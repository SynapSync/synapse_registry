---
name: universal-planner
description: >
  Adaptive planning skill that produces professional documentation for any software scenario:
  new projects, features, refactors, bug fixes, tech debt, and architecture changes.
  Trigger: When planning any software work that requires structured analysis and actionable task plans.
license: Apache-2.0
metadata:
  author: synapsync
  version: "2.0"
  scope: [root]
  auto_invoke:
    - "Planning a new project, feature, refactor, or any software work"
    - "Generate project planning documentation"
    - "Create requirements, design, and execution plans"
    - "Analyze and plan a bug fix, tech debt reduction, or architecture change"
  changelog:
    - version: "2.0"
      date: "2026-02-11"
      changes:
        - "Obsidian-native output: rich frontmatter, wiki-links, bidirectional references"
        - "PROGRESS.md and sprint plans include full frontmatter with progress tracking"
        - "Graduation gates, metric tables, and carried-forward sections in sprints"
        - "Optional retrospective generation at sprint completion"
        - "Pattern 8 updated: bidirectionality enforced with related field"
        - "Mode-specific frontmatter fields (severity for BUG_FIX, scope_modules for REFACTOR)"
    - version: "1.1"
      date: "2026-02-05"
      changes:
        - "Sprint generation is now optional — skill asks user before generating sprint documents"
        - "User can defer sprint creation to universal-planner-executor"
    - version: "1.0"
      date: "2026-02-04"
      changes:
        - "Initial release — unified from project-planner, sdlc-planner, and universal prompt templates"
        - "Six adaptive planning modes: NEW_PROJECT, NEW_FEATURE, REFACTOR, BUG_FIX, TECH_DEBT, ARCHITECTURE"
        - "Context-first codebase discovery with CONVENTIONS.md"
        - "Full SDLC requirements and system design for greenfield projects"
        - "Adaptive architecture detection across 12 product domains"
        - "4-level task granularity with verification commands and rollback strategies"
        - "MoSCoW prioritization, ADRs, Mermaid diagrams, and progress tracking"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# Universal Planner

## Assets

This skill uses the [assets pattern](../../../docs/standards/skill-assets-pattern.md). Detailed documentation, templates, and helpers are in the [assets/](assets/) directory:

- **[assets/modes/](assets/modes/)** - 6 planning modes with detailed workflows
- **[assets/helpers/](assets/helpers/)** - Config resolution and shared workflows
- **[assets/templates/](assets/templates/)** - Document templates with frontmatter
- **[assets/validators/](assets/validators/)** - Output validation schemas
- **[assets/examples/](assets/examples/)** - Test cases and examples

See [assets/README.md](assets/README.md) for full directory documentation.

---

## Purpose

Produce professional, structured planning documentation for **any** software engineering scenario. This skill adapts its workflow, depth, and output structure based on the type of work — from full SDLC documentation for a new product idea to a focused root-cause analysis and fix plan for a bug.

It replaces the need for separate planning skills by detecting the planning mode from the user's input and activating only the relevant workflow phases.

---

## Critical Rules

> **RULE 1 — PLANNING ONLY: NEVER EXECUTE**
>
> This skill produces **documentation only**. It MUST NOT implement, code, build, deploy, or carry out any task defined in the plan. Once all planning documents are complete, summarize what was produced and stop. Execution is a separate responsibility.

> **RULE 2 — CONTEXT-FIRST: RESPECT EXISTING PATTERNS**
>
> Before making **any** planning decision on an existing codebase, this skill MUST explore and understand the project's established patterns, conventions, and architecture. Every proposal MUST align with what already exists. When something genuinely new is needed, the deviation must be explicitly documented and justified — never silently introduced.
>
> **This rule does not apply to NEW_PROJECT mode** (there is no existing codebase to discover).

> **RULE 3 — ADAPTIVE MODE DETECTION**
>
> Detect the planning mode from the user's input (see Mode Detection below). If the mode is ambiguous, ask the user. Never force a mode that doesn't match the scenario — the wrong mode produces irrelevant documentation.

> **RULE 4 — PROFESSIONAL QUALITY**
>
> Output must read as if produced by a senior engineering team. Avoid vague language, placeholder text, or generic filler. Every statement must be specific to the project. Quantify non-functional requirements. Use Mermaid diagrams for architecture, data models, and flows. Use ADR format for architecture decisions.

> **RULE 5 — COMPLETENESS**
>
> Generate ALL documents required by the active mode. No file should be skipped or left empty. Each file must contain substantive, meaningful content specific to the project. Verify completeness before handoff.

> **RULE 6 — ASSUMPTION TRANSPARENCY**
>
> When information is missing or vague, infer reasonable defaults and document every assumption in the analysis. Never silently assume technical decisions. The development team must be able to validate all assumptions before implementation begins.

---

## Planning Modes

### Mode Detection

Detect the mode from the user's input using these signals:

| Mode | Signals | Example Inputs |
|------|---------|----------------|
| **NEW_PROJECT** | Product idea, app concept, "build from scratch", no existing codebase | "I need an app to track expenses", "Build a SaaS for team scheduling" |
| **NEW_FEATURE** | Adding functionality to existing project, "add", "implement", "create" within existing codebase | "Add dark mode to the app", "Implement payment integration" |
| **REFACTOR** | Restructure, reorganize, migrate patterns, improve architecture of existing code | "Refactor the auth module", "Migrate from Redux to Zustand" |
| **BUG_FIX** | Fix, issue, broken, regression, error, not working | "Fix the login timeout bug", "Users can't submit forms on mobile" |
| **TECH_DEBT** | Cleanup, dead code, outdated, deprecated, missing tests, duplication | "Clean up the orders module", "Reduce tech debt in the API layer" |
| **ARCHITECTURE** | System design, architecture evolution, scaling, infrastructure change | "Design the microservices migration", "Plan the monorepo restructure" |

### Mode Capabilities Matrix

| Document | NEW_PROJECT | NEW_FEATURE | REFACTOR | BUG_FIX | TECH_DEBT | ARCHITECTURE |
|----------|:-----------:|:-----------:|:--------:|:-------:|:---------:|:------------:|
| README.md | Yes | Yes | Yes | Yes | Yes | Yes |
| discovery/CONVENTIONS.md | — | Yes | Yes | Yes | Yes | Yes |
| requirements/* (7 files) | Yes | — | — | — | — | — |
| design/* (6 files) | Yes | — | — | — | — | Yes |
| analysis/ANALYSIS.md | Yes | Yes | Yes | Yes | Yes | Yes |
| planning/PLANNING.md | Yes | Yes | Yes | Yes | Yes | Yes |
| execution/EXECUTION.md | Yes | Yes | Yes | Yes | Yes | Yes |
| sprints/PROGRESS.md | Yes | Yes | Yes | Yes | Yes | Yes |
| sprints/SPRINT-*.md | Yes | Yes | Yes | Yes | Yes | Yes |

---

## Output Structure

All output goes into `{output_base}/planning/{project-name}/`.

```
{output_base}/planning/{project-name}/
├── README.md                              # Project overview and document navigation
│
├── discovery/                              # Codebase Discovery (all modes except NEW_PROJECT)
│   └── CONVENTIONS.md                     #   Existing patterns, components, conventions
│
├── requirements/                           # SDLC Phase 1 (NEW_PROJECT only)
│   ├── problem-definition.md              #   Problem statement and value proposition
│   ├── goals-and-metrics.md               #   SMART goals and KPIs
│   ├── stakeholders-and-personas.md       #   User personas and stakeholder map
│   ├── functional-requirements.md         #   MoSCoW-prioritized requirements
│   ├── non-functional-requirements.md     #   Performance, security, scalability targets
│   ├── assumptions-and-constraints.md     #   Inferred assumptions and known constraints
│   └── out-of-scope.md                    #   Excluded features and boundary definitions
│
├── design/                                 # System Design (NEW_PROJECT + ARCHITECTURE)
│   ├── system-overview.md                 #   System context and technology recommendations
│   ├── architecture-decisions.md          #   ADRs for key decisions
│   ├── high-level-architecture.md         #   Component diagram and communication patterns
│   ├── data-model.md                      #   Entity relationships and storage strategy
│   ├── core-flows.md                      #   Sequence diagrams for critical flows
│   └── non-functional-design.md           #   Performance, security, and scalability design
│
├── analysis/                               # Analysis (all modes — content adapts per mode)
│   └── ANALYSIS.md
│
├── planning/                               # Strategy (all modes)
│   └── PLANNING.md
│
├── execution/                              # Concrete task breakdown (all modes)
│   └── EXECUTION.md
│
└── sprints/                                # Sprint tracking (all modes)
    ├── PROGRESS.md                        #   Master progress dashboard
    └── SPRINT-{N}-{name}.md              #   Detailed sprint plans with checkboxes
```

### Naming Convention

Use kebab-case for `{project-name}`, inferred from the user's input:
- "expense tracker app" → `expense-tracker`
- "Refactor the auth module" → `refactor-auth-module`
- "Fix login timeout bug" → `fix-login-timeout`
- "CI/CD pipeline manager" → `cicd-pipeline-manager`

---

## Configuration Resolution

See [assets/helpers/config-resolver.md](assets/helpers/config-resolver.md) for the standardized resolution workflow.

**Quick summary:**
1. Check `cognitive.config.json` in project root → read `output_base`
2. If not found → ask user, suggest `~/obsidian-vault/{project-name}/`, create config
3. Use `{output_base}/` for all output paths

All `{output_base}` references depend on this resolution.

## Obsidian Output Standard

All documents generated by this skill MUST follow the `obsidian-md-standard`:

1. **Frontmatter**: Every `.md` file includes the universal frontmatter schema (title, date, updated, project, type, status, version, tags, changelog, related)
2. **Types**: Use `conventions`, `analysis`, `plan`, `execution-plan`, `sprint-plan`, `progress`, `requirements`, `architecture` as appropriate
3. **Wiki-links**: All inter-document references use `[[filename]]` syntax — never `[text](relative-path.md)`
4. **Referencias**: Every document ends with `## Referencias` listing Parent, Siblings, Children, and Input Documents
5. **Living documents**: PROGRESS.md and sprint plans are living documents — bump `version`, update `changelog`, transition `status` on modification
6. **IDs**: Use FR-/NFR- for requirements, ADR- for architecture decisions, T- for tasks
7. **Bidirectional**: If document A references B, document B must reference A in `related` and `## Referencias`
8. **Metrics**: Use `| Metric | Before | After | Delta | Status |` format for all quantitative data
9. **Gates**: Sprint plans include `## Graduation Gate` with verifiable checkbox criteria
10. **Carried Forward**: Sprint 2+ includes `## Carried Forward from [[previous-sprint]]` for incomplete items
11. **Sequential numbering**: Use `01-`, `02-` prefixes where reading order matters

**Frontmatter template for sprint plans:**
```yaml
---
title: "Sprint {N}: {Name}"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "{project-name}"
type: "sprint-plan"
status: "draft"
version: "1.0"
sprint: {N}
phase: "{active-phases}"
progress: 0
previous_doc: "[[SPRINT-{N-1}-name]]"
next_doc: "[[SPRINT-{N+1}-name]]"
parent_doc: "[[PROGRESS]]"
tags: ["{project-name}", "sprint-{N}", "sprint-plan"]
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Initial sprint plan"]
related:
  - "[[PROGRESS]]"
  - "[[EXECUTION]]"
  - "[[SPRINT-{N-1}-name]]"
  - "[[SPRINT-{N+1}-name]]"
---
```

**Mode-specific frontmatter extensions:**
- **BUG_FIX**: Add `severity: "critical|high|medium|low"` to ANALYSIS.md frontmatter
- **REFACTOR**: Add `scope_modules: ["module-a", "module-b"]` to ANALYSIS.md frontmatter

## Shared Workflow Steps

These steps are shared across all modes. Mode-specific steps are documented in the next section.

### Step: Codebase Discovery (all modes except NEW_PROJECT)

Before any planning begins, explore the existing project to understand its patterns, architecture, and conventions. **This step is non-negotiable.**

**Deliverable**: `discovery/CONVENTIONS.md`

**What to explore**:
1. **Project Structure**: Folder organization, module boundaries, monorepo vs single-app
2. **UI Patterns** (if applicable): Component library, design system, reusable components, styling approach, design tokens
3. **Backend Patterns** (if applicable): API structure, error handling, middleware, service/repository layers, validation
4. **State Management**: How the app manages state
5. **Data Layer**: ORM/database patterns, migration conventions, model definitions
6. **Naming Conventions**: File naming, variable naming, component naming, route naming
7. **Testing Patterns**: Framework, file location, mocking approach, coverage expectations
8. **Shared Utilities**: Existing helpers, hooks, services, and abstractions already available
9. **Dependencies & Tooling**: Key libraries in use, build tools, linters, formatters

**Output format**:
```markdown
# Project Conventions: {Project Name}

## Architecture
- Pattern: [e.g., Feature-based modules, MVC, Clean Architecture]
- Key directories: [e.g., src/features/, src/shared/, src/core/]

## UI Components (if applicable)
- Design system: [e.g., Custom components in src/components/ui/]
- Key components: [e.g., Button, FormField, Modal — with paths]
- Styling: [e.g., Tailwind CSS with tokens in tailwind.config.ts]

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
- [List key reusable modules with paths]

## Key Dependencies
- [List critical libraries and their purpose]
```

> **IMPORTANT**: Every subsequent document MUST reference CONVENTIONS.md. If a planning decision conflicts with an established convention, it must be explicitly called out and justified.

### Step: Analysis

Investigate and document what you need to build or change. The analysis content adapts per mode (see Mode-Specific Workflows below).

**Deliverable**: `analysis/ANALYSIS.md`

**Common sections** (all modes):
1. **Executive Summary**: What are we doing and why?
2. **Current State Assessment**: What exists today?
3. **Conventions Reference** (if applicable): Which existing patterns are relevant
4. **Technical Analysis**: Technologies, tools, architectural implications
5. **Constraints & Risks**: Limitations, risks with probability and mitigation
6. **Success Criteria**: How we measure done

### Step: Planning

Define the implementation strategy based on analysis findings. All proposals must align with CONVENTIONS.md (when applicable).

**Deliverable**: `planning/PLANNING.md`

**Common sections** (all modes):
1. **Implementation Strategy**: High-level approach — how it fits within existing architecture
2. **Conventions Alignment** (if applicable): Patterns to reuse, justified deviations
3. **Execution Phases**: Major milestones with name, description, objectives, deliverables, dependencies
4. **Resource Plan**: Who/what is needed
5. **Risk Mitigation**: Handling identified risks

### Step: Execution Plan

Define concrete tasks structured by phase. Each task specifies which existing patterns/components to use.

**Deliverable**: `execution/EXECUTION.md`

**Common sections** (all modes):
1. **Execution Overview**: Summary of phases
2. **Phase Breakdown**: For each phase — objectives, tasks, success criteria
3. **Resource Allocation**: Task ownership
4. **Risk Monitoring**: Ongoing risk assessment

**Task format requirement**: Every task in the execution plan must follow the standard task structure (see Sprint Structure Standards below).

### Step: Sprint Plans (Optional)

**Before generating sprint documents, ASK the user:**

> "The analysis, planning, and execution plan are complete. Do you want me to generate the sprint tracking documents (PROGRESS.md and SPRINT-*.md files) now, or would you prefer to stop here and generate them later with `universal-planner-executor`?"

- If the user says **yes** → Generate `sprints/PROGRESS.md` + `sprints/SPRINT-{N}-{name}.md` following the Sprint Structure Standards below.
- If the user says **no** → Skip sprint generation and proceed directly to Handoff. The user can later use `universal-planner-executor` to generate sprints from the execution plan.

**Optional Retrospective:** At the end of each sprint plan document, include this note:

> After completing this sprint, you may generate a retrospective document. Ask the user: _"Sprint {N} is complete. Would you like to generate a retrospective (RETRO-{N}-{name}.md) to capture learnings and metrics?"_

If the user accepts, generate a retrospective following the template in `obsidian-md-standard` (Section 12), saved to `sprints/RETRO-{N}-{name}.md`. The retrospective must:
- Reference the completed sprint via wiki-link and `related` frontmatter
- Include K (Keep), P (Problems), L (Learnings), A (Actions) with IDs
- Include a metrics table comparing planned vs actual
- Be bidirectionally linked from PROGRESS.md (`retro_refs`) and the sprint document (`related`)

**Deliverables** (when generated): `sprints/PROGRESS.md` + `sprints/SPRINT-{N}-{name}.md`

See Sprint Structure Standards for format specifications.

### Step: Handoff

Summarize all produced documents and their locations. Indicate the plan is ready for execution. **This skill STOPS here.**

---

## Mode-Specific Workflows

Each mode has a dedicated workflow documented in [assets/modes/](assets/modes/):

- **[NEW_PROJECT](assets/modes/NEW_PROJECT.md)** — Full SDLC for greenfield projects (Requirements + Design + Analysis + Planning + Execution)
- **[NEW_FEATURE](assets/modes/NEW_FEATURE.md)** — Codebase-aware feature planning (Discovery + Analysis + Planning + Execution)
- **[REFACTOR](assets/modes/REFACTOR.md)** — Technical improvement planning (Discovery + Analysis + Planning + Execution)
- **[BUG_FIX](assets/modes/BUG_FIX.md)** — Bug investigation & fix planning (Discovery + Root Cause Analysis + Solution Design)
- **[TECH_DEBT](assets/modes/TECH_DEBT.md)** — Technical debt reduction (Discovery + Debt Inventory + Prioritization + Modernization)
- **[ARCHITECTURE](assets/modes/ARCHITECTURE.md)** — Architecture evolution (Discovery + Target Design + Gap Analysis + Migration Plan)

Each mode file includes:
- When to use the mode
- Output structure (which documents are generated)
- Mode-specific frontmatter fields
- Detailed workflow steps
- Recommended sprint structure
- Analysis focus areas
- Examples

**See the mode files for complete workflows, architecture guidance, and examples.**

---

## Requirements Specifications (NEW_PROJECT mode)

### problem-definition.md
| Section | Content |
|---------|---------|
| Problem Statement | 2-3 paragraphs describing the problem in concrete terms |
| Current Alternatives | How users solve this today and why those solutions fall short |
| Proposed Solution | High-level description of what the product will do |
| Value Proposition | Why this solution is better than alternatives |

### goals-and-metrics.md
| Section | Content |
|---------|---------|
| Primary Goals | 3-5 measurable goals using SMART criteria |
| Success Metrics | Specific KPIs with target values |
| Timeline Goals | MVP, v1.0, and long-term milestones |
| Business Impact | Expected outcomes for stakeholders |

### stakeholders-and-personas.md
| Section | Content |
|---------|---------|
| Stakeholders | Table: role, interest, influence level |
| User Personas | 2-4 detailed personas: name, role, goals, pain points, tech proficiency |
| User Journey Summary | High-level journey per persona |

### functional-requirements.md

Use MoSCoW prioritization: **Must Have**, **Should Have**, **Could Have**, **Won't Have (this release)**.

| Section | Content |
|---------|---------|
| Requirements Table | ID, description, priority, persona |
| Feature Groups | Organize requirements into logical groups |
| Acceptance Criteria | 2-3 criteria per Must-Have requirement |
| Dependencies | Requirements that depend on other requirements |

### non-functional-requirements.md
| Category | What to Specify |
|----------|----------------|
| Performance | Response times, throughput, concurrent users |
| Scalability | Growth projections, horizontal/vertical scaling needs |
| Security | Authentication, authorization, encryption, compliance |
| Reliability | Uptime targets, disaster recovery, data backup |
| Usability | Accessibility standards, supported devices/browsers |
| Maintainability | Code standards, documentation, monitoring |
| Compatibility | Integration requirements, API versioning |

### assumptions-and-constraints.md
| Section | Content |
|---------|---------|
| Technical Assumptions | Stack, infrastructure, third-party services assumed |
| Business Assumptions | Market, user behavior, budget assumptions |
| Constraints | Technical, legal, resource, and timeline constraints |
| Risks | Known risks with probability and mitigation |

This file is critical — it captures everything inferred from vague input.

### out-of-scope.md
| Section | Content |
|---------|---------|
| Excluded Features | Features explicitly not included in this phase |
| Future Considerations | Features deferred to later phases with reasoning |
| Boundary Definitions | What the system will and won't do |

---

## Design Specifications (NEW_PROJECT + ARCHITECTURE modes)

### system-overview.md
| Section | Content |
|---------|---------|
| System Context | Where this system sits in the larger ecosystem |
| Key Components | Major system components with one-line descriptions |
| Technology Recommendations | Suggested technologies with justification |
| System Boundaries | What the system controls vs delegates |

### architecture-decisions.md

Document each key decision using ADR format:

```markdown
### ADR-{N}: {Decision Title}

**Status:** Proposed
**Context:** {Why this decision is needed}
**Decision:** {What was decided}
**Alternatives Considered:**
- {Alternative 1}: {Why rejected}
- {Alternative 2}: {Why rejected}
**Consequences:** {Trade-offs and implications}
```

Include ADRs for: application architecture style, frontend framework (if applicable), database selection, authentication approach, API design style, hosting and deployment strategy.

### high-level-architecture.md
| Section | Content |
|---------|---------|
| Architecture Diagram | Mermaid diagram showing major components |
| Component Descriptions | Each component's responsibility, inputs, outputs |
| Communication Patterns | How components interact (sync, async, event-driven) |
| External Integrations | Third-party services and connections |

### data-model.md
| Section | Content |
|---------|---------|
| Entity Descriptions | Each entity with attributes and descriptions |
| Relationships | Entity relationships with cardinality |
| ER Diagram | Mermaid ER diagram |
| Data Flow | How data moves through the system |
| Storage Strategy | Where different data types are stored and why |

### core-flows.md

Document the 3-5 most critical flows using:

```markdown
### Flow: {Flow Name}

**Actor:** {Who initiates}
**Trigger:** {What starts this flow}
**Preconditions:** {What must be true}

**Steps:**
1. {Step description}
2. {Step description}

**Postconditions:** {What is true after completion}
**Error Scenarios:** {What can go wrong and how to handle it}
```

Include a Mermaid sequence diagram for each flow.

### non-functional-design.md
| Section | Content |
|---------|---------|
| Performance Design | Caching, CDN, query optimization, lazy loading |
| Security Design | Auth flow, encryption, input validation, CORS, rate limiting |
| Scalability Design | Load balancing, horizontal scaling, database sharding/replication |
| Monitoring & Observability | Logging, metrics, alerting, health checks |
| Error Handling | Global error strategy, retry policies, circuit breakers |
| Disaster Recovery | Backup strategy, failover, RTO/RPO targets |

---

## Sprint Structure Standards

All sprint documents across all modes MUST follow these standards.

### PROGRESS.md Format

```markdown
---
title: "Progress: {Project Name}"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "{project-name}"
type: "progress"
status: "active"
version: "1.0"
progress: 0
tags: ["{project-name}", "progress", "dashboard"]
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Initial progress dashboard"]
related:
  - "[[EXECUTION]]"
  - "[[PLANNING]]"
  - "[[SPRINT-1-{name}]]"
---

# Progress: {Project Name}

## Executive Summary
{One paragraph describing the project and current status}

## Sprint Overview

| Sprint | Name | Status | Objectives |
|--------|------|--------|------------|
| 1 | {Name} | NOT_STARTED / IN_PROGRESS / COMPLETED | {One-line objective} |
| 2 | {Name} | NOT_STARTED / IN_PROGRESS / COMPLETED | {One-line objective} |

## Global Metrics

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| {Metric 1} | {Goal} | {Current} | NOT_STARTED / IN_PROGRESS / COMPLETED |

## Blockers & Issues

| Issue | Impact | Resolution | Status |
|-------|--------|------------|--------|
| {Issue} | {What it blocks} | {Mitigation} | OPEN / RESOLVED |

## Document Index
- [[CONVENTIONS]] (if applicable)
- [[ANALYSIS]]
- [[PLANNING]]
- [[EXECUTION]]
- Sprint plans: [[SPRINT-1-{name}]], [[SPRINT-2-{name}]], ...

## Referencias

**Children:** [[SPRINT-1-{name}]], [[SPRINT-2-{name}]], ...
**Input Documents:** [[EXECUTION]], [[PLANNING]]
```

### SPRINT-{N}-{name}.md Format

```markdown
---
title: "Sprint {N}: {Sprint Name}"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "{project-name}"
type: "sprint-plan"
status: "draft"
version: "1.0"
sprint: {N}
phase: "{active-phases}"
progress: 0
previous_doc: "[[SPRINT-{N-1}-name]]"
next_doc: "[[SPRINT-{N+1}-name]]"
parent_doc: "[[PROGRESS]]"
tags: ["{project-name}", "sprint-{N}", "sprint-plan"]
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Initial sprint plan"]
related:
  - "[[PROGRESS]]"
  - "[[EXECUTION]]"
---

# Sprint {N}: {Sprint Name}

**Duration:** {X-Y days}
**Objective:** {Clear one-line objective}
**Status:** NOT_STARTED | IN_PROGRESS | COMPLETED
**Dependencies:** {Prerequisites from other sprints}

<!-- For Sprint 2+, include this section: -->
## Carried Forward from [[SPRINT-{N-1}-name]]

- [ ] {Incomplete tasks from previous sprint with original T- IDs}

**Decisions inherited:**
- {Decisions from previous sprint that affect this one}

---

## Phase {N}.1: {Phase Name}

**Objective:** {What this phase achieves}

### Prerequisites
- [ ] {Required items before starting}

### Tasks

#### Task {N}.1.1: {Task Description}
**File(s):** `{paths}`
**Convention:** {Which existing pattern/component to use, if applicable}

**Changes:**
```{language}
// BEFORE
{existing code}

// AFTER
{proposed code}
```

**Steps:**
- [ ] {N}.1.1.1 — {Specific action}
- [ ] {N}.1.1.2 — {Specific action}

**Verification:**
```bash
{command to verify task completion}
# Expected: {what should happen}
```

---

## Phase {N}.2: Final Verification

### Code Verifications
- [ ] {Verification 1}: `{command}` — Expected: {result}
- [ ] {Verification 2}: `{command}` — Expected: {result}

### Functional Verifications
- [ ] Build succeeds
- [ ] Tests pass
- [ ] Manual smoke test passes

---

## Definition of Done

Sprint {N} is completed when:
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion N}

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk 1} | High/Medium/Low | {Impact} | {Strategy} |

## Rollback Strategy
{How to revert changes from this sprint if something goes wrong}

## Notes
{Space for implementation notes during execution}

## Graduation Gate

Sprint {N} is approved for completion when ALL criteria are met:

- [ ] All tasks marked complete with passing verification
- [ ] No open P0/P1 blockers
- [ ] Code reviewed and approved
- [ ] Tests passing
- [ ] PROGRESS.md updated with final metrics

## Metrics

| Metric | Target | Current | Delta | Status |
|--------|--------|---------|-------|--------|
| Tasks completed | {total} | 0 | -{total} | NOT_STARTED |
| {Custom metric} | {target} | {current} | {delta} | {status} |

## Referencias

**Parent:** [[PROGRESS]]
**Siblings:** [[SPRINT-{N-1}-name]], [[SPRINT-{N+1}-name]]
**Input Documents:** [[EXECUTION]], [[PLANNING]]
```

### Task Granularity

| Level | Name | Scope | Example |
|-------|------|-------|---------|
| L1 | Sprint | Major milestone (3-7 days) | "Sprint 1: Foundation Setup" |
| L2 | Phase | Logical grouping (0.5-2 days) | "Phase 1.1: Database Schema" |
| L3 | Task | Discrete work item (1-4 hours) | "Task 1.1.1: Create users table" |
| L4 | Subtask | Single action (5-30 min) | "1.1.1.1: Define column types" |

Every task must:
- Have a checkboxed action
- Include file paths when applicable
- Show before/after code snippets for changes
- Include a verification command
- Reference which existing patterns/components to use (when applicable)

---

## Critical Patterns

### Pattern 1: Planning Only — Never Execute

This skill MUST NOT begin implementing, coding, or deploying any planned task. Its output is strictly documentation. Once all documents are created, the skill's work is done.

**Bad**: Creating the plan and then starting to implement Phase 1 tasks
**Good**: Creating all documents, summarizing what was produced, then stopping

### Pattern 2: Respect Existing Patterns — Never Reinvent

Every planning decision on an existing codebase must align with established conventions. Before proposing any component, pattern, or approach, check what already exists.

**Bad**: "Create a new `<button>` element with custom CSS"
**Good**: "Use existing `Button` component from `src/components/ui/Button.tsx` with variant='primary'"

**Bad**: "Set up Redux for state management"
**Good**: "Use existing Zustand store pattern in `src/stores/` as the project already uses Zustand"

### Pattern 3: Justify Every Deviation

When something genuinely new IS needed, the plan must document:
1. **What exists today** and why it doesn't solve the problem
2. **What is proposed** as the new approach
3. **Why the deviation is justified** — concrete technical reasoning
4. **How it aligns** with the project's broader architecture

This goes in the **Conventions Alignment** section of PLANNING.md.

### Pattern 4: Adaptive Depth

Match documentation depth to project scale. A personal CLI tool doesn't need 4 user personas and 7 ADRs. A multi-tenant SaaS platform does. Infer scale from the user's input and adjust.

### Pattern 5: Specific Over Generic

Quantify everything. Measurable statements are testable; vague ones are not.

**Bad**: "The system must be scalable"
**Good**: "The system must handle 1,000 concurrent WebSocket connections with <100ms latency"

**Bad**: "Implement the feature"
**Good**: "Create API endpoint POST /api/v1/registrations with validation for email, password, and name"

### Pattern 6: Diagrams Over Prose

Use Mermaid diagrams for architecture, data models, and flows. Visual representations are faster to understand and less ambiguous than paragraph descriptions.

### Pattern 7: ADR Discipline

Document every significant architectural decision with context, alternatives considered, and consequences. Future team members need to understand the reasoning behind decisions.

### Pattern 8: Cross-Reference Consistency and Bidirectionality

All inter-document references use `[[wiki-links]]`. Every reference must be bidirectional.

**Do:** Use `[[CONVENTIONS]]`, `[[ANALYSIS]]`, `[[SPRINT-1-foundation]]` for inter-document refs. Ensure that if document A contains `[[B]]`, document B contains `[[A]]` in its `related` frontmatter field and `## Referencias` section.

**Don't:** Use `[text](relative-path.md)` for inter-document links. Never create one-directional references.

**Verification:** After generating all documents, check every `[[X]]` reference in each document and verify the target document references back.

### Pattern 9: Phase Dependencies

Always declare phase and sprint dependencies explicitly:

```markdown
### Phase 2: API Integration
**Dependencies**: Phase 1 (Foundation Setup) must be complete
**Blocks**: Phase 3 (Frontend Implementation)
```

### Pattern 10: Task-to-Phase Mapping

Every task in a sprint must map back to an execution phase. No orphan tasks.

---

## Configuration

### Project Scale

| Scale | Sprint Count | Phase Count | Detail Level |
|-------|:----------:|:---------:|------------|
| Small (1-2 weeks) | 1-2 | 2-3 | Concise, fewer personas/ADRs |
| Medium (1 month) | 3-4 | 3-5 | Standard depth |
| Large (2+ months) | 5-8+ | 4-6+ | Comprehensive, detailed design |

### Sprint Duration
- **Weekly**: Standard for most projects (recommended)
- **Bi-weekly**: For slower-moving or larger projects
- Align sprints with execution phases — each sprint should focus on completing 1-2 phases

---

## Integration with Other Skills

| Skill | Integration |
|-------|------------|
| `code-analyzer` | Use before REFACTOR or TECH_DEBT mode to get a detailed technical report as input |
| `skill-creator` | Reference when building skills that complement planning outputs |
| Execution skills | Hand off all planning documents for implementation |

---

## Troubleshooting

### "Analysis is never-ending"
Set a hard scope boundary. Document unknowns as risks, not blockers. Move to planning with incomplete analysis if needed — the plan can account for investigation tasks.

### "Plan proposes patterns that conflict with existing codebase"
Codebase Discovery was skipped or incomplete. Go back and create/update CONVENTIONS.md. Review every proposal against documented conventions.

### "Not sure which mode to use"
Ask the user. If the work involves both a new feature and refactoring, use NEW_FEATURE mode and include refactoring as a phase within the execution plan.

### "Input is too vague"
Make broader assumptions and document them prominently in ANALYSIS.md. For NEW_PROJECT mode, document in `assumptions-and-constraints.md`. Still generate all required files.

### "Sprint todos get out of sync with execution phases"
Create sprint plans AFTER finalizing the execution plan. Map each sprint task to a specific execution phase. Review alignment before handoff.

### "Tasks don't fit into a single phase"
Cross-cutting concerns (testing, documentation, monitoring) should be tracked as support tasks within the sprint where they're most relevant, or as a dedicated verification phase at the end of each sprint.

---

## Limitations

1. **Planning only**: Produces documentation, never executes
2. **Requires input**: Cannot plan without a description of the work (however vague)
3. **Assumptions must be validated**: Inferred decisions need team review before implementation
4. **Technology recommendations are suggestions**: The development team makes final choices
5. **Manual tracking**: Sprint progress must be updated manually during execution
6. **No automated validation**: Cannot verify that plans match codebase reality — relies on thorough discovery

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-04 | Initial release — unified from project-planner v1.2, sdlc-planner v1.0, and universal prompt templates |
| 2.0 | 2026-02-11 | Obsidian-native output — frontmatter, wiki-links, bidirectional references, graduation gates, metric tables, carried forward, optional retrospectives |
