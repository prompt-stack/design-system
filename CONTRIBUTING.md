# Contributing to the Design System

Thank you for your interest in contributing! This guide will help you understand our patterns and contribute effectively.

## 🎯 Design Philosophy

1. **Dependency Hierarchy**: Primitives → Composed → Features → Pages
2. **Zero Orphans**: Every component has a style companion
3. **Utility Bridge**: Box primitive handles common utilities
4. **LLM Optimization**: Clear, constrained patterns

## 📝 Before You Start

1. **Read the Docs**
   - [Component-Style Contract](./docs/COMPONENT-STYLE-CONTRACT.md)
   - [Component Architecture](./docs/COMPONENT-ARCHITECTURE.md)
   - [Style Guide](./docs/STYLE-GUIDE.md)

2. **Run Validation**
   ```bash
   node design-system/scripts/validate-component-styles.js
   ```

## 🔧 Creating a New Component

### 1. Determine the Layer

- **Primitive**: Maps 1:1 to HTML element, zero dependencies
- **Composed**: Built from primitives, reusable UI pattern
- **Feature**: Business logic, API calls, domain-specific

### 2. Use the Generator

```bash
node design-system/scripts/generate-component.js MyComponent composed
```

### 3. Complete the Metadata

```typescript
/**
 * @layer composed
 * @cssFile /styles/components/my-component.css
 * @dependencies Button, Text, Box
 * @utilities spacing, shadow (via Box)
 * @variants ["default", "compact", "expanded"]
 * @status experimental
 * @since 2025-07-20
 * @a11y Keyboard navigation required
 * @performance Virtualize if >50 items
 */
```

### 4. Follow the Patterns

#### For Primitives:
```typescript
// Direct HTML mapping, no dependencies
export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ variant, ...props }, ref) => {
    return <input ref={ref} className={clsx('input', `input--${variant}`)} {...props} />;
  }
);
```

#### For Composed:
```typescript
// Use Box for utilities, custom CSS for unique styling
export const Card = forwardRef<HTMLDivElement, CardProps>(
  ({ variant, padding = '4', ...boxProps }, ref) => {
    return (
      <Box 
        ref={ref}
        className={clsx('card', `card--${variant}`)}
        padding={padding}  // Utility via Box
        {...boxProps}
      >
        {children}
      </Box>
    );
  }
);
```

### 5. Write the CSS

```css
/* ==========================================================================
   MyComponent (@layer composed)
   Dependencies: Box for utilities
   Used by: [Update when used]
   ========================================================================== */

.my-component {
  /* Base styles - only what's unique to this component */
}

.my-component--compact {
  /* Variant styles */
}
```

### 6. Export the Component

Add to the appropriate index file:
```typescript
// src/components/index.ts
export { MyComponent } from './MyComponent';
```

### 7. Validate

```bash
node design-system/scripts/validate-component-styles.js
```

## 📋 Checklist

- [ ] Component has complete metadata
- [ ] CSS file exists and is referenced correctly
- [ ] Dependencies follow layer rules
- [ ] Utilities use Box, not className mixing
- [ ] Variants are documented
- [ ] Status and dates are included
- [ ] A11y requirements documented
- [ ] Performance notes if applicable
- [ ] Validation passes
- [ ] Added to exports

## 🚫 Common Mistakes

### ❌ Mixing Utilities in className
```typescript
// WRONG
<div className="card p-md shadow-lg">
```

### ✅ Use Box for Utilities
```typescript
// RIGHT
<Box className="card" padding="md" shadow="lg">
```

### ❌ Missing Metadata
```typescript
// WRONG - Incomplete
/**
 * Card component
 */
```

### ✅ Complete Metadata
```typescript
// RIGHT
/**
 * @layer composed
 * @cssFile /styles/components/card.css
 * @dependencies Box
 * etc...
 */
```

### ❌ Wrong Dependencies
```typescript
// WRONG - Primitive importing composed
import { Card } from './Card';
```

### ✅ Follow the Hierarchy
```typescript
// RIGHT - Composed can import primitives
import { Button, Text } from './primitives';
```

## 🔄 Updating Existing Components

1. **Check Current State**
   - Run validation to see current metadata
   - Review CSS file for orphaned styles

2. **Update Carefully**
   - Add @breaking tag for breaking changes
   - Update @since date
   - Document migration path

3. **Communicate Changes**
   - Update component registry
   - Note in PR what changed and why

## 🧪 Testing

1. **Visual Testing**
   - Add to playground
   - Test all variants
   - Check responsive behavior

2. **Dependency Testing**
   - Ensure imports follow rules
   - Validate doesn't break

3. **LLM Testing**
   - Can an LLM understand the metadata?
   - Are variants clearly documented?

## 📢 Getting Help

- **Questions**: Open an issue with [Question] tag
- **Bugs**: Include validation output
- **Ideas**: Share in discussions first

## 🎉 Thank You!

Your contributions help make this design system better for everyone - humans and AI alike!