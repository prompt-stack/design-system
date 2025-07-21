# LLM Quick Reference Guide

## Overview
This guide helps LLMs (Language Models) quickly understand and work with the Content Stack codebase. It provides context, patterns, and rules for consistent code generation.

## Project Context
**Content Stack** is a personal content management system that helps users collect, process, and organize digital content (articles, videos, images) into a searchable library.

### Key User Flow
1. User drops/pastes/uploads content into the Inbox
2. System processes and extracts metadata
3. Content is organized with auto-generated tags
4. User can search and retrieve content from their Library

## Architecture Overview

### Frontend Structure
```
/src
  /components      # Reusable UI components (primitives & composed)
  /features        # Feature-specific components with business logic
  /pages          # Route-level components
  /hooks          # Custom React hooks
  /services       # API communication layer
  /styles         # CSS files (mirrors component structure)
```

### Backend Structure
```
/backend
  /services       # Business logic
  /routes         # API endpoints
  /utils          # Helper functions
  /types          # TypeScript definitions
```

## Code Generation Rules

### 1. Component Creation
```typescript
// Always include these markers
/**
 * @layer primitive|composed|feature
 * @cssFile /styles/components/[name].css
 * @dependencies List other components used
 * @className .component-name
 */

// Use functional components with TypeScript
export function ComponentName({ prop1, prop2 }: ComponentProps) {
  // Implementation
}
```

### 2. CSS Patterns
```css
/* Follow BEM naming */
.component-name { }                    /* Block */
.component-name__element { }           /* Element */
.component-name--modifier { }          /* Modifier */
.component-name.is-state { }          /* State */

/* Use CSS variables for all values */
color: var(--color-primary);
padding: var(--space-md);
```

### 3. State Management
```typescript
// Prefer local state for UI
const [isOpen, setIsOpen] = useState(false);

// Use reducers for complex state
const [state, dispatch] = useReducer(reducer, initialState);

// Custom hooks for shared logic
const { items, addItem, removeItem } = useContentQueue();
```

### 4. API Patterns
```typescript
// All API calls go through services
import { ContentInboxApi } from '@/services/ContentInboxApi';

// Consistent error handling
try {
  const result = await ContentInboxApi.processContent(data);
  // Handle success
} catch (error) {
  // Show user-friendly error
}
```

## Common Patterns

### Modal Management
```typescript
// Single state object for modals
const [modalState, setModalState] = useState({
  isOpen: false,
  data: null,
  mode: 'create' // 'create' | 'edit' | 'view'
});
```

### List Rendering with Virtual Scrolling
```typescript
// Use VirtualList for large lists
<VirtualList
  items={filteredItems}
  height={600}
  itemHeight={80}
  renderItem={(item) => <ItemComponent {...item} />}
/>
```

### Form Handling
```typescript
// Controlled components with validation
const [formData, setFormData] = useState(initialValues);
const errors = validateForm(formData);

const handleSubmit = async (e: FormEvent) => {
  e.preventDefault();
  if (Object.keys(errors).length === 0) {
    await submitForm(formData);
  }
};
```

## File Naming Conventions

### React Components
```
ComponentName.tsx           # PascalCase
useCustomHook.ts           # camelCase with 'use' prefix
component-name.css         # kebab-case for CSS
CONSTANTS.ts              # SCREAMING_CASE for constants
```

### Backend Files
```
ContentInboxService.ts     # PascalCase for classes
contentInbox.ts           # camelCase for routes
generateContentId.ts      # camelCase for utils
```

## Import Order
```typescript
// 1. React/External libraries
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

// 2. Internal absolute imports
import { Button } from '@/components/Button';
import { useAuth } from '@/hooks/useAuth';

// 3. Relative imports
import { LocalComponent } from './LocalComponent';
import './styles.css';

// 4. Types
import type { ContentItem } from '@/types';
```

## Error Handling Patterns

### User-Friendly Errors
```typescript
// Transform technical errors
catch (error) {
  if (error.code === 'NETWORK_ERROR') {
    showError('Connection lost. Please check your internet.');
  } else if (error.code === 'FILE_TOO_LARGE') {
    showError('File is too large (max: 50MB)');
  } else {
    showError('Something went wrong. Please try again.');
  }
}
```

### Graceful Degradation
```typescript
// Always provide fallbacks
const content = await fetchContent().catch(() => []);
const metadata = extractMetadata(data) || getDefaultMetadata();
```

## Component Communication

### Props vs Context
```typescript
// Use props for direct parent-child
<ChildComponent data={data} onUpdate={handleUpdate} />

// Use context for deeply nested or global state
const { theme } = useTheme();
const { user } = useAuth();
```

### Event Naming
```typescript
// Consistent callback naming
onItemClick      // Not: handleClick, clickHandler
onDataUpdate     // Not: updateData, handleUpdate
onModalClose     // Not: closeModal, handleClose
```

## Performance Guidelines

### Memoization
```typescript
// Memoize expensive computations
const filteredItems = useMemo(
  () => items.filter(item => item.matches(query)),
  [items, query]
);

// Memoize callbacks
const handleClick = useCallback(
  (id: string) => { /* ... */ },
  [dependency]
);
```

### Code Splitting
```typescript
// Lazy load heavy features
const HeavyFeature = lazy(() => import('@/features/HeavyFeature'));
```

## Testing Approach
```typescript
// Component testing pattern
describe('ComponentName', () => {
  it('renders without crashing', () => {
    render(<ComponentName />);
  });
  
  it('handles user interaction', async () => {
    const { getByRole } = render(<ComponentName />);
    await userEvent.click(getByRole('button'));
    expect(/* assertion */).toBe(true);
  });
});
```

## Common Gotchas

### State Updates
```typescript
// ❌ Mutating state
state.items.push(newItem);

// ✅ Creating new state
setState(prev => ({
  ...prev,
  items: [...prev.items, newItem]
}));
```

### Effect Dependencies
```typescript
// ❌ Missing dependencies
useEffect(() => {
  doSomething(value);
}, []); // Missing 'value'

// ✅ Complete dependencies
useEffect(() => {
  doSomething(value);
}, [value]);
```

## Quick Decision Tree

**Creating a new component?**
1. Is it reusable with no business logic? → `/components`
2. Does it have feature-specific logic? → `/features/[feature-name]`
3. Is it a page/route? → `/pages`

**Styling approach?**
1. Component-specific styles? → Create matching CSS file
2. Utility styles? → Use existing utility classes
3. Dynamic styles? → Use CSS variables with inline styles

**State management?**
1. Local to component? → useState
2. Complex state logic? → useReducer
3. Shared across app? → Context or global store

## Code Review Checklist
- [ ] Follows naming conventions
- [ ] Has proper TypeScript types
- [ ] Includes error handling
- [ ] Uses semantic HTML
- [ ] Follows accessibility guidelines
- [ ] Has meaningful comments where needed
- [ ] No console.logs in production code
- [ ] Consistent with existing patterns