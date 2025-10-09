#!/bin/bash
# Caltech Library Pandoc Exhibit Builder
# Usage: ./build.sh

set -euo pipefail
IFS=$'\n\t'

echo "Building all Markdown files in content/ ..."

shopt -s nullglob
for input_path in content/*.md; do
  filename=$(basename "$input_path")
  basename="${filename%.md}"
  output_path="${basename}.html"
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
