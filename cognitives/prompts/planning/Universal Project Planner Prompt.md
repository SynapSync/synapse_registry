# 🎯 Universal Project Planner Prompt

## Overview

This is a reusable prompt template designed to generate comprehensive project analysis, sprint planning, and actionable task lists for any software development scenario. It adapts to:

- **Refactoring** existing modules
- **Bug fixing** and issue resolution
- **New feature** development
- **New project** initialization
- **Architecture** improvements
- **Code cleanup** and technical debt reduction

---

## 📋 The Prompt Template

```markdown
# Project Analysis and Sprint Planning Request

## 1. Context Definition

**Project Type:** [REFACTOR | FIX_ISSUE | NEW_FEATURE | NEW_PROJECT | ARCHITECTURE | CLEANUP]

**Scope:**
- Module/Feature path: `[PATH_TO_MODULE_OR_FEATURE]`
- Related files/modules (if applicable): `[RELATED_PATHS]`

**Current State:**
[Describe what exists now, the problem, or what you're starting with]

**Desired Outcome:**
[Describe the end goal - what should the code/architecture look like when done]

---

## 2. Analysis Requirements

Analyze my code at `[PATH]` and provide:

### Architecture Analysis
- Current folder structure and organization
- Responsibility distribution (what goes where)
- Identify violations of best practices for [FRAMEWORK/LANGUAGE]
- Patterns currently in use vs recommended patterns

### Problems Identification
- Code duplication (percentage if possible)
- Architectural inconsistencies
- Technical debt items
- Missing abstractions or over-engineering
- Dependency issues (circular, incorrect layering)

### Recommendations
- How the architecture SHOULD be organized
- Clear responsibility definitions per folder/module
- Naming conventions and patterns to follow
- What to keep, what to remove, what to create

---

## 3. Deliverables

### Required Output Files

Create the following files in `[OUTPUT_DIRECTORY]`:

1. **analysis.md** - Complete analysis with:
   - Executive summary
   - Current vs desired state comparison
   - Folder/responsibility definitions
   - Problems found with severity
   - Recommended architecture diagram
   - Verification commands
   - Success metrics

2. **PROGRESS.md** - Master progress tracker with:
   - Executive summary
   - Sprint overview (status, duration, objectives)
   - Global metrics table
   - Blockers and issues section
   - Timeline/schedule
   - Links to detailed sprint files

3. **SPRINT-N-[NAME].md** (one per sprint) - Detailed sprint plans with:
   - Duration and objectives
   - Dependencies and prerequisites
   - Phases breakdown
   - Tasks with checkboxes (subtitled, numbered)
   - Verification commands per phase
   - Definition of "Done"
   - Risks and mitigations
   - Rollback strategy
   - Notes section for implementation

---

## 4. Sprint Structure Requirements

Each sprint MUST include:

### Header Section
```markdown
# [EMOJI] SPRINT N: [Sprint Name]

**Duration:** X-Y days
**Objective:** [Clear one-line objective]
**Status:** 🔴 NOT STARTED | 🟡 IN PROGRESS | 🟢 COMPLETED
**Dependencies:** [List any prerequisites]
```

### Phase Structure
```markdown
## 📋 Phase N.M: [Phase Name]

**Objective:** [What this phase achieves]

### Prerequisites
- [ ] [Required items before starting]

### Tasks

#### Task N.M.X: [Task Description]
**File(s):** `[paths]`

**Changes:**
```[language]
// BEFORE (remove)
[code snippet]

// AFTER (add)
[code snippet]
```

**Steps:**
- [ ] Task N.M.X.1 - [Specific action]
- [ ] Task N.M.X.2 - [Specific action]

**Verification:**
```bash
[command to verify task completion]
```
```

### Verification Section
```markdown
## 📋 Phase N.X: Final Verification

### Code Verifications
- [ ] **Verification N.X.1** - [Description]
  ```bash
  [verification command]
  # Expected result: [what should happen]
  ```

### Functional Verifications
- [ ] Build succeeds
- [ ] Tests pass
- [ ] Manual smoke test
```

### Definition of Done
```markdown
## 🎯 Definition of "Done"

Sprint N is completed when:
✅ [Criteria 1]
✅ [Criteria 2]
✅ [Criteria N]
```

### Risks Table
```markdown
## ⚠️ Risks

| Risk | Probability | Mitigation |
|------|-------------|------------|
| [Risk 1] | High/Medium/Low | [How to prevent/handle] |
```

---

## 5. Task Granularity Guidelines

**Level 1 - Sprint:** Major milestone (3-7 days)
**Level 2 - Phase:** Logical grouping (0.5-2 days)
**Level 3 - Task:** Discrete work item (1-4 hours)
**Level 4 - Subtask:** Single action (5-30 minutes)

Each task should:
- Have a clear, verifiable outcome
- Include file paths when applicable
- Show code snippets for changes (before/after)
- Include verification command
- Be small enough to complete in one sitting

---

## 6. Progress Tracking

### Metrics Table Example
```markdown
| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| [Metric 1] | [Goal] | [Current] | 🔴/🟡/🟢 |
```

### Status Indicators
- 🔴 Not started / Blocked / Failed
- 🟡 In progress / Partially complete
- 🟢 Completed / Passed
- ⏳ Waiting / Pending verification
- 📋 Planned

---

## 7. Customization Variables

Replace these placeholders in your request:

| Variable | Description | Example |
|----------|-------------|---------|
| `[PATH_TO_MODULE]` | Main code location | `/apps/myapp/src/modules/users` |
| `[OUTPUT_DIRECTORY]` | Where to save plans | `/.synapsync/planning/users-refactor` |
| `[FRAMEWORK]` | Tech stack | Angular, React, Flutter, Node.js |
| `[PROJECT_TYPE]` | Type of work | REFACTOR, FIX_ISSUE, NEW_FEATURE |
| `[TIMELINE]` | Available time | 2 weeks, 3 sprints |

---

## 8. Example Prompts by Scenario

### Scenario A: Module Refactoring
```
Analyze my code at `/apps/frontend/src/modules/orders` 

This analysis should tell me:
- How my architecture SHOULD be structured
- What I need to fix and reorganize
- Current distribution of responsibilities (components, containers, services, etc.)

Focus on:
- Folder organization and responsibilities
- Code duplication identification
- Architectural pattern compliance for Angular/Clean Architecture

Create a sprint-based work plan in `/.synapsync/planning/orders-refactor/` with:
- analysis.md (complete analysis)
- PROGRESS.md (master tracker)
- SPRINT-1-*.md through SPRINT-N-*.md (detailed task lists)

Each sprint should have phases, numbered tasks with checkboxes, verification commands,
and update progressively as work is completed.
```

### Scenario B: Bug Fix / Issue Resolution
```
I have an issue in `/apps/api/src/services/payment`:
[Describe the bug/issue]

Analyze the code and create a fix plan:
- Root cause analysis
- Impact assessment
- Step-by-step fix procedure
- Test cases to prevent regression

Output to `/.synapsync/planning/payment-fix/` with:
- analysis.md (root cause, impact, solution)
- PROGRESS.md (fix progress)
- SPRINT-1-INVESTIGATION.md (reproduce, identify)
- SPRINT-2-FIX.md (implement fix)
- SPRINT-3-VERIFICATION.md (test, deploy)
```

### Scenario C: New Feature Development
```
I need to create a new feature: [FEATURE_DESCRIPTION]

Location: `/apps/myapp/src/features/[feature-name]`

Requirements:
- [Requirement 1]
- [Requirement 2]

Create implementation plan in `/.synapsync/planning/[feature-name]/`:
- analysis.md (architecture design, dependencies, interfaces)
- PROGRESS.md (development tracker)
- SPRINT-1-SETUP.md (scaffolding, models, interfaces)
- SPRINT-2-CORE.md (business logic, services)
- SPRINT-3-UI.md (components, integration)
- SPRINT-4-TESTS.md (unit, e2e, polish)

Include code templates, folder structure, and naming conventions.
```

### Scenario D: New Project Setup
```
I'm starting a new project: [PROJECT_NAME]

Tech stack: [STACK]
Type: [web app, mobile app, API, library]

Create project initialization plan in `/.synapsync/planning/[project-name]-init/`:
- analysis.md (architecture decisions, folder structure, conventions)
- PROGRESS.md (setup progress)
- SPRINT-1-FOUNDATION.md (project creation, config, tooling)
- SPRINT-2-ARCHITECTURE.md (core structure, patterns, base classes)
- SPRINT-3-INFRASTRUCTURE.md (CI/CD, testing, deployment)

Include recommended folder structure, naming conventions, and boilerplate code.
```

---

## 9. Quality Checklist

Before accepting the generated plan, verify:

### Analysis Document
- [ ] Clear problem statement
- [ ] Current vs desired state comparison
- [ ] Specific file/folder references
- [ ] Actionable recommendations
- [ ] Verification commands
- [ ] Success metrics defined

### Sprint Documents
- [ ] Clear objectives per sprint
- [ ] Logical phase groupings
- [ ] All tasks have checkboxes
- [ ] Code snippets show before/after
- [ ] Verification commands per phase
- [ ] Definition of Done
- [ ] Risk mitigation strategies

### Progress Tracker
- [ ] Links to all sprint documents
- [ ] Metrics table with targets
- [ ] Timeline/schedule
- [ ] Blockers section
- [ ] Update instructions

---

## 10. Maintenance Instructions

### During Execution
1. Check off completed tasks in sprint files
2. Update PROGRESS.md metrics after each phase
3. Document blockers as they arise
4. Add implementation notes in designated sections

### After Each Sprint
1. Update sprint status (🔴 → 🟢)
2. Update PROGRESS.md sprint progress
3. Document actual duration vs planned
4. Record lessons learned

### On Completion
1. Final verification checklist
2. Update all metrics to final values
3. Archive or mark as complete
4. Create summary of improvements achieved
```

---

## Quick Start

Copy and customize this compact version:

```markdown
Analyze my code at `[YOUR_PATH]`

Provide:
1. Architecture analysis (current structure, problems, recommendations)
2. Responsibility definitions per folder
3. Action items prioritized by impact

Create sprint planning in `[OUTPUT_PATH]/`:
- analysis.md
- PROGRESS.md  
- SPRINT-N-[NAME].md files

Requirements:
- Sprints with phases and numbered tasks
- Checkboxes for all actionable items
- Before/after code snippets
- Verification commands
- Definition of Done per sprint
- Risk mitigations

Focus only on [SCOPE] for now, we'll scale later.
```