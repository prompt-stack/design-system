# Component Metadata Standard

## Essential Metadata (Required)
These fields are parsed by validation scripts and must be present:

```typescript
/**
 * @layer primitive|composed|feature
 * @dependencies None|[ComponentA, ComponentB]
 * @cssFile /src/styles/components/component-name.css
 */
```

## Useful Metadata (Recommended)
Add these for better LLM understanding and documentation:

```typescript
/**
 * @className .component-name
 * @status stable|beta|deprecated
 * @description One-line component purpose
 */
```

## Optional Metadata (When Valuable)
Only add if it helps developers or LLMs use the component:

```typescript
/**
 * @variants ["primary", "secondary"] - If component has variants
 * @sizes ["sm", "md", "lg"] - If component has sizes  
 * @a11y Important accessibility notes
 * @performance Important performance considerations
 */
```

## What to SKIP
- ❌ `@since` - Use git history
- ❌ `@author` - Use git blame
- ❌ Long descriptions after metadata - Keep in README
- ❌ `@states` - Usually obvious from props

## Examples

### Minimal (Primitive)
```typescript
/**
 * @layer primitive
 * @dependencies None
 * @cssFile /src/styles/components/text.css
 * @className .text
 * @status stable
 */
export function Text({ children, ...props }) {
  // Simple component needs minimal metadata
}
```

### Standard (Composed)
```typescript
/**
 * @layer composed  
 * @dependencies [Box, Text, Button]
 * @cssFile /src/styles/components/card.css
 * @className .card
 * @status stable
 * @description Flexible container for grouped content
 * @variants ["default", "elevated", "bordered"]
 */
export function Card({ variant = 'default', ...props }) {
  // More complex component benefits from variants
}
```

### Complex (Feature)
```typescript
/**
 * @layer feature
 * @dependencies [Card, Button, VirtualList, useContentQueue]
 * @cssFile /src/styles/features/content-inbox.css
 * @className .content-inbox
 * @status stable
 * @description Manages content queue with filtering and actions
 * @performance Uses virtual scrolling for large lists
 * @a11y Announces queue changes to screen readers
 */
export function ContentInbox() {
  // Feature components justify more metadata
}
```

## Token Usage Optimization

To reduce tokens while maintaining value:

1. **Use arrays for lists**: `@variants ["a", "b", "c"]` not prose
2. **One-line descriptions**: Not paragraphs
3. **Skip obvious info**: Don't document what TypeScript already shows
4. **Reference don't repeat**: Link to docs instead of inline

## Validation

The `validate-component-styles.cjs` script requires:
- ✅ `@layer`
- ✅ `@dependencies`  
- ✅ `@cssFile`

Everything else is optional but helpful for LLMs and developers.