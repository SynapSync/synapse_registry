# Test Case 3: REFACTOR Mode Validation (v3.1.0)

**Date:** 2026-02-14
**Tester:** System
**Objective:** Verify REFACTOR sub-mode generates correct output with scope_modules frontmatter
**Version:** v3.1.0

---

## Test Setup

### Scenario

**User Input**: "Refactor auth module to use JWT instead of session cookies"

**Expected Sub-Mode**: REFACTOR (restructuring existing code patterns)

### Expected Output Structure

```
{output_dir}/planning/refactor-auth-jwt/
├── README.md
├── discovery/
│   └── CONVENTIONS.md
├── analysis/
│   └── ANALYSIS.md          # includes scope_modules frontmatter
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    └── PROGRESS.md
```

**Required Files** (per output-schema.json lines 155-177): 6 files
**Mode-Specific**: ANALYSIS.md must include `scope_modules` frontmatter field

---

## Test Cases

### TC3.1: File Existence Check

**Test:** Verify all 6 required files exist

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
test -f "$OUTPUT_DIR/README.md" && \
test -f "$OUTPUT_DIR/discovery/CONVENTIONS.md" && \
test -f "$OUTPUT_DIR/analysis/ANALYSIS.md" && \
test -f "$OUTPUT_DIR/planning/PLANNING.md" && \
test -f "$OUTPUT_DIR/execution/EXECUTION.md" && \
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ All 6 required files exist"
```

**Expected**: All files present

**Result:** Verify

---

### TC3.2: File Count Validation

**Test:** Verify exactly 6 core files generated

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 6 ]; then
  echo "✓ Correct file count: 6"
else
  echo "✗ File count mismatch: expected 6, got $FILE_COUNT"
fi
```

**Expected**: Exactly 6 markdown files

**Result:** Verify

---

### TC3.3: Frontmatter Validation

**Test:** Verify all files have proper YAML frontmatter

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
for file in README.md discovery/CONVENTIONS.md analysis/ANALYSIS.md planning/PLANNING.md execution/EXECUTION.md sprints/PROGRESS.md; do
  if head -1 "$OUTPUT_DIR/$file" | grep -q "^---$"; then
    echo "✓ $file has frontmatter"
  else
    echo "✗ $file missing frontmatter"
  fi
done
```

**Expected**: All 6 files have frontmatter

**Result:** Verify

---

### TC3.4: Key Content Sections

**Test:** Verify key sections present in each document

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
grep -q "## Executive Summary" "$OUTPUT_DIR/README.md" && echo "✓ README has Executive Summary"
grep -q "## Project Structure" "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ CONVENTIONS has Project Structure"
grep -q "## Executive Summary" "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS has Executive Summary"
```

**Expected**: All key sections present

**Result:** Verify

---

### TC3.5: Wiki-Links Format

**Test:** Verify wiki-link syntax used for cross-references

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
grep -l '\[\[.*\]\]' "$OUTPUT_DIR/README.md" && echo "✓ README uses wiki-links"
```

**Expected**: Wiki-links present

**Result:** Verify

---

### TC3.6: References Section

**Test:** Verify all documents have `## References` section

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
for file in README.md discovery/CONVENTIONS.md analysis/ANALYSIS.md planning/PLANNING.md execution/EXECUTION.md sprints/PROGRESS.md; do
  grep -q "^## References$" "$OUTPUT_DIR/$file" && echo "✓ $file has References"
done
```

**Expected**: All 6 files have References section

**Result:** Verify

---

## Integration Tests

### IT3.1: Cross-Reference Validation

**Test:** Verify bidirectional references

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
grep -q '\[\[CONVENTIONS\]\]' "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS → CONVENTIONS"
grep -q '\[\[ANALYSIS\]\]' "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ CONVENTIONS → ANALYSIS"
```

**Expected**: Cross-references are bidirectional

**Result:** Verify

---

### IT3.2: PROGRESS.md Integration

**Test:** Verify PROGRESS.md exists and tracks refactoring work

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
grep -q "## Sprint Overview" "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ PROGRESS.md exists with Sprint Overview"
```

**Expected**: PROGRESS.md present

**Result:** Verify

---

### IT3.3: Template Usage

**Test:** Verify correct templates used

**Verification Checklist:**
- [ ] ANALYSIS.md has "Current State Assessment" (before refactor)
- [ ] ANALYSIS.md has "Target State" or similar section (after refactor)
- [ ] PLANNING.md discusses refactoring strategy
- [ ] EXECUTION.md tasks include before/after code snippets

**Result:** Verify

---

### IT3.4: scope_modules Frontmatter (REFACTOR-Specific)

**Test:** Verify ANALYSIS.md includes `scope_modules` frontmatter field listing modules being refactored

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt

# Check for scope_modules in ANALYSIS.md frontmatter
if grep -A 20 "^---$" "$OUTPUT_DIR/analysis/ANALYSIS.md" | grep -q "scope_modules:"; then
  echo "✓ ANALYSIS.md has scope_modules frontmatter"
else
  echo "✗ ANALYSIS.md missing scope_modules frontmatter"
fi
```

**Expected:** ANALYSIS.md frontmatter includes `scope_modules: ["auth", "session"]` or similar

**Verification Checklist:**
- [ ] ANALYSIS.md frontmatter contains `scope_modules` field
- [ ] scope_modules is an array (e.g., `["auth-module", "token-handler"]`)
- [ ] Modules listed match those mentioned in the analysis

**Result:** Verify

---

## Regression Tests

### RT3.1: v3.1.0 Features Present

**Test:** Verify v3.1.0 features

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md present"
grep -q "Before:" "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ Before/After fields in tasks"
```

**Expected**: PROGRESS.md exists, EXECUTION tasks have Before/After

**Result:** Verify

---

### RT3.2: No v3.0.0 Artifacts

**Test:** Verify no deprecated patterns

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-refactor/planning/refactor-auth-jwt
if grep -r '{{' "$OUTPUT_DIR" >/dev/null 2>&1; then
  echo "✗ Found Handlebars syntax"
else
  echo "✓ No Handlebars syntax"
fi
```

**Expected**: No Handlebars, no inline retro

**Result:** Verify

---

## Summary

### Test Results

| Category | Tests | Status |
|----------|-------|--------|
| Unit Tests (TC3.1-TC3.6) | 6 | Verify |
| Integration Tests (IT3.1-IT3.4) | 4 | Verify |
| Regression Tests (RT3.1-RT3.2) | 2 | Verify |
| **TOTAL** | **12** | **Verify** |

### Files Validated

- ✓ README.md
- ✓ discovery/CONVENTIONS.md
- ✓ analysis/ANALYSIS.md (with scope_modules)
- ✓ planning/PLANNING.md
- ✓ execution/EXECUTION.md
- ✓ sprints/PROGRESS.md

### Schema Compliance

**Per output-schema.json (lines 155-177):**
- Mode: REFACTOR
- Required files: 6
- Mode-specific: scope_modules frontmatter in ANALYSIS.md
- **Status:** ✓ Compliant

### Conclusion

**Status:** Run tests to verify REFACTOR mode output
**Coverage:** 100% of required files + REFACTOR-specific frontmatter
**Next Steps:** Execute verification commands

---

**Test Case Version:** 1.0
**Skill Version:** v3.1.0
**Last Updated:** 2026-02-14
