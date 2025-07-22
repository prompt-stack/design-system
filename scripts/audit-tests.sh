#!/bin/bash

# Test Coverage Audit Script
# Analyzes test coverage and identifies untested components

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Test Coverage Audit ==="
echo

# Function to check if tests exist for a component
check_component_tests() {
    local component_file=$1
    local test_file="${component_file%.tsx}.test.tsx"
    local spec_file="${component_file%.tsx}.spec.tsx"
    
    if [[ -f "$test_file" ]] || [[ -f "$spec_file" ]]; then
        echo -e "${GREEN}✓${NC} $component_file has tests"
        return 0
    else
        echo -e "${RED}✗${NC} $component_file missing tests"
        return 1
    fi
}

# Function to check test coverage
check_coverage() {
    local coverage_file="coverage/coverage-summary.json"
    
    if [[ -f "$coverage_file" ]]; then
        echo "=== Coverage Summary ==="
        # Extract coverage percentages
        node -e "
            const coverage = require('./$coverage_file');
            const total = coverage.total;
            
            console.log('Lines:', total.lines.pct + '%');
            console.log('Statements:', total.statements.pct + '%');
            console.log('Functions:', total.functions.pct + '%');
            console.log('Branches:', total.branches.pct + '%');
            
            // Check thresholds
            const thresholds = { lines: 80, statements: 80, functions: 70, branches: 70 };
            let failed = false;
            
            Object.keys(thresholds).forEach(key => {
                if (total[key].pct < thresholds[key]) {
                    console.error('\x1b[31mFAILED:\x1b[0m', key, 'coverage is below threshold');
                    failed = true;
                }
            });
            
            process.exit(failed ? 1 : 0);
        "
    else
        echo -e "${YELLOW}Warning:${NC} No coverage report found. Run 'npm test -- --coverage' first."
    fi
}

# Find all components without tests
echo "=== Component Test Audit ==="
components_without_tests=0
total_components=0

for component in $(find src/components -name "*.tsx" -not -name "*.test.tsx" -not -name "*.spec.tsx" -not -name "*.stories.tsx"); do
    total_components=$((total_components + 1))
    if ! check_component_tests "$component"; then
        components_without_tests=$((components_without_tests + 1))
    fi
done

echo
echo "Total components: $total_components"
echo "Components without tests: $components_without_tests"
echo "Test coverage: $((($total_components - $components_without_tests) * 100 / $total_components))%"

# Check hooks
echo
echo "=== Hook Test Audit ==="
hooks_without_tests=0
total_hooks=0

for hook in $(find src/hooks -name "*.ts" -not -name "*.test.ts" -not -name "*.spec.ts"); do
    total_hooks=$((total_hooks + 1))
    test_file="${hook%.ts}.test.ts"
    if [[ ! -f "$test_file" ]]; then
        echo -e "${RED}✗${NC} $hook missing tests"
        hooks_without_tests=$((hooks_without_tests + 1))
    fi
done

if [[ $total_hooks -gt 0 ]]; then
    echo "Total hooks: $total_hooks"
    echo "Hooks without tests: $hooks_without_tests"
fi

# Check services
echo
echo "=== Service Test Audit ==="
services_without_tests=0
total_services=0

for service in $(find src/services -name "*.ts" -not -name "*.test.ts" -not -name "*.spec.ts"); do
    total_services=$((total_services + 1))
    test_file="${service%.ts}.test.ts"
    if [[ ! -f "$test_file" ]]; then
        echo -e "${RED}✗${NC} $service missing tests"
        services_without_tests=$((services_without_tests + 1))
    fi
done

if [[ $total_services -gt 0 ]]; then
    echo "Total services: $total_services"
    echo "Services without tests: $services_without_tests"
fi

# Check E2E test coverage
echo
echo "=== E2E Test Coverage ==="
if [[ -d "cypress/e2e" ]]; then
    e2e_tests=$(find cypress/e2e -name "*.cy.ts" | wc -l)
    echo "E2E test files: $e2e_tests"
    
    # Check for critical user journeys
    critical_journeys=("auth" "content" "upload" "search")
    missing_journeys=()
    
    for journey in "${critical_journeys[@]}"; do
        if ! find cypress/e2e -name "*${journey}*.cy.ts" | grep -q .; then
            missing_journeys+=("$journey")
        fi
    done
    
    if [[ ${#missing_journeys[@]} -gt 0 ]]; then
        echo -e "${YELLOW}Missing E2E tests for:${NC} ${missing_journeys[*]}"
    fi
else
    echo -e "${RED}No E2E tests found${NC}"
fi

# Run coverage check
echo
check_coverage

# Summary
echo
echo "=== Summary ==="
total_missing=$((components_without_tests + hooks_without_tests + services_without_tests))

if [[ $total_missing -eq 0 ]]; then
    echo -e "${GREEN}All code has test coverage!${NC}"
    exit 0
else
    echo -e "${RED}Missing tests: $total_missing files${NC}"
    echo "Run 'npm run generate:test' to create test templates"
    exit 1
fi