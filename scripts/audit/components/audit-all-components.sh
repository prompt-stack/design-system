#!/bin/bash

# @script audit-all-components
# @purpose Audit all components for CSS compliance
# @output console

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Auditing All Components${NC}"
echo "=========================="
echo ""

FAILED_COMPONENTS=0
PASSED_COMPONENTS=0
TOTAL_COMPONENTS=0

# Find all component files
find src/components -name "*.tsx" -type f | while read file; do
    # Extract component name from path
    component_name=$(basename "$file" .tsx)
    
    # Skip index files and non-component files
    if [[ "$component_name" == "index" ]] || [[ "$component_name" == "types" ]]; then
        continue
    fi
    
    TOTAL_COMPONENTS=$((TOTAL_COMPONENTS + 1))
    
    echo -e "${YELLOW}Checking: $component_name${NC}"
    
    # Run the audit for this component
    if ./grammar-ops/scripts/audit-component.sh "$component_name" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASSED${NC}"
        PASSED_COMPONENTS=$((PASSED_COMPONENTS + 1))
    else
        echo -e "${RED}❌ FAILED${NC}"
        FAILED_COMPONENTS=$((FAILED_COMPONENTS + 1))
    fi
done

echo ""
echo -e "${BLUE}📊 Component Audit Summary${NC}"
echo "========================"
echo "Total components: $TOTAL_COMPONENTS"
echo -e "Passed: ${GREEN}$PASSED_COMPONENTS${NC}"
echo -e "Failed: ${RED}$FAILED_COMPONENTS${NC}"

# Exit with error if any components failed
exit $FAILED_COMPONENTS