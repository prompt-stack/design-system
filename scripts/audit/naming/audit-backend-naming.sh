#!/bin/bash

# @script audit-backend-naming
# @purpose Validates backend service, route, and utility naming conventions
# @output console

# Backend Naming Convention Audit Script
# Checks backend code for naming convention violations

echo "🔍 Backend Naming Convention Audit"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_ISSUES=0
TOTAL_FILES=0

# Check service file naming (should be PascalCase with Service suffix)
echo -e "\n📁 Checking Service Files..."
if [ -d "backend/services" ]; then
    for file in backend/services/*.ts backend/services/*.js; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Check if filename matches pattern: PascalCaseService.ts
            if ! [[ "$filename" =~ ^[A-Z][a-zA-Z]*Service\.(ts|js)$ ]]; then
                echo -e "${RED}✗${NC} $filename - Should be PascalCase with 'Service' suffix"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            else
                echo -e "${GREEN}✓${NC} $filename"
            fi
        fi
    done
fi

# Check route file naming (should be camelCase)
echo -e "\n📁 Checking Route Files..."
if [ -d "backend/routes" ]; then
    for file in backend/routes/*.ts backend/routes/*.js; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Check if filename matches pattern: camelCase.ts
            if ! [[ "$filename" =~ ^[a-z][a-zA-Z]*\.(ts|js)$ ]]; then
                echo -e "${RED}✗${NC} $filename - Should be camelCase"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            else
                echo -e "${GREEN}✓${NC} $filename"
            fi
        fi
    done
fi

# Check util file naming (should be camelCase, verb-first)
echo -e "\n📁 Checking Util Files..."
if [ -d "backend/utils" ]; then
    for file in backend/utils/*.ts backend/utils/*.js; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" | sed 's/\.[^.]*$//')
            TOTAL_FILES=$((TOTAL_FILES + 1))
            
            # Common verb prefixes
            if [[ "$filename" =~ ^(get|set|create|update|delete|validate|parse|format|generate|extract|detect|calculate|transform|convert|fetch|save|load|send|handle|process|check|is|has|should)[A-Z] ]]; then
                echo -e "${GREEN}✓${NC} $(basename "$file") - Good verb-first naming"
            else
                echo -e "${YELLOW}⚠${NC}  $(basename "$file") - Consider verb-first naming"
                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            fi
        fi
    done
fi

# Check API endpoint patterns in route files
echo -e "\n📁 Checking API Endpoints..."
if [ -d "backend/routes" ]; then
    for file in backend/routes/*.ts backend/routes/*.js; do
        if [ -f "$file" ]; then
            # Look for route definitions
            while IFS= read -r line; do
                if [[ "$line" =~ \.(get|post|put|patch|delete)\([\'\"]/([^\'\"]+)[\'\"] ]]; then
                    endpoint="${BASH_REMATCH[2]}"
                    
                    # Check if endpoint uses kebab-case
                    if [[ "$endpoint" =~ [A-Z] ]] || [[ "$endpoint" =~ _ ]]; then
                        echo -e "${RED}✗${NC} Endpoint '$endpoint' in $(basename "$file") - Should use kebab-case"
                        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
                    fi
                fi
            done < "$file"
        fi
    done
fi

# Check for class naming in services
echo -e "\n📁 Checking Service Class Names..."
if [ -d "backend/services" ]; then
    for file in backend/services/*.ts backend/services/*.js; do
        if [ -f "$file" ]; then
            # Look for class definitions
            while IFS= read -r line; do
                if [[ "$line" =~ ^[[:space:]]*export[[:space:]]+class[[:space:]]+([a-zA-Z]+) ]]; then
                    classname="${BASH_REMATCH[1]}"
                    
                    # Check if class name ends with Service
                    if ! [[ "$classname" =~ Service$ ]]; then
                        echo -e "${RED}✗${NC} Class '$classname' in $(basename "$file") - Should end with 'Service'"
                        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
                    else
                        echo -e "${GREEN}✓${NC} Class '$classname' in $(basename "$file")"
                    fi
                fi
            done < "$file"
        fi
    done
fi

# Summary
echo -e "\n📊 Summary"
echo "=========="
echo "Total files checked: $TOTAL_FILES"
if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✨ No naming issues found!${NC}"
else
    echo -e "${RED}Found $TOTAL_ISSUES naming issues${NC}"
    echo -e "${YELLOW}Please review and fix the issues above${NC}"
fi

exit $TOTAL_ISSUES