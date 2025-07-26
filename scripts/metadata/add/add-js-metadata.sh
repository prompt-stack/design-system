#!/bin/bash

# @script add-js-metadata
# @purpose Add universal metadata to JavaScript files
# @output console

add_metadata_to_js() {
    local file=$1
    local file_rel=${file#./}
    local filename=$(basename "$file" .js)
    
    # Skip if already has metadata
    if head -20 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Determine metadata based on location and name
    local purpose="[TODO: Add purpose]"
    local layer="utility"
    local llm_write="full-edit"
    local llm_role="utility"
    
    # Location-based metadata
    if [[ "$file" =~ server/ ]]; then
        layer="backend"
        llm_write="suggest-only"
        llm_role="async-service"
        purpose="Server-side ${filename} logic"
    elif [[ "$file" =~ config/ ]]; then
        layer="config"
        llm_write="read-only"
        llm_role="entrypoint"
        purpose="Configuration for ${filename}"
    elif [[ "$file" =~ content/blog/ ]]; then
        layer="content"
        llm_write="suggest-only"
        llm_role="pure-view"
        purpose="Blog content script: ${filename}"
    elif [[ "$file" =~ utils/ ]]; then
        layer="utility"
        purpose="Utility functions for ${filename}"
    elif [[ "$file" =~ middleware/ ]]; then
        layer="middleware"
        llm_write="read-only"
        llm_role="async-service"
        purpose="Middleware for request handling"
    fi
    
    # Find dependencies (simple import detection)
    local deps=$(grep -E "require\\(|import .* from" "$file" 2>/dev/null | \
        grep -v "node_modules" | \
        sed -E "s/.*['\"]\.\/([^'\"]+).*/\1/" | \
        sed 's/\.js$//' | \
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
 * @deps $deps
 * @llm-read true
 * @llm-write $llm_write
 * @llm-role $llm_role
 */

"
    
    # Read current content
    local content=$(cat "$file")
    
    # Write metadata + content
    echo "$metadata$content" > "$file"
    
    echo "✅ Added metadata to: $file"
    echo "   Layer: $layer"
    echo "   Purpose: $purpose"
    echo "   LLM: $llm_write / $llm_role"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all JavaScript files ==="
        find . -name "*.js" -not -path "./node_modules/*" -not -path "./dist/*" -not -path "./build/*" | while read file; do
            add_metadata_to_js "$file"
        done
        ;;
        
    "--config")
        echo "=== Adding metadata to config files ==="
        find ./config -name "*.js" | while read file; do
            add_metadata_to_js "$file"
        done
        ;;
        
    "--server")
        echo "=== Adding metadata to server files ==="
        find ./server -name "*.js" | while read file; do
            add_metadata_to_js "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_js "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--config|--server|--single <file>]"
        echo ""
        echo "Add universal metadata to JavaScript files"
        ;;
esac