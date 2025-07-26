# Audit Scripts

Scripts for auditing codebase compliance with Grammar Ops conventions.

## 📁 Directory Structure

```
audit/
├── naming/       # Naming convention audits
├── components/   # Component structure audits
├── compliance/   # General compliance checks
├── meta/         # Audit the audit scripts
├── tests/        # Test pattern audits
└── reports/      # Generated audit reports
```

## 🎯 Purpose

Audit scripts ensure:
- **Naming Compliance**: Functions, components, and files follow Grammar rules
- **Architectural Integrity**: Layer boundaries are respected
- **Pattern Consistency**: Coding patterns match Grammar Ops standards
- **Quality Metrics**: Track compliance over time

## 🚀 Quick Start

### Run All Audits
```bash
./compliance/audit-all.sh

# With detailed output
./compliance/audit-all.sh --verbose

# Generate HTML report
./compliance/audit-all.sh --format html > report.html
```

### Audit Specific Areas
```bash
# Naming conventions only
./naming/audit-naming.sh src/

# Component structure
./components/audit-all-components.sh

# Backend API naming
./naming/audit-backend-naming.sh server/
```

## 📋 Audit Categories

### Naming Audits (`/naming/`)

#### `audit-naming.sh`
Core naming convention audit for all code.

Checks:
- Function names start with verbs
- Components use PascalCase
- Hooks start with 'use'
- Booleans have is/has/can prefix

```bash
./naming/audit-naming.sh src/
# Output: 
# ✅ 1,234 functions correctly named
# ❌ 12 functions missing verb prefix
# ✅ 89 components properly cased
# ⚠️  3 hooks missing 'use' prefix
```

#### `audit-css-naming.js`
CSS and style file naming audit.

Checks:
- BEM convention compliance
- Kebab-case usage
- Component-CSS pairing

#### Language-Specific Audits
- `audit-backend-naming.sh`: Node.js/Express patterns
- `audit-python-naming.sh`: Python snake_case conventions
- `audit-database-naming.sh`: SQL naming standards

### Component Audits (`/components/`)

#### `audit-component.sh`
Audits individual component for Grammar Ops compliance.

```bash
./components/audit-component.sh src/components/Button

# Checks:
# - File structure
# - Export patterns
# - Metadata presence
# - Style pairing
# - Test coverage
```

#### `audit-all-components.sh`
Batch audit of all components with summary report.

Features:
- Parallel processing
- Progress indication
- Exportable results

### Compliance Audits (`/compliance/`)

#### `audit-all.sh`
Master audit script that runs all checks.

Options:
- `--fix`: Auto-fix where possible
- `--strict`: Fail on any violation
- `--exclude`: Exclude patterns
- `--format`: Output format (text/json/html/junit)

#### `audit-naming-compliance.sh`
Focused compliance check against naming rules.

#### `audit-spacing-fixes.sh`
Code formatting and spacing audit.

### Meta Audits (`/meta/`)

#### `audit-audit-scripts.sh`
Ensures audit scripts themselves follow Grammar Ops.

Checks:
- Script naming conventions
- Metadata headers
- Function patterns
- Error handling

### Test Audits (`/tests/`)

#### `audit-tests.sh`
Validates test files follow test-driven grammar.

Checks:
- Test naming patterns ("should + verb")
- Test organization
- Coverage requirements
- Mock patterns

## 🔧 Configuration

### Config File (`.grammarops.audit.json`)
```json
{
  "audit": {
    "strict": false,
    "exclude": ["vendor/", "build/", "*.min.js"],
    "naming": {
      "allowedVerbs": ["get", "set", "fetch", "create", "update", "delete"],
      "componentSuffix": ["Page", "Modal", "Dialog"],
      "hookPrefix": "use"
    },
    "thresholds": {
      "naming": 95,
      "components": 90,
      "tests": 80
    }
  }
}
```

### Environment Variables
```bash
# Set audit strictness
GRAMMAR_OPS_STRICT=true ./compliance/audit-all.sh

# Custom verb list
ALLOWED_VERBS="get,set,fetch,create" ./naming/audit-naming.sh

# Output format
AUDIT_FORMAT=json ./compliance/audit-all.sh
```

## 📊 Output Formats

### Text (Default)
```
Grammar Ops Audit Report
========================
✅ Naming Compliance: 97.3% (1,423/1,463)
✅ Component Structure: 94.2% (89/94)
⚠️  Test Coverage: 78.9% (below 80% threshold)
❌ CSS Naming: 67.4% (needs attention)

Top Issues:
1. Missing verb prefix: 23 functions
2. Incorrect casing: 12 components
3. Missing tests: 18 components
```

### JSON
```json
{
  "summary": {
    "overall": 91.2,
    "naming": 97.3,
    "components": 94.2,
    "tests": 78.9,
    "css": 67.4
  },
  "violations": [
    {
      "file": "src/utils/data.js",
      "line": 23,
      "type": "naming",
      "message": "Function 'processData' should be 'processUserData'"
    }
  ]
}
```

### JUnit XML
For CI/CD integration:
```bash
./compliance/audit-all.sh --format junit > test-results.xml
```

## 🔄 Continuous Integration

### GitHub Actions Example
```yaml
- name: Grammar Ops Audit
  run: |
    ./scripts/audit/compliance/audit-all.sh --format junit > grammar-ops-results.xml
    
- name: Publish Test Results
  uses: EnricoMi/publish-unit-test-result-action@v2
  if: always()
  with:
    files: grammar-ops-results.xml
```

### Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run naming audit on staged files
git diff --cached --name-only | \
  grep -E '\.(js|ts|jsx|tsx)$' | \
  xargs ./scripts/audit/naming/audit-naming.sh --strict

if [ $? -ne 0 ]; then
  echo "❌ Grammar Ops naming violations found. Please fix before committing."
  exit 1
fi
```

## 📈 Tracking Progress

### Generate Trend Report
```bash
# Run daily and save results
./compliance/audit-all.sh --format json > "reports/audit-$(date +%Y%m%d).json"

# Generate trend analysis
./reports/generate-trend-report.sh reports/audit-*.json
```

### Compliance Dashboard
Results can be visualized in:
- CI/CD dashboards
- Custom web dashboards
- IDE extensions

## 🔍 Troubleshooting

### Audit Takes Too Long
- Use `--parallel` flag for multi-core processing
- Limit scope with specific paths
- Exclude large generated files

### Too Many False Positives
- Update allowed verbs in config
- Add exceptions for framework patterns
- Use `--learn` mode to detect patterns

### Missing Dependencies
Required tools:
- `ripgrep` (rg): Fast file searching
- `jq`: JSON processing
- `node`: For JavaScript-based audits

## 📚 Related Documentation

- Grammar Ops naming conventions
- Test-driven grammar patterns
- Component architecture rules
- Knowledge library: `/04-validation/audit-system/`