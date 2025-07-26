# Metadata Scripts

Scripts for managing file metadata headers that enable LLM navigation and Grammar Ops compliance.

## 📁 Directory Structure

```
metadata/
├── add/              # Scripts to add metadata to files
├── update/           # Scripts to update/migrate metadata
└── scan-metadata.sh  # Scan and report metadata coverage
```

## 🎯 Purpose

File metadata enables:
- **LLM Navigation**: 20-line principle for efficient AI understanding
- **Dependency Tracking**: Know what files import/export
- **Permission Control**: Define LLM read/write permissions
- **Architecture Documentation**: Layer and purpose definitions

## 📝 Metadata Format

Standard metadata header:
```typescript
/**
 * @file components/Button
 * @purpose Reusable button component with variants
 * @layer primitive
 * @dependencies None
 * @llm-read true
 * @llm-write full-edit
 * @llm-role utility
 */
```

## 🚀 Common Usage

### Add Metadata to TypeScript/JavaScript
```bash
# Add to all TypeScript files
./add/add-js-metadata.sh src/**/*.ts

# Add to specific directory
./add/add-js-metadata.sh src/components/
```

### Add LLM Directives
```bash
# Add LLM permissions to all files
./add/add-llm-directives.sh src/

# Add with specific permissions
LLM_WRITE_PERMISSION="read-only" ./add/add-llm-directives.sh src/api/
```

### Add Language-Specific Metadata
```bash
# Python files
./add/add-python-metadata.sh **/*.py

# CSS files
./add/add-css-metadata.sh src/styles/

# Shell scripts
./add/add-shell-metadata.sh scripts/
```

### Update Existing Metadata
```bash
# Migrate old format to new
./update/migrate-metadata.sh

# Batch update metadata fields
./update/update-metadata-batch.sh --field "layer" --value "feature"

# Smart update based on file analysis
./update/update-metadata-smart.sh
```

### Scan Metadata Coverage
```bash
# Generate coverage report
./scan-metadata.sh > metadata-report.txt

# Check specific directory
./scan-metadata.sh src/components/
```

## 🔧 Script Details

### Add Scripts (`/add/`)

#### `add-universal-metadata.sh`
Intelligent metadata addition that detects file type and applies appropriate metadata.

```bash
# Automatically detects file type and adds metadata
./add/add-universal-metadata.sh src/
```

#### `add-js-metadata.sh`
Adds metadata to JavaScript/TypeScript files.

Options:
- `--preserve-existing`: Don't overwrite existing metadata
- `--interactive`: Prompt for metadata values
- `--dry-run`: Show what would be added

#### `add-llm-directives.sh`
Specifically adds LLM permission directives.

Environment variables:
- `LLM_READ_DEFAULT`: Default read permission (true/false)
- `LLM_WRITE_DEFAULT`: Default write permission (full-edit/suggest-only/read-only)
- `LLM_ROLE_DEFAULT`: Default role (utility/entrypoint/pure-view/async-service)

### Update Scripts (`/update/`)

#### `migrate-metadata.sh`
Migrates metadata from old formats to current standard.

Features:
- Preserves existing data
- Adds missing required fields
- Standardizes formatting

#### `update-metadata-batch.sh`
Batch updates specific metadata fields.

```bash
# Update all components to primitive layer
./update/update-metadata-batch.sh \
  --pattern "src/components/**/*.tsx" \
  --field "layer" \
  --value "primitive"
```

#### `update-metadata-smart.sh`
Intelligently updates metadata based on file analysis.

Features:
- Infers layer from file location
- Detects dependencies automatically
- Suggests appropriate LLM permissions

## 📋 Best Practices

1. **Run on Version Control**: Always run with Git so you can review changes
2. **Start with Scan**: Use `scan-metadata.sh` to understand current state
3. **Test First**: Use `--dry-run` to preview changes
4. **Layer by Layer**: Add metadata incrementally by directory
5. **Review LLM Permissions**: Manually review security-sensitive files

## 🔍 Troubleshooting

### Metadata Not Added
- Check file has standard comment syntax
- Ensure file isn't in exclude list
- Verify file permissions

### Wrong Metadata Values
- Check environment variables
- Review config files
- Use `--interactive` mode for manual control

### Performance Issues
- Process directories separately rather than entire codebase
- Use file patterns to limit scope
- Run in parallel: `find . -type f -name "*.ts" | xargs -P 4 -I {} ./add/add-js-metadata.sh {}`

## 📚 Related Documentation

- See knowledge library: `/01-architecture/metadata-system/`
- Grammar Ops metadata standard documentation
- LLM directives documentation