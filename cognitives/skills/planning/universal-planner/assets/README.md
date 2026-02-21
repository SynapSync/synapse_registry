# Universal Planner Assets

Supporting files for the universal-planner skill (v3.4.0).

## Directory Structure

```
assets/
├── modes/              # PLAN mode, EXECUTE mode, and 6 planning sub-modes
├── helpers/            # Config resolution, decision log, code quality, troubleshooting
├── templates/          # Document templates (ANALYSIS, PLANNING, CONVENTIONS, EXECUTION, SPRINT, RETRO)
├── validators/         # Output validation schema
└── examples/           # Test cases
```

## Modes

| File | Purpose |
|------|---------|
| `PLAN.md` | Planning mode — sub-mode detection, workflow, output structure, critical patterns |
| `EXECUTE.md` | Execution mode — role system, sprint workflow, edge cases, code quality |
| `NEW_PROJECT.md` | Full SDLC for greenfield projects |
| `NEW_FEATURE.md` | Codebase-aware feature planning |
| `REFACTOR.md` | Technical improvement planning |
| `BUG_FIX.md` | Bug investigation & fix planning |
| `TECH_DEBT.md` | Technical debt reduction planning |
| `ARCHITECTURE.md` | Architecture change planning |

## Helpers

| File | Purpose |
|------|---------|
| `output-resolve.md` | Lightweight `{output_dir}` resolver — common-case fast path |
| `config-resolver.md` | Full persistence rules, error handling, and block template for first-time setup |
| `decision-log.md` | Decision log format for EXECUTE mode |
| `code-quality-standards.md` | Production code standards for EXECUTE mode |
| `troubleshooting.md` | Common issues for both PLAN and EXECUTE modes |

## Templates

| File | Purpose |
|------|---------|
| `ANALYSIS.md` | Strategic analysis template |
| `PLANNING.md` | Planning document template |
| `CONVENTIONS.md` | Codebase conventions template |
| `EXECUTION.md` | Execution plan template |
| `SPRINT.md` | Sprint plan template |
| `RETRO.md` | Sprint retrospective template |
| `PROGRESS.md` | Progress dashboard template |

## Examples

| File | Purpose |
|------|---------|
| `test-case-1.md` | Assets pattern smoke test (v3.0.0) |
| `test-case-2.md` | NEW_FEATURE mode validation (v3.1.0) |
| `test-case-3.md` | REFACTOR mode validation (v3.1.0) |
| `test-case-4.md` | BUG_FIX mode validation with fast path (v3.1.0) |
| `test-case-5.md` | TECH_DEBT mode validation (v3.1.0) |
| `test-case-6.md` | NEW_PROJECT mode validation (18 files) (v3.1.0) |
| `test-case-7.md` | ARCHITECTURE mode validation (13 files) (v3.1.0) |
