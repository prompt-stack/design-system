# Comprehensive Codebase Naming System

## File Naming by Type

### Scripts (Shell/JS)
Pattern: `{action}-{target}.{ext}`

**Actions (verb-first):**
- `audit-` : Check compliance/quality
- `add-` : Add something to files
- `build-` : Generate/compile something
- `find-` : Search for something
- `validate-` : Verify correctness
- `update-` : Modify existing content
- `generate-` : Create new content
- `migrate-` : Transform between formats

**Examples:**
```
audit-naming.sh          ✅ Correct
audit-css.sh            ❌ Should be: audit-css.sh
generate-component.js    ✅ Correct (though could be build-component.js)
```

### Component Files
Pattern: `{ComponentName}.{ext}`
```
Button.tsx              # Component
Button.test.tsx         # Test
button.css              # Styles (lowercase)
Button.stories.tsx      # Storybook
```

### Hook Files
Pattern: `use{Feature}.{ext}`
```
useContentQueue.ts      # Hook file
useLocalStorage.ts      
useDebounce.ts          
```

### Service/API Files
Pattern: `{Domain}{Type}.{ext}`
```
ContentInboxService.ts  # Service class
ContentInboxApi.ts      # API interface
contentInboxRoutes.ts   # Route definitions
```

### Config Files
Pattern: `{name}.config.{ext}` or `{name}rc`
```
vite.config.ts          # Tool config
.eslintrc               # Linter config
tsconfig.json           # TypeScript config
```

## Directory Structure

### Frontend
```
src/
├── components/         # Shared UI components
├── features/          # Feature modules
├── pages/             # Route pages
├── hooks/             # Custom hooks
├── utils/             # Utilities
├── services/          # API services
├── styles/            # Global styles
└── types/             # TypeScript types
```

### Backend
```
server/
├── routes/            # API routes
├── services/          # Business logic
├── models/            # Data models
├── middleware/        # Express middleware
└── utils/             # Server utilities
```

### Scripts
```
design-system/
└── scripts/
    ├── audit-*.sh     # Compliance checks
    ├── add-*.sh       # File modifiers
    ├── build-*.sh     # Generators
    └── find-*.sh      # Searchers
```

## Naming Patterns by Context

### React Components
```typescript
// PascalCase components
export function ContentInbox() {}
export function QueueManager() {}

// Props with 'Props' suffix
interface ButtonProps {}
interface ModalProps {}
```

### Functions
```typescript
// camelCase, verb-first
function processContent() {}
function validateInput() {}

// Event handlers
function handleClick() {}
function handleSubmit() {}

// Callbacks  
function onClick() {}
function onUpdate() {}
```

### Variables
```typescript
// camelCase
const userName = 'John';
const contentItems = [];

// Boolean with is/has/should
const isLoading = false;
const hasError = false;
const shouldUpdate = true;

// Constants SCREAMING_SNAKE
const MAX_FILE_SIZE = 5000000;
const API_TIMEOUT = 30000;
```

### CSS Classes (BEM)
```css
/* Block */
.content-inbox {}

/* Element */
.content-inbox__header {}
.content-inbox__item {}

/* Modifier */
.content-inbox--loading {}
.content-inbox__item--selected {}

/* State */
.is-active {}
.is-loading {}
```

### API Endpoints
```
GET    /api/content-inbox/items       # kebab-case, plural
POST   /api/content-inbox/items       
GET    /api/content-inbox/items/:id   # singular for specific
PUT    /api/content-inbox/items/:id
DELETE /api/content-inbox/items/:id

POST   /api/content-inbox/process     # verb for actions
POST   /api/content-inbox/bulk-import # kebab-case multi-word
```

### Database/Storage
```sql
-- Tables: plural, snake_case
content_items
metadata_entries
processing_queue

-- Columns: snake_case
content_id
source_url
created_at
is_processed
```

### TypeScript Types
```typescript
// PascalCase for types/interfaces
type ContentItem = {};
interface ProcessingOptions {}

// Enums PascalCase
enum ContentType {
  Article = 'article',
  Video = 'video'
}

// Type unions
type Status = 'pending' | 'processing' | 'completed';
```

## Common Prefixes/Suffixes

### Prefixes
- `use` - React hooks
- `is` - Boolean state
- `has` - Boolean check
- `should` - Boolean condition
- `get` - Getter function
- `set` - Setter function
- `handle` - Event handler
- `on` - Event callback
- `with` - HOC
- `_` - Private/internal

### Suffixes
- `Props` - Component props
- `State` - State types
- `Context` - React context
- `Provider` - Context provider
- `Service` - Service class
- `Api` - API interface
- `Error` - Error class
- `Config` - Configuration
- `Options` - Option types
- `Params` - Parameter types

## File Extension Guidelines

### Code Files
- `.ts` - TypeScript logic
- `.tsx` - React components
- `.js` - JavaScript (legacy/config)
- `.cjs` - CommonJS modules
- `.mjs` - ES modules
- `.d.ts` - Type declarations

### Style Files
- `.css` - Component styles
- `.scss` - Sass styles (if used)
- `.module.css` - CSS modules

### Config Files
- `.json` - Data/config
- `.yml/.yaml` - YAML config
- `.env` - Environment vars
- `.*rc` - Tool config

### Documentation
- `.md` - Markdown docs
- `.mdx` - MDX (if used)

## Validation Checklist

Before naming, ask:
1. ✅ Does it follow the pattern for its type?
2. ✅ Is the purpose immediately clear?
3. ✅ Is it consistent with similar files?
4. ✅ Does it avoid unnecessary abbreviations?
5. ✅ Is it properly cased?
6. ✅ Would a new developer understand it?
7. ✅ Is it unique and searchable?

## Anti-patterns to Avoid

❌ Abbreviations: `UsrMgr` → `UserManager`
❌ Unclear names: `data.ts` → `contentData.ts`
❌ Wrong case: `mycomponent.tsx` → `MyComponent.tsx`
❌ Missing prefixes: `loading` → `isLoading`
❌ Inconsistent: `user-data.ts` + `userData.ts`
❌ Too generic: `utils.ts` → `dateUtils.ts`
❌ Hungarian notation: `strName` → `name`