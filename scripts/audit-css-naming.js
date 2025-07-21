#!/usr/bin/env node

/**
 * CSS Naming Convention Audit Script
 * Checks all CSS files for BEM compliance and naming violations
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Color codes for terminal output
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  reset: '\x1b[0m'
};

// CSS file categories and their rules
const fileRules = {
  'components': {
    path: 'src/styles/components/',
    rules: {
      allowedPatterns: [
        /^\.[a-z]+(-[a-z]+)*$/,                    // .component-name
        /^\.[a-z]+(-[a-z]+)*--[a-z]+(-[a-z]+)*$/,  // .component-name--modifier
        /^\.[a-z]+(-[a-z]+)*__[a-z]+(-[a-z]+)*$/,  // .component-name__element
        /^\.is-[a-z]+(-[a-z]+)*$/,                 // .is-state
        /^\.has-[a-z]+(-[a-z]+)*$/                 // .has-feature
      ],
      bannedPrefixes: ['page-', 'app-']
    }
  },
  'pages': {
    path: 'src/styles/pages/',
    rules: {
      requirePrefix: true,
      allowedPatterns: [
        /^\.[a-z]+__[a-z-]+$/,                     // .page__element
        /^\.[a-z]+__[a-z-]+--[a-z-]+$/            // .page__element--modifier
      ]
    }
  },
  'features': {
    path: 'src/styles/features/',
    rules: {
      requirePrefix: true,
      allowedPatterns: [
        /^\.[a-z-]+__[a-z-]+$/,                    // .feature-name__element
        /^\.[a-z-]+__[a-z-]+--[a-z-]+$/           // .feature-name__element--modifier
      ]
    }
  },
  'layout': {
    path: 'src/styles/layout/',
    rules: {
      allowedPatterns: [
        /^\.[a-z]+(-[a-z]+)*$/,                    // .layout-component
        /^\.[a-z]+(-[a-z]+)*__[a-z]+(-[a-z]+)*$/,  // .layout-component__element
        /^\.[a-z]+(-[a-z]+)*--[a-z]+(-[a-z]+)*$/   // .layout-component--modifier
      ]
    }
  },
  'utils': {
    path: 'src/styles/utils/',
    rules: {
      allowedPatterns: [
        /^\.[a-z]+-[a-z0-9]+$/,                    // .property-value
        /^\.[a-z]+(-[a-z]+)*$/,                    // .utility-name
        /^\.m[tlrbxy]?-[0-9]+$/,                  // .m-1, .mt-2, etc.
        /^\.p[tlrbxy]?-[0-9]+$/,                  // .p-1, .pt-2, etc.
        /^\.[a-z]+(-[a-z]+)*:hover$/              // .utility:hover
      ],
      bannedPatterns: [
        /^\.card/,
        /^\.btn/,
        /^\.modal/,
        /^\.form(?!-group$)/
      ]
    }
  }
};

// Extract CSS class names from content
function extractClassNames(content) {
  const classRegex = /^\s*\.([\w-]+(?::[a-z-]+)?(?:\s*\.\w+)*)/gm;
  const classes = [];
  let match;
  
  while ((match = classRegex.exec(content)) !== null) {
    // Skip pseudo-selectors and combined selectors for now
    if (!match[1].includes(':') && !match[0].includes(',')) {
      classes.push('.' + match[1]);
    }
  }
  
  return [...new Set(classes)];
}

// Check if class name matches any allowed pattern
function isValidClassName(className, rules, fileName) {
  // Check for required prefix in page/feature files
  if (rules.requirePrefix) {
    const prefix = path.basename(fileName, '.css');
    const expectedPrefix = '.' + prefix + '__';
    if (!className.startsWith(expectedPrefix)) {
      return { valid: false, reason: `Missing required prefix "${prefix}__"` };
    }
  }
  
  // Check allowed patterns
  for (const pattern of rules.allowedPatterns) {
    if (pattern.test(className)) {
      return { valid: true };
    }
  }
  
  // Check banned patterns (for utils)
  if (rules.bannedPatterns) {
    for (const pattern of rules.bannedPatterns) {
      if (pattern.test(className)) {
        return { valid: false, reason: 'Contains component implementation (should be in components/)' };
      }
    }
  }
  
  // Check banned prefixes
  if (rules.bannedPrefixes) {
    for (const prefix of rules.bannedPrefixes) {
      if (className.startsWith('.' + prefix)) {
        return { valid: false, reason: `Uses banned prefix "${prefix}"` };
      }
    }
  }
  
  return { valid: false, reason: 'Does not match BEM naming convention' };
}

// Audit a single CSS file
function auditFile(filePath, rules) {
  const content = fs.readFileSync(filePath, 'utf8');
  const classes = extractClassNames(content);
  const violations = [];
  
  classes.forEach(className => {
    // Skip keyframes, CSS variables, and other special cases
    if (className.startsWith('.--') || className.includes('@')) {
      return;
    }
    
    const result = isValidClassName(className, rules, path.basename(filePath));
    if (!result.valid) {
      // Find line number
      const lines = content.split('\n');
      let lineNumber = 0;
      for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes(className)) {
          lineNumber = i + 1;
          break;
        }
      }
      
      violations.push({
        className,
        reason: result.reason,
        line: lineNumber
      });
    }
  });
  
  return violations;
}

// Main audit function
async function auditCSS() {
  console.log(`${colors.blue}CSS Naming Convention Audit${colors.reset}\n`);
  
  let totalFiles = 0;
  let filesWithViolations = 0;
  let totalViolations = 0;
  
  for (const [category, config] of Object.entries(fileRules)) {
    const pattern = path.join(config.path, '*.css');
    const files = glob.sync(pattern);
    
    if (files.length === 0) {
      console.log(`${colors.yellow}No files found in ${category}${colors.reset}`);
      continue;
    }
    
    console.log(`\n${colors.magenta}=== ${category.toUpperCase()} ===${colors.reset}`);
    
    files.forEach(file => {
      totalFiles++;
      const relativePath = path.relative(process.cwd(), file);
      const violations = auditFile(file, config.rules);
      
      if (violations.length === 0) {
        console.log(`${colors.green}✓${colors.reset} ${relativePath}`);
      } else {
        filesWithViolations++;
        totalViolations += violations.length;
        console.log(`${colors.red}✗${colors.reset} ${relativePath} (${violations.length} violations)`);
        
        violations.forEach(v => {
          console.log(`  Line ${v.line}: ${v.className} - ${v.reason}`);
        });
      }
    });
  }
  
  // Summary
  console.log(`\n${colors.blue}=== SUMMARY ===${colors.reset}`);
  console.log(`Total files audited: ${totalFiles}`);
  console.log(`Files with violations: ${filesWithViolations}`);
  console.log(`Total violations: ${totalViolations}`);
  
  if (totalViolations === 0) {
    console.log(`\n${colors.green}✨ All CSS files follow naming conventions!${colors.reset}`);
  } else {
    console.log(`\n${colors.red}❌ Found ${totalViolations} naming violations that need fixing${colors.reset}`);
    process.exit(1);
  }
}

// Check for specific patterns that might need attention
function findPatterns() {
  console.log(`\n${colors.blue}=== PATTERN ANALYSIS ===${colors.reset}`);
  
  const patterns = {
    'Legacy classes': /\.(cosmic-|inbox-cosmic|url-input-|pricing-|faq-|money-back)/,
    'Generic names': /\.(container|wrapper|content|header|footer|title|section)(?!__)/,
    'Hyphenated elements': /\.[a-z]+-[a-z]+-[a-z]+__/,
    'Double underscores': /\.__.*__/,
    'Mixed conventions': /\.[a-z]+_[a-z]+/
  };
  
  Object.entries(fileRules).forEach(([category, config]) => {
    const files = glob.sync(path.join(config.path, '*.css'));
    
    files.forEach(file => {
      const content = fs.readFileSync(file, 'utf8');
      const relativePath = path.relative(process.cwd(), file);
      
      Object.entries(patterns).forEach(([patternName, regex]) => {
        if (regex.test(content)) {
          console.log(`${colors.yellow}⚠${colors.reset}  ${patternName} found in ${relativePath}`);
        }
      });
    });
  });
}

// Run the audit
auditCSS().then(() => {
  findPatterns();
}).catch(err => {
  console.error(`${colors.red}Error:${colors.reset}`, err);
  process.exit(1);
});