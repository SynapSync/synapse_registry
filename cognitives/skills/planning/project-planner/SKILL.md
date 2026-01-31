---
name: project-planner
description: >
  Planning-only framework that produces structured analysis, planning, and execution-plan documents.
  Trigger: When planning a new feature, project scope, or complex task that requires structured planning documents.
license: Apache-2.0
metadata:
  author: synapsync
  version: "1.2"
  scope: [root]
  auto_invoke: "Planning a new project or feature"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

## Purpose

Create a structured project planning framework that produces analysis, planning, and execution-plan documents with clear roles, deliverables, and tracking mechanisms.

> **CRITICAL RULE 1 — PLANNING ONLY**
>
> This skill is strictly a **planning skill**. Its sole responsibility is to **create, organize, and deliver all planning documents** (analysis, planning, execution plan, sprint templates). It **MUST NOT** start implementing, executing, or carrying out any of the tasks defined in the plan. Execution is handled by a separate dedicated skill. Once all planning documents are complete, this skill's job is done.

> **CRITICAL RULE 2 — CONTEXT-FIRST: RESPECT EXISTING PATTERNS**
>
> Before making **any** planning decision, this skill **MUST** explore and understand the existing codebase. Every proposal — whether it involves UI, backend logic, architecture, file structure, naming, or tooling — **MUST align with the project's established patterns and conventions**. The planner does not invent new approaches when existing ones already solve the problem. It does not propose a generic button when the project has a design system with its own button component. It does not suggest a new state management pattern when the app already uses one. It does not introduce a new folder structure when the project follows an established convention.
>
> **This is not a restriction on creativity.** When something genuinely new is needed, the planner documents *why* existing patterns don't suffice and proposes the new approach as a conscious, justified deviation — never as a default.
>
> **Mandatory before planning**:
> 1. Explore the project's file structure, architecture, and conventions
> 2. Identify reusable components, shared utilities, design tokens, and patterns
> 3. Document these findings in a `CONVENTIONS.md` reference file
> 4. Reference these conventions in every planning decision

## When to Use This Skill

- **New feature development**: Building new functionality with undefined scope
- **Complex refactoring**: Large architectural changes requiring careful planning
- **Integration projects**: Multi-component projects requiring coordination
- **Sprint planning**: Breaking down quarterly goals into actionable tasks
- **Technical investigations**: Research-heavy features needing analysis before implementation
- **Cross-team initiatives**: Projects requiring stakeholder alignment and phase tracking

## Capabilities

### Planning Framework
- **Three-phase document structure**: Analysis → Planning → Execution Plan
- **Hierarchical goals**: Features → Phases → Objectives
- **Dependency tracking**: Task relationships and blocking
- **Sprint templates**: Pre-built tracking documents ready for execution

### Codebase Discovery
- Project structure and architecture exploration
- UI component and design system identification
- Backend patterns and conventions mapping
- Naming conventions, file organization, and coding style detection
- Reusable utilities, shared modules, and design tokens catalog

### Analysis Document Creation
- Requirements documentation
- Resource assessment
- Technical feasibility evaluation
- Constraint identification
- Existing conventions and patterns reference

### Planning Document Creation
- Step-by-step implementation strategy
- Phase decomposition with objectives
- Resource allocation
- Timeline and dependency mapping

### Execution Plan Document Creation
- Concrete task definitions organized by phase
- Phase-based task breakdown
- Sprint/todo template organization
- Progress tracking templates

### Sprint Template Creation
- Sprint-based todo list templates
- Phase completion checklist templates
- Dependency resolution tracking templates
- Overall project progress dashboard template

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

### Step 0: Codebase Discovery (MANDATORY)
Before any planning begins, explore the existing project to understand its patterns, architecture, and conventions. **This step is non-negotiable.** Skipping it leads to plans that conflict with the project's established design.

**Deliverable**: `.synapsync/planning/{project-name}/analysis/CONVENTIONS.md`

**What to explore**:
1. **Project Structure**: Folder organization, module boundaries, monorepo vs single-app
2. **UI Patterns** (if applicable): Component library, design system, reusable components (buttons, forms, modals, cards, layouts), styling approach (CSS modules, Tailwind, styled-components, etc.), design tokens (colors, spacing, typography)
3. **Backend Patterns** (if applicable): API structure (REST, GraphQL, tRPC), error handling patterns, middleware conventions, service/repository layers, validation approach
4. **State Management**: How the app manages state (Redux, Zustand, Context, signals, etc.)
5. **Data Layer**: ORM/database patterns, migration conventions, model definitions
6. **Naming Conventions**: File naming, variable naming, component naming, route naming
7. **Testing Patterns**: Test framework, test file location, mocking approach, coverage expectations
8. **Shared Utilities**: Existing helpers, hooks, services, and abstractions already available
9. **Dependencies & Tooling**: Key libraries already in use, build tools, linters, formatters

**Output format for CONVENTIONS.md**:
```markdown
# Project Conventions: [Project Name]

## Architecture
- Pattern: [e.g., Feature-based modules, MVC, Clean Architecture]
- Key directories: [e.g., src/features/, src/shared/, src/core/]

## UI Components (if applicable)
- Design system: [e.g., Custom components in src/components/ui/]
- Button component: [e.g., src/components/ui/Button.tsx — use this, never create raw <button>]
- Form pattern: [e.g., React Hook Form + Zod validation]
- Styling: [e.g., Tailwind CSS with design tokens in tailwind.config.ts]

## Backend Patterns (if applicable)
- API style: [e.g., REST with Express routers in src/routes/]
- Error handling: [e.g., Custom AppError class in src/utils/errors.ts]
- Validation: [e.g., Zod schemas in src/schemas/]

## State Management
- Approach: [e.g., Zustand stores in src/stores/]

## Naming Conventions
- Files: [e.g., kebab-case for files, PascalCase for components]
- Functions: [e.g., camelCase, verbs for actions]

## Testing
- Framework: [e.g., Vitest + Testing Library]
- Location: [e.g., __tests__/ adjacent to source]

## Shared Utilities
- [List key reusable modules already available]

## Key Dependencies
- [List critical libraries and their purpose]
```

**Role**: Codebase archaeologist. Ask "what patterns does this project already follow?" and "what exists that we should reuse?"

> **IMPORTANT**: Every subsequent step (Analysis, Planning, Execution Plan) MUST reference this conventions document. If a planning decision conflicts with an established convention, it must be explicitly called out and justified.

### Step 1: Analysis Phase
Investigate and document what you need to build. **Reference CONVENTIONS.md throughout.**

**Deliverable**: `.synapsync/planning/{project-name}/analysis/ANALYSIS.md`

**Sections**:
1. **Requirement Summary**: What are we building?
2. **Current State Assessment**: What exists today?
3. **Conventions Reference**: Link to CONVENTIONS.md — summarize which existing patterns are relevant to this feature
4. **Technical Analysis**: What technologies/tools do we need? (Prioritize what the project already uses)
5. **Resource Analysis**: What resources are available?
6. **Constraints & Risks**: What limitations exist?
7. **Success Criteria**: How will we know it's done?

**Role**: Information gathering and feasibility assessment. Ask "what do we have?" and "what do we need?"

### Step 2: Planning Phase
Define how you'll build it based on analysis findings. **All proposals must align with CONVENTIONS.md.**

**Deliverable**: `.synapsync/planning/{project-name}/planning/PLANNING.md`

**Sections**:
1. **Implementation Strategy**: High-level approach — must explain how it fits within the existing architecture
2. **Conventions Alignment**: Which existing patterns, components, and utilities will be reused. Any justified deviations from conventions must be explicitly listed here with reasoning.
3. **Execution Phases**: Major milestones/phases
   - Each phase has a name, description, and concrete objectives
   - Phases should be sequential or have clear dependencies
4. **Phase Details**: For each phase:
   - **Phase Name & Description**
   - **Objectives**: Specific, measurable goals
   - **Deliverables**: What gets completed
   - **Dependencies**: Prerequisites from other phases
   - **Existing Patterns Used**: Which conventions/components apply to this phase
5. **Resource Plan**: Who/what is needed
6. **Timeline**: Estimated phase duration
7. **Risk Mitigation**: Handling identified risks

**Role**: Strategic planning. Ask "how will we do this?" and "what are the phases?"

### Step 3: Execution Plan Document
Define the concrete tasks and structure needed for execution. **This step creates the execution plan document — it does NOT start executing tasks.** Each task must specify which existing patterns, components, or utilities to use.

**Deliverable**: `.synapsync/planning/{project-name}/execution-plan/EXECUTION.md`

**Sections**:
1. **Execution Overview**: Summary of phases and timeline
2. **Phase Breakdown**: For each execution phase:
   - **Phase X: [Name]**
   - **Objectives**: What this phase accomplishes
   - **Tasks**: Specific, actionable items — each task should note which existing components/patterns/utilities to use (e.g., "Create form using `FormField` component from `src/components/ui/` with Zod validation per project convention")
   - **Expected Duration**: How long this phase takes
3. **Success Criteria per Phase**: Completion metrics
4. **Resource Allocation**: Who does what
5. **Risk Monitoring**: Ongoing risk assessment

**Role**: Task definition and structuring. Ask "what specific tasks must be done, and which existing patterns apply?"

### Step 4: Sprint Templates
Create sprint tracking templates ready for use during execution. **This step creates the sprint template documents — it does NOT begin tracking or executing work.**

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

**Role**: Template creation for future tracking. Ask "what will we need to track?"

### Step 5: Handoff
Once all documents are created, the planning skill's work is complete. Summarize what was produced and indicate that the plan is ready to be picked up by an execution skill or team.

**Deliverable**: Summary of all created documents and their locations.

**This skill STOPS here. It does NOT begin implementing any of the planned tasks.**

## Directory Structure

All projects must follow this structure inside `.synapsync/planning/`:

```
.synapsync/planning/
├── {project-name}/              # Project identifier (kebab-case)
│   ├── analysis/
│   │   ├── CONVENTIONS.md       # Existing project patterns & conventions (Step 0)
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

## Conventions Reference
See: `CONVENTIONS.md`
- Key patterns relevant to this feature: [list]
- Existing components/utilities to reuse: [list]
- Architecture patterns that apply: [list]

## Technical Analysis
- Required technologies (prioritize what the project already uses)
- Architecture implications (within existing architecture)
- New dependencies needed (justify why existing tools don't suffice)

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
High-level approach and philosophy. Explain how it fits within the existing architecture.

## Conventions Alignment
- **Reused patterns**: [List existing patterns, components, and utilities that will be used]
- **Deviations**: [List any justified departures from existing conventions, with reasoning]
  - Deviation 1: [What] — Reason: [Why existing pattern doesn't suffice]

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

**Existing Patterns Used**: [Which conventions/components apply]

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

**Day 0**: Codebase Discovery
- Explore project structure and architecture
- Identify existing patterns, components, and conventions
- Create CONVENTIONS.md

**Day 1**: Fill in Analysis
- Research requirements
- Document current state (referencing CONVENTIONS.md)
- Identify constraints

**Day 2**: Create Planning document
- Define phases
- Set objectives per phase
- Create timeline

**Day 3+**: Complete execution plan and sprint templates
- Write EXECUTION.md with concrete tasks per phase
- Create SPRINT-1.md template for tracking
- Summarize all produced documents and hand off to execution

## Best Practices

### Codebase Discovery (Always First)

1. **Explore the project**:
   - Read the project's README, CLAUDE.md, or similar documentation
   - Browse the folder structure to understand architecture
   - Identify the UI component library / design system
   - Identify backend patterns (API routes, services, models)
   - Check existing utilities, hooks, and shared modules
   - Note naming conventions and file organization

2. **Document findings**:
   - Create CONVENTIONS.md with all discovered patterns
   - List reusable components by name and path
   - Note the styling approach, state management, and testing patterns
   - Identify any design tokens, theme configurations, or shared constants

3. **Use as foundation**:
   - Every subsequent document references CONVENTIONS.md
   - Every proposed solution is checked against existing patterns first

### Analysis Phase (Before/During)

1. **Before starting**:
   - Complete Codebase Discovery (Step 0) — CONVENTIONS.md must exist
   - Gather all requirements documentation
   - Interview stakeholders
   - Review related systems

2. **During analysis**:
   - Document assumptions clearly
   - Identify technical unknowns
   - List all constraints upfront
   - Cross-reference requirements against existing conventions — what can be solved with existing patterns?

3. **After analysis**:
   - Circulate for feedback
   - Validate assumptions with team
   - Get stakeholder sign-off

### Planning Phase (Before/During)

1. **Before planning**:
   - Finalize analysis document
   - Review CONVENTIONS.md — ensure you know the project's patterns
   - Get team together
   - Review timeline requirements

2. **During planning**:
   - Define phases sequentially
   - Set specific, measurable objectives
   - Identify phase dependencies
   - Estimate durations realistically
   - For each phase, note which existing components/patterns apply
   - Document any justified deviations in the Conventions Alignment section

3. **After planning**:
   - Get team agreement on phases
   - Verify all proposals align with CONVENTIONS.md
   - Adjust timeline based on feedback
   - Create execution document

### Execution Plan Document (Before/During)

1. **Before writing the execution plan**:
   - Break phases into concrete tasks
   - Assign task owners
   - Identify task dependencies

2. **During execution plan writing**:
   - Define clear, actionable tasks per phase
   - Map dependencies between tasks
   - Set success criteria per phase
   - Allocate resources to tasks

3. **After completing the execution plan document**:
   - Review task completeness with stakeholders
   - Validate that all phases have concrete deliverables

### Sprint Template Creation (Before/During)

1. **Before creating sprint templates**:
   - Plan sprint scope based on execution phases
   - Set realistic capacity
   - Identify dependencies

2. **During template creation**:
   - Structure todos by phase
   - Include blocker tracking sections
   - Add completion tracking metrics
   - Ensure tasks map to execution phases

3. **After sprint templates are created**:
   - Verify all execution plan tasks are represented
   - Confirm sprint scope aligns with phase objectives
   - **Hand off** — the planning skill's work is done

## Critical Patterns

### Pattern 0: Planning Only — Never Execute

This skill **MUST NOT** begin implementing, coding, building, deploying, or otherwise carrying out any task defined in the plan. Its output is strictly **documents**: analysis, planning, execution plan, and sprint templates. Once all documents are created and delivered, the skill's work is complete.

**Bad**: Creating the plan and then starting to implement Phase 1 tasks
**Good**: Creating all planning documents and summarizing what was produced, then stopping

**Why**: Separation of concerns. Planning and execution are distinct responsibilities. Mixing them leads to incomplete plans, rushed analysis, and untracked work. A dedicated execution skill will pick up where this skill leaves off.

### Pattern 1: Central Planning Location

All project plans MUST be created in `.synapsync/planning/` directory:

**Bad**: Storing plans in individual project folders or ad-hoc locations
**Good**: Everything in `.synapsync/planning/{project-name}/`

**Why**: Centralized planning enables:
- Single source of truth for all projects
- Easy discovery of ongoing and completed projects
- Consistent structure across all plans
- Better tooling integration

### Pattern 2: Respect Existing Patterns — Never Reinvent

Every planning decision must align with the project's established conventions. Before proposing any component, pattern, or approach, check what already exists.

**Bad**: "Create a new `<button>` element with custom CSS for the submit action"
**Good**: "Use the existing `Button` component from `src/components/ui/Button.tsx` with variant='primary'"

**Bad**: "Set up Redux for state management"
**Good**: "Use the existing Zustand store pattern in `src/stores/` as the project already uses Zustand"

**Bad**: "Create a `helpers/` folder for utility functions"
**Good**: "Add utility to `src/utils/` following the existing project structure"

**Bad**: "Use Axios for API calls"
**Good**: "Use the existing `apiClient` wrapper in `src/services/api.ts` that the project already uses"

**Why**: Consistency is what makes a codebase maintainable. Introducing new patterns when existing ones work creates fragmentation, increases cognitive load, and produces code that feels foreign to the team. The planner's job is to work **with** the project, not against it.

### Pattern 3: Justify Every Deviation

When something genuinely new IS needed (new library, new pattern, new component not yet in the system), the plan must explicitly document:
1. **What exists today** and why it doesn't solve the problem
2. **What is proposed** as the new approach
3. **Why the deviation is justified** — concrete technical reasoning
4. **How it aligns** with the project's broader architecture and philosophy

This goes in the **Conventions Alignment** section of the Planning document.

**Bad**: Silently introducing a new pattern without mentioning it
**Good**:
```markdown
## Conventions Alignment
### Deviation: New WebSocket service
- **Existing pattern**: REST API calls via `src/services/api.ts`
- **Why it doesn't suffice**: Real-time notifications require persistent connections; REST polling would be inefficient
- **Proposal**: Create `src/services/websocket.ts` following the same service pattern structure
- **Alignment**: Uses the same error handling conventions and auth token flow as `api.ts`
```

**Why**: Conscious, documented deviations are healthy engineering. Silent deviations are technical debt.

### Pattern 4: Phase Naming Convention

Use clear, action-oriented phase names:

**Bad**: Phase 1, Part A, Step 1
**Good**: Foundation Setup, API Implementation, Integration Testing

**Why**: Clear names help teams understand what each phase accomplishes and when it's complete.

### Pattern 5: Objective Specificity

Objectives must be measurable and concrete:

**Bad**: "Implement the feature"
**Good**: "Create API endpoint /register with validation for email, password, name"

**Why**: Specific objectives tell you exactly when a phase is done and prevent scope creep.

### Pattern 6: Phase Dependencies

Always declare phase dependencies explicitly:

```markdown
### Phase 2: API Integration
**Dependencies**: Phase 1 (Foundation Setup) must be complete
**Blocks**: Phase 3 (Frontend Implementation)
```

**Why**: Dependencies prevent starting work that has prerequisites and help identify parallel work.

### Pattern 7: Task-to-Phase Mapping

Every task in a sprint must map to an execution phase:

```markdown
- [ ] Implement user validation - Owner: Alice - **Phase**: Phase 1
```

**Why**: This prevents orphan tasks and keeps focus on phase completion.

### Pattern 8: Sprint Scope Alignment

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

### With `project-executor` (Execution Skill)
Once all planning documents are created, hand off to `project-executor` to begin implementing and tracking the plan. **This skill creates the plan; `project-executor` carries it out.**

### With `task-planner`
Use project-planner to define the overall structure, then use task-planner to create detailed task breakdowns for each sprint.

### With `growth-architect`
Use for strategic project review and phase prioritization during the planning stage.

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

1. **Planning only**: This skill creates planning documents but does NOT execute, implement, or carry out any planned tasks. Use a dedicated execution skill for that.
2. **Requires upfront planning**: Framework assumes analysis can happen before execution
3. **Not suitable for highly iterative work**: If requirements change frequently, plan for iteration phases
4. **Requires phase discipline**: Skipping phases or blending them reduces framework benefits
5. **Manual tracking**: No automated progress calculation; must update manually

## Safety Features

- **Planning-only boundary**: This skill never starts implementing tasks — it only produces planning documents
- **Conventions enforcement**: CONVENTIONS.md must be created before any planning begins; all proposals are checked against it
- **Deviation transparency**: Any departure from existing patterns must be explicitly documented and justified
- **Phase review gates**: Analysis and Planning documents should be reviewed before creating the Execution Plan
- **Dependency blocking**: Phase dependencies are documented to prevent premature execution
- **Scope protection**: All plan changes must be documented in updated documents
- **Status transparency**: PROJECT-STATUS.md template prevents surprises about completion

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

### Issue: "Plan proposes patterns that conflict with existing codebase"

**Solution**: This means Step 0 (Codebase Discovery) was skipped or incomplete. Go back and create/update CONVENTIONS.md. Review every proposal in the plan against the documented conventions. Replace conflicting proposals with approaches that use existing patterns.

### Issue: "Not sure if something should follow existing patterns or introduce something new"

**Solution**: Default to existing patterns. Only deviate when the existing approach genuinely cannot solve the problem. When in doubt, ask the team. If deviating, document the reasoning in the Conventions Alignment section of the Planning document.

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

## Conventions Reference
See: `CONVENTIONS.md`
- **UI**: Project uses custom `FormField`, `Button`, and `Input` components from `src/components/ui/`
- **Forms**: React Hook Form + Zod validation pattern
- **API**: Express routes in `src/routes/` with `apiClient` wrapper
- **Error handling**: Uses `AppError` class from `src/utils/errors.ts`

## Technical Analysis
- Need to update API endpoint to trigger email (using existing Express route pattern)
- Need to create email template (using existing SendGrid integration)
- Need error handling for email failures (using existing AppError pattern)
- Frontend form validation required (using existing React Hook Form + Zod pattern)

## Resource Analysis
- Backend: 1 engineer (2 days)
- Frontend: 1 engineer (1 day)
- QA: 1 engineer (0.5 days)

## Success Criteria
- User submits form and receives confirmation email
- Email contains registration details
- Error handling if email fails (consistent with existing error patterns)
- Mobile responsive form (using existing responsive patterns)
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

- **1.2** (2026-01-29): Added context-first planning rules — mandatory Codebase Discovery step, CONVENTIONS.md, pattern alignment enforcement, and deviation justification requirements.
- **1.1** (2026-01-29): Refactored to planning-only scope — skill creates all planning documents but does not execute tasks. Execution responsibility delegated to a dedicated execution skill.
- **1.0** (2026-01-28): Initial release with three-phase framework and sprint tracking

## Future Enhancements

- [ ] Add Gantt chart template for timeline visualization
- [ ] Create phase completion checklist template
- [ ] Add phase dependency diagram template
- [ ] Include burndown chart template for sprints
- [ ] Add retrospective template for project closure
