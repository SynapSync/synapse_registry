# Universal Planner Test Suite

Comprehensive test cases for validating the universal-planner skill v3.1.1 output across all planning sub-modes.

## Test Suite Overview

| Test Case | Mode | Required Files | Mode-Specific Feature | Version |
|-----------|------|----------------|----------------------|---------|
| [test-case-1.md](test-case-1.md) | Assets Pattern | 23 (now 29) | Smoke test for v3.0.0 consolidation | v3.0.0 |
| [test-case-2.md](test-case-2.md) | NEW_FEATURE | 6 | Codebase discovery + feature analysis | v3.1.0 |
| [test-case-3.md](test-case-3.md) | REFACTOR | 6 | `scope_modules` frontmatter | v3.1.0 |
| [test-case-4.md](test-case-4.md) | BUG_FIX | 2 (fast) / 6 (standard) | Fast path for LOW/MEDIUM severity | v3.1.0 |
| [test-case-5.md](test-case-5.md) | TECH_DEBT | 6 | Debt inventory with prioritization | v3.1.0 |
| [test-case-6.md](test-case-6.md) | NEW_PROJECT | 18 | Requirements (7) + Design (6) documents | v3.1.0 |
| [test-case-7.md](test-case-7.md) | ARCHITECTURE | 13 | Gap analysis (current → target) | v3.1.0 |

**Total Test Cases:** 7
**Total Test Coverage:** 100% of planning sub-modes
**Schema Compliance:** All test cases validate against `assets/validators/output-schema.json`

---

## Test Case Structure

Each test case follows a standardized structure:

### Sections

1. **Test Setup** — Scenario description, expected sub-mode, output structure
2. **Test Cases (TC)** — Unit tests validating individual components
3. **Integration Tests (IT)** — Cross-reference and workflow validation
4. **Regression Tests (RT)** — Version-specific feature validation
5. **Summary** — Test results table, files validated, schema compliance

### Test Categories

- **TC (Unit Tests)** — File existence, frontmatter, content validation
- **IT (Integration Tests)** — Cross-references, template usage, workflow validation
- **RT (Regression Tests)** — Version-specific features (v3.1.0 vs v3.0.0)

### Verification Commands

All tests include bash commands for automated verification:

```bash
# File count validation
FILE_COUNT=$(find "$OUTPUT_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 6 ]; then
  echo "✓ Correct file count: 6"
fi

# Frontmatter validation
head -1 "$OUTPUT_DIR/README.md" | grep -q "^---$" && echo "✓ Has frontmatter"

# Content validation
grep -q "## Executive Summary" "$OUTPUT_DIR/README.md" && echo "✓ Has Executive Summary"
```

---

## Mode-Specific Features

### BUG_FIX Fast Path (test-case-4)

- **Trigger:** Severity = LOW or MEDIUM
- **Output:** 2 files (ANALYSIS.md + SPRINT-1-hotfix.md)
- **Validation:** TC4.1, TC4.7, IT4.3

### NEW_PROJECT Requirements & Design (test-case-6)

- **Requirements:** 7 files (problem-definition, goals, stakeholders, functional, non-functional, assumptions, out-of-scope)
- **Design:** 6 files (system-overview, architecture-decisions, high-level-architecture, data-model, core-flows, non-functional-design)
- **Validation:** TC6.2, TC6.3, TC6.6, TC6.7

### ARCHITECTURE Gap Analysis (test-case-7)

- **Feature:** ANALYSIS.md includes current → target architecture comparison
- **Sections:** Gap Analysis, Current Architecture, Target Architecture, Migration Path
- **Validation:** TC7.6, IT7.4

### REFACTOR scope_modules (test-case-3)

- **Feature:** ANALYSIS.md frontmatter includes `scope_modules: ["module-a", "module-b"]`
- **Validation:** IT3.4

### TECH_DEBT Inventory (test-case-5)

- **Feature:** ANALYSIS.md includes structured debt inventory with prioritization
- **Sections:** Debt Inventory, Priority (HIGH/MEDIUM/LOW), Impact Assessment
- **Validation:** IT5.4

---

## Running Tests

### Full Test Suite

Run all test cases sequentially:

```bash
cd cognitives/skills/planning/universal-planner/assets/examples/

# Execute each test case's verification commands
for test in test-case-{2..7}.md; do
  echo "Running $test..."
  # Extract and run bash commands from test case
done
```

### Individual Test Case

Run a single test case:

```bash
# Example: Run NEW_FEATURE test (test-case-2)
OUTPUT_DIR=~/.agents/test-newfeature/planning/dark-mode-feature

# Run all TC, IT, RT commands from test-case-2.md
```

### Schema Validation

Validate test output against schema:

```bash
# Check required files per mode
python3 -c "
import json
schema = json.load(open('assets/validators/output-schema.json'))
# Validate output against schema['modes']['NEW_FEATURE']['required_files']
"
```

---

## Test Results Expected

### Success Criteria

Each test case should show:

```
| Category | Tests | Status |
|----------|-------|--------|
| Unit Tests (TC) | 6-10 | ✓ Pass |
| Integration Tests (IT) | 4-5 | ✓ Pass |
| Regression Tests (RT) | 2 | ✓ Pass |
| **TOTAL** | **12-17** | **✓ Pass** |
```

### Coverage Metrics

- **Mode Coverage:** 100% (6 planning sub-modes + assets pattern)
- **File Coverage:** 18 files (NEW_PROJECT) to 2 files (BUG_FIX fast path)
- **Feature Coverage:** All v3.1.0 features (PROGRESS.md, Before/After, fast path, gap analysis, etc.)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v3.1.1 | 2026-02-14 | Added 6 mode validation test cases (test-case-2 through test-case-7), created test suite index |
| v3.0.0 | 2026-02-13 | Initial test suite with assets pattern smoke test (test-case-1) |

---

## Schema Reference

All test cases validate against [assets/validators/output-schema.json](../validators/output-schema.json).

### Mode Requirements Summary

| Mode | Files | Mode-Specific |
|------|-------|---------------|
| NEW_PROJECT | 18 | 7 requirements + 6 design (no CONVENTIONS) |
| NEW_FEATURE | 6 | CONVENTIONS + feature analysis |
| REFACTOR | 6 | CONVENTIONS + `scope_modules` |
| BUG_FIX | 2/6 | Fast path (LOW/MEDIUM) or standard |
| TECH_DEBT | 6 | CONVENTIONS + debt inventory |
| ARCHITECTURE | 13 | 6 design + gap analysis + CONVENTIONS |

---

## Contributing

When adding new test cases:

1. Follow the standardized structure (Setup → TC → IT → RT → Summary)
2. Validate against `output-schema.json`
3. Include bash verification commands
4. Update this README with new test case entry
5. Update `assets/README.md` examples count
6. Update `manifest.json` examples count

---

**Last Updated:** 2026-02-14
**Version:** v3.1.1
**Total Test Cases:** 7
**Maintainer:** SynapSync
