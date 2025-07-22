# Test-Driven Grammar System for LLM-Assisted Development

## Overview
This document defines the testing grammar and conventions for LLM-assisted development, ensuring consistent, reliable, and testable code generation.

## Core Testing Philosophy
- **Test-First Development**: Write test descriptions before implementation
- **Behavior-Driven Syntax**: Tests describe what the code does, not how
- **LLM-Friendly Patterns**: Clear, predictable test structures for AI understanding

## Jest Unit Testing Grammar

### Component Test Structure
```typescript
// ComponentName.test.tsx
describe('ComponentName', () => {
  // Setup and teardown
  beforeEach(() => {
    // Reset state, mock functions
  });

  // Component rendering tests
  describe('rendering', () => {
    it('should render with default props', () => {
      // Test implementation
    });

    it('should render children correctly', () => {
      // Test implementation
    });
  });

  // Props validation tests
  describe('props', () => {
    it('should apply className to root element', () => {
      // Test implementation
    });

    it('should handle optional props gracefully', () => {
      // Test implementation
    });
  });

  // Event handling tests
  describe('interactions', () => {
    it('should call onClick when clicked', () => {
      // Test implementation
    });

    it('should handle keyboard events correctly', () => {
      // Test implementation
    });
  });

  // State management tests
  describe('state', () => {
    it('should update state on user action', () => {
      // Test implementation
    });
  });

  // Edge cases
  describe('edge cases', () => {
    it('should handle empty data gracefully', () => {
      // Test implementation
    });
  });
});
```

### Hook Test Structure
```typescript
// useHookName.test.ts
describe('useHookName', () => {
  it('should return initial state', () => {
    // Test implementation
  });

  it('should update state when action is called', () => {
    // Test implementation
  });

  it('should cleanup on unmount', () => {
    // Test implementation
  });
});
```

### Service Test Structure
```typescript
// ServiceName.test.ts
describe('ServiceName', () => {
  let service: ServiceName;

  beforeEach(() => {
    service = new ServiceName();
  });

  describe('methodName', () => {
    it('should return expected result for valid input', () => {
      // Test implementation
    });

    it('should throw error for invalid input', () => {
      // Test implementation
    });

    it('should handle async operations correctly', async () => {
      // Test implementation
    });
  });
});
```

## Cypress E2E Testing Grammar

### Page Object Pattern
```typescript
// pages/PageName.cy.ts
export class PageNamePage {
  // Selectors
  selectors = {
    submitButton: '[data-testid="submit-button"]',
    emailInput: '[data-testid="email-input"]',
    errorMessage: '[data-testid="error-message"]'
  };

  // Actions
  visit() {
    cy.visit('/page-path');
    return this;
  }

  fillEmail(email: string) {
    cy.get(this.selectors.emailInput).type(email);
    return this;
  }

  submit() {
    cy.get(this.selectors.submitButton).click();
    return this;
  }

  // Assertions
  shouldShowError(message: string) {
    cy.get(this.selectors.errorMessage)
      .should('be.visible')
      .and('contain', message);
    return this;
  }
}
```

### E2E Test Structure
```typescript
// e2e/feature-name.cy.ts
import { PageNamePage } from '../pages/PageName.cy';

describe('Feature Name', () => {
  let page: PageNamePage;

  beforeEach(() => {
    page = new PageNamePage();
    page.visit();
  });

  describe('Happy Path', () => {
    it('should complete user journey successfully', () => {
      page
        .fillEmail('user@example.com')
        .submit()
        .shouldShowSuccessMessage();
    });
  });

  describe('Error Handling', () => {
    it('should show error for invalid email', () => {
      page
        .fillEmail('invalid-email')
        .submit()
        .shouldShowError('Please enter a valid email');
    });
  });
});
```

## Test Naming Conventions

### Jest Test Names
```typescript
// Good test names - behavior focused
it('should display user name when logged in')
it('should return null when array is empty')
it('should throw ValidationError for invalid email format')

// Bad test names - implementation focused
it('should call setState')
it('should use regex')
it('should execute function')
```

### Cypress Test Names
```typescript
// Good E2E test names - user journey focused
it('should allow user to complete checkout process')
it('should prevent form submission with missing required fields')
it('should navigate to dashboard after successful login')

// Bad E2E test names - too technical
it('should click button')
it('should fill input')
it('should check element exists')
```

## Test Data Conventions

### Mock Data Structure
```typescript
// __mocks__/mockData.ts
export const mockUser = {
  id: 'user-123',
  email: 'test@example.com',
  name: 'Test User'
};

export const mockEmptyState = {
  items: [],
  loading: false,
  error: null
};

export const mockErrorState = {
  items: [],
  loading: false,
  error: 'Failed to load items'
};
```

### Test ID Convention
```html
<!-- Always use data-testid for E2E selectors -->
<button data-testid="submit-button">Submit</button>
<input data-testid="email-input" />
<div data-testid="error-message" />
```

## Coverage Requirements

### Unit Test Coverage
- **Components**: 80% minimum
- **Hooks**: 90% minimum
- **Utils/Services**: 95% minimum
- **Critical paths**: 100% required

### E2E Test Coverage
- **Happy paths**: All user journeys
- **Error paths**: Common error scenarios
- **Edge cases**: Browser compatibility, network issues

## LLM Directives for Test Generation

### Component Test Generation
```typescript
/**
 * @llm-test-component
 * @test-coverage 80
 * @test-scenarios rendering, props, interactions, state
 * @mock-dependencies Router, API
 */
```

### Service Test Generation
```typescript
/**
 * @llm-test-service
 * @test-coverage 95
 * @test-scenarios success, error, edge-cases
 * @mock-external fetch, localStorage
 */
```

### E2E Test Generation
```typescript
/**
 * @llm-test-e2e
 * @user-journey login -> dashboard -> action
 * @test-data use factory patterns
 * @assertions visual, functional, accessibility
 */
```

## Test Organization

### Directory Structure
```
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   └── Button.stories.tsx
├── hooks/
│   ├── useAuth/
│   │   ├── useAuth.ts
│   │   └── useAuth.test.ts
├── services/
│   ├── ApiService/
│   │   ├── ApiService.ts
│   │   └── ApiService.test.ts
└── __tests__/
    ├── integration/
    └── utils/

cypress/
├── e2e/
│   ├── auth/
│   │   └── login.cy.ts
│   └── content/
│       └── inbox.cy.ts
├── fixtures/
├── pages/
└── support/
```

## Common Testing Patterns

### Async Testing
```typescript
// Jest async pattern
it('should fetch data successfully', async () => {
  const data = await service.fetchData();
  expect(data).toEqual(expectedData);
});

// Cypress async pattern
it('should load content dynamically', () => {
  cy.intercept('GET', '/api/content', { fixture: 'content.json' });
  cy.visit('/');
  cy.get('[data-testid="content"]').should('have.length', 3);
});
```

### Error Testing
```typescript
// Jest error pattern
it('should handle network error gracefully', async () => {
  mockFetch.mockRejectedValue(new Error('Network error'));
  
  await expect(service.fetchData()).rejects.toThrow('Network error');
});

// Cypress error pattern
it('should display error message on failed submission', () => {
  cy.intercept('POST', '/api/submit', { statusCode: 500 });
  page.submit();
  page.shouldShowError('Something went wrong');
});
```

## Test Utilities

### Custom Matchers
```typescript
// jest.setup.ts
expect.extend({
  toBeValidEmail(received: string) {
    const pass = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(received);
    return {
      pass,
      message: () => `expected ${received} to be a valid email`
    };
  }
});
```

### Test Helpers
```typescript
// testUtils.ts
export const renderWithProviders = (ui: ReactElement, options = {}) => {
  return render(
    <ThemeProvider>
      <RouterProvider>
        {ui}
      </RouterProvider>
    </ThemeProvider>,
    options
  );
};
```

## CI/CD Integration

### Pre-commit Hooks
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run test:unit -- --coverage --watchAll=false"
    }
  }
}
```

### GitHub Actions
```yaml
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: npm ci
      - name: Run unit tests
        run: npm run test:unit -- --coverage
      - name: Run E2E tests
        run: npm run test:e2e
```

## Best Practices for LLM-Assisted Testing

1. **Clear Test Descriptions**: Write test names that clearly describe the expected behavior
2. **Predictable Structure**: Follow consistent patterns for test organization
3. **Explicit Assertions**: Make assertions specific and meaningful
4. **Isolated Tests**: Each test should be independent and not rely on others
5. **Meaningful Mocks**: Mock data should represent realistic scenarios
6. **Accessibility Testing**: Include ARIA and keyboard navigation tests
7. **Performance Considerations**: Test for performance regressions
8. **Documentation**: Document complex test scenarios and setup

## Test Anti-Patterns to Avoid

1. **Testing Implementation Details**: Focus on behavior, not internals
2. **Excessive Mocking**: Only mock what's necessary
3. **Brittle Selectors**: Use data-testid instead of CSS classes
4. **Shared State**: Avoid tests that depend on execution order
5. **Long Test Suites**: Keep individual tests focused and fast
6. **Ignoring Failures**: Never skip or ignore failing tests
7. **Over-Testing**: Don't test framework functionality
8. **Under-Testing**: Ensure critical paths have coverage

## Conclusion

This test-driven grammar system ensures that LLM-generated code is:
- Testable from the start
- Consistent across the codebase
- Maintainable over time
- Reliable in production

By following these patterns, both human developers and LLMs can create high-quality, well-tested code that meets the project's quality standards.