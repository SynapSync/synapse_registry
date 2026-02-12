# Decision Log Format

When making decisions not explicitly covered by the plan, document them in the sprint file's Notes section.

## When to Use

- The plan describes a state that doesn't match reality
- A task's description is ambiguous or underspecified
- A technical choice is needed between multiple valid options
- A deviation from the plan is required to achieve the objective

## Format

```markdown
### Decision Log

#### DEC-{{N}}: {{Short Title}}
- **Context**: {{What was ambiguous or conflicting}}
- **Options Considered**:
  1. {{Option A}}: {{Pros/cons}}
  2. {{Option B}}: {{Pros/cons}}
- **Decision**: {{What was chosen}}
- **Reasoning**: {{Why this aligns with the project's conventions and the plan's intent}}
- **Impact**: {{What this affects}}
- **Sprint**: [[SPRINT-{{N}}-name]]
- **Task**: [[SPRINT-{{N}}-name#T-{{task-id}}]]
```

## Example

```markdown
### Decision Log

#### DEC-1: Component Library Choice for New Feature
- **Context**: The plan references a `Button` component, but the project has two button implementations: `ui/Button` (legacy) and `components/Button` (new design system)
- **Options Considered**:
  1. Use `ui/Button`: Matches existing patterns, but deprecated
  2. Use `components/Button`: Aligns with design system migration, but inconsistent with some pages
- **Decision**: Use `components/Button`
- **Reasoning**: CONVENTIONS.md indicates the project is migrating to the new design system. Using the new component now avoids future refactoring.
- **Impact**: This feature will use the new design system. May create visual inconsistency with legacy pages until they're migrated.
- **Sprint**: [[SPRINT-2-checkout-flow]]
- **Task**: [[SPRINT-2-checkout-flow#T-2.1.3]]
```

## Cross-Linking

- **Sprint**: Always link to the sprint document using wiki-link syntax
- **Task**: Always link to the specific task section (use heading anchor)
- **Related docs**: If the decision affects CONVENTIONS.md or other planning docs, note it

## Numbering

- Use sequential IDs within each sprint: DEC-1, DEC-2, DEC-3, etc.
- IDs are scoped to the sprint — Sprint 1 has its own DEC-1, Sprint 2 has its own DEC-1
