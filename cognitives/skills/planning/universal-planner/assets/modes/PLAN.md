# PLAN Mode

## Purpose

Produce professional, structured planning documentation for any software engineering scenario. PLAN mode detects the scenario from user input and activates the appropriate sub-mode workflow.

**This mode produces documentation only. It MUST NOT implement, code, build, deploy, or carry out any task.**

---

## Mode-Specific Rules

> **RULE P1 — PLANNING ONLY: NEVER EXECUTE**
>
> PLAN mode produces **documentation only**. It MUST NOT implement, code, build, deploy, or carry out any task defined in the plan. Once all planning documents are complete, summarize what was produced and stop.

> **RULE P2 — CONTEXT-FIRST: RESPECT EXISTING PATTERNS**
>
> Before making **any** planning decision on an existing codebase, explore and understand the project's established patterns, conventions, and architecture. Every proposal MUST align with what already exists. When something genuinely new is needed, the deviation must be explicitly documented and justified.
>
> **This rule does not apply to NEW_PROJECT sub-mode** (there is no existing codebase to discover).

> **RULE P3 — ADAPTIVE SUB-MODE DETECTION**
>
> Detect the planning sub-mode from the user's input (see Sub-Mode Detection below). If the mode is ambiguous, ask the user. Never force a mode that doesn't match the scenario.

> **RULE P4 — COMPLETENESS**
>
> Generate ALL documents required by the active sub-mode. No file should be skipped or left empty. Each file must contain substantive, meaningful content specific to the project.

---

## Sub-Mode Detection

Detect the sub-mode from the user's input using these signals:

| Sub-Mode | Signals | Example Inputs |
|----------|---------|----------------|
| **NEW_PROJECT** | Product idea, app concept, "build from scratch", no existing codebase | "I need an app to track expenses", "Build a SaaS for team scheduling" |
| **NEW_FEATURE** | Adding functionality to existing project, "add", "implement", "create" within existing codebase | "Add dark mode to the app", "Implement payment integration" |
| **REFACTOR** | Restructure, reorganize, migrate patterns, improve architecture of existing code | "Refactor the auth module", "Migrate from Redux to Zustand" |
| **BUG_FIX** | Fix, issue, broken, regression, error, not working | "Fix the login timeout bug", "Users can't submit forms on mobile" |
| **TECH_DEBT** | Cleanup, dead code, outdated, deprecated, missing tests, duplication | "Clean up the orders module", "Reduce tech debt in the API layer" |
| **ARCHITECTURE** | System design, architecture evolution, scaling, infrastructure change | "Design the microservices migration", "Plan the monorepo restructure" |

## Sub-Mode Capabilities Matrix

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

All output goes into `{output_dir}/planning/{project-name}/`.

```
{output_dir}/planning/{project-name}/
├── README.md                              # Project overview and document navigation
│
├── discovery/                              # Codebase Discovery (all sub-modes except NEW_PROJECT)
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
├── analysis/                               # Analysis (all sub-modes — content adapts per mode)
│   └── ANALYSIS.md
│
├── planning/                               # Strategy (all sub-modes)
│   └── PLANNING.md
│
├── execution/                              # Concrete task breakdown (all sub-modes)
│   └── EXECUTION.md
│
└── sprints/                                # Sprint tracking (all sub-modes)
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

## Workflow

### Step 1: Codebase Discovery (all sub-modes except NEW_PROJECT)

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

Use the [CONVENTIONS template](../templates/CONVENTIONS.md) for the output format.

> **IMPORTANT**: Every subsequent document MUST reference CONVENTIONS.md. If a planning decision conflicts with an established convention, it must be explicitly called out and justified.

### Step 2: Analysis

Investigate and document what you need to build or change. Content adapts per sub-mode (see Sub-Mode Workflows below).

**Deliverable**: `analysis/ANALYSIS.md` — use the [ANALYSIS template](../templates/ANALYSIS.md)

**Common sections** (all sub-modes):
1. **Executive Summary**: What are we doing and why?
2. **Current State Assessment**: What exists today?
3. **Conventions Reference** (if applicable): Which existing patterns are relevant
4. **Technical Analysis**: Technologies, tools, architectural implications
5. **Constraints & Risks**: Limitations, risks with probability and mitigation
6. **Success Criteria**: How we measure done

### Step 3: Planning

Define the implementation strategy based on analysis findings. All proposals must align with CONVENTIONS.md (when applicable).

**Deliverable**: `planning/PLANNING.md` — use the [PLANNING template](../templates/PLANNING.md)

**Common sections** (all sub-modes):
1. **Implementation Strategy**: High-level approach — how it fits within existing architecture
2. **Conventions Alignment** (if applicable): Patterns to reuse, justified deviations
3. **Execution Phases**: Major milestones with name, description, objectives, deliverables, dependencies
4. **Resource Plan**: Who/what is needed
5. **Risk Mitigation**: Handling identified risks

### Step 4: Execution Plan

Define concrete tasks structured by phase. Each task specifies which existing patterns/components to use.

**Deliverable**: `execution/EXECUTION.md` — use the [EXECUTION template](../templates/EXECUTION.md)

**Common sections** (all sub-modes):
1. **Execution Overview**: Summary of phases
2. **Phase Breakdown**: For each phase — objectives, tasks, success criteria
3. **Resource Allocation**: Task ownership
4. **Risk Monitoring**: Ongoing risk assessment

**Task format requirement**: Every task must follow the standard task structure (see Sprint Structure Standards in SKILL.md).

### Step 5: Sprint Plans

**5a. Generate PROGRESS.md (always required):**

Generate `sprints/PROGRESS.md` using the [PROGRESS template](../templates/PROGRESS.md) with sprint overview and initial metrics. This file is **always** generated — it is required by the output schema and by EXECUTE mode.

**5b. Generate Sprint Files (ask user):**

> "The progress dashboard is ready. Do you want me to generate detailed sprint plan files (SPRINT-*.md) now, or would you prefer to generate them later?"

- If the user says **yes** → Generate `sprints/SPRINT-{N}-{name}.md` files using the [SPRINT template](../templates/SPRINT.md).
- If the user says **no** → Skip sprint file generation and proceed directly to Handoff.

**Optional Retrospective:** At the end of each sprint plan document, include this note:

> After completing this sprint, you may generate a retrospective document. Ask the user: _"Sprint {N} is complete. Would you like to generate a retrospective?"_

If the user accepts, generate a retrospective following the [RETRO template](../templates/RETRO.md).

### Step 6: Handoff

Summarize all produced documents and their locations. Indicate the plan is ready for implementation via EXECUTE mode. **PLAN mode STOPS here.**

**Handoff contract for EXECUTE mode:**
- All documents listed in the Sub-Mode Capabilities Matrix are generated
- The output directory follows the Output Structure above
- All inter-document references are bidirectional
- Every task in EXECUTION.md has file paths, verification commands, and convention references
- Sprint files (when generated) follow the Sprint Structure Standards

---

## Sub-Mode Workflows

Each sub-mode has a dedicated workflow documented in this directory:

- **[NEW_PROJECT](NEW_PROJECT.md)** — Full SDLC for greenfield projects (Requirements + Design + Analysis + Planning + Execution)
- **[NEW_FEATURE](NEW_FEATURE.md)** — Codebase-aware feature planning (Discovery + Analysis + Planning + Execution)
- **[REFACTOR](REFACTOR.md)** — Technical improvement planning (Discovery + Analysis + Planning + Execution)
- **[BUG_FIX](BUG_FIX.md)** — Bug investigation & fix planning (Discovery + Root Cause Analysis + Solution Design)
- **[TECH_DEBT](TECH_DEBT.md)** — Technical debt reduction (Discovery + Debt Inventory + Prioritization + Modernization)
- **[ARCHITECTURE](ARCHITECTURE.md)** — Architecture evolution (Discovery + Target Design + Gap Analysis + Migration Plan)

Each sub-mode file includes when to use the mode, output structure, frontmatter additions, workflow adjustments, and examples.

### Disambiguation: REFACTOR vs TECH_DEBT

When signals overlap between REFACTOR and TECH_DEBT, use this heuristic:

**Use REFACTOR when:**
- The primary goal is to CHANGE how code is structured or organized
- You're migrating from one pattern/library to another
- The architecture or module boundaries are being redesigned
- The end result has a different structure than the start

**Use TECH_DEBT when:**
- The primary goal is to CLEAN UP without changing structure
- You're removing dead code, updating deprecated deps, adding missing tests
- The architecture stays the same, only the quality improves
- The end result has the same structure but is cleaner

**Combined work?** Use REFACTOR and include cleanup as a phase within the execution plan.

> **ARCHITECTURE Exception:** For ARCHITECTURE sub-mode, Step 2 is **System Design** (generate 6 design files in `design/`), followed by Step 3 as **Gap Analysis** (comparing current vs target). See [ARCHITECTURE.md](ARCHITECTURE.md) for the modified workflow.

---

## Output Templates

All documents follow standardized templates:

- **[ANALYSIS.md](../templates/ANALYSIS.md)** — Strategic analysis with mode-specific sections
- **[PLANNING.md](../templates/PLANNING.md)** — Work plan with strategy and timeline
- **[CONVENTIONS.md](../templates/CONVENTIONS.md)** — Codebase conventions (for existing projects)
- **[EXECUTION.md](../templates/EXECUTION.md)** — Task breakdown with verification commands
- **[SPRINT.md](../templates/SPRINT.md)** — Sprint plan with daily progress tracking
- **[PROGRESS.md](../templates/PROGRESS.md)** — Progress dashboard with sprint overview and metrics
- **[RETRO.md](../templates/RETRO.md)** — Sprint retrospective with Keep/Problems/Learnings/Actions

---

## Requirements & Design Specifications (NEW_PROJECT sub-mode)

NEW_PROJECT sub-mode generates **7 requirements files** and **6 design files**.

See [NEW_PROJECT.md](NEW_PROJECT.md) for complete specifications.

**Quick reference:**
- **Requirements:** problem-definition, goals-and-metrics, stakeholders-and-personas, functional-requirements (MoSCoW), non-functional-requirements, assumptions-and-constraints, out-of-scope
- **Design:** system-overview, architecture-decisions (ADRs), high-level-architecture, data-model (ER diagrams), core-flows (sequence diagrams), non-functional-design

See also [ARCHITECTURE.md](ARCHITECTURE.md) for design specifications in architecture mode.

---

## Critical Patterns

### Pattern 1: Planning Only — Never Execute

This mode MUST NOT begin implementing, coding, or deploying any planned task. Its output is strictly documentation.

**Bad**: Creating the plan and then starting to implement Phase 1 tasks
**Good**: Creating all documents, summarizing what was produced, then stopping

### Pattern 2: Respect Existing Patterns — Never Reinvent

Every planning decision on an existing codebase must align with established conventions.

**Bad**: "Create a new `<button>` element with custom CSS"
**Good**: "Use existing `Button` component from `src/components/ui/Button.tsx` with variant='primary'"

**Bad**: "Set up Redux for state management"
**Good**: "Use existing Zustand store pattern in `src/stores/` as the project already uses Zustand"

### Pattern 3: Justify Every Deviation

When something genuinely new IS needed, document:
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

**Do:** Use `[[CONVENTIONS]]`, `[[ANALYSIS]]`, `[[SPRINT-1-foundation]]`. Ensure that if document A contains `[[B]]`, document B contains `[[A]]` in its `related` frontmatter and `## Referencias`.

**Don't:** Use `[text](relative-path.md)` for inter-document links. Never create one-directional references.

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
