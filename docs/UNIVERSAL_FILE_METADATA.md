# Universal File Metadata Standard

## The 20-Line Navigation Principle

Every file in the codebase should have metadata in the first 20 lines that tells an LLM:
1. **What this file is**
2. **What it depends on**
3. **What depends on it**
4. **Where to find related files**

This enables scanning 50+ files for < 1000 tokens!

## Universal Metadata Format

### For TypeScript/JavaScript Files
```typescript
/**
 * @file components/Button
 * @purpose Clickable action element with variants
 * @layer primitive
 * @deps none
 * @used-by [Card, Modal, Form, ContentInbox]
 * @css /src/styles/components/button.css
 * @tests /src/components/__tests__/Button.test.tsx
 * @docs /docs/components/button.md
 * @llm-read true
 * @llm-write full-edit
 * @llm-role utility
 */
```

### For CSS Files
```css
/**
 * @file styles/components/button
 * @purpose Button component styles
 * @component /src/components/Button.tsx
 * @deps [globals.css, variables.css]
 * @variants [primary, secondary, danger]
 * @states [hover, active, disabled, loading]
 */
```

### For Route/Page Files
```typescript
/**
 * @file pages/InboxPage
 * @purpose Content inbox management interface
 * @route /inbox
 * @features [ContentInbox, QueueManager]
 * @api [/api/content-inbox/items]
 * @css /src/styles/pages/inbox.css
 * @llm-read true
 * @llm-write suggest-only
 * @llm-role entrypoint
 */
```

### For API/Service Files
```typescript
/**
 * @file services/ContentInboxService
 * @purpose Handle content processing and storage
 * @endpoints [GET /items, POST /process, DELETE /items/:id]
 * @db-models [ContentItem, ProcessingQueue]
 * @used-by [ContentInboxFeature, InboxPage]
 * @llm-read true
 * @llm-write read-only
 * @llm-role async-service
 */
```

### For Hook Files
```typescript
/**
 * @file hooks/useContentQueue
 * @purpose Manage content queue state and operations
 * @returns {items, addItem, removeItem, processItem}
 * @deps [useState, useCallback, ContentInboxApi]
 * @used-by [ContentInboxFeature, QueuePanel]
 * @llm-read true
 * @llm-write full-edit
 * @llm-role utility
 */
```

## LLM Directives

### @llm-read
Controls whether LLMs should read this file:
- `true` - Normal files LLMs should process
- `false` - Skip (e.g., generated files, vendor code, large data files)

### @llm-write
Defines the level of modification allowed:
- `full-edit` - Components, utilities, features (normal development files)
- `suggest-only` - Critical paths, entry points, configuration
- `read-only` - APIs, database models, security-sensitive code

### @llm-role
Architectural purpose that guides LLM behavior:
- `utility` - Helper functions, components, hooks
- `entrypoint` - Pages, routes, main application files
- `pure-view` - Display-only components with no side effects
- `async-service` - API calls, data fetching, external integrations

## Examples by File Type

### Configuration Files
```typescript
/**
 * @file config/database
 * @purpose Database connection settings
 * @llm-read true
 * @llm-write read-only
 * @llm-role entrypoint
 */
```

### Generated Files
```typescript
/**
 * @file types/api-generated
 * @purpose Auto-generated API types
 * @llm-read false
 * @llm-write read-only
 * @generated true
 */
```

### Critical Security Files
```typescript
/**
 * @file auth/TokenValidator
 * @purpose JWT token validation
 * @llm-read true
 * @llm-write suggest-only
 * @llm-role async-service
 * @security-critical true
 */
```

## The Power of This Approach

### 1. Instant Navigation
```typescript
// LLM can scan 50 files in one shot:
const fileMap = files.map(f => ({
  path: f.path,
  metadata: extractFirst20Lines(f)
}));

// "Find all files that use the Button component"
// "Show me what depends on ContentInboxService"
// "What CSS files are needed for InboxPage"
```

### 2. Dependency Graphs
```
Button.tsx
  ├── used-by: [Card, Modal, Form]
  ├── css: button.css
  └── tests: Button.test.tsx

ContentInbox
  ├── deps: [Card, Button, VirtualList]
  ├── api: ContentInboxService
  └── used-by: [InboxPage]
```

### 3. Impact Analysis
Before changing a file, LLM instantly knows:
- What will break
- What tests to run
- What documentation to update

## Implementation Strategy

### Phase 1: Core Files
Start with the most connected files:
```bash
# Find most imported files
grep -r "import.*from" src/ | cut -d"'" -f2 | sort | uniq -c | sort -nr
```

### Phase 2: Automated Addition
```javascript
// Script to add metadata based on imports
function generateMetadata(filePath) {
  const deps = extractImports(filePath);
  const usedBy = findUsages(filePath);
  return formatMetadata({ deps, usedBy });
}
```

### Phase 3: Validation
```bash
# Ensure all files have metadata
find src -name "*.tsx" -o -name "*.ts" | while read f; do
  if ! head -20 "$f" | grep -q "@file"; then
    echo "Missing metadata: $f"
  fi
done
```

## Token Economics

### Traditional Approach
- Read entire Button.tsx: ~300 tokens
- Read entire Card.tsx: ~500 tokens  
- Read entire Modal.tsx: ~800 tokens
- **Total: 1,600 tokens for 3 files**

### Metadata-First Approach
- Read 20 lines × 50 files: ~1,000 tokens
- **Get overview of entire codebase!**

## Real Example

```typescript
/**
 * @file features/content-inbox/ContentInboxFeature
 * @purpose Main content processing and queue management
 * @layer feature
 * @deps [Card, Button, VirtualList, useContentQueue, ContentInboxApi]
 * @used-by [InboxPage, DashboardWidget]
 * @subcomponents [InputPanel, QueuePanel, TagEditor]
 * @css /src/styles/features/content-inbox.css
 * @api POST /api/content-inbox/process
 * @state [queue[], filters{}, modalState{}]
 * @perf Virtual scroll for 1000+ items
 */

import React, { useState, useCallback } from 'react';
// ... rest of component
```

With this, an LLM can:
1. Know exactly what this file does
2. Find all dependencies without parsing imports
3. Understand performance considerations
4. Navigate to related files
5. Know what API endpoints it uses

All in ~150 tokens instead of reading 1000+ lines!

## LLM Directives Implementation Plan

### Phase 1: Define Rules
Create a decision matrix for each directive:

```javascript
// LLM Write Permissions
const writePermissions = {
  'full-edit': [
    'src/components/**/*.tsx',
    'src/features/**/*.tsx',
    'src/hooks/**/*.ts',
    'src/utils/**/*.ts'
  ],
  'suggest-only': [
    'src/pages/**/*.tsx',
    'src/App.tsx',
    '**/*.config.js',
    '**/package.json'
  ],
  'read-only': [
    'src/api/**/*.ts',
    'src/services/**/*.ts',
    'src/auth/**/*.ts',
    '**/*.generated.ts'
  ]
};

// LLM Roles
const rolePatterns = {
  'utility': ['components/', 'hooks/', 'utils/'],
  'entrypoint': ['pages/', 'App.tsx', 'main.tsx'],
  'pure-view': ['*Display.tsx', '*View.tsx', '*List.tsx'],
  'async-service': ['api/', 'services/', '*Service.ts']
};
```

### Phase 2: Automated Script
```bash
#!/bin/bash
# add-llm-directives.sh

determine_write_permission() {
  local file=$1
  if [[ $file =~ (api/|services/|auth/|\.generated\.) ]]; then
    echo "read-only"
  elif [[ $file =~ (pages/|App\.tsx|config|package\.json) ]]; then
    echo "suggest-only"
  else
    echo "full-edit"
  fi
}

determine_role() {
  local file=$1
  if [[ $file =~ (api/|services/|Service\.ts) ]]; then
    echo "async-service"
  elif [[ $file =~ (pages/|App\.tsx|main\.tsx) ]]; then
    echo "entrypoint"
  elif [[ $file =~ (Display|View|List)\.tsx$ ]]; then
    echo "pure-view"
  else
    echo "utility"
  fi
}
```

### Phase 3: Integration with Tools

1. **Pre-edit Check**:
```typescript
function canEditFile(metadata: FileMetadata): boolean {
  return metadata['@llm-write'] === 'full-edit';
}
```

2. **Smart File Discovery**:
```typescript
// Skip files marked as @llm-read false
const readableFiles = files.filter(f => 
  f.metadata['@llm-read'] !== 'false'
);
```

3. **Context-Aware Suggestions**:
```typescript
// Warn when editing sensitive files
if (metadata['@llm-write'] === 'suggest-only') {
  console.warn('This file requires careful review');
}
```

### Benefits in Practice

1. **Faster Onboarding**: New LLMs instantly understand codebase boundaries
2. **Safer Operations**: Prevents accidental edits to critical files
3. **Smarter Navigation**: Skip generated files, focus on source code
4. **Role-Based Context**: Different behavior for utils vs services

This creates a **permission-aware, architecturally-intelligent** LLM navigation system!