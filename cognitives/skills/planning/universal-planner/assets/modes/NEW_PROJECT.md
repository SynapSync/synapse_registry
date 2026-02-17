# NEW_PROJECT Mode

## When to Use

Use this mode when planning a **product or application from scratch** (greenfield project). The user provides a product idea, app concept, or wants to "build from scratch" with no existing codebase.

**Example inputs:**
- "I need an app to track expenses"
- "Build a SaaS for team scheduling"
- "Create a CI/CD pipeline manager"
- "I want to build a mobile app for fitness tracking"

**Detection signals:**
- Product idea or app concept
- "build from scratch"
- No existing codebase
- Starting from zero

## Output Structure

NEW_PROJECT produces the most comprehensive documentation set:

```
{output_dir}/planning/{project-name}/
├── README.md
├── requirements/                    # SDLC Phase 1 (7 files)
│   ├── problem-definition.md
│   ├── goals-and-metrics.md
│   ├── stakeholders-and-personas.md
│   ├── functional-requirements.md
│   ├── non-functional-requirements.md
│   ├── assumptions-and-constraints.md
│   └── out-of-scope.md
├── design/                          # System Design (6 files)
│   ├── system-overview.md
│   ├── architecture-decisions.md
│   ├── high-level-architecture.md
│   ├── data-model.md
│   ├── core-flows.md
│   └── non-functional-design.md
├── analysis/
│   └── ANALYSIS.md
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    ├── PROGRESS.md
    └── SPRINT-{N}-{name}.md
```

**Documents that are NOT generated:**
- `discovery/CONVENTIONS.md` - Not applicable (no existing codebase)

## Frontmatter Additions

No mode-specific frontmatter fields for NEW_PROJECT. All documents use the standard universal schema.

## Workflow

**NEW_PROJECT Workflow:** Analyze Idea → Requirements → System Design → Analysis → Planning → Execution → Sprints → Handoff

### Step 1: Adaptive Architecture Detection

Before writing documentation, detect the product domain and adapt the architecture:

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

Use this to inform technology recommendations and architecture decisions.

### Step 2: Requirements Analysis (7 files)

Generate all 7 requirement files in `requirements/`:

1. **problem-definition.md** - Problem statement, current alternatives, proposed solution, value proposition
2. **goals-and-metrics.md** - SMART goals, KPIs, timeline milestones
3. **stakeholders-and-personas.md** - Stakeholder map, 2-4 user personas, user journeys
4. **functional-requirements.md** - MoSCoW-prioritized requirements with IDs (FR-001, FR-002...)
5. **non-functional-requirements.md** - Performance, scalability, security, reliability targets
6. **assumptions-and-constraints.md** - Technical/business assumptions, constraints, risks
7. **out-of-scope.md** - Excluded features, boundary definitions

See [Requirements Specifications](#requirements-specifications) below for detailed templates.

### Step 3: System Design (6 files)

Generate all 6 design files in `design/`:

1. **system-overview.md** - System context, tech stack recommendations
2. **architecture-decisions.md** - ADRs for key decisions (ADR-001, ADR-002...)
3. **high-level-architecture.md** - Component diagram (Mermaid), communication patterns
4. **data-model.md** - ER diagram (Mermaid), entities, relationships
5. **core-flows.md** - Sequence diagrams (Mermaid) for critical user flows
6. **non-functional-design.md** - Performance/security/scalability design

See [Design Specifications](#design-specifications) below for detailed templates.

### Step 4: Analysis

**Analysis adapts to:**
- Product feasibility assessment
- Technology selection rationale
- Resource requirements (team, timeline, budget estimates)
- Market analysis (if relevant)
- Technical risks and mitigation strategies

### Step 5-7: Planning, Execution, Sprints

Follow the shared workflow steps (same as other modes).

## Scale Adaptation

Adjust depth based on project scale:

| Scale | Indicators | Depth |
|-------|-----------|-------|
| **Small** | Personal tool, single user, simple domain | 2 personas, 3-4 ADRs, simpler architecture |
| **Medium** | Team tool, multiple user types, integrations | 3 personas, 5-6 ADRs, standard architecture |
| **Large** | Platform, multi-tenant, complex domain | 4+ personas, 7+ ADRs, detailed architecture |

## Requirements Specifications

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
| Requirements Table | ID (FR-001...), description, priority, persona |
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

**This file is critical** — it captures everything inferred from vague input.

### out-of-scope.md

| Section | Content |
|---------|---------|
| Excluded Features | Features explicitly not included in v1.0 |
| Future Considerations | Features planned for later releases |
| Boundary Definitions | What this product is NOT |

## Design Specifications

### system-overview.md

- System context diagram (Mermaid)
- Technology stack recommendations (frontend, backend, database, infrastructure)
- Third-party services and integrations
- Development tools and frameworks

### architecture-decisions.md

Use ADR format for each decision:

```markdown
## ADR-001: {Decision Title}

**Status:** Accepted

**Context:** [What decision needs to be made and why]

**Decision:** [What we decided]

**Consequences:** [Trade-offs, implications]

**Alternatives Considered:** [What else was considered and why rejected]
```

### high-level-architecture.md

- Component diagram (Mermaid) showing major components
- Communication patterns (REST, GraphQL, WebSockets, message queues)
- Deployment architecture (cloud, on-prem, hybrid)
- Scaling strategy

### data-model.md

- ER diagram (Mermaid) showing entities and relationships
- Entity definitions with attributes
- Indexes and constraints
- Data migration strategy (if applicable)

### core-flows.md

Sequence diagrams (Mermaid) for:
- User authentication flow
- Critical business flows (e.g., payment, checkout, data sync)
- Error handling flows

### non-functional-design.md

- **Performance Design:** Caching strategy, CDN, database optimization
- **Security Design:** Auth/authz architecture, encryption, rate limiting
- **Scalability Design:** Load balancing, horizontal scaling, database sharding
- **Reliability Design:** Monitoring, alerting, logging, disaster recovery

## Examples

**Example 1: Personal finance app**
- Scale: Small
- Personas: 2 (Budget-conscious student, Family financial planner)
- ADRs: 3 (Database choice, Authentication method, Mobile framework)
- Architecture: Mobile app (React Native) + Firebase backend

**Example 2: Team collaboration SaaS**
- Scale: Medium
- Personas: 3 (Project manager, Developer, Executive)
- ADRs: 5 (Multi-tenancy model, Real-time tech, Billing provider, Auth provider, Deployment platform)
- Architecture: SPA (React) + GraphQL API + PostgreSQL + Redis + WebSockets

**Example 3: Enterprise data platform**
- Scale: Large
- Personas: 4 (Data analyst, Data engineer, Business user, IT admin)
- ADRs: 8 (ETL framework, Data warehouse, Orchestration, Security model, API design, Visualization tool, Data catalog, Deployment strategy)
- Architecture: Microservices + Kafka + Airflow + Snowflake + Superset + Kubernetes
