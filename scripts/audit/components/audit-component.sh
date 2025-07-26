#!/bin/bash

# @script audit-component
# @purpose Audit component for compliance
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# Component-Level CSS Audit Script
# Fast validation for single components during development
# Usage: ./audit-component.sh Button

echo "Component CSS Audit (Fast Mode)"
echo "=============================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if component name was provided
if [ -z "$1" ]; then
    # If no component specified, run audit-all-components
    exec ./grammar-ops/scripts/audit-all-components.sh
fi

COMPONENT_NAME=$1
COMPONENT_FILE="src/components/${COMPONENT_NAME}.tsx"
# Convert to lowercase for CSS file
COMPONENT_NAME_LOWER=$(echo "$COMPONENT_NAME" | tr '[:upper:]' '[:lower:]')
CSS_FILE="src/styles/components/${COMPONENT_NAME_LOWER}.css"

# Check if component exists
if [ ! -f "$COMPONENT_FILE" ]; then
    echo -e "${RED}✗${NC} Component not found: $COMPONENT_FILE"
    exit 1
fi

echo -e "${BLUE}Auditing: ${COMPONENT_NAME}${NC}"
echo ""

# Initialize counters
violations=0

# 1. Check if CSS file exists
echo "1. CSS File Check"
if [ -f "$CSS_FILE" ]; then
    echo -e "   ${GREEN}✓${NC} CSS file exists: $CSS_FILE"
else
    echo -e "   ${RED}✗${NC} Missing CSS file: $CSS_FILE"
    ((violations++))
fi

# 2. Check component metadata
echo ""
echo "2. Component Metadata Check"
if grep -q "@layer" "$COMPONENT_FILE"; then
    echo -e "   ${GREEN}✓${NC} @layer annotation found"
else
    echo -e "   ${YELLOW}⚠${NC}  Missing @layer annotation"
    ((violations++))
fi

if grep -q "@cssFile" "$COMPONENT_FILE"; then
    # Extract cssFile path and verify it matches
    css_path=$(grep "@cssFile" "$COMPONENT_FILE" | sed -n 's/.*@cssFile \(.*\)/\1/p' | tr -d ' ')
    expected_path="/styles/components/${COMPONENT_NAME_LOWER}.css"
    if [[ "$css_path" == *"$expected_path"* ]] || [[ "$css_path" == "none" ]]; then
        echo -e "   ${GREEN}✓${NC} @cssFile path is correct"
    else
        echo -e "   ${RED}✗${NC} @cssFile path mismatch"
        echo "      Expected: $expected_path"
        echo "      Found: $css_path"
        ((violations++))
    fi
else
    echo -e "   ${YELLOW}⚠${NC}  Missing @cssFile annotation"
    ((violations++))
fi

# 3. Check CSS naming conventions (if CSS file exists)
if [ -f "$CSS_FILE" ]; then
    echo ""
    echo "3. CSS Naming Convention Check"
    
    # Special case for Button component which uses .btn
    if [ "$COMPONENT_NAME" = "Button" ]; then
        base_class=".btn"
    else
        base_class=".${COMPONENT_NAME_LOWER}"
    fi
    
    # Check for base class
    if grep -q "^$base_class\s*{" "$CSS_FILE"; then
        echo -e "   ${GREEN}✓${NC} Base class found: $base_class"
    else
        echo -e "   ${RED}✗${NC} Missing base class: $base_class"
        ((violations++))
    fi
    
    # Check for BEM violations
    if grep -E "^\s*\.[a-z]+_[a-z]+" "$CSS_FILE" > /dev/null; then
        echo -e "   ${RED}✗${NC} Found underscore (non-BEM) patterns"
        ((violations++))
    fi
    
    # Check for page prefixes (shouldn't exist in components)
    if grep -E "^\s*\.(home__|health__|subscription__|inbox__|playground__)" "$CSS_FILE" > /dev/null; then
        echo -e "   ${RED}✗${NC} Found page prefixes in component CSS"
        ((violations++))
    fi
fi

# 4. Check component imports
echo ""
echo "4. Import Validation"
if grep -q "import.*Box.*from.*Box" "$COMPONENT_FILE"; then
    echo -e "   ${GREEN}✓${NC} Uses Box primitive for utilities"
fi

# Check for design token usage in CSS
if [ -f "$CSS_FILE" ]; then
    if grep -q "var(--" "$CSS_FILE"; then
        echo -e "   ${GREEN}✓${NC} Uses design tokens"
    else
        echo -e "   ${YELLOW}⚠${NC}  No design tokens found"
    fi
fi

# 5. Quick scan for common issues
echo ""
echo "5. Common Issues Check"

# Check if component uses className prop correctly
if grep -q "className={clsx(" "$COMPONENT_FILE"; then
    echo -e "   ${GREEN}✓${NC} Uses clsx for className composition"
elif grep -q "className=" "$COMPONENT_FILE"; then
    echo -e "   ${YELLOW}⚠${NC}  Consider using clsx for className"
fi

# Summary
echo ""
echo -e "${BLUE}=== SUMMARY ===${NC}"
echo "Component: $COMPONENT_NAME"
echo "Violations: $violations"

if [ $violations -eq 0 ]; then
    echo -e "${GREEN}✨ Component passes all checks!${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $violations issues that need fixing${NC}"
    exit 1
fi
