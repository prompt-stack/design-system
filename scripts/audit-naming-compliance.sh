#!/bin/bash

# @script audit-naming-compliance
# @purpose Check all files against naming conventions
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

TOTAL_ISSUES=0

check_script_naming() {
    echo -e "${BLUE}=== Checking Script Naming ===${NC}"
    local issues=0
    
    # Check shell scripts
    find grammar-ops/scripts -name "*.sh" | while read file; do
        local filename=$(basename "$file")
        
        # Should follow action-target.sh pattern
        if ! echo "$filename" | grep -qE '^(audit|add|build|find|validate|update|generate|migrate|check|scan|rename)-[a-z-]+\.sh$'; then
            echo -e "${RED}❌ $filename${NC} - doesn't follow {action}-{target}.sh pattern"
            issues=$((issues + 1))
        fi
    done
    
    # Removed false positive check for audit-css.sh
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All scripts follow naming conventions${NC}"
    fi
    
    return $issues
}

check_component_naming() {
    echo -e "\n${BLUE}=== Checking Component Naming ===${NC}"
    local issues=0
    
    # Check React components
    find src/components -name "*.tsx" | while read file; do
        local filename=$(basename "$file" .tsx)
        
        # Should be PascalCase
        if ! echo "$filename" | grep -qE '^[A-Z][a-zA-Z0-9]*$'; then
            echo -e "${RED}❌ $filename${NC} - not PascalCase"
            issues=$((issues + 1))
        fi
        
        # Check if CSS file exists and is lowercase
        local css_file="src/styles/components/$(echo "$filename" | tr '[:upper:]' '[:lower:]').css"
        if [ ! -f "$css_file" ]; then
            echo -e "${YELLOW}⚠ Missing CSS: $css_file${NC}"
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All components follow naming conventions${NC}"
    fi
    
    return $issues
}

check_hook_naming() {
    echo -e "\n${BLUE}=== Checking Hook Naming ===${NC}"
    local issues=0
    
    # Check hooks
    find src/hooks -name "*.ts" -o -name "*.tsx" | while read file; do
        local filename=$(basename "$file" | sed 's/\.[^.]*$//')
        
        # Should start with 'use'
        if ! echo "$filename" | grep -qE '^use[A-Z]'; then
            echo -e "${RED}❌ $filename${NC} - doesn't start with 'use'"
            issues=$((issues + 1))
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All hooks follow naming conventions${NC}"
    fi
    
    return $issues
}

check_css_naming() {
    echo -e "\n${BLUE}=== Checking CSS File Naming ===${NC}"
    local issues=0
    
    # CSS files should be lowercase with hyphens
    find src/styles -name "*.css" | while read file; do
        local filename=$(basename "$file")
        
        if echo "$filename" | grep -qE '[A-Z]'; then
            echo -e "${RED}❌ $filename${NC} - contains uppercase letters"
            issues=$((issues + 1))
        fi
        
        if echo "$filename" | grep -qE '_'; then
            echo -e "${YELLOW}⚠ $filename${NC} - uses underscores instead of hyphens"
            issues=$((issues + 1))
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All CSS files follow naming conventions${NC}"
    fi
    
    return $issues
}

check_service_naming() {
    echo -e "\n${BLUE}=== Checking Service/API Naming ===${NC}"
    local issues=0
    
    # Check service files
    find src/services -name "*.ts" -o -name "*.tsx" 2>/dev/null | while read file; do
        local filename=$(basename "$file" | sed 's/\.[^.]*$//')
        
        # Should end with Service or Api
        if ! echo "$filename" | grep -qE '(Service|Api)$'; then
            echo -e "${YELLOW}⚠ $filename${NC} - should end with 'Service' or 'Api'"
            issues=$((issues + 1))
        fi
        
        # Should be PascalCase
        if ! echo "$filename" | grep -qE '^[A-Z][a-zA-Z0-9]*(Service|Api)$'; then
            echo -e "${RED}❌ $filename${NC} - not proper PascalCase"
            issues=$((issues + 1))
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All services follow naming conventions${NC}"
    fi
    
    return $issues
}

check_type_file_naming() {
    echo -e "\n${BLUE}=== Checking Type File Naming ===${NC}"
    local issues=0
    
    # Check for types.ts or *Types.ts pattern
    find src -name "*.ts" -path "*/types/*" -o -name "*Types.ts" -o -name "types.ts" | while read file; do
        local filename=$(basename "$file")
        
        if [ "$filename" != "types.ts" ] && ! echo "$filename" | grep -qE '^[A-Z][a-zA-Z0-9]*Types\.ts$'; then
            echo -e "${YELLOW}⚠ $filename${NC} - should be 'types.ts' or '{Domain}Types.ts'"
            issues=$((issues + 1))
        fi
    done
    
    if [ $issues -eq 0 ]; then
        echo -e "${GREEN}✅ All type files follow naming conventions${NC}"
    fi
    
    return $issues
}

# Main execution
echo -e "${BLUE}🔍 Codebase Naming Compliance Audit${NC}"
echo "===================================="

# Run all checks
check_script_naming
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

check_component_naming  
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

check_hook_naming
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

check_css_naming
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

check_service_naming
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

check_type_file_naming
TOTAL_ISSUES=$((TOTAL_ISSUES + $?))

# Summary
echo -e "\n${BLUE}=== Summary ===${NC}"
if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✨ Perfect! All files follow naming conventions${NC}"
    exit 0
else
    echo -e "${RED}Found $TOTAL_ISSUES naming issues${NC}"
    echo -e "\nRefer to: grammar-ops/docs/CODEBASE_NAMING_SYSTEM.md"
    exit 1
fi