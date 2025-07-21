#!/bin/bash

# @script add-file-metadata
# @purpose Add navigation metadata to first 20 lines of files
# @output console

# This script analyzes files and adds LLM-friendly metadata

analyze_typescript_file() {
    local file=$1
    local filename=$(basename "$file" .tsx | sed 's/\.ts$//')
    local filepath=${file#src/}
    
    echo "Analyzing: $file"
    
    # Extract imports to find dependencies
    deps=$(grep "^import" "$file" | grep -E "from ['\"]\./" | sed -E "s/.*from ['\"]\.\/([^'\"]+).*/\1/" | sort | uniq | tr '\n' ', ' | sed 's/,$//')
    
    # Find where this file is imported (simplified - would need better implementation)
    used_by=$(grep -r "from.*$filename" src/ --include="*.tsx" --include="*.ts" | cut -d: -f1 | xargs -I {} basename {} .tsx | sort | uniq | tr '\n' ', ' | sed 's/,$//')
    
    # Check for associated CSS
    css_file=$(grep "@cssFile" "$file" | sed 's/.*@cssFile //' | tr -d ' ' || echo "none")
    
    # Determine layer
    if [[ "$filepath" =~ ^components/ ]]; then
        layer="primitive"
    elif [[ "$filepath" =~ ^features/ ]]; then
        layer="feature"
    elif [[ "$filepath" =~ ^pages/ ]]; then
        layer="page"
    else
        layer="unknown"
    fi
    
    # Generate metadata
    cat << EOF
/**
 * @file $filepath
 * @purpose [TODO: Add purpose]
 * @layer $layer
 * @deps [$deps]
 * @used-by [$used_by]
 * @css $css_file
 */
EOF
}

# Example usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file>"
    echo "Example: $0 src/components/Button.tsx"
    exit 1
fi

analyze_typescript_file "$1"