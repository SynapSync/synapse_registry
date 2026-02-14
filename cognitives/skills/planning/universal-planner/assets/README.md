# Universal Planner Assets

Supporting files for the universal-planner skill (v3.1.0).

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
| `config-resolver.md` | `{output_base}` configuration resolution workflow |
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
