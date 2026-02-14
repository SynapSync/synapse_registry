# Test Case 1: Assets Pattern Smoke Test (v3.0.0)

**Date:** 2026-02-13
**Tester:** System
**Objective:** Verify that universal-planner v3.0.0 can access and reference all assets after consolidation
**Version:** Updated for v3.0.0 (universal-planner + universal-planner-executor consolidation)

---

## Test Setup

### Assets Structure Verified

```bash
$ ls -la assets/
drwxr-xr-x  examples/
drwxr-xr-x  helpers/
drwxr-xr-x  modes/
-rw-r--r--  README.md
drwxr-xr-x  templates/
drwxr-xr-x  validators/
```

### File Counts

| Directory | Files | Expected | Status |
|-----------|-------|----------|--------|
| `modes/` | 8 | PLAN, EXECUTE, NEW_PROJECT, NEW_FEATURE, REFACTOR, BUG_FIX, TECH_DEBT, ARCHITECTURE | Verify |
| `helpers/` | 4 | config-resolver, decision-log, code-quality-standards, troubleshooting | Verify |
| `templates/` | 7 | ANALYSIS, PLANNING, CONVENTIONS, EXECUTION, SPRINT, RETRO, PROGRESS | Verify |
| `validators/` | 2 | output-schema.json, README.md | Verify |
| `examples/` | 1 | test-case-1.md (this file) | Verify |

**Total assets:** 22 files + README.md = 23 files

---

## Test Cases

### TC1.1: Modes Directory Accessibility

**Test:** Verify all 8 mode files exist and are readable

**Command:**
```bash
ls assets/modes/
```

**Expected:**
```
ARCHITECTURE.md
BUG_FIX.md
EXECUTE.md
NEW_FEATURE.md
NEW_PROJECT.md
PLAN.md
REFACTOR.md
TECH_DEBT.md
```

**Verification:**
```bash
$ ls assets/modes/ | wc -l
8
```

**Result:** Verify

---

### TC1.2: Helpers Directory Accessibility

**Test:** Verify all 4 helper files exist and are readable

**Command:**
```bash
ls assets/helpers/
```

**Expected:**
```
code-quality-standards.md
config-resolver.md
decision-log.md
troubleshooting.md
```

**Verification:**
```bash
$ ls assets/helpers/ | wc -l
4
```

**Content Checks:**
- [ ] config-resolver.md contains "Configuration Resolver" or "Purpose" section
- [ ] decision-log.md contains DEC- format documentation
- [ ] code-quality-standards.md contains production code standards
- [ ] troubleshooting.md contains PLAN and EXECUTE mode issues

**Result:** Verify

---

### TC1.3: Templates Directory Accessibility

**Test:** Verify all 7 templates exist with frontmatter

**Command:**
```bash
for file in ANALYSIS.md PLANNING.md CONVENTIONS.md EXECUTION.md SPRINT.md RETRO.md PROGRESS.md; do
  if grep -q "^---$" assets/templates/$file; then
    echo "$file has frontmatter"
  else
    echo "$file missing frontmatter"
  fi
done
```

**Expected:** All 7 files have frontmatter

**Template Verification:**
- [ ] ANALYSIS.md (frontmatter + placeholders)
- [ ] PLANNING.md (frontmatter + placeholders)
- [ ] CONVENTIONS.md (frontmatter + placeholders)
- [ ] EXECUTION.md (frontmatter + placeholders)
- [ ] SPRINT.md (frontmatter + placeholders)
- [ ] RETRO.md (template with K/P/L/A sections)
- [ ] PROGRESS.md (frontmatter + Sprint Overview table + Global Metrics + Blockers)

**Result:** Verify

---

### TC1.4: Validators Directory Accessibility

**Test:** Verify JSON schema is valid and README exists

**Command:**
```bash
python3 -c "import json; json.load(open('assets/validators/output-schema.json'))" && echo "Valid JSON"
test -f assets/validators/README.md && echo "README exists"
```

**Expected:** Valid JSON + README exists

**Schema Verification:**
- [ ] Valid JSON syntax
- [ ] Contains `$schema` field
- [ ] Defines 6 modes (NEW_PROJECT, NEW_FEATURE, REFACTOR, BUG_FIX, TECH_DEBT, ARCHITECTURE)
- [ ] Mode-specific requirements defined
- [ ] `sprints/PROGRESS.md` listed as required for all modes

**Result:** Verify

---

### TC1.5: Cross-References Working

**Test:** Verify SKILL.md can reference assets without breaking

**Expected Behavior:**
When SKILL.md is read by an LLM, references like:
```markdown
See [assets/modes/NEW_PROJECT.md](assets/modes/NEW_PROJECT.md)
```

Should be resolvable relative to SKILL.md location.

**Manual Verification:**
- [ ] README.md references are correct
- [ ] Mode references point to existing files (8 files)
- [ ] Helper references point to existing files (4 files)
- [ ] Template references point to existing files (7 files)
- [ ] PLAN.md references PROGRESS template

**Result:** Verify

---

### TC1.6: No Broken Assets

**Test:** Ensure no broken symlinks or inaccessible files

**Command:**
```bash
find assets/ -type f -exec test -r {} \; -print | wc -l
```

**Expected:** Count matches total files (23)

**Result:** Verify

---

## Integration Tests

### IT1: Simulated Mode Detection -> Asset Lookup

**Scenario:** Skill detects NEW_PROJECT mode and needs to reference mode-specific guidance

**Steps:**
1. Skill determines mode = "NEW_PROJECT"
2. Skill looks up `assets/modes/NEW_PROJECT.md`
3. Skill reads mode-specific workflow and requirements

**Expected:** File exists and contains:
- "When to Use" section
- "Output Structure" section
- "Workflow" section
- Requirements/Design specifications

**Verification:**
```bash
$ grep -c "## When to Use" assets/modes/NEW_PROJECT.md
1
$ grep -c "## Output Structure" assets/modes/NEW_PROJECT.md
1
$ grep -c "## Workflow" assets/modes/NEW_PROJECT.md
1
```

**Result:** Verify

---

### IT2: Simulated Config Resolution

**Scenario:** Skill needs to resolve output_base

**Steps:**
1. Skill references `assets/helpers/config-resolver.md`
2. Skill follows workflow documented in helper
3. Skill creates/reads cognitive.config.json

**Expected:** Helper documents:
- Step 1: Check for config file
- Step 2: Read if found
- Step 3: Ask user if not found
- Step 4: Use {output_base}

**Verification:**
```bash
$ grep -c "Step 1: Check for Config File" assets/helpers/config-resolver.md
1
$ grep -c "Step 2: If Found" assets/helpers/config-resolver.md
1
$ grep -c "Step 3: If NOT Found" assets/helpers/config-resolver.md
1
```

**Result:** Verify

---

### IT3: Simulated Template Usage (ANALYSIS)

**Scenario:** Skill needs to generate ANALYSIS.md

**Expected:** Template contains frontmatter with placeholders and section structure.

**Result:** Verify

---

### IT4: PLAN -> EXECUTE Contract Validation

**Scenario:** Verify PLAN mode output can be consumed by EXECUTE mode

**Checks:**
- [ ] EXECUTION.md template task format includes Files, Before/After, Verification, Rollback
- [ ] PROGRESS.md template includes Sprint Overview table, Global Metrics, Blockers
- [ ] output-schema.json lists PROGRESS.md as required for all modes
- [ ] EXECUTE.md Step 0 validates PROGRESS.md existence
- [ ] Task granularity in EXECUTION.md matches SKILL.md (Sprint/Phase/Task/Subtask)

**Result:** Verify

---

### IT5: PLAN.md Step 5 -> PROGRESS.md Always Generated

**Scenario:** Verify PROGRESS.md is always generated regardless of user choice on sprint files

**Checks:**
- [ ] PLAN.md Step 5a generates PROGRESS.md always
- [ ] PLAN.md Step 5b asks user only about SPRINT-*.md files
- [ ] output-schema.json requires PROGRESS.md for all modes

**Result:** Verify

---

## Regression Tests

### RT1: SKILL.md Still Valid

**Test:** Verify SKILL.md is still a valid skill after v3.0.0 consolidation

**Checks:**
- [ ] Has YAML frontmatter with name, description, license, metadata
- [ ] Contains ## Purpose section
- [ ] Contains ## Critical Rules section (8 rules)
- [ ] Contains ## Mode Detection section
- [ ] Contains ## Capabilities Matrix
- [ ] Contains ## Sprint Structure Standards with L1-L4 granularity
- [ ] References to assets/ are valid relative paths
- [ ] Version is 3.0 in frontmatter

**Result:** Verify

---

### RT2: Consolidated Assets Present

**Test:** Verify executor assets were properly moved from universal-planner-executor

**Checks:**
- [ ] `assets/templates/RETRO.md` exists (moved from executor)
- [ ] `assets/helpers/decision-log.md` exists (moved from executor)
- [ ] `assets/helpers/code-quality-standards.md` exists (moved from executor)
- [ ] `assets/helpers/troubleshooting.md` exists (merged from both skills)
- [ ] `assets/modes/EXECUTE.md` exists (new in v3.0.0)
- [ ] `assets/modes/PLAN.md` exists (new in v3.0.0)

**Result:** Verify

---

## Summary

### Test Results

| Category | Tests | Status |
|----------|-------|--------|
| Unit Tests (TC1.1-TC1.6) | 6 | Verify |
| Integration Tests (IT1-IT5) | 5 | Verify |
| Regression Tests (RT1-RT2) | 2 | Verify |
| **TOTAL** | **13** | **Verify** |

### Assets Validated

- Modes: 8 files (6 sub-modes + PLAN.md + EXECUTE.md)
- Helpers: 4 files (config-resolver, decision-log, code-quality-standards, troubleshooting)
- Templates: 7 files (ANALYSIS, PLANNING, CONVENTIONS, EXECUTION, SPRINT, RETRO, PROGRESS)
- Validators: 2 files (output-schema.json, README.md)
- Examples: 1 file (this file)
- Assets README: 1 file
- **Total: 23 asset files**

### Conclusion

**Status:** Run tests to verify v3.0.0 asset integrity

---

**Test Updated:** 2026-02-13
**Version:** v3.0.0
