# Codebase Dialect Guide

## Overview
This document defines the "dialect" or communication style used throughout the Content Stack codebase. It ensures consistency in comments, documentation, error messages, and user-facing text.

## Core Voice Principles

### 1. Be Human, Not Robotic
```typescript
// ❌ Bad: "Error: Invalid parameter supplied to function"
// ✅ Good: "Oops! The URL you provided doesn't look quite right"

// ❌ Bad: "Processing initiated for content item"
// ✅ Good: "Starting to process your content..."
```

### 2. Be Helpful, Not Just Informative
```typescript
// ❌ Bad: throw new Error('Invalid content type');
// ✅ Good: throw new Error('Content type not supported. Try: article, video, or image');

// ❌ Bad: "Failed to connect"
// ✅ Good: "Couldn't connect to the server. Check your internet connection and try again"
```

### 3. Be Concise, But Complete
```typescript
// ❌ Bad: "The system has encountered an error while attempting to process..."
// ✅ Good: "Processing failed. The file might be too large (max: 50MB)"
```

## Code Comments

### Function Documentation
```typescript
/**
 * Extracts metadata from various content types.
 * Handles articles, videos, and images gracefully.
 * 
 * @param content - Raw content buffer
 * @param type - Content type (auto-detected if not provided)
 * @returns Extracted metadata or null if extraction fails
 * 
 * @example
 * const metadata = await extractMetadata(buffer, 'article');
 * if (!metadata) console.log('Could not extract metadata');
 */
```

### Inline Comments
```typescript
// Quick check - bail early if content is empty
if (!content) return null;

// Transform the data (this is where the magic happens)
const transformed = await transformer.process(content);

// TODO: Add retry logic here (max 3 attempts)
// FIXME: This breaks with Unicode filenames
// HACK: Temporary workaround until we upgrade the parser
```

## Error Messages

### User-Facing Errors
```typescript
export const USER_ERRORS = {
  INVALID_URL: "That URL doesn't look right. Make sure it starts with http:// or https://",
  FILE_TOO_LARGE: "This file is too large (max: 50MB). Try compressing it first",
  UNSUPPORTED_TYPE: "We can't process this file type yet. Supported: PDF, TXT, MD, DOCX",
  NETWORK_ERROR: "Connection issues detected. Please check your internet and try again"
};
```

### Developer Errors
```typescript
export const DEV_ERRORS = {
  MISSING_ENV: "Missing environment variable: {VAR_NAME}. Check .env.example",
  DB_CONNECTION: "Database connection failed. Is MongoDB running?",
  INVALID_SCHEMA: "Schema validation failed for {MODEL_NAME}: {DETAILS}"
};
```

## API Responses

### Success Messages
```json
{
  "status": "success",
  "message": "Content processed successfully!",
  "data": { },
  "next": "Your content is ready in the library"
}
```

### Error Responses
```json
{
  "status": "error",
  "message": "We couldn't process that URL",
  "reason": "The website blocked our access",
  "suggestion": "Try saving the page as PDF and uploading it instead"
}
```

## UI Text Guidelines

### Button Labels
```
// Action-oriented, clear outcome
"Process Content"     // Not "Submit"
"Save to Library"     // Not "OK"
"Try Again"          // Not "Retry"
"Get Started"        // Not "Begin"
```

### Status Messages
```
"Processing..."           // Active, present tense
"Almost there..."        // Encouraging during long waits
"All done!"             // Celebratory on completion
"Something went wrong"   // Honest but not alarming
```

### Empty States
```
"No content yet"                    // Simple statement
"Drop a file or paste a URL"       // Clear call-to-action
"Your library is empty"            // Current state
"Add your first item to begin"     // Next step
```

## Logging Style

### Info Logs
```typescript
logger.info('Content processor started');
logger.info(`Processing ${count} items from queue`);
logger.info('Cleanup completed: removed 15 expired items');
```

### Warning Logs
```typescript
logger.warn('Rate limit approaching: 80% of quota used');
logger.warn(`Slow response from API: ${responseTime}ms`);
logger.warn('Deprecated endpoint called: /api/v1/old-route');
```

### Error Logs
```typescript
logger.error('Failed to process content', { contentId, error: err.message });
logger.error(`Database query timeout after ${timeout}ms`);
logger.error('Unhandled content type', { type: contentType });
```

## Variable & Concept Naming

### User-Facing Concepts
```
"Content Inbox"      // Not "Import Queue"
"Processing"         // Not "Parsing"
"Library"           // Not "Storage"
"Tags"              // Not "Labels"
```

### Technical Terms Made Friendly
```
"Couldn't save"      // Instead of "Write failed"
"Taking longer"      // Instead of "Timeout exceeded"
"Try refreshing"     // Instead of "State sync error"
```

## Prompt Engineering Text

### For LLM Integration
```typescript
const SYSTEM_PROMPTS = {
  summarize: `
    You're helping organize content for a personal knowledge system.
    Be concise but thorough. Focus on key insights and actionable points.
    Write in a friendly, conversational tone.
  `,
  
  categorize: `
    Suggest 3-5 relevant categories for this content.
    Use simple, memorable category names.
    Think like a helpful librarian, not a robot.
  `
};
```

## Common Phrases Dictionary

### Encouragement
- "Great choice!"
- "You're all set"
- "Looking good"
- "Nice work"

### Waiting/Processing
- "Hang tight..."
- "Working on it..."
- "Almost ready..."
- "Just a moment..."

### Errors/Issues
- "Let's try that again"
- "Something's not right"
- "We hit a snag"
- "Didn't quite work"

### Success
- "All done!"
- "Success!"
- "Ready to go"
- "Processed successfully"

## Tone Variations by Context

### Onboarding
Warm, encouraging, helpful
```
"Welcome! Let's get your content inbox set up in just a few steps"
```

### Error Handling
Understanding, solution-focused
```
"That didn't work, but here's what you can try..."
```

### Processing/Waiting
Patient, informative
```
"This might take a minute. We're extracting all the good stuff..."
```

### Success States
Celebratory but professional
```
"Excellent! Your content has been processed and saved to your library"
```

## Writing Checklist
- [ ] Is it clear what happened or what needs to happen?
- [ ] Does it sound like a helpful human wrote it?
- [ ] Are technical terms explained or avoided?
- [ ] Is there a clear next action when appropriate?
- [ ] Would a stressed user find this calming?