# Pandoc Template for Online Exhibits

This is a template repository that allows Caltech Archives & Special Collections to create exhibits hosted on GitHub Pages using Markdown. The template provides a consistent design system aligned with Caltech branding while allowing content creators to focus on writing exhibit content in an accessible, easy-to-use format.

## Technology

This template uses a static site generation approach that converts Markdown content into styled HTML pages:

- **Content Creation**: Exhibit content is written in Markdown (`.md` files), making it easy to write and maintain without HTML knowledge
- **Pandoc**: A universal document converter that transforms Markdown into HTML using a custom template
- **Lua Filter**: Custom image processing filter (`figures.lua`) that applies alignment and styling classes to images
- **YAML Configuration**: Structured configuration for menus and front matter metadata
- **Front Matter**: YAML metadata at the top of each Markdown file controls page-specific design and settings
- **Build Script**: Automated bash script (`build.sh`) that processes all content files

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

To generate HTML from your Markdown content:

```bash
./build.sh
```

This script will:
1. Clean and recreate the `_site/` directory
2. Copy static assets (CSS and images) to `_site/`
3. Process all `.md` files in the `content/` directory
4. Apply the Pandoc template and Lua filters
5. Generate HTML files in the `_site/` directory

All generated files are placed in the `_site/` directory, which is excluded from version control via `.gitignore`. This follows the Jekyll convention for static site generators.

## Launch and Deployment

This template uses a **two-stage publishing workflow**:

1. **Staging (GitHub Pages)** - Automatic preview site for reviewing changes
2. **Production (S3)** - Manual publish to the live site when ready

### Stage 1: Automatic Staging Deployment

Every time you push changes to the main branch, the site automatically deploys to GitHub Pages as a preview/staging site.

**Setup:**

1. **Enable GitHub Pages** in your repository:
   - Go to **Settings** → **Pages**
   - Under "Source", select **Deploy from a branch**
   - Choose the `gh-pages` branch and `/ (root)` folder
   - Click **Save**

2. **Push your changes** to the main branch - the workflow will automatically:
   - Install Pandoc
   - Run `./build.sh` to generate the `_site/` directory
   - Deploy the `_site/` directory contents to the `gh-pages` branch
   - Publish to GitHub Pages

3. **Preview your site** at `https://[your-org].github.io/[repository-name]/`

This staging site updates automatically with every commit, allowing you to review changes before publishing to production.

### Stage 2: Manual Production Deployment

When you're ready to publish your exhibit to the live production site, manually trigger the S3 publish workflow.

**How to Publish:**

1. Go to the **Actions** tab in your repository
2. Click on **"Publish to S3"** in the left sidebar
3. Click the **"Run workflow"** button
4. Click **"Run workflow"** to confirm

The workflow will:
- Sync the `gh-pages` branch to S3
- Create a CloudFront invalidation to update the CDN
- Display the live site URL

**Your exhibit will be live at:**
```
https://digital.archives.caltech.edu/exhibits/[repository-name]/
```

The repository name becomes the URL slug for your exhibit (e.g., repository `becoming-caltech` → `/exhibits/becoming-caltech/`).

### Custom Domain Setup

For a custom Caltech subdomain (e.g., `your-exhibit.archives.caltech.edu`), contact the Digital Library Development (DLD) team. They will assist with:

- Configuring DNS settings for your custom domain
- Setting up the custom domain in your GitHub Pages settings

**Contact**: Digital Library Development team for custom domain setup
