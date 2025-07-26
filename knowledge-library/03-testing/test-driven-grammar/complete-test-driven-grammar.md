# Complete Test-Driven Grammar System - Testing as Language

## 📍 Source Information
- **Primary Source**: `/docs/TEST_DRIVEN_GRAMMAR.md` (lines 1-452)
- **Original Intent**: Define testing grammar and conventions for LLM-assisted development
- **Key Innovation**: Testing becomes part of the grammatical language system
- **Revolutionary Concept**: Tests describe behavior in natural language patterns that LLMs can generate and understand

## 🎯 Core Philosophy - Testing as Communication (Lines 5-10)

**Foundational Testing Principles**:

1. **Test-First Development**: Write test descriptions before implementation
   - **Impact**: LLMs understand desired behavior before generating code
   - **Grammar**: Natural language descriptions become test specifications

2. **Behavior-Driven Syntax**: Tests describe what the code does, not how
   - **Impact**: Tests read like documentation, not technical implementation
   - **Grammar**: Subject-verb-object patterns in test names

3. **LLM-Friendly Patterns**: Clear, predictable test structures for AI understanding
   - **Impact**: Consistent patterns enable reliable test generation
   - **Grammar**: Standardized test organization across all layers

## 🧪 Jest Unit Testing Grammar - Component Testing Language (Lines 11-113)

### Component Test Structure Grammar (Lines 13-69)

**Complete Component Test Template with Grammar Rules**:

```typescript
// ComponentName.test.tsx - Grammar: Component + .test suffix
describe('ComponentName', () => {              // Grammar: Component name as test suite
  // Setup and teardown section
  beforeEach(() => {                          // Grammar: Temporal hook naming
    // Reset state, mock functions
  });

  // GRAMMAR PATTERN: Group by aspect being tested
  
  // Rendering tests - Grammar: "rendering" grouping
  describe('rendering', () => {
    it('should render with default props', () => {     // Grammar: should + verb + condition
      // Test implementation
    });

    it('should render children correctly', () => {      // Grammar: should + verb + adverb
      // Test implementation
    });
    
    it('should display loading state', () => {          // Grammar: should + verb + state
      // Test implementation
    });
  });

  // Props validation - Grammar: "props" grouping
  describe('props', () => {
    it('should apply className to root element', () => {  // Grammar: should + apply + target
      // Test implementation
    });

    it('should handle optional props gracefully', () => {  // Grammar: should + handle + adverb
      // Test implementation
    });
    
    it('should use default values when not provided', () => {
      // Test implementation
    });
  });

  // Event handling - Grammar: "interactions" grouping
  describe('interactions', () => {
    it('should call onClick when clicked', () => {        // Grammar: should + call + condition
      // Test implementation
    });

    it('should handle keyboard events correctly', () => {  // Grammar: should + handle + correctly
      // Test implementation
    });
    
    it('should prevent default on form submission', () => {
      // Test implementation
    });
  });

  // State management - Grammar: "state" grouping
  describe('state', () => {
    it('should update state on user action', () => {      // Grammar: should + update + trigger
      // Test implementation
    });
    
    it('should reset state when component unmounts', () => {
      // Test implementation
    });
  });

  // Edge cases - Grammar: "edge cases" grouping
  describe('edge cases', () => {
    it('should handle empty data gracefully', () => {     // Grammar: should + handle + gracefully
      // Test implementation
    });
    
    it('should render fallback for missing required props', () => {
      // Test implementation
    });
  });
});
```

**Component Test Grammar Rules**:
1. **Test suite naming**: Always matches component filename
2. **Describe blocks**: Group by aspect (rendering, props, interactions, state, edge cases)
3. **Test names**: Always start with "should" followed by action verb
4. **Behavioral focus**: Describe outcome, not implementation
5. **Consistent grouping**: Same categories across all components

### Hook Test Structure Grammar (Lines 71-87)

**React Hook Test Template**:

```typescript
// useHookName.test.ts - Grammar: Hook name + .test suffix
describe('useHookName', () => {                        // Grammar: Hook name as suite
  it('should return initial state', () => {            // Grammar: should + return + what
    const { result } = renderHook(() => useHookName());
    expect(result.current.value).toBe(initialValue);
  });

  it('should update state when action is called', () => {  // Grammar: should + update + when
    const { result } = renderHook(() => useHookName());
    act(() => {
      result.current.setValue('new value');
    });
    expect(result.current.value).toBe('new value');
  });

  it('should cleanup on unmount', () => {              // Grammar: should + cleanup + when
    const { unmount } = renderHook(() => useHookName());
    unmount();
    // Verify cleanup occurred
  });
  
  it('should handle error states correctly', () => {    // Grammar: should + handle + correctly
    // Test error scenarios
  });
});
```

**Hook Test Grammar Rules**:
1. **Initial state verification**: Always test default return values
2. **State updates**: Test all state-changing functions
3. **Cleanup testing**: Verify proper resource cleanup
4. **Error handling**: Test error scenarios explicitly

### Service Test Structure Grammar (Lines 89-113)

**Service/Utility Test Template**:

```typescript
// ServiceName.test.ts - Grammar: Service + .test suffix
describe('ServiceName', () => {                        // Grammar: Service name as suite
  let service: ServiceName;

  beforeEach(() => {
    service = new ServiceName();                       // Grammar: Setup instance
    jest.clearAllMocks();                             // Grammar: Clear test state
  });

  describe('methodName', () => {                       // Grammar: Method name grouping
    it('should return expected result for valid input', () => {  // Grammar: should + return + condition
      const result = service.methodName('valid input');
      expect(result).toEqual(expectedValue);
    });

    it('should throw error for invalid input', () => {   // Grammar: should + throw + condition
      expect(() => service.methodName('invalid')).toThrow(ValidationError);
    });

    it('should handle async operations correctly', async () => {  // Grammar: should + handle + async
      const result = await service.asyncMethod();
      expect(result).toBeDefined();
    });
    
    it('should retry failed requests up to 3 times', async () => {
      // Test retry logic
    });
  });
});
```

**Service Test Grammar Rules**:
1. **Method grouping**: Each public method gets its own describe block
2. **Success cases first**: Valid input tests before error cases
3. **Error testing**: Explicit error type expectations
4. **Async patterns**: Clear async/await usage in test names

## 🌐 Cypress E2E Testing Grammar - User Journey Language (Lines 115-185)

### Page Object Pattern Grammar (Lines 117-152)

**Page Object Model Template**:

```typescript
// pages/PageName.cy.ts - Grammar: PageName + Page suffix
export class PageNamePage {
  // GRAMMAR RULE: Group selectors by feature
  selectors = {
    // Form elements
    submitButton: '[data-testid="submit-button"]',     // Grammar: element + action
    emailInput: '[data-testid="email-input"]',         // Grammar: element + type
    passwordInput: '[data-testid="password-input"]',
    
    // Feedback elements
    errorMessage: '[data-testid="error-message"]',     // Grammar: feedback + type
    successMessage: '[data-testid="success-message"]',
    loadingSpinner: '[data-testid="loading-spinner"]',
    
    // Navigation elements
    homeLink: '[data-testid="home-link"]',
    logoutButton: '[data-testid="logout-button"]'
  };

  // GRAMMAR RULE: Action methods return 'this' for chaining
  visit() {
    cy.visit('/page-path');
    cy.wait('@pageLoad');                              // Grammar: Wait for stability
    return this;
  }

  fillEmail(email: string) {
    cy.get(this.selectors.emailInput)
      .clear()                                         // Grammar: Clear before type
      .type(email);
    return this;
  }

  fillPassword(password: string) {
    cy.get(this.selectors.passwordInput)
      .clear()
      .type(password);
    return this;
  }

  submit() {
    cy.get(this.selectors.submitButton).click();
    return this;
  }

  // GRAMMAR RULE: Assertion methods start with 'should'
  shouldShowError(message: string) {
    cy.get(this.selectors.errorMessage)
      .should('be.visible')                            // Grammar: Visibility first
      .and('contain', message);                        // Grammar: Content second
    return this;
  }
  
  shouldBeLoggedIn() {
    cy.url().should('include', '/dashboard');
    cy.get(this.selectors.logoutButton).should('be.visible');
    return this;
  }
}
```

**Page Object Grammar Rules**:
1. **Selector organization**: Group by feature/purpose
2. **Action chaining**: All actions return `this` for fluent interface
3. **Clear-then-type pattern**: Always clear inputs before typing
4. **Assertion naming**: Start with "should" for all assertions
5. **Wait for stability**: Include appropriate waits after navigation

### E2E Test Structure Grammar (Lines 154-185)

**Complete E2E Test Template**:

```typescript
// e2e/feature-name.cy.ts - Grammar: feature-name in kebab-case
import { PageNamePage } from '../pages/PageName.cy';

describe('Feature Name', () => {                       // Grammar: Feature as suite name
  let page: PageNamePage;

  beforeEach(() => {
    // Setup test data
    cy.task('db:seed');                               // Grammar: Namespace tasks
    cy.intercept('GET', '/api/**', { middleware: true }); // Grammar: API interception
    
    page = new PageNamePage();
    page.visit();
  });

  describe('Happy Path', () => {                       // Grammar: "Happy Path" grouping
    it('should complete user journey successfully', () => {
      page
        .fillEmail('user@example.com')
        .fillPassword('SecurePass123!')
        .submit()
        .shouldBeLoggedIn()
        .shouldShowWelcomeMessage();
    });
    
    it('should remember user preferences', () => {
      // Test persistent state
    });
  });

  describe('Error Handling', () => {                   // Grammar: "Error Handling" grouping
    it('should show error for invalid email', () => {
      page
        .fillEmail('invalid-email')
        .submit()
        .shouldShowError('Please enter a valid email');
    });
    
    it('should handle network failures gracefully', () => {
      cy.intercept('POST', '/api/login', { statusCode: 500 });
      page
        .fillEmail('user@example.com')
        .fillPassword('password')
        .submit()
        .shouldShowError('Network error. Please try again.');
    });
  });
  
  describe('Accessibility', () => {                    // Grammar: "Accessibility" grouping
    it('should be keyboard navigable', () => {
      cy.get('body').tab();
      cy.focused().should('have.attr', 'data-testid', 'email-input');
    });
  });
});
```

**E2E Test Grammar Rules**:
1. **Feature-based organization**: Tests grouped by user features
2. **Journey descriptions**: Test names describe complete user flows
3. **Happy path first**: Success scenarios before error cases
4. **Real user actions**: Tests mirror actual user behavior
5. **Accessibility included**: A11y tests as standard practice

## 📝 Test Naming Conventions - Natural Language Patterns (Lines 187-213)

### Jest Test Name Grammar (Lines 189-200)

**Good Test Names - Behavior Focused**:
```typescript
// GRAMMAR PATTERN: should + verb + object/condition
it('should display user name when logged in')         // Conditional display
it('should return null when array is empty')          // Edge case handling
it('should throw ValidationError for invalid email format') // Error specificity

// GRAMMAR PATTERN: should + handle + scenario + adverb
it('should handle concurrent requests gracefully')     // Concurrency
it('should process large datasets efficiently')        // Performance
it('should recover from network failures automatically') // Resilience
```

**Bad Test Names - Implementation Focused**:
```typescript
// ❌ AVOID: Implementation details
it('should call setState')                            // Internal method
it('should use regex')                                // Implementation choice
it('should execute function')                         // Too generic

// ❌ AVOID: Technical jargon
it('should mutate state object')                      // Implementation detail
it('should invoke callback')                          // Too technical
```

### Cypress Test Name Grammar (Lines 202-213)

**Good E2E Test Names - User Journey Focused**:
```typescript
// GRAMMAR PATTERN: should + allow/prevent + user + to + action
it('should allow user to complete checkout process')   // Complete flow
it('should prevent form submission with missing required fields') // Validation
it('should navigate to dashboard after successful login') // Navigation flow

// GRAMMAR PATTERN: should + display/show + what + when
it('should display search results when user enters query') // Feature behavior
it('should show error notification when payment fails')    // Error handling
```

**Bad E2E Test Names - Too Technical**:
```typescript
// ❌ AVOID: Low-level actions
it('should click button')                             // Single action
it('should fill input')                               // Partial flow
it('should check element exists')                     // Technical check
```

## 📊 Test Data Conventions - Structured Test Data Language (Lines 215-246)

### Mock Data Structure Grammar (Lines 217-237)

**Standardized Mock Data Patterns**:

```typescript
// __mocks__/mockData.ts
// GRAMMAR RULE: mock prefix for all test data
export const mockUser = {                              // Grammar: mock + Entity
  id: 'user-123',                                     // Grammar: entity + number
  email: 'test@example.com',                          // Grammar: test@ domain
  name: 'Test User'                                   // Grammar: "Test" prefix
};

export const mockUsers = [                             // Grammar: Plural for arrays
  { id: 'user-1', name: 'Test User 1' },
  { id: 'user-2', name: 'Test User 2' },
  { id: 'user-3', name: 'Test User 3' }
];

// GRAMMAR RULE: State variations with descriptive names
export const mockEmptyState = {                       // Grammar: mock + descriptor + State
  items: [],
  loading: false,
  error: null
};

export const mockLoadingState = {
  items: [],
  loading: true,
  error: null
};

export const mockErrorState = {
  items: [],
  loading: false,
  error: 'Failed to load items'                        // Grammar: Human-readable errors
};

// GRAMMAR RULE: Factory functions for dynamic data
export const createMockUser = (overrides = {}) => ({  // Grammar: create + Mock + Entity
  id: 'user-123',
  email: 'test@example.com',
  name: 'Test User',
  ...overrides
});
```

### Test ID Convention Grammar (Lines 239-246)

**Data Test ID Patterns**:

```html
<!-- GRAMMAR RULE: Always use data-testid for E2E selectors -->
<!-- Pattern: element-purpose -->
<button data-testid="submit-button">Submit</button>
<button data-testid="cancel-button">Cancel</button>

<!-- Pattern: element-context-purpose -->
<input data-testid="login-email-input" />
<input data-testid="register-email-input" />

<!-- Pattern: feedback-type -->
<div data-testid="error-message" />
<div data-testid="success-message" />
<div data-testid="warning-message" />

<!-- Pattern: list-item-index -->
<li data-testid="todo-item-0">First Todo</li>
<li data-testid="todo-item-1">Second Todo</li>
```

**Test ID Grammar Rules**:
1. **Lowercase kebab-case**: All test IDs use hyphens
2. **Element-first naming**: Start with element type
3. **Context when needed**: Add context for disambiguation
4. **Purpose suffix**: End with element purpose
5. **Index for lists**: Use numeric suffixes for list items

## 📈 Coverage Requirements - Quality Metrics Grammar (Lines 247-259)

### Unit Test Coverage Standards

**Coverage Requirements by Layer**:

| Layer | Minimum Coverage | Rationale | Focus Areas |
|-------|-----------------|-----------|-------------|
| **Components** | 80% | UI can be visually tested | Props, events, rendering |
| **Hooks** | 90% | Critical state logic | All state changes, edge cases |
| **Utils/Services** | 95% | Pure functions, critical | All code paths, error cases |
| **Critical Paths** | 100% | Business critical | Auth, payments, data integrity |

### E2E Test Coverage Standards

**User Journey Coverage**:
- **Happy Paths**: All primary user workflows
- **Error Paths**: Common failure scenarios
- **Edge Cases**: Browser compatibility, slow networks
- **Accessibility**: Keyboard navigation, screen readers

## 🤖 LLM Directives for Test Generation - AI Test Instructions (Lines 260-290)

### Component Test Generation Directives

```typescript
/**
 * @llm-test-component
 * @test-coverage 80                                   // Minimum coverage target
 * @test-scenarios rendering, props, interactions, state // What to test
 * @mock-dependencies Router, API                     // What to mock
 * @test-accessibility true                           // Include a11y tests
 * @test-performance false                            // Skip perf tests
 */
export function UserCard({ user, onClick }) {
  // Component implementation
}
```

### Service Test Generation Directives

```typescript
/**
 * @llm-test-service  
 * @test-coverage 95                                   // Higher coverage for services
 * @test-scenarios success, error, edge-cases, async  // Comprehensive scenarios
 * @mock-external fetch, localStorage                 // External dependencies
 * @test-retry-logic true                            // Test resilience patterns
 * @test-timeout 5000                                 // Async timeout
 */
export class UserService {
  // Service implementation
}
```

### E2E Test Generation Directives

```typescript
/**
 * @llm-test-e2e
 * @user-journey login -> dashboard -> action -> logout // Complete flow
 * @test-data use factory patterns                    // Data generation strategy
 * @assertions visual, functional, accessibility      // What to verify
 * @network-conditions fast-3g, offline              // Network scenarios
 * @viewport-sizes mobile, tablet, desktop           // Responsive testing
 */
```

**LLM Directive Grammar Rules**:
1. **Explicit scenarios**: Tell AI exactly what to test
2. **Coverage targets**: Set minimum acceptable coverage
3. **Mock strategy**: Specify what should be mocked
4. **Test types**: Include/exclude specific test categories
5. **User journeys**: Define complete flows for E2E

## 📁 Test Organization - Structural Grammar (Lines 292-323)

### Directory Structure Grammar

```
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx                  # Component file
│   │   ├── Button.test.tsx             # Co-located unit tests
│   │   ├── Button.stories.tsx          # Storybook stories
│   │   └── Button.e2e.tsx             # Component-specific E2E
│   │
├── hooks/
│   ├── useAuth/
│   │   ├── useAuth.ts                  # Hook implementation
│   │   ├── useAuth.test.ts             # Hook unit tests
│   │   └── useAuth.mock.ts            # Mock implementation
│   │
├── services/
│   ├── ApiService/
│   │   ├── ApiService.ts               # Service implementation
│   │   ├── ApiService.test.ts          # Service unit tests
│   │   └── ApiService.integration.ts   # Integration tests
│   │
└── __tests__/                          # Shared test utilities
    ├── integration/                    # Cross-component tests
    ├── fixtures/                       # Shared test data
    └── utils/                          # Test helpers

cypress/
├── e2e/
│   ├── auth/
│   │   ├── login.cy.ts                # Login flow tests
│   │   ├── register.cy.ts             # Registration tests
│   │   └── password-reset.cy.ts       # Password reset flow
│   │
│   └── features/
│       ├── content-inbox.cy.ts        # Feature tests
│       └── user-settings.cy.ts        # Settings tests
│   
├── fixtures/                           # E2E test data
├── pages/                              # Page objects
├── support/                            # Custom commands
└── downloads/                          # Test downloads
```

**Test Organization Grammar Rules**:
1. **Co-location**: Unit tests next to implementation
2. **Feature grouping**: E2E tests organized by feature
3. **Shared utilities**: Common test code in `__tests__`
4. **Mock separation**: Mocks in separate files
5. **Integration tests**: Cross-component tests grouped

## 🔄 Common Testing Patterns - Reusable Test Grammar (Lines 325-359)

### Async Testing Grammar (Lines 327-341)

**Async Test Patterns**:

```typescript
// Jest async pattern - Grammar: async/await clarity
it('should fetch data successfully', async () => {
  // Arrange
  const expectedData = { id: 1, name: 'Test' };
  mockApi.get.mockResolvedValue(expectedData);
  
  // Act
  const data = await service.fetchData();
  
  // Assert
  expect(data).toEqual(expectedData);
  expect(mockApi.get).toHaveBeenCalledWith('/api/data');
});

// Cypress async pattern - Grammar: Command chaining
it('should load content dynamically', () => {
  // Arrange - Intercept network request
  cy.intercept('GET', '/api/content', { 
    fixture: 'content.json' 
  }).as('contentRequest');
  
  // Act - Visit page
  cy.visit('/');
  
  // Assert - Wait and verify
  cy.wait('@contentRequest');
  cy.get('[data-testid="content-item"]').should('have.length', 3);
});
```

### Error Testing Grammar (Lines 343-359)

**Error Test Patterns**:

```typescript
// Jest error pattern - Grammar: Explicit error scenarios
it('should handle network error gracefully', async () => {
  // Arrange - Mock network failure
  const networkError = new Error('Network error');
  mockFetch.mockRejectedValue(networkError);
  
  // Act & Assert - Verify error handling
  await expect(service.fetchData()).rejects.toThrow('Network error');
  expect(logger.error).toHaveBeenCalledWith('Fetch failed:', networkError);
});

// Cypress error pattern - Grammar: User-visible errors
it('should display error message on failed submission', () => {
  // Arrange - Mock server error
  cy.intercept('POST', '/api/submit', { 
    statusCode: 500,
    body: { error: 'Server error' }
  }).as('submitError');
  
  // Act - Trigger error
  page.fillForm().submit();
  
  // Assert - Verify user feedback
  cy.wait('@submitError');
  page.shouldShowError('Something went wrong. Please try again.');
});
```

## 🧰 Test Utilities - Helper Function Grammar (Lines 361-390)

### Custom Matchers Grammar (Lines 363-374)

**Jest Custom Matcher Patterns**:

```typescript
// jest.setup.ts - Grammar: Semantic matchers
expect.extend({
  // Email validation matcher
  toBeValidEmail(received: string) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const pass = emailRegex.test(received);
    
    return {
      pass,
      message: () => pass
        ? `expected ${received} not to be a valid email`
        : `expected ${received} to be a valid email`
    };
  },
  
  // Date range matcher
  toBeBetweenDates(received: Date, start: Date, end: Date) {
    const pass = received >= start && received <= end;
    
    return {
      pass,
      message: () => pass
        ? `expected ${received} not to be between ${start} and ${end}`
        : `expected ${received} to be between ${start} and ${end}`
    };
  }
});

// Usage
expect('user@example.com').toBeValidEmail();
expect(new Date()).toBeBetweenDates(yesterday, tomorrow);
```

### Test Helper Functions Grammar (Lines 376-390)

**Reusable Test Utilities**:

```typescript
// testUtils.ts - Grammar: Descriptive helper names
export const renderWithProviders = (
  ui: ReactElement, 
  options: RenderOptions = {}
) => {
  const AllProviders = ({ children }: { children: ReactNode }) => (
    <ThemeProvider theme={theme}>
      <AuthProvider>
        <RouterProvider>
          {children}
        </RouterProvider>
      </AuthProvider>
    </ThemeProvider>
  );
  
  return render(ui, { wrapper: AllProviders, ...options });
};

// Factory functions - Grammar: create + Entity pattern
export const createTestUser = (overrides = {}) => ({
  id: generateId(),
  email: 'test@example.com',
  name: 'Test User',
  role: 'user',
  ...overrides
});

// Wait utilities - Grammar: wait + Condition pattern
export const waitForElement = async (testId: string) => {
  return waitFor(() => {
    expect(screen.getByTestId(testId)).toBeInTheDocument();
  });
};
```

## 🚀 CI/CD Integration - Automated Test Grammar (Lines 392-421)

### Pre-commit Hook Grammar (Lines 394-402)

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run test:unit -- --coverage --watchAll=false --bail"
    }
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "npm run test:unit -- --findRelatedTests --passWithNoTests"
    ]
  }
}
```

### GitHub Actions Grammar (Lines 404-421)

```yaml
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16.x, 18.x]
        
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run unit tests with coverage
        run: npm run test:unit -- --coverage --coverageReporters=json-summary
        
      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        
      - name: Run E2E tests
        run: |
          npm run build
          npm run test:e2e -- --record --parallel
        env:
          CYPRESS_RECORD_KEY: ${{ secrets.CYPRESS_RECORD_KEY }}
```

## ✅ Best Practices for LLM-Assisted Testing (Lines 423-432)

### LLM Testing Guidelines

1. **Clear Test Descriptions**: Natural language that describes expected behavior
2. **Predictable Structure**: Consistent patterns across all test types
3. **Explicit Assertions**: Specific expectations, not generic checks
4. **Isolated Tests**: No dependencies between tests
5. **Meaningful Mocks**: Realistic data that represents actual scenarios
6. **Accessibility Testing**: ARIA and keyboard tests as standard
7. **Performance Considerations**: Include performance regression tests
8. **Documentation**: Complex scenarios documented inline

## ❌ Test Anti-Patterns to Avoid (Lines 433-443)

### Testing Anti-Pattern Grammar

1. **Testing Implementation Details**: 
   ```typescript
   // ❌ BAD: Tests internal state
   expect(component.state.counter).toBe(1);
   
   // ✅ GOOD: Tests visible behavior
   expect(screen.getByText('Count: 1')).toBeInTheDocument();
   ```

2. **Excessive Mocking**:
   ```typescript
   // ❌ BAD: Mocking everything
   jest.mock('react');
   
   // ✅ GOOD: Mock only external dependencies
   jest.mock('../api/userService');
   ```

3. **Brittle Selectors**:
   ```typescript
   // ❌ BAD: CSS class selectors
   cy.get('.btn-primary').click();
   
   // ✅ GOOD: Data test IDs
   cy.get('[data-testid="submit-button"]').click();
   ```

4. **Shared State**:
   ```typescript
   // ❌ BAD: Tests depend on order
   let sharedUser;
   beforeAll(() => { sharedUser = createUser(); });
   
   // ✅ GOOD: Each test is independent
   beforeEach(() => { const user = createUser(); });
   ```

## 🎯 Conclusion - Testing as Complete Language (Lines 445-452)

### Test-Driven Grammar Impact

This test-driven grammar system ensures that LLM-generated code is:

1. **Testable from the start** - Test patterns built into code generation
2. **Consistent across the codebase** - Same testing language everywhere
3. **Maintainable over time** - Clear patterns reduce maintenance burden
4. **Reliable in production** - Comprehensive coverage prevents regressions

By following these patterns, both human developers and LLMs can create high-quality, well-tested code that meets the project's quality standards.

## 🔗 Cross-References & Integration

### This System Connects To:
- **Component Architecture**: `/01-architecture/component-layers/` - Tests organized by architectural layer
- **Grammar Rules**: `/02-grammar/naming-system/` - Test naming follows grammar patterns
- **Metadata System**: `/01-architecture/metadata-system/` - Test directives in metadata
- **Full Stack Grammar**: `/02-grammar/full-stack-system/` - Testing across all layers

### This System Enables:
- **Test-First AI Development**: LLMs write tests before implementation
- **Behavioral Documentation**: Tests serve as living documentation
- **Quality Enforcement**: Coverage requirements prevent untested code
- **Consistent Test Language**: Same patterns from unit to E2E tests

### Dependencies:
- **Test Infrastructure**: Jest, Cypress, Testing Library required
- **Mock System**: Consistent mock data patterns needed
- **CI/CD Pipeline**: Automated test execution required
- **Coverage Tools**: Metrics tracking for quality gates

This creates a **complete testing language** where tests become a form of communication between developers, AI, and the codebase itself - making quality an inherent part of the development grammar.