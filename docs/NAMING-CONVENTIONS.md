# Naming Conventions

## Overview
This document establishes naming conventions across all layers of the Content Stack application to ensure consistency and maintainability.

## File Naming

### React Components
```
Button.tsx              # PascalCase for component files
Button.test.tsx         # Test files with .test suffix
button.css              # Lowercase with hyphens for CSS
index.ts                # Index files for exports
```

### Hooks
```
useContentQueue.ts      # camelCase with 'use' prefix
useLocalStorage.ts      # Descriptive of what it manages
useDebounce.ts          # Action-based naming
```

### Utilities
```
formatDate.ts           # camelCase, verb-first
validateUrl.ts          # Clear action
generateHash.ts         # Specific purpose
```

### Types/Interfaces
```
types.ts                # Generic types file
ContentTypes.ts         # Domain-specific types
index.d.ts              # Type declarations
```

## Code Naming

### Components
```typescript
// PascalCase for components
export function ContentInbox() { }
export function QueueManager() { }
export function MetadataPanel() { }

// Props interfaces with 'Props' suffix
interface ButtonProps { }
interface ModalProps { }
```

### Variables
```typescript
// camelCase for variables
const userName = 'John';
const isLoading = false;
const contentItems = [];

// SCREAMING_CASE for constants
const MAX_FILE_SIZE = 50 * 1024 * 1024;
const API_TIMEOUT = 30000;
const DEFAULT_PAGE_SIZE = 20;
```

### Functions
```typescript
// camelCase, verb-first for functions
function processContent(data: Content) { }
function validateInput(value: string) { }
function extractMetadata(file: File) { }

// Event handlers with 'handle' prefix
function handleClick(event: MouseEvent) { }
function handleSubmit(data: FormData) { }
function handleChange(value: string) { }

// Callbacks with 'on' prefix
interface Props {
  onClick: (id: string) => void;
  onUpdate: (data: Data) => void;
  onClose: () => void;
}
```

### Hooks
```typescript
// 'use' prefix, descriptive name
function useContentQueue() { }
function useLocalStorage(key: string) { }
function useDebounce(value: string, delay: number) { }

// Return tuple for state + setter
const [items, setItems] = useContentQueue();
```

## CSS Naming (BEM)

### Block Element Modifier
```css
/* Block - Component root */
.content-inbox { }
.queue-manager { }
.metadata-panel { }

/* Element - Component part */
.content-inbox__header { }
.content-inbox__item { }
.content-inbox__footer { }

/* Modifier - Variation */
.content-inbox--loading { }
.content-inbox--empty { }
.content-inbox__item--selected { }

/* State - Temporary state */
.content-inbox.is-dragging { }
.content-inbox__item.is-processing { }
```

### Utility Classes
```css
/* Utility prefix with purpose */
.u-text-center { }
.u-mt-2 { }         /* margin-top: 2 units */
.u-hidden { }
.u-flex { }
```

## API/Backend Naming

### Routes
```
/api/content-inbox/items      # kebab-case, plural resources
/api/content-inbox/process    # verb for actions
/api/metadata/extract         # clear hierarchy
```

### Database Fields
```javascript
{
  content_id: 'string',       // snake_case
  created_at: 'timestamp',
  source_url: 'string',
  is_processed: 'boolean'
}
```

## Props Naming

### Boolean Props
```typescript
// Use 'is', 'has', 'should' prefixes
isLoading: boolean;
hasError: boolean;
shouldAutoFocus: boolean;
isDisabled: boolean;
```

### Event Props
```typescript
// Use 'on' prefix
onClick: () => void;
onChange: (value: string) => void;
onSuccess: (data: Data) => void;
onError: (error: Error) => void;
```

### Render Props
```typescript
// Use 'render' prefix or children
renderItem: (item: Item) => ReactNode;
renderHeader: () => ReactNode;
children: (props: RenderProps) => ReactNode;
```

## State Variables

### Boolean States
```typescript
const [isOpen, setIsOpen] = useState(false);
const [isLoading, setIsLoading] = useState(false);
const [hasError, setHasError] = useState(false);
```

### Data States
```typescript
const [items, setItems] = useState<Item[]>([]);
const [selectedId, setSelectedId] = useState<string | null>(null);
const [formData, setFormData] = useState<FormData>(initialData);
```

## Enum Naming
```typescript
// PascalCase for enum names
enum ContentType {
  Article = 'article',
  Video = 'video',
  Image = 'image'
}

enum ProcessingStatus {
  Pending = 'pending',
  Processing = 'processing',
  Completed = 'completed',
  Failed = 'failed'
}
```

## Type Naming
```typescript
// PascalCase for types
type ContentItem = {
  id: string;
  title: string;
};

// Suffix with 'Type' when ambiguous
type ProcessingStatusType = 'pending' | 'processing' | 'completed';

// Union types
type Size = 'small' | 'medium' | 'large';
type Variant = 'primary' | 'secondary' | 'danger';
```

## Test Naming
```typescript
// Describe what is being tested
describe('ContentInbox', () => {
  // Use 'should' or behavior description
  it('should render without errors', () => {});
  it('displays empty state when no items', () => {});
  it('calls onItemClick when item is clicked', () => {});
  
  // Group related tests
  describe('when processing content', () => {
    it('shows loading spinner', () => {});
    it('disables submit button', () => {});
  });
});
```

## Configuration Files
```
.env                    # Environment variables
.env.example            # Example template
config.ts               # App configuration
constants.ts            # App constants
```

## Common Patterns

### Pluralization
- Collections: plural (`items`, `users`, `contentItems`)
- Single items: singular (`item`, `user`, `contentItem`)
- API endpoints: plural for resources (`/api/items`)

### Prefixes/Suffixes
- `is` - Boolean state (isLoading, isValid)
- `has` - Boolean possession (hasError, hasPermission)
- `should` - Boolean behavior (shouldUpdate, shouldRender)
- `handle` - Event handler (handleClick, handleSubmit)
- `on` - Event prop (onClick, onChange)
- `use` - Hook (useEffect, useContentQueue)
- `with` - HOC (withAuth, withTheme)
- `Provider` - Context provider (ThemeProvider, AuthProvider)
- `Context` - React context (ThemeContext, AuthContext)

### Acronyms
- Treat as words: `XmlParser` not `XMLParser`
- In constants: `API_KEY` not `APIKEY`
- Exception: Well-known acronyms like `URL`, `API`

## Naming Checklist
- [ ] Is the purpose immediately clear?
- [ ] Does it follow the established pattern?
- [ ] Is it consistent with similar items?
- [ ] Would a new developer understand it?
- [ ] Is it searchable and unique enough?
- [ ] Does it avoid abbreviations (unless standard)?
- [ ] Is it properly cased for its context?