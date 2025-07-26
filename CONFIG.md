# Grammar Ops Configuration Guide

## Overview

The `.grammarops.config.json` file is the central configuration for Grammar Ops in your project. It defines:

- Grammar rules and patterns
- File organization and paths
- Validation and audit settings
- Testing requirements
- LLM permissions
- Tool configurations

## Configuration Sections

### 🔤 Grammar Rules (`grammar`)

Defines the verb taxonomy and allowed prefixes for different code elements:

```json
"grammar": {
  "verbTaxonomy": {
    "data": ["fetch", "get", "create", "update", "delete"],
    "view": ["render", "display", "show", "hide"],
    "state": ["use", "set", "clear", "reset"]
  },
  "allowedPrefixes": {
    "boolean": ["is", "has", "can", "should"],
    "hook": ["use"],
    "hoc": ["with"]
  }
}
```

**Usage**: Scripts and tools reference these lists to validate naming conventions.

### 🏗️ Layer Architecture (`layers`)

Defines architectural layers and their import rules:

```json
"layers": {
  "primitive": {
    "path": "components/primitives",
    "canImport": [],
    "metadata": {
      "layer": "primitive",
      "dependencies": "None"
    }
  }
}
```

**Key Points**:
- Primitives can't import anything
- Composed can import primitives
- Features can import everything below

### 📝 Metadata Requirements (`metadata`)

Specifies required and optional metadata fields:

```json
"metadata": {
  "required": ["@file", "@purpose", "@layer"],
  "recommended": ["@dependencies", "@llm-read", "@llm-write"],
  "defaults": {
    "llm-read": true,
    "llm-write": "full-edit"
  }
}
```

### 🤖 LLM Directives (`llmDirectives`)

Controls AI permissions and roles:

```json
"llmDirectives": {
  "writePermissions": {
    "full-edit": ["components/", "hooks/", "utils/"],
    "suggest-only": ["pages/", "*.config.*"],
    "read-only": ["api/", "auth/", "migrations/"]
  }
}
```

**Security**: Critical files are read-only to prevent AI modifications.

### ✅ Validation Settings (`validation`)

Controls what Grammar Ops enforces:

```json
"validation": {
  "strictMode": true,
  "enforceNaming": true,
  "requireTests": true,
  "requireMetadata": true,
  "componentStylePairing": true
}
```

### 🧪 Testing Configuration (`testing`)

Defines test requirements and patterns:

```json
"testing": {
  "coverageThresholds": {
    "components": { "statements": 80 },
    "hooks": { "statements": 90 },
    "utils": { "statements": 95 }
  },
  "patterns": {
    "testNaming": "should {verb} {condition}"
  }
}
```

**Note**: Different thresholds for different file types based on testability.

### 📊 Audit Configuration (`audit`)

Controls compliance checking:

```json
"audit": {
  "thresholds": {
    "naming": 95,
    "architecture": 90,
    "overall": 90
  }
}
```

**Usage**: Pre-commit hooks can enforce these thresholds.

### 🛠️ Script Paths (`scripts`)

Maps script locations after reorganization:

```json
"scripts": {
  "aliases": {
    "add-metadata": "scripts/metadata/add/add-universal-metadata.sh",
    "audit-all": "scripts/audit/compliance/audit-all.sh"
  }
}
```

## Using the Configuration

### In Scripts

```bash
# Scripts can read config values
CONFIG=$(cat .grammarops.config.json)
STRICT_MODE=$(echo $CONFIG | jq -r '.validation.strictMode')
```

### In Node.js Tools

```javascript
const config = require('./.grammarops.config.json');
const verbs = config.grammar.verbTaxonomy.data;
```

### In VS Code

The IDE section configures VS Code integration:
- Auto-formatting on save
- File associations
- Recommended extensions

## Environment-Specific Overrides

Create environment-specific configs:

```bash
# Development
.grammarops.config.dev.json

# CI/CD
.grammarops.config.ci.json

# Production
.grammarops.config.prod.json
```

## Extending the Configuration

### Adding Custom Verbs

```json
"grammar": {
  "verbTaxonomy": {
    "custom": ["process", "transform", "calculate"]
  }
}
```

### Adding New Paths

```json
"paths": {
  "customFeature": "../src/features/custom"
}
```

### Adjusting Thresholds

Lower thresholds during migration:

```json
"audit": {
  "thresholds": {
    "naming": 80,  // Temporary during migration
    "overall": 75
  }
}
```

## Best Practices

1. **Version Control**: Always commit config changes
2. **Team Agreement**: Discuss threshold changes with team
3. **Gradual Adoption**: Start with lower thresholds, increase over time
4. **Document Changes**: Add comments for custom patterns
5. **Regular Review**: Review and update quarterly

## Validation

Validate your configuration:

```bash
# Check JSON syntax
jq . .grammarops.config.json

# Validate against schema
node scripts/utilities/validate-config.js

# Test with audit
./scripts/audit/compliance/audit-all.sh --config .grammarops.config.json
```

## Migration Path

When adopting Grammar Ops:

1. Start with minimal config
2. Run learning tools to understand patterns
3. Gradually enable validations
4. Increase thresholds over time
5. Add custom patterns as needed