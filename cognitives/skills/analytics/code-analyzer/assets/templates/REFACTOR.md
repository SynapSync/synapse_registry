# REFACTOR.md Template

Refactoring recommendations structure for code-analyzer v3 analysis.

## Frontmatter Schema

```yaml
---
title: "Refactoring Recommendations: {{module-name}}"
date: "{{YYYY-MM-DD}}"
updated: "{{YYYY-MM-DD}}"
project: "{{project-name}}"
type: "refactor-plan"
status: "active"
version: "1.0"
tags: ["{{project-name}}", "refactor-plan", "module-analysis", "{{module-name}}"]
changelog:
  - version: "1.0"
    date: "{{YYYY-MM-DD}}"
    changes: ["Initial refactoring recommendations"]
related:
  - "[[REPORT]]"  # Always link back to the main analysis report
---
```

## Document Structure

### 1. Code Smells

List issues detected with severity ratings.

```markdown
## Code Smells

| ID | Issue | Severity | Location | Description |
|----|-------|----------|----------|-------------|
| D-001 | God Class | High | `PaymentService` | Single class handles payment processing, validation, gateway communication, and event emission |
| D-002 | Long Method | Medium | `processPayment()` | 85-line method with multiple responsibilities |
| D-003 | Duplicate Code | Low | Validation logic | Payment validation repeated in 3 different methods |
```

**Severity levels**: High, Medium, Low

### 2. Recommendations

Specific, actionable improvements with impact and effort ratings.

```markdown
## Recommendations

| Issue | Recommendation | Priority | Impact | Effort |
|-------|---------------|----------|--------|--------|
| D-001 | Extract payment gateway logic to `PaymentGatewayService`, event emission to `PaymentEventEmitter`, validation to `PaymentValidator` | High | High | Medium |
| D-002 | Refactor `processPayment()` into smaller, focused methods: `validateRequest()`, `executeCharge()`, `handleResult()` | High | Medium | Low |
| D-003 | Create shared `PaymentValidator` class with reusable validation methods | Medium | Low | Low |
```

**Priority**: High, Medium, Low
**Impact**: High (system-wide improvement), Medium (module improvement), Low (minor improvement)
**Effort**: High (>3 days), Medium (1-3 days), Low (<1 day)

### 3. Priority Matrix

Visual representation of recommendations by impact and effort.

```markdown
## Priority Matrix

```
High Impact  │ D-001         │               │
            │               │               │
────────────┼───────────────┼───────────────┼
Medium Impact│ D-002         │               │
            │               │               │
────────────┼───────────────┼───────────────┼
Low Impact   │               │ D-003         │
            │               │               │
────────────┴───────────────┴───────────────┘
             Low Effort   Medium Effort   High Effort
```

**Recommended order**: High Impact/Low Effort first → High Impact/Medium Effort → Medium Impact/Low Effort → etc.
```

### 4. Implementation Plan

Step-by-step refactoring roadmap.

```markdown
## Implementation Plan

### Phase 1: Foundation (High Impact, Low Effort)
1. **D-002** — Extract `processPayment()` into smaller methods
   - Create `validateRequest()`, `executeCharge()`, `handleResult()`
   - Move each responsibility to its own method
   - Update tests to cover new methods

### Phase 2: Structure (High Impact, Medium Effort)
2. **D-001** — Extract responsibilities to separate classes
   - Create `PaymentGatewayService` for Stripe integration
   - Create `PaymentEventEmitter` for event handling
   - Create `PaymentValidator` for all validation logic
   - Update dependency injection configuration

### Phase 3: Cleanup (Low Impact, Low Effort)
3. **D-003** — Consolidate duplicate validation logic
   - Move all validation to `PaymentValidator`
   - Remove duplicated validation methods
   - Update tests
```

### 5. Impact Analysis

Estimate the impact of proposed changes.

```markdown
## Impact Analysis

### Affected Components
- `PaymentService` — Major refactoring required
- `OrderService` — No changes (interface remains the same)
- `NotificationService` — No changes (events unchanged)
- Test suites — Will require updates for new class structure

### Risk Assessment
| Risk | Probability | Severity | Mitigation |
|------|-------------|----------|------------|
| Breaking existing payment flows | Low | High | Maintain public interface, only refactor internals |
| Test coverage gaps | Medium | Medium | Write tests for new classes before refactoring |
| Stripe integration issues | Low | High | Use existing Stripe SDK patterns, no API changes |

### Expected Benefits
- **Maintainability**: +40% (based on reduced class complexity)
- **Testability**: +50% (smaller, focused classes easier to test)
- **Extensibility**: +60% (new payment gateways easier to add)
- **Code quality**: Cyclomatic complexity reduced from 12.3 to <8
```

### 6. Testing Strategy

How to validate refactoring changes.

```markdown
## Testing Strategy

### Before Refactoring
1. Ensure all existing tests pass
2. Measure test coverage baseline (currently 45%)
3. Document all public interfaces that must remain unchanged

### During Refactoring
1. Write tests for new classes before extracting code
2. Run tests after each extraction step
3. Verify no regression in end-to-end payment flows

### After Refactoring
1. Verify test coverage improved to 80%+
2. Run load tests to ensure performance unchanged
3. Perform manual QA on all payment scenarios
```

### 7. Referencias

Always link back to the main analysis report and any related documents.

```markdown
## Referencias

- [[REPORT]] — Main technical analysis of this module
- [[testing-strategy]] — Project-wide testing guidelines (if applicable)
- [[architecture-guidelines]] — Project architecture standards (if applicable)
```
