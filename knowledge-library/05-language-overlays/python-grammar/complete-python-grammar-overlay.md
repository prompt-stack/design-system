# Complete Python Grammar Overlay - Universal Grammar Across Languages

## 📍 Source Information
- **Primary Source**: `/docs/PYTHON_GRAMMAR_OVERLAY.md` (lines 1-258)
- **Original Intent**: Demonstrate Grammar Ops universality by adapting to Python's conventions
- **Key Innovation**: Same semantic rules (verb+noun) with language-appropriate style
- **Revolutionary Concept**: Polyglot codebases speaking same "grammar" with different "accents"

## 🎯 Core Principle - Universal Grammar, Language-Specific Style (Lines 3-4)

**Foundational Insight**: The grammar rules remain the same (verb + noun, layers, patterns) - only the casing and file conventions change for Python.

This means:
- **Semantic Consistency**: Same actions, patterns, and architectural concepts
- **Style Adaptation**: Language-appropriate conventions (snake_case vs camelCase)
- **Cross-Language Understanding**: LLMs can apply same grammar rules universally
- **Polyglot Harmony**: Mixed codebases maintain conceptual consistency

## 🐍 Python Style Mapping - Complete Translation Table (Lines 8-19)

### Comprehensive Style Translation

| Element | Python Style | Example | Maps to TS/JS |
|---------|-------------|---------|---------------|
| **Module (file)** | `snake_case.py` | `user_service.py` | `UserService.ts` |
| **Package (dir)** | `snake_case/` + `__init__.py` | `email_queue/` | `emailQueue/` |
| **Function/Method** | `snake_case` verb-first | `fetch_user()`, `validate_email()` | `fetchUser()`, `validateEmail()` |
| **Class** | `PascalCase` | `class UserService:` | `class UserService` |
| **Constant** | `UPPER_SNAKE_CASE` | `MAX_RETRIES = 3` | `MAX_RETRIES = 3` |
| **Boolean** | `is_`/`has_`/`can_` prefix | `is_active`, `has_permission` | `isActive`, `hasPermission` |
| **Private** | `_` prefix | `_internal_method()` | `private method()` |
| **Test file** | `test_*.py` or `*_test.py` | `test_user_service.py` | `UserService.test.ts` |
| **Config** | `config.py` or `settings.py` | `settings.py` | `config.ts` |

**Key Observations**:
- **Verb-First Rule**: Maintained across both languages (`fetch_user` vs `fetchUser`)
- **Boolean Clarity**: Same prefixes, different casing (`is_active` vs `isActive`)
- **Privacy Indicators**: Language-specific (`_` prefix vs `private` keyword)
- **File Organization**: Python requires `__init__.py` for packages

## 📁 Directory Structure for Python - Full Stack Organization (Lines 21-59)

### Complete Python Project Structure

```
project/
├── automation/           # Automation scripts (Grammar: action-focused layer)
│   ├── __init__.py
│   ├── data_pipeline.py     # Grammar: verb_noun pattern
│   ├── report_generator.py  # Grammar: verb_noun pattern
│   └── tests/
│       └── test_pipeline.py # Grammar: test_ prefix convention
├── web_app/             # Web application (Grammar: feature-focused layer)
│   ├── __init__.py
│   ├── routes/              # Grammar: REST endpoint organization
│   │   ├── __init__.py
│   │   └── user_routes.py   # Grammar: entity_routes pattern
│   ├── services/            # Grammar: business logic layer
│   │   ├── __init__.py
│   │   └── user_service.py  # Grammar: entity_service pattern
│   ├── models/              # Grammar: data layer
│   │   ├── __init__.py
│   │   └── user.py          # Grammar: entity pattern
│   └── utils/               # Grammar: utility layer
│       ├── __init__.py
│       └── validators.py    # Grammar: verb_plural pattern
├── ml/                  # Machine learning (Grammar: domain layer)
│   ├── __init__.py
│   ├── train_model.py       # Grammar: verb_noun pattern
│   ├── predict.py           # Grammar: single verb for focused action
│   └── models/
│       └── classifier.py    # Grammar: noun pattern for class files
├── scripts/             # CLI tools (Grammar: automation layer)
│   ├── migrate_database.py  # Grammar: verb_noun pattern
│   ├── generate_report.py   # Grammar: verb_noun pattern
│   └── clean_cache.py       # Grammar: verb_noun pattern
├── tests/               # Global test fixtures
│   ├── conftest.py          # Pytest convention
│   └── fixtures/
│       └── user_fixtures.py # Grammar: entity_fixtures pattern
└── requirements.txt
```

**Structural Grammar Rules**:
1. **Layer Organization**: Same conceptual layers as TypeScript (services, models, utils)
2. **Package Markers**: `__init__.py` required for Python packages
3. **Test Proximity**: Tests can be co-located or in separate test directories
4. **Script Layer**: Direct executable scripts without build step

## 🔤 Grammar Rules Applied to Python - Complete Verb Taxonomy (Lines 63-86)

### 1. Data Operations - CRUD Pattern

```python
# Data Operations (Same verbs, snake_case style)
def fetch_users():          # fetchUsers() in TS
def create_item():          # createItem() in TS
def update_record():        # updateRecord() in TS
def delete_entity():        # deleteEntity() in TS

# Batch Operations
def fetch_all_orders():     # fetchAllOrders() in TS
def create_bulk_items():    # createBulkItems() in TS
def update_many_records():  # updateManyRecords() in TS
def delete_expired_items(): # deleteExpiredItems() in TS
```

### 2. Validation Operations

```python
# Validation (Grammar: validate/check/ensure + entity)
def validate_email():       # validateEmail() in TS
def check_permissions():    # checkPermissions() in TS
def ensure_unique():        # ensureUnique() in TS
def verify_signature():     # verifySignature() in TS
def confirm_password():     # confirmPassword() in TS
```

### 3. Transformation Operations

```python
# Transformation (Grammar: format/parse/serialize + entity)
def format_date():          # formatDate() in TS
def parse_json():          # parseJson() in TS
def serialize_data():      # serializeData() in TS
def transform_response():   # transformResponse() in TS
def convert_currency():     # convertCurrency() in TS
```

### 4. State Management (When Applicable)

```python
# State Management (Grammar: use/set/clear + state)
def use_cache():           # useCache() in TS
def set_config():          # setConfig() in TS
def clear_session():       # clearSession() in TS
def reset_state():         # resetState() in TS
def sync_database():       # syncDatabase() in TS
```

## 🏛️ Class Patterns - Object-Oriented Grammar (Lines 89-109)

### Service Class Pattern

```python
# Service Classes (Grammar: EntityService pattern)
class UserService:          # Same as TS
    """Handles user-related business logic"""
    
    def get_user(self, user_id: int) -> User:
        """Grammar: get + entity"""
        pass
        
    def create_user(self, data: dict) -> User:
        """Grammar: create + entity"""
        pass
        
    def update_user(self, user_id: int, data: dict) -> User:
        """Grammar: update + entity"""
        pass
        
    def delete_user(self, user_id: int) -> bool:
        """Grammar: delete + entity"""
        pass
```

### Repository Pattern

```python
# Repository Pattern (Grammar: EntityRepository for data access)
class UserRepository:       # Same as TS
    """Data access layer for users"""
    
    def find_by_id(self, user_id: int) -> Optional[User]:
        """Grammar: find + criteria"""
        pass
        
    def find_all(self, filters: dict) -> List[User]:
        """Grammar: find + scope"""
        pass
        
    def save(self, user: User) -> User:
        """Grammar: action + entity"""
        pass
        
    def exists(self, email: str) -> bool:
        """Grammar: boolean check"""
        pass
```

### Model Pattern

```python
# Models (Grammar: Entity representation)
class User:                 # Same as TS
    """User entity model"""
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email
        self.is_active = True  # Grammar: is_ prefix for boolean
        self.has_verified_email = False  # Grammar: has_ prefix
        self.can_edit_posts = True  # Grammar: can_ prefix
```

## 📝 File Metadata Headers - Python Docstring Format (Lines 113-126)

### Complete Metadata Template

```python
"""
@file automation/data_pipeline
@purpose Extract, transform, and load data from multiple sources
@layer automation
@deps [pandas, sqlalchemy, requests]
@used-by [ReportGenerator, DataAnalyzer]
@schedule "0 2 * * *"  # Runs at 2 AM daily
@performance Processes 1M records in ~5 minutes
@llm-read true
@llm-write full-edit
@llm-role utility
"""

import pandas as pd
from sqlalchemy import create_engine
import requests
from typing import List, Dict, Optional

# Implementation follows...
```

**Python-Specific Metadata**:
- **`@schedule`**: For automation scripts, cron patterns
- **`@performance`**: Expected performance characteristics
- **`@deps`**: Python package dependencies
- **Docstring Format**: Uses triple quotes instead of JS comments

## 🧪 Testing Patterns - Pytest Conventions (Lines 130-146)

### Complete Test Structure

```python
# test_user_service.py
"""Test suite for UserService"""

import pytest
from unittest.mock import Mock, patch
from services.user_service import UserService
from models.user import User

class TestUserService:
    """Test UserService methods - Grammar: TestEntityName"""
    
    @pytest.fixture
    def service(self):
        """Fixture providing UserService instance"""
        return UserService()
    
    @pytest.fixture
    def mock_user(self):
        """Fixture providing mock user data"""
        return User(name="Test User", email="test@example.com")
    
    def test_should_create_user_with_valid_data(self, service, mock_user):
        """Grammar: should + action + condition (same as TS)"""
        # Arrange
        user_data = {"name": "Test User", "email": "test@example.com"}
        
        # Act
        result = service.create_user(user_data)
        
        # Assert
        assert result.name == user_data["name"]
        assert result.email == user_data["email"]
        
    def test_raises_error_when_email_exists(self, service):
        """Grammar: raises + error + condition"""
        # Arrange
        existing_email = "existing@example.com"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Email already exists"):
            service.create_user({"email": existing_email})
            
    @pytest.mark.asyncio
    async def test_async_fetch_external_data(self, service):
        """Grammar: async test pattern"""
        # Same pattern as JS async tests
        result = await service.fetch_external_data()
        assert result is not None
```

**Test Grammar Consistency**:
- **Test Names**: Same "should/raises + action + condition" pattern
- **Test Organization**: Class-based grouping like Jest describe blocks
- **Fixtures**: Replace Jest's beforeEach with pytest fixtures
- **Async Tests**: Same pattern with Python's async/await

## 📄 Special Python Files - Language-Specific Conventions (Lines 149-157)

### Python-Specific File Patterns

| File | Purpose | Pattern | Grammar Rule |
|------|---------|---------|--------------|
| `__init__.py` | Package marker | Usually empty or exports | Makes directory a package |
| `conftest.py` | Pytest fixtures | Test configuration | Shared test setup |
| `setup.py` | Package setup | Distribution config | Package metadata |
| `requirements.txt` | Dependencies | Line-by-line packages | Dependency list |
| `.env` | Environment vars | UPPER_SNAKE_CASE | Configuration values |
| `alembic.ini` | DB migrations | Config file | Migration settings |
| `pyproject.toml` | Modern config | TOML format | Build configuration |
| `Dockerfile` | Container def | Multi-stage builds | Deployment config |

## 🌐 Framework-Specific Patterns - Django/Flask Examples (Lines 161-178)

### Flask Route Patterns

```python
# Flask (Grammar: REST verb mapping)
@app.route('/api/users', methods=['GET'])
def get_users():  # Grammar: HTTP method matches function verb
    """Fetch all users"""
    return UserService().fetch_all_users()

@app.route('/api/users', methods=['POST'])
def create_user():  # Grammar: create for POST
    """Create new user"""
    return UserService().create_user(request.json)

@app.route('/api/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):  # Grammar: update for PUT
    """Update existing user"""
    return UserService().update_user(user_id, request.json)
```

### Django URL Patterns

```python
# Django urls.py (Grammar: REST resource mapping)
from django.urls import path
from . import views

urlpatterns = [
    path('api/users/', views.UserListView.as_view(), name='user-list'),
    path('api/users/<int:pk>/', views.UserDetailView.as_view(), name='user-detail'),
    path('api/users/search/', views.search_users, name='user-search'),
]
```

### Async Patterns

```python
# Async Functions (Grammar: same as JS async/await)
async def fetch_external_data(url: str) -> dict:
    """Grammar: fetch + source pattern"""
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

async def process_queue_items(queue: asyncio.Queue) -> None:
    """Grammar: process + entity pattern"""
    while True:
        item = await queue.get()
        await handle_item(item)
        queue.task_done()
```

## 🎨 Python-Specific Patterns - Decorators (Lines 181-190)

### Decorator Grammar

```python
# Property Decorators (Grammar: computed values)
@property
def full_name(self) -> str:
    """Grammar: computed property pattern"""
    return f"{self.first_name} {self.last_name}"

@cached_property
def expensive_calculation(self) -> float:
    """Grammar: cached computation pattern"""
    return sum(self.process_large_dataset())

# Function Decorators (Grammar: behavior modification)
@login_required
def protected_view(request):
    """Grammar: access control pattern"""
    return render(request, 'protected.html')

@retry(max_attempts=3, backoff=2.0)
def fetch_remote_data():
    """Grammar: resilience pattern"""
    return requests.get(API_URL).json()

@measure_performance
def process_large_file(file_path: str):
    """Grammar: monitoring pattern"""
    # Processing logic here
```

## 🔀 Import Rules for Mixed Codebases - Cross-Language Boundaries (Lines 193-205)

### Cross-Language Integration Patterns

```yaml
# Allowed Integration Patterns
Allowed:
  - Python CLI tools → call TS services via subprocess
  - TS backend → execute Python scripts for ML/data processing  
  - Shared JSON/YAML configs
  - REST API communication between services
  - Message queue integration (Redis, RabbitMQ)
  - Shared database with consistent schemas

# Forbidden Anti-Patterns  
Forbidden:
  - Direct imports across language boundaries
  - Python importing TS modules
  - TS importing .py files
  - Shared in-memory state
  - Direct function calls across languages
```

### Integration Examples

```python
# Python calling TypeScript service
import subprocess
import json

def call_ts_service(data: dict) -> dict:
    """Grammar: call + external service"""
    result = subprocess.run(
        ['npm', 'run', 'process-data', json.dumps(data)],
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)

# Python REST API client for TS backend
class TypeScriptAPIClient:
    """Grammar: ExternalServiceClient pattern"""
    
    def __init__(self, base_url: str):
        self.base_url = base_url
        
    def fetch_user_data(self, user_id: int) -> dict:
        """Grammar: fetch + entity + source"""
        response = requests.get(f"{self.base_url}/api/users/{user_id}")
        response.raise_for_status()
        return response.json()
```

## 🔧 Enforcement for Python - Linting and Type Checking (Lines 209-230)

### 1. Flake8 Configuration (.flake8)

```ini
[flake8]
# Enforce naming conventions
naming-convention = snake_case
max-line-length = 88
max-complexity = 10
exclude = .git,__pycache__,venv,migrations
ignore = E203,W503  # Black compatibility

# Custom naming rules
[flake8:names]
function-name-pattern = ^[a-z_][a-z0-9_]*$  # snake_case functions
class-name-pattern = ^[A-Z][a-zA-Z0-9]*$   # PascalCase classes
constant-name-pattern = ^[A-Z_][A-Z0-9_]*$  # UPPER_SNAKE constants
```

### 2. Type Checking Configuration (pyproject.toml)

```toml
[tool.mypy]
python_version = "3.9"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
```

### 3. Import Ordering (isort)

```toml
[tool.isort]
profile = "black"
line_length = 88
known_first_party = ["automation", "web_app", "ml", "scripts"]
sections = ["FUTURE", "STDLIB", "THIRDPARTY", "FIRSTPARTY", "LOCALFOLDER"]
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
ensure_newline_before_comments = true
```

### 4. Black Formatting

```toml
[tool.black]
line-length = 88
target-version = ['py39']
include = '\.pyi?$'
exclude = '''
/(
    \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | _build
  | buck-out
  | build
  | dist
)/
'''
```

## 📋 Audit Script for Python - Complete Validation (Lines 233-248)

### Comprehensive Python Grammar Audit

```bash
#!/bin/bash
# audit-python-naming.sh - Complete Python grammar validation

echo "🐍 Python Grammar Ops Audit"
echo "=========================="

# Check function naming (should be snake_case with verb)
echo -e "\n📝 Checking Python function naming..."
violations=$(find . -name "*.py" -type f -not -path "./venv/*" \
    | xargs grep -E "^def [A-Z]" \
    | grep -v "^def [A-Z][A-Z]")  # Allow all-caps like DEF_CONFIG
    
if [ -z "$violations" ]; then
    echo "✅ All functions follow snake_case convention"
else
    echo "❌ Function naming violations found:"
    echo "$violations"
fi

# Check verb-first pattern in functions
echo -e "\n🔤 Checking verb-first pattern..."
find . -name "*.py" -type f -not -path "./venv/*" \
    | xargs grep -E "^def [a-z_]+\(" \
    | grep -vE "^def (get|set|fetch|create|update|delete|validate|check|ensure|format|parse|transform|handle|process|calculate|compute|generate|build|render|display)" \
    | head -20

# Check class naming (should be PascalCase)
echo -e "\n🏛️ Checking Python class naming..."
violations=$(find . -name "*.py" -type f -not -path "./venv/*" \
    | xargs grep -E "^class [a-z]")
    
if [ -z "$violations" ]; then
    echo "✅ All classes follow PascalCase convention"
else
    echo "❌ Class naming violations found:"
    echo "$violations"
fi

# Check constants (should be UPPER_SNAKE)
echo -e "\n📊 Checking Python constants..."
violations=$(find . -name "*.py" -type f -not -path "./venv/*" \
    | xargs grep -E "^[a-z_]+ = ['\"]|^[a-z_]+ = \d+" \
    | grep -v "^_" \
    | grep -vE "^(app|router|api|db|engine) =")  # Common framework objects
    
if [ -z "$violations" ]; then
    echo "✅ Constants follow UPPER_SNAKE_CASE convention"
else
    echo "⚠️  Possible constant naming issues:"
    echo "$violations" | head -10
fi

# Check boolean naming patterns
echo -e "\n❓ Checking boolean naming patterns..."
find . -name "*.py" -type f -not -path "./venv/*" \
    | xargs grep -E "(is_|has_|can_|should_|will_|does_)[a-z_]+" \
    | grep -v "def " \
    | head -10

# Check test file naming
echo -e "\n🧪 Checking test file naming..."
test_files=$(find . -name "test_*.py" -o -name "*_test.py" | grep -v venv)
echo "Found $(echo "$test_files" | wc -l) test files following naming convention"

# Check for metadata headers
echo -e "\n📄 Checking for metadata headers..."
for file in $(find . -name "*.py" -type f -not -path "./venv/*" | head -20); do
    if head -20 "$file" | grep -q "@file"; then
        echo "✅ $file has metadata"
    else
        echo "❌ $file missing metadata"
    fi
done

echo -e "\n✨ Audit complete!"
```

## 🎯 Summary - Universal Grammar Success (Lines 251-258)

### Grammar System Universality Proven

The grammar system works perfectly for Python:

1. **Same Semantic Rules**:
   - Verb + noun patterns maintained
   - Layer architecture preserved
   - Functional patterns consistent

2. **Different Style Rules**:
   - snake_case instead of camelCase
   - Underscores instead of capitals
   - Python-specific conventions respected

3. **Same Architectural Principles**:
   - Services, repositories, utilities
   - Layer separation maintained
   - Dependency rules enforced

4. **Same Metadata System**:
   - Docstring format for Python
   - Same fields and directives
   - Universal LLM understanding

### Revolutionary Impact

This creates a **polyglot codebase** where every language speaks the same "grammar" with different "accents":

- **TypeScript**: `fetchUser()` in `UserService.ts`
- **Python**: `fetch_user()` in `user_service.py`
- **Go**: `FetchUser()` in `user_service.go`
- **Rust**: `fetch_user()` in `user_service.rs`

**Same concepts, same patterns, same understanding** - just different syntactic conventions!

## 🔗 Cross-References & Integration

### This System Connects To:
- **Core Grammar**: `/02-grammar/naming-system/` - Universal verb taxonomy
- **Metadata System**: `/01-architecture/metadata-system/` - Language-agnostic metadata
- **Full Stack Grammar**: `/02-grammar/full-stack-system/` - Cross-language patterns
- **Test Grammar**: `/03-testing/test-driven-grammar/` - Testing patterns across languages

### This System Enables:
- **Polyglot Development**: Consistent patterns across languages
- **LLM Language Switching**: AI understands pattern regardless of syntax
- **Team Flexibility**: Developers can work in multiple languages
- **Universal Documentation**: Same concepts documented consistently

### Dependencies:
- **Grammar Foundation**: Core verb/noun patterns must be established
- **Metadata Headers**: Required in all languages for consistency
- **Linting Tools**: Language-specific enforcement needed
- **Team Training**: Developers must understand universal patterns

This proves that Grammar Ops is truly a **universal development language** - transcending individual programming languages to create a consistent, understandable system across entire technology stacks!