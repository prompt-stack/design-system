#!/bin/bash

# @script find-orphan-styles
# @purpose Find orphan-styles in codebase
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# Find Orphan Styles Script
# Identifies CSS files that aren't imported anywhere and unused CSS classes

echo "🔍 Finding Orphan CSS Files and Unused Styles"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ORPHAN_COUNT=0
TOTAL_CSS_FILES=0

# Arrays to store results
declare -a ORPHAN_FILES
declare -a IMPORTED_FILES

echo -e "\n${BLUE}📁 Step 1: Finding all CSS files...${NC}"

# Find all CSS files
CSS_FILES=$(find src/styles -name "*.css" -type f | sort)

for css_file in $CSS_FILES; do
    TOTAL_CSS_FILES=$((TOTAL_CSS_FILES + 1))
    filename=$(basename "$css_file")
    
    # Skip globals.css as it's always imported
    if [ "$filename" = "globals.css" ]; then
        continue
    fi
    
    # Check if file is imported anywhere
    # Look in index.css, component files, or other CSS files
    if grep -r "$filename" src/ --include="*.css" --include="*.tsx" --include="*.ts" --include="*.js" --include="index.html" > /dev/null 2>&1; then
        IMPORTED_FILES+=("$css_file")
    else
        # Also check without extension
        basename_no_ext="${filename%.css}"
        if grep -r "$basename_no_ext" src/ --include="*.css" --include="*.tsx" --include="*.ts" --include="*.js" > /dev/null 2>&1; then
            IMPORTED_FILES+=("$css_file")
        else
            ORPHAN_FILES+=("$css_file")
            ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
        fi
    fi
done

echo -e "\n${BLUE}📊 CSS Import Analysis:${NC}"
echo "Total CSS files: $TOTAL_CSS_FILES"
echo "Imported files: ${#IMPORTED_FILES[@]}"
echo "Orphan files: $ORPHAN_COUNT"

if [ $ORPHAN_COUNT -gt 0 ]; then
    echo -e "\n${RED}❌ Orphan CSS files (not imported anywhere):${NC}"
    for file in "${ORPHAN_FILES[@]}"; do
        echo "   $file"
    done
else
    echo -e "\n${GREEN}✅ No orphan CSS files found!${NC}"
fi

# Step 2: Check for unused component mappings
echo -e "\n${BLUE}📁 Step 2: Checking component-CSS mappings...${NC}"

# Find components that reference CSS files
echo -e "\n${YELLOW}Components with missing CSS files:${NC}"
MISSING_COUNT=0

for component in $(find src/components src/features src/pages -name "*.tsx" -type f); do
    # Extract @cssFile from component
    css_ref=$(grep -o "@cssFile.*" "$component" | sed 's/@cssFile //' | tr -d ' ')
    
    if [ ! -z "$css_ref" ] && [ "$css_ref" != "none" ]; then
        # Convert path (remove leading slash, add src)
        css_path="src${css_ref}"
        
        if [ ! -f "$css_path" ]; then
            echo -e "${RED}✗${NC} $(basename "$component"): Missing CSS at $css_path"
            MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
    fi
done

if [ $MISSING_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ All component CSS mappings are valid!${NC}"
fi

# Step 3: Find potentially unused CSS classes
echo -e "\n${BLUE}📁 Step 3: Finding potentially unused CSS classes...${NC}"
echo -e "${YELLOW}(This is a heuristic check - manual verification recommended)${NC}\n"

# Check each CSS file for unused classes
UNUSED_CLASSES=0

for css_file in "${IMPORTED_FILES[@]}"; do
    # Skip some files that are known to have global styles
    if [[ "$css_file" =~ (globals|animations|variables) ]]; then
        continue
    fi
    
    # Extract class names from CSS file (basic regex)
    classes=$(grep -o '^\.[a-zA-Z0-9_-][a-zA-Z0-9_-]*' "$css_file" | sort | uniq)
    
    if [ ! -z "$classes" ]; then
        echo -e "\nChecking $css_file:"
        unused_in_file=0
        
        for class in $classes; do
            # Remove the dot prefix
            classname="${class:1}"
            
            # Search for usage in TSX/JSX files
            # Look for className="...$classname..." or className={`...$classname...`}
            if ! grep -r "className=.*$classname" src/ --include="*.tsx" --include="*.jsx" > /dev/null 2>&1; then
                # Also check for dynamic class construction
                if ! grep -r "$classname" src/ --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "\.css" > /dev/null 2>&1; then
                    echo -e "   ${RED}✗${NC} .$classname - Not found in any component"
                    unused_in_file=$((unused_in_file + 1))
                    UNUSED_CLASSES=$((UNUSED_CLASSES + 1))
                fi
            fi
        done
        
        if [ $unused_in_file -eq 0 ]; then
            echo -e "   ${GREEN}✓${NC} All classes appear to be used"
        fi
    fi
done

# Step 4: Check for duplicate style definitions
echo -e "\n${BLUE}📁 Step 4: Checking for duplicate CSS imports...${NC}"

# Check index.css for duplicate imports
DUPLICATES=$(grep "@import" src/index.css | sort | uniq -d)

if [ ! -z "$DUPLICATES" ]; then
    echo -e "${RED}❌ Duplicate imports found in index.css:${NC}"
    echo "$DUPLICATES"
else
    echo -e "${GREEN}✅ No duplicate imports found${NC}"
fi

# Final Summary
echo -e "\n${BLUE}📊 Final Summary:${NC}"
echo "=================="
echo "Orphan CSS files: $ORPHAN_COUNT"
echo "Missing CSS references: $MISSING_COUNT"
echo "Potentially unused classes: $UNUSED_CLASSES"

if [ $ORPHAN_COUNT -eq 0 ] && [ $MISSING_COUNT -eq 0 ]; then
    echo -e "\n${GREEN}✨ CSS structure looks good!${NC}"
else
    echo -e "\n${YELLOW}⚠️  Some issues need attention${NC}"
fi

# Recommendations
echo -e "\n${BLUE}📝 Recommendations:${NC}"
echo "1. Delete orphan CSS files that aren't needed"
echo "2. Update component @cssFile paths to match actual locations"
echo "3. Remove unused CSS classes to reduce bundle size"
echo "4. Consider consolidating utility styles into utilities.css"

exit $((ORPHAN_COUNT + MISSING_COUNT))
