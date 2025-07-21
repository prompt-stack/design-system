#!/bin/bash

# @script add-module-metadata
# @purpose Add universal metadata to CommonJS and ES Module files
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility

add_metadata_to_module() {
    local file=$1
    local file_rel=${file#./}
    local filename=$(basename "$file")
    local ext="${filename##*.}"
    
    # Skip if already has metadata
    if head -20 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Determine metadata based on extension and location
    local module_type="CommonJS"
    if [ "$ext" = "mjs" ]; then
        module_type="ES Module"
    fi
    
    local purpose="$module_type file: ${filename%.*}"
    local layer="utility"
    local llm_write="full-edit"
    local llm_role="utility"
    
    # Adjust based on location
    if [[ "$file" =~ node_modules ]]; then
        return # Skip node_modules
    elif [[ "$file" =~ config/ ]]; then
        layer="config"
        llm_write="read-only"
        purpose="Configuration module: ${filename%.*}"
    elif [[ "$file" =~ scripts/ ]]; then
        layer="tooling"
        purpose="Build/tool script: ${filename%.*}"
    fi
    
    # Find dependencies
    local deps=$(grep -E "require\\(|import .* from" "$file" 2>/dev/null | \
        grep -v "node_modules" | \
        sed -E "s/.*['\"]([^'\"]+)['\"].*/\1/" | \
        grep -v "^[./]" | \
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
 * @module-type $module_type
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
    echo "   Type: $module_type"
    echo "   Purpose: $purpose"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all CJS/MJS files ==="
        find . \( -name "*.cjs" -o -name "*.mjs" \) -not -path "./node_modules/*" | while read file; do
            add_metadata_to_module "$file"
        done
        ;;
        
    "--cjs")
        echo "=== Adding metadata to CommonJS files ==="
        find . -name "*.cjs" -not -path "./node_modules/*" | while read file; do
            add_metadata_to_module "$file"
        done
        ;;
        
    "--mjs")
        echo "=== Adding metadata to ES Module files ==="
        find . -name "*.mjs" -not -path "./node_modules/*" | while read file; do
            add_metadata_to_module "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_module "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--cjs|--mjs|--single <file>]"
        echo ""
        echo "Add universal metadata to CommonJS (.cjs) and ES Module (.mjs) files"
        ;;
esac