/**
 * @fileoverview Cypress configuration template for E2E testing
 * @module grammar-ops/config/cypress.config.template
 */

import { defineConfig } from 'cypress';

export default defineConfig({
  e2e: {
    // Base URL for tests
    baseUrl: 'http://localhost:5173',
    
    // Viewport settings
    viewportWidth: 1280,
    viewportHeight: 720,
    
    // Video recording
    video: true,
    videoCompression: 32,
    videosFolder: 'cypress/videos',
    
    // Screenshots
    screenshotsFolder: 'cypress/screenshots',
    screenshotOnRunFailure: true,
    
    // Test isolation
    testIsolation: true,
    
    // Timeouts
    defaultCommandTimeout: 10000,
    requestTimeout: 10000,
    responseTimeout: 10000,
    pageLoadTimeout: 30000,
    
    // Retries
    retries: {
      runMode: 2,
      openMode: 0,
    },
    
    // Setup node events
    setupNodeEvents(on, config) {
      // Task for seeding test data
      on('task', {
        seedDatabase() {
          // Implementation for seeding test data
          return null;
        },
        clearDatabase() {
          // Implementation for clearing test data
          return null;
        },
      });
      
      // Code coverage
      require('@cypress/code-coverage/task')(on, config);
      
      return config;
    },
    
    // Environment variables
    env: {
      coverage: true,
      codeCoverage: {
        exclude: [
          'cypress/**/*.*',
          'src/test/**/*.*',
        ],
      },
    },
    
    // Spec patterns
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    
    // Support file
    supportFile: 'cypress/support/e2e.ts',
    
    // Experimental features
    experimentalStudio: true,
    experimentalWebKitSupport: true,
  },
  
  component: {
    devServer: {
      framework: 'react',
      bundler: 'vite',
    },
    specPattern: 'src/**/*.cy.{js,jsx,ts,tsx}',
    supportFile: 'cypress/support/component.ts',
  },
});