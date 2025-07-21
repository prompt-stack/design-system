#!/bin/bash

# @script add-css-metadata
# @purpose Add universal metadata to CSS files
# @output console

add_metadata_to_css() {
    local file=$1
    local file_rel=${file#./}
    local filename=$(basename "$file" .css)
    
    # Skip if already has metadata
    if head -10 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Determine metadata based on location and name
    local purpose="Styles for ${filename}"
    local component="none"
    local layer="styles"
    local llm_write="full-edit"
    
    # Location-based metadata
    if [[ "$file" =~ styles/components/ ]]; then
        component="/src/components/${filename}.tsx"
        purpose="Component styles for ${filename}"
        layer="component-styles"
    elif [[ "$file" =~ styles/pages/ ]]; then
        component="/src/pages/${filename}.tsx"
        purpose="Page-specific styles for ${filename}"
        layer="page-styles"
        llm_write="suggest-only"
    elif [[ "$file" =~ styles/features/ ]]; then
        component="/src/features/${filename}/${filename}.tsx"
        purpose="Feature styles for ${filename}"
        layer="feature-styles"
    elif [[ "$filename" =~ globals|reset|normalize ]]; then
        purpose="Global CSS reset and base styles"
        layer="base-styles"
        llm_write="read-only"
    elif [[ "$filename" =~ variables|tokens ]]; then
        purpose="CSS variables and design tokens"
        layer="design-tokens"
        llm_write="suggest-only"
    fi
    
    # Find dependencies (other CSS imports)
    local deps=$(grep "@import" "$file" 2>/dev/null | \
        sed -E "s/.*['\"]([^'\"]+).*/\1/" | \
        sed 's/\.css$//' | \
        sort | uniq | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
    
    if [ -z "$deps" ]; then
        deps="none"
    else
        deps="[$deps]"
    fi
    
    # Create metadata header
    local metadata="/**
 * @file $file_rel
 * @purpose $purpose
 * @layer $layer
 * @component $component
 * @deps $deps
 * @llm-read true
 * @llm-write $llm_write
 * @llm-role pure-view
 */

"
    
    # Read current content
    local content=$(cat "$file")
    
    # Write metadata + content
    echo "$metadata$content" > "$file"
    
    echo "✅ Added metadata to: $file"
    echo "   Purpose: $purpose"
    echo "   Component: $component"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all CSS files ==="
        find . -name "*.css" -not -path "./node_modules/*" -not -path "./dist/*" | while read file; do
            add_metadata_to_css "$file"
        done
        ;;
        
    "--styles")
        echo "=== Adding metadata to src/styles CSS files ==="
        find ./src/styles -name "*.css" | while read file; do
            add_metadata_to_css "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_css "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--styles|--single <file>]"
        echo ""
        echo "Add universal metadata to CSS files"
        ;;
esac