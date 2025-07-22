#!/bin/bash

# Test Generation Script
# Generates test files from templates

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get the file to generate test for
FILE_PATH=$1

if [[ -z "$FILE_PATH" ]]; then
    echo "Usage: $0 <file-path>"
    echo "Example: $0 src/components/Button/Button.tsx"
    exit 1
fi

# Determine test type based on file location
if [[ "$FILE_PATH" == *"/components/"* ]]; then
    TEST_TYPE="component"
    TEMPLATE="grammar-ops/templates/tests/component.test.template.tsx"
elif [[ "$FILE_PATH" == *"/hooks/"* ]]; then
    TEST_TYPE="hook"
    TEMPLATE="grammar-ops/templates/tests/hook.test.template.ts"
elif [[ "$FILE_PATH" == *"/services/"* ]]; then
    TEST_TYPE="service"
    TEMPLATE="grammar-ops/templates/tests/service.test.template.ts"
else
    echo -e "${YELLOW}Warning:${NC} Unknown file type. Using component template."
    TEST_TYPE="component"
    TEMPLATE="grammar-ops/templates/tests/component.test.template.tsx"
fi

# Extract component/hook/service name
BASENAME=$(basename "$FILE_PATH")
NAME="${BASENAME%.*}"
TEST_FILE="${FILE_PATH%.*}.test.${FILE_PATH##*.}"

# Check if test already exists
if [[ -f "$TEST_FILE" ]]; then
    echo -e "${YELLOW}Test file already exists:${NC} $TEST_FILE"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Generate test from template
if [[ -f "$TEMPLATE" ]]; then
    # Replace template variables
    sed -e "s/{{ComponentName}}/$NAME/g" \
        -e "s/{{useHookName}}/$NAME/g" \
        -e "s/{{ServiceName}}/$NAME/g" \
        -e "s/{{component-name}}/$(echo $NAME | sed 's/\([A-Z]\)/-\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-//')/g" \
        "$TEMPLATE" > "$TEST_FILE"
    
    echo -e "${GREEN}✓${NC} Generated test file: $TEST_FILE"
    echo "Next steps:"
    echo "1. Review and customize the generated test"
    echo "2. Run 'npm test $TEST_FILE' to verify"
    echo "3. Add specific test cases for your implementation"
else
    echo "Error: Template not found: $TEMPLATE"
    exit 1
fi