# Metadata Migration Plan

## Goal
Update all 76 TypeScript/React files to have universal metadata format that enables:
- LLM navigation in <1000 tokens for 50 files
- Permission-aware editing
- Architectural role understanding

## Current State
- Total files: 76
- Files with old metadata: 34 
- Files with new metadata: 3 (after test)
- Files without any metadata: 39

## Migration Strategy

### Phase 1: Components (23 files)
These are the building blocks - update first
```bash
./design-system/scripts/update-metadata-batch.sh components
```

### Phase 2: Layout (4 files)
Core layout structure
```bash
./design-system/scripts/update-metadata-batch.sh layout
```

### Phase 3: Features (8 files)
Feature modules that use components
```bash
./design-system/scripts/update-metadata-batch.sh features
```

### Phase 4: Pages (4 files)
Entry points - need suggest-only permissions
```bash
./design-system/scripts/update-metadata-batch.sh pages
```

### Phase 5: Hooks (8 files)
Shared logic and state management
```bash
./design-system/scripts/update-metadata-batch.sh hooks
```

### Phase 6: Playground (18 files)
Demo and testing components
```bash
./design-system/scripts/update-metadata-batch.sh playground
```

### Phase 7: Remaining Files
App.tsx, main.tsx, and any stragglers
```bash
./design-system/scripts/add-universal-metadata.sh --all
```

## Verification Steps

After each phase:
1. Check status: `./update-metadata-batch.sh status`
2. Review changes: `git diff --stat`
3. Test components still work
4. Commit if successful

## Expected Outcome

Every file will have:
```typescript
/**
 * @file [relative path]
 * @purpose [clear description]
 * @layer [primitive|composed|feature|page]
 * @deps [dependencies or none]
 * @used-by [components using this]
 * @css [associated CSS or none]
 * @llm-read true|false
 * @llm-write full-edit|suggest-only|read-only
 * @llm-role utility|entrypoint|pure-view|async-service
 */
```

## Rollback Plan

If issues arise:
```bash
git checkout -- src/
```

## Success Metrics

- All 76 files have universal metadata
- LLM can scan 50 files in <1000 tokens
- Permission boundaries are respected
- No functionality is broken