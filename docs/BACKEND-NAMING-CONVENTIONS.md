# Backend Naming Conventions

## Overview
This document defines naming conventions for backend services, APIs, and data structures to ensure consistency across the Content Stack ecosystem.

## Core Principles
1. **Clarity over brevity** - Names should be self-documenting
2. **Consistency across layers** - Frontend to backend alignment
3. **Domain-driven naming** - Reflect business concepts
4. **Avoid abbreviations** - Use full words (except common ones like API, URL)

## Service Naming

### File Structure
```
/backend
  /services
    ContentInboxService.ts    # PascalCase for service files
    MetadataService.ts
  /routes
    contentInbox.ts          # camelCase for route files
    metadata.ts
  /utils
    generateContentId.ts     # camelCase, verb-first
    detectContentType.ts
  /types
    ContentTypes.ts          # PascalCase for type definitions
```

### Service Classes
```typescript
// Services use PascalCase with "Service" suffix
export class ContentInboxService { }
export class MetadataService { }
export class ProcessingService { }
```

### API Endpoints
```
POST   /api/content-inbox/items          # kebab-case, plural for collections
GET    /api/content-inbox/items/:id      # singular for specific resource
PUT    /api/content-inbox/items/:id
DELETE /api/content-inbox/items/:id

POST   /api/content-inbox/process        # verb for actions
POST   /api/content-inbox/bulk-import    # kebab-case for multi-word
```

## Data Structures

### Type Definitions
```typescript
// Types use PascalCase
export interface ContentItem {
  contentId: string;      // camelCase for properties
  sourceUrl: string;
  contentType: ContentType;
  metadata: ContentMetadata;
}

// Enums use PascalCase
export enum ContentType {
  Article = 'article',
  Video = 'video',
  Image = 'image'
}

// Type unions for states
export type ProcessingStatus = 
  | 'pending'
  | 'processing' 
  | 'completed'
  | 'failed';
```

### Database/Storage
```javascript
// Collection/table names: plural, snake_case
content_items
metadata_entries
processing_queue

// Field names: snake_case
{
  content_id: 'string',
  source_url: 'string',
  created_at: 'timestamp',
  updated_at: 'timestamp'
}
```

## Function Naming

### Utility Functions
```typescript
// Verb-first, descriptive
export function generateContentId(): string { }
export function validateContentType(type: string): boolean { }
export function extractMetadata(content: Buffer): Metadata { }

// Async functions can use "fetch", "load", "save" prefixes
export async function fetchContentFromUrl(url: string): Promise<Content> { }
export async function saveContentItem(item: ContentItem): Promise<void> { }
```

### Route Handlers
```typescript
// RESTful naming
async function getContentItems(req, res) { }
async function getContentItemById(req, res) { }
async function createContentItem(req, res) { }
async function updateContentItem(req, res) { }
async function deleteContentItem(req, res) { }

// Action handlers
async function processContent(req, res) { }
async function bulkImportContent(req, res) { }
```

## Error Naming
```typescript
// Custom errors use PascalCase with "Error" suffix
export class ContentNotFoundError extends Error { }
export class InvalidContentTypeError extends Error { }
export class ProcessingFailedError extends Error { }

// Error codes use SCREAMING_SNAKE_CASE
export const ERROR_CODES = {
  CONTENT_NOT_FOUND: 'CONTENT_NOT_FOUND',
  INVALID_CONTENT_TYPE: 'INVALID_CONTENT_TYPE',
  PROCESSING_FAILED: 'PROCESSING_FAILED'
};
```

## Configuration & Constants
```typescript
// Config objects use SCREAMING_SNAKE_CASE
export const API_CONFIG = {
  BASE_URL: '/api',
  VERSION: 'v1',
  TIMEOUT: 30000
};

// Feature flags use SCREAMING_SNAKE_CASE
export const FEATURE_FLAGS = {
  ENABLE_BULK_IMPORT: true,
  ENABLE_AUTO_TAGGING: false
};
```

## Event Names
```typescript
// Events use dot notation, lowercase
'content.created'
'content.updated'
'content.processed'
'processing.started'
'processing.completed'
'processing.failed'
```

## Queue/Job Names
```typescript
// Job names use kebab-case
'process-content'
'generate-metadata'
'cleanup-expired-content'
'send-notification'
```

## Naming Checklist
- [ ] Does the name clearly indicate purpose?
- [ ] Is it consistent with existing patterns?
- [ ] Does it avoid unnecessary abbreviations?
- [ ] Does it follow the correct case convention?
- [ ] Would a new developer understand it?

## Common Patterns

### CRUD Operations
- Create: `create`, `add`, `insert`
- Read: `get`, `fetch`, `find`, `list`
- Update: `update`, `modify`, `patch`
- Delete: `delete`, `remove`, `destroy`

### State Transitions
- `start`, `stop`, `pause`, `resume`
- `enable`, `disable`
- `activate`, `deactivate`
- `process`, `complete`, `fail`

### Data Transformations
- `parse`, `format`, `serialize`, `deserialize`
- `encode`, `decode`
- `transform`, `convert`
- `validate`, `sanitize`