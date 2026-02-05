# 🚀 Quick-Use Prompt Templates

Ready-to-use prompts for different scenarios. Just replace the `[PLACEHOLDERS]`.

---

## Template 1: Module Refactoring

```markdown
# Project Analysis Request: Module Refactoring

## Context
- **Module path:** `[MODULE_PATH]`
- **Framework:** [Angular/React/Flutter/Node.js/etc.]
- **Problem:** [Brief description of issues - messy code, duplications, bad architecture, etc.]

## Scope
Focus ONLY on `[MODULE_NAME]` module for now. We'll scale to other modules later.

## Analysis Requirements

Analyze the code and provide:

### 1. Architecture Analysis
- Current folder structure evaluation
- Responsibility violations (what's in wrong places)
- Code duplication percentage
- Pattern compliance issues
- Missing or incorrect abstractions

### 2. Folder Responsibility Definitions
For each folder type (components, containers, services, models, etc.), define:
- What SHOULD go there (rules)
- What's currently wrong
- Examples from my code

### 3. Recommendations
- Target architecture with folder structure
- What to DELETE (legacy, duplicates)
- What to MOVE (wrong locations)
- What to CREATE (missing abstractions)
- What to REFACTOR (incorrect patterns)

## Deliverables

Create the following files in `[OUTPUT_PATH]`:

### 1. `analysis.md`
- Executive summary
- Current vs target state comparison
- Detailed folder/responsibility definitions
- Verification commands for each check
- Success metrics

### 2. `PROGRESS.md`
- Sprint overview with status indicators
- Global metrics table (target vs current)
- Timeline/schedule
- Links to sprint files

### 3. Sprint files (`SPRINT-N-[NAME].md`)
Each sprint needs:
- Clear objective (one line)
- Duration estimate
- Phases with numbered tasks
- ALL tasks must have checkboxes
- Before/after code snippets for changes
- Verification commands per phase
- Definition of "Done"
- Risks and mitigations
- Rollback strategy

## Task Structure Requirements

Tasks must be:
- Numbered hierarchically (1.1.1, 1.1.2, etc.)
- Have checkboxes
- Include file paths
- Show code changes (before/after)
- Have verification command

Example format:
```
### Task 1.1.1: [Description]
**File:** `[path]`
**Changes:**
// BEFORE
[code]
// AFTER
[code]
**Steps:**
- [ ] Step 1
- [ ] Step 2
**Verification:**
```bash
[command]
```
```

## Sprint Recommendations
- Sprint 1: Cleanup (delete legacy, consolidate duplicates)
- Sprint 2: State/Architecture migration
- Sprint 3: Logic extraction and patterns enforcement
- Sprint 4: Testing and documentation (if needed)

Start the analysis now.
```

---

## Template 2: Bug Fix / Issue Resolution

```markdown
# Project Analysis Request: Issue Resolution

## Context
- **Issue location:** `[PATH_TO_AFFECTED_CODE]`
- **Problem description:** [What's happening]
- **Expected behavior:** [What should happen]
- **Reproduction steps:** [How to reproduce - if known]

## Analysis Requirements

### 1. Root Cause Analysis
- Trace the bug to its source
- Identify all affected code paths
- Document dependencies that might be impacted

### 2. Impact Assessment
- Severity (Critical/High/Medium/Low)
- Affected features/users
- Risk of fix introducing regressions

### 3. Solution Design
- Proposed fix approach
- Alternative solutions considered
- Trade-offs of each approach

## Deliverables

Create files in `[OUTPUT_PATH]`:

### 1. `analysis.md`
- Problem statement
- Root cause with code references
- Proposed solution with code snippets
- Test cases to verify fix
- Test cases to prevent regression

### 2. `PROGRESS.md`
- Fix progress tracker
- Verification checklist

### 3. Sprint files
- `SPRINT-1-INVESTIGATION.md`: Reproduce, trace, identify
- `SPRINT-2-IMPLEMENTATION.md`: Fix, refactor if needed
- `SPRINT-3-VERIFICATION.md`: Test, review, deploy

## Task Requirements
- All tasks with checkboxes
- Verification commands
- Rollback procedures
- Definition of Done

Start the analysis now.
```

---

## Template 3: New Feature Development

```markdown
# Project Analysis Request: New Feature

## Context
- **Feature name:** [NAME]
- **Location:** `[TARGET_PATH]`
- **Framework:** [Angular/React/Flutter/etc.]

## Feature Requirements
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Technical Constraints
- [Must integrate with X]
- [Must follow Y pattern]
- [Performance requirement Z]

## Analysis Requirements

### 1. Architecture Design
- Folder structure for the feature
- Components/services/models needed
- Interfaces and contracts
- Integration points with existing code

### 2. Dependencies
- External libraries needed
- Internal modules to use
- Shared code to leverage

### 3. Implementation Strategy
- Phase-by-phase approach
- Risk areas
- Testing strategy

## Deliverables

Create files in `[OUTPUT_PATH]`:

### 1. `analysis.md`
- Feature architecture diagram
- Component breakdown
- Data flow design
- API/interface definitions
- File structure to create

### 2. `PROGRESS.md`
- Development tracker
- Milestone metrics

### 3. Sprint files
- `SPRINT-1-SETUP.md`: Scaffolding, models, interfaces
- `SPRINT-2-CORE.md`: Business logic, services
- `SPRINT-3-UI.md`: Components, views
- `SPRINT-4-INTEGRATION.md`: Connect, test, polish

Include:
- Boilerplate code templates
- Naming conventions
- All tasks with checkboxes

Start the analysis now.
```

---

## Template 4: New Project Initialization

```markdown
# Project Analysis Request: New Project Setup

## Context
- **Project name:** [NAME]
- **Type:** [Web App/Mobile App/API/Library/Monorepo]
- **Tech stack:** [Languages, frameworks, tools]

## Project Requirements
- [Core functionality 1]
- [Core functionality 2]
- [Non-functional requirements]

## Analysis Requirements

### 1. Architecture Decisions
- Folder structure recommendation
- Design patterns to use
- State management approach
- Error handling strategy
- Logging strategy

### 2. Tooling Setup
- Build tools configuration
- Linting and formatting
- Testing framework
- CI/CD pipeline

### 3. Conventions
- Naming conventions (files, classes, functions)
- Code style guidelines
- Git workflow
- Documentation standards

## Deliverables

Create files in `[OUTPUT_PATH]`:

### 1. `analysis.md`
- Architecture decision records
- Complete folder structure
- Coding conventions document
- Tool configurations

### 2. `PROGRESS.md`
- Setup progress tracker

### 3. Sprint files
- `SPRINT-1-FOUNDATION.md`: Create project, config, deps
- `SPRINT-2-ARCHITECTURE.md`: Base structure, patterns, utilities
- `SPRINT-3-TOOLING.md`: CI/CD, testing, deployment
- `SPRINT-4-DOCUMENTATION.md`: README, API docs, guidelines

Include boilerplate code and configuration files.

Start the analysis now.
```

---

## Template 5: Technical Debt / Cleanup

```markdown
# Project Analysis Request: Technical Debt Reduction

## Context
- **Scope:** `[PATH_OR_MODULE]`
- **Codebase age:** [X months/years]
- **Known issues:** [Brief list]

## Analysis Requirements

### 1. Debt Inventory
- Dead code identification
- Deprecated dependencies
- Outdated patterns
- Code duplication
- Missing tests
- Documentation gaps

### 2. Prioritization
- Impact vs effort matrix
- Quick wins (high impact, low effort)
- Critical fixes
- Nice-to-have improvements

### 3. Modernization Path
- Patterns to migrate to
- Dependencies to update
- Code to sunset

## Deliverables

Create files in `[OUTPUT_PATH]`:

### 1. `analysis.md`
- Complete debt inventory
- Prioritized action items
- Risk assessment
- Verification commands

### 2. `PROGRESS.md`
- Debt reduction tracker
- Metrics (before/after)

### 3. Sprint files (prioritized by impact)
- `SPRINT-1-QUICKWINS.md`: Easy fixes, high impact
- `SPRINT-2-CLEANUP.md`: Delete dead code, consolidate
- `SPRINT-3-MODERNIZATION.md`: Update patterns, dependencies
- `SPRINT-4-TESTING.md`: Add missing test coverage

All tasks with checkboxes and verification commands.

Start the analysis now.
```

---

## 📝 Key Elements Checklist

When customizing any template, ensure you include:

- [ ] **Clear scope** - What exactly to analyze
- [ ] **Output path** - Where to save generated files
- [ ] **Framework/language** - For pattern recommendations
- [ ] **Sprint structure request** - Phases, tasks, checkboxes
- [ ] **Verification commands** - How to check completion
- [ ] **Definition of Done** - Clear completion criteria
- [ ] **Metrics** - What to measure before/after

---

## 🔧 Customization Tips

1. **Be specific about scope**: "ONLY this module for now" prevents scope creep
2. **Request code snippets**: "Show before/after code" makes changes clearer
3. **Ask for verification commands**: Makes completion objective
4. **Request numbered tasks**: Enables precise tracking
5. **Specify output location**: Keeps planning organized
6. **Include "scale later"**: Sets expectation for incremental work