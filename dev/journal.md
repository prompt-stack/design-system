### “Junior‑Grade” vs “Senior‑Grade” Code

*A structured divergence guide*

| Dimension                    | **Senior‑grade (A‑level)**                                                                          | **Junior‑grade (C‑level)**                                                          | Why it matters                                                   |
| ---------------------------- | --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **Abstraction Boundaries**   | Small, cohesive units that expose a focused public API (e.g. `UserRepository` isolates all DB I/O). | “God” classes/functions that mix DB calls, business rules, & UI concerns.           | Clear seams lower coupling, simplify tests & refactors.          |
| **Layer Discipline**         | Components → hooks → services → repositories → DB (imports only downward).                          | UI files import SQL helpers, env vars, or global singletons directly.               | Violating the dependency graph makes reasoning & testing harder. |
| **Naming ↔ Behavior Parity** | `validatePayment` fully validates all fields, returns rich error enum.                              | `validatePayment` only checks “card number length > 0” or returns `true/false`.     | Accurate names create trustworthy mental models.                 |
| **Error Handling**           | Fine‑grained custom errors, typed results, retry/back‑off on transient faults.                      | Blanket `try/catch {}` or `console.error(e)` then continue.                         | Robustness & debuggability.                                      |
| **Edge‑Case Awareness**      | Null checks, empty lists, timeouts, overflow, concurrency races handled.                            | Works only on happy path shown in storybook/curl.                                   | Real systems live on edges.                                      |
| **Security Posture**         | Sanitises inputs, parameterised queries, CSRF tokens, secure cookies, RBAC in middle layer.         | String concatenated SQL, plaintext JWT secret in repo, no auth checks on mutations. | Attack surface grows exponentially.                              |
| **Performance & Big‑O**      | Memoization, pagination, bulk operations, async streams.                                            | N² loops, blocking awaits in `for` loops, eager loading full tables.                | Latency & cost spirals under load.                               |
| **Configurability**          | Reads typed config (`config.ts`) & env vars; no hard‑coded constants.                               | API keys, host URLs, and magic numbers in source files.                             | Enables dev/prod parity & zero‑touch deployments.                |
| **Testing Strategy**         | Unit tests for pure logic, integration tests for I/O, contract tests for APIs, e2e happy paths.     | One shallow render test (“renders without crashing”).                               | Catch regressions, document behaviour.                           |
| **Documentation & Metadata** | 20‑line header, docstrings, ADRs & README that explain **why**.                                     | Sparse comments that explain **what** (or none at all).                             | Context for future maintainers & LLM agents.                     |
| **CI / Quality Gates**       | Lint, type‑check, tests, coverage, security scan, perf budget threshold.                            | Lint skipped, tests optional, “green if it builds”.                                 | Automates the mechanic role.                                     |
| **Reuse & DRYness**          | Shared primitives & utilities; duplication refactored.                                              | Copy‑pasted blocks with TODOs to “clean later”.                                     | Duplicated bugs, bloated codebase.                               |
| **Dependency Hygiene**       | Minimal deps, pinned versions, tree‑shaking, internal packages.                                     | Adds heavy libs for single helper, outdated or abandoned packages.                  | Attack surface & bundle size.                                    |
| **Evolvability**             | Uses patterns with growth paths (e.g. CQRS, feature flags).                                         | Hard‑wires choices (monolithic class, no interface segregation).                    | Adapts to new requirements without rewrite.                      |

---

#### Concrete Example

(React + TS service call)

|           | **Senior**                                                                                                                                                    | **Junior**                                                                                                                                                                                                   |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| *Hook*    | ``ts  export function useUser(id: UserID) {   const {data, error, isLoading} = useSWR(`/users/${id}`, api.get);   return {user: data, error, isLoading}; } `` | ``ts  export function useUser(id) {   const [data, setData] = useState();   useEffect(() => {     fetch(`/api/users/${id}`)       .then(r => r.json())       .then(setData);   }, [id]);   return data; } `` |
| *Service* | Reads token from config, typed response, throws `AuthError`, supports abort signal.                                                                           | Inlined inside component, no error map, no timeout.                                                                                                                                                          |
| *Tests*   | Unit test mocks SWR cache miss & error; integration test hits test DB.                                                                                        | No test or snapshot only.                                                                                                                                                                                    |
| *Env*     | Base URL taken from `PUBLIC_API_URL`.                                                                                                                         | Hard‑coded `/api`.                                                                                                                                                                                           |

---

### How to *programmatically* flag junior patterns

1. **Lint rules**

   * Disallow JSX + `fetch` in same file.
   * Boolean names require `is/has/can` prefix.
   * Max function length ≤ 40 LOC.

2. **Static‑analysis bots**

   * Detect N² loops via simple AST heuristics.
   * Flag string concatenation in SQL strings.

3. **CI quality thresholds**

   * Coverage ≥ 80 %, ESLint error count = 0, bundle size budget.

4. **Self‑audit agent**

   * Use grammar headers + dependency graph to warn:
     “`UserPage.tsx` imports `database/client.ts` — breaks layer rule.”

---

### TL;DR

*Junior code lacks defensive thinking, layer separation, and future‑proofing.*
By baking rules into your **grammar + linters + CI**, you elevate agent output automatically; all that remains for humans is high‑level product direction and nuanced trade‑off decisions.
