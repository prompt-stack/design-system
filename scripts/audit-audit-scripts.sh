#!/bin/bash

# @script audit-audit-scripts
# @purpose Audit audit-scripts for compliance
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility


# Meta-Audit Script: Auditing the Audit Scripts
# Checks if our audit scripts follow their own principles

echo "🔍 Meta-Audit: Auditing the Audit Scripts"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="grammar-ops/scripts"

# Required metadata fields for LLM-native compliance
REQUIRED_METADATA=(
    "@id"
    "@version" 
    "@type"
    "@description"
    "@dependencies"
    "@audit-targets"
    "@output-formats"
)

# Counters
TOTAL_SCRIPTS=0
COMPLIANT_SCRIPTS=0
MISSING_METADATA=0

echo -e "\n${BLUE}📁 Analyzing all audit scripts...${NC}"
echo "================================="

# Function to check metadata in a script
check_script_metadata() {
    local script=$1
    local script_name=$(basename "$script")
    local has_all_metadata=true
    local missing_fields=()
    
    echo -e "\n${YELLOW}Checking: $script_name${NC}"
    
    # Check for metadata block
    if ! grep -q "@id\|@version\|@type" "$script"; then
        echo -e "${RED}✗ No metadata block found${NC}"
        has_all_metadata=false
        missing_fields=("ALL")
    else
        # Check each required field
        for field in "${REQUIRED_METADATA[@]}"; do
            if ! grep -q "$field" "$script"; then
                echo -e "${RED}✗ Missing $field${NC}"
                has_all_metadata=false
                missing_fields+=("$field")
            else
                echo -e "${GREEN}✓ Has $field${NC}"
            fi
        done
    fi
    
    # Check for help/usage function
    if ! grep -q "\-\-help\|usage()" "$script"; then
        echo -e "${YELLOW}⚠ No --help option${NC}"
    fi
    
    # Check for structured output option
    if ! grep -q "\-\-format\|--json\|--output" "$script"; then
        echo -e "${YELLOW}⚠ No structured output option${NC}"
    fi
    
    # Check exit codes
    if ! grep -q "exit [0-9]" "$script"; then
        echo -e "${YELLOW}⚠ No explicit exit codes${NC}"
    fi
    
    if [ "$has_all_metadata" = true ]; then
        COMPLIANT_SCRIPTS=$((COMPLIANT_SCRIPTS + 1))
        echo -e "${GREEN}✅ Script is metadata compliant${NC}"
    else
        echo -e "${RED}❌ Script needs metadata: ${missing_fields[*]}${NC}"
    fi
    
    return 0
}

# Find all script files
for script in "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/*.js "$SCRIPT_DIR"/*.cjs; do
    if [ -f "$script" ]; then
        TOTAL_SCRIPTS=$((TOTAL_SCRIPTS + 1))
        check_script_metadata "$script"
    fi
done

echo -e "\n${BLUE}📊 Script Analysis Summary${NC}"
echo "========================="

# List all scripts with their purpose
echo -e "\n${YELLOW}Current Audit Scripts:${NC}"
echo "1. audit-naming.sh - Comprehensive naming convention checks"
echo "2. audit-backend-naming.sh - Backend-specific naming validation" 
echo "3. audit-css-naming.js - CSS BEM compliance checker"
echo "4. validate-component-styles.cjs - Component-CSS contract validation"
echo "5. find-orphan-styles.sh - Find unused CSS files and classes"
echo "6. audit-spacing-fixes.sh - Analyze spacing-fixes.css usage"
echo "7. audit-audit-scripts.sh - This meta-audit script"

# Consolidation recommendations
echo -e "\n${BLUE}📝 Consolidation Opportunities:${NC}"

echo -e "\n1. ${YELLOW}Merge Similar Scripts:${NC}"
echo "   - audit-naming.sh + audit-backend-naming.sh → unified-naming-audit.sh"
echo "   - Both check naming conventions, could be one script with --frontend/--backend flags"

echo -e "\n2. ${YELLOW}Create Master Audit Runner:${NC}"
echo "   - audit-all.sh that runs all audits and generates unified report"
echo "   - Single entry point for CI/CD integration"

echo -e "\n3. ${YELLOW}Convert to Node.js for consistency:${NC}"
echo "   - Shell scripts (*.sh) and Node scripts (*.js/*.cjs) mixed"
echo "   - Consider converting all to Node.js for better JSON output"

echo -e "\n${BLUE}📋 Required Metadata Template:${NC}"
cat << 'EOF'

For Shell Scripts:
#!/bin/bash

# @id grammar-ops/audit-[name]
# @version 1.0.0
# @type audit-script
# @description Brief description of what this audits
# @dependencies none|[tool-list]
# @audit-targets [what-it-validates]
# @output-formats console|json|junit
# @exit-codes 0=success,1=violations,2=error

For Node.js Scripts:
#!/usr/bin/env node

/**
 * @id grammar-ops/audit-[name]
 * @version 1.0.0
 * @type audit-script
 * @description Brief description of what this audits
 * @dependencies glob@7.2.0,chalk@4.1.0
 * @audit-targets [what-it-validates]
 * @output-formats console|json|junit
 * @exit-codes { 0: "success", 1: "violations", 2: "error" }
 */
EOF

echo -e "\n${BLUE}🎯 Action Items:${NC}"
echo "1. Add metadata headers to all scripts ($(($TOTAL_SCRIPTS - $COMPLIANT_SCRIPTS)) scripts need updates)"
echo "2. Implement --help flag for all scripts"
echo "3. Add --format json option to all scripts"
echo "4. Create audit-all.sh master runner"
echo "5. Consider consolidating naming audits"
echo "6. Standardize on Node.js or Shell (not both)"

# Final stats
echo -e "\n${BLUE}📊 Compliance Score:${NC}"
echo "Total scripts: $TOTAL_SCRIPTS"
echo "Compliant scripts: $COMPLIANT_SCRIPTS"
echo "Compliance rate: $(( $COMPLIANT_SCRIPTS * 100 / $TOTAL_SCRIPTS ))%"

if [ $COMPLIANT_SCRIPTS -eq $TOTAL_SCRIPTS ]; then
    echo -e "\n${GREEN}✨ All scripts are metadata compliant!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ $(($TOTAL_SCRIPTS - $COMPLIANT_SCRIPTS)) scripts need metadata${NC}"
    exit 1
fi
