/**
 * @file design-system/scripts/validate-component-styles.cjs
 * @purpose Build/tool script: validate-component-styles
 * @module-type CommonJS
 * @layer tooling
 * @deps [fs, glob, path]
 * @llm-read true
 * @llm-write full-edit
 * @llm-role utility
 */

#!/usr/bin/env node

/**
 * Component-Style Validation Script
 * 
 * Ensures:
 * 1. Every component has a style companion (or explicitly marked as utilities-only)
 * 2. No orphan styles exist
 * 3. Dependencies follow the correct flow
 * 4. Metadata is complete
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Colors for terminal output
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m'
};

// Component paths
const COMPONENT_PATHS = {
  primitives: 'src/components',
  composed: 'src/components',
  features: 'src/features',
  layout: 'src/layout',
  pages: 'src/pages'
};

// Style paths
const STYLE_PATHS = {
  components: 'src/styles/components',
  features: 'src/styles/features',
  layout: 'src/styles/layout',
  pages: 'src/styles/pages'
};

// Extract metadata from component file
function extractMetadata(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const metadata = {};
  
  // Extract @layer
  const layerMatch = content.match(/@layer\s+(\w+)/);
  metadata.layer = layerMatch ? layerMatch[1] : null;
  
  // Extract @cssFile
  const cssMatch = content.match(/@cssFile\s+([^\n]+)/);
  metadata.cssFile = cssMatch ? cssMatch[1].trim() : null;
  
  // Extract @dependencies
  const depsMatch = content.match(/@dependencies\s+([^\n]+)/);
  metadata.dependencies = depsMatch ? depsMatch[1].trim() : null;
  
  // Extract @utilities
  const utilsMatch = content.match(/@utilities\s+([^\n]+)/);
  metadata.utilities = utilsMatch ? utilsMatch[1].trim() : null;
  
  // Extract @status
  const statusMatch = content.match(/@status\s+(\w+)/);
  metadata.status = statusMatch ? statusMatch[1] : null;
  
  // Extract @since
  const sinceMatch = content.match(/@since\s+([^\n]+)/);
  metadata.since = sinceMatch ? sinceMatch[1].trim() : null;
  
  // Extract @a11y
  const a11yMatch = content.match(/@a11y\s+([^\n]+)/);
  metadata.a11y = a11yMatch ? a11yMatch[1].trim() : null;
  
  // Extract @performance
  const perfMatch = content.match(/@performance\s+([^\n]+)/);
  metadata.performance = perfMatch ? perfMatch[1].trim() : null;
  
  return metadata;
}

// Validate a single component
function validateComponent(componentPath) {
  const componentName = path.basename(componentPath, '.tsx');
  const metadata = extractMetadata(componentPath);
  const errors = [];
  
  // Check if metadata exists
  if (!metadata.layer) {
    errors.push(`Missing @layer metadata`);
  }
  
  // Check CSS file
  if (metadata.cssFile && metadata.cssFile !== 'none') {
    const cssPath = metadata.cssFile.replace(/^\//, '');
    const fullCssPath = path.join(process.cwd(), cssPath);
    
    if (!fs.existsSync(fullCssPath)) {
      errors.push(`CSS file not found: ${metadata.cssFile}`);
    }
  } else if (!metadata.cssFile) {
    errors.push(`Missing @cssFile metadata`);
  }
  
  // Check dependencies based on layer
  if (metadata.layer === 'primitive' && metadata.dependencies && 
      metadata.dependencies !== 'None' && metadata.dependencies !== 'none') {
    errors.push(`Primitives should not have component dependencies`);
  }
  
  // Check required fields for stable components
  if (metadata.status === 'stable') {
    if (!metadata.since) {
      errors.push(`Stable components must have @since date`);
    }
    if (!metadata.a11y && metadata.layer !== 'layout') {
      errors.push(`Stable components should document @a11y requirements`);
    }
  }
  
  // Warn about missing status
  if (!metadata.status) {
    errors.push(`Missing @status (stable/experimental/deprecated)`);
  }
  
  return {
    name: componentName,
    path: componentPath,
    metadata,
    errors
  };
}

// Find orphan styles
function findOrphanStyles() {
  const orphans = [];
  const allStyles = glob.sync('src/styles/**/*.css');
  const componentStyles = new Set();
  
  // Collect all referenced CSS files
  const allComponents = [
    ...glob.sync('src/components/*.tsx'),
    ...glob.sync('src/layout/*.tsx'),
    ...glob.sync('src/features/**/*.tsx'),
    ...glob.sync('src/pages/*.tsx')
  ];
  
  allComponents.forEach(comp => {
    const metadata = extractMetadata(comp);
    if (metadata.cssFile && metadata.cssFile !== 'none') {
      const normalizedPath = metadata.cssFile.replace(/^\/styles\//, '');
      componentStyles.add(normalizedPath);
    }
  });
  
  // Check each style file
  allStyles.forEach(stylePath => {
    const relativePath = path.relative('src/styles', stylePath);
    
    // Skip base styles and utilities
    if (relativePath.startsWith('base/') || 
        relativePath.startsWith('utils/') ||
        relativePath === 'globals.css') {
      return;
    }
    
    if (!componentStyles.has(relativePath)) {
      orphans.push(stylePath);
    }
  });
  
  return orphans;
}

// Generate component registry
function generateRegistry() {
  const registry = {
    primitives: {},
    composed: {},
    features: {},
    layout: {},
    pages: {}
  };
  
  const allComponents = glob.sync('src/components/*.tsx');
  
  allComponents.forEach(componentPath => {
    const result = validateComponent(componentPath);
    const layer = result.metadata.layer;
    
    if (layer && registry[layer + 's']) {
      registry[layer + 's'][result.name] = {
        file: path.basename(componentPath),
        css: result.metadata.cssFile,
        dependencies: result.metadata.dependencies,
        utilities: result.metadata.utilities
      };
    }
  });
  
  return registry;
}

// Main validation
function main() {
  console.log(`${colors.blue}🔍 Validating Component-Style Contract...${colors.reset}\n`);
  
  let hasErrors = false;
  
  // Validate all components
  const components = glob.sync('src/components/*.tsx');
  const results = components.map(validateComponent);
  
  // Report component errors
  results.forEach(result => {
    if (result.errors.length > 0) {
      hasErrors = true;
      console.log(`${colors.red}❌ ${result.name}${colors.reset}`);
      result.errors.forEach(error => {
        console.log(`   ${error}`);
      });
    } else {
      console.log(`${colors.green}✅ ${result.name}${colors.reset}`);
    }
  });
  
  // Check for orphan styles
  console.log(`\n${colors.blue}🔍 Checking for orphan styles...${colors.reset}`);
  const orphans = findOrphanStyles();
  
  if (orphans.length > 0) {
    hasErrors = true;
    console.log(`${colors.red}❌ Found ${orphans.length} orphan style files:${colors.reset}`);
    orphans.forEach(orphan => {
      console.log(`   ${orphan}`);
    });
  } else {
    console.log(`${colors.green}✅ No orphan styles found${colors.reset}`);
  }
  
  // Generate registry
  console.log(`\n${colors.blue}📝 Generating component registry...${colors.reset}`);
  const registry = generateRegistry();
  fs.writeFileSync(
    'component-registry.json',
    JSON.stringify(registry, null, 2)
  );
  console.log(`${colors.green}✅ Registry saved to component-registry.json${colors.reset}`);
  
  // Summary
  console.log(`\n${colors.blue}📊 Summary:${colors.reset}`);
  console.log(`   Components validated: ${results.length}`);
  console.log(`   Errors found: ${results.filter(r => r.errors.length > 0).length}`);
  console.log(`   Orphan styles: ${orphans.length}`);
  
  if (hasErrors) {
    console.log(`\n${colors.red}❌ Validation failed! Fix the errors above.${colors.reset}`);
    process.exit(1);
  } else {
    console.log(`\n${colors.green}✅ All validations passed!${colors.reset}`);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { validateComponent, findOrphanStyles, generateRegistry };
