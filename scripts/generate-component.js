#!/usr/bin/env node

/**
 * Component Generator Script
 * Usage: node generate-component.js <ComponentName> <layer>
 * Example: node generate-component.js DataTable composed
 */

const fs = require('fs');
const path = require('path');

const [,, componentName, layer] = process.argv;

if (!componentName || !layer) {
  console.error('Usage: node generate-component.js <ComponentName> <layer>');
  console.error('Layers: primitive, composed, feature');
  process.exit(1);
}

const validLayers = ['primitive', 'composed', 'feature'];
if (!validLayers.includes(layer)) {
  console.error(`Invalid layer. Must be one of: ${validLayers.join(', ')}`);
  process.exit(1);
}

// Convert to kebab-case for files
const kebabCase = componentName
  .replace(/([A-Z])/g, '-$1')
  .toLowerCase()
  .replace(/^-/, '');

// Templates for each layer
const templates = {
  primitive: `/**
 * @layer primitive
 * @description ${componentName} component - describe purpose here
 * @dependencies None (primitive component)
 * @cssFile /styles/components/${kebabCase}.css
 * @className .${kebabCase}
 * @variants ["default"]
 * @status experimental
 * @since ${new Date().toISOString().split('T')[0]}
 * @a11y Add accessibility requirements
 * 
 * This is a PRIMITIVE component with zero dependencies on other custom components.
 */

import { forwardRef } from 'react';
import clsx from 'clsx';
import type { HTMLAttributes } from 'react';

interface ${componentName}Props extends HTMLAttributes<HTMLDivElement> {
  variant?: 'default';
}

export const ${componentName} = forwardRef<HTMLDivElement, ${componentName}Props>(
  ({ variant = 'default', className, children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={clsx(
          '${kebabCase}',
          variant !== 'default' && \`${kebabCase}--\${variant}\`,
          className
        )}
        {...props}
      >
        {children}
      </div>
    );
  }
);

${componentName}.displayName = '${componentName}';`,

  composed: `/**
 * @layer composed
 * @description ${componentName} component - describe purpose here
 * @dependencies Box, Text (update with actual primitives used)
 * @cssFile /styles/components/${kebabCase}.css
 * @utilities spacing, shadow (via Box)
 * @variants ["default"]
 * @className .${kebabCase}
 * @status experimental
 * @since ${new Date().toISOString().split('T')[0]}
 * @a11y Add accessibility requirements
 * 
 * This is a COMPOSED component built from primitive components.
 */

import { forwardRef } from 'react';
import clsx from 'clsx';
import type { ReactNode } from 'react';
import { Box } from './Box';
import type { BoxProps } from './Box';

interface ${componentName}Props extends Omit<BoxProps, 'className'> {
  children: ReactNode;
  variant?: 'default';
  className?: string;
}

export const ${componentName} = forwardRef<HTMLDivElement, ${componentName}Props>(
  ({ 
    variant = 'default', 
    className,
    children,
    // Default utility props
    padding = '3',
    ...boxProps 
  }, ref) => {
    return (
      <Box
        ref={ref}
        className={clsx(
          '${kebabCase}',
          variant !== 'default' && \`${kebabCase}--\${variant}\`,
          className
        )}
        padding={padding}
        {...boxProps}
      >
        {children}
      </Box>
    );
  }
);

${componentName}.displayName = '${componentName}';`,

  feature: `/**
 * @layer feature
 * @description ${componentName} component - describe purpose here
 * @dependencies Card, Button, Text (update with actual dependencies)
 * @cssFile /styles/features/${kebabCase}.css
 * @className .${kebabCase}
 * @status experimental
 * @since ${new Date().toISOString().split('T')[0]}
 * @a11y Add accessibility requirements
 * @performance Add performance considerations
 * 
 * This is a FEATURE component that implements business logic.
 */

import { useState } from 'react';
import { Card } from '@/components/Card';
import { Button } from '@/components/Button';
import { Text } from '@/components/Text';

interface ${componentName}Props {
  // Add props
}

export function ${componentName}({ ...props }: ${componentName}Props) {
  const [state, setState] = useState();

  return (
    <div className="${kebabCase}">
      <Card>
        <Text>Implement ${componentName}</Text>
      </Card>
    </div>
  );
}`
};

// CSS template
const cssTemplate = `/* ==========================================================================
   ${componentName} Component (@layer ${layer})
   Dependencies: ${layer === 'primitive' ? 'None' : 'List dependencies here'}
   Used by: Will be updated as component is used
   ========================================================================== */

.${kebabCase} {
  /* Base styles */
}

/* Variants
   ========================================================================== */
.${kebabCase}--default {
  /* Default variant */
}

/* States
   ========================================================================== */
.${kebabCase}.is-active {
  /* Active state */
}

/* Elements (if composed/feature)
   ========================================================================== */
.${kebabCase}__header {
  /* Header element */
}

.${kebabCase}__body {
  /* Body element */
}`;

// Determine paths based on layer
const componentDir = layer === 'feature' ? 'src/features' : 'src/components';
const styleDir = layer === 'feature' ? 'src/styles/features' : 'src/styles/components';

// Create component file
const componentPath = path.join(process.cwd(), componentDir, `${componentName}.tsx`);
const stylePath = path.join(process.cwd(), styleDir, `${kebabCase}.css`);

// Check if files already exist
if (fs.existsSync(componentPath)) {
  console.error(`Component already exists: ${componentPath}`);
  process.exit(1);
}

if (fs.existsSync(stylePath)) {
  console.error(`Style file already exists: ${stylePath}`);
  process.exit(1);
}

// Write files
fs.writeFileSync(componentPath, templates[layer]);
fs.writeFileSync(stylePath, cssTemplate);

console.log(`✅ Created ${layer} component: ${componentName}`);
console.log(`   Component: ${componentPath}`);
console.log(`   Styles: ${stylePath}`);
console.log(`\n📝 Next steps:`);
console.log(`   1. Update component dependencies in metadata`);
console.log(`   2. Implement component logic`);
console.log(`   3. Add to appropriate index.ts export`);
console.log(`   4. Run validation: node scripts/validate-component-styles.js`);