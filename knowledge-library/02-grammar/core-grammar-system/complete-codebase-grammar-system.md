# Complete Codebase Grammar System - The Foundational Language

## 📍 Source Information
- **Primary Source**: `/docs/CODEBASE_GRAMMAR_SYSTEM.md` (lines 1-298)
- **Original Intent**: Define core grammatical rules mapping natural language to code
- **Key Innovation**: Every identifier follows grammatical rules like natural language
- **Revolutionary Concept**: Code becomes a complete, consistent language system

## 🎯 Core Principle - Code as Natural Language (Lines 3-8)

### Fundamental Grammar Mapping

Every identifier in code follows grammatical rules like a natural language:

- **Verbs** = Actions (functions) - What the code does
- **Nouns** = Things (components, types, models) - What the code represents
- **Adjectives** = Modifiers (variants, states) - How things appear
- **Adverbs** = Conditions (booleans) - When/whether things happen

This creates a **complete linguistic system** where code structure mirrors human language structure.

## 🗣️ Parts of Speech → Code Elements - Complete Mapping (Lines 10-18)

### Universal Grammar-to-Code Translation

| Grammar Role | Code Element | Rule | Examples |
|-------------|--------------|------|----------|
| **Verb** | Function/Method | Always starts with action | `fetchUser`, `createItem`, `validateInput` |
| **Noun (singular)** | Component/Type/Class | Things, no verbs, no plurals | `User`, `Button`, `ContentItem` |
| **Adjective** | Variant/Modifier | Describes state/appearance | `primaryButton`, `disabledInput`, `dangerAlert` |
| **Adverb** | Boolean flag | Condition/state | `isLoading`, `hasError`, `canEdit` |
| **Preposition** | Directory/Namespace | Relationships | `components/Card`, `services/user` |

**Key Principles**:
- **Verbs Always Lead**: Functions start with what they do
- **Nouns Stay Singular**: Components represent single concepts
- **Adjectives Modify**: Variants describe variations
- **Adverbs Question**: Booleans answer yes/no questions
- **Prepositions Organize**: Folders show relationships

## 🎬 Action Verb Taxonomy - Complete Verb Library (Lines 22-49)

### Core Verbs by Category

```typescript
const verbTaxonomy = {
  // Data Operations - CRUD and beyond
  data: [
    'fetch',    // Retrieve from external source
    'get',      // Retrieve from internal source
    'list',     // Retrieve multiple items
    'create',   // Make new item
    'update',   // Modify existing item
    'delete',   // Remove item
    'save',     // Persist changes
    'load',     // Bring into memory
    'sync'      // Synchronize data
  ],
  
  // View/Display - Visual operations
  view: [
    'render',   // Draw to screen
    'display',  // Show element
    'show',     // Make visible
    'hide',     // Make invisible
    'toggle',   // Switch visibility
    'open',     // Expand/reveal
    'close'     // Collapse/conceal
  ],
  
  // State Management - Data mutation
  state: [
    'use',       // Hook into state (React)
    'set',       // Update value
    'clear',     // Empty/reset
    'reset',     // Return to initial
    'initialize', // Set up first time
    'restore'    // Return to previous
  ],
  
  // Transformation - Data shape changes
  transform: [
    'format',     // Change for display
    'parse',      // Extract structure
    'convert',    // Change type/format
    'serialize',  // Object to string
    'deserialize', // String to object
    'normalize'   // Standardize format
  ],
  
  // Validation - Correctness checking
  validation: [
    'validate',  // Check against rules
    'verify',    // Confirm truth
    'check',     // Test condition
    'ensure',    // Guarantee state
    'assert'     // Require condition
  ],
  
  // Event Handling - User/system events
  events: [
    'handle',    // Process event
    'on',        // React to event
    'emit',      // Send event
    'dispatch',  // Send action
    'listen'     // Wait for event
  ],
  
  // Async Operations - Time-based
  async: [
    'queue',     // Add to queue
    'process',   // Work through items
    'retry',     // Try again
    'poll',      // Check repeatedly
    'stream'     // Continuous flow
  ],
  
  // Infrastructure - System operations
  infra: [
    'build',     // Compile/package
    'deploy',    // Push to environment
    'migrate',   // Update structure
    'seed',      // Add initial data
    'compile',   // Transform code
    'bundle'     // Package together
  ]
}
```

**Verb Selection Rules**:
1. **Choose Most Specific**: `validateEmail` not `checkEmail`
2. **Match Domain**: Use `render` for UI, `fetch` for API
3. **Be Consistent**: Same verb for same action type
4. **Avoid Synonyms**: Pick one verb per concept

## 📝 Sentence Patterns - Grammar Rules in Practice (Lines 53-65)

### Complete Pattern Library

| Pattern | Example | When to Use | File Location |
|---------|---------|-------------|---------------|
| **Verb + Noun** | `formatDate`, `fetchUser` | Stateless operations | `utils/`, `services/` |
| **use + Noun** | `useAuth`, `useContentQueue` | React hooks | `hooks/` |
| **Noun + Provider** | `AuthProvider`, `ThemeProvider` | Context providers | `contexts/` |
| **Noun + Service** | `UserService`, `ContentService` | Service classes | `services/` |
| **Noun + Page** | `DashboardPage`, `InboxPage` | Route components | `pages/` |
| **handle + Event** | `handleSubmit`, `handleClick` | Event handlers | Inside components |
| **on + Event** | `onClick`, `onSuccess` | Event props | Component props |
| **with + Feature** | `withAuth`, `withTheme` | HOCs | `hocs/` |
| **select + Noun** | `selectUserById`, `selectItems` | Selectors | `selectors/` |
| **create + Noun** | `createUser`, `createConfig` | Factory functions | `factories/` |

**Pattern Selection Guide**:
- **Actions on Data**: Verb + Noun (`validateInput`)
- **React Patterns**: Framework conventions (`useEffect`)
- **Class Patterns**: Noun + Role (`UserController`)
- **Event Patterns**: Action + Event (`handleClick`)

## 🔤 Casing Rules - Complete Style Guide (Lines 68-83)

### Comprehensive Casing Convention Table

| Element | Case | Pattern | Example |
|---------|------|---------|---------|
| **Function/Method** | camelCase | verbNoun | `fetchUserData` |
| **Component/Class** | PascalCase | Noun | `UserCard`, `AuthService` |
| **Hook** | camelCase | useNoun | `useScrollPosition` |
| **Boolean** | camelCase | is/has/can/should + Adjective | `isActive`, `hasPermission` |
| **Constant** | UPPER_SNAKE | NOUN_NOUN | `MAX_FILE_SIZE`, `API_TIMEOUT` |
| **Enum** | PascalCase | Singular noun | `Role`, `Status` |
| **Enum Values** | UPPER_SNAKE | NOUN | `Role.ADMIN`, `Status.PENDING` |
| **CSS Variable** | kebab-case | --category-name | `--color-primary`, `--space-md` |
| **CSS Class** | kebab-case | block__element--modifier | `card__header--active` |
| **File (Component)** | PascalCase | ComponentName.tsx | `Button.tsx`, `UserCard.tsx` |
| **File (Hook)** | camelCase | useFeature.ts | `useAuth.ts`, `useDebounce.ts` |
| **File (Util)** | camelCase | featureUtils.ts | `dateUtils.ts`, `stringUtils.ts` |
| **Directory** | kebab-case | feature-name | `content-inbox/`, `user-profile/` |

**Casing Philosophy**:
- **PascalCase**: "Proper nouns" - Components, Classes, Types
- **camelCase**: "Common words" - Functions, variables
- **UPPER_SNAKE**: "Shouting" - Constants that never change
- **kebab-case**: "URL-friendly" - Files, directories, CSS

## 📦 Export/Import Patterns - Module Communication (Lines 87-129)

### Export Rules by File Type

```typescript
// Components - Default export, name matches file
// Button.tsx
export default function Button() {}

// Hooks - Named export, starts with 'use'
// useAuth.ts
export function useAuth() {}

// Utils - Named exports, verb-first
// dateUtils.ts
export function formatDate() {}
export function parseTime() {}

// Types - Named exports
// types.ts
export type User = {}
export interface UserProps {}

// Services - Class or object export
// UserService.ts
export class UserService {}
// userApi.ts
export const userApi = {}

// Constants - Named exports, UPPER_SNAKE
// constants.ts
export const MAX_RETRIES = 3
export const API_TIMEOUT = 5000
```

### Import Pattern Conventions

```typescript
// Component imports - Default imports
import Button from '@/components/Button'
import UserCard from '@/components/UserCard'

// Hook imports - Named imports
import { useAuth } from '@/hooks/useAuth'
import { useDebounce, useThrottle } from '@/hooks/timing'

// Util imports - Named imports
import { formatDate, parseTime } from '@/utils/dateUtils'
import { validateEmail, validatePhone } from '@/utils/validators'

// Type imports - Type-only imports
import type { User } from '@/types'
import type { ApiResponse } from '@/types/api'

// Service imports - Class or const imports
import { UserService } from '@/services/UserService'
import { apiClient } from '@/services/apiClient'
```

**Import Ordering Convention**:
1. External packages
2. Aliases (@/ imports)
3. Relative imports
4. Type imports
5. CSS imports

## 📁 Directory Grammar - Structural Language (Lines 132-156)

### Complete Directory Architecture

```
src/
├── components/        # Nouns (visual units)
│   └── Button/       
│       ├── Button.tsx         # PascalCase.tsx - Main component
│       ├── Button.test.tsx    # PascalCase.test.tsx - Tests
│       └── button.css         # lowercase.css - Styles
├── features/          # Noun phrases (domain bundles)
│   └── content-inbox/
│       ├── ContentInbox.tsx   # Main feature component
│       ├── hooks/            # Feature-specific hooks
│       └── utils/            # Feature-specific utils
├── hooks/            # use + Noun (stateful logic)
├── utils/            # Verb phrases (pure functions)
├── services/         # Noun + Service (external communication)
├── pages/            # Noun + Page (routes)
├── types/            # Nouns (data shapes)
├── constants/        # UPPER_SNAKE values
├── contexts/         # Noun + Context/Provider
├── selectors/        # select + Noun
├── reducers/         # Noun + Reducer
├── middleware/       # Noun + Middleware
└── workers/          # Noun + Worker
```

**Directory Principles**:
- **Singular Names**: `component/` not `components/` (except root dirs)
- **Feature Grouping**: Related code stays together
- **Clear Purpose**: Directory name indicates content type
- **Flat When Possible**: Avoid deep nesting

## 🎯 Special Pattern Rules - Domain-Specific Grammar (Lines 160-197)

### Error Classes
```typescript
// Always suffix with 'Error'
class AuthenticationError extends Error {}
class ValidationError extends Error {}
class NetworkError extends Error {}
// Never: class AuthFailed, class BadValidation
```

### Action Types (Redux/State Management)
```typescript
// VERB_NOUN pattern in UPPER_SNAKE
const ADD_TODO = 'ADD_TODO'
const FETCH_USER_SUCCESS = 'FETCH_USER_SUCCESS'
const CLEAR_ERRORS = 'CLEAR_ERRORS'
const UPDATE_PROFILE_FAILED = 'UPDATE_PROFILE_FAILED'
```

### Test Descriptions
```typescript
// Behavior-first descriptions
describe('UserCard', () => {
  it('should render user information')        // Start with "should"
  it('displays loading state when fetching')  // Or present tense
  it('calls onClick when clicked')           // Clear cause-effect
  it('throws error when props are invalid')  // Error cases explicit
})
```

### Factory Functions
```typescript
// create + Noun pattern
function createUser(data: Partial<User>): User {}
function createDefaultConfig(): Config {}
function createMockResponse(): ApiResponse {}
```

### Builder Pattern
```typescript
// Noun + Builder suffix
class QueryBuilder {
  select(fields: string[]): this {}
  where(condition: string): this {}
  build(): Query {}
}

class ConfigBuilder {}
class RequestBuilder {}
```

## 🔀 File Type Communication Rules - Dependency Grammar (Lines 200-208)

### Import Hierarchy Matrix

| File Type | Imports From | Exports | Can Import | Cannot Import |
|-----------|--------------|---------|------------|---------------|
| **Component** | hooks, utils, other components | Default component | Any pure function | Pages, API calls directly |
| **Page** | features, components, hooks | Default page component | Anything | Other pages |
| **Hook** | other hooks, utils, services | Named hook function | Pure functions, other hooks | Components |
| **Util** | other utils only | Named pure functions | Other utils | Hooks, components, services |
| **Service** | utils, constants | Class or API object | Utils, types | Components, hooks |
| **Type** | other types | Type definitions | Only other types | Any implementation |

**Dependency Principles**:
- **Unidirectional Flow**: Higher layers import lower layers
- **No Circular Deps**: A→B→C never C→A
- **Layer Isolation**: Each layer has clear boundaries
- **Pure at Bottom**: Utils have no dependencies

## ✅ Grammar Validation Examples (Lines 212-241)

### Valid Examples - Following Grammar

```typescript
// ✅ Correct verb-noun for function
function validateEmail(email: string): boolean {}

// ✅ Correct use-prefix for hook
function useScrollLock() {}

// ✅ Correct PascalCase for component
function UserProfile() {}

// ✅ Correct boolean naming
const isLoading = true
const hasPermission = false
const canEdit = user.role === 'admin'
const shouldRefresh = Date.now() > lastUpdate

// ✅ Correct service naming
class AuthenticationService {}
const userApi = createApiClient('/users')

// ✅ Correct constant naming
const MAX_UPLOAD_SIZE = 10485760
const DEFAULT_TIMEOUT = 30000
```

### Invalid Examples - Grammar Violations

```typescript
// ❌ Wrong: noun-verb order
function emailValidate() {} // Should be: validateEmail

// ❌ Wrong: missing 'use' prefix
function scrollLock() {} // Should be: useScrollLock

// ❌ Wrong: camelCase component
function userProfile() {} // Should be: UserProfile

// ❌ Wrong: missing boolean prefix
const loading = true // Should be: isLoading
const error = false // Should be: hasError

// ❌ Wrong: plural component name
function Users() {} // Should be: UserList or UserGrid

// ❌ Wrong: verb in component name
function FetchUser() {} // Should be: UserFetcher or UserLoader
```

## 📋 Enforcement Checklist - Grammar Validation (Lines 244-256)

### Complete Grammar Compliance Checklist

- [ ] Functions start with allowed verbs from taxonomy
- [ ] Hooks start with 'use' prefix
- [ ] Components are PascalCase nouns
- [ ] Booleans have is/has/can/should prefix
- [ ] Services end with 'Service' or 'Api'
- [ ] Errors end with 'Error' suffix
- [ ] Pages end with 'Page' suffix
- [ ] Constants are UPPER_SNAKE_CASE
- [ ] CSS classes follow BEM convention
- [ ] Directories are kebab-case
- [ ] Exports match file names
- [ ] Imports follow dependency rules

## 🤖 LLM Benefits - AI-Friendly Grammar (Lines 258-266)

### How Grammar Helps Language Models

With this grammar system:

1. **Predictable Generation** - LLM knows exactly how to name new code
   - Function? Start with verb
   - Component? Use PascalCase noun
   - Boolean? Add is/has/can prefix

2. **Accurate Navigation** - Can find code by understanding naming patterns
   - Need user data? Look for `fetchUser`, `getUser`
   - Need authentication? Find `useAuth`, `AuthService`
   - Need validation? Search `validate*` functions

3. **Safe Refactoring** - Knows what can import what
   - Components can't import pages
   - Utils can't import hooks
   - Clear dependency rules

4. **Consistent Style** - Every identifier follows the same rules
   - No debates about naming
   - Automatic compliance
   - Predictable patterns

5. **Natural Mapping** - English phrases map directly to code
   - "fetch user data" → `fetchUserData()`
   - "user profile component" → `UserProfile`
   - "is loading?" → `isLoading`

## 💡 Complete Grammar in Action - Real Example (Lines 269-298)

### Comprehensive Example: Content Queue Hook

```typescript
// hooks/useContentQueue.ts
export function useContentQueue() {
  // State: nouns for data
  const [items, setItems] = useState<ContentItem[]>([])
  
  // Boolean: adverb for condition
  const isLoading = useLoadingState()
  
  // Method: verb + noun for action
  const addItem = (item: ContentItem) => {
    setItems(prev => [...prev, item])
  }
  
  // Method: verb + noun for action
  const removeItem = (id: string) => {
    setItems(prev => prev.filter(item => item.id !== id))
  }
  
  // Return: noun-based API
  return {
    items,        // Noun: the data
    isLoading,    // Adverb: the state
    addItem,      // Verb: the action
    removeItem    // Verb: the action
  }
}
```

**Grammar Analysis**:
- `useContentQueue` - use + Noun (hook pattern) ✓
- `items/setItems` - noun/setState pattern ✓
- `isLoading` - boolean adverb ✓
- `addItem/removeItem` - verb + Noun methods ✓
- `ContentItem` - PascalCase type noun ✓

Every identifier follows the grammar perfectly!

## 🔗 Cross-References & Integration

### This System Connects To:
- **Naming Patterns**: `/02-grammar/naming-patterns/` - Specific naming rules
- **Full Stack Grammar**: `/02-grammar/full-stack-system/` - Extended to all layers
- **Component Architecture**: `/01-architecture/component-layers/` - Structural patterns
- **Test Grammar**: `/03-testing/test-driven-grammar/` - Testing language patterns

### This System Enables:
- **Consistent Codebase**: Every file follows same rules
- **Rapid Onboarding**: New developers learn one system
- **AI-Powered Development**: LLMs understand structure
- **Reduced Cognitive Load**: Predictable patterns everywhere
- **Self-Documenting Code**: Names explain purpose

### Dependencies:
- **Team Buy-In**: Everyone must follow grammar
- **Tooling Support**: Linters enforce rules
- **Documentation**: Grammar guide accessible
- **Training**: Developers learn the system
- **Evolution**: Grammar adapts to new patterns

## 🎯 Revolutionary Impact

This Grammar System creates:

1. **A True Programming Language** - Not just syntax, but linguistic structure
2. **Universal Understanding** - Humans and AI speak same language
3. **Predictable Patterns** - Know how to name anything
4. **Self-Enforcing Quality** - Grammar rules ensure consistency
5. **Scalable Knowledge** - Patterns work from small to large codebases

The codebase becomes a **living language** that communicates intent through structure!