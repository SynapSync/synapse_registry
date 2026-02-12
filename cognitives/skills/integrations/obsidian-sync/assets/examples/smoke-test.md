# Obsidian-Sync Smoke Test

## Purpose

A simple verification test for obsidian-sync functionality. This test ensures the skill can correctly sync files, generate frontmatter, and validate cross-references.

## Test Scenario

Sync 3 markdown documents with different types from a local directory to an Obsidian vault, verify frontmatter generation, and validate cross-references.

## Test Files

### File 1: `test-analysis.md`

```markdown
# Strategic Analysis — Test Project

This is a test analysis document for verifying obsidian-sync functionality.

## Key Findings

- Finding 1: The skill successfully reads source files
- Finding 2: Frontmatter generation works correctly
- Finding 3: Cross-references are validated

## Referencias

**Input Documents:** [[test-conventions]]
```

**Expected type inference:** `analysis` (contains "Strategic Analysis" and "Key Findings")

### File 2: `test-conventions.md`

```markdown
# Project Conventions

This document defines the conventions for the test project.

## Naming Conventions

- Use kebab-case for filenames
- Use PascalCase for components

## Referencias

**Related:** [[test-analysis]]
```

**Expected type inference:** `conventions` (contains "Conventions" in title and section headers)

### File 3: `test-sprint.md`

```markdown
# Sprint 1: Foundation

This is a test sprint plan document.

## Phase 1.1: Setup

- [ ] T-1.1.1 — Initialize project structure
- [ ] T-1.1.2 — Configure development environment

## Graduation Gate

- [ ] All tasks completed
- [ ] Tests passing

## Referencias

**Parent:** [[PROGRESS]]
**Input Documents:** [[test-analysis]], [[test-conventions]]
```

**Expected type inference:** `sprint-plan` (contains "Sprint" in title, tasks, and graduation gate)

## Test Procedure

### Step 1: Prepare Test Files

Create a test directory with the 3 files above:

```bash
mkdir -p /tmp/obsidian-sync-test
# Create the 3 test files
```

### Step 2: Run Obsidian-Sync

Invoke the skill:
```
"sync /tmp/obsidian-sync-test/ to obsidian"
```

### Step 3: Verify Frontmatter Generation

Check that each synced file has complete frontmatter:

**test-analysis.md:**
```yaml
---
title: "Strategic Analysis — Test Project"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "test-project"
type: "analysis"
status: "active"
version: "1.0"
tags:
  - "test-project"
  - "analysis"
  - "strategic"
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Synced to Obsidian"]
related:
  - "[[test-conventions]]"
---
```

**test-conventions.md:**
```yaml
---
title: "Project Conventions"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "test-project"
type: "conventions"
status: "active"
version: "1.0"
tags:
  - "test-project"
  - "conventions"
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Synced to Obsidian"]
related:
  - "[[test-analysis]]"
---
```

**test-sprint.md:**
```yaml
---
title: "Sprint 1: Foundation"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "test-project"
type: "sprint-plan"
status: "active"
version: "1.0"
sprint: 1
progress: 0
parent_doc: "[[PROGRESS]]"
tags:
  - "test-project"
  - "sprint-1"
  - "sprint-plan"
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Synced to Obsidian"]
related:
  - "[[PROGRESS]]"
  - "[[test-analysis]]"
  - "[[test-conventions]]"
---
```

### Step 4: Verify Cross-Reference Validation

Check cross-reference validation report:

**Expected output:**
```
Cross-reference validation:
✓ test-analysis ↔ test-conventions (bidirectional)
✓ test-sprint → test-analysis (unidirectional, test-analysis updated)
✓ test-sprint → test-conventions (unidirectional, test-conventions updated)

3 files validated, 2 fixes applied.
```

**What should be fixed:**
- `test-analysis.md` should have `[[test-sprint]]` added to `related` array
- `test-conventions.md` should have `[[test-sprint]]` added to `related` array

### Step 5: Verify Sync Report

Check final sync report:

**Expected output:**
```
Synced 3 files to Obsidian:
  - test/test-analysis.md
  - test/test-conventions.md
  - test/test-sprint.md

3 files synced successfully to vault folder: test/
```

## Success Criteria

- [ ] All 3 files synced without errors
- [ ] Frontmatter generated correctly for each file
- [ ] Type inference correctly identified `analysis`, `conventions`, and `sprint-plan`
- [ ] Extended fields added to `test-sprint.md` (`sprint`, `progress`, `parent_doc`)
- [ ] Cross-references validated and fixed (bidirectionality enforced)
- [ ] Final report shows all files synced and validation results

## Cleanup

After the test:
```bash
# Remove test files from Obsidian vault (manual)
# Remove local test directory
rm -rf /tmp/obsidian-sync-test
```

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Type inference incorrect | Keywords not matched | Check obsidian-md-standard type taxonomy |
| Missing extended fields | Type not recognized as sprint-plan | Verify `sprint` keyword in filename or content |
| Cross-references not validated | Batch sync not detected (only 1 file?) | Ensure 2+ files synced in same batch |
| Sync fails | MCP tools not loaded | Verify Obsidian REST API is running |

## Expected Results Summary

| File | Type | Extended Fields | Related Count | Fixed By Validation |
|------|------|----------------|---------------|---------------------|
| test-analysis.md | analysis | None | 1 → 2 | +`[[test-sprint]]` |
| test-conventions.md | conventions | None | 1 → 2 | +`[[test-sprint]]` |
| test-sprint.md | sprint-plan | sprint, progress, parent_doc | 3 | None |

Total files synced: 3
Total validation fixes: 2
Total time: ~10 seconds (batch pattern optimizations applied)
