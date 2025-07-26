# Complete Test Templates - Concrete Grammar Implementation

## 📍 Source Information
- **Primary Sources**: 
  - `/templates/tests/component.test.template.tsx` (lines 1-138)
  - `/templates/tests/hook.test.template.ts` (lines 1-176)
  - `/templates/tests/e2e.test.template.ts` (lines 1-225)
  - `/templates/tests/utility.test.template.ts` (lines 1-73)
- **Original Intent**: Provide concrete test templates implementing Grammar Ops patterns
- **Key Innovation**: Standardized test structures following linguistic patterns
- **Revolutionary Concept**: Test templates as executable grammar documentation

## 🎯 Overview - Templates as Living Documentation

These test templates demonstrate the practical implementation of Grammar Ops testing patterns. Each template:

1. **Follows consistent grammar** - "should + verb + condition" patterns
2. **Implements complete coverage** - All aspects of code testing
3. **Provides clear structure** - Organized by concern (rendering, state, etc.)
4. **Includes best practices** - Accessibility, performance, edge cases
5. **Uses LLM directives** - Machine-readable test metadata

## 🧩 Component Test Template - Complete UI Testing Grammar

### Template Structure Overview (Lines 1-138)

```typescript
/**
 * @fileoverview Test template for React components
 * @module {{ComponentName}}.test
 * @llm-test-component           // LLM directive for component tests
 * @test-coverage 80            // Minimum coverage requirement
 */
```

### Key Sections and Grammar Patterns

#### 1. Test Organization Structure
```typescript
describe('{{ComponentName}}', () => {              // Component name as suite
  describe('rendering', () => {})                  // Visual output tests
  describe('props', () => {})                      // Property validation
  describe('interactions', () => {})               // User action tests
  describe('state', () => {})                      // State management
  describe('accessibility', () => {})              // A11y compliance
  describe('edge cases', () => {})                 // Boundary conditions
  describe('performance', () => {})                // Efficiency tests
});
```

#### 2. Rendering Tests Grammar
```typescript
describe('rendering', () => {
  it('should render without crashing', () => {})           // Basic render
  it('should render with custom className', () => {})      // Style application
  it('should render children correctly', () => {})         // Content projection
});
```

**Grammar Pattern**: "should + verb + object/condition"
- Always starts with "should"
- Present tense verb
- Clear outcome description

#### 3. Props Validation Grammar
```typescript
describe('props', () => {
  it('should handle all prop variations correctly', () => {})
  it('should apply data attributes', () => {})
});
```

**Grammar Focus**: Testing component API contract

#### 4. Interaction Testing Grammar
```typescript
describe('interactions', () => {
  it('should handle click events', async () => {
    const handleClick = jest.fn();
    renderComponent({ onClick: handleClick });
    
    await userEvent.click(element);
    
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
  
  it('should handle keyboard events', async () => {})
});
```

**Grammar Pattern**: "should + handle + event type"
- Async/await for user actions
- Clear cause-effect relationship

#### 5. State Management Grammar
```typescript
describe('state', () => {
  it('should manage internal state correctly', async () => {})
  it('should update when props change', () => {})
});
```

**Grammar Focus**: State transitions and updates

#### 6. Accessibility Grammar
```typescript
describe('accessibility', () => {
  it('should have proper ARIA attributes', () => {})
  it('should be keyboard navigable', async () => {})
});
```

**Grammar Pattern**: Inclusivity-focused language

#### 7. Edge Case Grammar
```typescript
describe('edge cases', () => {
  it('should handle null/undefined props gracefully', () => {})
  it('should handle empty data', () => {})
});
```

**Grammar Focus**: Resilience and error handling

#### 8. Performance Grammar
```typescript
describe('performance', () => {
  it('should not re-render unnecessarily', () => {})
});
```

**Grammar Pattern**: Efficiency assertions

### Helper Functions Pattern
```typescript
// Consistent helper naming
const defaultProps = {};                    // Default test data
const renderComponent = (props = {}) => {}; // Render wrapper
```

## 🪝 Hook Test Template - Stateful Logic Testing Grammar

### Template Structure Overview (Lines 1-176)

```typescript
/**
 * @llm-test-hook               // Hook-specific LLM directive
 * @test-coverage 90           // Higher coverage for critical logic
 */
```

### Hook Testing Sections

#### 1. Initialization Grammar
```typescript
describe('initialization', () => {
  it('should return initial state', () => {})
  it('should accept initial configuration', () => {})
});
```

**Grammar Pattern**: Testing default behavior

#### 2. State Update Grammar
```typescript
describe('state updates', () => {
  it('should update state when action is called', async () => {
    act(() => {
      result.current.updateState('new value');
    });
    
    expect(result.current.state).toBe('new value');
  });
  
  it('should handle async operations', async () => {})
});
```

**Grammar Focus**: Action → Result patterns

#### 3. Error Handling Grammar
```typescript
describe('error handling', () => {
  it('should handle errors gracefully', async () => {})
  it('should reset error state', () => {})
});
```

**Grammar Pattern**: Resilience testing

#### 4. Effects Grammar
```typescript
describe('effects', () => {
  it('should run effect on mount', () => {})
  it('should cleanup on unmount', () => {})
  it('should re-run effect when dependencies change', () => {})
});
```

**Grammar Focus**: Lifecycle behavior

#### 5. Memoization Grammar
```typescript
describe('memoization', () => {
  it('should memoize expensive calculations', () => {})
});
```

**Grammar Pattern**: Performance optimization

#### 6. Hook Edge Cases
```typescript
describe('edge cases', () => {
  it('should handle rapid state updates', () => {})
  it('should handle concurrent operations', async () => {})
});
```

**Grammar Focus**: Stress testing

### Hook Testing Best Practices
- Use `renderHook` for isolation
- Wrap updates in `act()`
- Test cleanup explicitly
- Verify memoization works

## 🌐 E2E Test Template - User Journey Grammar

### Template Structure Overview (Lines 1-225)

```typescript
/**
 * @llm-test-e2e
 * @user-journey {{describe journey}}    // Natural language journey
 */
```

### E2E Test Organization

#### 1. Setup/Teardown Grammar
```typescript
beforeEach(() => {
  page = new {{PageName}}Page();     // Page object pattern
  cy.clearTestData();                // Clean state
  cy.seedTestData('base-data');      // Known state
  cy.login('test@example.com');      // Authentication
  page.visit();                      // Navigation
});
```

**Grammar Pattern**: Imperative setup commands

#### 2. Page Load Grammar
```typescript
describe('Page Load', () => {
  it('should load the page successfully', () => {
    page
      .shouldBeVisible()
      .shouldHaveTitle('{{Page Title}}')
      .shouldShowMainContent();
  });
});
```

**Grammar Pattern**: Fluent interface chaining

#### 3. User Interaction Grammar
```typescript
describe('User Interactions', () => {
  it('should handle form submission successfully', () => {
    page
      .fillForm({ name: 'Test', email: 'test@example.com' })
      .submitForm()
      .shouldShowSuccessMessage('Form submitted successfully');
  });
  
  it('should validate form inputs', () => {})
  it('should handle search functionality', () => {})
  it('should handle filtering and sorting', () => {})
});
```

**Grammar Focus**: User action sequences

#### 4. Navigation Grammar
```typescript
describe('Navigation', () => {
  it('should navigate between pages', () => {})
  it('should handle browser back/forward', () => {})
});
```

**Grammar Pattern**: Movement through application

#### 5. Error Handling Grammar
```typescript
describe('Error Handling', () => {
  it('should handle network errors gracefully', () => {
    cy.intercept('GET', '/api/data', { statusCode: 500 });
    
    page
      .visit()
      .shouldShowErrorMessage('Failed to load data')
      .clickRetry()
      .shouldRetryDataLoad();
  });
});
```

**Grammar Focus**: Failure scenario testing

#### 6. Responsive Behavior Grammar
```typescript
describe('Responsive Behavior', () => {
  ['iphone-x', 'ipad-2', [1920, 1080]].forEach(viewport => {
    it(`should be responsive on ${viewport}`, () => {})
  });
});
```

**Grammar Pattern**: Multi-viewport testing

#### 7. Accessibility Grammar
```typescript
describe('Accessibility', () => {
  it('should be accessible', () => {})
  it('should be keyboard navigable', () => {})
  it('should announce changes to screen readers', () => {})
});
```

**Grammar Focus**: Inclusive design validation

#### 8. Performance Grammar
```typescript
describe('Performance', () => {
  it('should load within acceptable time', () => {
    page
      .measureLoadTime()
      .shouldLoadWithin(3000);
  });
});
```

**Grammar Pattern**: Metric-based assertions

#### 9. Integration Grammar
```typescript
describe('Integration', () => {
  it('should integrate with third-party services', () => {})
  it('should sync data across tabs', () => {})
});
```

**Grammar Focus**: System interconnection

### Page Object Pattern
The template assumes a page object pattern:
```typescript
class {{PageName}}Page {
  visit() { return this; }
  fillForm(data) { return this; }
  submitForm() { return this; }
  shouldShowSuccessMessage(msg) { return this; }
}
```

**Grammar Benefits**:
- Fluent interface for readability
- Reusable action methods
- Chainable assertions

## 🔧 Utility Test Template - Pure Function Grammar

### Template Structure Overview (Lines 1-73)

```typescript
/**
 * @llm-test-utility
 * @test-coverage 95            // Higher coverage for utilities
 */
```

### Utility Testing Sections

#### 1. Basic Functionality Grammar
```typescript
describe('basic functionality', () => {
  it('should handle valid inputs correctly', () => {})
  it('should return expected output for common cases', () => {
    const testCases = [
      { input: 'case1', expected: 'output1' },
      { input: 'case2', expected: 'output2' },
    ];
    
    testCases.forEach(({ input, expected }) => {
      expect({{functionName}}(input)).toBe(expected);
    });
  });
});
```

**Grammar Pattern**: Input → Output mapping

#### 2. Edge Cases Grammar
```typescript
describe('edge cases', () => {
  it('should handle empty input', () => {})
  it('should handle null/undefined', () => {})
  it('should handle special characters', () => {})
  it('should handle very long input', () => {})
});
```

**Grammar Focus**: Boundary testing

#### 3. Error Handling Grammar
```typescript
describe('error handling', () => {
  it('should throw error for invalid input type', () => {
    expect(() => {{functionName}}(123 as any)).toThrow(TypeError);
  });
  it('should handle malformed input gracefully', () => {})
});
```

**Grammar Pattern**: Exception testing

#### 4. Performance Grammar
```typescript
describe('performance', () => {
  it('should handle large datasets efficiently', () => {
    const startTime = Date.now();
    
    for (let i = 0; i < 1000; i++) {
      {{functionName}}(`input${i}`);
    }
    
    const endTime = Date.now();
    expect(endTime - startTime).toBeLessThan(100);
  });
});
```

**Grammar Focus**: Efficiency validation

## 🎯 Template Usage Guidelines

### 1. Variable Replacement
Replace template variables with actual values:
- `{{ComponentName}}` → `UserCard`
- `{{functionName}}` → `formatDate`
- `{{PageName}}` → `Dashboard`
- `{{FeatureName}}` → `User Authentication`

### 2. Coverage Requirements
Each template specifies minimum coverage:
- **Components**: 80% (UI can be visually tested)
- **Hooks**: 90% (Critical state logic)
- **Utilities**: 95% (Pure functions)
- **E2E**: 100% happy paths

### 3. Test Organization
Follow the section order in templates:
1. Basic functionality first
2. Edge cases second
3. Error handling third
4. Performance last

### 4. Grammar Consistency
Always use:
- "should" for test names
- Present tense verbs
- Clear cause-effect descriptions
- Behavior-focused language

## 🔗 Integration with Grammar Ops

### These Templates Implement:
1. **Test-Driven Grammar** patterns from `/03-testing/test-driven-grammar/`
2. **Naming conventions** from `/02-grammar/naming-system/`
3. **Component architecture** from `/01-architecture/component-layers/`
4. **LLM directives** from `/01-architecture/metadata-system/`

### Templates Enable:
- **Consistent test structure** across entire codebase
- **Predictable test patterns** for AI generation
- **Complete coverage** of all code aspects
- **Living documentation** through executable tests

### Best Practices Demonstrated:
- Async/await patterns
- Accessibility testing
- Performance validation
- Error resilience
- Page object pattern
- Test data management

## 🎯 Revolutionary Impact

These templates transform testing by:

1. **Making tests grammatically consistent** - Same patterns everywhere
2. **Providing complete blueprints** - Copy, replace variables, done
3. **Enforcing best practices** - Built into template structure
4. **Enabling AI generation** - LLMs can create tests from templates
5. **Creating living documentation** - Tests describe behavior clearly

With these templates, testing becomes as systematic and predictable as the Grammar Ops naming system itself!