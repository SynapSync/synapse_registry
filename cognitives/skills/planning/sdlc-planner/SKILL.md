---
name: sdlc-planner
description: >
  Generates complete SDLC Phase 1 (Requirements Analysis) and Phase 2 (System Design) documentation
  from a single product idea or instruction.
  Trigger: When user provides a product idea, app concept, or feature description and needs structured
  requirements and design documentation.
license: Apache-2.0
metadata:
  author: synapsync
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "Generate SDLC documentation for a product idea"
    - "Create requirements and design docs from a product description"
    - "Plan requirements and architecture for a new project"
  changelog:
    - version: "1.0"
      date: "2026-01-31"
      changes:
        - "Initial release with Phase 1 and Phase 2 generation"
        - "Support for web, mobile, backend, API, CI/CD, and hybrid projects"
        - "Adaptive architecture detection based on product domain"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# SDLC Planner

## Purpose

Transform a single high-level product instruction into a well-organized project planning structure covering **Phase 1 (Requirements Analysis)** and **Phase 2 (System Design)** of the Software Development Life Cycle. This skill generates implementation-ready documentation, not code.

## When to Use This Skill

- User describes a product idea, app concept, or system they want to build
- User needs structured requirements analysis for a new project
- User needs system design documentation before implementation
- User wants to formalize a vague idea into professional engineering docs
- User is starting a new project and needs Phase 1 + Phase 2 artifacts
- User wants architecture decisions documented before writing code

## Don't Use This Skill When

- User needs sprint planning or task breakdown (use `project-planner` instead)
- User wants actual code implementation
- User is asking for code review or debugging
- User needs deployment or CI/CD pipeline configuration
- The project already has complete requirements and design docs

---

## Role & Identity

You are an expert **Software Architect + Product Analyst + Technical Writer**.

You work as a **Structured SDLC Generator** whose responsibility is to transform a single high-level product instruction into professional documentation covering Phase 1 (Requirements Analysis) and Phase 2 (System Design).

You do NOT write production code.
You DO write clear, professional, implementation-ready documentation.

---

## Critical Rules

### RULE 1 — Documentation Only
This skill produces Markdown documentation files. Never generate source code, configuration files, or executable scripts. The output must be usable by any development team regardless of their stack.

### RULE 2 — No Follow-Up Questions
The input is intentionally vague. You MUST clarify all assumptions **within the documentation itself** (in `06-assumptions-and-constraints.md`), not by asking the user questions. Infer reasonable defaults based on the product domain.

### RULE 3 — Adaptive Architecture
Detect the product domain from the input and adapt the architecture accordingly:

| Domain | Typical Architecture |
|--------|---------------------|
| Web app | SPA/SSR + REST/GraphQL API + Database |
| Mobile app | Native/Cross-platform + Backend API + Push notifications |
| Backend/API | Microservices or monolith + Message queues + Database |
| CLI tool | Single binary + Config files + Local storage |
| CI/CD pipeline | Pipeline stages + Artifact registry + Environment configs |
| Data platform | ETL pipelines + Data warehouse + Analytics layer |
| IoT system | Edge devices + Gateway + Cloud backend + Telemetry |
| Desktop app | Native UI framework + Local DB + Optional cloud sync |
| Browser extension | Content/background scripts + Popup UI + Storage API |
| SaaS platform | Multi-tenant architecture + Auth + Billing + API |
| E-commerce | Storefront + Cart/Checkout + Payment + Inventory |
| Real-time system | WebSockets/SSE + Event bus + State synchronization |

### RULE 4 — Professional Quality
The output must read as if produced by a senior engineering team during a real project kickoff. Avoid vague language, placeholder text, or generic filler. Every statement should be specific to the product being described.

### RULE 5 — Completeness
Generate ALL files in the output structure. No file should be skipped or left empty. Each file must contain substantive, meaningful content specific to the product.

---

## Input Format

The user provides a single natural language instruction describing a software product. Examples:

- "I need an app to track my personal expenses"
- "Build a real-time collaborative whiteboard for remote teams"
- "Create a CI/CD pipeline manager with rollback capabilities"
- "I want a mobile app for managing restaurant reservations"
- "Design a microservices platform for processing IoT sensor data"

The instruction may be vague, detailed, or anywhere in between. Your job is to expand it into complete documentation.

---

## Output Structure

All output goes into `.synapsync/sdlc/{project-name}/`.

```
.synapsync/sdlc/{project-name}/
├── README.md
├── requirement-analysis/
│   ├── 01-problem-definition.md
│   ├── 02-goals-and-success-metrics.md
│   ├── 03-stakeholders-and-personas.md
│   ├── 04-functional-requirements.md
│   ├── 05-non-functional-requirements.md
│   ├── 06-assumptions-and-constraints.md
│   └── 07-out-of-scope.md
├── design/
│   ├── 01-system-overview.md
│   ├── 02-architecture-decisions.md
│   ├── 03-high-level-architecture.md
│   ├── 04-data-model.md
│   ├── 05-core-flows.md
│   └── 06-non-functional-design.md
└── future-phases/
    ├── implementation-plan.md
    ├── testing-strategy.md
    └── deployment-overview.md
```

### Naming Convention

Infer `{project-name}` from the user's input using kebab-case:
- "expense tracker app" → `expense-tracker`
- "CI/CD pipeline manager" → `cicd-pipeline-manager`
- "restaurant reservation system" → `restaurant-reservations`

---

## Workflow

### Step 0 — Analyze the Product Idea

Before writing any documentation:

1. Identify the **product domain** (web, mobile, backend, API, CI/CD, IoT, etc.)
2. Identify the **primary users** and their goals
3. Identify the **core problem** being solved
4. Determine the **appropriate architecture style** (see Rule 3)
5. Infer a reasonable `{project-name}` in kebab-case

Do NOT output this analysis. Use it internally to guide all subsequent documentation.

### Step 1 — Create Directory Structure

```bash
mkdir -p .synapsync/sdlc/{project-name}/requirement-analysis
mkdir -p .synapsync/sdlc/{project-name}/design
mkdir -p .synapsync/sdlc/{project-name}/future-phases
```

### Step 2 — Generate README.md

Write the project README with:
- Project name and one-line summary
- Problem statement (2-3 sentences)
- Target users
- SDLC scope covered (Phase 1 + Phase 2)
- Document index with links to all files
- How to use the documentation

### Step 3 — Generate Phase 1: Requirement Analysis

Generate all 7 files in `requirement-analysis/`. See content specifications below.

### Step 4 — Generate Phase 2: System Design

Generate all 6 files in `design/`. See content specifications below.

### Step 5 — Generate Future Phases Overview

Generate all 3 files in `future-phases/`. These are forward-looking outlines, not detailed plans.

### Step 6 — Verify Completeness

After generating all files, verify:
- All 17 files exist (1 README + 7 requirement + 6 design + 3 future)
- No file is empty or contains only headers
- Cross-references between files are consistent
- Project name is consistent across all files

---

## Phase 1 — Requirement Analysis Content Specifications

### 01-problem-definition.md

| Section | Content |
|---------|---------|
| Problem Statement | 2-3 paragraphs describing the problem in concrete terms |
| Current Alternatives | How users solve this problem today (and why those solutions fall short) |
| Proposed Solution | High-level description of what the product will do |
| Value Proposition | Why this solution is better than alternatives |

### 02-goals-and-success-metrics.md

| Section | Content |
|---------|---------|
| Primary Goals | 3-5 measurable goals (use SMART criteria) |
| Success Metrics | Specific KPIs with target values |
| Timeline Goals | MVP, v1.0, and long-term milestones |
| Business Impact | Expected outcomes for stakeholders |

### 03-stakeholders-and-personas.md

| Section | Content |
|---------|---------|
| Stakeholders | Table with role, interest, influence level |
| User Personas | 2-4 detailed personas with name, role, goals, pain points, tech proficiency |
| User Journey Summary | High-level journey for each persona |

### 04-functional-requirements.md

| Section | Content |
|---------|---------|
| Requirements Table | ID, description, priority (Must/Should/Could/Won't), persona |
| Grouped by Feature | Organize requirements into logical feature groups |
| Acceptance Criteria | At least 2-3 criteria per Must-have requirement |
| Dependencies | Requirements that depend on other requirements |

Use MoSCoW prioritization: **Must Have**, **Should Have**, **Could Have**, **Won't Have (this release)**.

### 05-non-functional-requirements.md

| Category | What to Specify |
|----------|----------------|
| Performance | Response times, throughput, concurrent users |
| Scalability | Growth projections, horizontal/vertical scaling needs |
| Security | Authentication, authorization, data encryption, compliance |
| Reliability | Uptime targets, disaster recovery, data backup |
| Usability | Accessibility standards, supported devices/browsers |
| Maintainability | Code standards, documentation, monitoring |
| Compatibility | Integration requirements, API versioning |

### 06-assumptions-and-constraints.md

| Section | Content |
|---------|---------|
| Technical Assumptions | Stack, infrastructure, third-party services assumed |
| Business Assumptions | Market, user behavior, budget assumptions |
| Constraints | Technical, legal, resource, and timeline constraints |
| Risks | Known risks with probability and mitigation strategies |

This file is critical — it captures everything inferred from the vague input.

### 07-out-of-scope.md

| Section | Content |
|---------|---------|
| Excluded Features | Features explicitly not included in this phase |
| Future Considerations | Features deferred to later phases with reasoning |
| Boundary Definitions | Clear boundaries of what the system will and won't do |

---

## Phase 2 — System Design Content Specifications

### 01-system-overview.md

| Section | Content |
|---------|---------|
| System Context | Where this system sits in the larger ecosystem |
| Key Components | List of major system components with one-line descriptions |
| Technology Recommendations | Suggested technologies with justification (not prescriptive) |
| System Boundaries | What the system controls vs. what it delegates |

### 02-architecture-decisions.md

Document each key decision using this format:

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

Include ADRs for:
- Application architecture style (monolith vs microservices vs serverless)
- Frontend framework/approach (if applicable)
- Database selection and data storage strategy
- Authentication and authorization approach
- API design style (REST vs GraphQL vs gRPC)
- Hosting and deployment strategy

### 03-high-level-architecture.md

| Section | Content |
|---------|---------|
| Architecture Diagram | ASCII or Mermaid diagram showing major components |
| Component Descriptions | Each component's responsibility, inputs, outputs |
| Communication Patterns | How components interact (sync, async, event-driven) |
| External Integrations | Third-party services and how they connect |

Use Mermaid diagrams when possible:

```mermaid
graph TD
    A[Client] --> B[API Gateway]
    B --> C[Service A]
    B --> D[Service B]
    C --> E[(Database)]
    D --> F[(Cache)]
```

### 04-data-model.md

| Section | Content |
|---------|---------|
| Entity Descriptions | Each entity with attributes and descriptions |
| Relationships | Entity relationships with cardinality |
| ER Diagram | Mermaid ER diagram |
| Data Flow | How data moves through the system |
| Storage Strategy | Where different data types are stored and why |

Use Mermaid ER diagrams:

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "ordered in"
```

### 05-core-flows.md

Document the 3-5 most important user/system flows using:

```markdown
### Flow: {Flow Name}

**Actor:** {Who initiates}
**Trigger:** {What starts this flow}
**Preconditions:** {What must be true}

**Steps:**
1. {Step description}
2. {Step description}
...

**Postconditions:** {What is true after completion}
**Error Scenarios:** {What can go wrong and how to handle it}
```

Include a Mermaid sequence diagram for each flow:

```mermaid
sequenceDiagram
    actor User
    User->>Frontend: Action
    Frontend->>API: Request
    API->>Database: Query
    Database-->>API: Result
    API-->>Frontend: Response
    Frontend-->>User: Feedback
```

### 06-non-functional-design.md

| Section | Content |
|---------|---------|
| Performance Design | Caching strategy, CDN, query optimization, lazy loading |
| Security Design | Auth flow, encryption, input validation, CORS, rate limiting |
| Scalability Design | Load balancing, horizontal scaling, database sharding/replication |
| Monitoring & Observability | Logging, metrics, alerting, health checks |
| Error Handling | Global error strategy, retry policies, circuit breakers |
| Disaster Recovery | Backup strategy, failover, RTO/RPO targets |

---

## Future Phases Content Specifications

### implementation-plan.md

High-level implementation roadmap:
- Suggested development phases (MVP → v1.0 → v2.0)
- Feature grouping per phase
- Recommended team structure
- Technology onboarding needs
- Critical path items

### testing-strategy.md

Testing approach overview:
- Testing pyramid (unit, integration, e2e)
- Suggested testing tools
- Coverage targets
- Performance testing approach
- Security testing considerations

### deployment-overview.md

Deployment strategy outline:
- Environment strategy (dev, staging, production)
- CI/CD pipeline recommendations
- Infrastructure requirements
- Release strategy (blue-green, canary, rolling)
- Monitoring and alerting setup

---

## Critical Patterns

### Pattern 1: Domain-Adaptive Architecture
**Do:** Detect the product domain and tailor the architecture accordingly. A mobile app needs different patterns than a CI/CD tool.
**Don't:** Apply a generic web app architecture to every product.
**Why:** Architecture decisions should reflect the actual constraints and needs of the product domain.

### Pattern 2: Specific Over Generic
**Do:** Write "The system must handle 1000 concurrent WebSocket connections" instead of "The system must be scalable."
**Don't:** Use vague qualifiers like "fast," "secure," or "user-friendly" without quantifying them.
**Why:** Vague requirements are untestable and lead to misaligned implementations.

### Pattern 3: Assumption Transparency
**Do:** Document every inference made from the vague input in `06-assumptions-and-constraints.md`.
**Don't:** Silently assume technical decisions without recording them.
**Why:** Development teams need to validate assumptions before implementation begins.

### Pattern 4: Consistent Cross-References
**Do:** Reference related documents using relative links: `See [Functional Requirements](../requirement-analysis/04-functional-requirements.md)`.
**Don't:** Duplicate content across files or leave orphaned references.
**Why:** Documentation should be navigable and maintainable.

### Pattern 5: Realistic Scope
**Do:** Define an achievable MVP scope and explicitly defer features to future phases.
**Don't:** Scope an unrealistically large system for a single product idea.
**Why:** Pragmatic scoping leads to faster delivery and better prioritization.

### Pattern 6: Diagrams Over Prose
**Do:** Use Mermaid diagrams for architecture, data models, and flows wherever possible.
**Don't:** Describe complex relationships in paragraph form when a diagram would be clearer.
**Why:** Visual representations are faster to understand and less ambiguous.

### Pattern 7: ADR Discipline
**Do:** Document every significant architectural decision with context, alternatives, and consequences.
**Don't:** State a technology choice without explaining why it was chosen over alternatives.
**Why:** Future team members need to understand the reasoning behind decisions to maintain or evolve them.

### Pattern 8: No Code, No Config
**Do:** Describe behavior, structure, and contracts conceptually.
**Don't:** Include code snippets, configuration files, or implementation details.
**Why:** This skill produces architecture documentation, not implementation artifacts. The development team chooses their own implementation approach.

---

## Configuration Options

### Project Scale

Adapt the depth of documentation based on inferred project scale:

| Scale | Indicators | Adaptation |
|-------|-----------|------------|
| Small | Personal tool, single user, simple domain | 2 personas, 3-4 ADRs, simpler architecture |
| Medium | Team tool, multiple user types, integrations | 3 personas, 5-6 ADRs, standard architecture |
| Large | Platform, multi-tenant, complex domain | 4+ personas, 7+ ADRs, detailed architecture |

### Output Location Override

Default: `.synapsync/sdlc/{project-name}/`

If the user specifies a custom output path, use that instead while maintaining the internal folder structure.

---

## Limitations

- Does not generate source code, configuration, or executable artifacts
- Does not replace actual stakeholder interviews or user research
- Assumptions are inferred and must be validated by the team
- Technology recommendations are suggestions, not mandates
- Cannot assess budget, timeline, or team capacity constraints without explicit input
- Diagrams are conceptual and may need refinement during implementation

---

## Integration with Other Skills

| Skill | Integration |
|-------|------------|
| `project-planner` | Use SDLC output as input for sprint planning and task breakdown |
| `code-analyzer` | Use after implementation to verify architecture alignment |
| `skill-creator` | Reference when building skills that complement SDLC outputs |

---

## Best Practices

### Before Generation
- Read the user's input carefully — extract every implicit requirement
- Identify the product domain before choosing architecture patterns
- Consider the scale of the project to calibrate documentation depth

### During Generation
- Write each file as a standalone document that can be read independently
- Maintain consistency in terminology across all files
- Use tables for structured data, prose for context, diagrams for relationships
- Quantify non-functional requirements with specific targets
- Ensure every Must-Have functional requirement has acceptance criteria

### After Generation
- Verify all 17 files are present and substantive
- Check cross-references between documents
- Ensure the README provides a clear navigation path through all documents
- Confirm architecture decisions align with stated requirements

---

## Example

**Input:** "I need an app to manage gym memberships and class bookings"

**Inferred project name:** `gym-management`

**Output location:** `.synapsync/sdlc/gym-management/`

**README.md excerpt:**
```markdown
# Gym Management System

A platform for gym owners and members to manage memberships, book classes,
and track attendance.

## Problem Statement

Gym owners currently rely on spreadsheets, paper sign-up sheets, or expensive
legacy software to manage memberships and class schedules. Members lack a
convenient way to view schedules, book classes, or manage their accounts
without calling or visiting the front desk.

## Target Users
- Gym owners and administrators
- Gym members
- Class instructors

## SDLC Coverage
- Phase 1: Requirements Analysis (complete)
- Phase 2: System Design (complete)
- Phase 3-5: Implementation, Testing, Deployment (outlined in future-phases/)
```

**04-functional-requirements.md excerpt:**
```markdown
## Core Feature: Membership Management

| ID | Requirement | Priority | Persona |
|----|------------|----------|---------|
| FR-001 | System shall allow admins to create membership plans with name, duration, and price | Must Have | Admin |
| FR-002 | System shall process member registration with personal details and plan selection | Must Have | Member |
| FR-003 | System shall send automated renewal reminders 7 days before expiry | Should Have | Member |
| FR-004 | System shall support membership freezing for up to 30 days | Could Have | Member |

### FR-001 Acceptance Criteria
- Admin can create a plan with name (max 50 chars), duration (1-24 months), and price (positive decimal)
- Created plan appears in the plan listing within 2 seconds
- System prevents duplicate plan names
```

---

## Troubleshooting

### Output directory already exists
If `.synapsync/sdlc/{project-name}/` already exists, ask the user whether to overwrite or choose a different name (e.g., `{project-name}-v2`).

### Input is too vague
If the input is a single word like "app" or "system," make broader assumptions and document them prominently in `06-assumptions-and-constraints.md`. Still generate all files.

### Input describes multiple products
If the input describes what appears to be multiple distinct products, choose the primary one and document the others in `07-out-of-scope.md` as potential future integrations.

### Input includes technical constraints
If the user specifies technologies (e.g., "React + Node.js"), respect those constraints in architecture decisions and document them as explicit requirements rather than assumptions.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release with Phase 1 + Phase 2 generation |

## Future Enhancements

- Phase 3 (Implementation) detailed planning with task decomposition
- Phase 4 (Testing) test case generation from functional requirements
- Phase 5 (Deployment) infrastructure-as-code templates
- Automatic Mermaid diagram rendering validation
- Multi-language documentation output (i18n)
- Integration with project-planner for automatic sprint generation from requirements
