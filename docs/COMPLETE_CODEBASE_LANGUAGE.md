# The Complete Codebase Language

## What We've Built

A comprehensive "grammar system" for the entire codebase where:
- Every identifier follows linguistic rules (verbs, nouns, adjectives)
- Every file type has specific patterns and conventions
- Every layer (frontend, backend, database) speaks the same language
- Everything is auditable and enforceable

## Coverage

### 1. File Types Covered
```
Frontend:    .tsx, .ts, .jsx, .js, .css, .scss, .html
Backend:     .ts, .js, .mjs, .cjs, API routes
Python:      .py, .pyi, automation, ML, web apps
Database:    .sql, .prisma, migrations, seeds
Scripts:     .sh, .bash, CLI tools
Config:      .json, .yml, .env, .toml
Docs:        .md, .mdx, stories
Assets:      images, fonts, media
```

### 2. Naming Patterns Defined

#### Frontend Layer
- **Components**: `PascalCase` - Button.tsx → `export default function Button()`
- **Hooks**: `camelCase` with use prefix - useAuth.ts → `export function useAuth()`
- **Pages**: `PascalCase` + Page suffix - InboxPage.tsx
- **CSS**: `kebab-case` BEM - `.content-inbox__header--active`

#### Backend Layer
- **Routes**: `/api/kebab-case` plural - `/api/content-items`
- **Controllers**: `PascalCase` + Controller - `UserController.ts`
- **Services**: `PascalCase` + Service - `AuthService.ts`
- **Middleware**: `camelCase` + Middleware - `authMiddleware.ts`

#### Database Layer
- **Tables**: `plural_snake_case` - `users`, `content_items`
- **Columns**: `snake_case` - `user_id`, `created_at`
- **Migrations**: `{timestamp}_{action}_{target}.sql`
- **Models**: `PascalCase` singular - `User`, `ContentItem`

#### Infrastructure
- **Docker**: lowercase services
- **CI/CD**: `{action}-{environment}.yml`
- **Scripts**: `{action}-{target}.sh`
- **Env vars**: `UPPER_SNAKE_CASE`

#### Python Layer (Same Grammar, Different Style)
- **Modules**: `snake_case.py` - `user_service.py`
- **Functions**: `snake_case` verb-first - `fetch_user()`, `validate_email()`
- **Classes**: `PascalCase` - `class UserService:`
- **Constants**: `UPPER_SNAKE_CASE` - `MAX_RETRIES = 3`
- **Booleans**: `is_/has_/can_` prefix - `is_active`, `has_permission`
- **Tests**: `test_*.py` - `test_user_service.py`
- **Packages**: `snake_case/` - `email_queue/__init__.py`

### 3. Grammar Rules

#### Verb Taxonomy (Actions)
```javascript
// Frontend
render, display, show, toggle, animate

// Data Operations  
fetch, get, create, update, delete, save

// State Management
use, set, clear, reset, initialize

// Validation
validate, verify, check, ensure, assert

// Database
select, insert, migrate, seed, index

// Infrastructure
deploy, build, monitor, scale, provision
```

#### Function Patterns
- **Utilities**: `verbNoun()` - `formatDate()`, `validateEmail()`
- **Event Handlers**: `handleEvent()` - `handleClick()`, `handleSubmit()`
- **Callbacks**: `onEvent()` - `onClick()`, `onSuccess()`
- **Hooks**: `useFeature()` - `useAuth()`, `useScrollPosition()`
- **API**: `actionResource()` - `createUser()`, `fetchPosts()`

#### Boolean Patterns
- `is` + State: `isLoading`, `isActive`, `isValid`
- `has` + Feature: `hasPermission`, `hasError`
- `can` + Action: `canEdit`, `canDelete`
- `should` + Behavior: `shouldUpdate`, `shouldRender`

### 4. Import/Export Rules

#### Export Patterns
```typescript
// Components - Default export
export default function Button() {}

// Hooks - Named export
export function useAuth() {}

// Utils - Named exports
export function formatDate() {}
export function parseTime() {}

// Types - Named exports
export type User = {}
export interface UserProps {}

// Constants - Named UPPER_SNAKE
export const MAX_FILE_SIZE = 5000000
```

#### Import Hierarchy
```
Pages → Features → Services → Models → Database → Utils
```

### 5. Cross-Layer Communication

| From | Can Import | Cannot Import |
|------|------------|---------------|
| **Components** | hooks, utils, types | pages, services |
| **Hooks** | utils, services, types | components |
| **Services** | utils, types | components, hooks |
| **Utils** | types, constants | everything else |

### 6. Metadata System

Every file has:
```typescript
/**
 * @file path/to/file
 * @purpose Clear description
 * @layer frontend|backend|database
 * @deps Dependencies
 * @llm-read true|false
 * @llm-write full-edit|suggest-only|read-only
 * @llm-role utility|entrypoint|pure-view|async-service
 */
```

## Enforcement Tools

### Audit Scripts
1. `audit-naming.sh` - Frontend naming
2. `audit-css-naming.js` - CSS/BEM compliance  
3. `audit-backend-naming.sh` - API patterns
4. `audit-database-naming.sh` - SQL conventions
5. `audit-python-naming.sh` - Python conventions
6. `audit-full-stack-naming.sh` - Everything

### Grammar Files
1. `CODEBASE_GRAMMAR_SYSTEM.md` - Core rules
2. `FULL_STACK_GRAMMAR_SYSTEM.md` - Complete system
3. `full-stack-grammar-schema.json` - Machine-readable rules
4. `naming-grammar-schema.json` - Validation schema

## Benefits Achieved

### For Humans
- **Predictable** - Know exactly how to name anything
- **Searchable** - Find code by pattern
- **Consistent** - Same rules everywhere
- **Documented** - Clear reference guides

### For LLMs
- **Navigation** - Find any code by understanding patterns
- **Generation** - Create correctly-named code
- **Refactoring** - Safe renaming following rules
- **Understanding** - Grammar maps to intent

### Token Efficiency
- Scan 50 files in <1000 tokens
- Understand entire codebase structure
- Navigate by pattern recognition
- Generate compliant code first try

## The Foundation

We've created a complete "language" where:
- Every **function** has an action verb pointing to what it works with
- Every **component** is a noun representing a thing
- Every **boolean** is an adverb describing state
- Every **directory** is a preposition showing relationships
- Every **file** follows predictable patterns

This isn't just naming - it's a complete communication system that both humans and LLMs can speak fluently!

## Polyglot Benefits

With Python added:
- **Same semantic rules** across all languages (verb+noun, layers, patterns)
- **Language-appropriate style** (camelCase for JS/TS, snake_case for Python)
- **Unified mental model** - one grammar, multiple syntaxes
- **Cross-language boundaries** clearly defined
- **LLMs understand** the entire polyglot codebase

The grammar is truly **language-agnostic at the semantic level** - making it perfect for mixed codebases!