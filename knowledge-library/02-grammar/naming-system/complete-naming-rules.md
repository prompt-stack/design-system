# Complete Naming Rules - Comprehensive Grammar System

## 📍 Source Information
- **Primary Source**: `/docs/CODEBASE_GRAMMAR_SYSTEM.md` (lines 1-298)
- **Original Intent**: Define complete grammatical rules for code identifiers
- **Key Innovation**: Map natural language parts of speech to code elements
- **Implementation**: Validated by `/scripts/audit-naming.sh`

## 🎯 Core Principle (Lines 3-8)

**Foundational Concept**: Every identifier in code follows grammatical rules like a natural language

### Parts of Speech Mapping
| Grammar Role | Code Element | Linguistic Rule | Technical Implementation |
|-------------|--------------|----------------|------------------------|
| **Verb** | Function/Method | Always starts with action | Must begin with approved verb from taxonomy |
| **Noun (singular)** | Component/Type/Class | Things, no verbs, no plurals | PascalCase, represents entities |
| **Adjective** | Variant/Modifier | Describes state/appearance | Modifies nouns, describes properties |
| **Adverb** | Boolean flag | Condition/state | is/has/can/should prefixes |
| **Preposition** | Directory/Namespace | Relationships | Indicates containment/belonging |

### Critical Nuances:
- **Singular Noun Requirement**: Components must be singular (`User`, not `Users`)
- **No Verb-Noun Mixing**: Components cannot contain action words
- **Adjective Positioning**: Always follows the noun it modifies (`primaryButton`)

## 🎨 Complete Verb Taxonomy (Lines 24-50)

### Architectural Decision Context
This taxonomy was created to **constrain LLM generation** - by limiting approved verbs, we prevent AI hallucination and ensure consistent naming patterns.

### Data Operations Verbs
```typescript
data: ['fetch', 'get', 'list', 'create', 'update', 'delete', 'save', 'load', 'sync']
```

**Semantic Distinctions**:
- `fetch` vs `get`: `fetch` implies async/remote, `get` implies local/synchronous
- `create` vs `save`: `create` implies new entity, `save` implies persistence of existing
- `list` vs `get`: `list` returns arrays, `get` returns single items

### View/Display Verbs
```typescript
view: ['render', 'display', 'show', 'hide', 'toggle', 'open', 'close']
```

**Context-Specific Usage**:
- `render`: React component rendering only
- `display`: General visibility control
- `toggle`: State switching between two values
- `open/close`: Modal, dropdown, or dialog controls

### State Management Verbs
```typescript
state: ['use', 'set', 'clear', 'reset', 'initialize', 'restore']
```

**Critical Exception**: `use` prefix is **reserved for React hooks only**
- `useAuth()` ✅ - React hook pattern
- `useDatabase()` ❌ - Not a React hook, should be `connectDatabase()`

### Transformation Verbs
```typescript
transform: ['format', 'parse', 'convert', 'serialize', 'deserialize', 'normalize']
```

**Data Flow Implications**:
- `format`: Display-ready transformation
- `parse`: String to structured data
- `convert`: Type/format transformation
- `serialize/deserialize`: Object ↔ String conversion
- `normalize`: Data standardization

### Validation Verbs
```typescript
validation: ['validate', 'verify', 'check', 'ensure', 'assert']
```

**Semantic Hierarchy**:
1. `check`: Simple boolean test
2. `validate`: Rule-based verification with detailed results
3. `verify`: Authentication/authorization checks
4. `ensure`: Guarantee state with side effects
5. `assert`: Development-time checks with exceptions

### Event Handling Verbs
```typescript
events: ['handle', 'on', 'emit', 'dispatch', 'listen']
```

**Context Rules**:
- `handle`: Event handler functions (`handleSubmit`)
- `on`: Callback props (`onClick`, `onSuccess`)
- `emit`: Event publishing
- `dispatch`: Redux/state management actions
- `listen`: Event subscription

### Async Operations Verbs
```typescript
async: ['queue', 'process', 'retry', 'poll', 'stream']
```

**Performance Implications**:
- `queue`: Batch processing, order matters
- `process`: Single item handling
- `retry`: Error recovery patterns
- `poll`: Interval-based checking
- `stream`: Real-time data flow

### Infrastructure Verbs
```typescript
infra: ['build', 'deploy', 'migrate', 'seed', 'compile', 'bundle']
```

**Build-Time Context**: These verbs are for development/deployment tools only

## 📋 Sentence Patterns - Grammar Rules (Lines 52-66)

### Core Patterns with Location Rules

| Pattern | Example | When to Use | Mandatory File Location | Validation Script |
|---------|---------|-------------|----------------------|------------------|
| **Verb + Noun** | `formatDate`, `fetchUser` | Stateless operations | `utils/`, `services/` | `audit-naming.sh` |
| **use + Noun** | `useAuth`, `useContentQueue` | React hooks | `hooks/` | `audit-component.sh` |
| **Noun + Provider** | `AuthProvider`, `ThemeProvider` | Context providers | `contexts/` | `audit-naming.sh` |
| **Noun + Service** | `UserService`, `ContentService` | Service classes | `services/` | `audit-backend-naming.sh` |
| **Noun + Page** | `DashboardPage`, `InboxPage` | Route components | `pages/` | `audit-component.sh` |
| **handle + Event** | `handleSubmit`, `handleClick` | Event handlers | Inside components | `audit-component.sh` |
| **on + Event** | `onClick`, `onSuccess` | Event props | Component props | `audit-component.sh` |
| **with + Feature** | `withAuth`, `withTheme` | HOCs | `hocs/` | `audit-naming.sh` |
| **select + Noun** | `selectUserById`, `selectItems` | Selectors | `selectors/` | `audit-naming.sh` |
| **create + Noun** | `createUser`, `createConfig` | Factory functions | `factories/` | `audit-naming.sh` |

### Critical Pattern Nuances:

1. **Event Handler Context**: `handle` vs `on` depends on usage location
   - `handleSubmit` - Inside component definitions
   - `onSubmit` - As props being passed

2. **React Hook Exclusivity**: Only React hooks use `use` prefix
   - File must be in `/hooks/` directory
   - Must follow React hook rules (conditional calls forbidden)

3. **Service Pattern Specificity**: Services are external communication only
   - Must end with `Service` or `Api`
   - Located in `/services/` directory
   - Cannot import components or hooks

## 🔤 Complete Casing Rules (Lines 67-84)

### Casing Decision Matrix

| Element | Case | Pattern | File Example | Directory Example | Rationale |
|---------|------|---------|--------------|------------------|-----------|
| **Function/Method** | camelCase | verbNoun | `fetchUserData.ts` | N/A | JavaScript convention |
| **Component/Class** | PascalCase | Noun | `UserCard.tsx` | N/A | Constructor naming |
| **Hook** | camelCase | useNoun | `useAuth.ts` | `/hooks/` | React convention |
| **Boolean** | camelCase | is/has/can/should + Adjective | N/A | N/A | English grammar |
| **Constant** | UPPER_SNAKE | NOUN_NOUN | `constants.ts` | `/constants/` | Traditional constant style |
| **Enum** | PascalCase | Singular noun | `types.ts` | `/types/` | Type naming consistency |
| **Enum Values** | UPPER_SNAKE | NOUN | `types.ts` | N/A | Constant-like values |
| **CSS Variable** | kebab-case | --category-name | N/A | N/A | CSS specification |
| **CSS Class** | kebab-case | block__element--modifier | N/A | N/A | BEM methodology |
| **File (Component)** | PascalCase | ComponentName.tsx | `Button.tsx` | `/components/` | Match export name |
| **File (Hook)** | camelCase | useFeature.ts | `useAuth.ts` | `/hooks/` | Match export name |
| **File (Util)** | camelCase | featureUtils.ts | `dateUtils.ts` | `/utils/` | Descriptive naming |
| **Directory** | kebab-case | feature-name | N/A | `content-inbox/` | URL-friendly |

### Critical Casing Nuances:

1. **File-Export Matching**: File names MUST match their default export
   - `Button.tsx` exports `export default function Button()`
   - `useAuth.ts` exports `export function useAuth()`

2. **Boolean Prefix Requirements**: All booleans must have semantic prefixes
   - `isLoading` ✅ (state)
   - `hasPermission` ✅ (possession)  
   - `canEdit` ✅ (ability)
   - `shouldUpdate` ✅ (recommendation)
   - `loading` ❌ (missing prefix)

3. **CSS BEM Integration**: CSS classes must follow BEM but directories use kebab-case
   - Component: `UserCard` (PascalCase)
   - CSS class: `.user-card__header--active` (BEM)
   - Directory: `user-card/` (kebab-case)

## 📁 Export/Import Patterns (Lines 85-130)

### Export Rules by File Type

#### Component Exports (Lines 90-91)
```typescript
// Components - Default export, name matches file
export default function Button() {} // Button.tsx
```

**Requirements**:
- MUST be default export
- Function name MUST match file name exactly
- File extension MUST be `.tsx` for components

#### Hook Exports (Lines 93-94)
```typescript
// Hooks - Named export, starts with 'use'
export function useAuth() {} // useAuth.ts
```

**Requirements**:
- MUST be named export (no default)
- Function name MUST start with `use`
- File name MUST match function name

#### Utility Exports (Lines 96-98)
```typescript
// Utils - Named exports, verb-first
export function formatDate() {} // dateUtils.ts
export function parseTime() {}
```

**Requirements**:
- Multiple named exports allowed
- Each function MUST start with approved verb
- File name should indicate domain (`dateUtils`, `stringUtils`)

#### Type Exports (Lines 100-102)
```typescript
// Types - Named exports
export type User = {} // types.ts
export interface UserProps {}
```

**Requirements**:
- Always named exports
- Types use `type`, interfaces use `interface`
- Can be grouped in domain-specific files

#### Service Exports (Lines 104-106)
```typescript
// Services - Class or object export
export class UserService {} // UserService.ts
export const userApi = {} // userApi.ts
```

**Requirements**:
- Can be class OR object
- MUST end with `Service` or `Api`
- File name MUST match export name

#### Constant Exports (Lines 108-109)
```typescript
// Constants - Named exports, UPPER_SNAKE
export const MAX_RETRIES = 3 // constants.ts
```

**Requirements**:
- Always UPPER_SNAKE_CASE
- Must be truly constant (not configuration)
- Group related constants in single file

### Import Patterns (Lines 112-129)

#### Path Alias Requirements
All imports MUST use path aliases (`@/`) for internal modules:

```typescript
// ✅ CORRECT
import Button from '@/components/Button'
import { useAuth } from '@/hooks/useAuth'

// ❌ INCORRECT
import Button from '../components/Button'
import { useAuth } from './hooks/useAuth'
```

#### Type Import Distinction (Lines 124-125)
```typescript
// Type imports MUST use 'type' keyword
import type { User } from '@/types'
```

**Critical Rule**: Runtime imports and type imports must be separated

## 📂 Directory Grammar (Lines 131-156)

### Complete Directory Structure with Grammar Rules

```
src/
├── components/        # Nouns (visual units) - PascalCase files
│   └── Button/       
│       ├── Button.tsx         # Default export matches directory
│       ├── Button.test.tsx    # Test file naming
│       └── button.css         # lowercase CSS
├── features/          # Noun phrases (domain bundles) - kebab-case
│   └── content-inbox/
│       ├── ContentInbox.tsx   # Main feature component (PascalCase)
│       ├── hooks/            # Feature-specific hooks
│       └── utils/            # Feature-specific utils
├── hooks/            # use + Noun (stateful logic) - camelCase files
├── utils/            # Verb phrases (pure functions) - camelCase files
├── services/         # Noun + Service (external communication) - PascalCase files
├── pages/            # Noun + Page (routes) - PascalCase files
├── types/            # Nouns (data shapes) - camelCase files
├── constants/        # UPPER_SNAKE values - camelCase files
├── contexts/         # Noun + Context/Provider - PascalCase files
├── selectors/        # select + Noun - camelCase files
├── reducers/         # Noun + Reducer - camelCase files
├── middleware/       # Noun + Middleware - camelCase files
└── workers/          # Noun + Worker - camelCase files
```

### Directory Grammar Rules:

1. **Directory Names**: Always kebab-case for URL compatibility
2. **File Names**: Casing depends on content type (see casing rules above)
3. **Structure Consistency**: Each directory type has specific file patterns
4. **Feature Bundles**: Complex features get their own directory with sub-structure

## 🔍 Special Pattern Rules (Lines 158-198)

### Error Class Pattern (Lines 160-165)
```typescript
// Always suffix with 'Error'
class AuthenticationError extends Error {}
class ValidationError extends Error {}
```

**Requirements**:
- MUST extend `Error` class
- MUST end with `Error` suffix
- Use PascalCase for class name
- Prefix describes the error domain

### Redux Action Types (Lines 167-173)
```typescript
// VERB_NOUN pattern
const ADD_TODO = 'ADD_TODO'
const FETCH_USER_SUCCESS = 'FETCH_USER_SUCCESS'
const CLEAR_ERRORS = 'CLEAR_ERRORS'
```

**Pattern Rules**:
- UPPER_SNAKE_CASE for constants
- Start with verb (action)
- End with noun (target)
- Success/failure suffixes for async actions

### Test Descriptions (Lines 175-183)
```typescript
// Behavior-first descriptions
describe('UserCard', () => {
  it('should render user information')      // Behavior expectation
  it('displays loading state when fetching') // Present tense behavior
  it('calls onClick when clicked')           // Action-reaction pattern
})
```

**Testing Grammar Rules**:
- `describe()`: Use component/function name exactly
- `it()`: Start with behavior verb or state description
- Focus on behavior, not implementation

### Factory Functions (Lines 185-190)
```typescript
// create + Noun
function createUser(data) {}
function createDefaultConfig() {}
```

**Factory Pattern Requirements**:
- MUST start with `create` verb
- Return new instances
- Located in `/factories/` directory

### Builder Pattern (Lines 192-197)
```typescript
// Noun + Builder
class QueryBuilder {}
class ConfigBuilder {}
```

**Builder Pattern Requirements**:
- MUST end with `Builder` suffix
- Use PascalCase
- Implement fluent interface

## 🔗 File Type Communication Rules - Critical Import Matrix (Lines 199-209)

### Complete Import Dependency Matrix

| File Type | Can Import | Cannot Import | Export Type | Validation Script |
|-----------|------------|---------------|-------------|------------------|
| **Component** | hooks, utils, other components, types | Pages, API calls directly, services | Default component | `audit-component.sh` |
| **Page** | features, components, hooks, services, utils | Other pages | Default page component | `audit-component.sh` |
| **Hook** | other hooks, utils, services, types | Components, pages | Named hook function | `audit-component.sh` |
| **Util** | other utils only, types | Hooks, components, services, pages | Named pure functions | `audit-naming.sh` |
| **Service** | utils, constants, types | Components, hooks, pages | Class or API object | `audit-backend-naming.sh` |
| **Type** | other types only | Any implementation files | Type definitions | `audit-naming.sh` |
| **Feature** | components, hooks, utils, services, types | pages, other features | Default feature component | `audit-component.sh` |
| **Context** | hooks, utils, types | components, pages, services | Provider component | `audit-component.sh` |

### Critical Import Rules:

1. **Circular Dependency Prevention**: Components cannot import pages that might import them
2. **Service Isolation**: Services cannot import UI components to maintain separation
3. **Type Purity**: Type files cannot import implementation to avoid runtime dependencies
4. **Utility Purity**: Utils can only import other utils to maintain functional purity
5. **Hook Constraints**: Hooks cannot import components to avoid dependency cycles

## ✅ Grammar Validation Examples (Lines 211-242)

### Valid Examples with Explanations (Lines 212-226)

```typescript
// Correct verb-noun for function
function validateEmail(email: string): boolean {}
// ✅ Starts with approved verb 'validate', followed by noun 'Email'

// Correct use-prefix for hook
function useScrollLock() {}
// ✅ React hook pattern, starts with 'use', followed by noun phrase

// Correct PascalCase for component
function UserProfile() {}
// ✅ Component naming, PascalCase, noun without verbs

// Correct boolean naming
const isLoading = true      // ✅ State boolean with 'is' prefix
const hasPermission = false // ✅ Possession boolean with 'has' prefix
```

### Invalid Examples with Corrections (Lines 228-242)

```typescript
// Wrong: noun-verb order
function emailValidate() {} // ❌ Noun first, verb second
// Should be: validateEmail() // ✅ Verb first, noun second

// Wrong: missing 'use' prefix
function scrollLock() {} // ❌ Hook without 'use' prefix
// Should be: useScrollLock() // ✅ Proper hook naming

// Wrong: camelCase component
function userProfile() {} // ❌ Component in camelCase
// Should be: UserProfile() // ✅ Component in PascalCase

// Wrong: missing boolean prefix
const loading = true // ❌ Boolean without semantic prefix
// Should be: isLoading // ✅ Boolean with state prefix
```

## 📊 Complete Enforcement Checklist (Lines 243-257)

### Automated Validation Checklist

- [ ] **Functions start with allowed verbs** - Validated by `audit-naming.sh`
- [ ] **Hooks start with 'use'** - Validated by `audit-component.sh`
- [ ] **Components are PascalCase** - Validated by `audit-component.sh`
- [ ] **Booleans have is/has/can/should prefix** - Validated by `audit-naming.sh`
- [ ] **Services end with 'Service' or 'Api'** - Validated by `audit-backend-naming.sh`
- [ ] **Errors end with 'Error'** - Validated by `audit-naming.sh`
- [ ] **Pages end with 'Page'** - Validated by `audit-component.sh`
- [ ] **Constants are UPPER_SNAKE_CASE** - Validated by `audit-naming.sh`
- [ ] **CSS classes follow BEM** - Validated by `audit-css.sh`
- [ ] **Directories are kebab-case** - Validated by `audit-naming.sh`
- [ ] **Exports match file names** - Validated by `validate-component-styles.cjs`
- [ ] **Imports follow dependency rules** - Validated by `audit-component.sh`

### Validation Script Mapping:
- `/scripts/audit-naming.sh` - General naming conventions
- `/scripts/audit-component.sh` - Component-specific rules
- `/scripts/audit-backend-naming.sh` - Service and API naming
- `/scripts/audit-css.sh` - CSS naming conventions
- `/scripts/validate-component-styles.cjs` - File structure validation

## 🤖 LLM Integration Benefits (Lines 258-267)

### Why This Grammar System Enables AI

1. **Predictable Generation** - LLM knows exactly how to name new code
   - **Implementation**: Verb taxonomy constrains function names
   - **Benefit**: No hallucinated or inconsistent naming

2. **Accurate Navigation** - Can find code by understanding naming patterns
   - **Implementation**: Consistent patterns make code searchable
   - **Benefit**: LLM can locate relevant code without reading everything

3. **Safe Refactoring** - Knows what can import what
   - **Implementation**: File type communication rules
   - **Benefit**: LLM won't create circular dependencies

4. **Consistent Style** - Every identifier follows the same rules
   - **Implementation**: Comprehensive casing and pattern rules
   - **Benefit**: Generated code matches existing codebase style

5. **Natural Mapping** - English phrases map directly to code
   - **Implementation**: Parts of speech → code elements mapping
   - **Benefit**: Natural language prompts translate directly to code

## 📝 Complete Grammar Example (Lines 268-298)

### Real-World Implementation Analysis

```typescript
// hooks/useContentQueue.ts
export function useContentQueue() {
  const [items, setItems] = useState<ContentItem[]>([])
  const isLoading = useLoadingState()
  
  const addItem = (item: ContentItem) => {
    setItems(prev => [...prev, item])
  }
  
  const removeItem = (id: string) => {
    setItems(prev => prev.filter(item => item.id !== id))
  }
  
  return {
    items,
    isLoading,
    addItem,
    removeItem
  }
}
```

### Grammar Analysis of Every Identifier:

1. **`useContentQueue`** - Hook pattern (`use` + `ContentQueue`)
   - **Rule**: React hook naming (Lines 57)
   - **Location**: `/hooks/` directory required
   - **Export**: Named export required

2. **`items/setItems`** - State pattern (`noun`/`setState`)
   - **Rule**: React useState convention
   - **Type**: `items` is noun, `setItems` is verb+noun

3. **`isLoading`** - Boolean adverb pattern
   - **Rule**: Boolean naming (Lines 74)
   - **Prefix**: `is` indicates state condition

4. **`addItem/removeItem`** - Verb + Noun methods
   - **Rule**: Function naming (Lines 56)
   - **Verbs**: `add` and `remove` from data operations taxonomy

5. **`ContentItem`** - PascalCase type noun
   - **Rule**: Component/Type naming (Lines 72)
   - **Pattern**: Singular noun, no verbs

### File Structure Compliance:
- **File**: `hooks/useContentQueue.ts` ✅ (camelCase in hooks directory)
- **Export**: Named export ✅ (hook pattern requirement)
- **Imports**: Can import other hooks, utils ✅ (communication rules)

## 🔗 Cross-References

### This Document Connects To:
- **Implementation**: `/scripts/audit-naming.sh` - Validation logic
- **Schema**: `/config/naming-grammar-schema.json` - Machine-readable rules
- **Components**: Component naming follows these rules
- **Testing**: Test naming patterns defined here
- **Architecture**: Directory structure grammar

### This Document Enables:
- **Component Generation**: Templates use these naming rules
- **Code Validation**: Automated grammar checking
- **LLM Integration**: Predictable code generation
- **Team Onboarding**: Clear naming standards

### Dependencies:
- **Framework Detection**: Some rules vary by framework context
- **File Type Analysis**: Rules apply differently by file type
- **Metadata System**: Grammar rules feed into metadata validation