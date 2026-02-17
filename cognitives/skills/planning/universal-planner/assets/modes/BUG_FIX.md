# BUG_FIX Mode

## When to Use

Use this mode when **investigating and planning a fix for a specific issue**. The user reports a bug, regression, error, or something that's "not working".

**Example inputs:**
- "Fix the login timeout bug"
- "Users can't submit forms on mobile"
- "API returns 500 error on large uploads"
- "The checkout flow crashes on Safari"

**Detection signals:**
- "fix", "bug", "issue", "broken", "regression", "error"
- "not working", "fails", "crashes"
- Specific problem report

## Fast Path (Severity LOW/MEDIUM with Trivial Fix)

If the bug has a clear root cause, a simple fix (< 20 LOC), and low regression risk, use the Fast Path to avoid documentation overhead.

**Generate only:**
1. `analysis/ANALYSIS.md` — Root Cause Analysis + Solution Design + Test Cases
2. `sprints/SPRINT-1-hotfix.md` — Single sprint with the fix tasks

**Skip:** README.md (optional stub), CONVENTIONS.md (reference only), PLANNING.md, EXECUTION.md, PROGRESS.md

**Detection:** Use Fast Path when ALL of these are true:
- Severity is LOW or MEDIUM
- Root cause is identified in a single file
- Fix is < 20 lines of code
- Regression risk is LOW

When any condition is NOT met, use the full BUG_FIX workflow below.

---

## Output Structure

```
{output_dir}/planning/{project-name}/
├── README.md
├── discovery/
│   └── CONVENTIONS.md              # Existing patterns and test coverage
├── analysis/
│   └── ANALYSIS.md                 # Root cause analysis
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    ├── PROGRESS.md
    └── SPRINT-{N}-{name}.md
```

## Frontmatter Additions

**ANALYSIS.md frontmatter:**
```yaml
severity: "critical" | "high" | "medium" | "low"
```

Severity levels:
- **Critical**: Production down, data loss, security breach
- **High**: Major feature broken, affects many users
- **Medium**: Feature partially broken, workaround exists
- **Low**: Minor issue, cosmetic, edge case

## Workflow

**BUG_FIX Workflow:** Discovery → Analysis → Planning → Execution → Sprints → Handoff

### Step 1: Codebase Discovery

Generate `discovery/CONVENTIONS.md` focusing on:
- **Existing test coverage:** Where tests exist, where they don't
- **Error handling patterns:** How errors are currently handled
- **Logging and monitoring:** What logging exists
- **Deployment and rollback:** How to deploy fixes, how to rollback

### Step 2: Analysis (Root Cause Analysis)

**Analysis adapts to:**

1. **Root Cause Analysis**
   - **Reproduction steps:** Exact steps to reproduce the bug
   - **Root cause:** Trace the bug to its source (file, line, function)
   - **Affected code paths:** All code paths that exhibit the bug
   - **Why it wasn't caught:** Why existing tests didn't catch it

2. **Impact Assessment**
   - **Severity:** Critical/High/Medium/Low
   - **Affected features:** What features are broken
   - **Affected users:** How many users, which user segments
   - **Regression risk:** Risk of fix breaking other things

3. **Solution Design**
   - **Proposed fix:** Detailed fix approach
   - **Alternative solutions:** Other ways to fix it
   - **Trade-offs:** Pros/cons of each approach
   - **Why this approach:** Justification for chosen solution

4. **Test Cases**
   - **Verification tests:** Tests that prove the bug is fixed
   - **Regression prevention tests:** Tests that prevent it from happening again
   - **Edge cases:** Additional scenarios to test

## Recommended Sprint Structure

| Sprint | Focus | Deliverables |
|--------|-------|--------------|
| **Sprint 1: Investigation** | Reproduce, trace, identify root cause | Reproduction case, root cause documented |
| **Sprint 2: Implementation** | Implement fix, refactor if needed | Fix implemented, code reviewed |
| **Sprint 3: Verification** | Test, review, deploy | Tests passing, deployed to production |

For **critical bugs**, collapse into 1 sprint (hotfix).

For **simple bugs**, collapse into 1-2 sprints.

## Analysis Template

### Root Cause Analysis

```markdown
## Root Cause Analysis

### Bug Description
[Clear description of what's broken]

### Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Expected: X, Actual: Y]

### Root Cause
**File:** `src/auth/login.service.ts`
**Line:** 147
**Function:** `validateToken()`

**Problem:** The token validation fails when the token expiry is exactly equal to current time (off-by-one error).

\`\`\`typescript
// Current (buggy):
if (tokenExpiry < Date.now()) {  // ❌ Should be <=
  throw new Error('Token expired');
}
\`\`\`

**Why it wasn't caught:** Test cases didn't cover the edge case of exact expiry time.

### Affected Code Paths
1. Login flow → Token validation
2. Session refresh → Token validation
3. API middleware → Token validation

All paths use `validateToken()`, so all are affected.
```

### Impact Assessment

```markdown
## Impact Assessment

| Metric | Value |
|--------|-------|
| **Severity** | High |
| **Affected users** | ~15% of users (those with tokens expiring at exact second) |
| **Affected features** | Login, session refresh, API access |
| **Workaround** | Users can log out and log back in |
| **Regression risk** | Low (fix is isolated to one function) |
| **Data at risk** | No data loss, authentication only |
```

### Solution Design

```markdown
## Solution Design

### Proposed Fix
Change comparison operator from `<` to `<=`:

\`\`\`typescript
// Fixed:
if (tokenExpiry <= Date.now()) {  // ✅ Correct
  throw new Error('Token expired');
}
\`\`\`

### Alternative Solutions
1. **Add buffer time** (e.g., expire 1 second earlier)
   - Pro: More conservative
   - Con: Reduces actual session time
   - **Rejected:** Doesn't fix root cause

2. **Refactor token validation** to use a library
   - Pro: More robust
   - Con: Larger change, higher risk
   - **Rejected:** Overkill for this fix

### Why This Approach
- Minimal change (1 character)
- Low regression risk
- Fixes root cause directly
- Easy to test
```

### Test Cases

```markdown
## Test Cases

### Verification Tests
1. **Test:** Token expires in future → Should pass validation
2. **Test:** Token expires at exact current time → Should fail validation ✅ NEW
3. **Test:** Token expired in past → Should fail validation

### Regression Prevention Tests
1. **Test:** Token validation with various expiry offsets (-10s, -1s, 0s, +1s, +10s)
2. **Test:** Edge case: Token with null expiry
3. **Test:** Edge case: Token with invalid expiry format

### Edge Cases
- Token with expiry = 0
- Token with expiry in distant future (year 2100)
- Token with expiry in distant past (year 1970)
```

## Examples

**Example 1: Critical production bug**
- Severity: Critical
- Sprints: 1 (hotfix)
- Timeline: Fix within 4 hours
- Deployment: Immediate after testing

**Example 2: Mobile-specific UI bug**
- Severity: High
- Sprints: 2 (Investigation + Fix)
- Root cause: CSS media query missing
- Testing: Manual testing on 5 devices

**Example 3: Edge case data corruption**
- Severity: High (data loss)
- Sprints: 3 (Investigation + Fix + Verification)
- Root cause: Race condition in concurrent writes
- Solution: Add database transaction
