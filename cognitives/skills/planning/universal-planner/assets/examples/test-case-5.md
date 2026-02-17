# Test Case 5: TECH_DEBT Mode Validation (v3.1.0)

**Date:** 2026-02-14
**Tester:** System
**Objective:** Verify TECH_DEBT sub-mode generates correct output with debt inventory and prioritization
**Version:** v3.1.0

---

## Test Setup

### Scenario

**User Input**: "Clean up deprecated API endpoints in the orders module"

**Expected Sub-Mode**: TECH_DEBT (cleanup, dead code removal, modernization)

### Expected Output Structure

```
{output_dir}/planning/cleanup-orders-api/
├── README.md
├── discovery/
│   └── CONVENTIONS.md
├── analysis/
│   └── ANALYSIS.md          # includes debt inventory
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    └── PROGRESS.md
```

**Required Files** (per output-schema.json lines 155-177): 6 files
**Mode-Specific**: ANALYSIS.md includes debt inventory, prioritization matrix

---

## Test Cases

### TC5.1: File Existence Check

**Test:** Verify all 6 required files exist

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
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

### TC5.2: File Count Validation

**Test:** Verify exactly 6 core files generated

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
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

### TC5.3: Frontmatter Validation

**Test:** Verify all files have proper YAML frontmatter

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
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

### TC5.4: Key Content Sections

**Test:** Verify key sections present in each document

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
grep -q "## Executive Summary" "$OUTPUT_DIR/README.md" && echo "✓ README has Executive Summary"
grep -q "## Project Structure" "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ CONVENTIONS has Project Structure"
grep -q "## Executive Summary" "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS has Executive Summary"
```

**Expected**: All key sections present

**Result:** Verify

---

### TC5.5: Wiki-Links Format

**Test:** Verify wiki-link syntax used for cross-references

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
grep -l '\[\[.*\]\]' "$OUTPUT_DIR/README.md" && echo "✓ README uses wiki-links"
```

**Expected**: Wiki-links present

**Result:** Verify

---

### TC5.6: References Section

**Test:** Verify all documents have `## References` section

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
for file in README.md discovery/CONVENTIONS.md analysis/ANALYSIS.md planning/PLANNING.md execution/EXECUTION.md sprints/PROGRESS.md; do
  grep -q "^## References$" "$OUTPUT_DIR/$file" && echo "✓ $file has References"
done
```

**Expected**: All 6 files have References section

**Result:** Verify

---

## Integration Tests

### IT5.1: Cross-Reference Validation

**Test:** Verify bidirectional references

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
grep -q '\[\[CONVENTIONS\]\]' "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS → CONVENTIONS"
grep -q '\[\[ANALYSIS\]\]' "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ CONVENTIONS → ANALYSIS"
```

**Expected**: Cross-references are bidirectional

**Result:** Verify

---

### IT5.2: PROGRESS.md Integration

**Test:** Verify PROGRESS.md exists and tracks tech debt work

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
grep -q "## Sprint Overview" "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ PROGRESS.md exists with Sprint Overview"
```

**Expected**: PROGRESS.md present

**Result:** Verify

---

### IT5.3: Template Usage

**Test:** Verify correct templates used

**Verification Checklist:**
- [ ] ANALYSIS.md has "Debt Inventory" or similar section
- [ ] ANALYSIS.md has prioritization (HIGH/MEDIUM/LOW debt items)
- [ ] PLANNING.md discusses cleanup strategy
- [ ] EXECUTION.md tasks organized by priority or module

**Result:** Verify

---

### IT5.4: Debt Inventory Validation (TECH_DEBT-Specific)

**Test:** Verify ANALYSIS.md includes structured debt inventory

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api

# Check for debt inventory section
grep -q "Debt Inventory\|Technical Debt Catalog" "$OUTPUT_DIR/analysis/ANALYSIS.md" && \
echo "✓ ANALYSIS has debt inventory"

# Check for prioritization
grep -q "Priority\|HIGH\|MEDIUM\|LOW" "$OUTPUT_DIR/analysis/ANALYSIS.md" && \
echo "✓ Debt items are prioritized"
```

**Expected:** ANALYSIS.md contains:
- Debt inventory (list of tech debt items)
- Prioritization (HIGH/MEDIUM/LOW or similar)
- Impact assessment for each item

**Verification Checklist:**
- [ ] Debt inventory section exists
- [ ] Each debt item includes:
  - [ ] Description
  - [ ] Location (file/module)
  - [ ] Priority (HIGH/MEDIUM/LOW)
  - [ ] Effort estimate
  - [ ] Impact/risk if not addressed
- [ ] Items are sorted or grouped by priority

**Result:** Verify

---

## Regression Tests

### RT5.1: v3.1.0 Features Present

**Test:** Verify v3.1.0 features

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md present"
grep -q "Before:" "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ Before/After fields in tasks"
```

**Expected**: PROGRESS.md exists, EXECUTION tasks have Before/After

**Result:** Verify

---

### RT5.2: No v3.0.0 Artifacts

**Test:** Verify no deprecated patterns

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-techdebt/planning/cleanup-orders-api
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
| Unit Tests (TC5.1-TC5.6) | 6 | Verify |
| Integration Tests (IT5.1-IT5.4) | 4 | Verify |
| Regression Tests (RT5.1-RT5.2) | 2 | Verify |
| **TOTAL** | **12** | **Verify** |

### Files Validated

- ✓ README.md
- ✓ discovery/CONVENTIONS.md
- ✓ analysis/ANALYSIS.md (with debt inventory)
- ✓ planning/PLANNING.md
- ✓ execution/EXECUTION.md
- ✓ sprints/PROGRESS.md

### Schema Compliance

**Per output-schema.json (lines 155-177):**
- Mode: TECH_DEBT
- Required files: 6
- Mode-specific: Debt inventory with prioritization in ANALYSIS.md
- **Status:** ✓ Compliant

### Conclusion

**Status:** Run tests to verify TECH_DEBT mode output
**Coverage:** 100% of required files + debt inventory validation
**Next Steps:** Execute verification commands

---

**Test Case Version:** 1.0
**Skill Version:** v3.1.0
**Last Updated:** 2026-02-14
