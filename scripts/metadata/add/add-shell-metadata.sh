#!/bin/bash

# @script add-shell-metadata
# @purpose Add universal metadata to shell scripts
# @output console

add_metadata_to_shell() {
    local file=$1
    local filename=$(basename "$file")
    
    # Skip if already has metadata
    if head -10 "$file" | grep -q "@script\|@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Extract script name from filename
    local script_name=${filename%.sh}
    
    # Determine purpose from script name
    local purpose="[TODO: Add purpose]"
    case "$script_name" in
        audit-*)
            purpose="Audit ${script_name#audit-} for compliance"
            ;;
        add-*)
            purpose="Add ${script_name#add-} to files"
            ;;
        build-*)
            purpose="Build ${script_name#build-}"
            ;;
        find-*)
            purpose="Find ${script_name#find-} in codebase"
            ;;
        *)
            purpose="Script for $script_name operations"
            ;;
    esac
    
    # Determine LLM permissions
    local llm_write="full-edit"
    local llm_role="utility"
    
    # Create metadata header
    local metadata="#!/bin/bash

# @script $script_name
# @purpose $purpose
# @output console
# @llm-read true
# @llm-write $llm_write
# @llm-role $llm_role
"
    
    # Read the current content (skip shebang if exists)
    local content
    if head -1 "$file" | grep -q "^#!/bin/bash"; then
        content=$(tail -n +2 "$file")
    else
        content=$(cat "$file")
    fi
    
    # Write metadata + content back
    echo "$metadata" > "$file"
    echo "$content" >> "$file"
    
    echo "✅ Added metadata to: $file"
    echo "   Purpose: $purpose"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all shell scripts ==="
        find . -name "*.sh" -not -path "./node_modules/*" | while read file; do
            add_metadata_to_shell "$file"
        done
        ;;
        
    "--design-system")
        echo "=== Adding metadata to design-system scripts ==="
        find grammar-ops/scripts -name "*.sh" | while read file; do
            add_metadata_to_shell "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_shell "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--design-system|--single <file>]"
        echo ""
        echo "Add universal metadata to shell scripts"
        ;;
esac