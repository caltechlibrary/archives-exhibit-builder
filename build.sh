#!/bin/bash
# Caltech Library Pandoc Exhibit Builder
# Usage: ./build.sh

set -euo pipefail
IFS=$'\n\t'

echo "Building all Markdown files in content/ ..."

# Clean & recreate _site/ directory
rm -rf "_site"
mkdir -p "_site/styles"
mkdir -p "_site/images"

# Copy static assets
echo "Copying static assets..."
cp styles/style.css "_site/styles/"
cp -r images/* "_site/images/"

# Build all Markdown files to _site/ root
shopt -s nullglob
for input_path in content/*.md; do
  filename=$(basename "$input_path")
  basename="${filename%.md}"

  # Remove 'demo-' prefix if present
  output_filename="${basename#demo-}.html"
  output_path="_site/${output_filename}"

  echo "Building $input_path -> $output_path"

  pandoc "$input_path" \
    --lua-filter="figures.lua" \
    --template="templates/exhibit_template.html" \
    --metadata-file="config/menu.yaml" \
    --standalone \
    --toc --toc-depth=2 \
    --wrap=auto \
    -o "$output_path"

  echo "Built $output_path"
done

echo "All Markdown files built successfully!"
echo "_site/ directory ready for deployment"
