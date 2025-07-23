# Grammar-Ops: Context-Aware Code Convention Enforcement

A smart, framework-aware tool for enforcing naming conventions in Python and TypeScript/JavaScript codebases. Unlike traditional linters, Grammar-Ops understands your code's context and respects framework idioms.

## 🚀 Quick Start

```bash
# Install grammar-ops
cd grammar-ops
export PATH="$PWD/bin:$PATH"

# Analyze your project
grammar-ops analyze /path/to/project

# Learn from existing code
grammar-ops learn /path/to/project -o my-conventions.json

# Migrate code interactively
grammar-ops migrate /path/to/project --dry-run
```

## 📁 Project Structure

```
grammar-ops/
├── bin/                    # Executable scripts
│   └── grammar-ops        # Main CLI entry point
│
├── lib/                   # Core library modules
│   ├── core/             # Core functionality
│   │   └── framework_detector.py
│   ├── analyzers/        # Code analyzers
│   │   ├── context_analyzer.py
│   │   └── constant_detector.py
│   └── reporters/        # Output formatters
│       └── enhanced_reporter.py
│
├── tools/                 # Standalone tools
│   ├── learn.py          # Learn patterns from code
│   └── migrate.py        # Migrate code to conventions
│
├── scripts/              # Original audit scripts
│   ├── audit-*.sh        # Shell-based auditors
│   └── *.js/*.py         # Language-specific scripts
│
├── config/               # Configuration files
│   ├── schema-v2.json    # Enhanced config schema
│   └── *.json            # Other schemas
│
├── examples/             # Example configurations
│   ├── sample-configs/   # Config examples
│   └── sample-projects/  # Demo projects
│
├── docs/                 # Documentation
│   ├── ENHANCED_FEATURES.md
│   └── *.md              # Other docs
│
└── templates/            # Code templates
```

## 🎯 Key Features

### 1. Framework Detection
Automatically detects and respects framework conventions:
- **Python**: FastAPI, Django, Flask, Typer, Click, Pytest
- **JavaScript**: React, Vue, Angular, Next.js (coming soon)

### 2. Context-Aware Analysis
Understands function context before applying rules:
- CLI commands can use Rails-style naming (`start`, `stop`)
- Test functions already have `test_` prefix
- Response factories follow constructor patterns
- Fixtures are nouns, not actions

### 3. Smart Constant Detection
Distinguishes between:
- True constants (`MAX_RETRIES = 3`)
- Singleton instances (`app = FastAPI()`)
- TypeVar declarations (`T = TypeVar('T')`)
- Logger instances (`logger = logging.getLogger()`)

### 4. Learning Mode
Learn from your existing codebase:
```bash
grammar-ops learn . -o learned.json
```

### 5. Interactive Migration
Safely migrate with preview and rollback:
```bash
grammar-ops migrate . --dry-run  # Preview
grammar-ops migrate .            # Apply
grammar-ops migrate . --rollback # Undo
```

## 📋 Commands

### `analyze` - Check for violations
```bash
grammar-ops analyze [path] [options]

Options:
  -p, --pattern     File pattern (default: **/*.py)
  -v, --verbose     Show detailed issues
  -m, --max-issues  Maximum issues to show
  --no-color        Disable colored output
```

### `learn` - Learn from existing code
```bash
grammar-ops learn [path] [options]

Options:
  -o, --output      Output config file
  -r, --report      Show detailed report
```

### `migrate` - Fix violations interactively
```bash
grammar-ops migrate [path] [options]

Options:
  -c, --config      Config file to use
  -p, --pattern     File pattern
  -d, --dry-run     Preview changes
  --rollback        Undo previous migration
```

### `detect` - Detect frameworks
```bash
grammar-ops detect [path]
```

## 📝 Configuration

### Basic Configuration
Create `.grammarops.config.json` in your project:

```json
{
  "project": {
    "type": "fullstack",
    "language": "python"
  },
  "frameworks": {
    "auto_detect": true
  },
  "rules": {
    "python": {
      "functions": {
        "require_verb_prefix": {
          "enabled": true,
          "exceptions": {
            "cli_commands": "rails_style"
          }
        }
      }
    }
  }
}
```

### Learning from Your Code
Let Grammar-Ops learn your patterns:

```bash
# Learn patterns
grammar-ops learn . -o .grammarops.config.json

# Review and adjust
cat .grammarops.config.json

# Use it
grammar-ops analyze .
```

## 🔧 Original Scripts

The `scripts/` directory contains the original grammar-ops scripts:

- **Metadata Management**: `add-*.sh` scripts
- **Auditing**: `audit-*.sh` scripts
- **Component Generation**: `generate-component.js`
- **Validation**: `validate-*.js` scripts

These scripts work independently and can be used directly:
```bash
./scripts/audit-python-naming.sh
./scripts/add-python-metadata.sh
```

## 🎨 Examples

### CLI Command (Rails-style OK)
```python
@cli.command()
def start():  # ✓ Grammar-Ops understands this
    """Start the service"""
```

### Test Function (Already has prefix)
```python
def test_user_can_login():  # ✓ No "verb prefix" warning
    assert user.login()
```

### Singleton Instance (Lowercase OK)
```python
app = FastAPI()  # ✓ Not flagged as "should be UPPER_CASE"
router = APIRouter()  # ✓ Framework pattern recognized
```

### TypeVar (Special naming)
```python
T = TypeVar('T')  # ✓ Typing convention understood
UserT = TypeVar('UserT', bound=User)  # ✓ Also OK
```

## 🤝 Contributing

1. Framework patterns not recognized? Add to `lib/core/framework_detector.py`
2. New context needed? Update `lib/analyzers/context_analyzer.py`
3. Better error messages? Enhance `lib/reporters/enhanced_reporter.py`

## 📚 Learn More

- [Enhanced Features Documentation](docs/ENHANCED_FEATURES.md)
- [Full Grammar System](docs/FULL_STACK_GRAMMAR_SYSTEM.md)
- [Naming Conventions](docs/NAMING-CONVENTIONS.md)

## 🔄 Migration Path

1. **Analyze Current State**
   ```bash
   grammar-ops analyze . --verbose
   ```

2. **Learn Your Patterns**
   ```bash
   grammar-ops learn . -o my-patterns.json
   ```

3. **Configure Exceptions**
   ```bash
   cp my-patterns.json .grammarops.config.json
   # Edit to adjust rules
   ```

4. **Gradual Migration**
   ```bash
   # Start with new files only
   # Then expand to existing code
   grammar-ops migrate . --dry-run
   ```

5. **Integrate with CI/CD**
   ```yaml
   - name: Check Grammar
     run: grammar-ops analyze .
   ```

## 🎯 Philosophy

Grammar-Ops believes that:
- **Context matters**: A CLI command doesn't need `execute_` prefix
- **Frameworks have idioms**: `app = FastAPI()` is correct, not `APP`
- **Gradual adoption works**: Don't break working code
- **Developers know best**: Learn from existing patterns

Start using Grammar-Ops today for smarter, context-aware code conventions!