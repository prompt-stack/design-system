/**
 * @fileoverview E2E test template for Cypress
 * @module {{FeatureName}}.cy
 * @llm-test-e2e
 * @user-journey {{describe journey}}
 */

import { {{PageName}}Page } from '../pages/{{PageName}}.page';

describe('{{FeatureName}} E2E Tests', () => {
  let page: {{PageName}}Page;

  beforeEach(() => {
    // Initialize page object
    page = new {{PageName}}Page();
    
    // Clear test data
    cy.clearTestData();
    
    // Seed test data
    cy.seedTestData('{{feature-name}}/base-data');
    
    // Login if required
    cy.login('test@example.com', 'password');
    
    // Visit page
    page.visit();
  });

  afterEach(() => {
    // Cleanup
    cy.clearTestData();
  });

  describe('Page Load', () => {
    it('should load the page successfully', () => {
      page
        .shouldBeVisible()
        .shouldHaveTitle('{{Page Title}}')
        .shouldShowMainContent();
    });

    it('should display all required elements', () => {
      page
        .shouldShowHeader()
        .shouldShowNavigation()
        .shouldShowMainContent()
        .shouldShowFooter();
    });

    it('should load data correctly', () => {
      page
        .waitForDataLoad()
        .shouldDisplayItems(10)
        .shouldNotShowLoadingState();
    });
  });

  describe('User Interactions', () => {
    it('should handle form submission successfully', () => {
      page
        .fillForm({
          name: 'Test Name',
          email: 'test@example.com',
          message: 'Test message content'
        })
        .submitForm()
        .shouldShowSuccessMessage('Form submitted successfully');
    });

    it('should validate form inputs', () => {
      page
        .fillForm({
          name: '',
          email: 'invalid-email',
          message: ''
        })
        .submitForm()
        .shouldShowValidationError('Name is required')
        .shouldShowValidationError('Invalid email format')
        .shouldShowValidationError('Message is required');
    });

    it('should handle search functionality', () => {
      page
        .searchFor('test query')
        .shouldShowSearchResults()
        .shouldHighlightSearchTerms('test query');
    });

    it('should handle filtering and sorting', () => {
      page
        .filterBy('category', 'electronics')
        .sortBy('price', 'asc')
        .shouldShowFilteredResults()
        .shouldBeSortedBy('price', 'asc');
    });
  });

  describe('Navigation', () => {
    it('should navigate between pages', () => {
      page
        .clickNavLink('About')
        .shouldBeOnPage('/about')
        .clickNavLink('Home')
        .shouldBeOnPage('/');
    });

    it('should handle browser back/forward', () => {
      page
        .navigateTo('/page1')
        .navigateTo('/page2')
        .goBack()
        .shouldBeOnPage('/page1')
        .goForward()
        .shouldBeOnPage('/page2');
    });
  });

  describe('Error Handling', () => {
    it('should handle network errors gracefully', () => {
      cy.intercept('GET', '/api/data', { statusCode: 500 });
      
      page
        .visit()
        .shouldShowErrorMessage('Failed to load data')
        .clickRetry()
        .shouldRetryDataLoad();
    });

    it('should handle 404 errors', () => {
      page
        .visitInvalidUrl()
        .shouldShow404Page()
        .shouldHaveReturnHomeLink();
    });

    it('should handle session timeout', () => {
      cy.intercept('GET', '/api/auth/user', { statusCode: 401 });
      
      page
        .visit()
        .shouldRedirectToLogin()
        .shouldShowMessage('Session expired');
    });
  });

  describe('Responsive Behavior', () => {
    ['iphone-x', 'ipad-2', [1920, 1080]].forEach(viewport => {
      it(`should be responsive on ${viewport}`, () => {
        if (Array.isArray(viewport)) {
          cy.viewport(viewport[0], viewport[1]);
        } else {
          cy.viewport(viewport as Cypress.ViewportPreset);
        }
        
        page
          .visit()
          .shouldBeResponsive()
          .shouldHaveMobileMenu(viewport === 'iphone-x');
      });
    });
  });

  describe('Accessibility', () => {
    it('should be accessible', () => {
      page
        .visit()
        .checkAccessibility()
        .shouldHaveNoA11yViolations();
    });

    it('should be keyboard navigable', () => {
      page
        .visit()
        .tabToElement('first-interactive')
        .pressEnter()
        .shouldTriggerAction()
        .tabToElement('next-interactive')
        .pressSpace()
        .shouldTriggerAction();
    });

    it('should announce changes to screen readers', () => {
      page
        .triggerAction()
        .shouldAnnounce('Action completed successfully');
    });
  });

  describe('Performance', () => {
    it('should load within acceptable time', () => {
      page
        .measureLoadTime()
        .shouldLoadWithin(3000);
    });

    it('should handle large datasets efficiently', () => {
      cy.seedTestData('{{feature-name}}/large-dataset');
      
      page
        .visit()
        .shouldRenderLargeList()
        .shouldScrollSmoothly()
        .shouldNotHaveMemoryLeaks();
    });
  });

  describe('Integration', () => {
    it('should integrate with third-party services', () => {
      page
        .triggerThirdPartyAction()
        .shouldCallExternalAPI()
        .shouldHandleExternalResponse();
    });

    it('should sync data across tabs', () => {
      page
        .openInNewTab()
        .updateDataInTab1()
        .switchToTab2()
        .shouldSeeUpdatedData();
    });
  });
});