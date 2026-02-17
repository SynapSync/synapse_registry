# ARCHITECTURE Mode

## When to Use

Use this mode when **evolving system architecture or planning major structural changes**. The user wants to redesign architecture, scale the system, or make infrastructure changes.

**Example inputs:**
- "Design the microservices migration"
- "Plan the monorepo restructure"
- "Architect the multi-tenant system"
- "Design the event-driven architecture"

**Detection signals:**
- "architecture", "system design", "infrastructure"
- "scaling", "migration", "evolution"
- Major structural changes
- Platform or system-level changes

## Output Structure

```
{output_dir}/planning/{project-name}/
├── README.md
├── discovery/
│   └── CONVENTIONS.md              # Current architecture
├── design/                          # Target architecture (6 files)
│   ├── system-overview.md
│   ├── architecture-decisions.md
│   ├── high-level-architecture.md
│   ├── data-model.md
│   ├── core-flows.md
│   └── non-functional-design.md
├── analysis/
│   └── ANALYSIS.md                 # Gap analysis and migration plan
├── planning/
│   └── PLANNING.md
├── execution/
│   └── EXECUTION.md
└── sprints/
    ├── PROGRESS.md
    └── SPRINT-{N}-{name}.md
```

**Key difference from NEW_PROJECT:**
- `discovery/CONVENTIONS.md` documents **current** architecture
- `design/*` documents **target** architecture
- `analysis/ANALYSIS.md` includes **gap analysis** and **migration path**

## Frontmatter Additions

No mode-specific frontmatter fields for ARCHITECTURE. All documents use the standard universal schema.

## Workflow

**ARCHITECTURE Workflow:** Discovery → System Design → Analysis → Planning → Execution → Sprints → Handoff

### Step 1: Codebase Discovery

Generate `discovery/CONVENTIONS.md` documenting **current architecture**:
- Current system architecture and components
- Current data model and storage
- Current communication patterns (sync/async, protocols)
- Current deployment architecture
- Current scaling characteristics
- Pain points and limitations

### Step 2: System Design (Target Architecture)

Generate all 6 design files in `design/`:

1. **system-overview.md** - Target system context, tech stack evolution
2. **architecture-decisions.md** - ADRs for architectural changes (ADR-001, ADR-002...)
3. **high-level-architecture.md** - Target component diagram, new communication patterns
4. **data-model.md** - Target data model, storage evolution
5. **core-flows.md** - Target sequence diagrams for critical flows
6. **non-functional-design.md** - Target performance, security, scalability design

**Critical:** Design documents describe the **target** (where you're going), while CONVENTIONS.md describes the **current** (where you are).

### Step 3: Analysis (Gap Analysis & Migration Plan)

**Analysis adapts to:**

1. **Current vs Target Architecture Gap**
   - Side-by-side comparison: current vs target
   - What's changing, what's staying
   - Why each change is necessary

2. **Migration Path**
   - **Phase 1, 2, 3...:** Step-by-step migration plan
   - **Backwards compatibility strategy:** How to maintain compatibility during migration
   - **Rollback plan:** How to roll back if migration fails
   - **Feature flags:** Which feature flags control migration

3. **Risk Assessment**
   - **Risk 1, 2, 3...:** Identified risks for each change
   - **Probability:** High/Medium/Low
   - **Impact:** High/Medium/Low
   - **Mitigation:** How to reduce risk

4. **Data Migration**
   - **What data:** What data needs to migrate
   - **Migration strategy:** ETL, dual-write, cutover, etc.
   - **Validation:** How to validate migration success
   - **Rollback:** How to rollback data changes

### Step 4-6: Planning, Execution, Sprints

Follow the shared workflow steps.

## Recommended Sprint Structure

| Sprint | Focus | Deliverables |
|--------|-------|--------------|
| **Sprint 1: Foundation** | Infrastructure, base patterns, feature flags | New infra deployed, feature flags in place |
| **Sprint 2: Migration** | Core component migration | Critical components migrated |
| **Sprint 3: Integration** | Reconnect migrated components | System working end-to-end |
| **Sprint 4: Cleanup** | Remove legacy code, feature flags, verification | Legacy code removed, full cutover |

Adjust sprint count based on migration scope:
- **Small change** (component-level): 2 sprints
- **Medium change** (layer-level): 3 sprints
- **Large change** (architecture-level): 4-6 sprints

## Analysis Template

### Current vs Target Gap Analysis

```markdown
## Current vs Target Architecture

### Current Architecture (Monolith)

\`\`\`mermaid
graph TD
    A[Web App] --> B[Monolithic API]
    B --> C[PostgreSQL]
    B --> D[Redis Cache]
\`\`\`

**Characteristics:**
- Single deployment unit
- Tightly coupled modules
- Vertical scaling only
- Single point of failure

**Pain Points:**
- Deployment risk (one change requires full redeploy)
- Scaling inefficiency (must scale entire monolith)
- Team coordination (multiple teams touch same codebase)
- Technology lock-in (all services use same stack)

### Target Architecture (Microservices)

\`\`\`mermaid
graph TD
    A[Web App] --> B[API Gateway]
    B --> C[Auth Service]
    B --> D[Orders Service]
    B --> E[Inventory Service]
    B --> F[Notifications Service]
    C --> G[Auth DB]
    D --> H[Orders DB]
    E --> I[Inventory DB]
    K[Message Bus] --> C
    K --> D
    K --> E
    K --> F
\`\`\`

**Characteristics:**
- Independent deployments per service
- Loosely coupled via APIs and events
- Horizontal scaling per service
- Fault isolation

**Benefits:**
- Independent deployment (deploy one service without affecting others)
- Efficient scaling (scale only what needs scaling)
- Team autonomy (each team owns a service)
- Technology diversity (each service can use best-fit stack)

### Gap Analysis

| Aspect | Current | Target | Change Required |
|--------|---------|--------|-----------------|
| **Deployment** | Monolith | Microservices | Split codebase, containerize, orchestrate |
| **Data** | Shared DB | DB per service | Data migration, event-driven sync |
| **Communication** | In-process | HTTP + Events | Add API layer, message bus |
| **Scaling** | Vertical | Horizontal | Kubernetes, load balancers |
| **Monitoring** | Monolithic logs | Distributed tracing | Add observability stack |
```

### Migration Path

```markdown
## Migration Path

### Phase 1: Strangler Fig Pattern Setup (Sprint 1)
1. Deploy API Gateway in front of monolith
2. Set up feature flags for service routing
3. Set up message bus (Kafka/RabbitMQ)
4. No service extraction yet — just infrastructure

### Phase 2: Extract First Service (Sprint 2)
1. **Service:** Auth Service (least dependencies)
2. **Data:** Copy auth tables to auth DB
3. **Dual-write:** Monolith writes to both DBs
4. **Routing:** Feature flag routes 10% → Auth Service, 90% → Monolith
5. **Validation:** Compare responses, monitor errors
6. **Ramp up:** 10% → 50% → 100% over 1 week

### Phase 3: Extract Remaining Services (Sprint 3-5)
1. Orders Service (depends on Auth)
2. Inventory Service (depends on Orders)
3. Notifications Service (async, event-driven)

### Phase 4: Decommission Monolith (Sprint 6)
1. All traffic routed to microservices
2. Remove monolith code
3. Remove feature flags
4. Full cutover complete
```

### Risk Assessment

```markdown
## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| **Data inconsistency during dual-write** | Medium | High | Event sourcing + reconciliation jobs |
| **Performance degradation (network overhead)** | High | Medium | Caching layer + async where possible |
| **Distributed transaction failures** | Medium | High | Saga pattern for multi-service transactions |
| **Observability gaps** | High | Medium | Distributed tracing from day 1 |
| **Team knowledge gaps** | Medium | Medium | Training + pair programming |
```

### Data Migration Strategy

```markdown
## Data Migration

### Auth Data Migration

**What:** Users, roles, permissions tables

**Strategy:**
1. **Snapshot:** Take snapshot of auth tables from monolith DB
2. **Dual-write:** Monolith writes to both DBs during migration
3. **Sync:** Periodic sync job ensures consistency
4. **Cutover:** Switch reads to auth DB once validated
5. **Cleanup:** Remove dual-write after 2 weeks

**Validation:**
- Record count comparison (monolith DB vs auth DB)
- Checksum validation for critical fields
- Automated integration tests

**Rollback:**
- Revert routing to monolith
- Keep dual-write active for 2 weeks as safety net
```

## Examples

**Example 1: Monolith to Microservices**
- Sprints: 6 (Foundation + 4 service extractions + Cleanup)
- Services extracted: Auth, Orders, Inventory, Notifications
- Migration: Strangler Fig pattern
- Timeline: 3 months

**Example 2: Multi-tenancy architecture**
- Sprints: 4 (Design + DB sharding + Tenant routing + Testing)
- Change: Shared DB → DB per tenant
- Migration: Blue-green deployment with phased tenant migration

**Example 3: Event-driven refactor**
- Sprints: 3 (Message bus + Event producers + Event consumers)
- Change: Synchronous → Event-driven
- Migration: Add events alongside existing sync calls, phase out sync
