#!/bin/bash

# @file audit-security-patterns
# @purpose Audit codebase for Grammar Ops security patterns compliance
# @security-level critical
# @security-audit required

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default paths
TARGET_PATH="${1:-.}"
REPORT_FILE="security-audit-report.md"

# Security verb patterns
SECURITY_VERBS=(
  "authenticate"
  "authorize"
  "validate"
  "sanitize"
  "encrypt"
  "decrypt"
  "hash"
  "verify"
  "escape"
  "filter"
)

# Initialize counters
TOTAL_FUNCTIONS=0
SECURE_FUNCTIONS=0
INSECURE_PATTERNS=0
CRITICAL_ISSUES=0

echo "🔒 Grammar Ops Security Pattern Audit"
echo "====================================="
echo "Target: $TARGET_PATH"
echo ""

# Function to check if a function name follows security grammar
check_security_grammar() {
  local func_name="$1"
  local file="$2"
  local line_num="$3"
  
  # Check for security-related operations without proper verbs
  if [[ "$func_name" =~ (user|password|token|auth|login|access|permission|data|input|output|html|sql|file|upload) ]]; then
    local has_security_verb=false
    
    for verb in "${SECURITY_VERBS[@]}"; do
      if [[ "$func_name" =~ ^$verb ]]; then
        has_security_verb=true
        break
      fi
    done
    
    if ! $has_security_verb; then
      echo -e "${YELLOW}⚠️  Potential security function without security verb:${NC}"
      echo "   File: $file:$line_num"
      echo "   Function: $func_name"
      echo "   Suggestion: Consider prefixing with: validate, sanitize, authorize, etc."
      echo ""
      ((INSECURE_PATTERNS++))
    fi
  fi
}

# Check for forbidden patterns
check_forbidden_patterns() {
  echo "Checking for forbidden security patterns..."
  
  # SQL injection risks
  if rg -i "exec\(|eval\(|system\(|shell_exec\(" "$TARGET_PATH" --type-add 'web:*.{js,jsx,ts,tsx,py}' -t web; then
    echo -e "${RED}❌ CRITICAL: Found dangerous execution functions${NC}"
    ((CRITICAL_ISSUES++))
  fi
  
  # Hardcoded secrets
  if rg -i "password\s*=\s*[\"'][^\"']+[\"']|api[_-]?key\s*=\s*[\"'][^\"']+[\"']" "$TARGET_PATH" --type-add 'web:*.{js,jsx,ts,tsx,py}' -t web; then
    echo -e "${RED}❌ CRITICAL: Found hardcoded credentials${NC}"
    ((CRITICAL_ISSUES++))
  fi
  
  # Unsafe innerHTML
  if rg "innerHTML\s*=" "$TARGET_PATH" --type-add 'web:*.{js,jsx,ts,tsx}' -t web | grep -v "sanitize"; then
    echo -e "${RED}❌ CRITICAL: Found unsafe innerHTML usage${NC}"
    ((CRITICAL_ISSUES++))
  fi
}

# Analyze TypeScript/JavaScript files
analyze_ts_files() {
  echo "Analyzing TypeScript/JavaScript security patterns..."
  
  # Find function declarations
  rg "^(export\s+)?(async\s+)?function\s+(\w+)|^(export\s+)?const\s+(\w+)\s*=\s*(async\s*)?\(" "$TARGET_PATH" \
    --type ts --type js -n | while IFS=: read -r file line_num content; do
    
    # Extract function name
    if [[ "$content" =~ function[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
      func_name="${BASH_REMATCH[1]}"
    elif [[ "$content" =~ const[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*= ]]; then
      func_name="${BASH_REMATCH[1]}"
    else
      continue
    fi
    
    ((TOTAL_FUNCTIONS++))
    
    # Check if it follows security grammar
    check_security_grammar "$func_name" "$file" "$line_num"
    
    # Count secure functions
    for verb in "${SECURITY_VERBS[@]}"; do
      if [[ "$func_name" =~ ^$verb ]]; then
        ((SECURE_FUNCTIONS++))
        break
      fi
    done
  done
}

# Analyze Python files
analyze_python_files() {
  echo "Analyzing Python security patterns..."
  
  rg "^(async\s+)?def\s+(\w+)" "$TARGET_PATH" --type py -n | while IFS=: read -r file line_num content; do
    if [[ "$content" =~ def[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
      func_name="${BASH_REMATCH[1]}"
      ((TOTAL_FUNCTIONS++))
      
      check_security_grammar "$func_name" "$file" "$line_num"
      
      for verb in "${SECURITY_VERBS[@]}"; do
        if [[ "$func_name" =~ ^$verb ]]; then
          ((SECURE_FUNCTIONS++))
          break
        fi
      done
    fi
  done
}

# Check for security metadata
check_security_metadata() {
  echo "Checking security metadata compliance..."
  
  local files_with_security_level=$(rg -l "@security-level" "$TARGET_PATH" --type-add 'code:*.{js,jsx,ts,tsx,py}' -t code | wc -l)
  local critical_files=$(rg -l "@security-level critical" "$TARGET_PATH" --type-add 'code:*.{js,jsx,ts,tsx,py}' -t code | wc -l)
  
  echo "Files with security level metadata: $files_with_security_level"
  echo "Files marked as critical: $critical_files"
}

# Generate report
generate_report() {
  cat > "$REPORT_FILE" << EOF
# Grammar Ops Security Audit Report

Generated: $(date)

## Summary

- Total Functions Analyzed: $TOTAL_FUNCTIONS
- Functions Following Security Grammar: $SECURE_FUNCTIONS
- Insecure Pattern Warnings: $INSECURE_PATTERNS
- Critical Security Issues: $CRITICAL_ISSUES

## Compliance Score

Security Grammar Compliance: $(( SECURE_FUNCTIONS * 100 / (TOTAL_FUNCTIONS + 1) ))%

## Critical Issues

EOF

  if [ $CRITICAL_ISSUES -gt 0 ]; then
    echo "⚠️  Found $CRITICAL_ISSUES critical security issues that require immediate attention!" >> "$REPORT_FILE"
  else
    echo "✅ No critical security issues found." >> "$REPORT_FILE"
  fi

  cat >> "$REPORT_FILE" << EOF

## Recommendations

1. Prefix all security-related functions with appropriate verbs:
   - User input handling: \`validateUserInput()\`, \`sanitizeFormData()\`
   - Authentication: \`authenticateUser()\`, \`verifyToken()\`
   - Authorization: \`authorizeAccess()\`, \`checkPermissions()\`
   - Data protection: \`encryptSensitiveData()\`, \`hashPassword()\`

2. Add security metadata to critical files:
   \`\`\`
   /**
    * @security-level critical
    * @security-features ["authentication", "encryption"]
    * @security-audit required
    */
   \`\`\`

3. Implement security test coverage for all security functions

4. Regular security audits using Grammar Ops patterns
EOF
}

# Main execution
check_forbidden_patterns
analyze_ts_files
analyze_python_files
check_security_metadata
generate_report

# Output summary
echo ""
echo "====================================="
echo -e "${GREEN}✅ Security Audit Complete${NC}"
echo ""
echo "Security Grammar Compliance: $(( SECURE_FUNCTIONS * 100 / (TOTAL_FUNCTIONS + 1) ))%"
echo "Critical Issues: $CRITICAL_ISSUES"
echo "Warnings: $INSECURE_PATTERNS"
echo ""
echo "Full report saved to: $REPORT_FILE"

# Exit with error if critical issues found
if [ $CRITICAL_ISSUES -gt 0 ]; then
  exit 1
fi