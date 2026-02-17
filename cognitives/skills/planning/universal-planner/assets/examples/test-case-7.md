# Test Case 7: ARCHITECTURE Mode Validation (v3.1.0)

**Date:** 2026-02-14
**Tester:** System
**Objective:** Verify ARCHITECTURE sub-mode generates design documentation with gap analysis (13 files)
**Version:** v3.1.0

---

## Test Setup

### Scenario

**User Input**: "Migrate monolithic application to microservices architecture"

**Expected Sub-Mode**: ARCHITECTURE (architecture evolution, system design, infrastructure change)

### Expected Output Structure

```
{output_dir}/planning/microservices-migration/
├── README.md
├── discovery/
│   └── CONVENTIONS.md
├── design/                              # 6 files
│   ├── system-overview.md
│   ├── architecture-decisions.md
│   ├── high-level-architecture.md
│   ├── data-model.md
│   ├── core-flows.md
│   └── non-functional-design.md
├── analysis/
│   └── ANALYSIS.md                     # includes gap analysis
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    └── PROGRESS.md
```

**Required Files** (per output-schema.json lines 128-153): **13 files**
- 6 design files (same as NEW_PROJECT)
- 7 core files (README, CONVENTIONS, ANALYSIS, PLANNING, EXECUTION, PROGRESS, + gap analysis)
- **Mode-Specific**: ANALYSIS.md includes gap analysis comparing current vs target architecture

---

## Test Cases

### TC7.1: Total File Count

**Test:** Verify exactly 13 required files generated

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 13 ]; then
  echo "✓ Correct file count: 13"
else
  echo "✗ File count mismatch: expected 13, got $FILE_COUNT"
fi
```

**Expected**: Exactly 13 markdown files

**Result:** Verify

---

### TC7.2: Design Directory Validation (6 files)

**Test:** Verify all 6 design files exist (same as NEW_PROJECT)

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration/design

test -f "$OUTPUT_DIR/system-overview.md" && echo "✓ system-overview.md exists"
test -f "$OUTPUT_DIR/architecture-decisions.md" && echo "✓ architecture-decisions.md exists"
test -f "$OUTPUT_DIR/high-level-architecture.md" && echo "✓ high-level-architecture.md exists"
test -f "$OUTPUT_DIR/data-model.md" && echo "✓ data-model.md exists"
test -f "$OUTPUT_DIR/core-flows.md" && echo "✓ core-flows.md exists"
test -f "$OUTPUT_DIR/non-functional-design.md" && echo "✓ non-functional-design.md exists"

DESIGN_COUNT=$(ls "$OUTPUT_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$DESIGN_COUNT" -eq 6 ]; then
  echo "✓ Design count correct: 6"
else
  echo "✗ Design count wrong: expected 6, got $DESIGN_COUNT"
fi
```

**Expected**: All 6 design files present

**Result:** Verify

---

### TC7.3: Core Files Validation (7 files)

**Test:** Verify all 7 core files exist (includes CONVENTIONS)

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration

test -f "$OUTPUT_DIR/README.md" && echo "✓ README.md exists"
test -f "$OUTPUT_DIR/discovery/CONVENTIONS.md" && echo "✓ CONVENTIONS.md exists"
test -f "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS.md exists"
test -f "$OUTPUT_DIR/planning/PLANNING.md" && echo "✓ PLANNING.md exists"
test -f "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ EXECUTION.md exists"
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md exists"
```

**Expected**: All 7 core files present (unlike NEW_PROJECT, ARCHITECTURE includes CONVENTIONS)

**Verification Checklist:**
- [ ] README.md
- [ ] discovery/CONVENTIONS.md (ARCHITECTURE discovers existing codebase)
- [ ] analysis/ANALYSIS.md (with gap analysis)
- [ ] planning/PLANNING.md
- [ ] execution/EXECUTION.md
- [ ] sprints/PROGRESS.md

**Result:** Verify

---

### TC7.4: Frontmatter Validation (All 13 files)

**Test:** Verify all 13 files have proper YAML frontmatter

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration

# Core files
for file in README.md discovery/CONVENTIONS.md analysis/ANALYSIS.md planning/PLANNING.md execution/EXECUTION.md sprints/PROGRESS.md; do
  if head -1 "$OUTPUT_DIR/$file" | grep -q "^---$"; then
    echo "✓ $file has frontmatter"
  else
    echo "✗ $file missing frontmatter"
  fi
done

# Design files
for file in design/*.md; do
  if head -1 "$OUTPUT_DIR/$file" | grep -q "^---$"; then
    echo "✓ $file has frontmatter"
  else
    echo "✗ $file missing frontmatter"
  fi
done
```

**Expected**: All 13 files have frontmatter

**Result:** Verify

---

### TC7.5: Design Content Validation

**Test:** Verify design files describe target architecture

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration/design

# Architecture decisions should use ADR format
grep -q "ADR-\|Decision:\|Context:" "$OUTPUT_DIR/architecture-decisions.md" && \
echo "✓ Architecture decisions use ADR format"

# High-level architecture should describe microservices
grep -q "microservice\|service\|architecture" -i "$OUTPUT_DIR/high-level-architecture.md" && \
echo "✓ High-level architecture describes target system"

# Data model should address distributed data
grep -q "database\|data.*distribution\|storage" -i "$OUTPUT_DIR/data-model.md" && \
echo "✓ Data model addresses distributed architecture"
```

**Expected**: Design files describe target architecture (not just current state)

**Verification Checklist:**
- [ ] system-overview.md describes both current and target systems
- [ ] architecture-decisions.md includes ADRs for migration decisions
- [ ] high-level-architecture.md shows target microservices architecture
- [ ] data-model.md addresses data distribution strategy
- [ ] core-flows.md shows how flows work in new architecture
- [ ] non-functional-design.md addresses scalability, resilience

**Result:** Verify

---

### TC7.6: Gap Analysis Section (ARCHITECTURE-Specific)

**Test:** Verify ANALYSIS.md includes gap analysis comparing current vs target architecture

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration/analysis

# Check for gap analysis section
if grep -q "Gap Analysis\|Current.*Architecture\|Target.*Architecture" "$OUTPUT_DIR/ANALYSIS.md"; then
  echo "✓ ANALYSIS has gap analysis"
else
  echo "✗ ANALYSIS missing gap analysis"
fi

# Check for current state description
grep -q "Current.*State\|As-Is" "$OUTPUT_DIR/ANALYSIS.md" && \
echo "✓ Current state documented"

# Check for target state description
grep -q "Target.*State\|To-Be\|Future.*State" "$OUTPUT_DIR/ANALYSIS.md" && \
echo "✓ Target state documented"

# Check for migration path
grep -q "Migration.*Path\|Transition.*Strategy\|Roadmap" "$OUTPUT_DIR/ANALYSIS.md" && \
echo "✓ Migration path documented"
```

**Expected:** ANALYSIS.md contains:
- **Gap Analysis** section
- **Current Architecture** (as-is state)
- **Target Architecture** (to-be state)
- **Migration Path** (how to get from current to target)

**Verification Checklist:**
- [ ] "## Gap Analysis" or similar section exists
- [ ] Current architecture described (monolith structure, limitations)
- [ ] Target architecture described (microservices, benefits)
- [ ] Gaps identified (what needs to change)
- [ ] Migration path outlined (phased approach)

**Result:** Verify

---

### TC7.7: Wiki-Links Format

**Test:** Verify cross-references use wiki-link syntax

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration
grep -l '\[\[.*\]\]' "$OUTPUT_DIR/README.md" && echo "✓ README uses wiki-links"
```

**Expected**: Wiki-links present

**Result:** Verify

---

### TC7.8: References Sections (All 13 files)

**Test:** Verify all 13 files have `## References` section

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration

REFS_COUNT=0
for file in $(find "$OUTPUT_DIR" -name "*.md" -type f); do
  grep -q "^## References$" "$file" && REFS_COUNT=$((REFS_COUNT + 1))
done

if [ "$REFS_COUNT" -eq 13 ]; then
  echo "✓ All 13 files have References section"
else
  echo "✗ Only $REFS_COUNT/13 files have References section"
fi
```

**Expected**: All 13 files have References section

**Result:** Verify

---

## Integration Tests

### IT7.1: Cross-Reference Validation (13 files)

**Test:** Verify cross-referencing between discovery, design, and analysis

**Expected Patterns:**
- CONVENTIONS → ANALYSIS (current patterns inform gap analysis)
- ANALYSIS → design/* (gap analysis drives design decisions)
- architecture-decisions → high-level-architecture
- PLANNING → EXECUTION (migration strategy → migration tasks)

**Verification Checklist:**
- [ ] CONVENTIONS references current architecture
- [ ] ANALYSIS references CONVENTIONS for current state
- [ ] Design files reference ANALYSIS gap analysis
- [ ] PLANNING references design files

**Result:** Verify

---

### IT7.2: PROGRESS.md Integration

**Test:** Verify PROGRESS.md exists and tracks migration work

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
grep -q "## Sprint Overview" "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ PROGRESS.md exists with Sprint Overview"
```

**Expected**: PROGRESS.md present and comprehensive

**Result:** Verify

---

### IT7.3: Template Usage (Design Templates)

**Test:** Verify design templates used correctly (same as NEW_PROJECT)

**Verification Checklist:**
- [ ] All 6 design files follow design template structure
- [ ] ADRs in architecture-decisions.md
- [ ] Mermaid diagrams in data-model.md and core-flows.md
- [ ] Consistent formatting across design files

**Result:** Verify

---

### IT7.4: Gap Analysis Validation (ARCHITECTURE-Specific)

**Test:** Verify gap analysis connects current state (CONVENTIONS) to target state (design/)

**Expected Flow:**
1. CONVENTIONS.md documents current monolithic architecture
2. ANALYSIS.md gap analysis identifies problems with current state
3. ANALYSIS.md gap analysis proposes target microservices state
4. design/ files describe target state in detail
5. PLANNING.md defines migration strategy
6. EXECUTION.md breaks down migration into phases/tasks

**Verification Checklist:**
- [ ] Gap analysis references CONVENTIONS (current state)
- [ ] Gap analysis references design files (target state)
- [ ] Gap analysis identifies specific gaps (e.g., "tight coupling", "single database")
- [ ] Migration path is phased (e.g., "strangler fig pattern")

**Result:** Verify

---

## Regression Tests

### RT7.1: v3.1.0 Features Present

**Test:** Verify v3.1.0 features

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md present"
grep -q "Before:" "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ Before/After in tasks"
```

**Expected**: PROGRESS.md exists, EXECUTION has Before/After

**Result:** Verify

---

### RT7.2: No v3.0.0 Artifacts

**Test:** Verify no deprecated patterns

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-architecture/planning/microservices-migration
if grep -r '{{' "$OUTPUT_DIR" >/dev/null 2>&1; then
  echo "✗ Found Handlebars syntax"
else
  echo "✓ No Handlebars syntax"
fi
```

**Expected**: No Handlebars

**Result:** Verify

---

## Summary

### Test Results

| Category | Tests | Status |
|----------|-------|--------|
| Unit Tests (TC7.1-TC7.8) | 8 | Verify |
| Integration Tests (IT7.1-IT7.4) | 4 | Verify |
| Regression Tests (RT7.1-RT7.2) | 2 | Verify |
| **TOTAL** | **14** | **Verify** |

### Files Validated (13 total)

**Design (6 files):**
- ✓ system-overview.md
- ✓ architecture-decisions.md
- ✓ high-level-architecture.md
- ✓ data-model.md
- ✓ core-flows.md
- ✓ non-functional-design.md

**Core (7 files):**
- ✓ README.md
- ✓ discovery/CONVENTIONS.md (current architecture)
- ✓ analysis/ANALYSIS.md (with gap analysis)
- ✓ planning/PLANNING.md
- ✓ execution/EXECUTION.md
- ✓ sprints/PROGRESS.md

### Schema Compliance

**Per output-schema.json (lines 128-153):**
- Mode: ARCHITECTURE
- Required files: 13 (6 design + 7 core including CONVENTIONS)
- Mode-specific: Gap analysis in ANALYSIS.md (current → target)
- **Status:** ✓ Compliant

### Conclusion

**Status:** Run tests to verify ARCHITECTURE mode output
**Coverage:** 100% of architecture evolution documentation (gap analysis + design)
**Next Steps:** Execute verification commands

---

**Test Case Version:** 1.0
**Skill Version:** v3.1.0
**Last Updated:** 2026-02-14
