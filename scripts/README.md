# Grammar Ops Scripts

This directory contains all scripts for implementing, validating, and maintaining Grammar Ops conventions across your codebase.

## 📁 Directory Structure

```
scripts/
├── metadata/        # Scripts for managing file metadata
├── audit/          # Scripts for auditing compliance
├── validation/     # Scripts for validating specific patterns
├── generation/     # Scripts for generating code
├── utilities/      # Utility and maintenance scripts
└── lib/           # Shared functions and libraries
```

## 🚀 Quick Start

### Running the Reorganization
If scripts are not yet organized, run:
```bash
./reorganize-scripts.sh
```

### Common Tasks

#### Add Metadata to Files
```bash
# Add metadata to all JavaScript files
./metadata/add/add-js-metadata.sh src/

# Add LLM directives to TypeScript files
./metadata/add/add-llm-directives.sh src/**/*.ts
```

#### Audit Your Codebase
```bash
# Run all audits
./audit/compliance/audit-all.sh

# Audit naming conventions only
./audit/naming/audit-naming.sh

# Audit specific component
./audit/components/audit-component.sh src/components/Button
```

#### Generate New Code
```bash
# Generate a new component with Grammar Ops patterns
./generation/generate-component.js Button

# Generate tests for a component
./generation/generate-test.sh src/components/Button
```

## 📋 Script Categories

### Metadata Scripts (`/metadata/`)
Scripts for adding and managing file metadata headers that enable LLM navigation and understanding.

- **add/**: Scripts to add metadata to different file types
- **update/**: Scripts to update or migrate existing metadata
- **scan-metadata.sh**: Scan and report on metadata coverage

### Audit Scripts (`/audit/`)
Scripts for validating Grammar Ops compliance across your codebase.

- **naming/**: Validate naming conventions (functions, components, etc.)
- **components/**: Audit component structure and organization
- **compliance/**: General compliance and quality checks
- **meta/**: Audit the audit scripts themselves
- **tests/**: Validate test patterns and coverage
- **reports/**: Generated audit reports

### Validation Scripts (`/validation/`)
Focused validation scripts for specific concerns.

- Component-style pairing validation
- LLM permission checking
- Orphan file detection

### Generation Scripts (`/generation/`)
Code generation following Grammar Ops patterns.

- Component generation with proper structure
- Test generation with grammar patterns

### Utility Scripts (`/utilities/`)
Maintenance and helper scripts.

- Path updates
- Script registry building
- Batch operations

### Shared Libraries (`/lib/`)
Common functions used across multiple scripts.

## 🔧 Configuration

Many scripts support configuration through:

1. **Command-line arguments**
   ```bash
   ./audit/naming/audit-naming.sh --strict src/
   ```

2. **Environment variables**
   ```bash
   GRAMMAR_OPS_STRICT=true ./audit/compliance/audit-all.sh
   ```

3. **Config files**
   ```bash
   # .grammarops.config.json in project root
   {
     "audit": {
       "strict": true,
       "exclude": ["vendor/", "build/"]
     }
   }
   ```

## 📝 Writing New Scripts

When adding new scripts:

1. **Use proper metadata header**:
   ```bash
   #!/bin/bash
   # @script script-name
   # @purpose Brief description
   # @usage ./script-name.sh [options] <args>
   # @dependencies List any required tools
   ```

2. **Place in appropriate directory** based on primary function

3. **Source shared functions** when available:
   ```bash
   source "$(dirname "$0")/../lib/common-functions.sh"
   ```

4. **Follow Grammar Ops naming**:
   - Verb-first for action scripts: `audit-naming.sh`
   - Noun-based for utilities: `script-registry.sh`

## 🔍 Troubleshooting

### Permission Errors
```bash
chmod +x scripts/**/*.sh
```

### Path Issues
Scripts assume they're run from the project root or scripts directory. Use absolute paths if running from elsewhere.

### Missing Dependencies
Most scripts require:
- `jq` for JSON processing
- `ripgrep` (rg) for fast searching
- `node` for JavaScript scripts

Install with:
```bash
# macOS
brew install jq ripgrep node

# Ubuntu/Debian
apt-get install jq ripgrep nodejs
```

## 📚 Further Documentation

- See individual directory README files for detailed script documentation
- Check the Grammar Ops knowledge library for conceptual understanding
- Review script source for inline documentation

## 🤝 Contributing

When contributing scripts:
1. Follow the organization structure
2. Include proper metadata headers
3. Add documentation to relevant README
4. Use shared functions from lib/ when possible
5. Test on multiple file types/edge cases