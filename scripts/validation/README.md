# Validation Scripts

Focused validation scripts for specific Grammar Ops concerns.

## 📋 Available Scripts

### `validate-component-styles.cjs`
Validates that every component has a corresponding CSS file and vice versa.

**Usage:**
```bash
node validation/validate-component-styles.cjs src/components/

# With specific extensions
node validation/validate-component-styles.cjs --css-ext=".module.css" src/
```

**Checks:**
- Every `.tsx` component has a matching CSS file
- Every CSS file has a corresponding component
- CSS imports match file names
- No orphaned style files

### `check-llm-permissions.sh`
Audits LLM read/write permissions across the codebase.

**Usage:**
```bash
./validation/check-llm-permissions.sh

# Check specific directory
./validation/check-llm-permissions.sh src/api/

# Generate security report
./validation/check-llm-permissions.sh --security-report
```

**Reports:**
- Files with `full-edit` permission
- Security-sensitive files with wrong permissions
- Missing LLM directives
- Permission distribution statistics

### `find-orphan-styles.sh`
Finds CSS files without corresponding components.

**Usage:**
```bash
./validation/find-orphan-styles.sh

# Check specific style directory
./validation/find-orphan-styles.sh src/styles/

# Include SCSS files
./validation/find-orphan-styles.sh --include-scss
```

**Features:**
- Detects unused CSS files
- Identifies broken component-style pairs
- Suggests cleanup actions

## 🔧 Configuration

### Environment Variables
```bash
# Set CSS file extension
CSS_EXTENSION=".module.css" ./validation/validate-component-styles.cjs

# Set component extension
COMPONENT_EXTENSION=".tsx" ./validation/find-orphan-styles.sh
```

### Config File
```json
{
  "validation": {
    "componentStyles": {
      "cssExtension": ".css",
      "componentExtension": ".tsx",
      "enforceModules": false
    },
    "llmPermissions": {
      "defaultRead": true,
      "defaultWrite": "suggest-only",
      "securityPaths": ["src/api", "src/auth"]
    }
  }
}
```

## 📊 Output Examples

### Component-Style Validation
```
Component-Style Validation Report
=================================
✅ 45 components with matching styles
❌ 3 components missing styles:
   - src/components/Header/Header.tsx
   - src/components/Footer/Footer.tsx
   - src/components/Nav/Nav.tsx

⚠️  2 orphaned style files:
   - src/styles/components/old-button.css
   - src/styles/components/legacy-card.css

Summary: 93.75% compliance (45/48)
```

### LLM Permissions Report
```
LLM Permissions Audit
====================
Files by permission level:
- full-edit: 156 files (78%)
- suggest-only: 34 files (17%)
- read-only: 10 files (5%)

⚠️  Security Concerns:
- src/api/auth.ts has 'full-edit' (should be 'read-only')
- src/config/database.ts missing LLM directives

✅ All security-sensitive paths properly restricted
```

## 🔄 Integration

### Pre-commit Hook
```bash
#!/bin/sh
# Validate component-style pairing before commit

./scripts/validation/validate-component-styles.cjs src/components/
if [ $? -ne 0 ]; then
    echo "❌ Component-style validation failed"
    exit 1
fi
```

### CI/CD Pipeline
```yaml
- name: Validate Grammar Ops Rules
  run: |
    npm run validate:component-styles
    ./scripts/validation/check-llm-permissions.sh --strict
    ./scripts/validation/find-orphan-styles.sh
```

## 🔍 Troubleshooting

### Script Not Finding Files
- Check file extensions match your project
- Verify paths are relative to script location
- Ensure proper permissions on directories

### False Positives
- Update config with project-specific patterns
- Add exceptions for special cases
- Check for symbolic links

### Performance Issues
- Limit scope to specific directories
- Use `--parallel` flag where available
- Exclude node_modules and build directories

## 📚 Related Documentation

- Component-Style Contract documentation
- LLM Directives specification
- Grammar Ops architecture patterns