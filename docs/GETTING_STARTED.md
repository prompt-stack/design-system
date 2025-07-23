# Getting Started with Grammar-Ops

This guide will help you get up and running with Grammar-Ops in minutes.

## Installation

### Option 1: Add to PATH (Recommended)
```bash
cd /path/to/grammar-ops
export PATH="$PWD/bin:$PATH"

# Add to your shell profile for permanent access
echo 'export PATH="/path/to/grammar-ops/bin:$PATH"' >> ~/.bashrc
```

### Option 2: Use Directly
```bash
/path/to/grammar-ops/bin/grammar-ops analyze .
```

### Option 3: Create Alias
```bash
alias grammar-ops='/path/to/grammar-ops/bin/grammar-ops'
```

## First Steps

### 1. Detect Your Frameworks

See what frameworks Grammar-Ops detects in your project:

```bash
grammar-ops detect /path/to/your/project
```

Output:
```
Framework Detection Report
==========================

Detected Frameworks: fastapi, pytest
Evidence:

fastapi:
  - Import found: fastapi in main.py
  - Pattern found: app = FastAPI() in main.py
  - Decorator found: @app.get in routes.py

Active Idioms:
  - response_factories: True
  - cli_style: rails
```

### 2. Learn from Your Code

Let Grammar-Ops learn your existing patterns:

```bash
grammar-ops learn /path/to/your/project -o my-patterns.json
```

This generates a configuration based on your code's current patterns.

### 3. Analyze Your Code

Run analysis with default settings:

```bash
grammar-ops analyze /path/to/your/project
```

Or with verbose output to see specific issues:

```bash
grammar-ops analyze /path/to/your/project --verbose
```

## Understanding the Output

### Summary View
```
Grammar-Ops Analysis Summary
============================

ℹ️ Total issues: 47
  • Functions: 32
  • Constants: 15

Function contexts:
  • CLI Command: 8
  • Regular Function: 20
  • Test Function: 4

💡 Recommendations:
  • CLI Style: Found 8 CLI commands. Consider setting "cli_commands": "rails_style" in config.
  • Singletons: Found 5 singleton instances. These are valid lowercase names.
```

### Detailed View (--verbose)
```
📄 cli.py:42
🔧 Function: start
📍 Context: CLI Command
❌ Issue: Missing verb prefix

CLI commands traditionally use one of two styles:
  1. Rails-style: start, stop, build
  2. Verb-noun style: start_server, stop_server

Your project appears to use Rails-style based on detected patterns.

💡 Suggestion:
  Rename to: start_service

  Decorators: @cli.command()

  ❓ Options:
    1. ✅ Accept suggestion: Rename to start_service
    2. ℹ️ Add exception: Add start to .grammarops.exceptions.json
    3. ℹ️ Change style: Configure CLI style in .grammarops.config.json
    4. Skip: Leave as-is for now
```

## Configuration

### Use a Pre-made Config

Copy one of the example configs:

```bash
# For FastAPI projects
cp grammar-ops/examples/sample-configs/config-fastapi.json .grammarops.config.json

# For Django projects
cp grammar-ops/examples/sample-configs/config-django.json .grammarops.config.json

# Minimal config
cp grammar-ops/examples/sample-configs/config-minimal.json .grammarops.config.json
```

### Or Create Your Own

Start with the learned config:

```bash
# Learn from your code
grammar-ops learn . -o .grammarops.config.json

# Edit to adjust
nano .grammarops.config.json

# Test it
grammar-ops analyze .
```

### Key Configuration Options

```json
{
  "rules": {
    "python": {
      "functions": {
        "require_verb_prefix": {
          "exceptions": {
            "cli_commands": "rails_style",     // or "verb_noun"
            "test_functions": "test_prefix_only",
            "response_factories": "noun_response_pattern"
          }
        }
      }
    }
  },
  "exceptions": {
    "functions": ["main", "setup"],  // Functions to ignore
    "constants": ["app", "logger"],  // Constants to ignore
    "patterns": {
      "allow": [
        "^app = FastAPI\\(",  // Pattern exceptions
        "^T = TypeVar\\("
      ]
    }
  }
}
```

## Migration

### Preview Changes

Always preview before applying:

```bash
grammar-ops migrate . --dry-run
```

### Apply Interactively

Grammar-Ops will show each change and ask for confirmation:

```bash
grammar-ops migrate .
```

### Rollback if Needed

Made a mistake? Roll back:

```bash
grammar-ops migrate . --rollback
```

## Integration

### Pre-commit Hook

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: grammar-ops
        name: Grammar-Ops Check
        entry: grammar-ops analyze
        language: system
        pass_filenames: false
        args: [.]
```

### GitHub Actions

Add to `.github/workflows/grammar.yml`:

```yaml
name: Grammar Check

on: [push, pull_request]

jobs:
  grammar:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Grammar-Ops
        run: |
          git clone https://github.com/your-org/grammar-ops.git
          echo "$PWD/grammar-ops/bin" >> $GITHUB_PATH
      
      - name: Run Grammar Check
        run: grammar-ops analyze .
```

## Tips and Tricks

### 1. Start with Learning
Always run `learn` first to understand your codebase patterns.

### 2. Use Framework Detection
The `detect` command helps you understand what conventions to expect.

### 3. Configure Gradually
Start with a minimal config and add exceptions as needed.

### 4. Focus on New Code
Use the `new_files_only` option to enforce on new code first:

```json
{
  "enforcement": {
    "new_files_only": true
  }
}
```

### 5. Understand Context
Grammar-Ops is smart about context. A function named `start` in a CLI module is different from one in a regular module.

## Common Issues

### "Too Many Violations"
- Use `learn` to generate exceptions
- Consider gradual adoption
- Focus on specific directories first

### "Framework Not Detected"
- Check imports are at module level
- Ensure framework is in the supported list
- Add manual framework specification in config

### "False Positives"
- Add specific exceptions
- Use pattern-based exceptions
- Consider if it's a new pattern to add to Grammar-Ops

## Next Steps

1. Run `grammar-ops learn` on your project
2. Review the generated configuration
3. Run `grammar-ops analyze --verbose` to see specific issues
4. Use `grammar-ops migrate --dry-run` to preview fixes
5. Integrate into your development workflow

Happy coding with consistent conventions!