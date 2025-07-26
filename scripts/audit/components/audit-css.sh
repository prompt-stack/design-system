#!/bin/bash

# @script css-audit
# @purpose Script for css-audit operations
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# CSS Naming Convention Audit Script
# Checks all CSS files for BEM compliance and naming violations

echo "CSS Naming Convention Audit"
echo "=========================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_files=0
files_with_issues=0
total_violations=0

# Function to check component CSS files
check_components() {
    echo -e "${BLUE}=== COMPONENTS ===${NC}"
    for file in src/styles/components/*.css; do
        if [ -f "$file" ]; then
            ((total_files++))
            filename=$(basename "$file")
            violations=0
            
            # Check for page prefixes (should not exist in components)
            if grep -E '^\s*\.(home__|health__|subscription__|inbox__|playground__)' "$file" > /dev/null; then
                echo -e "${RED}✗${NC} $file - Contains page prefixes"
                ((violations++))
            fi
            
            # Check for non-BEM patterns
            if grep -E '^\s*\.[a-z]+_[a-z]+' "$file" > /dev/null; then
                echo -e "${RED}✗${NC} $file - Contains underscore (non-BEM)"
                ((violations++))
            fi
            
            # Check for overly generic names
            if grep -E '^\s*\.(container|wrapper|content|header|footer|title)(\s|{)' "$file" > /dev/null; then
                echo -e "${YELLOW}⚠${NC}  $file - Contains generic class names"
                ((violations++))
            fi
            
            if [ $violations -eq 0 ]; then
                echo -e "${GREEN}✓${NC} $file"
            else
                ((files_with_issues++))
                ((total_violations+=$violations))
            fi
        fi
    done
}

# Function to check page CSS files
check_pages() {
    echo -e "\n${BLUE}=== PAGES ===${NC}"
    for file in src/styles/pages/*.css; do
        if [ -f "$file" ]; then
            ((total_files++))
            filename=$(basename "$file" .css)
            violations=0
            
            # Check if page classes use proper prefix
            if grep -E "^\s*\.[^${filename}__]" "$file" | grep -vE '^\s*\.(is-|has-|@)' > /dev/null; then
                echo -e "${RED}✗${NC} $file - Missing page prefix '${filename}__'"
                ((violations++))
                # Show some examples
                echo "  Examples of violations:"
                grep -E "^\s*\.[^${filename}__]" "$file" | grep -vE '^\s*\.(is-|has-|@)' | head -3 | sed 's/^/    /'
            fi
            
            if [ $violations -eq 0 ]; then
                echo -e "${GREEN}✓${NC} $file"
            else
                ((files_with_issues++))
                ((total_violations+=$violations))
            fi
        fi
    done
}

# Function to check utils CSS files
check_utils() {
    echo -e "\n${BLUE}=== UTILS ===${NC}"
    for file in src/styles/utils/*.css; do
        if [ -f "$file" ]; then
            ((total_files++))
            filename=$(basename "$file")
            violations=0
            
            # Check for component implementations
            if grep -E '^\s*\.(card__|btn__|modal__|badge__|form__)' "$file" > /dev/null; then
                echo -e "${RED}✗${NC} $file - Contains component implementations"
                ((violations++))
            fi
            
            # Check for page-specific classes
            if grep -E '^\s*\.(home__|health__|subscription__|inbox__|playground__)' "$file" > /dev/null; then
                echo -e "${RED}✗${NC} $file - Contains page-specific classes"
                ((violations++))
            fi
            
            if [ $violations -eq 0 ]; then
                echo -e "${GREEN}✓${NC} $file"
            else
                ((files_with_issues++))
                ((total_violations+=$violations))
            fi
        fi
    done
}

# Function to find specific patterns
find_patterns() {
    echo -e "\n${BLUE}=== PATTERN ANALYSIS ===${NC}"
    
    # Find legacy class names
    echo "Checking for legacy patterns..."
    if grep -r "cosmic-\|inbox-cosmic\|url-input-\|pricing-\|faq-\|money-back" src/styles/ --include="*.css" > /dev/null; then
        echo -e "${YELLOW}⚠${NC}  Found legacy class names:"
        grep -r "cosmic-\|inbox-cosmic\|url-input-\|pricing-\|faq-\|money-back" src/styles/ --include="*.css" | head -5
    fi
    
    # Find double underscores in element names
    echo -e "\nChecking for double underscores..."
    if grep -r "__.*__" src/styles/ --include="*.css" > /dev/null; then
        echo -e "${YELLOW}⚠${NC}  Found double underscores (possible BEM violation):"
        grep -r "__.*__" src/styles/ --include="*.css" | head -5
    fi
    
    # Find mixed naming conventions
    echo -e "\nChecking for mixed conventions..."
    if grep -r "\.[a-z]*-[a-z]*_[a-z]*\|[a-z]*_[a-z]*-[a-z]*" src/styles/ --include="*.css" > /dev/null; then
        echo -e "${YELLOW}⚠${NC}  Found mixed underscore/hyphen usage:"
        grep -r "\.[a-z]*-[a-z]*_[a-z]*\|[a-z]*_[a-z]*-[a-z]*" src/styles/ --include="*.css" | head -5
    fi
}

# Run all checks
check_components
check_pages
check_utils
find_patterns

# Summary
echo -e "\n${BLUE}=== SUMMARY ===${NC}"
echo "Total files audited: $total_files"
echo "Files with issues: $files_with_issues"
echo "Total violations: $total_violations"

if [ $total_violations -eq 0 ]; then
    echo -e "\n${GREEN}✨ All CSS files follow naming conventions!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Found $total_violations naming violations that need fixing${NC}"
    exit 1
fi
