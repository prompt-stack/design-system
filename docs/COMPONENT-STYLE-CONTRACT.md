# Component-Style Contract & Dependency Rules

> 🎯 **Purpose**: Enforce the relationship between components and styles, prevent orphans, and ensure proper dependency flow

## Core Principles

### 1. Every Component MUST Have a Style Companion
```
Component File          →  Style File
-----------------------------------------
Button.tsx             →  button.css
Card.tsx               →  card.css  
Modal.tsx              →  modal.css
Box.tsx                →  (uses utilities only)
```

### 2. Dependency Flow (STRICT)
```
Primitives → Composed → Features → Pages
    ↓           ↓          ↓         ↓
(utilities)  (primitives) (both)   (all)
```

## Component Metadata Requirements

### Primitive Components
```typescript
/**
 * @layer primitive
 * @cssFile /styles/components/button.css | none (utilities only)
 * @utilities spacing, typography (if using Box)
 * @variants ["primary", "secondary", "danger"]
 * @sizes ["xs", "sm", "md", "lg", "xl"]
 * @states ["loading", "disabled", "active"]
 * @status stable | experimental | deprecated
 * @since 2025-07-19
 * @a11y Requires aria-label for icon-only buttons
 */
```

### Composed Components
```typescript
/**
 * @layer composed
 * @cssFile /styles/components/card.css
 * @dependencies Button, Text (primitives used)
 * @utilities via Box primitive
 * @variants ["elevated", "glass", "bordered"]
 * @status stable
 * @since 2025-07-19
 * @performance Consider virtualization for lists >100 items
 */
```

## Style File Requirements

### Component CSS Header
```css
/* ==========================================================================
   Card Component (@layer composed)
   Dependencies: Box primitive for utilities
   Used by: ProductCard, ContentCard features
   ========================================================================== */
```

## Utility Strategy

### When to Use Utilities vs Custom CSS

| Use Case | Approach | Example |
|----------|----------|---------|
| **Spacing** | Utilities via Box | `<Box padding="md" margin="sm">` |
| **Basic Layout** | Utilities via Box | `<Box display="flex" gap="md">` |
| **Unique Component Style** | Custom CSS | `.card--glass { backdrop-filter... }` |
| **Complex Animations** | Custom CSS | `@keyframes slideIn { ... }` |
| **State Management** | Custom CSS | `.btn.is-loading::after { ... }` |

### Box Primitive as Utility Bridge
```typescript
// ✅ GOOD: Utilities for common, custom CSS for unique
<Box 
  className="card card--glass"  // Custom styling
  padding="md"                  // Utility
  display="flex"                // Utility
>
  {children}
</Box>

// ❌ BAD: Mixing utility classes in className
<div className="card p-md d-flex">  // Don't do this
```

## Orphan Prevention System

### 1. Build-Time Validation Script
```javascript
// scripts/validate-styles.js
const components = glob.sync('src/components/*.tsx');
const styles = glob.sync('src/styles/components/*.css');

components.forEach(component => {
  const name = path.basename(component, '.tsx');
  const metadata = extractMetadata(component);
  
  if (metadata.cssFile !== 'none') {
    const styleExists = styles.includes(metadata.cssFile);
    if (!styleExists) {
      throw new Error(`Orphan component: ${name} missing ${metadata.cssFile}`);
    }
  }
});
```

### 2. Component Registry
```json
// component-registry.json (auto-generated)
{
  "primitives": {
    "Button": {
      "file": "Button.tsx",
      "css": "button.css",
      "utilities": ["spacing"],
      "variants": ["primary", "secondary", "danger"],
      "usedBy": ["Card", "Modal", "Form"]
    }
  },
  "composed": {
    "Card": {
      "file": "Card.tsx", 
      "css": "card.css",
      "dependencies": ["Box", "Text"],
      "utilities": ["spacing", "shadow", "rounded"],
      "usedBy": ["ProductCard", "ContentList"]
    }
  }
}
```

## Enhanced Metadata Fields

### Status Tracking
- **@status** - Component lifecycle state
  - `stable` - Ready for production use
  - `experimental` - API may change
  - `deprecated` - Will be removed, use alternative
- **@since** - Version/date when component was added
- **@deprecatedAfter** - (If deprecated) Date for removal
- **@alternative** - (If deprecated) What to use instead

### Quality Attributes
- **@a11y** - Accessibility requirements and considerations
- **@performance** - Performance notes and thresholds
- **@breaking** - Breaking changes from previous versions

### Example with All Metadata
```typescript
/**
 * @layer composed
 * @cssFile /styles/components/data-table.css
 * @dependencies Box, Text, Button, Checkbox
 * @utilities via Box primitive
 * @variants ["striped", "hoverable", "compact"]
 * @status experimental
 * @since 2025-07-20
 * @a11y Requires aria-label on sortable columns
 * @performance Virtualize for >100 rows, debounce sort/filter
 * @breaking v2.0 removed 'condensed' variant, use 'compact'
 */
```

## LLM-Friendly Documentation

### Component Creation Template
```typescript
/**
 * When creating a new component:
 * 1. Determine layer (primitive/composed/feature)
 * 2. Check dependencies allowed for that layer
 * 3. Create companion CSS file (unless utilities-only)
 * 4. Add metadata header with all required fields
 * 5. Update component registry
 */
```

### Utility Usage Rules for LLMs
```typescript
// For spacing, layout, shadows, borders - use Box with props:
<Box padding="md" shadow="lg" rounded="md">

// For component-specific styling - use CSS classes:
<Box className="card card--elevated">

// NEVER mix utility classes in className:
❌ <div className="p-md shadow-lg card">
✅ <Box className="card" padding="md" shadow="lg">
```

## Enforcement Checklist

- [ ] **Pre-commit hook** runs style validation
- [ ] **Component metadata** includes all required fields
- [ ] **CSS files** have dependency headers
- [ ] **Registry** auto-updates on component changes
- [ ] **Build fails** if orphans detected
- [ ] **LLM prompt** includes this contract

## Benefits

1. **No Orphans** - Every component has its style companion
2. **Clear Dependencies** - Can trace usage up and down
3. **LLM Clarity** - Utilities via props, custom via classes
4. **Type Safety** - Props constrain utility choices
5. **Maintainable** - Easy to see what uses what

This contract ensures your design system remains consistent and prevents the common pitfalls of mixed utility/custom CSS approaches.