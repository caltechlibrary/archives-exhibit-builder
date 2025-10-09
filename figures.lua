-- figures.lua
-- Move alignment classes (left/right/center) from nested Image to the enclosing Figure for HTML output.
-- Works with Pandoc 3.x Figure nodes and falls back to Para->Image for older versions.

function Figure(fig)
  if not FORMAT:match('html') then return nil end

  local align = nil

  -- Handler to strip alignment class off any Image and remember it
  local function image_handler(img)
    local classes = (img.attr and img.attr.classes) or {}
    if classes and #classes > 0 then
      local kept = {}
      for _, c in ipairs(classes) do
        if (c == 'left' or c == 'right' or c == 'center') and not align then
          align = c
        else
          table.insert(kept, c)
        end
      end
      if img.attr then
        img.attr.classes = kept
      end
    end
    return img
  end

  -- Walk the figure to process any nested Images
  fig = pandoc.walk_block(fig, { Image = image_handler })

  -- Ensure figure has classes table
  fig.attr = fig.attr or pandoc.Attr()
  fig.attr.classes = fig.attr.classes or {}

  -- Add alignment class to the Figure if one was found
  if align then
    table.insert(fig.attr.classes, align)
  end

  return fig
end

-- Fallback for older Pandoc that may not produce Figure nodes
function Para(el)
  if not FORMAT:match('html') then return nil end
  if #el.content ~= 1 or el.content[1].t ~= 'Image' then return nil end

  local img = el.content[1]
  local classes = (img.attr and img.attr.classes) or {}
  local align = nil
  local kept = {}

  for _, c in ipairs(classes) do
    if (c == 'left' or c == 'right' or c == 'center') and not align then
      align = c
    else
      table.insert(kept, c)
    end
  end

  if not align then return nil end

  local src = img.src or img.target or ''
  local alt = pandoc.utils.stringify(img.caption or {})
  local cls = table.concat(kept, ' ')
  local class_attr = (#cls > 0) and (' class="'..cls..'"') or ''

  local html = '<figure class="'..align..'">'
    .. '<img src="'..src..'" alt="'..alt..'"'..class_attr..'>'
  if alt ~= '' then
    html = html .. '<figcaption>'..alt..'</figcaption>'
  end
  html = html .. '</figure>'

  return pandoc.RawBlock('html', html)
end