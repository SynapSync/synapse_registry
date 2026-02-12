# REFACTOR Mode

## When to Use

Use this mode when **restructuring existing code without changing behavior**. The user wants to refactor, reorganize, migrate patterns, or improve the architecture of existing code.

**Example inputs:**
- "Refactor the auth module"
- "Migrate from Redux to Zustand"
- "Restructure the API layer"
- "Clean up the component hierarchy"

**Detection signals:**
- "refactor", "restructure", "reorganize"
- Migrate patterns or libraries
- Improve architecture
- Code quality improvement

## Output Structure

```
{output_base}/planning/{project-name}/
├── README.md
├── discovery/
│   └── CONVENTIONS.md              # Current patterns and issues
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

## Frontmatter Additions

**ANALYSIS.md frontmatter:**
```yaml
scope_modules: ["module-a", "module-b", "module-c"]
```

Lists all modules affected by the refactor.

## Workflow

**REFACTOR Workflow:** Discovery → Analysis → Planning → Execution → Sprints → Handoff

### Step 1: Codebase Discovery

Generate `discovery/CONVENTIONS.md` documenting:
- **Current architecture:** How the code is organized today
- **Pattern inconsistencies:** Where patterns diverge
- **Code smells:** Duplication, circular dependencies, violations
- **Architectural debt:** Technical debt accumulated over time

### Step 2: Analysis

**Analysis adapts to:**

1. **Current vs Target Architecture Comparison**
   - What the architecture is today
   - What the architecture should be (target state)
   - Gap analysis

2. **Code Duplication Identification**
   - Percentage of duplicated code (if measurable)
   - Locations of duplication
   - Consolidation opportunities

3. **Architectural Inconsistencies**
   - Pattern violations (e.g., components doing business logic)
   - Layering violations (e.g., UI importing database code)
   - Naming inconsistencies

4. **Folder Responsibility Definitions**
   - **What SHOULD go where** (ideal structure)
   - **What IS where** (current structure)
   - Files that need to move

5. **Missing Abstractions or Over-engineering**
   - Abstractions that should exist but don't
   - Abstractions that shouldn't exist but do

6. **Dependency Issues**
   - Circular dependencies
   - Incorrect layering (UI depends on DB, etc.)
   - Tight coupling

## Recommended Sprint Structure

| Sprint | Focus | Deliverables |
|--------|-------|--------------|
| **Sprint 1: Cleanup** | Delete legacy code, consolidate duplicates | Dead code removed, duplication reduced |
| **Sprint 2: Migration** | State/architecture migration | New patterns established, old patterns deprecated |
| **Sprint 3: Extraction** | Logic extraction, pattern enforcement | Business logic extracted, patterns enforced |
| **Sprint 4: Verification** | Testing and documentation | Tests passing, docs updated |

Adjust based on scope:
- **Small refactor** (module-level): 1-2 sprints
- **Medium refactor** (layer-level): 2-3 sprints
- **Large refactor** (architecture-level): 3-4 sprints

## Analysis Template

### Current Architecture

```markdown
## Current Architecture

### Module Structure
\`\`\`
src/
├── components/           # UI components (some have business logic ❌)
├── services/             # API calls and business logic
├── utils/                # Utilities (some are actually services ❌)
└── hooks/                # React hooks (mixed concerns ❌)
\`\`\`

### Problems
- **P1**: Components contain business logic (violates separation of concerns)
- **P2**: `utils/` contains services, not utilities
- **P3**: Hooks duplicate logic that should be in services
- **P4**: 35% code duplication in API call handling
```

### Target Architecture

```markdown
## Target Architecture

### Module Structure
\`\`\`
src/
├── components/           # UI components only (presentation)
├── services/             # Business logic and API calls
├── hooks/                # React hooks (state + service orchestration)
├── utils/                # Pure utilities only
├── types/                # TypeScript types
└── constants/            # Constants
\`\`\`

### Changes
- **Extract business logic** from components → services
- **Move services** from utils/ → services/
- **Consolidate API calls** into shared service utilities
- **Extract duplicated logic** into reusable hooks
```

### Migration Path

```markdown
## Migration Path

### Phase 1: Extract Services
1. Create `services/` directory
2. Extract business logic from components → `services/{domain}.service.ts`
3. Update components to use services

### Phase 2: Consolidate Utilities
1. Audit `utils/` directory
2. Move services → `services/`
3. Keep only pure functions in `utils/`

### Phase 3: Refactor Hooks
1. Remove duplicated logic from hooks
2. Make hooks call services instead of duplicating logic
3. Add shared hooks for common patterns
```

## Metrics

Track refactor progress with before/after metrics:

| Metric | Before | After | Delta | Status |
|--------|--------|-------|-------|--------|
| Code duplication | 35% | <10% | -25% | 🎯 Target |
| Circular dependencies | 12 | 0 | -12 | 🎯 Target |
| Average file size | 450 LOC | 250 LOC | -200 | 🎯 Target |
| Test coverage | 45% | 80% | +35% | 🎯 Target |
| Build time | 45s | 30s | -15s | 🎯 Target |

## Examples

**Example 1: Redux to Zustand migration**
- Scope: State management layer
- Sprints: 3 (Setup Zustand + Migrate stores + Remove Redux)
- Modules affected: All components using Redux

**Example 2: Component hierarchy cleanup**
- Scope: UI layer
- Sprints: 2 (Extract logic + Reorganize components)
- Before: 80 components, 40% duplication
- After: 50 components, <5% duplication

**Example 3: API layer consolidation**
- Scope: Service layer
- Sprints: 3 (Consolidate + Extract utilities + Testing)
- Before: API calls in 25 files, inconsistent error handling
- After: Centralized API client, consistent patterns
