#!/bin/bash

# @script add-html-metadata
# @purpose Add universal metadata to HTML files
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility

add_metadata_to_html() {
    local file=$1
    local file_rel=${file#./}
    local filename=$(basename "$file" .html)
    
    # Skip if already has metadata
    if head -10 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Determine metadata
    local purpose="HTML document for ${filename}"
    local llm_write="suggest-only"
    local llm_role="entrypoint"
    
    if [[ "$filename" = "index" ]]; then
        purpose="Main application entry point"
        llm_write="read-only"
    fi
    
    # Create metadata comment
    local metadata="<!--
  @file $file_rel
  @purpose $purpose
  @layer presentation
  @llm-read true
  @llm-write $llm_write
  @llm-role $llm_role
-->"
    
    # Insert after <!DOCTYPE> if exists, otherwise at start
    if grep -q "<!DOCTYPE" "$file"; then
        # Insert after DOCTYPE
        awk -v meta="$metadata" '/<!DOCTYPE/ {print; print meta; next} {print}' "$file" > "$file.tmp"
    else
        # Insert at beginning
        echo "$metadata" > "$file.tmp"
        cat "$file" >> "$file.tmp"
    fi
    
    mv "$file.tmp" "$file"
    
    echo "✅ Added metadata to: $file"
    echo "   Purpose: $purpose"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all HTML files ==="
        find . -name "*.html" -not -path "./node_modules/*" -not -path "./dist/*" | while read file; do
            add_metadata_to_html "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_html "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--single <file>]"
        echo ""
        echo "Add universal metadata to HTML files"
        ;;
esac