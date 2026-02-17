# TECH_DEBT Mode

## When to Use

Use this mode when **reducing technical debt in an existing codebase**. The user wants to clean up, modernize, or address accumulated technical issues.

**Example inputs:**
- "Clean up the orders module"
- "Reduce tech debt in the API layer"
- "Remove dead code from the frontend"
- "Update deprecated dependencies"
- "Add missing test coverage"

**Detection signals:**
- "cleanup", "clean up", "dead code"
- "outdated", "deprecated"
- "missing tests", "test coverage"
- "duplication", "technical debt", "code quality"

## Output Structure

```
{output_dir}/planning/{project-name}/
├── README.md
├── discovery/
│   └── CONVENTIONS.md              # Current patterns and debt inventory
├── analysis/
│   └── ANALYSIS.md                 # Debt analysis and prioritization
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    ├── PROGRESS.md
    └── SPRINT-{N}-{name}.md
```

## Frontmatter Additions

No mode-specific frontmatter fields for TECH_DEBT. All documents use the standard universal schema.

## Workflow

**TECH_DEBT Workflow:** Discovery → Analysis → Planning → Execution → Sprints → Handoff

### Step 1: Codebase Discovery

Generate `discovery/CONVENTIONS.md` documenting:
- **Current patterns:** What patterns are in use
- **Tech debt symptoms:** Visible signs of debt (slow builds, flaky tests, etc.)
- **Dependency status:** Outdated packages, security vulnerabilities
- **Test coverage:** Current coverage percentage and gaps

### Step 2: Analysis (Debt Inventory & Prioritization)

**Analysis adapts to:**

1. **Debt Inventory**
   - **Dead code:** Unused files, functions, components
   - **Deprecated dependencies:** Outdated packages, security vulnerabilities
   - **Outdated patterns:** Old patterns that should be migrated
   - **Code duplication:** Percentage and locations
   - **Missing tests:** Modules without test coverage
   - **Documentation gaps:** Missing or outdated docs

2. **Impact vs Effort Matrix**
   Categorize each debt item:

   | Category | Description | Priority |
   |----------|-------------|----------|
   | **Quick Wins** | High impact, low effort | P0 |
   | **Critical Fixes** | High impact, high effort | P1 |
   | **Strategic Improvements** | Medium impact, low/medium effort | P2 |
   | **Nice-to-Have** | Low impact, any effort | P3 |

3. **Prioritization**
   Order items by:
   - Impact on maintainability
   - Impact on developer experience
   - Risk if not addressed
   - Effort required

4. **Modernization Path**
   - **Patterns to migrate to:** New patterns to adopt
   - **Dependencies to update:** Package upgrades
   - **Code to sunset:** Code to deprecate and remove

## Recommended Sprint Structure

| Sprint | Focus | Deliverables |
|--------|-------|--------------|
| **Sprint 1: Quick Wins** | Easy fixes with high impact | Dead code removed, simple updates |
| **Sprint 2: Cleanup** | Delete dead code, consolidate duplicates | Codebase size reduced, duplication removed |
| **Sprint 3: Modernization** | Update patterns, upgrade dependencies | New patterns adopted, deps updated |
| **Sprint 4: Testing** | Add missing test coverage | Test coverage increased to target % |

Adjust sprint count based on debt scope:
- **Small cleanup** (single module): 1-2 sprints
- **Medium cleanup** (layer-level): 2-3 sprints
- **Large cleanup** (codebase-wide): 3-4 sprints

## Analysis Template

### Debt Inventory

```markdown
## Debt Inventory

### Dead Code
- **12 unused components** in `src/legacy/` (1,200 LOC)
- **8 unused utility files** in `src/utils/old/` (600 LOC)
- **3 deprecated API routes** in `src/api/v1/` (300 LOC)
- **Total dead code:** ~2,100 LOC (~15% of codebase)

### Deprecated Dependencies
| Package | Current | Latest | Risk | Update Effort |
|---------|---------|--------|------|---------------|
| `react` | 17.0.2 | 18.2.0 | Medium | High (breaking changes) |
| `lodash` | 4.17.15 | 4.17.21 | High (security) | Low (no breaking changes) |
| `moment` | 2.29.1 | N/A (deprecated) | Medium | Medium (migrate to date-fns) |

### Outdated Patterns
- **Class components:** 45 components still using class syntax (should be hooks)
- **PropTypes:** 30 components using PropTypes (should be TypeScript)
- **Inline styles:** 20 components with inline styles (should use styled-components)

### Code Duplication
- **API error handling:** Duplicated in 15 files (~35% duplication)
- **Form validation:** 8 different validation implementations
- **Date formatting:** Formatting logic repeated 12 times

### Missing Tests
- **API layer:** 0% coverage (20 files, 0 tests)
- **Utils:** 30% coverage (10 files, 3 tested)
- **Components:** 45% coverage (80 components, 36 tested)
- **Overall coverage:** 32% (target: 80%)

### Documentation Gaps
- **10 API endpoints** without OpenAPI specs
- **No README** in 5 key modules
- **Outdated setup docs** (last updated 18 months ago)
```

### Impact vs Effort Matrix

```markdown
## Impact vs Effort Matrix

### Quick Wins (High Impact, Low Effort) - Priority P0
1. **Remove dead code** (2,100 LOC) - Impact: +++, Effort: +
2. **Update lodash** (security fix) - Impact: +++, Effort: +
3. **Add API error handling utility** - Impact: ++, Effort: +

### Critical Fixes (High Impact, High Effort) - Priority P1
4. **Migrate to React 18** - Impact: +++, Effort: +++
5. **Add API layer test coverage** - Impact: +++, Effort: +++
6. **Consolidate form validation** - Impact: ++, Effort: ++

### Strategic Improvements (Medium Impact, Low/Medium Effort) - Priority P2
7. **Convert class components to hooks** (45 components) - Impact: ++, Effort: ++
8. **Migrate moment → date-fns** - Impact: +, Effort: ++
9. **Add module READMEs** - Impact: +, Effort: +

### Nice-to-Have (Low Impact, Any Effort) - Priority P3
10. **Convert PropTypes → TypeScript** - Impact: +, Effort: ++
11. **Standardize inline styles** - Impact: +, Effort: +
```

### Prioritization Rationale

```markdown
## Prioritization

| Rank | Item | Impact | Effort | Why Priority |
|------|------|--------|--------|--------------|
| 1 | Remove dead code | High | Low | Reduces codebase complexity, improves build time |
| 2 | Update lodash | High | Low | Security vulnerability (CVE-2021-23337) |
| 3 | API error handling utility | High | Low | Reduces duplication, improves consistency |
| 4 | Migrate React 18 | High | High | Enables concurrent features, performance gains |
| 5 | API test coverage | High | High | Critical path untested, high bug risk |
```

### Modernization Path

```markdown
## Modernization Path

### Pattern Migrations
- **From:** Class components → **To:** Functional components + hooks
- **From:** PropTypes → **To:** TypeScript interfaces
- **From:** moment.js → **To:** date-fns (smaller bundle, not deprecated)
- **From:** Inline API calls → **To:** Centralized API client with error handling

### Dependency Updates
1. **Phase 1 (Low risk):** Update patch/minor versions (lodash, etc.)
2. **Phase 2 (Medium risk):** Update React 17 → 18
3. **Phase 3 (High risk):** Migrate moment → date-fns (breaking change)

### Code to Sunset
- `src/legacy/` - Delete entirely
- `src/utils/old/` - Delete entirely
- `src/api/v1/` - Deprecate, redirect to v2
```

## Metrics

Track progress with before/after metrics:

| Metric | Before | After | Delta | Status |
|--------|--------|-------|-------|--------|
| Total LOC | 14,000 | 11,900 | -2,100 | 🎯 Target |
| Code duplication | 35% | <10% | -25% | 🎯 Target |
| Test coverage | 32% | 80% | +48% | 🎯 Target |
| Outdated dependencies | 12 | 0 | -12 | 🎯 Target |
| Build time | 2m 30s | 1m 45s | -45s | 🎯 Target |
| Bundle size | 850kb | 650kb | -200kb | 🎯 Target |

## Examples

**Example 1: Small module cleanup**
- Scope: Single module (orders)
- Sprints: 2 (Quick wins + Testing)
- Debt removed: Dead code, duplicate logic, missing tests
- Coverage: 20% → 85%

**Example 2: Dependency modernization**
- Scope: All dependencies
- Sprints: 3 (Patch updates + React 18 + moment migration)
- Security vulns: 5 → 0
- Bundle size: 850kb → 650kb

**Example 3: Codebase-wide cleanup**
- Scope: Entire frontend
- Sprints: 4 (Dead code + Duplication + Modernization + Testing)
- LOC reduction: 15,000 → 12,000 (-20%)
- Test coverage: 30% → 80%
