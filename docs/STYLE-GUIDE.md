# Content Stack Style Guide & CSS Reference

> 🎯 **Purpose**: Single source of truth for CSS naming conventions, utility classes, and component styles during refactor

> ✅ **Migration Status**: CSS refactor completed! All styles have been successfully migrated from the monolithic `components.css` to a modular architecture.

## Table of Contents
1. [Quick Reference](#quick-reference)
2. [Naming Conventions](#naming-conventions)
3. [Design Tokens](#design-tokens)
4. [Component Classes](#component-classes)
5. [Utility Classes](#utility-classes)
6. [Animation Classes](#animation-classes)
7. [Migration Tracking](#migration-tracking)

---

## Quick Reference

### File Structure
```
src/styles/
├── base/          # Reset, animations, variables
│   └── animations.css
├── components/    # Reusable UI components
│   ├── button.css
│   ├── card.css
│   ├── badge.css
│   ├── modal.css
│   ├── toggle.css
│   └── forms.css
├── features/      # Feature-specific styles
│   ├── content-inbox.css
│   ├── queue-manager.css
│   ├── mobile-menu.css
│   ├── theme-toggle.css
│   └── dropzone.css
├── pages/         # Page-specific styles
│   ├── home.css
│   ├── inbox.css
│   ├── library.css
│   └── search.css
├── layout/        # Layout components
│   ├── header.css
│   ├── navigation.css
│   └── responsive.css
└── utils/         # Utility classes and fixes
    ├── utilities.css
    ├── spacing-fixes.css  # Comprehensive spacing system
    └── input-fixes.css    # Form element alignment fixes
```

### Class Naming Pattern
```css
.component          /* Base component */
.component--modifier /* Modifier (variant) */
.component__element  /* Child element */
.is-state           /* State class */
.has-feature        /* Feature flag */
```

### File Naming Pattern
```
components/button.css     /* Lowercase, hyphenated */
features/content-inbox.css /* Match component name */
pages/home.css           /* Match route name */
```

---

## Naming Conventions

### STRICT NAMING RULES - MUST FOLLOW

#### 1. CSS Class Naming Pattern
```css
/* Base component - lowercase, hyphenated */
.component-name

/* Component variant/modifier - double dash */
.component-name--variant

/* Component child element - double underscore */
.component-name__element

/* State classes - prefixed with 'is-' or 'has-' */
.is-active, .is-loading, .has-error

/* Page-specific classes - use page prefix */
.playground__header, .inbox__item

/* Feature-specific classes - use feature prefix */
.content-inbox__title, .queue-manager__list
```

#### 2. File Organization Rules
```
/styles/
  /base/         → Reset, variables, animations (global)
  /components/   → ONLY reusable components (button, card, modal)
  /features/     → Feature-specific styles (content-inbox, queue-manager)
  /pages/        → Page-specific styles (home, playground, inbox)
  /layout/       → Layout components (header, navigation, sidebar)
  /utils/        → Utility classes and fixes
```

#### 3. Where Styles Belong - NO EXCEPTIONS
- **Reusable component** → `/components/[component].css`
- **Page-specific styling** → `/pages/[page].css` with page prefix
- **Feature module** → `/features/[feature].css` with feature prefix
- **Utility classes** → `/utils/utilities.css` ONLY
- **Layout elements** → `/layout/[element].css`

#### 4. Examples of Correct Usage
```css
/* ✅ CORRECT - Button component */
.btn
.btn--primary
.btn__icon

/* ✅ CORRECT - Playground page */
.playground__header
.playground__demo-section
.playground__pattern-card

/* ❌ WRONG - Generic names in page files */
.demo-section     /* Should be: .playground__demo-section */
.pattern-card     /* Should be: .playground__pattern-card */

/* ❌ WRONG - Utilities defined outside utilities.css */
.mb-4 in playground.css  /* Should only be in utilities.css */
```

### 1. Base Components
| Current Class | New Class | File Location | Notes |
|--------------|-----------|---------------|-------|
| `.button` | `.btn` | `components/button.css` | Shorter, consistent |
| `.card` | `.card` | `components/card.css` | Keep as is |
| `.badge` | `.badge` | `components/badge.css` | Keep as is |
| `.modal` | `.modal` | `components/modal.css` | Keep as is |

### 2. Component Modifiers
| Current | New | Example |
|---------|-----|---------|
| `.button--primary` | `.btn--primary` | Primary action |
| `.button--secondary` | `.btn--secondary` | Secondary action |
| `.button--large` | `.btn--lg` | Size variant |
| `.button--small` | `.btn--sm` | Size variant |
| `.button--loading` | `.btn.is-loading` | State class |
| `.card--elevated` | `.card--elevated` | Keep as is |
| `.card--glass` | `.card--glass` | Keep as is |

### 3. Complex Components
| Current | New | File Location |
|---------|-----|---------------|
| `.inbox-cosmic` | `.content-inbox` | `features/content-inbox.css` |
| `.cosmic-header` | `.content-inbox__header` | `features/content-inbox.css` |
| `.cosmic-title` | `.content-inbox__title` | `features/content-inbox.css` |
| `.queue-manager` | `.queue-manager` | `features/queue-manager.css` |
| `.mobile-menu` | `.mobile-menu` | `features/mobile-menu.css` |

### 4. State Classes
```css
.is-active     /* Active state */
.is-disabled   /* Disabled state */
.is-loading    /* Loading state */
.is-open       /* Open state (modals, menus) */
.is-closed     /* Closed state */
.is-dragging   /* Dragging state */
.has-error     /* Error state */
.has-success   /* Success state */
```

---

## Design Tokens

### Colors (from globals.css)
```css
/* Primary Palette */
--color-cosmos: #0a0e27;        /* Deep space blue */
--color-nebula: #1a1f3a;        /* Lighter space blue */
--color-starlight: #ffffff;     /* Pure white */
--color-plasma: #00d4ff;        /* Electric cyan - PRIMARY ACCENT */
--color-orbit: #7c8db5;         /* Muted blue-gray */
--color-lunar: #e8ecf3;         /* Light gray */
--color-void: #000000;          /* Pure black */

/* Semantic Colors */
--color-success: #00ff88;       /* Neon green */
--color-warning: #ffaa00;       /* Amber */
--color-error: #ff3366;         /* Hot pink */

/* Surfaces */
--surface-primary: #ffffff;
--surface-secondary: #f8fafc;
--surface-elevated: rgba(255, 255, 255, 0.95);
--surface-glass: rgba(255, 255, 255, 0.1);
--surface-overlay: rgba(10, 14, 39, 0.75);
```

### Spacing
```css
--space-xs: 0.25rem;   /* 4px */
--space-sm: 0.5rem;    /* 8px */
--space-md: 1rem;      /* 16px */
--space-lg: 1.5rem;    /* 24px */
--space-xl: 2rem;      /* 32px */
--space-2xl: 3rem;     /* 48px */
--space-3xl: 4rem;     /* 64px */
```

### Border Radius
```css
--radius-sm: 0.5rem;    /* 8px - Small elements */
--radius-md: 0.75rem;   /* 12px - Cards, inputs */
--radius-lg: 1rem;      /* 16px - Modals, large cards */
--radius-xl: 1.5rem;    /* 24px - Hero sections */
--radius-2xl: 2rem;     /* 32px - Special elements */
--radius-full: 9999px;  /* Pills, round buttons */
```

### Shadows
```css
--shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.04);
--shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
--shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12);
--shadow-xl: 0 16px 48px rgba(0, 0, 0, 0.16);
--shadow-glow: 0 0 24px rgba(0, 212, 255, 0.3);
```

---

## Component Classes

### Button Component
```css
/* Base */
.btn

/* Variants */
.btn--primary         /* Plasma gradient */
.btn--secondary       /* Glass style */
.btn--ghost          /* No background */
.btn--danger         /* Error action */

/* Sizes */
.btn--sm             /* Small */
.btn--md             /* Medium (default) */
.btn--lg             /* Large */

/* States */
.btn.is-loading      /* Shows spinner */
.btn.is-disabled     /* Disabled state */

/* Elements */
.btn__icon           /* Icon in button */
.btn__text           /* Text in button */
```

### Card Component
```css
/* Base */
.card

/* Variants */
.card--elevated      /* Elevated shadow */
.card--glass         /* Glassmorphism */
.card--interactive   /* Hover effects */
.card--bordered      /* With border */

/* Elements */
.card__header        /* Card header */
.card__body          /* Card content */
.card__footer        /* Card footer */
.card__title         /* Card title */
```

### Badge Component
```css
/* Base */
.badge

/* Variants */
.badge--blue         /* Info/primary */
.badge--green        /* Success */
.badge--yellow       /* Warning */
.badge--red          /* Error */
.badge--glass        /* Glass effect */

/* Sizes */
.badge--sm           /* Small */
.badge--lg           /* Large */
```

### Modal Component
```css
/* Structure */
.modal-overlay       /* Background overlay */
.modal              /* Modal container */
.modal__header      /* Modal header */
.modal__body        /* Modal content */
.modal__footer      /* Modal footer */
.modal__close       /* Close button */

/* States */
.modal.is-open      /* Open state */
.modal.is-closing   /* Closing animation */
```

### Form Elements
```css
/* Inputs */
.input              /* Base input */
.input--error       /* Error state */
.input--success     /* Success state */
.input--disabled    /* Disabled */

/* Groups */
.input-group        /* Input wrapper */
.input-group__icon  /* Icon in input */
.input-group__addon /* Addon element */

/* Toggles */
.toggle             /* Toggle container */
.toggle__input      /* Hidden checkbox */
.toggle__slider     /* Visual toggle */
.toggle__label      /* Label text */
```

---

## Utility Classes

### Display
```css
.d-none            /* display: none */
.d-block           /* display: block */
.d-flex            /* display: flex */
.d-grid            /* display: grid */
.d-inline          /* display: inline */
.d-inline-flex     /* display: inline-flex */
```

### Flexbox
```css
.flex-row          /* flex-direction: row */
.flex-column       /* flex-direction: column */
.justify-start     /* justify-content: flex-start */
.justify-center    /* justify-content: center */
.justify-end       /* justify-content: flex-end */
.justify-between   /* justify-content: space-between */
.align-start       /* align-items: flex-start */
.align-center      /* align-items: center */
.align-end         /* align-items: flex-end */
.gap-sm            /* gap: var(--space-sm) */
.gap-md            /* gap: var(--space-md) */
.gap-lg            /* gap: var(--space-lg) */
```

### Spacing
```css
/* Margin */
.m-0  .m-1  .m-2  .m-3  .m-4  .m-5
.mt-* .mr-* .mb-* .ml-*           /* Directional */
.mx-* .my-*                        /* Axis */

/* Padding */
.p-0  .p-1  .p-2  .p-3  .p-4  .p-5
.pt-* .pr-* .pb-* .pl-*           /* Directional */
.px-* .py-*                        /* Axis */

/* Scale: 0=0, 1=xs, 2=sm, 3=md, 4=lg, 5=xl */
```

### Text
```css
.text-left         /* text-align: left */
.text-center       /* text-align: center */
.text-right        /* text-align: right */
.text-xs           /* font-size: 0.75rem */
.text-sm           /* font-size: 0.875rem */
.text-md           /* font-size: 1rem */
.text-lg           /* font-size: 1.125rem */
.text-xl           /* font-size: 1.25rem */
.text-2xl          /* font-size: 1.5rem */
.text-primary      /* color: var(--text-primary) */
.text-secondary    /* color: var(--text-secondary) */
.text-success      /* color: var(--color-success) */
.text-error        /* color: var(--color-error) */
.text-warning      /* color: var(--color-warning) */
.font-bold         /* font-weight: 700 */
.font-medium       /* font-weight: 500 */
```

### Background
```css
.bg-primary        /* background: var(--surface-primary) */
.bg-secondary      /* background: var(--surface-secondary) */
.bg-elevated       /* background: var(--surface-elevated) */
.bg-glass          /* background: var(--surface-glass) */
.bg-transparent    /* background: transparent */
```

### Effects
```css
.shadow-sm         /* box-shadow: var(--shadow-sm) */
.shadow-md         /* box-shadow: var(--shadow-md) */
.shadow-lg         /* box-shadow: var(--shadow-lg) */
.shadow-xl         /* box-shadow: var(--shadow-xl) */
.shadow-glow       /* box-shadow: var(--shadow-glow) */
.rounded-sm        /* border-radius: var(--radius-sm) */
.rounded-md        /* border-radius: var(--radius-md) */
.rounded-lg        /* border-radius: var(--radius-lg) */
.rounded-full      /* border-radius: var(--radius-full) */
```

---

## Animation Classes

### Keyframes
```css
@keyframes fadeIn { }      /* Fade in with slight up movement */
@keyframes slideIn { }     /* Slide in from left */
@keyframes slideUp { }     /* Slide up from bottom */
@keyframes pulse { }       /* Opacity pulse */
@keyframes glow { }        /* Shadow glow pulse */
@keyframes spin { }        /* 360 rotation */
@keyframes rotate { }      /* Orbital rotation */
```

### Animation Utilities
```css
.animate-fadeIn    /* animation: fadeIn 0.5s ease-out */
.animate-slideIn   /* animation: slideIn 0.3s ease-out */
.animate-pulse     /* animation: pulse 2s infinite */
.animate-spin      /* animation: spin 0.8s linear infinite */
.animate-none      /* animation: none */
```

---

## Migration Tracking

### Status Legend
- ✅ Completed
- 🚧 In Progress
- ⏳ Planned
- ❌ Deprecated

### Component Migration Status

| Component | Current Location | New Location | Status | Notes |
|-----------|-----------------|--------------|--------|-------|
| Button | `components.css:4-77` | `components/button.css` | ✅ | Renamed to .btn |
| Card | `components.css:79-106` | `components/card.css` | ✅ | Added BEM elements |
| Badge | `components.css:503-529` | `components/badge.css` | ✅ | Extracted all variants |
| Modal | `components.css:574-644` | `components/modal.css` | ✅ | Complete with animations |
| Toggle | `components.css:350-391` | `components/toggle.css` | ✅ | Enhanced with variants |
| Forms | `components.css:628-640` | `components/forms.css` | ✅ | Comprehensive form elements |
| ContentInbox | `components.css:123-347` | `features/content-inbox.css` | ✅ | Cosmic Station preserved |
| QueueManager | `components.css:474-550` | `features/queue-manager.css` | ✅ | Full feature extracted |
| MobileMenu | `components.css:727-885` | `features/mobile-menu.css` | ✅ | Enhanced animations |
| ThemeToggle | `components.css:921-983` | `features/theme-toggle.css` | ✅ | Added variants |
| Dropzone | `components.css:425-450` | `features/dropzone.css` | ✅ | Expanded functionality |
| Hero/App | `components.css:647-724` | `pages/home.css` | ✅ | Complete homepage styles |
| InboxPage | `components.css:108-121` | `pages/inbox.css` | ✅ | Page-specific styles |
| Library | - | `pages/library.css` | ✅ | New page template |
| Search | - | `pages/search.css` | ✅ | New page template |
| Header | `index.css:74-313` | `layout/header.css` | ✅ | Responsive header |
| Navigation | - | `layout/navigation.css` | ✅ | Sidebar & breadcrumbs |
| Responsive | - | `layout/responsive.css` | ✅ | Layout utilities |
| Animations | `globals.css` | `base/animations.css` | ✅ | All keyframes |
| Utilities | - | `utils/utilities.css` | ✅ | Comprehensive utilities |
| Spacing Fixes | - | `utils/spacing-fixes.css` | ✅ | Consistent spacing system |
| Input Fixes | - | `utils/input-fixes.css` | ✅ | Form alignment & interactions |

### Deprecated Classes
| Old Class | Replacement | Reason |
|-----------|-------------|--------|
| `.button--loading` | `.btn.is-loading` | Consistent state naming |
| `.card--interactive` | `.card.is-interactive` | State vs variant |
| `.text-green` | `.text-success` | Semantic naming |

### Breaking Changes
1. **Button**: `.button` → `.btn` (shorter, consistent)
2. **States**: Modifier states → `.is-*` pattern
3. **Spacing**: Custom spacing → utility classes

---

## Usage Examples

### Before Refactor
```html
<button class="button button--primary button--large button--loading">
  Submit
</button>
```

### After Refactor
```html
<button class="btn btn--primary btn--lg is-loading">
  Submit
</button>
```

### Complex Component
```html
<!-- Before -->
<div class="inbox-cosmic">
  <div class="cosmic-header">
    <div class="cosmic-title">Title</div>
  </div>
</div>

<!-- After -->
<div class="content-inbox">
  <div class="content-inbox__header">
    <div class="content-inbox__title">Title</div>
  </div>
</div>
```

---

## Developer Checklist - REQUIRED FOR ALL CSS

### Before Writing Any CSS:
1. **Check existing utilities** - Don't recreate what exists in `utilities.css`
2. **Identify the type** - Is it a component, page, feature, or utility?
3. **Choose correct file** - Follow the file organization rules above
4. **Use correct prefix** - Page/feature styles MUST use their prefix

### Naming Checklist:
- [ ] **Component**: Use base name (`.card`, `.btn`, `.modal`)
- [ ] **Modifier**: Use double dash (`.btn--primary`, `.card--elevated`)
- [ ] **Child**: Use double underscore (`.card__header`, `.modal__body`)
- [ ] **State**: Use `is-` or `has-` prefix (`.is-active`, `.has-error`)
- [ ] **Page-specific**: Use page prefix (`.playground__section`)
- [ ] **Feature-specific**: Use feature prefix (`.content-inbox__item`)

### File Placement Checklist:
- [ ] **Reusable?** → `/components/`
- [ ] **Page-specific?** → `/pages/` with page prefix
- [ ] **Feature module?** → `/features/` with feature prefix
- [ ] **Utility?** → `/utils/utilities.css` ONLY
- [ ] **Layout?** → `/layout/`

### Quality Checklist:
- [ ] Use CSS custom properties for all values
- [ ] Never hard-code colors, spacing, or sizes
- [ ] Test responsive behavior
- [ ] Check dark mode compatibility
- [ ] Document in this guide if adding new patterns

---

## Recent Additions (July 2025)

### Spacing System (`utils/spacing-fixes.css`)
Comprehensive spacing system that ensures consistent spacing throughout the app:
- **Headers**: Consistent top/bottom margins using `var(--space-md)`
- **Icons**: Proper spacing between icons and text
- **Cards**: Standardized padding and gaps
- **Demo sections**: Consistent component showcase spacing

### Input Alignment System (`utils/input-fixes.css`)
Fixes for form element alignment and interactions:
- **Icon alignment**: Centered icons in input fields using `translateY(-50%)`
- **Textarea performance**: GPU acceleration for smooth resizing
- **Select styling**: Custom dropdown arrow with proper alignment
- **Checkbox/Radio**: Custom styles with consistent spacing
- **Button-Input groups**: Matching heights (2.5rem) for visual harmony

### Component Updates
- **Badge sizes**: Added `xs`, `sm`, `md`, `lg` variants for different use cases
- **Button sizes**: Added `xs` size (0.375rem padding) for input groups
- **Modal spacing**: Fixed content bleeding with proper `modal__body` padding

## Notes
- This guide is a living document - update as patterns evolve
- When in doubt, favor consistency over perfection
- Gradual migration is OK - not everything needs to change at once
- Keep old classes during transition, deprecate gradually