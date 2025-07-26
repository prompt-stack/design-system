# Security Grammar Overlay for Grammar Ops

## Executive Summary

Security becomes a first-class grammatical concern in Grammar Ops through:
- **Security Verb Taxonomy**: `validate`, `sanitize`, `authorize`, `authenticate`, `encrypt`
- **Security-First Naming**: Functions explicitly declare security intent
- **Layered Security Grammar**: Each architectural layer has security responsibilities
- **Automated Security Auditing**: Grammar patterns enforce security practices
- **LLM Security Directives**: AI understands and respects security boundaries

## Core Security Grammar

### Security Verb Taxonomy

```typescript
const securityVerbs = {
  authentication: ['authenticate', 'login', 'logout', 'verify', 'challenge'],
  authorization: ['authorize', 'permit', 'deny', 'grant', 'revoke'],
  validation: ['validate', 'verify', 'check', 'ensure', 'assert'],
  sanitization: ['sanitize', 'escape', 'clean', 'filter', 'purify'],
  encryption: ['encrypt', 'decrypt', 'hash', 'sign', 'mask'],
  monitoring: ['audit', 'log', 'track', 'monitor', 'alert']
};
```

### Security Naming Patterns

```typescript
// ✅ GOOD: Security intent is explicit
validateUserInput(data: unknown): ValidationResult
sanitizeHtmlContent(html: string): SafeHtml
authorizeResourceAccess(user: User, resource: Resource): boolean
encryptSensitiveData(data: string): EncryptedData
auditSecurityEvent(event: SecurityEvent): void

// ❌ BAD: Security intent is ambiguous
checkData(data: unknown): boolean
cleanHtml(html: string): string
canAccess(user: User, resource: Resource): boolean
processData(data: string): string
logEvent(event: Event): void
```

## Security Layer Architecture

### 1. Primitive Layer (Defense Foundation)
```typescript
/**
 * @file components/primitives/SecureInput
 * @purpose Sanitized input with XSS prevention
 * @layer primitive
 * @security-level high
 * @security-features ["input-sanitization", "xss-prevention"]
 */

// Security primitives provide base defense
export function SecureInput({ value, onChange, ...props }: SecureInputProps) {
  const sanitizedValue = useMemo(() => sanitizeUserInput(value), [value]);
  
  const handleSecureChange = useCallback((e: ChangeEvent) => {
    const cleaned = sanitizeUserInput(e.target.value);
    onChange(cleaned);
  }, [onChange]);
  
  return <input {...props} value={sanitizedValue} onChange={handleSecureChange} />;
}
```

### 2. Composed Layer (Security Orchestration)
```typescript
/**
 * @file components/composed/AuthorizedDataTable
 * @purpose Data table with row-level authorization
 * @layer composed
 * @security-level high
 * @security-features ["rbac", "data-filtering"]
 */

export function AuthorizedDataTable({ data, userRole }: Props) {
  // Composed security: authorization + sanitization
  const authorizedData = useAuthorizedData(data, userRole);
  const sanitizedData = useSanitizedTableData(authorizedData);
  
  return <DataTable data={sanitizedData} />;
}
```

### 3. Feature Layer (Security Policy)
```typescript
/**
 * @file features/user-management/UserDashboard
 * @purpose User management with complete security
 * @layer feature
 * @security-level critical
 * @security-features ["authentication", "authorization", "audit-logging"]
 */

export function UserDashboard() {
  const { user, permissions } = useAuthentication();
  const auditLog = useAuditLogger('user-dashboard');
  
  // Feature-level security orchestration
  if (!authenticateUserSession(user)) {
    auditLog.recordUnauthorizedAccess();
    return <Redirect to="/login" />;
  }
  
  if (!authorizeFeatureAccess(permissions, 'user-management')) {
    auditLog.recordInsufficientPermissions();
    return <AccessDenied />;
  }
  
  return <SecureUserManagement user={user} />;
}
```

## Security Metadata Standards

### Required Security Metadata
```typescript
/**
 * @file services/payment-processor
 * @purpose Handle payment transactions securely
 * @security-level critical
 * @security-features ["pci-compliance", "encryption", "tokenization"]
 * @security-audit required
 * @security-review 2024-07-15
 * @threat-model payment-processing-v2
 */
```

### Security Classification Levels
```typescript
// @security-level public      - No security concerns
// @security-level internal    - Internal use only
// @security-level sensitive   - Contains PII or sensitive data
// @security-level critical    - Payment, auth, or infrastructure
// @security-level restricted  - Requires special authorization
```

## Security Grammar Rules

### 1. Input Validation Grammar
```typescript
// Rule: All external inputs must use validate prefix
validateEmailInput(email: string): ValidatedEmail
validatePhoneNumber(phone: string): ValidatedPhone
validateApiPayload<T>(payload: unknown): ValidatedPayload<T>

// Anti-pattern detection
processUserInput(input: string) // ❌ Missing validation verb
```

### 2. Output Sanitization Grammar
```typescript
// Rule: All outputs must be explicitly sanitized
sanitizeForHtml(content: string): SafeHtml
sanitizeForSql(query: string): SafeQuery
sanitizeForLog(message: string): SafeLogMessage

// Grammar enforcement
renderUserContent(content: string) // ❌ Missing sanitization
```

### 3. Authorization Grammar
```typescript
// Rule: Resource access requires authorize verb
authorizeUserAction(user: User, action: Action): AuthResult
authorizeDataAccess(user: User, data: Data[]): Data[]
authorizeApiEndpoint(token: Token, endpoint: string): boolean

// Pattern matching
canUserEdit(user: User) // ❌ Should be authorizeUserEdit
```

## Security Test Grammar

### Security Test Patterns
```typescript
describe('SecurityFeature', () => {
  describe('authentication', () => {
    it('should reject invalid credentials', () => {});
    it('should prevent brute force attacks', () => {});
    it('should expire sessions after timeout', () => {});
  });
  
  describe('authorization', () => {
    it('should enforce role-based access', () => {});
    it('should deny unauthorized resource access', () => {});
    it('should log authorization failures', () => {});
  });
  
  describe('input validation', () => {
    it('should reject malicious inputs', () => {});
    it('should sanitize special characters', () => {});
    it('should prevent injection attacks', () => {});
  });
});
```

### Security Test Templates
```typescript
// SQL Injection Test Template
it('should prevent SQL injection in ${paramName}', () => {
  const maliciousInputs = [
    "'; DROP TABLE users; --",
    "1' OR '1'='1",
    "admin'--"
  ];
  
  maliciousInputs.forEach(input => {
    expect(() => validateSqlParameter(input)).toThrow(ValidationError);
  });
});

// XSS Prevention Template
it('should prevent XSS in ${fieldName}', () => {
  const xssPayloads = [
    '<script>alert("XSS")</script>',
    '<img src=x onerror=alert("XSS")>',
    'javascript:alert("XSS")'
  ];
  
  xssPayloads.forEach(payload => {
    const sanitized = sanitizeHtmlContent(payload);
    expect(sanitized).not.toContain('<script>');
    expect(sanitized).not.toContain('javascript:');
  });
});
```

## LLM Security Directives

### Security-Aware LLM Permissions
```typescript
/**
 * @llm-security-context critical
 * @llm-security-review required
 * @llm-security-capabilities ["read-only", "suggest-patterns"]
 * @llm-security-restrictions ["no-secret-generation", "no-auth-bypass"]
 */
```

### LLM Security Rules
```json
{
  "llmSecurityDirectives": {
    "forbiddenPatterns": [
      "hardcoded passwords",
      "disabled security checks",
      "bypassed authentication",
      "exposed secrets",
      "unsafe deserialization"
    ],
    "requiredPatterns": {
      "authentication": ["validate session", "check expiry"],
      "authorization": ["verify permissions", "check roles"],
      "validation": ["sanitize inputs", "validate types"]
    }
  }
}
```

## Security Audit Grammar

### Automated Security Checks
```bash
# Security-specific audit scripts
./audit-security-patterns.sh     # Check security verb usage
./audit-input-validation.sh      # Verify all inputs validated
./audit-authentication-flow.sh   # Analyze auth patterns
./audit-sensitive-data.sh        # Find exposed secrets
```

### Security Compliance Scoring
```typescript
interface SecurityAuditResult {
  score: number;                    // 0-100
  vulnerabilities: {
    critical: SecurityIssue[];      // Must fix immediately
    high: SecurityIssue[];          // Fix before release
    medium: SecurityIssue[];        // Fix within sprint
    low: SecurityIssue[];           // Track for future
  };
  patterns: {
    authentication: ComplianceScore;
    authorization: ComplianceScore;
    validation: ComplianceScore;
    sanitization: ComplianceScore;
    encryption: ComplianceScore;
  };
}
```

## Security Grammar Implementation

### Phase 1: Foundation (Weeks 1-2)
- Add security verb taxonomy to grammar rules
- Create security metadata standards
- Implement basic security audit scripts

### Phase 2: Integration (Weeks 3-4)
- Update existing code with security verbs
- Add security test templates
- Enable LLM security directives

### Phase 3: Enforcement (Weeks 5-6)
- Enable security grammar validation
- Set compliance thresholds
- Integrate with CI/CD pipeline

### Phase 4: Maturation (Ongoing)
- Refine security patterns based on findings
- Expand threat model coverage
- Improve automated detection

## Security Grammar Benefits

### For Developers
- **Clear Security Intent**: Function names declare security purpose
- **Consistent Patterns**: Same security patterns everywhere
- **Automated Guidance**: Grammar rules prevent mistakes
- **Security by Design**: Security built into naming

### For Security Teams
- **Automated Auditing**: Grammar patterns enable scanning
- **Compliance Tracking**: Measure security adoption
- **Risk Visibility**: Identify security gaps quickly
- **Policy Enforcement**: Grammar rules enforce standards

### For LLMs
- **Security Understanding**: AI recognizes security patterns
- **Safe Code Generation**: Follows security grammar
- **Threat Awareness**: Identifies potential vulnerabilities
- **Compliance Support**: Helps maintain standards

## Security Anti-Patterns to Detect

### 1. Ambiguous Security Functions
```typescript
// ❌ BAD: Unclear security intent
checkUser(user: User): boolean
processData(data: string): string
handleRequest(req: Request): Response

// ✅ GOOD: Explicit security intent
authenticateUser(user: User): AuthResult
sanitizeUserData(data: string): SafeData
authorizeRequest(req: Request): AuthorizedResponse
```

### 2. Missing Security Layers
```typescript
// ❌ BAD: Direct database access without authorization
async function getUserData(userId: string) {
  return await db.users.find(userId);
}

// ✅ GOOD: Layered security
async function getAuthorizedUserData(userId: string, requestor: User) {
  await authorizeDataAccess(requestor, userId);
  const data = await db.users.find(userId);
  return sanitizeUserData(data);
}
```

### 3. Incomplete Security Coverage
```typescript
// ❌ BAD: Validation without sanitization
function handleUserInput(input: string) {
  if (validateInput(input)) {
    return input; // Unescaped!
  }
}

// ✅ GOOD: Complete security pipeline
function handleSecureUserInput(input: string) {
  const validated = validateUserInput(input);
  const sanitized = sanitizeForStorage(validated);
  auditDataAccess('user-input', sanitized);
  return sanitized;
}
```

## Security Grammar Configuration

```json
{
  "grammar": {
    "verbTaxonomy": {
      "security": {
        "authentication": ["authenticate", "login", "logout", "verify"],
        "authorization": ["authorize", "permit", "deny", "grant"],
        "validation": ["validate", "verify", "check", "ensure"],
        "sanitization": ["sanitize", "escape", "clean", "filter"],
        "encryption": ["encrypt", "decrypt", "hash", "sign"],
        "monitoring": ["audit", "log", "track", "monitor"]
      }
    }
  },
  "security": {
    "requiredPatterns": {
      "userInput": "validate.*Input",
      "htmlOutput": "sanitize.*Html",
      "apiEndpoint": "authorize.*Endpoint",
      "sensitiveData": "encrypt.*Data"
    },
    "vulnerabilityScanning": {
      "sqlInjection": true,
      "xss": true,
      "csrf": true,
      "xxe": true,
      "idor": true
    },
    "complianceStandards": ["OWASP", "PCI-DSS", "GDPR"]
  }
}
```

## Conclusion

Security Grammar Overlay transforms security from a checklist into a living language that:
- Makes security intent explicit in every function name
- Enables automated security auditing through patterns
- Guides developers toward secure implementations
- Helps LLMs understand and maintain security boundaries

By making security a grammatical concern, we ensure that secure coding becomes as natural as proper naming—not an afterthought, but an integral part of how we express intent in code.