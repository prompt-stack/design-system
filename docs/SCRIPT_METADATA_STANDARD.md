# Script Metadata Standard

## Essential Metadata (Required)

These 3-4 fields provide the core information needed:

```bash
#!/bin/bash

# @script audit-naming
# @purpose Validates naming conventions across codebase
# @output console|json
```

That's it! Simple and effective.

## Extended Metadata (Optional)

Add these only when they provide real value:

```bash
# @requires node>=18,bash
# @targets [css, components, backend]
# @example ./audit-naming.sh --format json
```

## Why Minimal is Better

1. **Easy to Maintain** - Developers will actually add it
2. **Quick to Parse** - LLMs can extract info fast
3. **Less Drift** - Fewer fields = less outdated info

## Examples

### Minimal (Recommended)
```bash
#!/bin/bash

# @script find-orphan-styles
# @purpose Find CSS files not imported anywhere
# @output console

# Script starts here...
```

### With Options
```bash
#!/bin/bash

# @script audit-all
# @purpose Run all audit scripts and generate report
# @output console|json|html
# @example ./audit-all.sh --format json > report.json

# Script with more complex needs...
```

### For Node.js
```javascript
#!/usr/bin/env node

/**
 * @script validate-components
 * @purpose Ensure components follow architecture rules
 * @output console|json
 */

// Code starts here...
```

## What NOT to Include

❌ **Version** - Use git for version tracking
❌ **Author** - Use git blame
❌ **Date** - Use git history  
❌ **Long descriptions** - Keep it to one line
❌ **Exit codes** - Document in --help instead

## Integration Benefits

With this minimal metadata, we can:

1. **Auto-generate script registry**
```json
{
  "audit-naming": {
    "purpose": "Validates naming conventions across codebase",
    "output": ["console", "json"]
  }
}
```

2. **Create LLM-friendly interface**
```
Available scripts:
- audit-naming: Validates naming conventions across codebase
- find-orphan-styles: Find CSS files not imported anywhere
```

3. **Build CI/CD pipelines**
```yaml
- run: ./scripts/audit-all.sh --format json
```

## Implementation

Just add 3 lines to each script:
```bash
# @script [short-name]
# @purpose [one-line description]  
# @output [formats]
```

That's 30 seconds per script vs. 5 minutes for complex metadata!