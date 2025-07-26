#!/bin/bash

# @script fix-script-naming
# @purpose Rename scripts to follow {action}-{target}.sh convention
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Renaming map - define the mappings
RENAME_LIST=(
    "audit-css.sh:audit-css.sh"
    "update-metadata-batch.sh:update-metadata-batch.sh"
    "migrate-metadata.sh:migrate-metadata.sh"
    "check-llm-permissions.sh:check-llm-permissions.sh"
    "update-metadata-smart.sh:update-metadata-smart.sh"
    "scan-llm-aware.sh:scan-metadata.sh"
    "fix-script-naming.sh:rename-scripts.sh"
)

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
    echo -e "${YELLOW}DRY RUN MODE - No files will be renamed${NC}"
fi

echo -e "${BLUE}🔧 Fixing Script Naming Convention${NC}"
echo "===================================="
echo "Pattern: {action}-{target}.sh"
echo ""

RENAMED=0
FAILED=0

for mapping in "${RENAME_LIST[@]}"; do
    OLD_NAME="${mapping%%:*}"
    NEW_NAME="${mapping#*:}"
    OLD_PATH="grammar-ops/scripts/$OLD_NAME"
    NEW_PATH="grammar-ops/scripts/$NEW_NAME"
    
    if [ -f "$OLD_PATH" ]; then
        echo -e "${YELLOW}Found:${NC} $OLD_NAME"
        echo -e "${GREEN}  →${NC} $NEW_NAME"
        
        if [ "$DRY_RUN" = false ]; then
            # Check if target already exists
            if [ -f "$NEW_PATH" ]; then
                echo -e "${RED}  ✗ Target already exists!${NC}"
                FAILED=$((FAILED + 1))
                continue
            fi
            
            # Rename the file
            if mv "$OLD_PATH" "$NEW_PATH"; then
                echo -e "${GREEN}  ✓ Renamed successfully${NC}"
                RENAMED=$((RENAMED + 1))
                
                # Update any references in other scripts
                echo "  Updating references..."
                find . -name "*.sh" -o -name "*.md" | while read file; do
                    if grep -q "$OLD_NAME" "$file" 2>/dev/null; then
                        sed -i.bak "s/$OLD_NAME/$NEW_NAME/g" "$file" && rm -f "$file.bak"
                        echo "    Updated: $file"
                    fi
                done
            else
                echo -e "${RED}  ✗ Rename failed!${NC}"
                FAILED=$((FAILED + 1))
            fi
        else
            echo -e "${BLUE}  Would rename${NC}"
        fi
        echo ""
    fi
done

# Check for any remaining non-compliant scripts
echo -e "\n${BLUE}Checking for other non-compliant scripts...${NC}"
find grammar-ops/scripts -name "*.sh" | while read script; do
    filename=$(basename "$script")
    # Check if follows pattern: {action}-{target}.sh
    if ! echo "$filename" | grep -qE '^(audit|add|build|find|validate|update|generate|migrate|check|scan|fix)-[a-z-]+\.sh$'; then
        # Skip if it's one we just renamed
        skip=false
        for mapping in "${RENAME_LIST[@]}"; do
            NEW_NAME="${mapping#*:}"
            if [ "$filename" = "$NEW_NAME" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = false ]; then
            echo -e "${YELLOW}⚠ Non-compliant:${NC} $filename"
            # Suggest a name
            if [[ "$filename" =~ ^([a-z]+)-?([a-z-]+)\.sh$ ]]; then
                echo "  Suggestion: Consider renaming based on its purpose"
            fi
        fi
    fi
done

# Summary
echo -e "\n${BLUE}=== Summary ===${NC}"
if [ "$DRY_RUN" = false ]; then
    echo "Renamed: $RENAMED scripts"
    echo "Failed: $FAILED scripts"
    
    if [ $FAILED -eq 0 ] && [ $RENAMED -gt 0 ]; then
        echo -e "${GREEN}✅ All scripts renamed successfully!${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Test that renamed scripts still work"
        echo "2. Update any documentation"
        echo "3. Commit with message: 'Standardize script naming to {action}-{target} pattern'"
    fi
else
    echo "Run without --dry-run to apply changes"
fi