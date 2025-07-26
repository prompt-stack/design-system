# Complete Grammar Schemas - Machine-Readable Rule Enforcement

## 📍 Source Information
- **Primary Sources**: 
  - `/config/naming-grammar-schema.json` (lines 1-230)
  - `/config/full-stack-grammar-schema.json` (lines 1-350)
- **Original Intent**: Define machine-readable validation rules for Grammar Ops
- **Key Innovation**: Complete grammar system encoded as JSON schemas
- **Revolutionary Concept**: Automated enforcement through structured rule definitions

## 🎯 Overview - Schemas as Executable Grammar

These JSON schemas represent the **complete Grammar Ops rule system** in machine-readable format:

1. **Naming Grammar Schema** - Core naming rules and patterns
2. **Full Stack Grammar Schema** - Extended rules for all technology layers

Together they enable:
- **Automated validation** of code against grammar rules
- **Tool integration** for linters and validators
- **AI understanding** of exact patterns to follow
- **Cross-language consistency** through universal rules
- **Evolution tracking** as schemas can be versioned

## 📘 Naming Grammar Schema - Core Rule System

### Verb Taxonomy - Complete Action Library (Lines 3-12)

```json
{
  "verbTaxonomy": {
    "data": ["fetch", "get", "list", "create", "update", "delete", "save", "load", "sync", "query"],
    "view": ["render", "display", "show", "hide", "toggle", "open", "close", "reveal", "collapse"],
    "state": ["use", "set", "clear", "reset", "initialize", "restore", "manage", "track"],
    "transform": ["format", "parse", "convert", "serialize", "deserialize", "normalize", "stringify", "slugify"],
    "validation": ["validate", "verify", "check", "ensure", "assert", "confirm", "test"],
    "events": ["handle", "on", "emit", "dispatch", "listen", "trigger", "fire"],
    "async": ["queue", "process", "retry", "poll", "stream", "defer", "schedule"],
    "infra": ["build", "deploy", "migrate", "seed", "compile", "bundle", "optimize"]
  }
}
```

**Schema Benefits**:
- **Categorized verbs** for different operation types
- **Exhaustive lists** prevent ambiguity
- **Tool validation** can check function names start with these verbs
- **AI generation** uses appropriate verbs for context

### File Type Definitions - Complete Pattern Library (Lines 14-141)

#### Component Definition
```json
{
  "Component": {
    "location": "src/components/**/*.tsx",
    "filePattern": "^[A-Z][a-zA-Z0-9]+\\.tsx$",      // PascalCase.tsx
    "exportPattern": "default",
    "exportName": "PascalCase",
    "allowedVerbs": ["render", "display", "show"],
    "propsType": "{ComponentName}Props",
    "imports": ["hooks", "utils", "components", "types"],
    "forbidden": ["pages", "direct API calls"],
    "example": "Button.tsx exports default function Button()"
  }
}
```

**Schema Elements Explained**:
- **`location`**: Glob pattern for file discovery
- **`filePattern`**: Regex for filename validation
- **`exportPattern`**: Expected export style (default/named)
- **`allowedVerbs`**: Valid function prefixes within file
- **`imports/forbidden`**: Dependency rules enforcement
- **`example`**: Clear usage demonstration

#### Hook Definition
```json
{
  "Hook": {
    "location": "src/hooks/**/*.ts",
    "filePattern": "^use[A-Z][a-zA-Z0-9]+\\.ts$",    // use prefix required
    "exportPattern": "named",
    "exportName": "use{Feature}",
    "allowedVerbs": ["use", "set", "clear", "reset", "manage"],
    "returns": "object or tuple",
    "imports": ["hooks", "utils", "services", "types"],
    "forbidden": ["components"],                      // No circular deps
    "example": "useAuth.ts exports function useAuth()"
  }
}
```

**Hook-Specific Rules**:
- **Mandatory `use` prefix** in filename and export
- **Named exports only** (not default)
- **Cannot import components** (prevents circular dependencies)
- **State management verbs** allowed

#### Service Definition
```json
{
  "Service": {
    "location": "src/services/**/*.ts",
    "filePattern": "^[A-Z][a-zA-Z0-9]+(Service|Api)\\.ts$",
    "exportPattern": "class or object",
    "exportName": "{Domain}Service|{Domain}Api",
    "allowedVerbs": ["fetch", "get", "create", "update", "delete", "query"],
    "imports": ["utils", "constants", "types"],
    "forbidden": ["components", "hooks"],             // Pure business logic
    "example": "UserService.ts exports class UserService"
  }
}
```

**Service Pattern Rules**:
- **Suffix required**: Either `Service` or `Api`
- **CRUD verbs** for data operations
- **No UI dependencies** (components/hooks forbidden)

### Complete File Type Registry

The schema defines patterns for 13 file types:
1. **Component** - UI elements
2. **Hook** - Stateful logic
3. **Utility** - Pure functions
4. **Service** - Business logic
5. **Page** - Route components
6. **Type** - TypeScript definitions
7. **Constant** - Configuration values
8. **Error** - Error classes
9. **Middleware** - Request processing
10. **Worker** - Background tasks
11. **Selector** - State derivation
12. **Factory** - Object creation

### Casing Rules - Style Enforcement (Lines 143-177)

```json
{
  "casingRules": {
    "function": {
      "pattern": "camelCase",
      "regex": "^[a-z][a-zA-Z0-9]*$",
      "mustStartWith": ["verb from verbTaxonomy"]
    },
    "boolean": {
      "pattern": "camelCase with prefix",
      "regex": "^(is|has|can|should|will|did)[A-Z][a-zA-Z0-9]*$"
    },
    "constant": {
      "pattern": "UPPER_SNAKE_CASE",
      "regex": "^[A-Z][A-Z0-9_]*$"
    },
    "cssClass": {
      "pattern": "kebab-case BEM",
      "regex": "^[a-z][a-z0-9-]*(__|--)?[a-z0-9-]*$"
    }
  }
}
```

**Casing Validation Features**:
- **Regex patterns** for automated checking
- **Clear naming** of each pattern type
- **Special rules** like boolean prefixes
- **BEM support** for CSS classes

### Import Rules - Dependency Management (Lines 179-200)

```json
{
  "importRules": {
    "components": {
      "canImport": ["hooks", "utils", "components", "types", "constants"],
      "cannotImport": ["pages", "services/*.ts"]
    },
    "utils": {
      "canImport": ["utils", "types", "constants"],
      "cannotImport": ["hooks", "components", "services", "pages"]
    },
    "pages": {
      "canImport": ["*"],                    // Pages can import anything
      "cannotImport": ["pages"]               // Except other pages
    }
  }
}
```

**Dependency Rules Enable**:
- **Circular dependency prevention**
- **Layer isolation enforcement**
- **Clean architecture validation**
- **Automated import checking**

### Special Patterns - Context-Specific Rules (Lines 202-228)

```json
{
  "specialPatterns": {
    "eventHandler": {
      "pattern": "handle{Event}",
      "location": "inside components",
      "example": "handleClick, handleSubmit"
    },
    "hoc": {
      "pattern": "with{Feature}",
      "location": "src/hocs",
      "example": "withAuth, withTheme"
    },
    "actionType": {
      "pattern": "VERB_NOUN",
      "location": "reducer actions",
      "example": "ADD_TODO, FETCH_USER_SUCCESS"
    }
  }
}
```

## 📗 Full Stack Grammar Schema - Universal Extension

### Layer Definitions - Complete Stack Coverage (Lines 3-224)

#### Frontend Layer
```json
{
  "frontend": {
    "components": {
      "location": "src/components/**/*.tsx",
      "pattern": "PascalCase",
      "exports": "default function {Name}",
      "verbs": ["render", "display", "show", "toggle"]
    },
    "hooks": {
      "pattern": "camelCase use{Feature}",
      "verbs": ["use", "set", "clear", "reset"]
    },
    "styles": {
      "pattern": "kebab-case",
      "cssPattern": "BEM: block__element--modifier"
    }
  }
}
```

#### Backend Layer
```json
{
  "backend": {
    "routes": {
      "pattern": "kebab-case plural",
      "httpVerbs": ["GET", "POST", "PUT", "DELETE"],
      "functions": ["get{Resource}", "create{Resource}", "update{Resource}", "delete{Resource}"]
    },
    "controllers": {
      "pattern": "PascalCase + Controller",
      "methods": ["index", "show", "create", "update", "destroy"]
    },
    "services": {
      "pattern": "PascalCase + Service",
      "verbs": ["fetch", "create", "update", "delete", "process", "validate"]
    }
  }
}
```

#### Database Layer
```json
{
  "database": {
    "migrations": {
      "pattern": "{timestamp}_{action}_{target}.sql",
      "actions": ["create", "alter", "drop", "add", "remove"],
      "example": "20240121_create_users_table.sql"
    },
    "models": {
      "pattern": "PascalCase singular",
      "relations": {
        "hasOne": "singular",
        "hasMany": "plural",
        "belongsTo": "singular",
        "belongsToMany": "plural"
      }
    }
  }
}
```

#### Infrastructure Layer
```json
{
  "infrastructure": {
    "docker": {
      "naming": {
        "services": "kebab-case",
        "images": "kebab-case:tag",
        "volumes": "snake_case"
      }
    },
    "cicd": {
      "pattern": "{action}-{environment}.yml",
      "example": "deploy-production.yml"
    },
    "kubernetes": {
      "pattern": "{resource}-{type}.yaml",
      "labels": "kebab-case"
    }
  }
}
```

### Python Layer Integration (Lines 180-223)

```json
{
  "python": {
    "functions": {
      "pattern": "snake_case verb_noun",
      "example": "fetch_user(), validate_email()"
    },
    "classes": {
      "pattern": "PascalCase",
      "example": "class UserService:"
    },
    "booleans": {
      "prefixes": ["is_", "has_", "can_", "should_"],
      "example": "is_active, has_permission"
    }
  }
}
```

**Cross-Language Consistency**:
- Same verb patterns, different casing
- Same architectural concepts
- Same boolean prefixes
- Language-appropriate style

### SQL Naming Conventions (Lines 228-256)

```json
{
  "sql": {
    "tables": {
      "pattern": "plural_snake_case",
      "example": "users, user_profiles"
    },
    "columns": {
      "pattern": "snake_case",
      "primaryKey": "{table_singular}_id",
      "foreignKey": "{related_table_singular}_id",
      "timestamps": ["created_at", "updated_at", "deleted_at"]
    },
    "indexes": {
      "pattern": "idx_{table}_{column(s)}",
      "example": "idx_users_email"
    }
  }
}
```

### API Endpoint Patterns (Lines 258-273)

```json
{
  "api": {
    "endpoints": {
      "pattern": "/api/{resource}",
      "restful": {
        "GET /api/users": "List all",
        "GET /api/users/:id": "Get one",
        "POST /api/users": "Create",
        "PUT /api/users/:id": "Update",
        "DELETE /api/users/:id": "Delete"
      },
      "actions": {
        "pattern": "/api/{resource}/:id/{action}",
        "example": "/api/users/:id/activate"
      }
    }
  }
}
```

### Complete Verb Taxonomy by Domain (Lines 289-318)

```json
{
  "verbTaxonomyComplete": {
    "frontend": {
      "render": ["render", "display", "show", "paint", "draw"],
      "interact": ["click", "hover", "focus", "blur", "scroll", "drag", "drop"],
      "animate": ["animate", "transition", "fade", "slide", "bounce", "rotate"]
    },
    "backend": {
      "serve": ["serve", "handle", "process", "route", "forward", "proxy"],
      "auth": ["authenticate", "authorize", "login", "logout", "verify", "refresh"]
    },
    "database": {
      "query": ["select", "insert", "update", "delete", "upsert", "merge"],
      "migrate": ["migrate", "rollback", "seed", "truncate", "backup", "restore"]
    },
    "async": {
      "queue": ["enqueue", "dequeue", "process", "retry", "fail", "complete"],
      "stream": ["stream", "pipe", "buffer", "flush", "drain"]
    }
  }
}
```

### File Extension Registry (Lines 320-348)

```json
{
  "fileExtensions": {
    "code": {
      "typescript": [".ts", ".tsx", ".d.ts", ".mts", ".cts"],
      "javascript": [".js", ".jsx", ".mjs", ".cjs"],
      "python": [".py", ".pyi", ".pyx"]
    },
    "data": {
      "config": [".json", ".yaml", ".yml", ".toml", ".ini"],
      "database": [".sql", ".prisma", ".graphql"]
    }
  }
}
```

## 🔧 Schema Usage and Integration

### 1. Validation Tools
These schemas can be used by:
- **ESLint plugins** for naming validation
- **Pre-commit hooks** for compliance checking
- **CI/CD pipelines** for automated enforcement
- **IDE extensions** for real-time feedback

### 2. Code Generation
AI and tools can use schemas to:
- **Generate compliant code** following patterns
- **Suggest corrections** for violations
- **Create boilerplate** with correct structure
- **Refactor existing code** to match rules

### 3. Documentation Generation
Schemas enable:
- **Auto-generated style guides** from rules
- **Interactive documentation** showing patterns
- **Training materials** for developers
- **Onboarding resources** for new team members

### 4. Evolution and Versioning
Schemas support:
- **Version tracking** of rule changes
- **Migration paths** for rule updates
- **A/B testing** of new patterns
- **Gradual adoption** of new rules

## 🎯 Implementation Example

### Using Schema for Validation
```javascript
const namingSchema = require('./naming-grammar-schema.json');

function validateFunctionName(name, fileType) {
  const rules = namingSchema.namingGrammar.fileTypes[fileType];
  const verbs = rules.allowedVerbs;
  
  // Check if function starts with allowed verb
  const startsWithVerb = verbs.some(verb => 
    name.startsWith(verb)
  );
  
  if (!startsWithVerb) {
    return {
      valid: false,
      message: `Function must start with: ${verbs.join(', ')}`
    };
  }
  
  // Check casing rules
  const casingRule = namingSchema.namingGrammar.casingRules.function;
  const matchesCasing = new RegExp(casingRule.regex).test(name);
  
  return {
    valid: matchesCasing,
    message: matchesCasing ? 'Valid' : `Must match ${casingRule.pattern}`
  };
}
```

### Using Schema for Generation
```javascript
function generateServiceClass(domain) {
  const serviceRules = namingSchema.namingGrammar.fileTypes.Service;
  
  return {
    filename: `${domain}Service.ts`,
    className: `${domain}Service`,
    methods: serviceRules.allowedVerbs.map(verb => 
      `${verb}${domain}()`
    ),
    imports: serviceRules.imports
  };
}
```

## 🔗 Integration with Grammar Ops

### These Schemas Connect To:
- **Core Grammar System** - Implements the verb/noun patterns
- **Full Stack Grammar** - Extends to all technology layers
- **Naming System** - Enforces naming conventions
- **LLM Directives** - Provides machine-readable rules

### Schemas Enable:
- **Automated validation** of entire codebases
- **Consistent enforcement** across all tools
- **Evolution tracking** of grammar rules
- **Cross-tool integration** through standard format

### Critical Success Factors:
- **Tool adoption** - Linters must use schemas
- **Maintenance** - Schemas must stay updated
- **Documentation** - Changes must be communicated
- **Testing** - Schema rules must be validated

## 🎯 Revolutionary Impact

These schemas transform Grammar Ops from documentation to **executable specification**:

1. **Living Rules** - Documentation that validates itself
2. **Tool Ecosystem** - Any tool can use the schemas
3. **Evolution Support** - Rules can change systematically
4. **Universal Language** - Same rules, many implementations
5. **Quality Automation** - Compliance becomes automatic

With these schemas, Grammar Ops becomes a **self-enforcing system** where the rules are the code!