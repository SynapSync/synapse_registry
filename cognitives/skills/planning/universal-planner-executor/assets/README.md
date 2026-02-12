# Universal Planner Executor Assets

Supporting files for `universal-planner-executor` following the assets pattern.

## Directory Structure

```
assets/
├── README.md                          # This file
├── templates/                         # Document templates
│   └── RETRO.md                       # Sprint retrospective template
└── helpers/                           # Reusable workflows
    ├── code-quality-standards.md      # Production code standards
    ├── decision-log.md                # Decision documentation format
    └── troubleshooting.md             # Common issues and resolutions
```

## Purpose of Each Directory

### templates/

**Purpose**: Document generation templates with placeholder syntax.

**Contents**:
- `RETRO.md` — Sprint retrospective template with frontmatter and sections (generated in Step 3.5 when user accepts retrospective offer)

**Usage**: Reference from SKILL.md workflow steps. Use `{{variable}}` placeholder syntax for dynamic substitution.

### helpers/

**Purpose**: Reusable workflows and standards that reduce duplication in SKILL.md.

**Contents**:
- `code-quality-standards.md` — Production-quality coding standards for the Senior Developer role (frontend, backend, testing, git practices)
- `decision-log.md` — Format for documenting decisions when the plan is ambiguous or conflicts with reality
- `troubleshooting.md` — Common execution issues and their resolutions

**Usage**: Referenced from SKILL.md sections. These helpers provide depth without cluttering the main workflow.

## Why Assets?

This skill was refactored to use the assets pattern to:

1. **Reduce SKILL.md size**: From 615 LOC to ~468 LOC (-24%)
2. **Improve maintainability**: Templates and standards can be updated independently
3. **Preserve readability**: SKILL.md remains a concise overview with links to depth
4. **Enable reusability**: Helpers are referenced multiple times without duplication

## Migration Impact

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| SKILL.md LOC | 615 | ~468 | -24% |
| Templates extracted | 0 | 1 | +1 |
| Helpers extracted | 0 | 3 | +3 |
| Total assets | 0 | 4 | +4 |

## Version

Assets introduced in version 2.1.0 (2026-02-12).
