#!/bin/bash

# @script metadata-migration
# @purpose Coordinate full metadata migration to universal format
# @output console

# Master script to migrate all files to universal metadata format

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Universal Metadata Migration${NC}"
echo "==============================="
echo ""

# Phase 1: Analysis
echo -e "${YELLOW}Phase 1: Analysis${NC}"
echo "-----------------"

# Count files
total_files=$(find src -name "*.tsx" -o -name "*.ts" | wc -l | tr -d ' ')
files_with_old_metadata=$(find src -name "*.tsx" -o -name "*.ts" | xargs grep -l "@layer\|@dependencies" 2>/dev/null | wc -l | tr -d ' ')
files_with_new_metadata=$(find src -name "*.tsx" -o -name "*.ts" | xargs grep -l "@file.*@llm-" 2>/dev/null | wc -l | tr -d ' ')
files_without_metadata=$((total_files - files_with_old_metadata - files_with_new_metadata))

echo "Total TypeScript/React files: $total_files"
echo "Files with old metadata: $files_with_old_metadata"
echo "Files with new metadata: $files_with_new_metadata"
echo "Files without metadata: $files_without_metadata"
echo ""

if [ "$1" = "--analyze" ]; then
    echo -e "${GREEN}Analysis complete!${NC}"
    exit 0
fi

# Phase 2: Migration Plan
echo -e "${YELLOW}Phase 2: Migration Plan${NC}"
echo "----------------------"
echo "1. Update files with existing metadata (preserves values)"
echo "2. Add metadata to files without any"
echo "3. Verify all files have universal format"
echo ""

if [ "$1" = "--dry-run" ]; then
    echo -e "${BLUE}DRY RUN - No changes will be made${NC}"
    echo ""
fi

# Ask for confirmation unless --force
if [ "$1" != "--force" ] && [ "$1" != "--dry-run" ]; then
    echo -e "${YELLOW}This will update $((files_with_old_metadata + files_without_metadata)) files.${NC}"
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Migration cancelled."
        exit 1
    fi
fi

# Phase 3: Update existing metadata
echo ""
echo -e "${YELLOW}Phase 3: Updating existing metadata${NC}"
echo "----------------------------------"

if [ "$1" != "--dry-run" ]; then
    ./design-system/scripts/update-metadata-smart.sh --update-all
else
    echo "Would update $files_with_old_metadata files with old metadata"
fi

# Phase 4: Add metadata to files without any
echo ""
echo -e "${YELLOW}Phase 4: Adding metadata to new files${NC}"
echo "------------------------------------"

if [ "$1" != "--dry-run" ]; then
    ./design-system/scripts/add-universal-metadata.sh --all
else
    echo "Would add metadata to $files_without_metadata files"
fi

# Phase 5: Verification
echo ""
echo -e "${YELLOW}Phase 5: Verification${NC}"
echo "--------------------"

# Re-count after migration
if [ "$1" != "--dry-run" ]; then
    new_total_with_metadata=$(find src -name "*.tsx" -o -name "*.ts" | xargs grep -l "@file.*@llm-" 2>/dev/null | wc -l | tr -d ' ')
    echo "Files with universal metadata: $new_total_with_metadata / $total_files"
    
    if [ "$new_total_with_metadata" -eq "$total_files" ]; then
        echo -e "${GREEN}✅ SUCCESS: All files now have universal metadata!${NC}"
    else
        missing=$((total_files - new_total_with_metadata))
        echo -e "${YELLOW}⚠️  WARNING: $missing files still missing metadata${NC}"
        echo "Run with --check-missing to see which files"
    fi
fi

# Phase 6: Report
if [ "$1" = "--check-missing" ]; then
    echo ""
    echo -e "${YELLOW}Files still missing universal metadata:${NC}"
    find src -name "*.tsx" -o -name "*.ts" | while read file; do
        if ! grep -q "@file.*@llm-" "$file" 2>/dev/null; then
            echo "  - $file"
        fi
    done
fi

echo ""
echo -e "${BLUE}Migration complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review changes with git diff"
echo "2. Test that components still work"
echo "3. Commit with message: 'Add universal metadata for LLM navigation'"