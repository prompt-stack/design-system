#!/bin/bash

# @script add-universal-metadata
# @purpose Add complete universal metadata to all files
# @output console

# Script to add full metadata headers to files that need them

add_metadata_to_file() {
    local file=$1
    local file_rel=${file#src/}
    local filename=$(basename "$file" .tsx | sed 's/\.ts$//')
    
    # Skip if already has @file metadata
    if head -20 "$file" | grep -q "@file" 2>/dev/null; then
        echo "✓ Already has metadata: $file"
        return
    fi
    
    # Determine metadata based on file type and location
    local layer=""
    local purpose=""
    local llm_write=""
    local llm_role=""
    
    # Layer detection
    if [[ "$file" =~ src/components/ ]]; then
        layer="primitive"
        llm_write="full-edit"
        llm_role="utility"
    elif [[ "$file" =~ src/features/ ]]; then
        layer="feature"
        llm_write="full-edit"
        llm_role="utility"
    elif [[ "$file" =~ src/pages/ ]]; then
        layer="page"
        llm_write="suggest-only"
        llm_role="entrypoint"
    elif [[ "$file" =~ src/hooks/ ]]; then
        layer="hook"
        llm_write="full-edit"
        llm_role="utility"
    elif [[ "$file" =~ src/api/ ]] || [[ "$file" =~ src/services/ ]]; then
        layer="service"
        llm_write="read-only"
        llm_role="async-service"
    elif [[ "$file" =~ src/utils/ ]]; then
        layer="utility"
        llm_write="full-edit"
        llm_role="utility"
    else
        layer="unknown"
        llm_write="suggest-only"
        llm_role="utility"
    fi
    
    # Extract imports to find dependencies
    local deps=$(grep "^import" "$file" 2>/dev/null | \
        grep -E "from ['\"]\./" | \
        sed -E "s/.*from ['\"]\.\/([^'\"]+).*/\1/" | \
        sed 's/\.tsx$//' | sed 's/\.ts$//' | \
        sort | uniq | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
    
    if [ -z "$deps" ]; then
        deps="none"
    else
        deps="[$deps]"
    fi
    
    # Find where this component is used
    local component_name=$(basename "$file" .tsx | sed 's/\.ts$//')
    local used_by=$(grep -r "import.*$component_name" src/ --include="*.tsx" --include="*.ts" 2>/dev/null | \
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
    
    # Check for CSS file
    local css_file="none"
    local potential_css="/src/styles/components/${filename}.css"
    local potential_css2="/src/styles/features/${filename}.css"
    local potential_css3="/src/styles/pages/${filename}.css"
    
    if [ -f ".$potential_css" ]; then
        css_file="$potential_css"
    elif [ -f ".$potential_css2" ]; then
        css_file="$potential_css2"
    elif [ -f ".$potential_css3" ]; then
        css_file="$potential_css3"
    fi
    
    # Generate purpose based on file name and type
    case "$filename" in
        *Service|*Api)
            purpose="Handle ${filename%Service} operations and data"
            ;;
        *Page)
            purpose="${filename%Page} page component"
            ;;
        *Modal|*Dialog)
            purpose="Modal dialog for ${filename%Modal}"
            ;;
        *List|*Table)
            purpose="Display list/table of items"
            ;;
        use*)
            purpose="Hook for ${filename#use} management"
            ;;
        *)
            purpose="[TODO: Add purpose]"
            ;;
    esac
    
    # Create the metadata header
    local metadata="/**
 * @file $file_rel
 * @purpose $purpose
 * @layer $layer
 * @deps $deps
 * @used-by $used_by
 * @css $css_file
 * @llm-read true
 * @llm-write $llm_write
 * @llm-role $llm_role
 */

"
    
    # Read the current file content
    local content=$(cat "$file")
    
    # Write metadata + content back
    echo "$metadata$content" > "$file"
    
    echo "✅ Added metadata to: $file"
    echo "   Layer: $layer"
    echo "   Purpose: $purpose"
    echo "   Dependencies: $deps"
    echo "   Used by: $used_by"
    echo "   LLM permissions: $llm_write / $llm_role"
    echo ""
}

# Process based on arguments
case "$1" in
    "--dry-run")
        echo "=== Dry Run: Files that need metadata ==="
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            if ! head -20 "$file" | grep -q "@file" 2>/dev/null; then
                echo "Would update: $file"
            fi
        done
        ;;
        
    "--components")
        echo "=== Adding metadata to components ==="
        find src/components -name "*.tsx" | while read file; do
            add_metadata_to_file "$file"
        done
        ;;
        
    "--features")
        echo "=== Adding metadata to features ==="
        find src/features -name "*.tsx" -o -name "*.ts" | while read file; do
            add_metadata_to_file "$file"
        done
        ;;
        
    "--pages")
        echo "=== Adding metadata to pages ==="
        find src/pages -name "*.tsx" | while read file; do
            add_metadata_to_file "$file"
        done
        ;;
        
    "--all")
        echo "=== Adding metadata to all files ==="
        find src -name "*.tsx" -o -name "*.ts" | while read file; do
            add_metadata_to_file "$file"
        done
        ;;
        
    "--single")
        if [ -z "$2" ]; then
            echo "Error: Please provide a file path"
            exit 1
        fi
        add_metadata_to_file "$2"
        ;;
        
    *)
        echo "Usage: $0 [--dry-run|--components|--features|--pages|--all|--single <file>]"
        echo ""
        echo "Add universal metadata headers to TypeScript/React files"
        echo ""
        echo "Options:"
        echo "  --dry-run     Show files that would be updated"
        echo "  --components  Update only component files"
        echo "  --features    Update only feature files"
        echo "  --pages       Update only page files"
        echo "  --all         Update all files"
        echo "  --single      Update a single file"
        echo ""
        echo "Example:"
        echo "  $0 --dry-run"
        echo "  $0 --components"
        echo "  $0 --single src/components/Card.tsx"
        ;;
esac