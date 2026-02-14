---
title: "{{project_name}} - Work Plan"
date: "{{date}}"
updated: "{{date}}"
project: "{{project_name}}"
type: "plan"
status: "active"
version: "1.0"
tags: ["{{project_name}}", "planning", "strategy"]
changelog:
  - version: "1.0"
    date: "{{date}}"
    changes: ["Initial work plan"]
related:
  - "[[ANALYSIS]]"
  - "[[EXECUTION]]"
  - "[[PROGRESS]]"
---

# Work Plan: {{project_name}}

**Mode:** {{mode}}
**Date:** {{date}}
**Duration:** {{estimated_duration}}

---

## Vision & Objectives

### What We're Building
[Clear description of what this work will accomplish]

### Why It Matters
[Business value, user impact, technical benefit]

### Success Looks Like
[Concrete description of the end state]

---

## Strategy

### Approach
[High-level approach to accomplishing the work]

**Core Principles:**
1. **{{principle_1}}** - [Why this matters]
2. **{{principle_2}}** - [Why this matters]
3. **{{principle_3}}** - [Why this matters]

### Phases

#### Phase 1: {{phase_1_name}}
**Goal:** [What this phase accomplishes]

**Duration:** {{phase_1_duration}}

**Deliverables:**
- Deliverable 1
- Deliverable 2

#### Phase 2: {{phase_2_name}}
**Goal:** [What this phase accomplishes]

**Duration:** {{phase_2_duration}}

**Deliverables:**
- Deliverable 1
- Deliverable 2

#### Phase 3: {{phase_3_name}}
**Goal:** [What this phase accomplishes]

**Duration:** {{phase_3_duration}}

**Deliverables:**
- Deliverable 1
- Deliverable 2

---

## Technical Strategy

### Architecture Approach
[High-level technical approach]

**Key Decisions:**
- **Decision 1:** [What + Why]
- **Decision 2:** [What + Why]
- **Decision 3:** [What + Why]

### Technology Stack
| Layer | Technology | Rationale |
|-------|-----------|-----------|
| {{layer_1}} | {{tech_1}} | {{rationale_1}} |
| {{layer_2}} | {{tech_2}} | {{rationale_2}} |

### Integration Points
- **{{integration_1}}:** [How it integrates]
- **{{integration_2}}:** [How it integrates]

---

## Execution Strategy

### Development Workflow
1. **{{workflow_step_1}}** - [Description]
2. **{{workflow_step_2}}** - [Description]
3. **{{workflow_step_3}}** - [Description]

### Testing Strategy
- **Unit Testing:** {{unit_test_approach}}
- **Integration Testing:** {{integration_test_approach}}
- **E2E Testing:** {{e2e_test_approach}}

### Deployment Strategy
- **Environment Flow:** {{env_flow}}
- **Rollout Plan:** {{rollout_plan}}
- **Rollback Plan:** {{rollback_plan}}

---

## Risk Management

### Identified Risks

| Risk | Impact | Probability | Mitigation | Owner |
|------|--------|-------------|------------|-------|
| {{risk_1}} | {{impact_1}} | {{prob_1}} | {{mitigation_1}} | {{owner_1}} |
| {{risk_2}} | {{impact_2}} | {{prob_2}} | {{mitigation_2}} | {{owner_2}} |

### Contingency Plans
- **If {{scenario_1}}:** [Contingency plan]
- **If {{scenario_2}}:** [Contingency plan]

---

## Dependencies & Blockers

### External Dependencies
- **{{dependency_1}}:** [What we need + When]
- **{{dependency_2}}:** [What we need + When]

### Internal Dependencies
- **{{internal_dep_1}}:** [Team/module + What we need]
- **{{internal_dep_2}}:** [Team/module + What we need]

### Blockers (if any)
- [ ] **{{blocker_1}}:** [Description + Resolution plan]
- [ ] **{{blocker_2}}:** [Description + Resolution plan]

---

## Timeline

### Milestones

| Milestone | Target Date | Deliverables | Status |
|-----------|-------------|--------------|--------|
| {{milestone_1}} | {{date_1}} | {{deliverables_1}} | 🔄 Planned |
| {{milestone_2}} | {{date_2}} | {{deliverables_2}} | 🔄 Planned |
| {{milestone_3}} | {{date_3}} | {{deliverables_3}} | 🔄 Planned |

### Critical Path
1. **{{critical_item_1}}** ({{duration_1}}) → Blocks: {{blocked_items_1}}
2. **{{critical_item_2}}** ({{duration_2}}) → Blocks: {{blocked_items_2}}
3. **{{critical_item_3}}** ({{duration_3}}) → Blocks: {{blocked_items_3}}

---

## Resource Allocation

### Team Composition
| Role | Allocation | Responsibilities |
|------|------------|------------------|
| {{role_1}} | {{allocation_1}} | {{responsibilities_1}} |
| {{role_2}} | {{allocation_2}} | {{responsibilities_2}} |

### Budget (if applicable)
| Category | Estimated Cost | Notes |
|----------|---------------|-------|
| {{category_1}} | {{cost_1}} | {{notes_1}} |
| {{category_2}} | {{cost_2}} | {{notes_2}} |

---

## Quality Gates

### Pre-Development
- [ ] Requirements validated
- [ ] Design approved
- [ ] Dependencies confirmed

### During Development
- [ ] Code reviews completed
- [ ] Tests passing (>{{test_coverage_target}}% coverage)
- [ ] Performance benchmarks met

### Pre-Launch
- [ ] Security audit passed
- [ ] Documentation complete
- [ ] Stakeholder sign-off

---

## Communication Plan

### Stakeholder Updates
- **Frequency:** {{update_frequency}}
- **Format:** {{update_format}}
- **Key Metrics:** {{key_metrics}}

### Team Sync
- **Daily:** {{daily_sync}}
- **Weekly:** {{weekly_sync}}
- **Retrospectives:** {{retro_cadence}}

---

## Success Metrics

### Quantitative
| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| {{metric_1}} | {{current_1}} | {{target_1}} | {{how_measured_1}} |
| {{metric_2}} | {{current_2}} | {{target_2}} | {{how_measured_2}} |

### Qualitative
- **{{qual_metric_1}}:** [How we'll assess]
- **{{qual_metric_2}}:** [How we'll assess]

---

## Next Steps

**Immediate (This Week):**
1. {{immediate_step_1}}
2. {{immediate_step_2}}

**Short-term (This Month):**
1. {{short_term_step_1}}
2. {{short_term_step_2}}

**Long-term (This Quarter):**
1. {{long_term_step_1}}
2. {{long_term_step_2}}

---

## Section Applicability

*Omit sections marked "No" entirely for the given sub-mode. Sections marked "Optional" may be included if relevant.*

| Section | NEW_PROJECT | NEW_FEATURE | REFACTOR | BUG_FIX | TECH_DEBT | ARCHITECTURE |
|---------|:-----------:|:-----------:|:--------:|:-------:|:---------:|:------------:|
| Budget | Yes | Optional | No | No | No | Yes |
| Communication Plan | Yes | No | No | No | No | Optional |
| Team Composition | Yes | Optional | No | No | No | Yes |
| Deployment Strategy | Yes | Optional | Optional | Optional | No | Yes |
| Timeline Milestones | Yes | Yes | Yes | Optional | Yes | Yes |

---

## References

**Parent Documents:**
- [[README]]
- [[ANALYSIS]]

**Sibling Documents:**
- [[CONVENTIONS]]

**Child Documents:**
- [[EXECUTION]]
- [[PROGRESS]]

**Referenced Documents:**
- Requirements documents (if applicable)
- Design documents (if applicable)
