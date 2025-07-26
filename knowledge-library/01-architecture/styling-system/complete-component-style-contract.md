# Complete Component-Style Contract - Comprehensive Styling System

## 📍 Source Information
- **Primary Source**: `/docs/COMPONENT-STYLE-CONTRACT.md` (lines 1-215)
- **Implementation Script**: `/scripts/validate-component-styles.cjs` (lines 1-282)
- **Original Intent**: Enforce relationship between components and styles, prevent orphans, ensure proper dependency flow
- **Key Innovation**: Strict component-CSS pairing with Box primitive as utility bridge

## 🎯 Core Purpose (Lines 1-3)

**Foundational Vision**: Enforce the relationship between components and styles through:
1. **Orphan Prevention** - Every component has its style companion or explicit utility-only declaration
2. **Dependency Flow Control** - Strict layer-based styling dependencies
3. **Utility-Custom CSS Bridge** - Clear separation through Box primitive pattern

## 📋 Core Principles - Mandatory Relationships (Lines 5-23)

### 1. Component-Style Companion Rule (Lines 7-15)

**Mandatory Pairing System**:
```
Component File          →  Style File                   → Strategy
----------------------------------------                  
Button.tsx             →  button.css                   → Custom CSS required
Card.tsx               →  card.css                     → Custom CSS required
Modal.tsx              →  modal.css                    → Custom CSS required
Box.tsx                →  (uses utilities only)        → No CSS file needed
```

**Critical Implementation Details**:
- **Every component** MUST declare its styling strategy in metadata
- **CSS file path** must be absolute and verifiable at build time
- **Utilities-only components** explicitly marked with `@cssFile none`
- **Mixed approach forbidden** - component cannot use both CSS file AND utility classes in className

### 2. Strict Dependency Flow (Lines 17-22)

**Layer-Based Styling Dependencies**:
```
Architectural Layer    →  Allowed Styling Sources     → Forbidden Dependencies
--------------------------------------------------------------------------------
Primitives            →  utilities only              → No other component styles
Composed              →  primitives + utilities      → No feature/page styles  
Features              →  primitives + composed       → No other feature styles
Pages                 →  all layers                  → No other page styles
```

**Dependency Flow Enforcement**:
- **Primitives**: Only design tokens and utilities (no component dependencies)
- **Composed**: Can reference primitive styles + utilities via Box
- **Features**: Can reference primitive + composed styles + business logic styling
- **Pages**: Can reference all layer styles for layout orchestration

## 📊 Component Metadata Requirements - Complete Specification (Lines 24-169)

### Primitive Component Metadata Template (Lines 26-39)

**Complete Primitive Specification**:
```typescript
/**
 * @layer primitive
 * @cssFile /styles/components/button.css | none (utilities only)
 * @utilities spacing, typography (if using Box)
 * @variants ["primary", "secondary", "danger", "ghost", "outline"]
 * @sizes ["xs", "sm", "md", "lg", "xl"]
 * @states ["loading", "disabled", "active", "hover", "focus"]
 * @status stable | experimental | deprecated
 * @since 2025-07-19
 * @a11y Requires aria-label for icon-only buttons, focus indicators required
 * @performance Debounce for heavy operations, avoid layout thrashing
 * @breaking (if applicable) v2.0 removed 'large' size, use 'lg'
 */
```

**Primitive Metadata Field Explanations**:
- **`@layer primitive`**: Architectural classification, determines allowed dependencies
- **`@cssFile`**: Absolute path to CSS file or explicit "none" for utilities-only
- **`@utilities`**: Which utility categories used (via Box primitive only)
- **`@variants`**: Available style variations (constrained by design system)
- **`@sizes`**: Available size options (following consistent scaling)
- **`@states`**: Interactive and accessibility states supported
- **`@status`**: Development lifecycle (affects validation requirements)
- **`@since`**: Version/date tracking for deprecation planning
- **`@a11y`**: Accessibility requirements and implementation notes
- **`@performance`**: Performance considerations and optimization notes

### Composed Component Metadata Template (Lines 41-53)

**Complete Composed Specification**:
```typescript
/**
 * @layer composed
 * @cssFile /styles/components/card.css
 * @dependencies Button, Text, Box (primitives used directly)
 * @utilities via Box primitive (never className)
 * @variants ["elevated", "glass", "bordered", "compact", "wide"]
 * @composition pattern - Card + CardHeader + CardBody
 * @status stable
 * @since 2025-07-19
 * @a11y Focus management for interactive cards, proper heading structure
 * @performance Consider virtualization for lists >100 items
 * @usedBy [ProductCard, ContentCard, SettingsCard] (features that extend this)
 */
```

**Composed-Specific Field Explanations**:
- **`@dependencies`**: Explicit list of primitive components used
- **`@utilities via Box primitive`**: Utilities only through Box, never mixed in className
- **`@composition pattern`**: How sub-components work together
- **`@usedBy`**: Features/pages that consume this composed component

### Enhanced Metadata Fields - Complete Quality System (Lines 141-169)

#### Status Tracking System (Lines 141-148)
```typescript
@status stable        // Ready for production use - full validation required
@status experimental  // API may change - relaxed validation  
@status deprecated    // Will be removed - requires migration path

// Deprecated components MUST include:
@deprecatedAfter 2025-12-01       // Removal date
@alternative use Card instead     // Migration guidance
@breaking v3.0 removed elevation prop, use variant="elevated"
```

#### Quality Attribute Documentation (Lines 150-154)
```typescript
@a11y aria-label required for icon-only, keyboard navigation supported
@performance Virtualize for >100 rows, debounce sort/filter at 300ms
@breaking v2.0 removed 'condensed' variant, use 'compact'
@security Sanitizes user input, escapes HTML in content prop
@responsive Mobile-first, collapses to single column <768px
```

## 🎨 Style File Requirements - Comprehensive CSS Standards (Lines 55-64)

### Mandatory CSS File Header Template

**Complete CSS Documentation Header**:
```css
/* ==========================================================================
   Card Component (@layer composed)
   Dependencies: Box primitive for utilities, Button primitive for actions
   Used by: ProductCard, ContentCard, SettingsCard features
   Responsive: Mobile-first, collapses at 768px
   A11y: Focus indicators, proper contrast ratios
   Performance: GPU-accelerated animations, optimized repaints
   Last updated: 2025-07-19
   ========================================================================== */

/* Base component styles */
.card {
  /* Component-specific styles only */
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
}

/* Variants */
.card--elevated {
  box-shadow: var(--shadow-lg);
}

.card--glass {
  backdrop-filter: blur(10px);
  background: var(--color-glass);
}

/* States */
.card.is-loading {
  opacity: 0.6;
  pointer-events: none;
}

/* Sub-components */
.card__header {
  padding: var(--space-md);
  border-bottom: 1px solid var(--color-border);
}

.card__body {
  padding: var(--space-md);
}
```

**CSS Header Requirements**:
- **Component identification**: Name and architectural layer
- **Dependency documentation**: What primitives/tokens are used
- **Usage tracking**: Which features/pages consume this CSS
- **Responsive strategy**: Breakpoint behavior documentation
- **Accessibility notes**: Focus, contrast, keyboard navigation
- **Performance notes**: Animation optimization, repaint considerations

## 🔧 Utility Strategy - Box Primitive Bridge System (Lines 66-96)

### Utility vs Custom CSS Decision Matrix (Lines 68-76)

| Use Case | Approach | Implementation | Rationale |
|----------|----------|----------------|-----------|
| **Spacing** | Utilities via Box | `<Box padding="md" margin="sm">` | Consistent spacing scale |
| **Basic Layout** | Utilities via Box | `<Box display="flex" gap="md">` | Common layout patterns |
| **Typography** | Utilities via Box | `<Box fontSize="lg" fontWeight="bold">` | Type scale consistency |
| **Unique Component Style** | Custom CSS | `.card--glass { backdrop-filter... }` | Component-specific design |
| **Complex Animations** | Custom CSS | `@keyframes slideIn { ... }` | Performance optimization |
| **State Management** | Custom CSS | `.btn.is-loading::after { ... }` | Pseudo-element states |
| **Media Queries** | Custom CSS | `@media (max-width: 768px) { ... }` | Responsive breakpoints |

### Box Primitive as Utility Bridge (Lines 78-91)

**Correct Pattern - Clean Separation**:
```typescript
// ✅ EXCELLENT: Utilities via props, custom styling via className
<Box 
  className="card card--glass"  // Custom component styling
  padding="md"                  // Utility: consistent spacing
  display="flex"                // Utility: common layout  
  gap="sm"                      // Utility: spacing between children
  rounded="md"                  // Utility: consistent border radius
>
  {children}
</Box>
```

**Incorrect Patterns - Mixing Concerns**:
```typescript
// ❌ BAD: Mixing utility classes in className
<div className="card p-md d-flex gap-sm">  // Utility classes in className

// ❌ BAD: Custom CSS in style prop  
<Box style={{padding: '16px', backgroundColor: '#f5f5f5'}}>  // Hardcoded values

// ❌ BAD: No Box primitive for utilities
<div className="card" style={{padding: 'var(--space-md)'}}>  // Direct style usage
```

**Critical Box Primitive Rules**:
1. **All utilities** must go through Box props (never className utility classes)
2. **Custom styling** must use className with semantic CSS classes
3. **No hardcoded values** - all values must come from design tokens
4. **No mixed approaches** - component cannot use both Box utilities AND utility classes

## 🛡️ Orphan Prevention System - Complete Validation (Lines 94-137)

### Build-Time Validation Implementation (Lines 95-112)

**Complete Validation Script Logic** (from `/scripts/validate-component-styles.cjs`):
```javascript
// Comprehensive component-style validation
function validateComponentStyleContract() {
  const components = glob.sync('src/components/**/*.tsx');
  const styles = glob.sync('src/styles/**/*.css');
  const errors = [];
  
  components.forEach(componentPath => {
    const metadata = extractMetadata(componentPath);
    const componentName = path.basename(componentPath, '.tsx');
    
    // Validate CSS file declaration
    if (!metadata.cssFile) {
      errors.push(`${componentName}: Missing @cssFile metadata`);
    } else if (metadata.cssFile !== 'none') {
      // Verify CSS file exists
      const cssPath = metadata.cssFile.replace(/^\//, '');
      if (!fs.existsSync(cssPath)) {
        errors.push(`${componentName}: CSS file not found: ${metadata.cssFile}`);
      }
      
      // Validate CSS file header
      validateCSSHeader(cssPath, metadata);
    }
    
    // Validate layer-specific requirements
    validateLayerRequirements(componentPath, metadata);
    
    // Validate dependency flow
    validateDependencyFlow(componentPath, metadata);
  });
  
  // Find orphan CSS files
  const orphanStyles = findOrphanStyles(components, styles);
  orphanStyles.forEach(orphan => {
    errors.push(`Orphan CSS file: ${orphan} (no corresponding component)`);
  });
  
  return errors;
}
```

### Component Registry System (Lines 114-137)

**Auto-Generated Component Registry** (from validation script lines 187-214):
```json
{
  "primitives": {
    "Button": {
      "file": "Button.tsx",
      "css": "button.css", 
      "utilities": ["spacing", "typography"],
      "variants": ["primary", "secondary", "danger"],
      "dependencies": [],
      "usedBy": ["Card", "Modal", "Form", "Toolbar"],
      "status": "stable",
      "lastValidated": "2025-07-19T10:30:00Z"
    }
  },
  "composed": {
    "Card": {
      "file": "Card.tsx",
      "css": "card.css",
      "dependencies": ["Box", "Text", "Button"],
      "utilities": ["spacing", "shadow", "rounded"],
      "variants": ["elevated", "glass", "bordered"],
      "usedBy": ["ProductCard", "ContentList", "Dashboard"],
      "status": "stable",
      "lastValidated": "2025-07-19T10:30:00Z"
    }
  },
  "features": {
    "ContentInbox": {
      "file": "ContentInbox.tsx", 
      "css": "content-inbox.css",
      "dependencies": ["Card", "Button", "SearchBox"],
      "businessLogic": true,
      "apiDependencies": ["ContentAPI", "UserAPI"],
      "status": "experimental"
    }
  }
}
```

**Registry Benefits**:
- **Dependency Tracking**: Understand component relationships
- **Impact Analysis**: Know what breaks when components change
- **Usage Analytics**: Which components are most/least used
- **Migration Planning**: Plan deprecations and API changes
- **Architecture Visualization**: Generate dependency graphs

## 🔍 Advanced Validation System (Lines 94-282 from validation script)

### Metadata Extraction and Validation

**Complete Metadata Parser** (from script lines 54-92):
```javascript
function extractMetadata(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const metadata = {};
  
  // Required fields
  metadata.layer = extractField(content, '@layer'); 
  metadata.cssFile = extractField(content, '@cssFile');
  metadata.dependencies = extractField(content, '@dependencies');
  metadata.status = extractField(content, '@status');
  
  // Quality fields
  metadata.since = extractField(content, '@since');
  metadata.a11y = extractField(content, '@a11y');
  metadata.performance = extractField(content, '@performance');
  metadata.breaking = extractField(content, '@breaking');
  
  // Design fields
  metadata.variants = extractArrayField(content, '@variants');
  metadata.sizes = extractArrayField(content, '@sizes');
  metadata.utilities = extractField(content, '@utilities');
  
  return metadata;
}
```

### Layer-Specific Validation Rules (from script lines 117-136)

**Primitive Layer Validation**:
```javascript
function validatePrimitiveComponent(metadata, errors) {
  // Primitives cannot have component dependencies
  if (metadata.dependencies && 
      metadata.dependencies !== 'None' && 
      metadata.dependencies !== 'none') {
    errors.push('Primitives should not have component dependencies');
  }
  
  // Primitives must declare CSS strategy
  if (!metadata.cssFile) {
    errors.push('Primitives must declare @cssFile (path or "none")');
  }
  
  // Stable primitives need full documentation
  if (metadata.status === 'stable') {
    if (!metadata.a11y) errors.push('Stable primitives need @a11y documentation');
    if (!metadata.since) errors.push('Stable primitives need @since date');
  }
}
```

**Composed Layer Validation**:
```javascript
function validateComposedComponent(metadata, errors) {
  // Must have primitive dependencies
  if (!metadata.dependencies) {
    errors.push('Composed components must declare @dependencies');
  }
  
  // Must use utilities via Box only
  if (metadata.utilities && !metadata.utilities.includes('via Box')) {
    errors.push('Composed components must use utilities "via Box primitive"');
  }
  
  // Must have custom CSS file (cannot be utilities-only)
  if (metadata.cssFile === 'none') {
    errors.push('Composed components must have custom CSS file');
  }
}
```

### Orphan Style Detection (from script lines 146-185)

**Complete Orphan Detection Algorithm**:
```javascript
function findOrphanStyles() {
  const orphans = [];
  const allStyles = glob.sync('src/styles/**/*.css');
  const referencedStyles = new Set();
  
  // Collect all CSS files referenced by components
  const allComponents = [
    ...glob.sync('src/components/**/*.tsx'),
    ...glob.sync('src/features/**/*.tsx'),
    ...glob.sync('src/pages/**/*.tsx')
  ];
  
  allComponents.forEach(componentPath => {
    const metadata = extractMetadata(componentPath);
    if (metadata.cssFile && metadata.cssFile !== 'none') {
      const normalizedPath = metadata.cssFile.replace(/^\/styles\//, '');
      referencedStyles.add(normalizedPath);
    }
  });
  
  // Check each style file for orphan status
  allStyles.forEach(stylePath => {
    const relativePath = path.relative('src/styles', stylePath);
    
    // Skip infrastructure styles
    const infraPatterns = ['base/', 'utils/', 'tokens/', 'globals.css'];
    if (infraPatterns.some(pattern => relativePath.startsWith(pattern))) {
      return;
    }
    
    // Flag orphan styles
    if (!referencedStyles.has(relativePath)) {
      orphans.push({
        path: stylePath,
        relativePath: relativePath,
        size: fs.statSync(stylePath).size,
        lastModified: fs.statSync(stylePath).mtime
      });
    }
  });
  
  return orphans;
}
```

## 🤖 LLM Integration Guidelines (Lines 171-196)

### Component Creation Decision Tree for AI

**Complete LLM Decision Process**:
```typescript
interface ComponentCreationProcess {
  step1_determineLayer(): ComponentLayer {
    // Questions to determine architectural layer
    if (mapsToSingleHTMLElement) return 'primitive';
    if (combinesMultiplePrimitives && !hasBusinessLogic) return 'composed';
    if (hasBusinessLogic || apiCalls) return 'feature';
    if (representsRoute) return 'page';
  }
  
  step2_validateDependencies(layer: ComponentLayer): boolean {
    // Check allowed dependencies for layer
    const allowedDeps = {
      primitive: [],
      composed: ['primitives'],
      feature: ['primitives', 'composed'],
      page: ['primitives', 'composed', 'features']
    };
    return checkDependencies(allowedDeps[layer]);
  }
  
  step3_determineStyleStrategy(): StyleStrategy {
    // Decide CSS approach
    if (requiresCustomStyling) {
      return {
        cssFile: `/styles/${layer}s/${kebabCase(componentName)}.css`,
        utilities: 'via Box primitive'
      };
    } else {
      return {
        cssFile: 'none',
        utilities: 'spacing, layout, typography'
      };
    }
  }
  
  step4_generateMetadata(): ComponentMetadata {
    return {
      layer: determined_layer,
      cssFile: determined_css_strategy,
      dependencies: validated_dependencies,
      status: 'experimental', // Start experimental
      since: new Date().toISOString().split('T')[0],
      variants: [], // Start empty, add as needed
      utilities: determined_utilities
    };
  }
}
```

### Utility Usage Rules for LLMs (Lines 185-196)

**LLM Utility Decision Matrix**:
```typescript
// DECISION: When to use Box utilities vs custom CSS

// ✅ USE BOX UTILITIES FOR:
// - Spacing (padding, margin, gap)
// - Layout (display, flexDirection, alignItems) 
// - Typography (fontSize, fontWeight, lineHeight)
// - Basic styling (backgroundColor, borderRadius, shadow)
<Box padding="md" display="flex" gap="sm" shadow="lg">

// ✅ USE CUSTOM CSS FOR:
// - Component-specific designs (.card--glass)
// - Complex animations (@keyframes)
// - Pseudo-elements (::before, ::after)
// - Media queries (@media)
// - Component states (.btn.is-loading)
<Box className="card card--elevated">

// ❌ NEVER DO:
// - Mix utility classes in className
<div className="card p-md d-flex">  // Wrong!

// - Hardcode values in style prop
<Box style={{padding: '16px'}}>  // Wrong!

// - Skip Box for utilities
<div style={{padding: 'var(--space-md)'}}>  // Wrong!
```

## 📋 Enforcement Checklist - Complete Quality Gates (Lines 198-206)

### Pre-commit Hook Integration
```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Validating component-style contract..."

# Run style validation
node scripts/validate-component-styles.cjs

if [ $? -ne 0 ]; then
  echo "❌ Component-style validation failed!"
  echo "Fix the errors above before committing."
  exit 1
fi

echo "✅ Component-style validation passed!"
```

### CI/CD Pipeline Integration
```yaml
# .github/workflows/validate-architecture.yml
name: Architecture Validation
on: [push, pull_request]

jobs:
  validate-components:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      - name: Install dependencies
        run: npm ci
      - name: Validate component-style contract
        run: npm run validate:styles
      - name: Upload component registry
        uses: actions/upload-artifact@v2
        with:
          name: component-registry
          path: component-registry.json
```

### Complete Quality Gate Checklist
- [ ] **Pre-commit hook** runs style validation and blocks invalid commits
- [ ] **Component metadata** includes all required fields based on status
- [ ] **CSS files** have complete documentation headers with dependencies
- [ ] **Registry** auto-updates on component changes and tracks usage
- [ ] **Build fails** if orphan styles or missing CSS files detected
- [ ] **LLM prompts** include this contract for consistent AI behavior
- [ ] **Code review** includes architectural validation checklist
- [ ] **Documentation** stays synchronized with component changes

## 🎯 System Benefits - Quantified Impact (Lines 207-215)

### Architectural Benefits

1. **Zero Orphan Styles** 
   - **Impact**: No unused CSS bloating bundle
   - **Measurement**: Automated detection in build pipeline
   - **Benefit**: Reduced bundle size and maintenance overhead

2. **Clear Dependency Tracking**
   - **Impact**: Understanding component relationships for safe refactoring
   - **Measurement**: Auto-generated dependency graphs and usage analytics
   - **Benefit**: Confident architecture evolution and deprecation planning

3. **LLM Clarity Through Constraints**
   - **Impact**: AI understands styling strategy without reading implementation
   - **Measurement**: Consistent AI-generated components following patterns
   - **Benefit**: Reliable automated development with architectural compliance

4. **Type Safety for Styling**
   - **Impact**: Box props constrain utility choices preventing invalid combinations
   - **Measurement**: TypeScript validation of utility prop usage
   - **Benefit**: Reduced styling bugs and consistent design system usage

5. **Maintainable Architecture** 
   - **Impact**: Easy to see component usage and styling dependencies
   - **Measurement**: Registry tracking and validation metrics
   - **Benefit**: Faster debugging and confident refactoring

## 🔗 Cross-References & Integration

### This System Connects To:
- **Component Architecture**: `/01-architecture/component-layers/` - Layer-based styling rules
- **Grammar Rules**: `/02-grammar/naming-system/` - CSS class naming patterns  
- **LLM Directives**: `/01-architecture/metadata-system/` - Metadata requirements
- **Build Scripts**: `/scripts/validate-component-styles.cjs` - Validation automation
- **Design Tokens**: Foundation for all utility values

### This System Enables:
- **Orphan-Free Codebase**: Guaranteed component-style pairing
- **Predictable AI Behavior**: Clear styling strategy for LLM generation
- **Architectural Enforcement**: Layer-based styling dependency validation
- **Confident Refactoring**: Complete dependency tracking and impact analysis

### Dependencies:
- **Box Primitive**: Must exist as utility bridge component
- **Design Token System**: All utilities must reference design tokens
- **Metadata Standard**: Components must have complete metadata blocks
- **Build Pipeline**: Validation must run automatically on code changes

This contract ensures your design system remains consistent and prevents the common pitfalls of mixed utility/custom CSS approaches while providing clear guidance for both human developers and AI assistants.