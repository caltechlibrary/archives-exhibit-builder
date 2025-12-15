#!/bin/bash
# Caltech Library Pandoc Exhibit Builder
# Usage: ./build.sh

set -euo pipefail
IFS=$'\n\t'

echo "Building all Markdown files in content/ ..."

# Create demo directory if it doesn't exist
mkdir -p demo

shopt -s nullglob
for input_path in content/*.md; do
  filename=$(basename "$input_path")
  basename="${filename%.md}"

  # Build demo files (demo-*.md) to demo/ directory
  if [[ "$filename" == demo-* ]]; then
    # Remove 'demo-' prefix from output filename
    output_filename="${basename#demo-}.html"
    output_path="demo/${output_filename}"
    echo "Building demo: $input_path -> $output_path"
  else
    # Build regular files to root
    output_path="${basename}.html"
    echo "Building $input_path -> $output_path"
  fi

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
