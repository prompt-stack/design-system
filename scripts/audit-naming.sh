#!/bin/bash

# @script audit-naming
# @purpose Audit naming for compliance
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# Comprehensive Naming Convention Audit Script
# Checks both frontend and backend code for naming convention violations

echo "🔍 Comprehensive Naming Convention Audit"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_ISSUES=0
TOTAL_FILES=0

# Function to check React component naming
check_react_components() {
    echo -e "\n${BLUE}📁 Checking React Components...${NC}"
    
    for file in src/components/*.tsx src/features/**/*.tsx src/pages/*.tsx; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .tsx)
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Skip index files
            if [ "$filename" = "index" ]; then
                continue
            fi
            
            # Check if filename is PascalCase
            if ! [[ "$filename" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
                echo -e "${RED}✗${NC} $file - Component file should be PascalCase"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            else
                echo -e "${GREEN}✓${NC} $filename"
            fi
            
            # Check for matching CSS file
            css_file="${file%.tsx}.css"
            expected_css="src/styles/components/${filename,,}.css"
            
            if [ ! -f "$expected_css" ] && [[ "$file" =~ components/ ]]; then
                echo -e "${YELLOW}⚠${NC}  Missing CSS file: $expected_css"
            fi
        fi
    done
}

# Function to check hook naming
check_hooks() {
    echo -e "\n${BLUE}📁 Checking React Hooks...${NC}"
    
    for file in src/hooks/*.ts src/features/**/hooks/*.ts; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .ts)
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Check if filename starts with 'use'
            if ! [[ "$filename" =~ ^use[A-Z] ]]; then
                echo -e "${RED}✗${NC} $file - Hook should start with 'use'"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            else
                echo -e "${GREEN}✓${NC} $filename"
            fi
        fi
    done
}

# Function to check CSS files
check_css_naming() {
    echo -e "\n${BLUE}📁 Checking CSS Files...${NC}"
    
    for file in src/styles/**/*.css; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .css)
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Check if filename is kebab-case
            if ! [[ "$filename" =~ ^[a-z]+(-[a-z]+)*$ ]]; then
                echo -e "${RED}✗${NC} $file - CSS file should be kebab-case"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            fi
            
            # Check BEM naming inside CSS files
            while IFS= read -r line; do
                # Check for class definitions
                if [[ "$line" =~ ^\.[a-zA-Z] ]]; then
                    class_name=$(echo "$line" | grep -o '^\.[a-zA-Z0-9-_]*' | sed 's/^\.//')
                    
                    # Check BEM patterns
                    if [[ "$class_name" =~ ^[a-z]+(-[a-z]+)*(__[a-z]+(-[a-z]+)*)?(--[a-z]+(-[a-z]+)*)?$ ]] || 
                       [[ "$class_name" =~ ^[a-z]+(-[a-z]+)*\.is-[a-z]+(-[a-z]+)*$ ]]; then
                        # Valid BEM
                        :
                    else
                        echo -e "${YELLOW}⚠${NC}  Non-BEM class: .$class_name in $file"
                    fi
                fi
            done < "$file"
        fi
    done
}

# Function to check TypeScript interfaces and types
check_typescript_types() {
    echo -e "\n${BLUE}📁 Checking TypeScript Types...${NC}"
    
    for file in src/**/*.ts src/**/*.tsx backend/**/*.ts; do
        if [ -f "$file" ]; then
            # Check interface naming
            while IFS= read -r line; do
                if [[ "$line" =~ ^[[:space:]]*export[[:space:]]+interface[[:space:]]+([a-zA-Z]+) ]]; then
                    interface_name="${BASH_REMATCH[1]}"
                    
                    # Check if interface is PascalCase
                    if ! [[ "$interface_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
                        echo -e "${RED}✗${NC} Interface '$interface_name' in $file - Should be PascalCase"
                        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
                    fi
                    
                    # Check for Props suffix for component props
                    if [[ "$file" =~ \.(tsx)$ ]] && [[ "$interface_name" =~ Props$ ]]; then
                        echo -e "${GREEN}✓${NC} Good Props naming: $interface_name"
                    fi
                fi
                
                # Check type naming
                if [[ "$line" =~ ^[[:space:]]*export[[:space:]]+type[[:space:]]+([a-zA-Z]+) ]]; then
                    type_name="${BASH_REMATCH[1]}"
                    
                    # Check if type is PascalCase
                    if ! [[ "$type_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
                        echo -e "${RED}✗${NC} Type '$type_name' in $file - Should be PascalCase"
                        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
                    fi
                fi
                
                # Check enum naming
                if [[ "$line" =~ ^[[:space:]]*export[[:space:]]+enum[[:space:]]+([a-zA-Z]+) ]]; then
                    enum_name="${BASH_REMATCH[1]}"
                    
                    # Check if enum is PascalCase
                    if ! [[ "$enum_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
                        echo -e "${RED}✗${NC} Enum '$enum_name' in $file - Should be PascalCase"
                        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
                    fi
                fi
            done < "$file"
        fi
    done
}

# Function to check constants
check_constants() {
    echo -e "\n${BLUE}📁 Checking Constants...${NC}"
    
    for file in src/**/*.ts src/**/*.tsx backend/**/*.ts; do
        if [ -f "$file" ]; then
            # Look for exported constants
            while IFS= read -r line; do
                if [[ "$line" =~ ^export[[:space:]]+const[[:space:]]+([A-Z_]+)[[:space:]]*= ]] ||
                   [[ "$line" =~ ^[[:space:]]*const[[:space:]]+([A-Z_]+)[[:space:]]*= ]]; then
                    const_name="${BASH_REMATCH[1]}"
                    
                    # Check if constant is SCREAMING_SNAKE_CASE
                    if [[ "$const_name" =~ ^[A-Z]+(_[A-Z]+)*$ ]]; then
                        echo -e "${GREEN}✓${NC} Good constant naming: $const_name in $(basename "$file")"
                    fi
                fi
            done < "$file"
        fi
    done
}

# Run all checks
check_react_components
check_hooks
check_css_naming
check_typescript_types
check_constants

# Also run backend-specific checks
if [ -f "$(dirname "$0")/audit-backend-naming.sh" ]; then
    echo -e "\n${BLUE}Running backend-specific checks...${NC}"
    bash "$(dirname "$0")/audit-backend-naming.sh"
fi

# Summary
echo -e "\n${BLUE}📊 Overall Summary${NC}"
echo "=================="
echo "Total files checked: $TOTAL_FILES"
if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✨ No naming issues found!${NC}"
else
    echo -e "${RED}Found $TOTAL_ISSUES naming issues${NC}"
    echo -e "${YELLOW}Please review and fix the issues above${NC}"
fi

exit $TOTAL_ISSUES
