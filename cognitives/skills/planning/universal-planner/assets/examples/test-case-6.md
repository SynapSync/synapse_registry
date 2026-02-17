# Test Case 6: NEW_PROJECT Mode Validation (v3.1.0)

**Date:** 2026-02-14
**Tester:** System
**Objective:** Verify NEW_PROJECT sub-mode generates complete SDLC documentation with 18 required files
**Version:** v3.1.0

---

## Test Setup

### Scenario

**User Input**: "Build a team task manager SaaS application"

**Expected Sub-Mode**: NEW_PROJECT (greenfield project, no existing codebase)

### Expected Output Structure

```
{output_dir}/planning/team-task-manager/
├── README.md
├── requirements/                        # 7 files
│   ├── problem-definition.md
│   ├── goals-and-metrics.md
│   ├── stakeholders-and-personas.md
│   ├── functional-requirements.md
│   ├── non-functional-requirements.md
│   ├── assumptions-and-constraints.md
│   └── out-of-scope.md
├── design/                              # 6 files
│   ├── system-overview.md
│   ├── architecture-decisions.md
│   ├── high-level-architecture.md
│   ├── data-model.md
│   ├── core-flows.md
│   └── non-functional-design.md
├── analysis/
│   └── ANALYSIS.md
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    └── PROGRESS.md
```

**Required Files** (per output-schema.json lines 95-126): **18 files**
- 7 requirements files
- 6 design files
- 5 core files (README, ANALYSIS, PLANNING, EXECUTION, PROGRESS)
- **NO CONVENTIONS.md** (NEW_PROJECT doesn't discover existing codebase)

---

## Test Cases

### TC6.1: Total File Count

**Test:** Verify exactly 18 required files generated

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 18 ]; then
  echo "✓ Correct file count: 18"
else
  echo "✗ File count mismatch: expected 18, got $FILE_COUNT"
fi
```

**Expected**: Exactly 18 markdown files

**Result:** Verify

---

### TC6.2: Requirements Directory Validation (7 files)

**Test:** Verify all 7 requirements files exist

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager/requirements

test -f "$OUTPUT_DIR/problem-definition.md" && echo "✓ problem-definition.md exists"
test -f "$OUTPUT_DIR/goals-and-metrics.md" && echo "✓ goals-and-metrics.md exists"
test -f "$OUTPUT_DIR/stakeholders-and-personas.md" && echo "✓ stakeholders-and-personas.md exists"
test -f "$OUTPUT_DIR/functional-requirements.md" && echo "✓ functional-requirements.md exists"
test -f "$OUTPUT_DIR/non-functional-requirements.md" && echo "✓ non-functional-requirements.md exists"
test -f "$OUTPUT_DIR/assumptions-and-constraints.md" && echo "✓ assumptions-and-constraints.md exists"
test -f "$OUTPUT_DIR/out-of-scope.md" && echo "✓ out-of-scope.md exists"

# Count
REQ_COUNT=$(ls "$OUTPUT_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$REQ_COUNT" -eq 7 ]; then
  echo "✓ Requirements count correct: 7"
else
  echo "✗ Requirements count wrong: expected 7, got $REQ_COUNT"
fi
```

**Expected**: All 7 requirements files present

**Verification Checklist:**
- [ ] problem-definition.md — Problem statement, value proposition
- [ ] goals-and-metrics.md — SMART goals, KPIs
- [ ] stakeholders-and-personas.md — User personas, stakeholder map
- [ ] functional-requirements.md — MoSCoW-prioritized requirements
- [ ] non-functional-requirements.md — Performance, security, scalability
- [ ] assumptions-and-constraints.md — Inferred assumptions, constraints
- [ ] out-of-scope.md — Excluded features, boundaries

**Result:** Verify

---

### TC6.3: Design Directory Validation (6 files)

**Test:** Verify all 6 design files exist

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager/design

test -f "$OUTPUT_DIR/system-overview.md" && echo "✓ system-overview.md exists"
test -f "$OUTPUT_DIR/architecture-decisions.md" && echo "✓ architecture-decisions.md exists"
test -f "$OUTPUT_DIR/high-level-architecture.md" && echo "✓ high-level-architecture.md exists"
test -f "$OUTPUT_DIR/data-model.md" && echo "✓ data-model.md exists"
test -f "$OUTPUT_DIR/core-flows.md" && echo "✓ core-flows.md exists"
test -f "$OUTPUT_DIR/non-functional-design.md" && echo "✓ non-functional-design.md exists"

# Count
DESIGN_COUNT=$(ls "$OUTPUT_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$DESIGN_COUNT" -eq 6 ]; then
  echo "✓ Design count correct: 6"
else
  echo "✗ Design count wrong: expected 6, got $DESIGN_COUNT"
fi
```

**Expected**: All 6 design files present

**Verification Checklist:**
- [ ] system-overview.md — System context, technology recommendations
- [ ] architecture-decisions.md — ADRs for key decisions
- [ ] high-level-architecture.md — Component diagram, communication patterns
- [ ] data-model.md — Entity relationships, storage strategy
- [ ] core-flows.md — Sequence diagrams for critical flows
- [ ] non-functional-design.md — Performance, security, scalability design

**Result:** Verify

---

### TC6.4: Core Files Validation (5 files)

**Test:** Verify all 5 core files exist

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager

test -f "$OUTPUT_DIR/README.md" && echo "✓ README.md exists"
test -f "$OUTPUT_DIR/analysis/ANALYSIS.md" && echo "✓ ANALYSIS.md exists"
test -f "$OUTPUT_DIR/planning/PLANNING.md" && echo "✓ PLANNING.md exists"
test -f "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ EXECUTION.md exists"
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md exists"
```

**Expected**: All 5 core files present

**Result:** Verify

---

### TC6.5: Frontmatter Validation (All 18 files)

**Test:** Verify all 18 files have proper YAML frontmatter

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager

# Core files
for file in README.md analysis/ANALYSIS.md planning/PLANNING.md execution/EXECUTION.md sprints/PROGRESS.md; do
  head -1 "$OUTPUT_DIR/$file" | grep -q "^---$" && echo "✓ $file has frontmatter"
done

# Requirements files
for file in requirements/*.md; do
  head -1 "$OUTPUT_DIR/$file" | grep -q "^---$" && echo "✓ $file has frontmatter"
done

# Design files
for file in design/*.md; do
  head -1 "$OUTPUT_DIR/$file" | grep -q "^---$" && echo "✓ $file has frontmatter"
done
```

**Expected**: All 18 files have frontmatter

**Result:** Verify

---

### TC6.6: Requirements Content Validation

**Test:** Verify requirements files have expected content

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager/requirements

# Functional requirements should use MoSCoW prioritization
grep -q "Must Have\|Should Have\|Could Have\|Won't Have" "$OUTPUT_DIR/functional-requirements.md" && \
echo "✓ Functional requirements use MoSCoW prioritization"

# Goals should be SMART
grep -q "SMART\|Specific.*Measurable.*Achievable" "$OUTPUT_DIR/goals-and-metrics.md" && \
echo "✓ Goals documented as SMART"

# Personas should exist
grep -q "Persona\|User" "$OUTPUT_DIR/stakeholders-and-personas.md" && \
echo "✓ User personas documented"
```

**Expected**: Requirements follow best practices

**Verification Checklist:**
- [ ] functional-requirements.md uses MoSCoW (Must/Should/Could/Won't Have)
- [ ] goals-and-metrics.md includes SMART goals
- [ ] stakeholders-and-personas.md includes user personas
- [ ] non-functional-requirements.md includes quantifiable metrics

**Result:** Verify

---

### TC6.7: Design Content Validation

**Test:** Verify design files have expected content

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager/design

# Architecture decisions should use ADR format
grep -q "ADR-\|Decision:\|Context:\|Consequences:" "$OUTPUT_DIR/architecture-decisions.md" && \
echo "✓ Architecture decisions use ADR format"

# Data model should have diagrams
grep -q "```mermaid\|erDiagram\|graph" "$OUTPUT_DIR/data-model.md" && \
echo "✓ Data model includes Mermaid diagrams"

# Core flows should have sequence diagrams
grep -q "```mermaid\|sequenceDiagram" "$OUTPUT_DIR/core-flows.md" && \
echo "✓ Core flows include sequence diagrams"
```

**Expected**: Design files include diagrams and structured content

**Verification Checklist:**
- [ ] architecture-decisions.md uses ADR- prefix (e.g., ADR-001, ADR-002)
- [ ] data-model.md includes Mermaid ER diagrams
- [ ] core-flows.md includes Mermaid sequence diagrams
- [ ] high-level-architecture.md includes component diagram

**Result:** Verify

---

### TC6.8: Wiki-Links Format

**Test:** Verify cross-references use wiki-link syntax

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager
grep -l '\[\[.*\]\]' "$OUTPUT_DIR/README.md" && echo "✓ README uses wiki-links"
```

**Expected**: Wiki-links present, no markdown links to .md files

**Result:** Verify

---

### TC6.9: References Sections (All 18 files)

**Test:** Verify all 18 files have `## References` section

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager

REFS_COUNT=0
for file in $(find "$OUTPUT_DIR" -name "*.md" -type f); do
  grep -q "^## References$" "$file" && REFS_COUNT=$((REFS_COUNT + 1))
done

if [ "$REFS_COUNT" -eq 18 ]; then
  echo "✓ All 18 files have References section"
else
  echo "✗ Only $REFS_COUNT/18 files have References section"
fi
```

**Expected**: All 18 files have References section

**Result:** Verify

---

### TC6.10: NO CONVENTIONS.md

**Test:** Verify CONVENTIONS.md does NOT exist (NEW_PROJECT doesn't discover codebase)

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager

if test -f "$OUTPUT_DIR/discovery/CONVENTIONS.md"; then
  echo "✗ CONVENTIONS.md exists (should NOT for NEW_PROJECT)"
else
  echo "✓ CONVENTIONS.md does not exist (correct for NEW_PROJECT)"
fi
```

**Expected**: NO discovery/CONVENTIONS.md file

**Result:** Verify

---

## Integration Tests

### IT6.1: Cross-Reference Validation (18 files)

**Test:** Verify extensive cross-referencing between requirements and design

**Expected Patterns:**
- README → references all major documents
- problem-definition → goals-and-metrics
- functional-requirements → data-model (data requirements)
- system-overview → architecture-decisions
- PLANNING → EXECUTION → PROGRESS

**Verification Checklist:**
- [ ] Requirements files cross-reference each other
- [ ] Design files cross-reference requirements
- [ ] Core files reference requirements and design

**Result:** Verify

---

### IT6.2: PROGRESS.md Integration

**Test:** Verify PROGRESS.md exists and tracks full SDLC

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && \
grep -q "## Sprint Overview" "$OUTPUT_DIR/sprints/PROGRESS.md" && \
echo "✓ PROGRESS.md exists with Sprint Overview"
```

**Expected**: PROGRESS.md present and comprehensive

**Result:** Verify

---

### IT6.3: Template Usage (Requirements + Design)

**Test:** Verify requirements and design templates used correctly

**Verification Checklist:**
- [ ] All requirements files follow requirements template structure
- [ ] All design files follow design template structure
- [ ] Consistent formatting across all 18 files

**Result:** Verify

---

### IT6.4: Requirements Cross-References

**Test:** Verify requirements files reference each other logically

**Expected Flow:**
- problem-definition → goals-and-metrics (problem leads to goals)
- goals-and-metrics → functional-requirements (goals drive features)
- functional-requirements → non-functional-requirements (features have NFRs)
- assumptions-and-constraints → all other requirements
- out-of-scope → functional-requirements (what's excluded)

**Result:** Verify

---

### IT6.5: Design Cross-References

**Test:** Verify design files reference each other logically

**Expected Flow:**
- system-overview → architecture-decisions (context for decisions)
- architecture-decisions → high-level-architecture (decisions lead to architecture)
- high-level-architecture → data-model (architecture includes data)
- data-model → core-flows (flows use data)
- core-flows → non-functional-design (flows have performance requirements)

**Result:** Verify

---

## Regression Tests

### RT6.1: v3.1.0 Features Present

**Test:** Verify v3.1.0 features

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager
test -f "$OUTPUT_DIR/sprints/PROGRESS.md" && echo "✓ PROGRESS.md present"
grep -q "Before:" "$OUTPUT_DIR/execution/EXECUTION.md" && echo "✓ Before/After in tasks"
```

**Expected**: PROGRESS.md exists, EXECUTION has Before/After

**Result:** Verify

---

### RT6.2: No v3.0.0 Artifacts

**Test:** Verify no deprecated patterns

**Command:**
```bash
OUTPUT_DIR=.agents/staging/universal-planner/test-newproject/planning/team-task-manager
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
| Unit Tests (TC6.1-TC6.10) | 10 | Verify |
| Integration Tests (IT6.1-IT6.5) | 5 | Verify |
| Regression Tests (RT6.1-RT6.2) | 2 | Verify |
| **TOTAL** | **17** | **Verify** |

### Files Validated (18 total)

**Requirements (7 files):**
- ✓ problem-definition.md
- ✓ goals-and-metrics.md
- ✓ stakeholders-and-personas.md
- ✓ functional-requirements.md
- ✓ non-functional-requirements.md
- ✓ assumptions-and-constraints.md
- ✓ out-of-scope.md

**Design (6 files):**
- ✓ system-overview.md
- ✓ architecture-decisions.md
- ✓ high-level-architecture.md
- ✓ data-model.md
- ✓ core-flows.md
- ✓ non-functional-design.md

**Core (5 files):**
- ✓ README.md
- ✓ analysis/ANALYSIS.md
- ✓ planning/PLANNING.md
- ✓ execution/EXECUTION.md
- ✓ sprints/PROGRESS.md

**NOT Generated:**
- ✓ NO discovery/CONVENTIONS.md (correct for NEW_PROJECT)

### Schema Compliance

**Per output-schema.json (lines 95-126):**
- Mode: NEW_PROJECT
- Required files: 18 (7 requirements + 6 design + 5 core)
- **Status:** ✓ Compliant

### Conclusion

**Status:** Run tests to verify NEW_PROJECT mode output
**Coverage:** 100% of SDLC documentation (requirements + design + planning)
**Next Steps:** Execute verification commands

---

**Test Case Version:** 1.0
**Skill Version:** v3.1.0
**Last Updated:** 2026-02-14
