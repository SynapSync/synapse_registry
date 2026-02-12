---
title: "Sprint {{sprint_number}}: {{sprint_name}}"
date: "{{start_date}}"
updated: "{{start_date}}"
project: "{{project_name}}"
type: "sprint-plan"
status: "draft"
version: "1.0"
sprint: {{sprint_number}}
phase: "{{active_phases}}"
progress: 0
previous_doc: "[[SPRINT-{{prev_sprint}}]]"
next_doc: "[[SPRINT-{{next_sprint}}]]"
parent_doc: "[[PROGRESS]]"
tags: ["{{project_name}}", "sprint-{{sprint_number}}", "sprint-plan"]
changelog:
  - version: "1.0"
    date: "{{start_date}}"
    changes: ["Initial sprint plan"]
related:
  - "[[PROGRESS]]"
  - "[[EXECUTION]]"
  - "[[SPRINT-{{prev_sprint}}]]"
  - "[[SPRINT-{{next_sprint}}]]"
---

# Sprint {{sprint_number}}: {{sprint_name}}

**Duration:** {{start_date}} → {{end_date}} ({{duration}} days)
**Phase:** {{phase}}
**Focus:** {{sprint_focus}}

---

## Sprint Goal

{{sprint_goal_description}}

**Success Criteria:**
- [ ] {{success_criterion_1}}
- [ ] {{success_criterion_2}}
- [ ] {{success_criterion_3}}

---

## Carried Forward from [[SPRINT-{{prev_sprint}}]]

{{#if has_carried_items}}
The following items were not completed in Sprint {{prev_sprint}} and are carried forward:

| ID | Task | Reason | Status |
|----|------|--------|--------|
| {{task_id_1}} | {{task_name_1}} | {{reason_1}} | {{status_1}} |
| {{task_id_2}} | {{task_name_2}} | {{reason_2}} | {{status_2}} |

**Adjusted Priority:** These tasks take priority in this sprint.
{{/if}}

{{#unless has_carried_items}}
No items carried forward from previous sprint.
{{/unless}}

---

## Sprint Backlog

### Phase {{phase_number}}: {{phase_name}}

#### Task {{task_id_1}}: {{task_name_1}}

**Priority:** {{priority}} (P0/P1/P2)

**Description:**
{{task_description_1}}

**Acceptance Criteria:**
- [ ] {{criterion_1}}
- [ ] {{criterion_2}}
- [ ] {{criterion_3}}

**Implementation Steps:**
1. [ ] {{step_1}}
2. [ ] {{step_2}}
3. [ ] {{step_3}}

**Dependencies:**
- Depends on: {{depends_on}}
- Blocks: {{blocks}}

**Verification:**
```bash
{{verification_command}}
```

**Rollback:**
```bash
{{rollback_command}}
```

**Estimated Effort:** {{effort}}
**Assigned To:** {{assignee}}
**Status:** 🔄 Not Started

---

#### Task {{task_id_2}}: {{task_name_2}}

[Repeat structure for each task...]

---

## Daily Progress

### Day 1 - {{day_1_date}}
**Completed:**
- {{completed_item_1}}

**In Progress:**
- {{in_progress_item_1}}

**Blockers:**
- {{blocker_1}}

---

### Day 2 - {{day_2_date}}
**Completed:**
- {{completed_item_1}}

**In Progress:**
- {{in_progress_item_1}}

**Blockers:**
- {{blocker_1}}

---

[Continue for each day of the sprint...]

---

## Metrics

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Tasks Completed | {{target_tasks}} | {{current_tasks}} | {{status}} |
| Story Points | {{target_points}} | {{current_points}} | {{status}} |
| Test Coverage | {{target_coverage}}% | {{current_coverage}}% | {{status}} |
| Bugs Introduced | 0 | {{bug_count}} | {{status}} |
| Code Review Time | <24h | {{review_time}} | {{status}} |

---

## Risks & Issues

### Active Risks

| Risk | Impact | Probability | Mitigation | Owner | Status |
|------|--------|-------------|------------|-------|--------|
| {{risk_1}} | {{impact_1}} | {{prob_1}} | {{mitigation_1}} | {{owner_1}} | {{status_1}} |
| {{risk_2}} | {{impact_2}} | {{prob_2}} | {{mitigation_2}} | {{owner_2}} | {{status_2}} |

### Issues

| Issue | Severity | Description | Resolution | Status |
|-------|----------|-------------|------------|--------|
| {{issue_1}} | {{severity_1}} | {{description_1}} | {{resolution_1}} | {{status_1}} |
| {{issue_2}} | {{severity_2}} | {{description_2}} | {{resolution_2}} | {{status_2}} |

---

## Decisions Made

### Decision 1: {{decision_title_1}}
**Date:** {{decision_date_1}}

**Context:** {{decision_context_1}}

**Decision:** {{decision_made_1}}

**Rationale:** {{decision_rationale_1}}

**Impact:** {{decision_impact_1}}

---

### Decision 2: {{decision_title_2}}
[Repeat for each decision...]

---

## Code Changes

### New Files
- `{{new_file_1}}` - {{purpose_1}}
- `{{new_file_2}}` - {{purpose_2}}

### Modified Files
- `{{modified_file_1}}` - {{change_description_1}}
- `{{modified_file_2}}` - {{change_description_2}}

### Deleted Files
- `{{deleted_file_1}}` - {{deletion_reason_1}}

### Pull Requests
- [#{{pr_number_1}}]({{pr_url_1}}) - {{pr_title_1}} ({{pr_status_1}})
- [#{{pr_number_2}}]({{pr_url_2}}) - {{pr_title_2}} ({{pr_status_2}})

---

## Testing

### Tests Added
- **Unit Tests:** {{unit_test_count}} ({{files}})
- **Integration Tests:** {{integration_test_count}} ({{files}})
- **E2E Tests:** {{e2e_test_count}} ({{files}})

### Test Results

| Test Suite | Passed | Failed | Skipped | Coverage |
|------------|--------|--------|---------|----------|
| Unit | {{unit_passed}} | {{unit_failed}} | {{unit_skipped}} | {{unit_coverage}}% |
| Integration | {{int_passed}} | {{int_failed}} | {{int_skipped}} | {{int_coverage}}% |
| E2E | {{e2e_passed}} | {{e2e_failed}} | {{e2e_skipped}} | {{e2e_coverage}}% |

---

## Deployment

### Environments

| Environment | Deployed | Version | Status | URL |
|-------------|----------|---------|--------|-----|
| Development | {{dev_deploy_date}} | {{dev_version}} | ✅ Stable | {{dev_url}} |
| Staging | {{staging_deploy_date}} | {{staging_version}} | ✅ Stable | {{staging_url}} |
| Production | {{prod_deploy_date}} | {{prod_version}} | 🔄 Pending | {{prod_url}} |

### Deployment Notes
{{deployment_notes}}

---

## Graduation Gate

**To complete this sprint, all criteria must be met:**

### Code Quality
- [ ] All tasks completed and verified
- [ ] All PRs merged to main
- [ ] Lint passes (0 errors, 0 warnings)
- [ ] Code coverage >= {{coverage_target}}%
- [ ] No high/critical security vulnerabilities

### Testing
- [ ] All unit tests passing ({{unit_test_target}} tests)
- [ ] All integration tests passing ({{integration_test_target}} tests)
- [ ] All e2e tests passing ({{e2e_test_target}} tests)
- [ ] Manual QA completed

### Documentation
- [ ] Code documented (JSDoc/docstrings)
- [ ] README updated (if needed)
- [ ] API docs updated (if API changed)
- [ ] Changelog updated

### Deployment
- [ ] Deployed to staging
- [ ] Smoke tests passed on staging
- [ ] Ready for production deployment

### Team
- [ ] Sprint retrospective completed
- [ ] Next sprint planned
- [ ] Learnings documented

**Gate Status:** {{gate_status}} (Open/Passed/Failed)

---

## Sprint Retrospective

### What Went Well ✅
1. {{went_well_1}}
2. {{went_well_2}}
3. {{went_well_3}}

### What Could Be Improved ⚠️
1. {{improve_1}}
2. {{improve_2}}
3. {{improve_3}}

### Action Items for Next Sprint 🎯
1. [ ] {{action_item_1}}
2. [ ] {{action_item_2}}
3. [ ] {{action_item_3}}

### Learnings 🎓
1. **{{learning_1_title}}:** {{learning_1_description}}
2. **{{learning_2_title}}:** {{learning_2_description}}

---

## Next Sprint Preview

**Sprint {{next_sprint}} Focus:** {{next_sprint_focus}}

**Planned Tasks:**
1. {{next_task_1}}
2. {{next_task_2}}
3. {{next_task_3}}

**Dependencies to Resolve:**
- {{next_dependency_1}}
- {{next_dependency_2}}

---

## Referencias

**Parent Document:**
- [[PROGRESS]]

**Previous Sprint:**
- [[SPRINT-{{prev_sprint}}]]

**Next Sprint:**
- [[SPRINT-{{next_sprint}}]]

**Related:**
- [[EXECUTION]]
- [[PLANNING]]
