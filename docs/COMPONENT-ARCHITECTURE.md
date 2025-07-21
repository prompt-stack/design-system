# Component Architecture & Design System Guide

> 🎯 **Purpose**: Complete guide for component-driven development with LLM-friendly rules and playground validation methodology

## Table of Contents
1. [Current State Analysis](#current-state-analysis)
2. [Target Architecture](#target-architecture)
3. [Component Classification](#component-classification)
4. [Migration Roadmap](#migration-roadmap)
5. [LLM Rules & Guidelines](#llm-rules--guidelines)
6. [Playground Validation Process](#playground-validation-process)
7. [Component-CSS Mapping](#component-css-mapping)

---

## Current State Analysis

### Current Structure
```
/components (flat, mixed concerns)
  ├── Button.tsx         → Primitive
  ├── Card.tsx          → Primitive/Composed
  ├── Modal.tsx         → Composed
  ├── Dropdown.tsx      → Composed
  ├── ContentInbox.tsx  → Feature
  ├── QueueManager.tsx  → Feature
  ├── Header.tsx        → Layout
  └── Layout.tsx        → Layout
```

### Issues Identified
1. **No layer separation** - primitives mixed with features
2. **Unclear dependencies** - any component can import any other
3. **Inconsistent naming** - some components describe UI (Button), others describe domain (ContentInbox)

---

## Target Architecture

### Folder Structure
```
/components
  /primitives        # Zero dependencies, maps to HTML elements
    Button.tsx
    Input.tsx
    Text.tsx
    Image.tsx
    Link.tsx
  
  /composed          # Built from primitives only
    Card/
      Card.tsx
      CardHeader.tsx
      CardBody.tsx
    Modal/
      Modal.tsx
      ModalHeader.tsx
    Dropdown/
      Dropdown.tsx
      DropdownItem.tsx
    FormField/
      FormField.tsx
  
  /features          # Business logic, can use composed + primitives
    ContentInbox/
      ContentInbox.tsx
      ContentInboxItem.tsx
      useContentInbox.ts
    QueueManager/
      QueueManager.tsx
      useQueue.ts
    URLInput/
      URLInput.tsx
      useURLValidation.ts
  
  /layout            # Page structure components
    Header/
    Navigation/
    Layout/
  
  /pages             # Route components
    InboxPage.tsx
    PlaygroundPage.tsx
    HealthPage.tsx
```

---

## Component Classification

### Current Components → Target Layer

| Component | Current Location | Target Layer | Reasoning |
|-----------|-----------------|--------------|-----------|
| Button | /components | /primitives | Maps to `<button>`, zero deps |
| Card | /components | /composed | Combines multiple primitives |
| Modal | /components | /composed | Complex UI pattern |
| Dropdown | /components | /composed | Interactive pattern |
| ContentInbox | /components | /features | Business logic, API calls |
| QueueManager | /components | /features | Domain-specific logic |
| InboxItem | /components | /features/ContentInbox | Sub-component of feature |
| Header | /components | /layout | Page structure |
| Layout | /components | /layout | App shell |
| URLInput | /components | /features | Domain logic (validation) |
| Dropzone | /components | /composed | Reusable UI pattern |
| PasteModal | /components | /features | Specific business logic |

### New Primitives Needed
- `Text` - Typography wrapper
- `Input` - Form input wrapper
- `Link` - Anchor wrapper
- `Box` - Layout primitive
- `Icon` - Icon wrapper

---

## Migration Roadmap

### Phase 1: Create Structure (No Breaking Changes)
```bash
# Create new folders
mkdir -p src/components/{primitives,composed,features,layout}

# Add index files with re-exports
echo "export { Button } from '../Button'" > src/components/primitives/index.ts
```

### Phase 2: Move Components (Gradual)
1. **Week 1**: Move primitives (Button → /primitives)
2. **Week 2**: Move composed (Card, Modal → /composed)
3. **Week 3**: Move features (ContentInbox → /features)
4. **Week 4**: Update imports, remove old locations

### Phase 3: Enforce Boundaries
```json
// .eslintrc.json
{
  "rules": {
    "no-restricted-imports": ["error", {
      "patterns": [
        {
          "group": ["*/features/*", "*/pages/*"],
          "message": "Primitives cannot import from features or pages"
        }
      ]
    }]
  }
}
```

---

## LLM Rules & Guidelines

### 1. Component Creation Rules

```typescript
// RULE: When creating a new component, determine its layer first

// PRIMITIVE - Zero dependencies, single HTML element
✅ Button, Input, Text, Link
❌ Card (multiple elements), Modal (complex behavior)

// COMPOSED - Built from primitives only
✅ Card (uses Box, Text), FormField (uses Label, Input)
❌ URLInput (has validation logic), ContentInbox (API calls)

// FEATURE - Business logic, domain-specific
✅ ContentInbox, SearchBar, UserProfile
❌ Button (too generic), Card (no business logic)
```

### 2. Import Rules by Layer

```typescript
// PRIMITIVES
import { colors, spacing } from '@/design-tokens';  // ✅
import { Card } from '@/components/composed';       // ❌

// COMPOSED
import { Button, Text } from '@/components/primitives'; // ✅
import { useUser } from '@/hooks';                     // ✅
import { ContentInbox } from '@/components/features'; // ❌

// FEATURES
import { Card } from '@/components/composed';         // ✅
import { Button } from '@/components/primitives';     // ✅
import { api } from '@/services';                     // ✅
import { HomePage } from '@/pages';                   // ❌
```

### 3. Naming Convention Rules

```typescript
// Component Names (PascalCase)
Button.tsx → .btn
ContentInbox.tsx → .content-inbox
QueueManager.tsx → .queue-manager

// CSS Classes (BEM)
.btn                    // Block
.btn--primary          // Modifier
.btn__icon             // Element
.btn.is-loading        // State

// File Structure
/features/ContentInbox/
  ContentInbox.tsx           // Main component
  ContentInboxItem.tsx       // Sub-component
  useContentInbox.ts         // Hook
  content-inbox.css          // Styles
  index.ts                   // Exports
```

### 4. Component Complexity Rules

```typescript
// RULE: Start simple, add complexity only when needed

// Phase 1: Minimal API
<Button>Click me</Button>

// Phase 2: Add variants
<Button variant="primary">Click me</Button>

// Phase 3: Add more props only if 3+ consumers need them
<Button variant="primary" size="lg" loading>Click me</Button>

// AVOID: Kitchen sink components
<Button 
  variant="primary"
  size="lg"
  rounded
  gradient
  shadow
  glow
  pulse
  ... // 20 more props
/>
```

---

## Playground Validation Process

### Purpose
The playground serves as a **living style guide** and **validation tool** for design decisions.

### Structure
```
/playground
  /components
    ButtonPlayground.tsx     # Test all button variants
    CardPlayground.tsx       # Test card compositions
    FormPlayground.tsx       # Test form patterns
    CompositionPlayground.tsx # Test component combinations
```

### Validation Methodology

#### 1. Visual Consistency Testing
```tsx
// ButtonPlayground.tsx
export function ButtonPlayground() {
  return (
    <section>
      <h3>Size Validation</h3>
      <div className="demo-row">
        <Button size="sm">Small</Button>
        <Button size="md">Medium</Button>
        <Button size="lg">Large</Button>
        {/* Validate: Equal spacing, proportional scaling */}
      </div>
      
      <h3>State Testing</h3>
      <div className="demo-row">
        <Button>Default</Button>
        <Button disabled>Disabled</Button>
        <Button loading>Loading</Button>
        {/* Validate: Clear state differentiation */}
      </div>
    </section>
  );
}
```

#### 2. Composition Testing
```tsx
// CompositionPlayground.tsx
export function CompositionPlayground() {
  return (
    <section>
      <h3>Card with Actions</h3>
      <Card>
        <CardHeader>
          <h4>Title</h4>
          <Button size="sm">Action</Button>
        </CardHeader>
        <CardBody>
          {/* Validate: Components work together */}
        </CardBody>
      </Card>
    </section>
  );
}
```

#### 3. Responsive Testing
```tsx
// Use playground to test at different breakpoints
<div className="breakpoint-test">
  <div className="mobile-view">320px</div>
  <div className="tablet-view">768px</div>
  <div className="desktop-view">1024px</div>
</div>
```

### Measurement Criteria

| Aspect | What to Measure | How to Validate |
|--------|----------------|-----------------|
| **Spacing** | Consistent use of spacing scale | Visual alignment in playground |
| **Sizing** | Proportional component sizes | Side-by-side comparison |
| **Colors** | Token usage, contrast ratios | Theme toggle testing |
| **States** | Interactive states clear | Hover/focus/active testing |
| **Composition** | Components work together | Real-world examples |
| **Responsive** | Adapts to viewports | Resize testing |

---

## Component-CSS Mapping

### Mapping Rules

```
React Component → CSS File → CSS Classes

/primitives/Button.tsx → /styles/components/button.css → .btn
/composed/Card/ → /styles/components/card.css → .card
/features/ContentInbox/ → /styles/features/content-inbox.css → .content-inbox
```

### CSS Architecture Alignment

```
/components                    /styles
  /primitives        →           /components
  /composed          →           /components  
  /features          →           /features
  /layout            →           /layout
  /pages             →           /pages
```

### Enforcing Consistency

```javascript
// build-time validation
const componentCSSMap = {
  'Button.tsx': 'button.css',
  'Card.tsx': 'card.css',
  'ContentInbox.tsx': 'content-inbox.css'
};

// Validate all components have corresponding CSS
validateComponentStyles(componentCSSMap);
```

---

## Automated Validation

### 1. Dependency Graph Generation
```javascript
// scripts/analyze-deps.js
const madge = require('madge');

madge('src/components/').then((res) => {
  // Generate visual dependency graph
  res.image('deps-graph.svg');
  
  // Validate no upward dependencies
  validateLayerBoundaries(res.obj());
});
```

### 2. Component Metadata
```typescript
// Each component exports metadata
export const Button = () => {...};
Button.meta = {
  layer: 'primitive',
  cssFile: 'button.css',
  dependencies: [],
  status: 'stable'
};
```

### 3. Playground Integration
```typescript
// Auto-generate playground from component metadata
generatePlayground({
  components: scanComponents('./src/components'),
  outputPath: './src/playground/generated'
});
```

---

## LLM Instructions Template

When working with components in this codebase:

1. **Identify the component layer**:
   - Primitive: Single element, zero deps → `/primitives`
   - Composed: Multiple primitives → `/composed`
   - Feature: Business logic → `/features`
   - Page: Route component → `/pages`

2. **Follow naming conventions**:
   - Component: PascalCase (`ContentInbox.tsx`)
   - CSS class: kebab-case (`.content-inbox`)
   - CSS file: matches component (`content-inbox.css`)

3. **Respect import boundaries**:
   - Check the layer's allowed imports
   - Never import upward in the hierarchy
   - Use design tokens for all values

4. **Validate in playground**:
   - Add new components to playground
   - Test all variants and states
   - Verify responsive behavior

5. **Document dependencies**:
   - Export component metadata
   - Update COMPOSED-MAP.json
   - Keep CSS in sync

---

## Success Metrics

- **No circular dependencies** in dependency graph
- **100% token usage** (no hardcoded values)
- **All components in playground** with examples
- **Consistent naming** across components and CSS
- **Clear layer boundaries** with no violations

---

This architecture provides a scalable, maintainable foundation for component-driven development with clear rules for both human developers and LLM assistants.