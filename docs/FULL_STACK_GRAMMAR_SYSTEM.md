# Full Stack Grammar System - Complete Language

## Coverage Areas
- **Frontend**: React, TypeScript, CSS, HTML
- **Backend**: Node.js, Express, API routes, Services
- **Database**: SQL, Migrations, Models, Schemas
- **Infrastructure**: Docker, CI/CD, Config, Scripts
- **Testing**: Unit, Integration, E2E, Fixtures
- **Documentation**: Markdown, Stories, API docs

## 1. Database Layer Grammar

### SQL Files
| File Type | Location | Pattern | Example |
|-----------|----------|---------|---------|
| **Migration** | `migrations/` | `{timestamp}_{action}_{target}.sql` | `20240121_create_users_table.sql` |
| **Seed** | `seeds/` | `{order}_{name}.sql` | `01_initial_users.sql` |
| **Query** | `queries/` | `{action}_{entity}.sql` | `get_active_users.sql` |
| **Schema** | `schema/` | `{entity}_schema.sql` | `users_schema.sql` |
| **Procedure** | `procedures/` | `sp_{action}_{entity}.sql` | `sp_update_user_status.sql` |
| **View** | `views/` | `vw_{entity}_{purpose}.sql` | `vw_users_summary.sql` |
| **Index** | `indexes/` | `idx_{table}_{columns}.sql` | `idx_users_email.sql` |

### SQL Naming Conventions
```sql
-- Tables: plural, snake_case
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email_address VARCHAR(255),
    created_at TIMESTAMP
);

-- Columns: snake_case, descriptive
-- Primary keys: {table_singular}_id
-- Foreign keys: {related_table_singular}_id
-- Timestamps: created_at, updated_at, deleted_at

-- Indexes: idx_{table}_{column(s)}
CREATE INDEX idx_users_email ON users(email_address);

-- Constraints: {table}_{type}_{columns}
ALTER TABLE users ADD CONSTRAINT users_unique_email UNIQUE(email_address);
```

## 2. Backend API Layer

### Route Files
| Pattern | Location | Example | Verbs |
|---------|----------|---------|-------|
| **RESTful Routes** | `routes/{resource}.ts` | `routes/users.ts` | GET, POST, PUT, DELETE |
| **Controller** | `controllers/{Resource}Controller.ts` | `UserController.ts` | index, show, create, update, destroy |
| **Middleware** | `middleware/{purpose}Middleware.ts` | `authMiddleware.ts` | validate, authenticate, log |
| **Validator** | `validators/{resource}Validator.ts` | `userValidator.ts` | validate{Field}, check{Condition} |

### API Naming Patterns
```typescript
// RESTful endpoints
GET    /api/users          // getUsers, listUsers, indexUsers
GET    /api/users/:id      // getUser, showUser, findUserById
POST   /api/users          // createUser, storeUser
PUT    /api/users/:id      // updateUser, modifyUser
DELETE /api/users/:id      // deleteUser, removeUser, destroyUser

// Action endpoints
POST   /api/users/:id/activate    // activateUser
POST   /api/users/:id/reset-password  // resetUserPassword
GET    /api/users/:id/permissions     // getUserPermissions
```

## 3. Model/ORM Layer

### Model Files
| ORM | Location | Pattern | Example |
|-----|----------|---------|---------|
| **Prisma** | `prisma/schema.prisma` | PascalCase models | `model User {}` |
| **TypeORM** | `entities/{Entity}.ts` | `@Entity() class User` | `User.entity.ts` |
| **Sequelize** | `models/{Model}.js` | `class User extends Model` | `User.model.js` |
| **Mongoose** | `models/{Model}.ts` | `{Model}Schema` | `UserSchema.ts` |

### Model Naming
```typescript
// Entity/Model: Singular PascalCase
class User extends Model {
  // Properties: camelCase in code
  firstName: string
  emailAddress: string
  isActive: boolean
  
  // Relations: singular/plural based on cardinality
  profile: Profile        // has one
  posts: Post[]          // has many
  roles: Role[]          // many to many
}

// Repository pattern
class UserRepository {
  findById(id: string): Promise<User>
  findByEmail(email: string): Promise<User>
  createUser(data: CreateUserDto): Promise<User>
  updateUser(id: string, data: UpdateUserDto): Promise<User>
}
```

## 4. Service Layer

### Business Logic
| Type | Location | Pattern | Example |
|------|----------|---------|---------|
| **Service** | `services/{Domain}Service.ts` | Class with methods | `AuthService.ts` |
| **UseCase** | `usecases/{Action}{Entity}.ts` | Single responsibility | `CreateUserUseCase.ts` |
| **Domain** | `domain/{entity}/` | DDD structure | `domain/user/UserAggregate.ts` |
| **Repository** | `repositories/{Entity}Repository.ts` | Data access | `UserRepository.ts` |

## 5. Infrastructure Layer

### Config & DevOps
| File Type | Location | Pattern | Purpose |
|-----------|----------|---------|---------|
| **Docker** | `Dockerfile`, `docker-compose.yml` | Lowercase | Container config |
| **CI/CD** | `.github/workflows/*.yml` | `{action}-{target}.yml` | `deploy-production.yml` |
| **Terraform** | `infrastructure/*.tf` | `{resource}.tf` | `database.tf` |
| **K8s** | `k8s/*.yaml` | `{resource}-{type}.yaml` | `api-deployment.yaml` |
| **Env** | `.env`, `.env.example` | UPPER_SNAKE vars | `DATABASE_URL` |

## 6. Testing Layer

### Test Files
| Type | Location | Pattern | Example |
|------|----------|---------|---------|
| **Unit** | `{file}.test.ts` | Next to source | `UserService.test.ts` |
| **Integration** | `tests/integration/` | `{feature}.test.ts` | `auth-flow.test.ts` |
| **E2E** | `tests/e2e/` | `{flow}.e2e.ts` | `user-registration.e2e.ts` |
| **Fixtures** | `tests/fixtures/` | `{entity}.fixture.ts` | `users.fixture.ts` |
| **Mocks** | `tests/mocks/` | `{service}.mock.ts` | `database.mock.ts` |

### Test Naming
```typescript
// Test suites: Describe what is being tested
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user with valid data')
    it('should hash the password before saving')
    it('should throw error if email already exists')
  })
})

// E2E: User stories
describe('User Registration Flow', () => {
  it('allows new users to sign up with email')
  it('sends confirmation email after registration')
  it('prevents duplicate email registration')
})
```

## 7. Job/Queue Layer

### Background Jobs
| Type | Location | Pattern | Example |
|------|----------|---------|---------|
| **Job** | `jobs/{Action}Job.ts` | `{Verb}{Noun}Job` | `SendEmailJob.ts` |
| **Queue** | `queues/{entity}Queue.ts` | `{Noun}Queue` | `EmailQueue.ts` |
| **Worker** | `workers/{Purpose}Worker.ts` | `{Noun}Worker` | `EmailWorker.ts` |
| **Cron** | `cron/{schedule}_{task}.ts` | Schedule + task | `daily_cleanup.ts` |

## 8. CLI/Scripts Layer

### Command Line Tools
| Type | Location | Pattern | Example |
|------|----------|---------|---------|
| **CLI** | `cli/{command}.ts` | Verb-noun | `generate-report.ts` |
| **Script** | `scripts/{action}-{target}.ts` | Action-target | `migrate-database.ts` |
| **Bin** | `bin/{tool}` | Single word | `bin/deploy` |
| **Task** | `tasks/{verb}{noun}.ts` | VerbNoun | `tasks/cleanCache.ts` |

## 9. Complete Verb Taxonomy

```typescript
const fullStackVerbs = {
  // Frontend specific
  render: ['render', 'display', 'show', 'paint', 'draw'],
  interact: ['click', 'hover', 'focus', 'blur', 'scroll'],
  animate: ['animate', 'transition', 'fade', 'slide', 'bounce'],
  
  // Backend specific
  serve: ['serve', 'handle', 'process', 'route', 'forward'],
  auth: ['authenticate', 'authorize', 'login', 'logout', 'verify'],
  
  // Database specific
  query: ['select', 'insert', 'update', 'delete', 'upsert'],
  migrate: ['migrate', 'rollback', 'seed', 'truncate'],
  
  // API specific
  http: ['get', 'post', 'put', 'patch', 'delete', 'head', 'options'],
  
  // Queue/Job specific
  queue: ['enqueue', 'dequeue', 'process', 'retry', 'fail'],
  schedule: ['schedule', 'cron', 'delay', 'throttle'],
  
  // Infrastructure
  deploy: ['deploy', 'rollout', 'scale', 'provision', 'terminate'],
  monitor: ['monitor', 'track', 'alert', 'log', 'trace']
}
```

## 10. File Extension Complete List

```yaml
Frontend:
  - .tsx    # React components
  - .ts     # TypeScript logic
  - .js     # JavaScript (legacy)
  - .jsx    # React (legacy)
  - .css    # Styles
  - .scss   # Sass styles
  - .html   # Markup
  - .svg    # Vector graphics

Backend:
  - .ts     # TypeScript services
  - .js     # Node.js files
  - .mjs    # ES modules
  - .cjs    # CommonJS modules
  - .json   # Config/data

Database:
  - .sql    # SQL queries/schemas
  - .prisma # Prisma schema
  - .graphql # GraphQL schema

Infrastructure:
  - .yml/.yaml  # CI/CD, K8s
  - .tf         # Terraform
  - .sh         # Shell scripts
  - .dockerfile # Docker

Config:
  - .env        # Environment
  - .json       # Settings
  - .toml       # Rust/Python
  - .ini        # Legacy config

Docs:
  - .md         # Markdown
  - .mdx        # MDX
  - .rst        # reStructuredText
```

## 11. Cross-Layer Communication Rules

### Import Hierarchy (Top to Bottom)
```
Pages/Routes
    ↓
Features/Controllers
    ↓
Services/UseCases
    ↓
Models/Repositories
    ↓
Database/External APIs
    ↓
Utils/Helpers
```

### Naming Across Layers
| Layer | Receives | Returns | Named As |
|-------|----------|---------|----------|
| **Route** | Request | Response | `/api/users` |
| **Controller** | DTO | ViewModel | `UserController.index()` |
| **Service** | Entity | Entity | `UserService.findById()` |
| **Repository** | Query | Model | `UserRepository.findOne()` |
| **Database** | SQL | Rows | `SELECT * FROM users` |

## 12. Full Stack File Examples

### Complete User Feature
```
src/
├── pages/
│   └── UsersPage.tsx                    # Frontend entry
├── features/user/
│   ├── components/
│   │   ├── UserList.tsx                # Display component
│   │   └── UserForm.tsx                # Input component
│   └── hooks/
│       └── useUsers.ts                  # State management
├── services/
│   └── UserService.ts                   # Frontend API calls
│
server/
├── routes/
│   └── users.ts                         # API routes
├── controllers/
│   └── UserController.ts                # Request handling
├── services/
│   └── UserService.ts                   # Business logic
├── repositories/
│   └── UserRepository.ts                # Data access
├── models/
│   └── User.ts                          # Data model
│
database/
├── migrations/
│   └── 20240121_create_users_table.sql # Schema
├── seeds/
│   └── 01_initial_users.sql            # Test data
└── queries/
    └── get_active_users.sql            # Complex queries
```

This is now a COMPLETE grammar system covering:
- ✅ Frontend (React, CSS, HTML)
- ✅ Backend (Node, Express, APIs)
- ✅ Database (SQL, Migrations, Models)
- ✅ Infrastructure (Docker, CI/CD)
- ✅ Testing (Unit, Integration, E2E)
- ✅ Jobs/Queues
- ✅ All file extensions
- ✅ Cross-layer communication