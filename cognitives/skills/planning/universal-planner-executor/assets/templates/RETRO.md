# Sprint Retrospective Template

Use this template when generating retrospective documents after sprint completion.

## File Naming

`sprints/RETRO-{{N}}-{{name}}.md`

Where:
- `{{N}}` = Sprint number (e.g., 1, 2, 3)
- `{{name}}` = Sprint name in kebab-case (e.g., database-setup, api-integration)

## Template

```markdown
---
title: "Retrospective: Sprint {{N}} — {{Sprint Name}}"
date: "{{YYYY-MM-DD}}"
updated: "{{YYYY-MM-DD}}"
project: "{{project-name}}"
type: "retrospective"
status: "active"
version: "1.0"
sprint: {{N}}
previous_doc: "[[SPRINT-{{N}}-name]]"
tags: ["{{project-name}}", "retrospective", "sprint-{{N}}"]
changelog:
  - version: "1.0"
    date: "{{YYYY-MM-DD}}"
    changes: ["Initial retrospective"]
related:
  - "[[SPRINT-{{N}}-name]]"
  - "[[SPRINT-{{N+1}}-name]]"
  - "[[PROGRESS]]"
---

# Retrospective: Sprint {{N}} — {{Sprint Name}}

## Context
{{Brief description of sprint objective and outcome}}

## Keep (What Went Well)
- **K1**: {{What to continue doing}}
- **K2**: {{What to continue doing}}

## Problems (What Went Wrong)
- **P1**: {{Issue encountered}}
- **P2**: {{Issue encountered}}

## Learnings (What We Learned)
- **L1**: {{Insight gained}}
- **L2**: {{Insight gained}}

## Actions (What to Do Differently)
- **A1**: {{Concrete action for next sprint}} → Assigned to: {{who}}
- **A2**: {{Concrete action for next sprint}} → Assigned to: {{who}}

## Metrics

| Metric | Planned | Actual | Delta | Status |
|--------|---------|--------|-------|--------|
| Tasks completed | {{planned}} | {{actual}} | {{delta}} | {{status}} |
| {{Custom metric}} | {{target}} | {{actual}} | {{delta}} | {{status}} |

## Signals to Watch
- {{Early warning indicator for next sprint}}

## Verdict
{{Was the sprint successful? Key takeaway.}}

## Referencias

**Parent:** [[PROGRESS]]
**Input Documents:** [[SPRINT-{{N}}-name]]
**Siblings:** [[RETRO-{{N-1}}-name]], [[RETRO-{{N+1}}-name]]
```

## Usage Notes

1. **When to generate**: After completing a sprint (Step 3.5), if the user accepts the retrospective offer
2. **Frontmatter updates**: After creation, update PROGRESS.md to add `retro_refs: ["[[RETRO-{{N}}-name]]"]`
3. **Cross-linking**: Update the completed sprint's `related` field to include the retrospective
4. **Carried-forward items**: Include any sprint items marked "carry forward" in the `## Actions` section
5. **Metrics**: Pull actual metrics from the completed sprint file's final state
