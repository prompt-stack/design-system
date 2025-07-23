# Enhanced Grammar-Ops Features

Based on field experiment feedback, grammar-ops has been enhanced with context-aware analysis, framework detection, and intelligent error reporting.

## New Features

### 1. Framework Detection (`framework-detector.py`)

Automatically detects common frameworks and applies appropriate conventions:

- **Python**: FastAPI, Django, Flask, Typer, Click, Pytest, Pydantic, SQLAlchemy
- **JavaScript/TypeScript**: React, Vue, Angular, Next.js (coming soon)

```bash
./grammar-ops detect /path/to/project
```

### 2. Context-Aware Function Analysis (`context-analyzer.py`)

Understands function context before applying naming rules:

```python
# CLI Commands - Rails-style allowed
@cli.command()
def start():  # ✓ OK - CLI command
    pass

# Test Functions - Already have prefix
def test_user_can_login():  # ✓ OK - Test function
    pass

# Response Factories - Constructor pattern
def success_response(data):  # ✓ OK - Factory pattern
    return Response(...)

# Regular Functions - Need verb prefix
def process_data():  # ✓ Good
def data():  # ✗ Bad - needs verb
```

### 3. Smart Constant Detection (`constant-detector.py`)

Distinguishes between true constants and other patterns:

```python
# True Constants - Should be UPPER_CASE
MAX_RETRIES = 3  # ✓ Good
max_retries = 3  # ✗ Bad

# Singleton Instances - Lowercase is correct
app = FastAPI()  # ✓ OK - Framework singleton
router = APIRouter()  # ✓ OK - Framework singleton

# TypeVar - Special naming
T = TypeVar('T')  # ✓ OK - TypeVar convention
TUser = TypeVar('TUser')  # ✓ OK - Descriptive TypeVar

# Logger - Instance, not constant
logger = logging.getLogger(__name__)  # ✓ OK
```

### 4. Learning from Existing Code (`grammar-ops-learn.py`)

Learn patterns from your codebase to generate smart configuration:

```bash
# Learn from existing code
./grammar-ops learn /path/to/project -o learned-config.json

# With detailed report
./grammar-ops learn /path/to/project --report
```

### 5. Interactive Migration (`grammar-ops-migrate.py`)

Migrate code with preview and rollback support:

```bash
# Preview changes
./grammar-ops migrate /path/to/project --dry-run

# Apply changes interactively
./grammar-ops migrate /path/to/project

# Rollback if needed
./grammar-ops migrate /path/to/project --rollback
```

### 6. Enhanced Error Messages (`enhanced-reporter.py`)

Context-aware, helpful error messages:

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

❓ Options:
    1. ✅ Accept suggestion: Rename to start_service
    2. ℹ️ Add exception: Add start to .grammarops.exceptions.json
    3. ℹ️ Change style: Configure CLI style in .grammarops.config.json
    4. Skip: Leave as-is for now
```

## Enhanced Configuration Schema

The new configuration schema (`enhanced-grammar-schema.json`) supports:

### Framework-Specific Rules

```json
{
  "frameworks": {
    "auto_detect": true,
    "frontend": "react",
    "backend": "fastapi"
  },
  "rules": {
    "python": {
      "functions": {
        "require_verb_prefix": {
          "enabled": true,
          "exceptions": {
            "cli_commands": "rails_style",
            "test_functions": "test_prefix_only",
            "response_factories": "noun_response_pattern"
          }
        }
      }
    }
  }
}
```

### Gradual Adoption

```json
{
  "enforcement": {
    "gradual_adoption": {
      "enabled": true,
      "phases": [
        {
          "name": "Documentation",
          "rules": ["metadata"],
          "date": "2025-02-01"
        },
        {
          "name": "New Code",
          "rules": ["functions", "constants"],
          "date": "2025-03-01"
        }
      ]
    }
  }
}
```

### Smart Exceptions

```json
{
  "exceptions": {
    "patterns": {
      "allow": [
        "^T = TypeVar\\(",
        "^app = FastAPI\\(",
        "^logger = logging\\.getLogger"
      ]
    }
  }
}
```

## Usage Examples

### 1. Analyze with Context

```bash
# Basic analysis
./grammar-ops analyze .

# Verbose with context
./grammar-ops analyze . --verbose

# Specific pattern
./grammar-ops analyze . --pattern "src/**/*.py"
```

### 2. Learn and Apply

```bash
# Learn from existing code
./grammar-ops learn . -o my-conventions.json

# Review the generated config
cat my-conventions.json

# Use learned config
cp my-conventions.json .grammarops.config.json

# Run analysis with learned rules
./grammar-ops analyze .
```

### 3. Gradual Migration

```bash
# Phase 1: See what needs fixing
./grammar-ops analyze . --verbose

# Phase 2: Fix interactively
./grammar-ops migrate . --dry-run  # Preview
./grammar-ops migrate .  # Apply

# Phase 3: If something goes wrong
./grammar-ops migrate . --rollback
```

## Benefits

1. **Reduced False Positives**: Framework patterns are recognized
2. **Easier Adoption**: Learn from existing code instead of mass refactoring
3. **Better Developer Experience**: Clear, helpful error messages
4. **Safe Migration**: Preview changes and rollback if needed
5. **Team-Friendly**: Gradual adoption and customizable rules

## Next Steps

1. Try framework detection: `./grammar-ops detect .`
2. Learn your patterns: `./grammar-ops learn .`
3. Review generated config and customize
4. Start with new files only if needed
5. Gradually expand coverage

The enhanced grammar-ops makes code convention enforcement practical for real-world projects!