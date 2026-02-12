# Universal Planner Assets

This directory contains supporting files for the universal-planner skill following the [assets pattern](../../../../docs/standards/skill-assets-pattern.md).

## Directory Structure

```
assets/
├── README.md           # This file
├── modes/              # Mode-specific rules and documentation
├── helpers/            # Reusable workflow helpers
├── templates/          # Document templates
├── validators/         # JSON schemas for output validation
└── examples/           # Example configs and test cases
```

## Purpose of Each Directory

### `modes/`
Contains detailed documentation for each of the 6 planning modes:
- `NEW_PROJECT.md` - Full SDLC planning for greenfield projects
- `NEW_FEATURE.md` - Codebase-aware feature planning
- `REFACTOR.md` - Technical improvement planning
- `BUG_FIX.md` - Bug investigation & fix planning
- `TECH_DEBT.md` - Technical debt reduction planning
- `ARCHITECTURE.md` - Architecture change planning

Each mode file includes:
- When to use this mode
- Output structure specific to the mode
- Frontmatter additions
- Workflow adjustments
- Examples

### `helpers/`
Reusable workflow components:
- `config-resolver.md` - Configuration resolution workflow for `{output_base}`

### `templates/`
Standard document templates:
- `ANALYSIS.md` - Strategic analysis template
- `PLANNING.md` - Planning document template
- `CONVENTIONS.md` - Conventions document template
- `EXECUTION.md` - Execution plan template
- `SPRINT.md` - Sprint plan template

Each template includes:
- Frontmatter structure
- Section layout
- Placeholders for variable substitution
- Inline examples

### `validators/`
JSON schemas for validating output:
- `output-schema.json` - Defines the contract for universal-planner output

Used by downstream skills (like universal-planner-executor) to validate that planning output is complete and correct.

### `examples/`
Example configurations and test cases:
- Test scenarios for smoke testing
- Example cognitive.config.json files
- Sample inputs and expected outputs

## Benefits of This Structure

1. **SKILL.md stays concise** - Overview and quick reference only
2. **Assets provide depth** - Detailed documentation available on-demand
3. **Easy to maintain** - Change templates without touching SKILL.md
4. **Self-contained** - All assets download with `npx skills add universal-planner`
5. **Versionable** - Each asset can evolve independently

## Usage

When reading SKILL.md, you'll see references like:
```markdown
See [assets/modes/NEW_PROJECT.md](modes/NEW_PROJECT.md) for details.
```

Click through to access the detailed documentation.

## Version

Assets structure created: 2026-02-12 (v2.1.0)
Pattern specification: [skill-assets-pattern.md](../../../../docs/standards/skill-assets-pattern.md)
