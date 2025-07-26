# Complete Grammar Ops Tools - Implementation and Migration

## 📍 Source Information
- **Primary Sources**: 
  - `/tools/migrate.py` (migration tool)
  - `/tools/learn.py` (pattern learning tool)
  - `/lib/` (supporting analysis libraries)
- **Original Intent**: Provide automated tools for adopting Grammar Ops
- **Key Innovation**: Learn from existing patterns before enforcing new ones
- **Revolutionary Concept**: Gradual, intelligent migration to Grammar Ops

## 🎯 Overview - Smart Implementation Tools

Grammar Ops provides two main implementation tools:

1. **Learning Tool (`learn.py`)** - Analyzes existing codebases to understand current patterns
2. **Migration Tool (`migrate.py`)** - Helps migrate codebases to Grammar Ops conventions

Together they enable:
- **Non-disruptive adoption** - Learn patterns before changing them
- **Intelligent migration** - Understand context before renaming
- **Safe transformation** - Backup and rollback capabilities
- **Gradual adoption** - Migrate incrementally
- **Custom exceptions** - Preserve valid non-standard patterns

## 🧠 Learning Tool - Pattern Discovery Engine

### Purpose and Philosophy
The learning tool **discovers existing patterns** in your codebase before enforcing Grammar Ops rules. This enables:
- Understanding current conventions
- Identifying valid exceptions
- Creating custom configuration
- Avoiding unnecessary changes

### Core Components

#### Pattern Learner Class
```python
class PatternLearner:
    """Learns naming patterns from existing code."""
    
    def __init__(self, project_root: Path):
        self.project_root = Path(project_root)
        self.framework_detector = FrameworkDetector(project_root)
        
        # Pattern collections
        self.function_patterns = defaultdict(list)
        self.constant_patterns = defaultdict(list)
        self.class_patterns = []
        self.module_patterns = []
        
        # Learned patterns
        self.learned_exceptions = {
            'functions': set(),
            'constants': set(),
            'patterns': {
                'cli_commands': set(),
                'response_factories': set(),
                'singletons': set(),
                'typevars': set()
            }
        }
```

### Learning Process

1. **File Analysis**
   - Scans all Python files in project
   - Skips common non-source directories
   - Parses AST for each file
   - Extracts naming patterns

2. **Pattern Categories**
   - **Functions**: Identifies verb patterns, special cases
   - **Constants**: Recognizes different constant styles
   - **Classes**: Learns class naming conventions
   - **Modules**: Understands file organization

3. **Context Understanding**
   - **CLI Commands**: Functions that are CLI entry points
   - **Factory Functions**: Object creation patterns
   - **Framework Patterns**: Django views, Flask routes
   - **Test Functions**: Test naming conventions

### Output: Learned Configuration

The tool generates a configuration file capturing your codebase's patterns:

```json
{
  "learned_patterns": {
    "project": "/path/to/project",
    "analysis_date": "2024-07-26",
    "statistics": {
      "files_analyzed": 156,
      "functions": 1243,
      "constants": 387,
      "classes": 89
    },
    "patterns": {
      "functions": {
        "common_prefixes": ["handle", "process", "execute", "run"],
        "exceptions": ["cli_main", "wsgi_app", "fixture_user"],
        "framework_specific": {
          "django_views": ["home", "about", "contact"],
          "celery_tasks": ["send_email_task", "process_payment_task"]
        }
      },
      "constants": {
        "styles_found": ["UPPER_CASE", "CamelCase", "lowercase"],
        "common_patterns": ["_SETTINGS", "_CONFIG", "_DEFAULT"],
        "exceptions": ["settings", "urlpatterns", "app"]
      }
    },
    "recommendations": {
      "functions": {
        "adopt_verb_prefix": true,
        "preserve_exceptions": ["cli_*", "test_*", "fixture_*"],
        "custom_verbs": ["execute", "run", "init"]
      },
      "constants": {
        "target_style": "UPPER_CASE",
        "preserve_framework": ["settings", "urlpatterns"]
      }
    }
  }
}
```

### Usage Example

```bash
# Learn patterns from current project
python tools/learn.py .

# Learn with specific focus
python tools/learn.py . --focus functions

# Generate exception rules for existing patterns
python tools/learn.py . --generate-exceptions

# Learn from specific directory
python tools/learn.py src/ --recursive
```

## 🔄 Migration Tool - Intelligent Code Transformation

### Purpose and Capabilities
The migration tool **safely transforms** code to follow Grammar Ops conventions while:
- Preserving functionality
- Creating backups
- Allowing rollbacks
- Respecting exceptions
- Providing interactive mode

### Core Components

#### Code Migrator Class
```python
class CodeMigrator:
    """Handles code migration to grammar-ops conventions."""
    
    def __init__(self, project_root: Path, config_path: Optional[Path] = None):
        self.project_root = Path(project_root)
        self.config = self._load_config(config_path)
        self.framework_detector = FrameworkDetector(project_root)
        
        # Migration state
        self.backup_dir = self.project_root / '.grammar-ops-backup'
        self.migration_log = []
        self.fixed_files = set()
        self.skipped_files = set()
        
        # Analyzers
        self.function_analyzer = ContextAwareFunctionAnalyzer(self.framework_detector)
        self.constant_analyzer = SmartConstantAnalyzer(self.framework_detector)
```

### Migration Process

1. **Analysis Phase**
   ```python
   def analyze(self, file_pattern: str = "**/*.py") -> Dict:
       """Analyze files and identify needed changes."""
       issues = {
           'functions': [],
           'constants': [],
           'total': 0
       }
       
       # Identify all issues before making changes
       for py_file in py_files:
           func_issues = self.function_analyzer.analyze_file(py_file)
           const_issues = self.constant_analyzer.analyze_file(py_file)
   ```

2. **Backup Phase**
   - Creates timestamped backup directory
   - Copies original files before modification
   - Maintains migration log
   - Enables safe rollback

3. **Transformation Phase**
   - Applies Grammar Ops rules
   - Preserves learned exceptions
   - Updates imports/references
   - Maintains code functionality

4. **Validation Phase**
   - Checks syntax validity
   - Runs basic tests if available
   - Generates migration report
   - Highlights manual review items

### Migration Strategies

#### 1. Interactive Mode
```bash
python tools/migrate.py . --interactive

# For each issue:
# [1] user_data() -> get_user_data()
#     File: src/models.py, Line: 45
#     
# Apply this change? [y/n/s/a/q]: 
# y = yes, n = no, s = skip file, a = apply all, q = quit
```

#### 2. Automatic Mode with Review
```bash
# Analyze first
python tools/migrate.py . --analyze-only

# Review report, then migrate
python tools/migrate.py . --auto --backup

# With specific rules
python tools/migrate.py . --fix-functions --skip-constants
```

#### 3. Gradual Migration
```bash
# Migrate one directory at a time
python tools/migrate.py src/utils/ --fix-all
python tools/migrate.py src/models/ --fix-all
python tools/migrate.py src/views/ --fix-all
```

### Configuration Options

```json
{
  "rules": {
    "python": {
      "functions": {
        "require_verb_prefix": {
          "enabled": true,
          "verbs": ["get", "set", "create", "update", "delete", "fetch", "process"],
          "exceptions": ["__init__", "__str__", "setUp", "tearDown"]
        }
      },
      "constants": {
        "style": "UPPER_CASE",
        "exceptions": ["settings", "urlpatterns", "app"]
      }
    }
  },
  "migration": {
    "backup": true,
    "interactive": true,
    "update_imports": true,
    "fix_references": true,
    "validate_syntax": true
  }
}
```

## 📚 Supporting Libraries

### Framework Detector
```python
class FrameworkDetector:
    """Detects frameworks and their patterns."""
    
    def detect_frameworks(self) -> Set[str]:
        # Detects Django, Flask, FastAPI, etc.
        # Understands framework-specific patterns
```

### Context Analyzers
```python
class ContextAwareFunctionAnalyzer:
    """Analyzes functions with context understanding."""
    
    def analyze_function(self, node: ast.FunctionDef, context: FunctionContext):
        # Understands:
        # - CLI commands
        # - Test functions
        # - Framework handlers
        # - Factory functions
```

### Smart Constant Analyzer
```python
class SmartConstantAnalyzer:
    """Intelligently analyzes constants."""
    
    def analyze_constant(self, node: ast.Assign, context: AssignmentContext):
        # Recognizes:
        # - Configuration constants
        # - Type variables
        # - Framework constants
        # - Singleton instances
```

## 🚀 Implementation Workflow

### Recommended Adoption Process

1. **Learn Current Patterns**
   ```bash
   python tools/learn.py . > patterns.json
   ```

2. **Review and Customize**
   - Edit generated configuration
   - Add custom exceptions
   - Define migration strategy

3. **Analyze Impact**
   ```bash
   python tools/migrate.py . --analyze-only > migration-report.txt
   ```

4. **Test Migration**
   ```bash
   # On a branch or copy
   python tools/migrate.py . --dry-run
   ```

5. **Execute Migration**
   ```bash
   python tools/migrate.py . --backup --interactive
   ```

6. **Validate Results**
   - Run tests
   - Check functionality
   - Review changes

7. **Commit or Rollback**
   ```bash
   # If successful
   git add -A && git commit -m "Migrate to Grammar Ops conventions"
   
   # If issues
   python tools/migrate.py . --rollback
   ```

## 🎯 Advanced Features

### 1. Custom Verb Detection
The tools can learn domain-specific verbs:
```python
# Learns: process_payment, calculate_tax, validate_order
# Suggests: process, calculate, validate as approved verbs
```

### 2. Import Updates
Automatically updates imports when renaming:
```python
# Before: from utils import user_data
# After:  from utils import get_user_data
```

### 3. Test Preservation
Recognizes and preserves test patterns:
```python
# Preserves: test_user_creation
# Preserves: test_calculate_tax_with_discount
```

### 4. Framework Integration
Understands framework requirements:
```python
# Django: preserves 'urlpatterns', 'INSTALLED_APPS'
# Flask: preserves 'app', route handlers
# FastAPI: preserves dependency injection patterns
```

## 🔗 Integration with Grammar Ops

### These Tools Enable:
- **Gradual adoption** without disrupting development
- **Context-aware migration** that preserves functionality
- **Learning-based configuration** tailored to your codebase
- **Safe transformation** with rollback capability

### Tools Connect To:
- **Grammar schemas** for rule definitions
- **Configuration files** for customization
- **CI/CD pipelines** for validation
- **IDE integrations** for real-time feedback

### Success Metrics:
- **Adoption rate**: % of code following Grammar Ops
- **Exception rate**: Valid patterns preserved
- **Migration safety**: Zero functionality breaks
- **Developer satisfaction**: Smooth transition

## 🎯 Revolutionary Impact

These tools transform Grammar Ops adoption from a disruptive rewrite to an **intelligent evolution**:

1. **Learn Before Enforce** - Understand existing patterns
2. **Preserve Valid Exceptions** - Respect framework requirements
3. **Migrate Safely** - Backup and rollback capabilities
4. **Adopt Gradually** - One module at a time
5. **Maintain Productivity** - No development disruption

The tools make Grammar Ops **practical for real-world adoption** in existing codebases!