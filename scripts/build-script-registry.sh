#!/bin/bash

# @script build-script-registry
# @purpose Generate JSON registry of all scripts from their metadata
# @output json

# This script scans all scripts and extracts their metadata to build a registry

SCRIPT_DIR="design-system/scripts"
OUTPUT_FILE="design-system/script-registry.json"

echo "{"
echo '  "generated": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
echo '  "scripts": {'

first=true

# Find all executable scripts
for script in "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/*.js "$SCRIPT_DIR"/*.cjs; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        # Extract metadata
        script_name=$(grep -m1 "@script" "$script" 2>/dev/null | sed 's/.*@script //' | tr -d '\r')
        purpose=$(grep -m1 "@purpose" "$script" 2>/dev/null | sed 's/.*@purpose //' | tr -d '\r')
        output=$(grep -m1 "@output" "$script" 2>/dev/null | sed 's/.*@output //' | tr -d '\r')
        
        if [ ! -z "$script_name" ]; then
            if [ "$first" = false ]; then
                echo ","
            fi
            first=false
            
            echo -n '    "'$script_name'": {'
            echo -n '"file": "'$(basename "$script")'"'
            
            if [ ! -z "$purpose" ]; then
                echo -n ', "purpose": "'$purpose'"'
            fi
            
            if [ ! -z "$output" ]; then
                # Convert output formats to array
                IFS='|' read -ra FORMATS <<< "$output"
                echo -n ', "output": ['
                first_format=true
                for format in "${FORMATS[@]}"; do
                    if [ "$first_format" = false ]; then
                        echo -n ", "
                    fi
                    first_format=false
                    echo -n '"'$format'"'
                done
                echo -n ']'
            fi
            
            echo -n '}'
        fi
    fi
done

echo ""
echo "  }"
echo "}"