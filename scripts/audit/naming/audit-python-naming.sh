#!/bin/bash

# @script audit-python-naming
# @purpose Check Python files follow naming conventions
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

echo -e "${BLUE}🐍 Python Naming Audit${NC}"
echo "======================"
echo ""

ISSUES=0

# Check module/file naming
echo -e "${BLUE}=== Module (File) Naming ===${NC}"
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" -not -path "./node_modules/*" | while read file; do
    filename=$(basename "$file")
    
    # Skip special files
    if [[ "$filename" =~ ^(__init__|setup|conftest)\.py$ ]]; then
        continue
    fi
    
    # Check for snake_case
    if echo "$filename" | grep -qE '[A-Z]'; then
        echo -e "${RED}❌ $filename${NC} - contains uppercase (should be snake_case)"
        ISSUES=$((ISSUES + 1))
    elif echo "$filename" | grep -qE '^[0-9]'; then
        echo -e "${RED}❌ $filename${NC} - starts with number"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check function naming
echo -e "\n${BLUE}=== Function Naming ===${NC}"
echo "Checking for camelCase functions (should be snake_case)..."
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -n "^def [a-z][a-zA-Z]" 2>/dev/null | while read match; do
    if echo "$match" | grep -qE "def [a-z]+[A-Z]"; then
        echo -e "${RED}❌ camelCase function found:${NC}"
        echo "   $match"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check for verb-first functions
echo -e "\nChecking for functions without verb prefixes..."
VALID_VERBS="get|set|fetch|create|update|delete|validate|check|parse|format|serialize|handle|process|calculate|generate|load|save|read|write|send|receive|convert|transform|render|display|extract|build|test|mock"

find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -E "^def [a-z_]+\(" 2>/dev/null | while read match; do
    func_name=$(echo "$match" | sed -E 's/.*def ([a-z_]+)\(.*/\1/')
    
    # Skip special methods and test functions
    if [[ "$func_name" =~ ^(__|test_|setup|teardown) ]]; then
        continue
    fi
    
    # Check if starts with valid verb
    if ! echo "$func_name" | grep -qE "^($VALID_VERBS)_"; then
        if [ ${#func_name} -gt 3 ]; then  # Skip very short names
            echo -e "${YELLOW}⚠ Function without verb prefix: $func_name${NC}"
            echo "   in: $(echo "$match" | cut -d: -f1)"
        fi
    fi
done

# Check class naming
echo -e "\n${BLUE}=== Class Naming ===${NC}"
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -E "^class " 2>/dev/null | while read match; do
    class_name=$(echo "$match" | sed -E 's/.*class ([A-Za-z0-9_]+).*/\1/')
    
    # Should be PascalCase
    if ! echo "$class_name" | grep -qE '^[A-Z][a-zA-Z0-9]*$'; then
        echo -e "${RED}❌ Non-PascalCase class: $class_name${NC}"
        echo "   in: $(echo "$match" | cut -d: -f1)"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check constants
echo -e "\n${BLUE}=== Constant Naming ===${NC}"
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -E "^[A-Z_]+ = " 2>/dev/null | while read match; do
    const_name=$(echo "$match" | sed -E 's/^([A-Z_]+) = .*/\1/')
    
    # Should be UPPER_SNAKE_CASE
    if echo "$const_name" | grep -qE '[a-z]'; then
        echo -e "${RED}❌ Lowercase in constant: $const_name${NC}"
        echo "   in: $(echo "$match" | cut -d: -f1)"
        ISSUES=$((ISSUES + 1))
    fi
done

# Check boolean naming
echo -e "\n${BLUE}=== Boolean Naming ===${NC}"
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -E "(is_|has_|can_|should_)[a-z_]+ = (True|False)" 2>/dev/null | head -5 | while read match; do
    echo -e "${GREEN}✓ Good boolean: $(echo "$match" | grep -oE "(is_|has_|can_|should_)[a-z_]+")${NC}"
done

# Check for wrong boolean patterns
find . -name "*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | xargs grep -E "^[a-z_]*_(flag|boolean|bool) = " 2>/dev/null | while read match; do
    echo -e "${YELLOW}⚠ Boolean without prefix:${NC}"
    echo "   $match"
    echo "   Should use: is_, has_, can_, or should_ prefix"
done

# Check test files
echo -e "\n${BLUE}=== Test File Naming ===${NC}"
find . -name "*test*.py" -type f -not -path "./venv/*" -not -path "./__pycache__/*" | while read file; do
    filename=$(basename "$file")
    
    if [[ "$filename" =~ ^test_.*\.py$ ]] || [[ "$filename" =~ .*_test\.py$ ]]; then
        echo -e "${GREEN}✓ $filename${NC}"
    else
        echo -e "${YELLOW}⚠ Non-standard test file: $filename${NC}"
        echo "   Should be: test_*.py or *_test.py"
    fi
done

# Check package structure
echo -e "\n${BLUE}=== Package Structure ===${NC}"
find . -type d -name "[A-Z]*" -not -path "./venv/*" -not -path "./__pycache__/*" -not -path "./node_modules/*" | while read dir; do
    dirname=$(basename "$dir")
    echo -e "${RED}❌ Uppercase in package name: $dirname${NC}"
    echo "   Python packages should be snake_case"
    ISSUES=$((ISSUES + 1))
done

# Summary
echo -e "\n${BLUE}=== Python Naming Conventions Summary ===${NC}"
echo "✓ Modules: snake_case.py"
echo "✓ Functions: snake_case with verb prefix (get_user, validate_email)"
echo "✓ Classes: PascalCase (UserService, DataProcessor)"
echo "✓ Constants: UPPER_SNAKE_CASE (MAX_RETRIES, DEFAULT_TIMEOUT)"
echo "✓ Booleans: is_/has_/can_/should_ prefix (is_active, has_permission)"
echo "✓ Tests: test_*.py or *_test.py"
echo "✓ Packages: snake_case/ with __init__.py"

if [ $ISSUES -eq 0 ]; then
    echo -e "\n${GREEN}✅ All Python naming follows conventions!${NC}"
else
    echo -e "\n${RED}❌ Found $ISSUES naming issues${NC}"
fi

exit $ISSUES