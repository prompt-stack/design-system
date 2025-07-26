# Generation Scripts

Scripts for generating code that follows Grammar Ops patterns.

## 📋 Available Scripts

### `generate-component.js`
Generates a complete component following Grammar Ops conventions.

**Usage:**
```bash
# Generate basic component
node generation/generate-component.js Button

# Generate with options
node generation/generate-component.js UserCard --layer composed --with-test --with-story

# Generate in specific location
node generation/generate-component.js Header --path src/layout/
```

**Options:**
- `--layer`: primitive|composed|feature (default: primitive)
- `--with-test`: Include test file
- `--with-story`: Include Storybook story
- `--with-styles`: Include CSS file (default: true)
- `--typescript`: Use TypeScript (default: true)

**Generates:**
```
src/components/Button/
├── Button.tsx          # Component with metadata
├── Button.test.tsx     # Test with Grammar patterns
├── button.css          # Styled with BEM conventions
└── Button.stories.tsx  # Storybook story
```

### `generate-test.sh`
Generates tests for existing components following test-driven grammar.

**Usage:**
```bash
# Generate test for component
./generation/generate-test.sh src/components/Button/Button.tsx

# Generate with specific test type
./generation/generate-test.sh --type unit src/hooks/useAuth.ts

# Generate E2E test
./generation/generate-test.sh --type e2e src/pages/LoginPage.tsx
```

**Test Types:**
- `unit`: Component/hook unit tests
- `integration`: Integration tests
- `e2e`: End-to-end tests

## 🎨 Generated Code Examples

### Component Generation

**Input:**
```bash
node generation/generate-component.js UserAvatar --layer primitive
```

**Output `UserAvatar.tsx`:**
```typescript
/**
 * @file components/UserAvatar
 * @purpose Display user avatar with fallback
 * @layer primitive
 * @dependencies None
 * @llm-read true
 * @llm-write full-edit
 * @llm-role utility
 */

import { Box } from '../Box';
import './user-avatar.css';

export interface UserAvatarProps {
  src?: string;
  alt: string;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export default function UserAvatar({
  src,
  alt,
  size = 'md',
  className = ''
}: UserAvatarProps) {
  return (
    <Box 
      className={`user-avatar user-avatar--${size} ${className}`}
      role="img"
      aria-label={alt}
    >
      {src ? (
        <img src={src} alt={alt} className="user-avatar__image" />
      ) : (
        <span className="user-avatar__fallback">
          {alt.charAt(0).toUpperCase()}
        </span>
      )}
    </Box>
  );
}
```

### Test Generation

**Input:**
```bash
./generation/generate-test.sh src/components/UserAvatar/UserAvatar.tsx
```

**Output `UserAvatar.test.tsx`:**
```typescript
/**
 * @fileoverview Test suite for UserAvatar component
 * @module UserAvatar.test
 */

import { render, screen } from '@testing-library/react';
import UserAvatar from './UserAvatar';

describe('UserAvatar', () => {
  const defaultProps = {
    alt: 'John Doe'
  };

  describe('rendering', () => {
    it('should render without crashing', () => {
      render(<UserAvatar {...defaultProps} />);
      expect(screen.getByRole('img')).toBeInTheDocument();
    });

    it('should display image when src provided', () => {
      render(<UserAvatar {...defaultProps} src="/avatar.jpg" />);
      expect(screen.getByAltText('John Doe')).toHaveAttribute('src', '/avatar.jpg');
    });

    it('should display fallback when no src', () => {
      render(<UserAvatar {...defaultProps} />);
      expect(screen.getByText('J')).toBeInTheDocument();
    });
  });

  describe('props', () => {
    it('should apply size modifier class', () => {
      render(<UserAvatar {...defaultProps} size="lg" />);
      expect(screen.getByRole('img')).toHaveClass('user-avatar--lg');
    });
  });
});
```

## 🔧 Configuration

### Component Templates
Templates are customizable via `.grammarops/templates/`:

```
.grammarops/
└── templates/
    ├── component.tsx.hbs
    ├── component.test.tsx.hbs
    ├── component.css.hbs
    └── component.stories.tsx.hbs
```

### Generation Config
```json
{
  "generation": {
    "components": {
      "defaultLayer": "primitive",
      "includeTests": true,
      "includeStyles": true,
      "includeStories": false,
      "typescript": true
    },
    "tests": {
      "framework": "jest",
      "testingLibrary": "@testing-library/react",
      "coverageThreshold": 80
    }
  }
}
```

## 🚀 Advanced Usage

### Batch Generation
```bash
# Generate multiple components
cat component-list.txt | xargs -I {} node generation/generate-component.js {}

# Generate tests for all components without tests
find src/components -name "*.tsx" -not -name "*.test.tsx" | \
  xargs -I {} ./generation/generate-test.sh {}
```

### Custom Templates
```bash
# Use custom template
node generation/generate-component.js Button --template custom-button

# Generate from JSON schema
node generation/generate-component.js --from-schema button-schema.json
```

## 🔄 Integration

### VS Code Task
```json
{
  "label": "Generate Component",
  "type": "shell",
  "command": "node",
  "args": [
    "${workspaceFolder}/scripts/generation/generate-component.js",
    "${input:componentName}",
    "--layer",
    "${input:componentLayer}"
  ]
}
```

### Package.json Scripts
```json
{
  "scripts": {
    "generate:component": "node scripts/generation/generate-component.js",
    "generate:test": "./scripts/generation/generate-test.sh",
    "generate:coverage": "find src -name '*.tsx' -not -name '*.test.tsx' | xargs -I {} ./scripts/generation/generate-test.sh {}"
  }
}
```

## 🎯 Best Practices

1. **Always Review Generated Code**: Templates are starting points
2. **Customize After Generation**: Add specific business logic
3. **Maintain Templates**: Keep templates updated with patterns
4. **Use Consistent Options**: Team should agree on defaults
5. **Generate Tests First**: Follow test-driven development

## 🔍 Troubleshooting

### Component Already Exists
- Use `--force` to overwrite (careful!)
- Or generate with different name and merge

### Template Not Found
- Check template path in config
- Ensure template files have correct extensions
- Verify template syntax (Handlebars)

### Generated Code Doesn't Compile
- Check TypeScript/JavaScript setting matches project
- Verify import paths are correct
- Ensure dependencies are installed

## 📚 Related Documentation

- Component Architecture patterns
- Test-Driven Grammar guide
- Grammar Ops naming conventions
- Template customization guide