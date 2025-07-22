/**
 * Grammar-Ops Core Module
 * Entry point for the grammar-based development system
 */

export const GrammarOps = {
  version: '1.0.0',
  
  // Paths to key resources
  paths: {
    templates: './templates',
    configs: './config',
    docs: './docs',
    scripts: './scripts'
  },
  
  // Available templates
  templates: {
    component: './templates/tests/component.test.template.tsx',
    hook: './templates/tests/hook.test.template.ts',
    e2e: './templates/tests/e2e.test.template.ts'
  },
  
  // Configuration templates
  configs: {
    jest: './config/jest.config.template.js',
    jestSetup: './config/jest.setup.template.ts',
    cypress: './config/cypress.config.template.ts',
    cypressCommands: './config/cypress-commands.template.ts'
  },
  
  // Schema definitions
  schemas: {
    naming: './config/naming-grammar-schema.json',
    fullStack: './config/full-stack-grammar-schema.json'
  }
};

// Export utils for programmatic use
export { validateComponent } from './scripts/validate-component-styles.cjs';

export default GrammarOps;