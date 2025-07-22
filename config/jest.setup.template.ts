/**
 * @fileoverview Jest setup template for consistent test environment
 * @module grammar-ops/config/jest.setup.template
 */

import '@testing-library/jest-dom';
import { configure } from '@testing-library/react';
import 'jest-canvas-mock';

// Configure testing library
configure({
  testIdAttribute: 'data-testid',
});

// Global test utilities
global.mockConsole = () => {
  const originalConsole = { ...console };
  beforeAll(() => {
    console.log = jest.fn();
    console.error = jest.fn();
    console.warn = jest.fn();
  });
  afterAll(() => {
    console.log = originalConsole.log;
    console.error = originalConsole.error;
    console.warn = originalConsole.warn;
  });
};

// Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});

// Mock IntersectionObserver
global.IntersectionObserver = class IntersectionObserver {
  constructor() {}
  disconnect() {}
  observe() {}
  unobserve() {}
};

// Mock ResizeObserver
global.ResizeObserver = class ResizeObserver {
  constructor(callback: ResizeObserverCallback) {}
  disconnect() {}
  observe() {}
  unobserve() {}
};

// Custom matchers
expect.extend({
  toBeValidEmail(received: string) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const pass = emailRegex.test(received);
    return {
      pass,
      message: () =>
        pass
          ? `expected ${received} not to be a valid email`
          : `expected ${received} to be a valid email`,
    };
  },
  
  toBeWithinRange(received: number, floor: number, ceiling: number) {
    const pass = received >= floor && received <= ceiling;
    return {
      pass,
      message: () =>
        pass
          ? `expected ${received} not to be within range ${floor} - ${ceiling}`
          : `expected ${received} to be within range ${floor} - ${ceiling}`,
    };
  },
});