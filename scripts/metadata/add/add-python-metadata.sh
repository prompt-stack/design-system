#!/bin/bash

# @script add-python-metadata
# @purpose Add universal metadata to Python files
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility

add_metadata_to_python() {
    local file=$1
    local file_rel=${file#./}
    local filename=$(basename "$file" .py)
    
    # Skip if already has metadata
    if head -10 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Skip __pycache__ and generated files
    if [[ "$file" =~ __pycache__ ]] || [[ "$file" =~ \.generated\.py$ ]]; then
        return
    fi
    
    # Determine metadata based on location and name
    local purpose="Python module: ${filename//_/ }"
    local layer="utility"
    local llm_write="full-edit"
    local llm_role="utility"
    
    # Location-based metadata
    if [[ "$file" =~ automation/ ]]; then
        layer="automation"
        purpose="Automation script for ${filename//_/ }"
    elif [[ "$file" =~ web_app/ ]]; then
        layer="web"
        if [[ "$file" =~ routes/ ]]; then
            purpose="API routes for ${filename//_/ }"
            llm_role="entrypoint"
        elif [[ "$file" =~ services/ ]]; then
            purpose="Service layer for ${filename//_/ }"
            llm_role="async-service"
        elif [[ "$file" =~ models/ ]]; then
            purpose="Data model for ${filename//_/ }"
            llm_write="suggest-only"
        fi
    elif [[ "$file" =~ ml/ ]] || [[ "$file" =~ machine_learning/ ]]; then
        layer="ml"
        purpose="Machine learning: ${filename//_/ }"
        llm_write="suggest-only"
    elif [[ "$file" =~ tests/ ]] || [[ "$filename" =~ ^test_ ]]; then
        layer="test"
        purpose="Test suite for ${filename#test_}"
        llm_role="test"
    elif [[ "$file" =~ scripts/ ]] || [[ "$file" =~ tools/ ]]; then
        layer="cli"
        purpose="CLI tool: ${filename//_/ }"
        llm_role="entrypoint"
    elif [[ "$file" =~ migrations/ ]]; then
        layer="database"
        purpose="Database migration"
        llm_write="read-only"
    fi
    
    # Find imports (simplified)
    local deps=$(grep -E "^(import |from )" "$file" 2>/dev/null | \
        grep -v "__future__" | \
        awk '{print $2}' | \
        grep -v "^\\." | \
        sort | uniq | head -5 | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
    
    if [ -z "$deps" ]; then
        deps="none"
    else
        deps="[$deps]"
    fi
    
    # Check if it's a script with shebang
    local has_shebang=false
    if head -1 "$file" | grep -q "^#!"; then
        has_shebang=true
    fi
    
    # Create metadata docstring
    local metadata='"""
@file '"$file_rel"'
@purpose '"$purpose"'
@layer '"$layer"'
@deps '"$deps"'
@llm-read true
@llm-write '"$llm_write"'
@llm-role '"$llm_role"'
"""'
    
    # Handle shebang if present
    if [ "$has_shebang" = true ]; then
        local shebang=$(head -1 "$file")
        local content=$(tail -n +2 "$file")
        
        echo "$shebang" > "$file"
        echo "" >> "$file"
        echo "$metadata" >> "$file"
        echo "" >> "$file"
        echo "$content" >> "$file"
    else
        local content=$(cat "$file")
        echo "$metadata" > "$file"
        echo "" >> "$file"
        echo "$content" >> "$file"
    fi
    
    echo "✅ Added metadata to: $file"
    echo "   Layer: $layer"
    echo "   Purpose: $purpose"
    echo "   LLM: $llm_write / $llm_role"
}

# Process files
case "$1" in
    "--all")
        echo "=== Adding metadata to all Python files ==="
        find . -name "*.py" -type f -not -path "./venv/*" -not -path "./.venv/*" -not -path "./node_modules/*" -not -path "./__pycache__/*" | while read file; do
            add_metadata_to_python "$file"
        done
        ;;
        
    "--automation")
        echo "=== Adding metadata to automation scripts ==="
        find ./automation -name "*.py" -type f 2>/dev/null | while read file; do
            add_metadata_to_python "$file"
        done
        ;;
        
    "--ml")
        echo "=== Adding metadata to ML scripts ==="
        find ./ml -name "*.py" -type f 2>/dev/null | while read file; do
            add_metadata_to_python "$file"
        done
        ;;
        
    "--web")
        echo "=== Adding metadata to web app files ==="
        find ./web_app -name "*.py" -type f 2>/dev/null | while read file; do
            add_metadata_to_python "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_python "$2"
        ;;
        
    *)
        echo "Usage: $0 [--all|--automation|--ml|--web|--single <file>]"
        echo ""
        echo "Add universal metadata to Python files"
        echo ""
        echo "Options:"
        echo "  --all         Add to all Python files"
        echo "  --automation  Add to automation/ directory"
        echo "  --ml          Add to ml/ directory"
        echo "  --web         Add to web_app/ directory"
        echo "  --single      Add to a single file"
        ;;
esac