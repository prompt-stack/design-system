# Codebase Grammar System - The Complete Language

## Core Principle
Every identifier in code follows grammatical rules like a natural language:
- **Verbs** = Actions (functions)
- **Nouns** = Things (components, types, models)
- **Adjectives** = Modifiers (variants, states)
- **Adverbs** = Conditions (booleans)

## 1. Parts of Speech → Code Elements

| Grammar Role | Code Element | Rule | Examples |
|-------------|--------------|------|----------|
| **Verb** | Function/Method | Always starts with action | `fetchUser`, `createItem`, `validateInput` |
| **Noun (singular)** | Component/Type/Class | Things, no verbs, no plurals | `User`, `Button`, `ContentItem` |
| **Adjective** | Variant/Modifier | Describes state/appearance | `primaryButton`, `disabledInput`, `dangerAlert` |
| **Adverb** | Boolean flag | Condition/state | `isLoading`, `hasError`, `canEdit` |
| **Preposition** | Directory/Namespace | Relationships | `components/Card`, `services/user` |

## 2. Action Verb Taxonomy

### Core Verbs by Category

```typescript
const verbTaxonomy = {
  // Data Operations
  data: ['fetch', 'get', 'list', 'create', 'update', 'delete', 'save', 'load', 'sync'],
  
  // View/Display
  view: ['render', 'display', 'show', 'hide', 'toggle', 'open', 'close'],
  
  // State Management
  state: ['use', 'set', 'clear', 'reset', 'initialize', 'restore'],
  
  // Transformation
  transform: ['format', 'parse', 'convert', 'serialize', 'deserialize', 'normalize'],
  
  // Validation
  validation: ['validate', 'verify', 'check', 'ensure', 'assert'],
  
  // Event Handling
  events: ['handle', 'on', 'emit', 'dispatch', 'listen'],
  
  // Async Operations
  async: ['queue', 'process', 'retry', 'poll', 'stream'],
  
  // Infrastructure
  infra: ['build', 'deploy', 'migrate', 'seed', 'compile', 'bundle']
}
```

## 3. Sentence Patterns (Grammar Rules)

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

## 4. Casing Rules

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

## 5. Export/Import Patterns

### Export Rules

```typescript
// Components - Default export, name matches file
export default function Button() {} // Button.tsx

// Hooks - Named export, starts with 'use'
export function useAuth() {} // useAuth.ts

// Utils - Named exports, verb-first
export function formatDate() {} // dateUtils.ts
export function parseTime() {}

// Types - Named exports
export type User = {} // types.ts
export interface UserProps {}

// Services - Class or object export
export class UserService {} // UserService.ts
export const userApi = {} // userApi.ts

// Constants - Named exports, UPPER_SNAKE
export const MAX_RETRIES = 3 // constants.ts
```

### Import Patterns

```typescript
// Component imports
import Button from '@/components/Button'

// Hook imports
import { useAuth } from '@/hooks/useAuth'

// Util imports
import { formatDate, parseTime } from '@/utils/dateUtils'

// Type imports
import type { User } from '@/types'

// Service imports
import { UserService } from '@/services/UserService'
```

## 6. Directory Grammar

```
src/
├── components/        # Nouns (visual units)
│   └── Button/       
│       ├── Button.tsx         # PascalCase.tsx
│       ├── Button.test.tsx    # PascalCase.test.tsx
│       └── button.css         # lowercase.css
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

## 7. Special Pattern Rules

### Error Classes
```typescript
// Always suffix with 'Error'
class AuthenticationError extends Error {}
class ValidationError extends Error {}
```

### Action Types (Redux/Reducers)
```typescript
// VERB_NOUN pattern
const ADD_TODO = 'ADD_TODO'
const FETCH_USER_SUCCESS = 'FETCH_USER_SUCCESS'
const CLEAR_ERRORS = 'CLEAR_ERRORS'
```

### Test Descriptions
```typescript
// Behavior-first descriptions
describe('UserCard', () => {
  it('should render user information')
  it('displays loading state when fetching')
  it('calls onClick when clicked')
})
```

### Factory Functions
```typescript
// create + Noun
function createUser(data) {}
function createDefaultConfig() {}
```

### Builder Pattern
```typescript
// Noun + Builder
class QueryBuilder {}
class ConfigBuilder {}
```

## 8. File Type Communication Rules

| File Type | Imports From | Exports | Can Import | Cannot Import |
|-----------|--------------|---------|------------|---------------|
| **Component** | hooks, utils, other components | Default component | Any pure function | Pages, API calls directly |
| **Page** | features, components, hooks | Default page component | Anything | Other pages |
| **Hook** | other hooks, utils, services | Named hook function | Pure functions, other hooks | Components |
| **Util** | other utils only | Named pure functions | Other utils | Hooks, components, services |
| **Service** | utils, constants | Class or API object | Utils, types | Components, hooks |
| **Type** | other types | Type definitions | Only other types | Any implementation |

## 9. Grammar Validation Rules

### ✅ Valid Examples
```typescript
// Correct verb-noun for function
function validateEmail(email: string): boolean {}

// Correct use-prefix for hook
function useScrollLock() {}

// Correct PascalCase for component
function UserProfile() {}

// Correct boolean naming
const isLoading = true
const hasPermission = false
```

### ❌ Invalid Examples
```typescript
// Wrong: noun-verb order
function emailValidate() {} // Should be: validateEmail

// Wrong: missing 'use' prefix
function scrollLock() {} // Should be: useScrollLock

// Wrong: camelCase component
function userProfile() {} // Should be: UserProfile

// Wrong: missing boolean prefix
const loading = true // Should be: isLoading
```

## 10. Enforcement Checklist

- [ ] Functions start with allowed verbs
- [ ] Hooks start with 'use'
- [ ] Components are PascalCase
- [ ] Booleans have is/has/can/should prefix
- [ ] Services end with 'Service' or 'Api'
- [ ] Errors end with 'Error'
- [ ] Pages end with 'Page'
- [ ] Constants are UPPER_SNAKE_CASE
- [ ] CSS classes follow BEM
- [ ] Directories are kebab-case
- [ ] Exports match file names
- [ ] Imports follow dependency rules

## 11. LLM Benefits

With this grammar system:

1. **Predictable Generation** - LLM knows exactly how to name new code
2. **Accurate Navigation** - Can find code by understanding naming patterns
3. **Safe Refactoring** - Knows what can import what
4. **Consistent Style** - Every identifier follows the same rules
5. **Natural Mapping** - English phrases map directly to code

## Example: Complete Grammar in Action

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

Every identifier follows the grammar:
- `useContentQueue` - use + Noun (hook pattern)
- `items/setItems` - noun/setState pattern
- `isLoading` - boolean adverb
- `addItem/removeItem` - verb + Noun methods
- `ContentItem` - PascalCase type noun