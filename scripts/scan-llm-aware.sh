#!/bin/bash

# @script llm-aware-scan
# @purpose Demonstrate LLM-aware file scanning using directives
# @output json

# This script shows how an LLM would scan files respecting the directives

scan_file_metadata() {
    local file=$1
    local metadata=""
    
    # Extract first 20 lines
    local header=$(head -20 "$file" 2>/dev/null)
    
    # Extract LLM directives
    local llm_read=$(echo "$header" | grep "@llm-read" | sed 's/.*@llm-read //' | awk '{print $1}')
    local llm_write=$(echo "$header" | grep "@llm-write" | sed 's/.*@llm-write //' | awk '{print $1}')
    local llm_role=$(echo "$header" | grep "@llm-role" | sed 's/.*@llm-role //' | awk '{print $1}')
    
    # Extract other key metadata
    local purpose=$(echo "$header" | grep "@purpose" | sed 's/.*@purpose //')
    local deps=$(echo "$header" | grep "@deps" | sed 's/.*@deps //')
    local used_by=$(echo "$header" | grep "@used-by" | sed 's/.*@used-by //')
    
    # Build JSON object
    echo -n "{"
    echo -n "\"path\":\"$file\","
    echo -n "\"llm_read\":\"${llm_read:-true}\","
    echo -n "\"llm_write\":\"${llm_write:-unknown}\","
    echo -n "\"llm_role\":\"${llm_role:-unknown}\","
    echo -n "\"purpose\":\"${purpose:-unknown}\","
    echo -n "\"deps\":\"${deps:-[]}\","
    echo -n "\"used_by\":\"${used_by:-[]}\""
    echo -n "}"
}

# Simulate different LLM scanning scenarios
case "$1" in
    "editable")
        echo "=== Files LLM Can Edit ==="
        echo "["
        first=true
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            metadata=$(scan_file_metadata "$file")
            llm_write=$(echo "$metadata" | grep -o '"llm_write":"[^"]*"' | cut -d'"' -f4)
            if [ "$llm_write" = "full-edit" ]; then
                if [ "$first" = false ]; then echo ","; fi
                echo -n "  $metadata"
                first=false
            fi
        done
        echo ""
        echo "]"
        ;;
        
    "services")
        echo "=== Async Service Files ==="
        echo "["
        first=true
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            metadata=$(scan_file_metadata "$file")
            llm_role=$(echo "$metadata" | grep -o '"llm_role":"[^"]*"' | cut -d'"' -f4)
            if [ "$llm_role" = "async-service" ]; then
                if [ "$first" = false ]; then echo ","; fi
                echo -n "  $metadata"
                first=false
            fi
        done
        echo ""
        echo "]"
        ;;
        
    "readonly")
        echo "=== Read-Only Files (Require Caution) ==="
        echo "["
        first=true
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            metadata=$(scan_file_metadata "$file")
            llm_write=$(echo "$metadata" | grep -o '"llm_write":"[^"]*"' | cut -d'"' -f4)
            if [ "$llm_write" = "read-only" ] || [ "$llm_write" = "suggest-only" ]; then
                if [ "$first" = false ]; then echo ","; fi
                echo -n "  $metadata"
                first=false
            fi
        done
        echo ""
        echo "]"
        ;;
        
    "map")
        echo "=== Quick Codebase Map (First 5 Files) ==="
        echo "["
        count=0
        find src -name "*.tsx" -o -name "*.ts" | head -5 | while read file; do
            if [ $count -gt 0 ]; then echo ","; fi
            echo -n "  $(scan_file_metadata "$file")"
            count=$((count + 1))
        done
        echo ""
        echo "]"
        echo ""
        echo "Token usage: ~$(find src -name "*.tsx" -o -name "*.ts" | head -5 | wc -l | awk '{print $1 * 20}') tokens for 5 files"
        ;;
        
    *)
        echo "Usage: $0 [editable|services|readonly|map]"
        echo ""
        echo "Demonstrate LLM-aware file scanning:"
        echo "  editable  - Show files LLM can freely edit"
        echo "  services  - Show async service files"
        echo "  readonly  - Show protected files"
        echo "  map       - Quick codebase overview"
        ;;
esac