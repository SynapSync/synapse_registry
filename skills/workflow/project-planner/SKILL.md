---
name: project-planner
description: >
  Comprehensive project planning framework with structured analysis, planning, and execution phases.
  Trigger: When planning a new feature, project scope, or complex task that requires analysis, planning, and execution phases.
license: Apache-2.0
metadata:
  author: synapsync
  version: "1.0"
  scope: [root]
  auto_invoke: "Planning a new project or feature"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

## Purpose

Create a structured project planning framework that separates analysis, planning, and execution into distinct phases with clear roles, deliverables, and tracking mechanisms.

## When to Use This Skill

- **New feature development**: Building new functionality with undefined scope
- **Complex refactoring**: Large architectural changes requiring careful planning
- **Integration projects**: Multi-component projects requiring coordination
- **Sprint planning**: Breaking down quarterly goals into actionable tasks
- **Technical investigations**: Research-heavy features needing analysis before implementation
- **Cross-team initiatives**: Projects requiring stakeholder alignment and phase tracking

## Capabilities

### Planning Framework
- **Three-phase structure**: Analysis → Planning → Execution
- **Hierarchical goals**: Features → Phases → Objectives
- **Dependency tracking**: Task relationships and blocking
- **Progress monitoring**: Sprint-based execution with status tracking

### Analysis Phase
- Requirements documentation
- Resource assessment
- Technical feasibility evaluation
- Constraint identification

### Planning Phase
- Step-by-step implementation strategy
- Phase decomposition with objectives
- Resource allocation
- Timeline and dependency mapping

### Execution Phase
- Concrete task definitions
- Phase-based implementation
- Sprint/todo organization
- Progress tracking and monitoring

### Monitoring & Tracking
- Sprint-based todo lists
- Phase completion checklist
- Dependency resolution status
- Overall project progress dashboard

## Output Location

All project plans must be created in the central planning directory:

```
.synapsync/planning/
└── {project-name}/
    ├── analysis/
    ├── planning/
    ├── execution-plan/
    └── todos/
```

**Key Rule**: All workflow outputs go to `.synapsync/planning/**`

## Workflow

### Step 1: Analysis Phase
Investigate and document what you need to build.

**Deliverable**: `.synapsync/planning/{project-name}/analysis/ANALYSIS.md`

**Sections**:
1. **Requirement Summary**: What are we building?
2. **Current State Assessment**: What exists today?
3. **Technical Analysis**: What technologies/tools do we need?
4. **Resource Analysis**: What resources are available?
5. **Constraints & Risks**: What limitations exist?
6. **Success Criteria**: How will we know it's done?

**Role**: Information gathering and feasibility assessment. Ask "what do we have?" and "what do we need?"

### Step 2: Planning Phase
Define how you'll build it based on analysis findings.

**Deliverable**: `.synapsync/planning/{project-name}/planning/PLANNING.md`

**Sections**:
1. **Implementation Strategy**: High-level approach
2. **Execution Phases**: Major milestones/phases
   - Each phase has a name, description, and concrete objectives
   - Phases should be sequential or have clear dependencies
3. **Phase Details**: For each phase:
   - **Phase Name & Description**
   - **Objectives**: Specific, measurable goals
   - **Deliverables**: What gets completed
   - **Dependencies**: Prerequisites from other phases
4. **Resource Plan**: Who/what is needed
5. **Timeline**: Estimated phase duration
6. **Risk Mitigation**: Handling identified risks

**Role**: Strategic planning. Ask "how will we do this?" and "what are the phases?"

### Step 3: Execution Phase
Execute the plan and track progress.

**Deliverable**: `.synapsync/planning/{project-name}/execution-plan/EXECUTION.md`

**Sections**:
1. **Execution Overview**: Summary of phases and timeline
2. **Phase Breakdown**: For each execution phase:
   - **Phase X: [Name]**
   - **Objectives**: What this phase accomplishes
   - **Tasks**: Specific, actionable items
   - **Expected Duration**: How long this phase takes
3. **Success Criteria per Phase**: Completion metrics
4. **Resource Allocation**: Who does what
5. **Risk Monitoring**: Ongoing risk assessment

**Role**: Hands-on implementation. Ask "what specific tasks must we do?"

### Step 4: Execution Tracking (Todos/Sprints)
Monitor daily/weekly progress with sprint-based todos.

**Deliverable**: `.synapsync/planning/{project-name}/todos/SPRINT-{N}.md`

**Sections per Sprint**:
1. **Sprint Overview**: Timeline and goals
2. **Phase Status**: Which execution phase(s) are active
3. **Todo Checklist**: Specific tasks with:
   - [ ] Task description
   - **Owner**: Who's responsible
   - **Phase**: Which execution phase
   - **Status**: Pending/In Progress/Blocked/Done
   - **Dependencies**: Any blockers

4. **Blockers & Risk Updates**: Current issues
5. **Completion Tracking**: Percentage complete per phase

**Role**: Daily progress monitoring. Ask "are we on track?"

## Directory Structure

All projects must follow this structure inside `.synapsync/planning/`:

```
.synapsync/planning/
├── {project-name}/              # Project identifier (kebab-case)
│   ├── analysis/
│   │   ├── ANALYSIS.md          # Main analysis document
│   │   └── [optional-details]/  # Detailed analysis by component
│   ├── planning/
│   │   ├── PLANNING.md          # Main planning document
│   │   └── [optional-details]/  # Detailed planning per phase
│   ├── execution-plan/
│   │   ├── EXECUTION.md         # Main execution document
│   │   └── [optional-guides]/   # Step-by-step guides per phase
│   └── todos/
│       ├── SPRINT-1.md          # Week 1 or sprint 1
│       ├── SPRINT-2.md          # Week 2 or sprint 2
│       └── PROJECT-STATUS.md    # Overall progress dashboard
└── [other-projects]/
```

### Naming Convention for Projects

Use kebab-case for project folder names:

```
Good naming:
- create-new-register
- implement-dark-mode
- refactor-auth-system
- add-payment-gateway

Bad naming:
- Create New Register
- createNewRegister
- project1
- feature_xyz
```

## Template Examples

### Analysis Template

```markdown
# Analysis: [Project/Feature Name]

## Requirement Summary
What are we building? Why?

## Current State Assessment
- Existing systems involved
- Current user workflows
- Technical debt considerations

## Technical Analysis
- Required technologies
- Architecture implications
- New dependencies needed

## Resource Analysis
- Team members available
- External resources needed
- Skills required

## Constraints & Risks
- Technical limitations
- Time/budget constraints
- Known risks

## Success Criteria
- How we measure success
- Acceptance criteria
- Definition of "done"
```

### Planning Template

```markdown
# Planning: [Project/Feature Name]

## Implementation Strategy
High-level approach and philosophy.

## Execution Phases

### Phase 1: [Name]
**Description**: What this phase accomplishes

**Objectives**:
- Objective 1
- Objective 2
- Objective 3

**Deliverables**:
- Deliverable 1
- Deliverable 2

**Dependencies**: Phase 0 (if any)

### Phase 2: [Name]
[Same structure as Phase 1]

## Resource Plan
- Team lead: [Name]
- Frontend: [Names]
- Backend: [Names]
- DevOps: [Names]

## Timeline
- Phase 1: X days
- Phase 2: Y days
- Phase 3: Z days
- **Total**: X+Y+Z days

## Risk Mitigation
- Risk 1 -> Mitigation strategy
- Risk 2 -> Mitigation strategy
```

### Execution Template

```markdown
# Execution Plan: [Project/Feature Name]

## Execution Overview
Timeline: [Start] to [End]

Active Phases: Phase 1, Phase 2

## Phase 1: [Name]

**Objectives**:
- Objective 1
- Objective 2

**Tasks**:
1. Task 1 - Expected: 1 day
2. Task 2 - Expected: 2 days
3. Task 3 - Expected: 1 day

**Success Criteria**:
- [ ] All tasks completed
- [ ] Code reviewed
- [ ] Tests passing

## Phase 2: [Name]
[Same structure]

## Resource Allocation
| Task | Owner | Start | End | Status |
|------|-------|-------|-----|--------|
| Task 1 | Alice | Day 1 | Day 1 | Done |
| Task 2 | Bob | Day 2 | Day 3 | In Progress |

## Risk Monitoring
- Risk 1: [Current status]
- Risk 2: [Current status]
```

### Sprint Todo Template

```markdown
# Sprint 1: [Date Range]

## Overview
- **Phase**: Execution Phase 1 & 2
- **Goal**: Complete first milestone
- **Duration**: 1 week

## Phase Status
| Phase | Tasks | Done | Status |
|-------|-------|------|--------|
| Phase 1 | 5 | 3 | In Progress (60%) |
| Phase 2 | 4 | 0 | Not Started |

## Todos

### Phase 1 Tasks
- [x] Task 1.1 - Owner: Alice
- [x] Task 1.2 - Owner: Bob
- [ ] Task 1.3 - Owner: Alice (Blocked by Task 2.1)
- [x] Task 1.4 - Owner: Charlie
- [ ] Task 1.5 - Owner: Bob

### Phase 2 Tasks
- [ ] Task 2.1 - Owner: Alice (Prerequisite for 1.3)
- [ ] Task 2.2 - Owner: Bob
- [ ] Task 2.3 - Owner: Charlie
- [ ] Task 2.4 - Owner: Alice

## Blockers & Issues
| Issue | Impact | Resolution |
|-------|--------|-----------|
| Waiting on API docs | Blocks Phase 2 | ETA: Wed |
| Database schema change | Blocks Phase 1.3 | In review |

## Completion Tracking
- **Overall**: 30% complete (7/24 tasks)
- **Phase 1**: 60% (3/5 tasks)
- **Phase 2**: 0% (0/4 tasks)

## Next Steps
1. Complete API documentation
2. Review and merge database schema changes
3. Start Phase 2 tasks next week
```

## Command Examples

### Creating a New Project Plan

```bash
# Create project structure in .synapsync/planning/
mkdir -p .synapsync/planning/create-new-register/{analysis,planning,execution-plan,todos}

# Create initial documents
touch .synapsync/planning/create-new-register/analysis/ANALYSIS.md
touch .synapsync/planning/create-new-register/planning/PLANNING.md
touch .synapsync/planning/create-new-register/execution-plan/EXECUTION.md
touch .synapsync/planning/create-new-register/todos/SPRINT-1.md
```

### Using the Framework

**Day 1**: Fill in Analysis
- Research requirements
- Document current state
- Identify constraints

**Day 2**: Create Planning document
- Define phases
- Set objectives per phase
- Create timeline

**Day 3+**: Execute and track
- Update EXECUTION.md with real tasks
- Create SPRINT-1.md for tracking
- Update daily in sprint file

## Best Practices

### Analysis Phase (Before/During)

1. **Before starting**:
   - Gather all requirements documentation
   - Interview stakeholders
   - Review related systems

2. **During analysis**:
   - Document assumptions clearly
   - Identify technical unknowns
   - List all constraints upfront

3. **After analysis**:
   - Circulate for feedback
   - Validate assumptions with team
   - Get stakeholder sign-off

### Planning Phase (Before/During)

1. **Before planning**:
   - Finalize analysis document
   - Get team together
   - Review timeline requirements

2. **During planning**:
   - Define phases sequentially
   - Set specific, measurable objectives
   - Identify phase dependencies
   - Estimate durations realistically

3. **After planning**:
   - Get team agreement on phases
   - Adjust timeline based on feedback
   - Create execution document

### Execution Phase (Before/During/After)

1. **Before execution**:
   - Break phases into concrete tasks
   - Assign task owners
   - Identify task dependencies

2. **During execution**:
   - Update sprint todos daily
   - Track blockers immediately
   - Monitor phase progress
   - Adapt if needed

3. **After execution**:
   - Document lessons learned
   - Update PROJECT-STATUS.md
   - Archive completed sprints

### Monitoring & Tracking (Before/During/After)

1. **Before sprints**:
   - Plan sprint scope based on execution phases
   - Set realistic capacity
   - Identify dependencies

2. **During sprints**:
   - Update todos daily
   - Communicate blockers
   - Track phase progress
   - Adjust scope if needed

3. **After sprints**:
   - Calculate completion percentage
   - Document what changed
   - Plan next sprint

## Critical Patterns

### Pattern 0: Central Planning Location

All project plans MUST be created in `.synapsync/planning/` directory:

**Bad**: Storing plans in individual project folders or ad-hoc locations
**Good**: Everything in `.synapsync/planning/{project-name}/`

**Why**: Centralized planning enables:
- Single source of truth for all projects
- Easy discovery of ongoing and completed projects
- Consistent structure across all plans
- Better tooling integration

### Pattern 1: Phase Naming Convention

Use clear, action-oriented phase names:

**Bad**: Phase 1, Part A, Step 1
**Good**: Foundation Setup, API Implementation, Integration Testing

**Why**: Clear names help teams understand what each phase accomplishes and when it's complete.

### Pattern 2: Objective Specificity

Objectives must be measurable and concrete:

**Bad**: "Implement the feature"
**Good**: "Create API endpoint /register with validation for email, password, name"

**Why**: Specific objectives tell you exactly when a phase is done and prevent scope creep.

### Pattern 3: Phase Dependencies

Always declare phase dependencies explicitly:

```markdown
### Phase 2: API Integration
**Dependencies**: Phase 1 (Foundation Setup) must be complete
**Blocks**: Phase 3 (Frontend Implementation)
```

**Why**: Dependencies prevent starting work that has prerequisites and help identify parallel work.

### Pattern 4: Task-to-Phase Mapping

Every task in a sprint must map to an execution phase:

```markdown
- [ ] Implement user validation - Owner: Alice - **Phase**: Phase 1
```

**Why**: This prevents orphan tasks and keeps focus on phase completion.

### Pattern 5: Sprint Scope Alignment

Sprint todos should pull tasks from 1-2 active execution phases:

```markdown
## Sprint 1
- Phase 1: Foundation Setup (5 tasks)
- Phase 2: API Implementation (2 tasks)

## Sprint 2
- Phase 2: API Implementation (3 remaining tasks)
- Phase 3: Integration Testing (4 tasks)
```

**Why**: Keeps sprints focused on completing phases rather than arbitrary time boundaries.

## Integration with Other Skills

### With `task-planner`
Use project-planner to define the overall structure, then use task-planner to create detailed task breakdowns for each sprint.

### With `task-executor`
Once execution phases are defined, use task-executor to monitor daily progress against sprint todos.

### With `growth-architect`
Use for strategic project review and phase prioritization during planning stage.

## Configuration Options

### Project Scale
- **Small (1-2 weeks)**: 2-3 phases, 1-2 sprints
- **Medium (1 month)**: 3-4 phases, 4 sprints
- **Large (2+ months)**: 4-6 phases, 8+ sprints

### Phase Granularity
- **Fine-grained**: Many small phases (easier to track, more overhead)
- **Coarse-grained**: Few large phases (simpler structure, harder to track)
- **Recommended**: 3-5 phases per project

### Sprint Duration
- **Daily**: For fast-moving projects (not recommended)
- **Weekly**: Standard for most projects
- **Bi-weekly**: For slower-moving projects
- **Recommended**: Weekly sprints aligned with execution phases

## Limitations

1. **Requires upfront planning**: Framework assumes analysis can happen before execution
2. **Not suitable for highly iterative work**: If requirements change frequently, plan for iteration phases
3. **Requires phase discipline**: Skipping phases or blending them reduces framework benefits
4. **Manual tracking**: No automated progress calculation; must update manually

## Safety Features

- **Phase review gates**: Analysis and Planning should be reviewed before Execution
- **Dependency blocking**: Never start a phase before prerequisites are complete
- **Scope protection**: All changes to plan must be documented in update sprints
- **Status transparency**: Project-STATUS.md prevents surprises about completion

## Troubleshooting

### Issue: "Analysis is never-ending"

**Solution**: Set a hard deadline for analysis (typically 1-2 days). Document unknowns as risks, not blockers. Move to planning with incomplete analysis if needed.

### Issue: "Plan becomes outdated during execution"

**Solution**: Update EXECUTION.md weekly with actual durations and findings. Keep PLANNING.md as the strategic reference. Document changes in sprint todos.

### Issue: "Team doesn't agree on phases"

**Solution**: During planning, get team consensus on phase names and objectives before finalizing. Make phases in execution document more granular than planning if needed.

### Issue: "Tasks don't fit neatly into phases"

**Solution**: Some tasks are cross-phase (e.g., testing, documentation). Create a "Support Tasks" section in execution plan for these.

### Issue: "Sprint todos get out of sync with execution phases"

**Solution**: Create sprint todos AFTER finalizing execution phases. Map each sprint todo to a specific execution phase objective.

## Example: Building a "Send Register" Feature

**Project Location**: `.synapsync/planning/create-new-register/`

### Analysis Document
File: `.synapsync/planning/create-new-register/analysis/ANALYSIS.md`

```markdown
# Analysis: Send Register Feature

## Requirement Summary
Users need to submit a registration form that creates a new register record in the system and sends a confirmation email.

## Current State Assessment
- User registration endpoint exists but doesn't send emails
- Email service (SendGrid) already configured
- Database has register table with required fields
- No email templates for registration

## Technical Analysis
- Need to update API endpoint to trigger email
- Need to create email template
- Need error handling for email failures
- Frontend form validation required

## Resource Analysis
- Backend: 1 engineer (2 days)
- Frontend: 1 engineer (1 day)
- QA: 1 engineer (0.5 days)

## Success Criteria
- User submits form and receives confirmation email
- Email contains registration details
- Error handling if email fails
- Mobile responsive form
```

### Planning Document
File: `.synapsync/planning/create-new-register/planning/PLANNING.md`

```markdown
# Planning: Send Register Feature

## Implementation Strategy
Build email integration first, then update frontend, then test end-to-end.

## Execution Phases

### Phase 1: Email Service Integration
Create email template and update API to send emails

**Objectives**:
- Create email template in SendGrid
- Update /register endpoint to send confirmation email
- Add error handling for email failures

### Phase 2: Frontend Form Enhancement
Update form with validation and success messaging

**Objectives**:
- Add form validation
- Show success message after submit
- Handle error states
- Mobile responsive design

### Phase 3: End-to-End Testing
Verify complete flow works

**Objectives**:
- Test happy path on desktop
- Test happy path on mobile
- Test error scenarios
- Performance testing

## Timeline
- Phase 1: 2 days
- Phase 2: 1 day
- Phase 3: 1 day
```

### Execution Document
File: `.synapsync/planning/create-new-register/execution-plan/EXECUTION.md`

```markdown
# Execution Plan: Send Register Feature

## Phase 1: Email Service Integration (2 days)

**Tasks**:
1. Create email template in SendGrid - 2 hours
2. Update API endpoint /register - 4 hours
3. Add error handling - 2 hours

## Phase 2: Frontend Form (1 day)

**Tasks**:
1. Add form validation - 2 hours
2. Add success/error messages - 2 hours
3. Make mobile responsive - 2 hours

## Phase 3: Testing (1 day)

**Tasks**:
1. Manual testing on desktop - 2 hours
2. Manual testing on mobile - 1 hour
3. Error scenario testing - 1 hour
```

### Sprint 1 Todos
File: `.synapsync/planning/create-new-register/todos/SPRINT-1.md`

```markdown
# Sprint 1: Week of Jan 27

## Phase Status
| Phase | Tasks | Done | Status |
|-------|-------|------|--------|
| Phase 1 | 3 | 1 | In Progress (33%) |
| Phase 2 | 3 | 0 | Not Started |
| Phase 3 | 3 | 0 | Not Started |

## Todos

### Phase 1: Email Service Integration
- [x] Create SendGrid email template - Owner: Alex
- [ ] Update /register endpoint - Owner: Alex (In Progress)
- [ ] Add error handling - Owner: Alex

### Phase 2: Frontend Form
- [ ] Add form validation - Owner: Jordan
- [ ] Add success/error messages - Owner: Jordan
- [ ] Make mobile responsive - Owner: Jordan

### Phase 3: Testing
- [ ] Manual testing desktop - Owner: Casey
- [ ] Manual testing mobile - Owner: Casey
- [ ] Error scenario testing - Owner: Casey

## Blockers
None currently

## Next Week
Complete Phase 1, start Phase 2
```

## Version History

- **1.0** (2026-01-28): Initial release with three-phase framework and sprint tracking

## Future Enhancements

- [ ] Add Gantt chart template for timeline visualization
- [ ] Create phase completion checklist template
- [ ] Add phase dependency diagram template
- [ ] Include burndown chart template for sprints
- [ ] Add retrospective template for project closure
