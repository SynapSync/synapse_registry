# Code-Analyzer Assets

Supporting templates and helpers for the code-analyzer skill.

## Structure

```
assets/
├── README.md                      # This file
├── templates/                     # Output document templates
│   ├── REPORT.md                  # Technical analysis report structure
│   └── REFACTOR.md                # Refactoring recommendations structure (v3 only)
└── helpers/                       # Analysis guidelines and references
    └── diagram-guidelines.md      # Mermaid diagram selection and best practices
```

## Usage

### Templates

Templates in `templates/` define the complete structure for code-analyzer output documents. They include:

- Frontmatter schemas with `{{placeholder}}` variables
- Section organization and content guidelines
- Example outputs for each section

**REPORT.md** — Main technical analysis report (v1/v2/v3)
- Executive Summary, Technical Analysis, Module Communication, Diagrams, Metrics, Referencias

**REFACTOR.md** — Refactoring recommendations (v3 only)
- Code Smells, Recommendations, Priority Matrix, Implementation Plan, Impact Analysis, Testing Strategy, Referencias

### Helpers

**diagram-guidelines.md** — Guidelines for selecting appropriate Mermaid diagrams based on module complexity and communication patterns. Includes examples for:
- Flowcharts (execution flow)
- Sequence diagrams (inter-module communication)
- Class diagrams (internal structure)
- C4 Context (system-level view)

## Integration

The main SKILL.md references these assets to keep the skill file concise:

```markdown
## Output Templates
See [assets/templates/](assets/templates/) for complete document structures.

## Diagram Guidelines
See [assets/helpers/diagram-guidelines.md](assets/helpers/diagram-guidelines.md) for Mermaid diagram selection.
```

## Template Variables

Templates use `{{variable}}` syntax for placeholders:
- `{{module-name}}` — Name of the analyzed module
- `{{project-name}}` — Name of the containing project
- `{{YYYY-MM-DD}}` — Date in ISO format

## Version History

- **2.0** (2026-02-12): Assets pattern migration — extracted templates and diagram guidelines from SKILL.md
