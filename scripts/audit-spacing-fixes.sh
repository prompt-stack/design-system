#!/bin/bash

# @script audit-spacing-fixes
# @purpose Audit spacing-fixes for compliance
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# Audit spacing-fixes.css
# Determines what's actually needed vs what should be moved/deleted

echo "🔍 Auditing spacing-fixes.css"
echo "============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SPACING_FILE="src/styles/utils/spacing-fixes.css"

echo -e "\n${BLUE}📏 File Statistics:${NC}"
echo "File: $SPACING_FILE"
echo "Size: $(wc -l < "$SPACING_FILE") lines"
echo "Last modified: $(stat -f "%Sm" "$SPACING_FILE" 2>/dev/null || stat -c "%y" "$SPACING_FILE" 2>/dev/null | cut -d' ' -f1)"

echo -e "\n${BLUE}📝 Content Analysis:${NC}"

# Check for different types of content
echo -e "\n${YELLOW}Global Element Selectors:${NC}"
grep -n "^[a-z]" "$SPACING_FILE" | grep -v "^\." | head -20

echo -e "\n${YELLOW}Utility Classes:${NC}"
grep -n "^\.[a-z]" "$SPACING_FILE" | grep -E "\.(m|p|text|flex|d-)" | head -10

echo -e "\n${YELLOW}Component Implementations:${NC}"
grep -n "^\.[a-z]" "$SPACING_FILE" | grep -vE "\.(m|p|text|flex|d-)" | head -10

echo -e "\n${BLUE}🔍 Usage Analysis:${NC}"

# Check if any component is actually using spacing utilities from this file
echo -e "\n${YELLOW}Checking component usage of spacing utilities:${NC}"

# Common spacing classes that might be used
spacing_classes=("m-0" "m-1" "m-2" "m-3" "m-4" "m-5" "p-0" "p-1" "p-2" "p-3" "p-4" "p-5" "mb-0" "mb-1" "mb-2" "mt-0" "mt-1" "mt-2")

used_count=0
for class in "${spacing_classes[@]}"; do
    if grep -r "className=.*$class" src/ --include="*.tsx" --include="*.jsx" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} .$class is used"
        used_count=$((used_count + 1))
    fi
done

echo -e "\nUsed spacing classes: $used_count"

echo -e "\n${BLUE}📊 Recommendations:${NC}"

# Analyze content
line_count=$(wc -l < "$SPACING_FILE")
element_selectors=$(grep -c "^[a-z]" "$SPACING_FILE" | grep -v "^\.")
utility_classes=$(grep -c "^\.[a-z]" "$SPACING_FILE")

echo -e "\n1. ${YELLOW}Global Element Selectors (h1, p, etc.):${NC}"
if [ "$element_selectors" -gt 0 ]; then
    echo "   - Found global element selectors that affect ALL instances"
    echo "   - ${RED}Recommendation:${NC} Move to globals.css or remove"
fi

echo -e "\n2. ${YELLOW}Spacing Utilities:${NC}"
if [ $used_count -gt 0 ]; then
    echo "   - Some spacing utilities are being used"
    echo "   - ${GREEN}Recommendation:${NC} Keep only used utilities, move to utilities.css"
else
    echo "   - ${RED}No spacing utilities appear to be used${NC}"
    echo "   - ${RED}Recommendation:${NC} Consider removing this file"
fi

echo -e "\n3. ${YELLOW}File Purpose:${NC}"
if [ $line_count -gt 100 ]; then
    echo "   - File is large ($line_count lines) for a 'fixes' file"
    echo "   - ${YELLOW}Recommendation:${NC} Split into specific purpose files or merge with utilities.css"
fi

echo -e "\n${BLUE}🎯 Action Items:${NC}"
echo "1. Review global element selectors - these affect EVERYTHING"
echo "2. Check if utilities.css already has these spacing classes"
echo "3. Remove unused classes"
echo "4. Consider renaming to 'typography-reset.css' if keeping typography rules"
echo "5. Move any component-specific styles to their respective CSS files"

# Check for duplicates with utilities.css
echo -e "\n${BLUE}🔍 Checking for duplicates with utilities.css:${NC}"
if [ -f "src/styles/utils/utilities.css" ]; then
    # Extract class names from both files
    spacing_classes=$(grep -o '^\.[a-zA-Z0-9_-]*' "$SPACING_FILE" | sort | uniq)
    utility_classes=$(grep -o '^\.[a-zA-Z0-9_-]*' "src/styles/utils/utilities.css" | sort | uniq)
    
    # Find common classes
    duplicates=$(comm -12 <(echo "$spacing_classes") <(echo "$utility_classes") 2>/dev/null)
    
    if [ ! -z "$duplicates" ]; then
        echo -e "${RED}Found duplicate classes in both files:${NC}"
        echo "$duplicates"
    else
        echo -e "${GREEN}No duplicate classes found${NC}"
    fi
fi

exit 0
