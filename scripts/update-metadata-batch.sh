#!/bin/bash

# @script batch-metadata-update
# @purpose Safely update metadata in batches with verification
# @output console

# Safe batch processing of metadata updates

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

process_batch() {
    local batch_name=$1
    local file_pattern=$2
    
    echo -e "${BLUE}Processing: $batch_name${NC}"
    echo "================================"
    
    # Count files
    local count=$(find src -path "$file_pattern" | wc -l | tr -d ' ')
    echo "Found $count files"
    
    if [ "$count" -eq 0 ]; then
        echo "No files found matching pattern"
        return
    fi
    
    # Process each file
    local success=0
    local failed=0
    
    find src -path "$file_pattern" | while read file; do
        echo -n "Processing $(basename $file)... "
        
        # Check if already has new format
        if grep -q "@file.*@llm-" "$file" 2>/dev/null; then
            echo -e "${GREEN}✓ Already updated${NC}"
            continue
        fi
        
        # Check if has old metadata
        if grep -q "@layer\|@dependencies" "$file" 2>/dev/null; then
            # Use smart update
            if ./grammar-ops/scripts/update-metadata-smart.sh --single "$file" > /dev/null 2>&1; then
                echo -e "${GREEN}✓ Updated existing metadata${NC}"
                success=$((success + 1))
            else
                echo -e "${RED}✗ Failed to update${NC}"
                failed=$((failed + 1))
            fi
        else
            # Use add metadata
            if ./grammar-ops/scripts/add-universal-metadata.sh --single "$file" > /dev/null 2>&1; then
                echo -e "${GREEN}✓ Added new metadata${NC}"
                success=$((success + 1))
            else
                echo -e "${RED}✗ Failed to add${NC}"
                failed=$((failed + 1))
            fi
        fi
    done
    
    echo ""
    echo "Summary: $success successful, $failed failed"
    echo ""
}

# Main execution
case "$1" in
    "components")
        process_batch "Components" "src/components/*.tsx"
        ;;
        
    "features")
        process_batch "Features" "src/features/**/*.tsx"
        process_batch "Feature TypeScript" "src/features/**/*.ts"
        ;;
        
    "pages")
        process_batch "Pages" "src/pages/*.tsx"
        ;;
        
    "hooks")
        process_batch "Hooks" "src/hooks/*.ts"
        ;;
        
    "playground")
        process_batch "Playground Components" "src/playground/components/*.tsx"
        process_batch "Playground Utils" "src/playground/utils/*.ts"
        ;;
        
    "layout")
        process_batch "Layout Components" "src/layout/*.tsx"
        ;;
        
    "test")
        # Test with just 3 files
        echo -e "${YELLOW}TEST MODE: Processing only 3 files${NC}"
        find src/components -name "*.tsx" | head -3 | while read file; do
            echo "Testing on: $file"
            if grep -q "@file.*@llm-" "$file" 2>/dev/null; then
                echo "  Already has universal metadata"
            else
                ./grammar-ops/scripts/update-metadata-smart.sh --single "$file"
            fi
        done
        ;;
        
    "status")
        echo -e "${BLUE}Metadata Update Status${NC}"
        echo "====================="
        echo ""
        
        for dir in components features pages hooks playground layout; do
            total=$(find src/$dir -name "*.tsx" -o -name "*.ts" 2>/dev/null | wc -l | tr -d ' ')
            updated=$(find src/$dir -name "*.tsx" -o -name "*.ts" 2>/dev/null | xargs grep -l "@file.*@llm-" 2>/dev/null | wc -l | tr -d ' ')
            
            if [ "$total" -gt 0 ]; then
                percent=$((updated * 100 / total))
                printf "%-15s: %3d/%3d (%3d%%)" "$dir" "$updated" "$total" "$percent"
                
                if [ "$percent" -eq 100 ]; then
                    echo -e " ${GREEN}✓${NC}"
                elif [ "$percent" -gt 50 ]; then
                    echo -e " ${YELLOW}◐${NC}"
                else
                    echo -e " ${RED}○${NC}"
                fi
            fi
        done
        ;;
        
    *)
        echo "Usage: $0 [components|features|pages|hooks|playground|layout|test|status]"
        echo ""
        echo "Batch update metadata by directory:"
        echo "  components  - Update all component files"
        echo "  features    - Update all feature files"
        echo "  pages       - Update all page files"
        echo "  hooks       - Update all hook files"
        echo "  playground  - Update playground files"
        echo "  layout      - Update layout files"
        echo "  test        - Test with 3 files only"
        echo "  status      - Show current update status"
        echo ""
        echo "Example workflow:"
        echo "  $0 test       # Test with 3 files"
        echo "  $0 status     # Check current status"
        echo "  $0 components # Update all components"
        ;;
esac