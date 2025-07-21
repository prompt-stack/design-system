#!/bin/bash

# @script smart-metadata-update
# @purpose Intelligently update existing metadata to universal standard
# @output console

# This script handles files that already have some metadata

update_existing_metadata() {
    local file=$1
    local file_rel=${file#src/}
    local filename=$(basename "$file" .tsx | sed 's/\.ts$//')
    
    # Read first 30 lines to capture existing metadata
    local header=$(head -30 "$file")
    
    # Check if has old-style metadata
    if echo "$header" | grep -q "@layer\|@dependencies\|@cssFile" 2>/dev/null; then
        echo "📝 Updating existing metadata: $file"
        
        # Extract existing values
        local existing_layer=$(echo "$header" | grep "@layer" | sed 's/.*@layer //' | awk '{print $1}')
        local existing_deps=$(echo "$header" | grep "@dependencies" | sed 's/.*@dependencies //')
        local existing_css=$(echo "$header" | grep "@cssFile" | sed 's/.*@cssFile //' | tr -d ' ')
        local existing_desc=$(echo "$header" | grep "@description" | sed 's/.*@description //')
        local existing_status=$(echo "$header" | grep "@status" | sed 's/.*@status //' | awk '{print $1}')
        
        # Determine new values
        local llm_write="full-edit"
        local llm_role="utility"
        
        if [[ "$file" =~ src/pages/ ]]; then
            llm_write="suggest-only"
            llm_role="entrypoint"
        elif [[ "$file" =~ src/api/ ]] || [[ "$file" =~ src/services/ ]]; then
            llm_write="read-only"
            llm_role="async-service"
        fi
        
        # Find used-by
        local used_by=$(grep -r "import.*$filename" src/ --include="*.tsx" --include="*.ts" 2>/dev/null | \
            grep -v "$file:" | \
            cut -d: -f1 | \
            xargs -I {} basename {} .tsx | \
            sed 's/\.ts$//' | \
            sort | uniq | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
        
        if [ -z "$used_by" ]; then
            used_by="none"
        else
            used_by="[$used_by]"
        fi
        
        # Build new metadata
        local new_metadata="/**
 * @file $file_rel
 * @purpose ${existing_desc:-Component for $filename}
 * @layer ${existing_layer:-unknown}
 * @deps ${existing_deps:-none}
 * @used-by $used_by
 * @css ${existing_css:-none}"
        
        # Add status if it existed
        if [ ! -z "$existing_status" ]; then
            new_metadata="$new_metadata
 * @status $existing_status"
        fi
        
        # Add LLM directives
        new_metadata="$new_metadata
 * @llm-read true
 * @llm-write $llm_write
 * @llm-role $llm_role"
        
        # Close comment
        new_metadata="$new_metadata
 */"
        
        # Find where old metadata ends (look for */ on its own line)
        local metadata_end_line=$(echo "$header" | grep -n "^\s*\*/$" | head -1 | cut -d: -f1)
        
        if [ ! -z "$metadata_end_line" ]; then
            # Get content after metadata
            local content=$(tail -n +$((metadata_end_line + 1)) "$file")
            
            # Write new metadata + content
            echo "$new_metadata" > "$file"
            echo "$content" >> "$file"
            
            echo "   ✅ Updated to universal format"
            return 0
        else
            echo "   ⚠️  Could not find metadata end marker"
            return 1
        fi
    else
        echo "⏭️  No existing metadata: $file"
        return 2
    fi
}

# Process based on arguments
case "$1" in
    "--check")
        echo "=== Files with existing metadata to update ==="
        count=0
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            if head -20 "$file" | grep -q "@layer\|@dependencies\|@cssFile" 2>/dev/null; then
                if ! head -20 "$file" | grep -q "@file" 2>/dev/null; then
                    echo "$file"
                    count=$((count + 1))
                fi
            fi
        done
        ;;
        
    "--update-all")
        echo "=== Updating all files with existing metadata ==="
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            update_existing_metadata "$file"
        done
        ;;
        
    "--update-components")
        echo "=== Updating components with existing metadata ==="
        find src/components -name "*.tsx" | while read file; do
            update_existing_metadata "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        update_existing_metadata "$2"
        ;;
        
    *)
        echo "Usage: $0 [--check|--update-all|--update-components|--single <file>]"
        echo ""
        echo "Update existing metadata to universal format"
        echo ""
        echo "Options:"
        echo "  --check             List files with old metadata format"
        echo "  --update-all        Update all files with old metadata"
        echo "  --update-components Update component files only"
        echo "  --single           Update a single file"
        echo ""
        echo "This script preserves existing metadata values while adding:"
        echo "  - @file path"
        echo "  - @purpose (from @description)"
        echo "  - @used-by (calculated)"
        echo "  - @llm-* directives"
        ;;
esac