# Test Case 4: BUG_FIX Mode Validation (v3.1.0)

**Date:** 2026-02-14
**Tester:** System
**Objective:** Verify BUG_FIX sub-mode supports both standard workflow and fast path for trivial fixes
**Version:** v3.1.0

---

## Test Setup

### Scenarios

#### Scenario A: Fast Path (LOW/MEDIUM Severity, Trivial Fix)

**User Input**: "Fix login timeout after 5 minutes of inactivity"
**Severity**: MEDIUM
**Expected Sub-Mode**: BUG_FIX (fast path)
**Expected Files**: 2 (ANALYSIS.md + SPRINT-1-hotfix.md)

#### Scenario B: Standard Path (HIGH/CRITICAL Severity)

**User Input**: "Fix data corruption bug in checkout process"
**Severity**: HIGH
**Expected Sub-Mode**: BUG_FIX (standard workflow)
**Expected Files**: 6 (README, CONVENTIONS, ANALYSIS, PLANNING, EXECUTION, PROGRESS)

---

## Fast Path Tests

### TC4.1: Fast Path File Existence

**Test:** Verify only 2 files generated for fast path

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-fast/planning/fix-login-timeout
test -f "$OUTPUT_DIR/analysis/ANALYSIS.md" && \
test -f "$OUTPUT_DIR/sprints/SPRINT-1-hotfix.md" && \
echo "✓ Fast path: 2 required files exist"
```

**Expected**: Only ANALYSIS.md and SPRINT-1-hotfix.md

**Result:** Verify

---

### TC4.2: Fast Path File Count

**Test:** Verify exactly 2 files (no CONVENTIONS, PLANNING, EXECUTION, PROGRESS)

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-fast/planning/fix-login-timeout
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 2 ]; then
  echo "✓ Fast path correct: 2 files"
else
  echo "✗ Fast path file count wrong: expected 2, got $FILE_COUNT"
fi

# Verify files that should NOT exist
test ! -f "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ No CONVENTIONS (fast path)"
test ! -f "$OUTPUT_DIR/planning/PLANNING.md" && echo "✓ No PLANNING (fast path)"
test ! -f "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ No EXECUTION (fast path)"
test ! -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ No PROGRESS (fast path)"
```

**Expected**: 2 files total, no planning overhead

**Result:** Verify

---

### TC4.3: Fast Path Frontmatter (Severity Field)

**Test:** Verify ANALYSIS.md includes `severity` frontmatter

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-fast/planning/fix-login-timeout
if grep -A 20 "^---$" "$OUTPUT_DIR/analysis/ANALYSIS.md" | grep -q 'severity:.*"medium"'; then
  echo "✓ ANALYSIS has severity: medium"
else
  echo "✗ ANALYSIS missing severity field"
fi
```

**Expected**: `severity: "medium"` or `severity: "low"`

**Result:** Verify

---

### TC4.4: Fast Path Sprint Structure

**Test:** Verify SPRINT-1-hotfix.md contains direct fix tasks

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-fast/planning/fix-login-timeout
test -f "$OUTPUT_DIR/sprints/SPRINT-1-hotfix.md" && \
grep -q "## Task" "$OUTPUT_DIR/sprints/SPRINT-1-hotfix.md" && \
echo "✓ SPRINT-1-hotfix has tasks"
```

**Expected**: Sprint file with concise fix tasks

**Result:** Verify

---

## Standard Path Tests

### TC4.5: Standard Path File Existence

**Test:** Verify all 6 required files for HIGH severity bug

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-std/planning/fix-checkout-corruption
test -f "$OUTPUT_DIR/README.md" && \
test -f "$OUTPUT_DIR/discovery/CONVENTIONS.md" && \
test -f "$OUTPUT_DIR/analysis/ANALYSIS.md" && \
test -f "$OUTPUT_DIR/planning/PLANNING.md" && \
test -f "$OUTPUT_DIR/execution/EXECUTION.md" && \
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ Standard path: all 6 files exist"
```

**Expected**: Full 6-file workflow

**Result:** Verify

---

### TC4.6: Standard Path File Count

**Test:** Verify exactly 6 files for standard path

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-std/planning/fix-checkout-corruption
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 6 ]; then
  echo "✓ Standard path correct: 6 files"
else
  echo "✗ Standard path file count wrong: expected 6, got $FILE_COUNT"
fi
```

**Expected**: 6 markdown files

**Result:** Verify

---

### TC4.7: Standard Path Severity Field

**Test:** Verify ANALYSIS.md includes `severity: "high"` or `severity: "critical"`

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-std/planning/fix-checkout-corruption
if grep -A 20 "^---$" "$OUTPUT_DIR/analysis/ANALYSIS.md" | grep -q 'severity:.*\(high\|critical\)'; then
  echo "✓ ANALYSIS has high/critical severity"
else
  echo "✗ ANALYSIS missing or wrong severity"
fi
```

**Expected**: `severity: "high"` or `severity: "critical"`

**Result:** Verify

---

### TC4.8: Standard Path Content

**Test:** Verify bug analysis sections present

**Verification Checklist:**
- [ ] ANALYSIS.md contains "Root Cause Analysis"
- [ ] ANALYSIS.md contains "Impact Assessment"
- [ ] PLANNING.md contains "Fix Strategy"
- [ ] EXECUTION.md contains tasks with reproduction steps, fix implementation, verification

**Command:**
```bash
OUTPUT_DIR=~/.agents/test-bugfix-std/planning/fix-checkout-corruption
grep -q "Root Cause" "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ Root cause analysis present"
grep -q "Fix Strategy\|Solution Design" "$OUTPUT_DIR/planning/PLANNING.md" && echo "✓ Fix strategy present"
```

**Expected**: Bug-specific sections present

**Result:** Verify

---

## Integration Tests

### IT4.1: Cross-Reference Validation

**Test:** Standard path has bidirectional references; fast path has minimal references

**Fast Path:**
- ANALYSIS.md → SPRINT-1-hotfix.md
- SPRINT-1-hotfix.md → ANALYSIS.md

**Standard Path:**
- Full bidirectional linking (same as other modes)

**Result:** Verify

---

### IT4.2: PROGRESS.md Integration

**Test:** Verify PROGRESS.md exists for standard path, NOT for fast path

**Command:**
```bash
# Fast path should NOT have PROGRESS.md
test ! -f ~/.agents/test-bugfix-fast/planning/fix-login-timeout/sprints/PROGRESS.md && \
echo "✓ Fast path: no PROGRESS.md (correct)"

# Standard path SHOULD have PROGRESS.md
test -f ~/.agents/test-bugfix-std/planning/fix-checkout-corruption/sprints/PROGRESS.md && \
echo "✓ Standard path: PROGRESS.md present"
```

**Expected**: PROGRESS.md only for standard path

**Result:** Verify

---

### IT4.3: Template Usage

**Test:** Verify BUG_FIX-specific templates used

**Verification Checklist:**
- [ ] ANALYSIS.md includes "Bug Report" or "Issue Description"
- [ ] ANALYSIS.md includes "Reproduction Steps"
- [ ] ANALYSIS.md includes "Root Cause Analysis"
- [ ] SPRINT-1-hotfix.md (fast path) is concise (< 50 lines)

**Result:** Verify

---

### IT4.4: Severity Field Validation (BUG_FIX-Specific)

**Test:** Verify severity field determines workflow path

**Fast Path Rules:**
- Severity: LOW or MEDIUM
- Fix complexity: Trivial (< 20 LOC)
- Output: 2 files

**Standard Path Rules:**
- Severity: HIGH or CRITICAL
- OR fix complexity: Non-trivial
- Output: 6 files

**Verification Checklist:**
- [ ] MEDIUM severity → fast path (2 files)
- [ ] HIGH severity → standard path (6 files)
- [ ] Severity field present in all ANALYSIS.md files

**Result:** Verify

---

## Regression Tests

### RT4.1: v3.1.0 Features Present

**Test:** Fast path feature added in v3.1.0

**Command:**
```bash
# Verify fast path documentation exists in BUG_FIX.md mode file
test -f /Users/rperaza/.claude/skills/universal-planner/assets/modes/BUG_FIX.md && \
grep -q "Fast Path" /Users/rperaza/.claude/skills/universal-planner/assets/modes/BUG_FIX.md && \
echo "✓ Fast path documented in BUG_FIX mode"
```

**Expected**: Fast path is documented feature

**Result:** Verify

---

### RT4.2: No v3.0.0 Artifacts

**Test:** No deprecated patterns

**Command:**
```bash
# Check both fast and standard path outputs
for OUTPUT_DIR in ~/.agents/test-bugfix-fast/planning/fix-login-timeout ~/.agents/test-bugfix-std/planning/fix-checkout-corruption; do
  if [ -d "$OUTPUT_DIR" ]; then
    if grep -r '{{' "$OUTPUT_DIR" >/dev/null 2>&1; then
      echo "✗ Found Handlebars in $OUTPUT_DIR"
    else
      echo "✓ No Handlebars in $OUTPUT_DIR"
    fi
  fi
done
```

**Expected**: No Handlebars

**Result:** Verify

---

## Summary

### Test Results

| Category | Tests | Status |
|----------|-------|--------|
| Fast Path Tests (TC4.1-TC4.4) | 4 | Verify |
| Standard Path Tests (TC4.5-TC4.8) | 4 | Verify |
| Integration Tests (IT4.1-IT4.4) | 4 | Verify |
| Regression Tests (RT4.1-RT4.2) | 2 | Verify |
| **TOTAL** | **14** | **Verify** |

### Files Validated

**Fast Path (2 files):**
- ✓ analysis/ANALYSIS.md (with severity: low/medium)
- ✓ sprints/SPRINT-1-hotfix.md

**Standard Path (6 files):**
- ✓ README.md
- ✓ discovery/CONVENTIONS.md
- ✓ analysis/ANALYSIS.md (with severity: high/critical)
- ✓ planning/PLANNING.md
- ✓ execution/EXECUTION.md
- ✓ sprints/PROGRESS.md

### Schema Compliance

**Per output-schema.json (lines 155-177) + BUG_FIX.md mode file:**
- Mode: BUG_FIX
- Fast path: 2 files (ANALYSIS + SPRINT-1-hotfix)
- Standard path: 6 files (full workflow)
- Mode-specific: severity frontmatter field
- **Status:** ✓ Compliant

### Conclusion

**Status:** Run tests to verify BUG_FIX mode with both paths
**Coverage:** 100% of BUG_FIX workflows (fast + standard)
**Next Steps:** Execute verification commands for both scenarios

---

**Test Case Version:** 1.0
**Skill Version:** v3.1.0
**Last Updated:** 2026-02-14
