#!/bin/bash

# @script audit-full-stack-naming
# @purpose Run comprehensive naming audit across all layers
# @output console|json
# @llm-read true
# @llm-write full-edit
# @llm-role utility

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

OUTPUT_FORMAT="${1:-console}"

if [ "$OUTPUT_FORMAT" = "json" ]; then
    echo '{'
    echo '  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
    echo '  "layers": {'
fi

run_audit() {
    local layer=$1
    local script=$2
    local description=$3
    
    if [ "$OUTPUT_FORMAT" = "console" ]; then
        echo -e "\n${BLUE}=== $description ===${NC}"
    else
        if [ "$layer" != "frontend" ]; then
            echo ','
        fi
        echo -n "    \"$layer\": {"
    fi
    
    if [ -f "$script" ]; then
        if $script > /dev/null 2>&1; then
            if [ "$OUTPUT_FORMAT" = "console" ]; then
                echo -e "${GREEN}✅ PASSED${NC}"
            else
                echo -n '"status": "passed"}'
            fi
        else
            if [ "$OUTPUT_FORMAT" = "console" ]; then
                echo -e "${RED}❌ FAILED${NC}"
                echo "Run $script for details"
            else
                echo -n '"status": "failed"}'
            fi
        fi
    else
        if [ "$OUTPUT_FORMAT" = "console" ]; then
            echo -e "${YELLOW}⚠ Script not found: $script${NC}"
        else
            echo -n '"status": "missing"}'
        fi
    fi
}

echo -e "${BLUE}🌐 Full Stack Naming Audit${NC}"
echo "=========================="

# Frontend audits
run_audit "frontend" "grammar-ops/scripts/audit-naming.sh" "Frontend Naming (Components, Hooks, etc.)"
run_audit "css" "grammar-ops/scripts/audit-css-naming.js" "CSS/Style Naming"

# Backend audits
run_audit "backend" "grammar-ops/scripts/audit-backend-naming.sh" "Backend API Naming"
run_audit "database" "grammar-ops/scripts/audit-database-naming.sh" "Database/SQL Naming"

# Infrastructure audits
run_audit "scripts" "grammar-ops/scripts/audit-naming-compliance.sh" "Script File Naming"

# Additional checks
if [ "$OUTPUT_FORMAT" = "console" ]; then
    echo -e "\n${BLUE}=== Additional Checks ===${NC}"
    
    # Check for TypeScript interfaces/types
    echo -n "TypeScript Types: "
    if find src -name "*.ts" -o -name "*.tsx" | xargs grep -E "^(interface|type) [a-z]" > /dev/null 2>&1; then
        echo -e "${RED}❌ Found lowercase types/interfaces${NC}"
    else
        echo -e "${GREEN}✅ All PascalCase${NC}"
    fi
    
    # Check for API endpoint patterns
    echo -n "API Endpoints: "
    if find . -name "*.ts" -path "*/routes/*" -o -path "*/api/*" | xargs grep -E "router\.(get|post|put|delete).*[A-Z]" > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠ Found uppercase in routes${NC}"
    else
        echo -e "${GREEN}✅ All lowercase/kebab-case${NC}"
    fi
    
    # Check for environment variables
    echo -n "Environment Variables: "
    if [ -f ".env.example" ]; then
        if grep -E "^[a-z]" .env.example > /dev/null 2>&1; then
            echo -e "${RED}❌ Found lowercase env vars${NC}"
        else
            echo -e "${GREEN}✅ All UPPER_SNAKE_CASE${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ No .env.example found${NC}"
    fi
    
    echo -e "\n${BLUE}=== Grammar Rules Summary ===${NC}"
    echo "✓ Functions: verbNoun (camelCase)"
    echo "✓ Components: Noun (PascalCase)"
    echo "✓ Hooks: useNoun (camelCase)"
    echo "✓ Booleans: is/has/can + Adjective"
    echo "✓ Constants: UPPER_SNAKE_CASE"
    echo "✓ CSS: kebab-case (BEM)"
    echo "✓ SQL: snake_case"
    echo "✓ API routes: /kebab-case"
    echo "✓ Files: {pattern}.{ext}"
    
    echo -e "\n${GREEN}Full grammar system defined in:${NC}"
    echo "→ grammar-ops/docs/FULL_STACK_GRAMMAR_SYSTEM.md"
    echo "→ grammar-ops/config/full-stack-grammar-schema.json"
else
    echo '  }'
    echo '}'
fi