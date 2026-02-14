---
title: "{{project_name}} - Strategic Analysis"
date: "{{date}}"
updated: "{{date}}"
project: "{{project_name}}"
type: "analysis"
status: "active"
version: "1.0"
tags: ["{{project_name}}", "analysis", "planning"]
changelog:
  - version: "1.0"
    date: "{{date}}"
    changes: ["Initial strategic analysis"]
related:
  - "[[PLANNING]]"
  - "[[CONVENTIONS]]"
---

# Strategic Analysis: {{project_name}}

**Mode:** {{mode}}
**Date:** {{date}}
**Scope:** {{scope}}

---

## Executive Summary

[2-3 paragraph overview of what you're analyzing and why]

**Key Findings:**
- Finding 1
- Finding 2
- Finding 3

---

## Context

### Background
[What led to this analysis? What problem are we solving?]

### Objectives
1. **Primary Goal:** [Main objective]
2. **Secondary Goals:** [Supporting objectives]

### Scope
**In Scope:**
- Item 1
- Item 2

**Out of Scope:**
- Item 1
- Item 2

---

## Current State Analysis

[This section adapts based on mode - see mode-specific guidance below]

### {{mode}}-Specific Analysis

{{mode_specific_analysis_content}}

---

## Findings

### Key Insights

#### Insight 1: [Title]
**Finding:** [What you discovered]

**Impact:** [Why it matters]

**Recommendation:** [What should be done]

#### Insight 2: [Title]
**Finding:** [What you discovered]

**Impact:** [Why it matters]

**Recommendation:** [What should be done]

### Risks & Concerns

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| {{risk_1}} | {{probability}} | {{impact}} | {{mitigation}} |
| {{risk_2}} | {{probability}} | {{impact}} | {{mitigation}} |

### Opportunities

- **Opportunity 1:** [Description]
- **Opportunity 2:** [Description]

---

## Technical Assessment

### Architecture Implications
[How this impacts system architecture]

### Technology Considerations
[Tech stack, libraries, frameworks, tools]

### Dependencies
**External Dependencies:**
- Dependency 1
- Dependency 2

**Internal Dependencies:**
- Module/component 1
- Module/component 2

---

## Resource Requirements

### Team
- **Developers:** {{dev_count}}
- **Designers:** {{designer_count}}
- **Other:** {{other_roles}}

### Timeline
- **MVP:** {{mvp_timeline}}
- **V1.0:** {{v1_timeline}}
- **Full Launch:** {{launch_timeline}}

### Budget (if applicable)
- **Development:** {{dev_budget}}
- **Infrastructure:** {{infra_budget}}
- **Third-party services:** {{service_budget}}

---

## Success Criteria

### Definition of Done
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Key Performance Indicators

| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| {{metric_1}} | {{baseline}} | {{target}} | {{timeline}} |
| {{metric_2}} | {{baseline}} | {{target}} | {{timeline}} |

---

## Assumptions

1. **{{assumption_category_1}}**
   - Assumption 1
   - Assumption 2

2. **{{assumption_category_2}}**
   - Assumption 1
   - Assumption 2

---

## Next Steps

1. **{{step_1}}** - [Description and timeline]
2. **{{step_2}}** - [Description and timeline]
3. **{{step_3}}** - [Description and timeline]

---

## References

**Parent Documents:**
- [[README]]

**Sibling Documents:**
- [[CONVENTIONS]]

**Child Documents:**
- [[PLANNING]]

**Input Documents:**
- User requirements
- Technical specifications (if any)

---

## Mode-Specific Guidance

### NEW_PROJECT Mode
Focus on: Product feasibility, technology selection, resource assessment, market analysis

### NEW_FEATURE Mode
Focus on: Feature architecture, integration points, data flow, dependencies on existing code

### REFACTOR Mode
Focus on: Current vs target architecture, code duplication, architectural inconsistencies, dependency issues

### BUG_FIX Mode
Focus on: Root cause analysis, impact assessment, solution design, test cases

### TECH_DEBT Mode
Focus on: Debt inventory, impact vs effort matrix, prioritization, modernization path

### ARCHITECTURE Mode
Focus on: Current vs target gap, migration path, risk assessment, data migration
