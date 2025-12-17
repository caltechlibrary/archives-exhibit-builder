# Overview

Archives Exhibit Builder is a template repository that enables Caltech Archives & Special Collections to create standalone online exhibits. The system allows the archives team to develop content in Markdown and host relevant images. When changes are committed to the main branch, the site automatically rebuilds and deploys to GitHub Pages as a preview. Once the exhibit is ready, a manual GitHub Action publishes the static files to S3, where the live site is hosted at a branded Caltech Library URL. The template provides a consistent design that aligns with the Caltech Library Design System while allowing content creators to focus on writing exhibit content in an accessible, easy-to-use format.

## Technology

This template uses a static site generation approach that converts Markdown content into styled HTML pages using a Pandoc template:

- **Content Creation**: Exhibit content is written in Markdown (`.md` files), making it easy to write and maintain without HTML knowledge
- **Pandoc**: A universal document converter that transforms Markdown into HTML using a custom template
- **Lua Filter**: Custom image processing filter (`figures.lua`) that applies alignment and styling classes to images
- **YAML Configuration**: Structured configuration for menus and front matter metadata
- **Front Matter**: YAML metadata at the top of each Markdown file controls page-specific design and settings
- **Build Script**: Automated bash script (`build.sh`) that processes all content files and outputs them to a `_site/` directory
- **GitHub Actions**: Two workflows manage deployment: `Preview Changes (automated)` automatically deploys to GitHub Pages for preview, `Publish Site (Manual)` manually publishes to S3 for production

## Building Your Menu with YAML

The site navigation menu is configured in `config/menu.yaml`. Each menu item requires two fields:

```yaml
menu:
  - title: "Home"
    url: "index.html"
  - title: "About"
    url: "about.html"
  - title: "Contact"
    url: "contact.html"
```

- **title**: Display text shown in the navigation menu
- **url**: Relative path to the page (typically the `.html` filename)

## Front Matter Configuration

Each Markdown content file begins with YAML front matter enclosed by `---` delimiters. This metadata controls the page's appearance and configuration:

```yaml
---
exhibit_title: "Title of the Exhibit"
exhibit_subtitle: "Subtitle of the Exhibit"
organization: "Caltech Archives & Special Collections"
feature_image: "feature.webp"
feature_color: "#000000"
feature_overlay: "#001F3F80"
---
```

### Available Front Matter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `exhibit_title` | Yes | Main heading displayed in the banner |
| `exhibit_subtitle` | No | Secondary heading displayed below the title |
| `organization` | Yes | Organization name (typically "Caltech Archives & Special Collections") |
| `feature_image` | No | Filename of the banner background image (stored in `/images/`) |
| `feature_color` | No | Hex color code for banner background (e.g., `#000000`) |
| `feature_overlay` | No | Hex color code with transparency for overlay effect (e.g., `#001F3F80`) |

## Image Styling

Images in Markdown can be styled using Pandoc's attribute syntax. The Lua filter processes these attributes and applies them to the generated HTML.

### Basic Image Syntax

```markdown
![Alt text description](/images/your-image.jpg){.class1 .class2}
```

### Alignment Classes

- **`.left`** - Floats image to the left with text wrapping around the right
- **`.right`** - Floats image to the right with text wrapping around the left
- **`.center`** - Centers the image as a block element with no text wrapping

### Size Classes

- **`.img-small`** - Maximum width of 300px
- **`.img-medium`** - Maximum width of 600px
- **`.img-large`** - Maximum width of 100% (full width)

### Additional Styling

- **`.frame`** - Adds a border and subtle shadow for a framed appearance

### Example Usage

```markdown
![Historical photograph of Throop Hall](/images/throop-hall.jpg){.img-medium .frame .left}

![Wide campus panorama](/images/campus-panorama.jpg){.img-large .center}

![Portrait of George Ellery Hale](/images/hale-portrait.jpg){.img-small .frame .right}
```

## Building Your Site

The build process is handled automatically by GitHub Actions. You don't need to run the build script manually. It will run everytime a commit is made to the main branch. However, if you want to build locally for testing you can run:

```bash
./build.sh
```

This script will:
1. Clean and recreate the `_site/` directory (temporary build location)
2. Copy static assets (CSS and images) to `_site/`
3. Process all `.md` files in the `content/` directory
4. Apply the Pandoc template and Lua filters
5. Generate HTML files in the `_site/` directory

The `_site/` directory is temporary and excluded from version control via `.gitignore`. GitHub Actions uses this directory to deploy files to the `gh-pages` branch (for preview) or S3 (for production).


## Launch and Deployment

This template uses a **two-stage publishing workflow**:

1. **Preview/staging (GitHub Pages)** - Automatic preview site to review changes before going live.
2. **Production (S3)** - Manual publish to the live site when ready

### Automated Preview Deployment

GitHub Pages will be automatically configured the first time you commit a change to the main branch. The workflow will:

1. Build your site
2. Create a `gh-pages` branch (if it doesn't exist)
3. Deploy your site to GitHub Pages

After your first commit, wait 1-2 minutes, then visit your preview URL:
`https://caltechlibrary.github.io/your-repo-name/`

(Replace `your-repo-name` with your actual repository name)


### Manual Production Deployment

When you're ready to publish your exhibit to the live production site, manually trigger the S3 publish workflow.

**How to Publish:**

1. Go to the **Actions** tab in your repository
2. Click on **Publish Site (Manual)** in the left sidebar
3. Click the **"Run workflow"** button
4. Click **"Run workflow"** to confirm (main branch should be selected)

The workflow will:
- Sync the `gh-pages` branch to S3
- Create a CloudFront invalidation to update the CDN
- Display the live site URL

**Your exhibit will be live at:**
```
https://digital.archives.caltech.edu/exhibits/[repository-name]/
```

The repository name becomes the URL slug for your exhibit (e.g., repository `becoming-caltech` → `/exhibits/becoming-caltech/`).
