# Python Grammar Overlay - Same Semantics, Different Style

## Core Principle
The grammar rules remain the same (verb + noun, layers, patterns) - only the casing and file conventions change for Python.

## Python Style Mapping

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

## Directory Structure for Python

```
project/
├── automation/           # Automation scripts
│   ├── __init__.py
│   ├── data_pipeline.py
│   ├── report_generator.py
│   └── tests/
│       └── test_pipeline.py
├── web_app/             # Web application
│   ├── __init__.py
│   ├── routes/
│   │   ├── __init__.py
│   │   └── user_routes.py
│   ├── services/
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   └── utils/
│       ├── __init__.py
│       └── validators.py
├── ml/                  # Machine learning
│   ├── __init__.py
│   ├── train_model.py
│   ├── predict.py
│   └── models/
│       └── classifier.py
├── scripts/             # CLI tools
│   ├── migrate_database.py
│   ├── generate_report.py
│   └── clean_cache.py
├── tests/               # Global test fixtures
│   ├── conftest.py
│   └── fixtures/
│       └── user_fixtures.py
└── requirements.txt
```

## Grammar Rules Applied to Python

### 1. Verb Taxonomy (Same Actions, Different Case)

```python
# Data Operations
def fetch_users():          # fetchUsers() in TS
def create_item():          # createItem() in TS
def update_record():        # updateRecord() in TS
def delete_entity():        # deleteEntity() in TS

# Validation
def validate_email():       # validateEmail() in TS
def check_permissions():    # checkPermissions() in TS
def ensure_unique():        # ensureUnique() in TS

# Transformation
def format_date():          # formatDate() in TS
def parse_json():          # parseJson() in TS
def serialize_data():      # serializeData() in TS

# State Management (if applicable)
def use_cache():           # useCache() in TS
def set_config():          # setConfig() in TS
def clear_session():       # clearSession() in TS
```

### 2. Class Patterns

```python
# Service Classes
class UserService:          # Same as TS
    def get_user(self, user_id: int):
    def create_user(self, data: dict):
    def update_user(self, user_id: int, data: dict):

# Repository Pattern
class UserRepository:       # Same as TS
    def find_by_id(self, user_id: int):
    def find_all(self, filters: dict):
    def save(self, user: User):

# Models
class User:                 # Same as TS
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email
        self.is_active = True  # Boolean pattern
```

### 3. File Metadata Headers

```python
"""
@file automation/data_pipeline
@purpose Extract, transform, and load data from multiple sources
@layer automation
@deps [pandas, sqlalchemy, requests]
@llm-read true
@llm-write full-edit
@llm-role utility
"""

import pandas as pd
from sqlalchemy import create_engine
```

### 4. Testing Patterns

```python
# test_user_service.py
"""Test suite for UserService"""

import pytest
from services.user_service import UserService

class TestUserService:
    """Test UserService methods"""
    
    def test_should_create_user_with_valid_data(self):
        """should create user with valid data"""
        # Follows same pattern as TS tests
        
    def test_raises_error_when_email_exists(self):
        """raises error when email already exists"""
```

### 5. Special Python Files

| File | Purpose | Pattern |
|------|---------|---------|
| `__init__.py` | Package marker | Usually empty or exports |
| `conftest.py` | Pytest fixtures | Test configuration |
| `setup.py` | Package setup | Distribution config |
| `requirements.txt` | Dependencies | Line-by-line packages |
| `.env` | Environment vars | UPPER_SNAKE_CASE |
| `alembic.ini` | DB migrations | Config file |

## Python-Specific Patterns

### 1. Django/Flask Routes
```python
# Flask
@app.route('/api/users', methods=['GET'])
def get_users():  # Same REST patterns

# Django
urlpatterns = [
    path('api/users/', UserListView.as_view()),
]
```

### 2. Async Functions
```python
async def fetch_external_data():    # Same as JS async
    async with aiohttp.ClientSession() as session:
        return await session.get(url)
```

### 3. Decorators (Python-specific)
```python
@property
def full_name(self):  # Computed property

@cached_property
def expensive_calculation(self):

@login_required
def protected_view(request):
```

## Import Rules for Mixed Codebases

### Python ↔ TypeScript Boundaries
```yaml
Allowed:
  - Python CLI tools → call TS services via subprocess
  - TS backend → execute Python scripts for ML/data processing
  - Shared JSON/YAML configs

Forbidden:
  - Direct imports across language boundaries
  - Python importing TS modules
  - TS importing .py files
```

## Enforcement for Python

### 1. Linting Rules (.flake8 or pyproject.toml)
```ini
[flake8]
# Enforce naming conventions
naming-convention = snake_case
max-line-length = 88
```

### 2. Type Checking (mypy)
```ini
[mypy]
python_version = 3.9
strict = True
```

### 3. Import Order (isort)
```ini
[isort]
profile = black
known_first_party = automation,web_app,ml
```

## Audit Script for Python

```bash
# audit-python-naming.sh
#!/bin/bash

# Check function naming (should be snake_case with verb)
echo "Checking Python function naming..."
find . -name "*.py" -type f | xargs grep -E "^def [A-Z]" | grep -v "^def [A-Z][A-Z]"

# Check class naming (should be PascalCase)
echo "Checking Python class naming..."
find . -name "*.py" -type f | xargs grep -E "^class [a-z]"

# Check constants (should be UPPER_SNAKE)
echo "Checking Python constants..."
find . -name "*.py" -type f | xargs grep -E "^[a-z_]+ = ['\"]" | grep -v "^_"
```

## Summary

The grammar system works perfectly for Python:
- **Same semantic rules** (verb+noun, layers, patterns)
- **Different style rules** (snake_case instead of camelCase)
- **Same architectural principles** (services, repositories, utilities)
- **Same metadata system** (with Python docstring format)

This creates a polyglot codebase where every language speaks the same "grammar" with different "accents"!