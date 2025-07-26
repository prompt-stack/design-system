# Utility Scripts

Maintenance and helper scripts for Grammar Ops operations.

## 📋 Available Scripts

### `build-script-registry.sh`
Builds a registry of all Grammar Ops scripts with metadata.

**Usage:**
```bash
./utilities/build-script-registry.sh

# Output to specific file
./utilities/build-script-registry.sh > script-registry.json

# Include script content analysis
./utilities/build-script-registry.sh --analyze
```

**Output Example:**
```json
{
  "scripts": [
    {
      "path": "audit/naming/audit-naming.sh",
      "purpose": "Audit codebase for naming convention compliance",
      "dependencies": ["jq", "ripgrep"],
      "usage": "./audit-naming.sh [options] <path>",
      "category": "audit",
      "lastModified": "2024-07-26"
    }
  ],
  "total": 35,
  "categories": {
    "audit": 15,
    "metadata": 10,
    "generation": 2,
    "validation": 3,
    "utilities": 5
  }
}
```

### `rename-scripts.sh`
Batch rename scripts to follow Grammar Ops naming conventions.

**Usage:**
```bash
# Dry run to see what would change
./utilities/rename-scripts.sh --dry-run

# Rename scripts interactively
./utilities/rename-scripts.sh --interactive

# Rename with automatic pattern detection
./utilities/rename-scripts.sh --auto
```

**Features:**
- Detects script purpose from content
- Suggests Grammar-compliant names
- Updates references in other scripts
- Creates redirect scripts for compatibility

### `update-paths.sh`
Updates script paths after reorganization.

**Usage:**
```bash
# Update all path references
./utilities/update-paths.sh

# Update specific directory
./utilities/update-paths.sh audit/

# Check for broken paths only
./utilities/update-paths.sh --check-only
```

**Updates:**
- Script-to-script references
- README documentation paths
- Config file paths
- Symbolic links

## 🔧 Additional Utilities

### Script Analysis
```bash
# Analyze script complexity
./utilities/analyze-scripts.sh

# Output:
# Script Complexity Report
# =======================
# Simple scripts: 23
# Medium complexity: 10
# Complex scripts: 2
# 
# Most complex:
# 1. audit-full-stack-naming.sh (312 lines, 15 functions)
# 2. migrate-metadata.sh (287 lines, 12 functions)
```

### Dependency Check
```bash
# Check all script dependencies
./utilities/check-dependencies.sh

# Output:
# Checking script dependencies...
# ✅ jq: installed (1.6)
# ✅ ripgrep: installed (13.0.0)
# ✅ node: installed (18.17.0)
# ❌ parallel: not installed
# 
# Scripts requiring 'parallel':
# - audit/compliance/audit-all.sh
# - metadata/update/update-metadata-batch.sh
```

### Performance Profiling
```bash
# Profile script execution times
./utilities/profile-scripts.sh

# Output:
# Script Performance Profile
# =========================
# Fastest scripts (<1s):
# - check-llm-permissions.sh: 0.3s
# - find-orphan-styles.sh: 0.5s
# 
# Slowest scripts (>10s):
# - audit-all.sh: 45.2s
# - audit-full-stack-naming.sh: 23.1s
```

## 🔄 Maintenance Tasks

### Regular Maintenance
```bash
# Weekly maintenance routine
./utilities/maintenance-routine.sh

# Tasks performed:
# 1. Check for unused scripts
# 2. Verify all scripts are executable
# 3. Update script registry
# 4. Check for outdated patterns
# 5. Generate usage statistics
```

### Script Cleanup
```bash
# Find duplicate functionality
./utilities/find-duplicate-scripts.sh

# Remove backup files
./utilities/clean-backups.sh --older-than 30d

# Archive unused scripts
./utilities/archive-unused.sh
```

## 📊 Registry Management

### Building the Registry
The script registry is essential for:
- Documentation generation
- Dependency tracking
- Script discovery
- Usage analytics

### Registry Schema
```json
{
  "version": "1.0",
  "generated": "2024-07-26T10:30:00Z",
  "scripts": [{
    "path": "string",
    "purpose": "string",
    "category": "audit|metadata|generation|validation|utility",
    "dependencies": ["string"],
    "usage": "string",
    "metadata": {
      "author": "string",
      "created": "date",
      "modified": "date",
      "complexity": "simple|medium|complex"
    }
  }]
}
```

## 🛠️ Development Utilities

### Script Template
```bash
# Create new script from template
./utilities/new-script.sh audit-new-feature

# Generates:
# - audit/audit-new-feature.sh
# - Proper metadata header
# - Common function imports
# - Basic structure
```

### Script Testing
```bash
# Test script in isolation
./utilities/test-script.sh audit/naming/audit-naming.sh

# Run with test data
./utilities/test-script.sh generation/generate-component.js --test-data
```

## 🔍 Troubleshooting Utilities

### Debug Mode
```bash
# Run any script in debug mode
DEBUG=1 ./utilities/debug-wrapper.sh audit/audit-all.sh

# Features:
# - Verbose output
# - Execution timing
# - Variable dumps
# - Call stack on error
```

### Script Doctor
```bash
# Diagnose script issues
./utilities/script-doctor.sh audit/naming/audit-naming.sh

# Checks:
# - Syntax errors
# - Missing dependencies
# - Permission issues
# - Path problems
# - Common anti-patterns
```

## 📚 Best Practices

1. **Run Registry Build**: After adding/modifying scripts
2. **Check Dependencies**: Before distributing scripts
3. **Profile Performance**: For scripts run frequently
4. **Archive Old Scripts**: Don't delete, archive with context
5. **Document Changes**: Update registry when modifying

## 🔗 Integration

### CI/CD Integration
```yaml
- name: Validate Scripts
  run: |
    ./scripts/utilities/check-dependencies.sh
    ./scripts/utilities/build-script-registry.sh
    ./scripts/utilities/test-all-scripts.sh
```

### Git Hooks
```bash
# pre-commit hook
./scripts/utilities/validate-scripts.sh --staged
```

## 📈 Analytics

The utilities can generate usage analytics:
```bash
./utilities/script-analytics.sh --last-30-days

# Output:
# Most used scripts:
# 1. audit-naming.sh: 156 runs
# 2. generate-component.js: 89 runs
# 3. add-metadata.sh: 67 runs
# 
# Error rate: 2.3%
# Average execution time: 3.4s
```