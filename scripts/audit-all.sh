#!/bin/bash

# @script audit-all
# @purpose Run all audit scripts and generate combined report
# @output console|json

# Master audit runner - discovers and executes all audit scripts

SCRIPT_DIR="grammar-ops/scripts"
FAILED_AUDITS=0
PASSED_AUDITS=0
TOTAL_AUDITS=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
OUTPUT_FORMAT="console"
while [[ $# -gt 0 ]]; do
    case $1 in
        --format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [--format console|json]"
            echo ""
            echo "Runs all audit scripts in the grammar-ops/scripts directory"
            echo ""
            echo "Options:"
            echo "  --format    Output format (console or json)"
            echo "  --help      Show this help"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

if [ "$OUTPUT_FORMAT" = "json" ]; then
    echo '{'
    echo '  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
    echo '  "audits": ['
fi

if [ "$OUTPUT_FORMAT" = "console" ]; then
    echo -e "${BLUE}🔍 Running All Audits${NC}"
    echo "===================="
    echo ""
fi

first_audit=true

# Find and run all audit scripts (except audit-all itself)
for script in "$SCRIPT_DIR"/audit-*.sh; do
    if [ -f "$script" ] && [ "$script" != "$SCRIPT_DIR/audit-all.sh" ]; then
        script_name=$(basename "$script" .sh)
        
        # Extract metadata
        purpose=$(grep -m1 "@purpose" "$script" 2>/dev/null | sed 's/.*@purpose //' | tr -d '\r')
        
        TOTAL_AUDITS=$((TOTAL_AUDITS + 1))
        
        if [ "$OUTPUT_FORMAT" = "console" ]; then
            echo -e "${YELLOW}Running: $script_name${NC}"
            if [ ! -z "$purpose" ]; then
                echo "Purpose: $purpose"
            fi
            echo "---"
        fi
        
        # Run the audit and capture result
        if [ "$OUTPUT_FORMAT" = "json" ]; then
            if [ "$first_audit" = false ]; then
                echo ","
            fi
            first_audit=false
            
            echo -n '    {'
            echo -n '"name": "'$script_name'"'
            if [ ! -z "$purpose" ]; then
                echo -n ', "purpose": "'$purpose'"'
            fi
            echo -n ', "status": '
        fi
        
        # Execute the script
        if bash "$script" > /dev/null 2>&1; then
            PASSED_AUDITS=$((PASSED_AUDITS + 1))
            if [ "$OUTPUT_FORMAT" = "console" ]; then
                echo -e "${GREEN}✅ PASSED${NC}\n"
            else
                echo -n '"passed"}'
            fi
        else
            FAILED_AUDITS=$((FAILED_AUDITS + 1))
            if [ "$OUTPUT_FORMAT" = "console" ]; then
                echo -e "${RED}❌ FAILED${NC}\n"
            else
                echo -n '"failed"}'
            fi
        fi
    fi
done

if [ "$OUTPUT_FORMAT" = "json" ]; then
    echo ""
    echo "  ],"
    echo '  "summary": {'
    echo '    "total": '$TOTAL_AUDITS','
    echo '    "passed": '$PASSED_AUDITS','
    echo '    "failed": '$FAILED_AUDITS','
    echo '    "passRate": '$(awk "BEGIN {printf \"%.1f\", $PASSED_AUDITS * 100 / $TOTAL_AUDITS}")
    echo "  }"
    echo "}"
else
    echo -e "${BLUE}📊 Audit Summary${NC}"
    echo "==============="
    echo "Total audits run: $TOTAL_AUDITS"
    echo -e "Passed: ${GREEN}$PASSED_AUDITS${NC}"
    echo -e "Failed: ${RED}$FAILED_AUDITS${NC}"
    
    if [ $FAILED_AUDITS -eq 0 ]; then
        echo -e "\n${GREEN}✨ All audits passed!${NC}"
    else
        echo -e "\n${RED}❌ $FAILED_AUDITS audit(s) failed${NC}"
        echo "Run individual audit scripts for details"
    fi
fi

# Exit with error if any audits failed
exit $FAILED_AUDITS