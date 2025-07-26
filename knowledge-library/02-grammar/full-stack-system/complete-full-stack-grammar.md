# Complete Full Stack Grammar System - Universal Development Language

## 📍 Source Information
- **Primary Source**: `/docs/FULL_STACK_GRAMMAR_SYSTEM.md` (lines 1-319)
- **Original Intent**: Extend Grammar Ops beyond frontend to complete application stack
- **Key Innovation**: Universal grammar rules for database, backend, infrastructure, and testing layers
- **Revolutionary Concept**: Every layer of application development follows consistent grammatical patterns

## 🎯 Core Vision - Complete Coverage (Lines 3-10)

**Universal Grammar Scope**:
- **Frontend**: React, TypeScript, CSS, HTML (existing Grammar Ops)
- **Backend**: Node.js, Express, API routes, Services (new)
- **Database**: SQL, Migrations, Models, Schemas (new)
- **Infrastructure**: Docker, CI/CD, Config, Scripts (new)
- **Testing**: Unit, Integration, E2E, Fixtures (new)
- **Documentation**: Markdown, Stories, API docs (new)

**The Revolutionary Principle**: **Every file, every function, every configuration follows the same grammatical rules** - creating a unified language for complete application development.

## 🗄️ Database Layer Grammar - Complete SQL Standards (Lines 11-43)

### Database File Type Grammar (Lines 13-22)

**Complete SQL File Classification System**:

| File Type | Location | Naming Pattern | Example | Grammar Rule |
|-----------|----------|----------------|---------|---------------|
| **Migration** | `migrations/` | `{timestamp}_{action}_{target}.sql` | `20240121_create_users_table.sql` | Verb + Entity pattern |
| **Seed** | `seeds/` | `{order}_{name}.sql` | `01_initial_users.sql` | Sequential ordering |
| **Query** | `queries/` | `{action}_{entity}.sql` | `get_active_users.sql` | Verb + Adjective + Noun |
| **Schema** | `schema/` | `{entity}_schema.sql` | `users_schema.sql` | Entity + Type suffix |
| **Procedure** | `procedures/` | `sp_{action}_{entity}.sql` | `sp_update_user_status.sql` | Stored procedure prefix |
| **View** | `views/` | `vw_{entity}_{purpose}.sql` | `vw_users_summary.sql` | View prefix + purpose |
| **Index** | `indexes/` | `idx_{table}_{columns}.sql` | `idx_users_email.sql` | Index prefix + target |

**Critical Grammar Rules**:
- **Action verbs first**: `create`, `update`, `get`, `delete` start filenames
- **Entity names plural** for tables, singular for records
- **Descriptive suffixes** indicate file purpose (`_schema`, `_view`, `_index`)
- **Timestamp prefixes** for migrations ensure ordering

### SQL Naming Convention Grammar (Lines 24-43)

**Complete SQL Object Naming System**:

```sql
-- TABLES: plural, snake_case (Grammar Rule: Collections are plural)
CREATE TABLE users (                    -- ✅ Plural entity name
    user_id SERIAL PRIMARY KEY,         -- ✅ {singular}_id pattern
    email_address VARCHAR(255),         -- ✅ Descriptive field names
    first_name VARCHAR(100),            -- ✅ snake_case convention
    is_active BOOLEAN DEFAULT true,     -- ✅ Boolean with 'is_' prefix
    created_at TIMESTAMP DEFAULT NOW(), -- ✅ Standard timestamp naming
    updated_at TIMESTAMP DEFAULT NOW()  -- ✅ Standard timestamp naming
);

-- PRIMARY KEYS: {table_singular}_id (Grammar Rule: ID pattern)
user_id, order_id, product_id  -- ✅ Consistent ID naming

-- FOREIGN KEYS: {related_table_singular}_id (Grammar Rule: Relationship naming)
profile_user_id, order_user_id  -- ✅ Clear relationship indication

-- TIMESTAMPS: Standard suffixes (Grammar Rule: Lifecycle naming)
created_at, updated_at, deleted_at, published_at  -- ✅ Action + _at

-- INDEXES: idx_{table}_{column(s)} (Grammar Rule: Index identification)
CREATE INDEX idx_users_email ON users(email_address);        -- ✅ Single column
CREATE INDEX idx_orders_user_status ON orders(user_id, status); -- ✅ Composite

-- CONSTRAINTS: {table}_{type}_{columns} (Grammar Rule: Constraint identification)
ALTER TABLE users ADD CONSTRAINT users_unique_email UNIQUE(email_address);
ALTER TABLE orders ADD CONSTRAINT orders_fk_user FOREIGN KEY (user_id) REFERENCES users(user_id);
```

**Database Grammar Benefits**:
- **Predictable structure**: LLMs can infer table relationships from naming
- **Self-documenting**: Purpose clear from grammatical patterns
- **Consistent querying**: Grammar rules enable query pattern templates

## 🚀 Backend API Layer Grammar - RESTful Patterns (Lines 45-68)

### API File Organization Grammar (Lines 47-53)

**Backend File Classification System**:

| Pattern | Location | Example | Grammar Rule | Purpose |
|---------|----------|---------|---------------|---------|
| **RESTful Routes** | `routes/{resource}.ts` | `routes/users.ts` | Resource-based grouping | HTTP endpoint definitions |
| **Controller** | `controllers/{Resource}Controller.ts` | `UserController.ts` | PascalCase + Controller suffix | Request/response handling |
| **Middleware** | `middleware/{purpose}Middleware.ts` | `authMiddleware.ts` | camelCase + Middleware suffix | Request processing pipeline |
| **Validator** | `validators/{resource}Validator.ts` | `userValidator.ts` | camelCase + Validator suffix | Input validation logic |

### RESTful Endpoint Grammar (Lines 55-68)

**Complete HTTP Verb to Function Mapping**:

```typescript
// RESTful Resource Operations (Grammar Rule: HTTP verb to function verb mapping)
GET    /api/users          → getUsers(), listUsers(), indexUsers()     // Collection retrieval
GET    /api/users/:id      → getUser(), showUser(), findUserById()     // Single item retrieval  
POST   /api/users          → createUser(), storeUser()                 // Resource creation
PUT    /api/users/:id      → updateUser(), modifyUser()                // Full resource update
PATCH  /api/users/:id      → patchUser(), updateUserPartial()          // Partial update
DELETE /api/users/:id      → deleteUser(), removeUser(), destroyUser() // Resource deletion

// Action-Based Endpoints (Grammar Rule: Action verb + resource pattern)
POST   /api/users/:id/activate         → activateUser()                // State change action
POST   /api/users/:id/reset-password   → resetUserPassword()           // Specific action
POST   /api/users/:id/send-invite      → sendUserInvite()             // Communication action
GET    /api/users/:id/permissions      → getUserPermissions()          // Related data retrieval
PUT    /api/users/:id/permissions      → updateUserPermissions()      // Related data update
```

**API Grammar Rules**:
- **HTTP verbs map to function verbs**: GET→get/list, POST→create, PUT→update, DELETE→delete
- **Action endpoints use verb phrases**: `/activate` → `activateUser()`
- **Resource-based grouping**: Related endpoints in same route file
- **Consistent parameter naming**: `:id` for primary keys, `:userId` for foreign keys

## 🏗️ Model/ORM Layer Grammar - Data Abstraction (Lines 70-102)

### ORM-Specific File Patterns (Lines 72-78)

**Model File Grammar by ORM**:

| ORM | Location | Pattern | Example | Grammar Rule |
|-----|----------|---------|---------|---------------|
| **Prisma** | `prisma/schema.prisma` | `model {Entity}` | `model User {}` | Single schema file, PascalCase models |
| **TypeORM** | `entities/{Entity}.ts` | `@Entity() class {Entity}` | `User.entity.ts` | Class-based, decorator pattern |
| **Sequelize** | `models/{Model}.js` | `class {Entity} extends Model` | `User.model.js` | Inheritance pattern |
| **Mongoose** | `models/{Model}.ts` | `{Entity}Schema` | `UserSchema.ts` | Schema-based pattern |

### Model Naming Grammar (Lines 80-102)

**Complete Entity Relationship Grammar**:

```typescript
// Entity Class: Singular PascalCase (Grammar Rule: Entity naming)
class User extends Model {
  // Properties: camelCase in code, snake_case in DB (Grammar Rule: Property naming)
  firstName: string           // Maps to first_name
  emailAddress: string        // Maps to email_address  
  isActive: boolean           // Maps to is_active
  createdAt: Date            // Maps to created_at
  
  // Relationships: Grammar rules based on cardinality
  profile: Profile           // hasOne: singular, immediate relation
  posts: Post[]             // hasMany: plural array
  roles: Role[]             // manyToMany: plural array
  organization: Organization // belongsTo: singular reference
  
  // Computed properties: get prefix (Grammar Rule: Computed naming)
  get fullName(): string { return `${this.firstName} ${this.lastName}`; }
  get isVerified(): boolean { return this.emailVerifiedAt !== null; }
}

// Repository Pattern: {Entity}Repository (Grammar Rule: Repository naming)
class UserRepository {
  // Query methods: find prefix + criteria (Grammar Rule: Query method naming)
  findById(id: string): Promise<User>                    // Single result by ID
  findByEmail(email: string): Promise<User>              // Single result by unique field
  findManyByRole(role: string): Promise<User[]>          // Multiple results
  findActiveUsers(): Promise<User[]>                     // Multiple with criteria
  
  // Mutation methods: action verb + entity (Grammar Rule: Mutation naming)
  createUser(data: CreateUserDto): Promise<User>         // Create new entity
  updateUser(id: string, data: UpdateUserDto): Promise<User>  // Update existing
  deleteUser(id: string): Promise<void>                  // Remove entity
  
  // Boolean query methods: exists/has prefix (Grammar Rule: Boolean query naming)
  existsByEmail(email: string): Promise<boolean>         // Existence check
  hasPermission(userId: string, permission: string): Promise<boolean>  // Permission check
}
```

**Model Grammar Benefits**:
- **Relationship clarity**: Singular/plural naming indicates cardinality
- **Query predictability**: Standard prefixes enable LLM generation
- **Type safety**: Grammar rules map to TypeScript patterns

## ⚙️ Service Layer Grammar - Business Logic Patterns (Lines 104-113)

### Business Logic File Organization

**Service Layer Classification System**:

| Type | Location | Pattern | Example | Grammar Rule | Purpose |
|------|----------|---------|---------|---------------|---------|
| **Service** | `services/{Domain}Service.ts` | Class with methods | `AuthService.ts` | Domain + Service suffix | Multi-method business logic |
| **UseCase** | `usecases/{Action}{Entity}.ts` | Single responsibility | `CreateUserUseCase.ts` | Action + Entity + UseCase | Single business operation |
| **Domain** | `domain/{entity}/` | DDD structure | `domain/user/UserAggregate.ts` | Domain-driven design | Complex business rules |
| **Repository** | `repositories/{Entity}Repository.ts` | Data access interface | `UserRepository.ts` | Entity + Repository | Data layer abstraction |

**Service Layer Grammar Rules**:

```typescript
// Service Class: Domain + Service (Grammar Rule: Service naming)
class AuthService {
  // Authentication methods: auth verbs (Grammar Rule: Auth method naming)
  async authenticateUser(credentials: LoginCredentials): Promise<AuthResult>     // Login process
  async authorizeAction(user: User, action: string): Promise<boolean>           // Permission check
  async validateToken(token: string): Promise<TokenValidation>                  // Token verification
  async refreshToken(refreshToken: string): Promise<TokenPair>                  // Token renewal
  
  // Password methods: password verbs (Grammar Rule: Password method naming)
  async hashPassword(plaintext: string): Promise<string>                        // Password hashing
  async comparePassword(plaintext: string, hash: string): Promise<boolean>      // Password verification
  async resetPassword(email: string): Promise<void>                           // Password reset initiation
  async changePassword(userId: string, newPassword: string): Promise<void>     // Password update
}

// UseCase: Single Action (Grammar Rule: UseCase naming)
class CreateUserUseCase {
  constructor(
    private userRepository: UserRepository,
    private emailService: EmailService,
    private authService: AuthService
  ) {}
  
  // Single execute method: Grammar Rule for UseCase pattern
  async execute(input: CreateUserInput): Promise<CreateUserOutput> {
    // 1. Validation phase
    await this.validateInput(input);
    
    // 2. Business logic phase  
    const hashedPassword = await this.authService.hashPassword(input.password);
    const user = await this.userRepository.createUser({
      ...input,
      password: hashedPassword
    });
    
    // 3. Side effects phase
    await this.emailService.sendWelcomeEmail(user.email);
    
    return { user, success: true };
  }
  
  // Private helper methods: validate/check/ensure prefixes (Grammar Rule: Helper naming)
  private async validateInput(input: CreateUserInput): Promise<void>
  private async checkEmailUniqueness(email: string): Promise<void>  
  private async ensurePasswordComplexity(password: string): Promise<void>
}
```

## 🏭 Infrastructure Layer Grammar - DevOps Patterns (Lines 115-124)

### Infrastructure File Grammar

**Complete Infrastructure File Classification**:

| File Type | Location | Pattern | Purpose | Grammar Rule |
|-----------|----------|---------|---------|---------------|
| **Docker** | `Dockerfile`, `docker-compose.yml` | Lowercase, descriptive | Container configuration | Standard Docker naming |
| **CI/CD** | `.github/workflows/*.yml` | `{action}-{target}.yml` | Automation pipelines | Action-target pattern |
| **Terraform** | `infrastructure/*.tf` | `{resource}.tf` | Infrastructure as code | Resource-based naming |
| **Kubernetes** | `k8s/*.yaml` | `{resource}-{type}.yaml` | Container orchestration | Resource-type pattern |
| **Environment** | `.env*` files | UPPER_SNAKE variables | Configuration values | Constant naming convention |

**Infrastructure Grammar Examples**:

```yaml
# CI/CD Grammar: action-target.yml
.github/workflows/
├── deploy-production.yml      # ✅ Action-target pattern
├── test-pull-request.yml      # ✅ Action-target pattern  
├── build-docker-image.yml     # ✅ Action-target pattern
└── release-npm-package.yml    # ✅ Action-target pattern

# Kubernetes Grammar: resource-type.yaml
k8s/
├── api-deployment.yaml        # ✅ Resource-type pattern
├── api-service.yaml          # ✅ Resource-type pattern
├── database-configmap.yaml   # ✅ Resource-type pattern  
└── ingress-rules.yaml        # ✅ Resource-type pattern

# Terraform Grammar: resource.tf
infrastructure/
├── database.tf               # ✅ Resource-based naming
├── networking.tf             # ✅ Resource-based naming
├── security.tf               # ✅ Resource-based naming
└── monitoring.tf             # ✅ Resource-based naming
```

**Environment Variable Grammar**:
```bash
# Environment variables: UPPER_SNAKE_CASE (Grammar Rule: Constant naming)
DATABASE_URL=postgresql://...           # ✅ Service + descriptor
REDIS_CONNECTION_STRING=redis://...     # ✅ Service + type
JWT_SECRET_KEY=...                      # ✅ Feature + descriptor
SMTP_HOST=...                          # ✅ Protocol + descriptor
API_RATE_LIMIT_PER_MINUTE=60           # ✅ Feature + unit descriptor
```

## 🧪 Testing Layer Grammar - Complete Testing Standards (Lines 126-153)

### Test File Organization Grammar (Lines 127-134)

**Testing File Classification System**:

| Type | Location | Pattern | Example | Grammar Rule | Purpose |
|------|----------|---------|---------|---------------|---------|
| **Unit** | `{file}.test.ts` | Co-located with source | `UserService.test.ts` | Source + .test suffix | Individual function testing |
| **Integration** | `tests/integration/` | `{feature}.test.ts` | `auth-flow.test.ts` | Feature-based grouping | Multi-component testing |
| **E2E** | `tests/e2e/` | `{user-flow}.e2e.ts` | `user-registration.e2e.ts` | User story naming | Complete workflow testing |
| **Fixtures** | `tests/fixtures/` | `{entity}.fixture.ts` | `users.fixture.ts` | Entity + fixture suffix | Test data generation |
| **Mocks** | `tests/mocks/` | `{service}.mock.ts` | `database.mock.ts` | Service + mock suffix | Dependency simulation |

### Test Naming Grammar (Lines 136-153)

**Complete Test Description Grammar**:

```typescript
// Unit Test Grammar: Class/Function being tested
describe('UserService', () => {                    // ✅ Class under test
  describe('createUser', () => {                   // ✅ Method under test
    
    // Positive test cases: "should" + expected behavior
    it('should create a new user with valid data')           // ✅ Happy path
    it('should hash the password before saving')             // ✅ Security behavior
    it('should return user without password field')          // ✅ Data transformation
    it('should send welcome email after creation')           // ✅ Side effect
    
    // Negative test cases: "should throw/fail/reject" + condition
    it('should throw error if email already exists')         // ✅ Validation error
    it('should reject invalid email format')                 // ✅ Input validation
    it('should fail if password is too weak')                // ✅ Business rule
    
    // Edge cases: "should handle" + edge condition
    it('should handle database connection failure')          // ✅ Infrastructure failure
    it('should handle concurrent user creation')             // ✅ Race condition
  })
  
  describe('findUserById', () => {
    it('should return user when ID exists')                  // ✅ Success case
    it('should return null when ID does not exist')          // ✅ Not found case
    it('should throw error for invalid ID format')           // ✅ Input validation
  })
})

// Integration Test Grammar: Feature/Flow being tested
describe('Authentication Flow', () => {                      // ✅ Feature under test
  it('allows user to login with valid credentials')         // ✅ Success workflow
  it('redirects to dashboard after successful login')       // ✅ Navigation behavior
  it('displays error message for invalid credentials')      // ✅ Error handling
  it('locks account after multiple failed attempts')        // ✅ Security behavior
})

// E2E Test Grammar: Complete user journeys
describe('User Registration Journey', () => {               // ✅ User story
  it('allows new users to sign up with email')             // ✅ Primary flow
  it('sends confirmation email after registration')         // ✅ Email workflow  
  it('prevents duplicate email registration')               // ✅ Validation flow
  it('enables profile completion after email verification') // ✅ Multi-step flow
})

// Fixture Grammar: Test data generation patterns
export const userFixtures = {
  // Valid data patterns: adjective + noun
  validUser: () => ({ email: 'test@example.com', password: 'SecurePass123!' }),
  adminUser: () => ({ ...validUser(), role: 'admin' }),
  
  // Invalid data patterns: invalid + descriptor  
  invalidEmail: () => ({ email: 'not-an-email', password: 'SecurePass123!' }),
  weakPassword: () => ({ email: 'test@example.com', password: '123' }),
  
  // Edge case patterns: edge + condition
  longEmail: () => ({ email: 'a'.repeat(250) + '@example.com', password: 'SecurePass123!' }),
  emptyFields: () => ({ email: '', password: '' })
}
```

## ⚡ Job/Queue Layer Grammar - Background Processing (Lines 155-163)

### Background Job Grammar

**Job System Classification**:

| Type | Location | Pattern | Example | Grammar Rule | Purpose |
|------|----------|---------|---------|---------------|---------|
| **Job** | `jobs/{Action}Job.ts` | `{Verb}{Noun}Job` | `SendEmailJob.ts` | Action + Job suffix | Executable work unit |
| **Queue** | `queues/{entity}Queue.ts` | `{Noun}Queue` | `EmailQueue.ts` | Entity + Queue suffix | Job organization |
| **Worker** | `workers/{Purpose}Worker.ts` | `{Noun}Worker` | `EmailWorker.ts` | Purpose + Worker suffix | Job processor |
| **Cron** | `cron/{schedule}_{task}.ts` | Schedule + task | `daily_cleanup.ts` | Time + action pattern | Scheduled tasks |

**Job Grammar Examples**:

```typescript
// Job Class Grammar: Action + Job
class SendEmailJob {
  // Job properties: data needed for execution
  constructor(
    public readonly to: string,
    public readonly subject: string, 
    public readonly body: string,
    public readonly priority: 'high' | 'normal' | 'low' = 'normal'
  ) {}
  
  // Execute method: Grammar rule for job execution
  async execute(): Promise<void> {
    await this.sendEmail();
    await this.trackDelivery();
  }
  
  // Retry logic: handle prefix for error handling
  async handleFailure(error: Error): Promise<void> {
    await this.logError(error);
    if (this.shouldRetry(error)) {
      throw error; // Will trigger automatic retry
    }
  }
}

// Queue Grammar: Entity + Queue  
class EmailQueue {
  // Queue methods: action verbs for queue operations
  async enqueueEmail(job: SendEmailJob): Promise<void>       // Add to queue
  async dequeueNext(): Promise<SendEmailJob | null>          // Get next job
  async processJob(job: SendEmailJob): Promise<void>         // Execute job
  async retryFailedJob(jobId: string): Promise<void>         // Retry logic
  async clearQueue(): Promise<void>                          // Queue management
}

// Cron Job Grammar: schedule_action.ts
// daily_cleanup.ts
export async function dailyCleanup(): Promise<void> {
  await cleanExpiredSessions();
  await removeOldLogs();  
  await optimizeDatabaseIndexes();
}

// weekly_reports.ts  
export async function weeklyReports(): Promise<void> {
  await generateUserActivityReport();
  await sendAdminSummary();
}
```

## 🛠️ CLI/Scripts Layer Grammar - Command Line Tools (Lines 165-173)

### Command Line Grammar

**CLI Tool Classification**:

| Type | Location | Pattern | Example | Grammar Rule | Purpose |
|------|----------|---------|---------|---------------|---------|
| **CLI** | `cli/{command}.ts` | Verb-noun | `generate-report.ts` | Action-target pattern | User-facing commands |
| **Script** | `scripts/{action}-{target}.ts` | Action-target | `migrate-database.ts` | Action-target pattern | Development automation |
| **Bin** | `bin/{tool}` | Single word | `bin/deploy` | Tool name only | Executable entry points |
| **Task** | `tasks/{verb}{noun}.ts` | VerbNoun | `tasks/cleanCache.ts` | camelCase action | Build system tasks |

**CLI Grammar Examples**:

```typescript
// CLI Command Grammar: verb-noun.ts
// cli/generate-report.ts
export class GenerateReportCommand {
  // Command properties: descriptive names
  name = 'generate-report'
  description = 'Generate analytics report for specified date range'
  
  // Arguments: noun-based naming
  arguments = [
    { name: 'reportType', required: true },
    { name: 'startDate', required: true },
    { name: 'endDate', required: false }
  ]
  
  // Options: feature-based naming
  options = [
    { name: 'format', choices: ['json', 'csv', 'pdf'] },
    { name: 'output', description: 'Output file path' }
  ]
  
  // Execute method: standard execution pattern
  async execute(args: any, options: any): Promise<void> {
    await this.validateInput(args, options);
    const report = await this.generateReport(args.reportType, args.startDate, args.endDate);
    await this.saveReport(report, options.output, options.format);
  }
}

// Script Grammar: action-target.ts
// scripts/migrate-database.ts
export async function migrateDatabase(): Promise<void> {
  console.log('Starting database migration...');
  await runMigrations();
  await seedInitialData();
  console.log('Database migration completed.');
}

// scripts/deploy-production.ts
export async function deployProduction(): Promise<void> {
  await buildApplication();
  await runTests();
  await uploadAssets();
  await updateServerConfiguration();
  await restartServices();
}
```

## 📚 Complete Verb Taxonomy - Full Stack Actions (Lines 175-203)

### Comprehensive Action Verb Classification

```typescript
const fullStackVerbTaxonomy = {
  // Frontend-Specific Verbs (UI/UX Actions)
  render: ['render', 'display', 'show', 'paint', 'draw', 'present'],
  interact: ['click', 'hover', 'focus', 'blur', 'scroll', 'drag', 'drop'],
  animate: ['animate', 'transition', 'fade', 'slide', 'bounce', 'rotate'],
  navigate: ['route', 'redirect', 'navigate', 'pushState', 'replaceState'],
  
  // Backend-Specific Verbs (Server Actions)
  serve: ['serve', 'handle', 'process', 'route', 'forward', 'proxy'],
  auth: ['authenticate', 'authorize', 'login', 'logout', 'verify', 'validate'],
  middleware: ['intercept', 'transform', 'filter', 'parse', 'serialize'],
  
  // Database-Specific Verbs (Data Operations)
  query: ['select', 'insert', 'update', 'delete', 'upsert', 'merge'],
  schema: ['migrate', 'rollback', 'seed', 'truncate', 'backup', 'restore'],
  transaction: ['begin', 'commit', 'rollback', 'savepoint', 'release'],
  
  // API-Specific Verbs (HTTP Operations)
  http: ['get', 'post', 'put', 'patch', 'delete', 'head', 'options'],
  response: ['respond', 'return', 'send', 'stream', 'redirect', 'error'],
  
  // Queue/Job-Specific Verbs (Async Processing)
  queue: ['enqueue', 'dequeue', 'process', 'retry', 'fail', 'complete'],
  schedule: ['schedule', 'cron', 'delay', 'throttle', 'debounce'],
  
  // Infrastructure Verbs (DevOps Actions)
  deploy: ['deploy', 'rollout', 'scale', 'provision', 'terminate', 'restart'],
  monitor: ['monitor', 'track', 'alert', 'log', 'trace', 'profile'],
  
  // Testing Verbs (Quality Assurance)
  test: ['test', 'assert', 'expect', 'mock', 'stub', 'spy'],
  verify: ['verify', 'validate', 'check', 'ensure', 'confirm'],
  
  // File System Verbs (File Operations)
  file: ['read', 'write', 'append', 'copy', 'move', 'delete', 'watch'],
  directory: ['create', 'remove', 'list', 'scan', 'traverse'],
  
  // Security Verbs (Protection Actions)
  secure: ['encrypt', 'decrypt', 'hash', 'salt', 'sign', 'verify'],
  access: ['grant', 'deny', 'revoke', 'check', 'audit', 'restrict'],
  
  // Communication Verbs (External Integration)
  notify: ['notify', 'alert', 'message', 'broadcast', 'publish'],
  integrate: ['connect', 'sync', 'import', 'export', 'webhook']
}
```

**Verb Grammar Rules**:
- **Context-specific verbs**: Each layer has preferred action words
- **Consistent tense**: Always present tense for functions (`create` not `creates`)
- **Specific over generic**: `authenticate` over `check` for auth operations
- **Layer appropriate**: Database verbs in database layer, UI verbs in frontend

## 📁 Complete File Extension Grammar (Lines 205-246)

### Universal File Type Classification

**Frontend Extensions**:
```yaml
Components & Logic:
  .tsx     # React components with TypeScript
  .ts      # TypeScript logic files
  .js      # JavaScript (legacy support)
  .jsx     # React components (legacy)

Styling:
  .css     # Standard stylesheets
  .scss    # Sass preprocessor
  .less    # Less preprocessor
  .styled  # Styled-components

Markup & Assets:
  .html    # HTML templates
  .svg     # Vector graphics
  .png/.jpg # Raster images
  .ico     # Favicons
```

**Backend Extensions**:
```yaml
Server Code:
  .ts      # TypeScript services
  .js      # Node.js files
  .mjs     # ES modules
  .cjs     # CommonJS modules

Configuration:
  .json    # Config/data files
  .yaml/.yml # Configuration files
  .toml    # Configuration format
  .ini     # Legacy config format
```

**Database Extensions**:
```yaml
Database Files:
  .sql     # SQL queries/schemas
  .prisma  # Prisma schema
  .graphql # GraphQL schemas
  .mongodb # MongoDB scripts
```

**Infrastructure Extensions**:
```yaml
DevOps & Deployment:
  .dockerfile  # Docker container config
  .yml/.yaml   # CI/CD, Kubernetes
  .tf          # Terraform infrastructure
  .sh          # Shell scripts
  .ps1         # PowerShell scripts

Environment:
  .env         # Environment variables
  .env.local   # Local overrides
  .env.example # Template file
```

**Documentation Extensions**:
```yaml
Documentation:
  .md      # Markdown documentation
  .mdx     # MDX (Markdown + JSX)
  .rst     # reStructuredText
  .adoc    # AsciiDoc
```

## 🔄 Cross-Layer Communication Rules - Universal Patterns (Lines 248-273)

### Complete Import Hierarchy (Lines 250-263)

**Universal Dependency Flow**:
```
Pages/Routes (Application Entry)
    ↓ Can import from all layers below
Features/Controllers (Business Features)  
    ↓ Can import from service layers below
Services/UseCases (Business Logic)
    ↓ Can import from data layers below
Models/Repositories (Data Access)
    ↓ Can import from infrastructure below
Database/External APIs (Data Sources)
    ↓ Can import from utilities only
Utils/Helpers (Pure Functions)
    ↓ Cannot import from any application layer
```

**Critical Grammar Rules**:
- **Downward dependencies only**: Higher layers can import lower layers
- **No circular imports**: Layers cannot import from higher layers
- **Utility layer independence**: Utils cannot import business logic
- **External boundary respect**: Database layer handles all external communication

### Cross-Layer Naming Consistency (Lines 265-273)

**Complete Layer Communication Grammar**:

| Layer | Receives (Input) | Returns (Output) | Named As | Grammar Pattern |
|-------|------------------|------------------|----------|-----------------|
| **Route** | HTTP Request | HTTP Response | `/api/users` | RESTful URL pattern |
| **Controller** | Request DTO | Response ViewModel | `UserController.index()` | Controller + action method |
| **Service** | Business Entity | Business Entity | `UserService.findById()` | Service + business action |
| **Repository** | Query Parameters | Domain Model | `UserRepository.findOne()` | Repository + data action |
| **Database** | SQL Query | Raw Data Rows | `SELECT * FROM users` | SQL statement |

**Data Transformation Grammar**:
```typescript
// Request → DTO → Entity → Model → Database
HTTP Request 
  ↓ Transform to DTO (Data Transfer Object)
CreateUserRequest 
  ↓ Transform to Entity (Business Object)  
User Entity
  ↓ Transform to Model (Database Object)
UserModel
  ↓ Transform to SQL
INSERT INTO users (...)

// Database → Model → Entity → ViewModel → Response  
Raw Database Rows
  ↓ Transform to Model
UserModel
  ↓ Transform to Entity  
User Entity
  ↓ Transform to ViewModel
UserViewModel
  ↓ Transform to Response
HTTP Response JSON
```

## 🏗️ Complete Application Example - Grammar in Action (Lines 274-309)

### Full Stack User Feature Architecture

**Complete File Structure with Grammar Compliance**:

```
project-root/
├── frontend/src/
│   ├── pages/
│   │   └── UsersPage.tsx                    # Page layer (entry point)
│   ├── features/user/
│   │   ├── components/
│   │   │   ├── UserList.tsx                # Feature component (display)
│   │   │   ├── UserForm.tsx                # Feature component (input)
│   │   │   └── UserCard.tsx                # Feature component (item)
│   │   ├── hooks/
│   │   │   ├── useUsers.ts                 # State management hook
│   │   │   ├── useUserForm.ts              # Form management hook
│   │   │   └── useUserValidation.ts        # Validation hook
│   │   └── types/
│   │       └── UserTypes.ts                # TypeScript definitions
│   ├── services/
│   │   └── UserService.ts                   # Frontend API client
│   └── utils/
│       └── userUtils.ts                     # Pure utility functions
│
├── backend/src/
│   ├── routes/
│   │   └── users.ts                         # RESTful API routes
│   ├── controllers/
│   │   └── UserController.ts                # Request/response handling
│   ├── services/
│   │   ├── UserService.ts                   # Business logic
│   │   └── EmailService.ts                  # Supporting service
│   ├── repositories/
│   │   └── UserRepository.ts                # Data access layer
│   ├── models/
│   │   └── User.ts                          # Data model/entity
│   ├── validators/
│   │   └── userValidator.ts                 # Input validation
│   ├── middleware/
│   │   ├── authMiddleware.ts                # Authentication
│   │   └── validationMiddleware.ts          # Request validation
│   └── utils/
│       └── passwordUtils.ts                 # Utility functions
│
├── database/
│   ├── migrations/
│   │   ├── 20240121_create_users_table.sql # Table creation
│   │   └── 20240122_add_user_indexes.sql   # Performance optimization
│   ├── seeds/
│   │   └── 01_initial_users.sql            # Test data
│   ├── queries/
│   │   ├── get_active_users.sql            # Complex queries
│   │   └── user_statistics.sql             # Reporting queries
│   └── procedures/
│       └── sp_user_cleanup.sql             # Stored procedures
│
├── tests/
│   ├── unit/
│   │   ├── UserService.test.ts             # Service unit tests
│   │   └── userUtils.test.ts               # Utility unit tests
│   ├── integration/
│   │   └── user-api.test.ts                # API integration tests
│   ├── e2e/
│   │   └── user-registration.e2e.ts        # End-to-end tests
│   ├── fixtures/
│   │   └── users.fixture.ts                # Test data
│   └── mocks/
│       └── database.mock.ts                # Mock implementations
│
├── infrastructure/
│   ├── docker/
│   │   ├── Dockerfile                      # Container definition
│   │   └── docker-compose.yml              # Multi-service setup
│   ├── k8s/
│   │   ├── api-deployment.yaml             # Kubernetes deployment
│   │   └── database-service.yaml           # Database service
│   ├── terraform/
│   │   ├── database.tf                     # Database infrastructure
│   │   └── networking.tf                   # Network configuration
│   └── scripts/
│       ├── deploy-production.sh            # Deployment script
│       └── migrate-database.sh             # Migration script
│
├── docs/
│   ├── api/
│   │   └── user-endpoints.md               # API documentation
│   ├── database/
│   │   └── user-schema.md                  # Database schema docs
│   └── guides/
│       └── user-management.md              # Feature documentation
│
└── .github/workflows/
    ├── test-pull-request.yml               # PR validation
    ├── deploy-staging.yml                  # Staging deployment
    └── deploy-production.yml               # Production deployment
```

## 🎯 Universal Grammar Benefits - Complete System Impact (Lines 311-319)

### Revolutionary Development Transformation

**Grammar System Coverage Achieved**:
- ✅ **Frontend** (React, CSS, HTML) - Component architecture with styling contracts
- ✅ **Backend** (Node, Express, APIs) - RESTful patterns with service layers  
- ✅ **Database** (SQL, Migrations, Models) - Consistent schema and query patterns
- ✅ **Infrastructure** (Docker, CI/CD) - Standardized DevOps configurations
- ✅ **Testing** (Unit, Integration, E2E) - Comprehensive testing grammar
- ✅ **Jobs/Queues** - Background processing patterns
- ✅ **All File Extensions** - Universal file type classification
- ✅ **Cross-Layer Communication** - Standardized interaction patterns

### The Complete Grammar System Impact

**For Language Models**:
- **Universal Language**: Every technology layer follows same grammatical patterns
- **Predictable Generation**: LLMs can generate any layer using consistent rules
- **Context Awareness**: Grammar rules indicate proper layer and dependency usage
- **Error Prevention**: Invalid patterns become grammatically incorrect

**For Development Teams**:
- **Consistent Patterns**: Same naming conventions across entire technology stack
- **Faster Onboarding**: Universal grammar reduces learning curve
- **Architectural Clarity**: File organization follows predictable patterns
- **Maintenance Efficiency**: Consistent structure simplifies debugging and updates

**For Codebase Quality**:
- **Self-Documenting**: Grammar rules make code purpose immediately clear
- **Dependency Management**: Import hierarchies prevent architectural violations
- **Scalable Structure**: Patterns work for any application size
- **Technology Agnostic**: Grammar principles apply regardless of specific tools

## 🔗 Cross-References & Integration

### This System Connects To:
- **Component Architecture**: `/01-architecture/component-layers/` - Frontend layer patterns
- **Naming Rules**: `/02-grammar/naming-system/` - Universal naming conventions
- **LLM Directives**: `/01-architecture/metadata-system/` - File metadata requirements
- **Style Contract**: `/01-architecture/styling-system/` - CSS integration patterns

### This System Enables:
- **Full Stack AI Development**: LLMs can generate complete applications
- **Universal Code Review**: Same standards across all technology layers
- **Automated Architecture Validation**: Grammar rules enable automated checking
- **Technology Migration**: Consistent patterns ease technology transitions

### Dependencies:
- **Universal Metadata Standard**: All files need grammatical metadata
- **Build Tool Integration**: Grammar validation in development pipeline
- **Team Training**: Development teams must understand full grammar system
- **Tool Support**: IDEs and development tools must support grammar checking

This creates a **complete development language** where every aspect of application development - from database schemas to deployment scripts - follows consistent grammatical patterns that both humans and AI can understand and apply reliably.