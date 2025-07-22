/**
 * @fileoverview Cypress custom commands template
 * @module grammar-ops/config/cypress-commands.template
 */

/// <reference types="cypress" />

declare global {
  namespace Cypress {
    interface Chainable {
      /**
       * Custom command to login via API
       */
      login(email: string, password: string): Chainable<void>;
      
      /**
       * Custom command to seed test data
       */
      seedTestData(fixture: string): Chainable<void>;
      
      /**
       * Custom command to clear all test data
       */
      clearTestData(): Chainable<void>;
      
      /**
       * Custom command to wait for loading states
       */
      waitForLoading(): Chainable<void>;
      
      /**
       * Custom command to test accessibility
       */
      checkA11y(context?: string): Chainable<void>;
      
      /**
       * Custom command to upload files
       */
      uploadFile(fileName: string, selector: string): Chainable<void>;
      
      /**
       * Custom command to drag and drop
       */
      dragAndDrop(subject: string, target: string): Chainable<void>;
    }
  }
}

// Login command
Cypress.Commands.add('login', (email: string, password: string) => {
  cy.request('POST', '/api/auth/login', { email, password })
    .then((response) => {
      window.localStorage.setItem('auth-token', response.body.token);
      cy.visit('/');
    });
});

// Seed test data
Cypress.Commands.add('seedTestData', (fixture: string) => {
  cy.fixture(fixture).then((data) => {
    cy.task('seedDatabase', data);
  });
});

// Clear test data
Cypress.Commands.add('clearTestData', () => {
  cy.task('clearDatabase');
});

// Wait for loading states
Cypress.Commands.add('waitForLoading', () => {
  cy.get('[data-testid="loading"]').should('not.exist');
  cy.get('[data-testid="spinner"]').should('not.exist');
  cy.get('.loading').should('not.exist');
});

// Accessibility testing
Cypress.Commands.add('checkA11y', (context?: string) => {
  cy.injectAxe();
  cy.checkA11y(context);
});

// File upload
Cypress.Commands.add('uploadFile', (fileName: string, selector: string) => {
  cy.fixture(fileName, 'base64').then((fileContent) => {
    cy.get(selector).attachFile({
      fileContent: fileContent.toString(),
      fileName: fileName,
      encoding: 'base64',
    });
  });
});

// Drag and drop
Cypress.Commands.add('dragAndDrop', (subject: string, target: string) => {
  cy.get(subject)
    .trigger('dragstart', { dataTransfer: new DataTransfer() });
  
  cy.get(target)
    .trigger('drop', { dataTransfer: new DataTransfer() });
});

// Intercept commands for common API patterns
export const setupInterceptors = () => {
  // Auth endpoints
  cy.intercept('POST', '/api/auth/login', { fixture: 'auth/login.json' }).as('login');
  cy.intercept('POST', '/api/auth/logout', { statusCode: 200 }).as('logout');
  cy.intercept('GET', '/api/auth/user', { fixture: 'auth/user.json' }).as('getUser');
  
  // Content endpoints
  cy.intercept('GET', '/api/content', { fixture: 'content/list.json' }).as('getContent');
  cy.intercept('POST', '/api/content', { fixture: 'content/create.json' }).as('createContent');
  cy.intercept('PUT', '/api/content/*', { fixture: 'content/update.json' }).as('updateContent');
  cy.intercept('DELETE', '/api/content/*', { statusCode: 204 }).as('deleteContent');
};

export {};