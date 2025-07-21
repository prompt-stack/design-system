# Naming Compliance Issues

## Script Naming Issues

### Scripts that need renaming:
1. `audit-css.sh` → `audit-css.sh` (action-target pattern)
2. `update-metadata-batch.sh` → `update-metadata-batch.sh`
3. `migrate-metadata.sh` → `migrate-metadata.sh`
4. `check-llm-permissions.sh` → `check-llm-permissions.sh`
5. `update-metadata-smart.sh` → `update-metadata-smart.sh`
6. `scan-llm-aware.sh` → `scan-llm-aware.sh`

### Pattern to follow:
```
{action}-{target}.sh

Actions: audit, add, build, find, validate, update, generate, migrate, check, scan
```

## Service File Issues

1. `src/services/api.ts` should be renamed to:
   - `ApiService.ts` (if it's a service class)
   - `apiClient.ts` (if it's a utility)
   - Should be PascalCase if a class/service

## Type File Issues

1. `src/types/index.ts` is fine as a barrel export
   - But individual type files should follow `{Domain}Types.ts` pattern

## CSS File Issues

All CSS files are correctly lowercase with hyphens ✅

## Component Issues

All components follow PascalCase ✅

## Hook Issues

All hooks start with 'use' ✅

## Recommendations

### Immediate Actions:
1. Rename non-compliant shell scripts
2. Rename `api.ts` to follow service naming pattern
3. Update any imports after renaming

### Future Guidelines:
1. All new scripts must follow `{action}-{target}.sh`
2. All services must end with 'Service' or 'Api'
3. Enforce naming in code reviews
4. Add pre-commit hook to check naming

## Benefits of Compliance

1. **Predictability** - Know what a file does by its name
2. **Searchability** - Easy to find all audit scripts (`audit-*.sh`)
3. **Consistency** - Same patterns everywhere
4. **LLM-friendly** - AI tools can understand structure better