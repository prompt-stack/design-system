/**
 * @fileoverview Jest configuration template for LLM-assisted development
 * @module grammar-ops/config/jest.config.template
 * 
 * This template provides a standardized Jest configuration that ensures
 * consistent testing patterns across projects using the grammar-ops system.
 */

module.exports = {
  // Test environment
  testEnvironment: 'jsdom',
  
  // Setup files
  setupFilesAfterEnv: ['<rootDir>/src/test/jest.setup.ts'],
  
  // Module name mapping for TypeScript paths
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
    '^@components/(.*)$': '<rootDir>/src/components/$1',
    '^@hooks/(.*)$': '<rootDir>/src/hooks/$1',
    '^@services/(.*)$': '<rootDir>/src/services/$1',
    '^@utils/(.*)$': '<rootDir>/src/utils/$1',
    '^@types/(.*)$': '<rootDir>/src/types/$1',
    // CSS modules
    '\\.(css|less|scss|sass)$': 'identity-obj-proxy',
    // Static assets
    '\\.(jpg|jpeg|png|gif|svg|webp)$': '<rootDir>/src/test/__mocks__/fileMock.js'
  },
  
  // Transform files
  transform: {
    '^.+\\.(ts|tsx|js|jsx)$': 'ts-jest'
  },
  
  // File extensions
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
  
  // Coverage configuration
  coverageDirectory: '<rootDir>/coverage',
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.tsx',
    '!src/test/**/*',
    '!src/main.tsx',
    '!src/vite-env.d.ts'
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 80,
      statements: 80
    }
  },
  
  // Test match patterns
  testMatch: [
    '<rootDir>/src/**/__tests__/**/*.{ts,tsx}',
    '<rootDir>/src/**/*.{test,spec}.{ts,tsx}'
  ],
  
  // Ignore patterns
  testPathIgnorePatterns: [
    '/node_modules/',
    '/dist/',
    '/coverage/',
    '/.next/'
  ],
  
  // Globals
  globals: {
    'ts-jest': {
      tsconfig: {
        jsx: 'react-jsx'
      }
    }
  }
};