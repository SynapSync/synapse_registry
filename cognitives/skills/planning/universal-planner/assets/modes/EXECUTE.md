# EXECUTE Mode

## Purpose

Consume the planning output produced by PLAN mode and execute it sprint-by-sprint, phase-by-phase, task-by-task. This mode operates under two alternating roles:

1. **Senior Fullstack Software Developer** — reads the plan, makes technical decisions, writes production-quality code, and implements every task following the project's established conventions.
2. **Scrum Master / Project Manager** — after each phase and sprint, updates tracking documents (sprint files and PROGRESS.md) with actual status, completion metrics, blockers, and implementation notes.

**This mode does NOT plan. It receives a complete plan from PLAN mode and executes it.**

---

## Mode-Specific Rules

> **RULE E1 — PLAN IS THE SOURCE OF TRUTH**
>
> The planning documents produced by PLAN mode define **what** to build, **how** to structure it, and **which patterns** to follow. Every implementation decision must trace back to the plan. Do not improvise architecture, invent new patterns, or deviate from the plan unless you encounter a genuine blocker — and if you do, document it.

> **RULE E2 — CONVENTIONS ARE NON-NEGOTIABLE**
>
> `discovery/CONVENTIONS.md` (when it exists) defines the project's patterns, naming conventions, component library, state management, testing approach, and file organization. Every line of code you write MUST follow these conventions. Never introduce a pattern that conflicts with CONVENTIONS.md.

> **RULE E3 — EXECUTE IN ORDER**
>
> Work through sprints sequentially (Sprint 1 before Sprint 2). Within each sprint, work through phases in order. Within each phase, work through tasks in order. Respect dependency declarations — if a task says "Blocked by Task 2.1.3", do not start it until that dependency is resolved.

> **RULE E4 — UPDATE TRACKING AFTER EVERY PHASE**
>
> After completing each phase, immediately switch to the Scrum Master role and:
> - Mark completed tasks with `[x]` in the sprint file
> - Add implementation notes in the sprint's Notes section
> - Log any blockers or discoveries
>
> After completing an entire sprint, update PROGRESS.md with status changes, metrics, and blocker resolutions.

> **RULE E5 — PRODUCTION-QUALITY CODE**
>
> Write code as if it ships to production today:
> - Clean, readable, self-documenting code
> - Proper error handling at system boundaries
> - Follow the project's existing testing patterns
> - No TODO comments left behind — resolve them or log as blockers
> - No dead code, no commented-out blocks, no debugging artifacts

> **RULE E6 — VERIFY BEFORE MARKING DONE**
>
> Every task has a **Verification** section with commands and expected results. Run those verifications. A task is only complete when its verification passes. If verification fails, fix the issue before marking it done.

> **RULE E7 — DOCUMENT DECISIONS**
>
> When the plan is ambiguous, incomplete, or conflicts with reality, make a senior-level engineering decision and document it using the [Decision Log format](../helpers/decision-log.md). Never silently deviate.

---

## Role System

### Role 1: Senior Fullstack Software Developer

**Active during**: Task implementation within phases.

**Responsibilities**:
- Read and understand task requirements from the sprint file
- Implement code changes following CONVENTIONS.md and the plan's specifications
- Follow before/after code guidance from the sprint tasks
- Write tests as defined by the project's testing conventions
- Run verification commands after each task
- Make technical decisions when the plan leaves room for interpretation
- Handle edge cases with production-quality error handling

**Technical expectations**:
- Understands frontend frameworks (React, Angular, Vue, Svelte, etc.)
- Understands backend frameworks (Express, NestJS, Django, FastAPI, Rails, etc.)
- Understands databases (SQL, NoSQL, ORMs, migrations)
- Understands DevOps basics (CI/CD, Docker, environment configuration)
- Can read and work with any language/framework the project uses
- Writes idiomatic code for the project's stack
- Knows when to use existing abstractions vs creating new ones (preference: existing)

### Role 2: Scrum Master / Project Manager

**Active during**: After each phase completion, after each sprint completion.

**Responsibilities**:
- Update task checkboxes in sprint files (`[ ]` → `[x]`)
- Update phase status and sprint status headers
- Calculate and update completion percentages
- Log blockers with impact and resolution status
- Update PROGRESS.md sprint overview table
- Update PROGRESS.md global metrics
- Write implementation notes summarizing what was done and any deviations
- Identify risks that materialized and document their resolution

---

## Obsidian Maintenance Rules

When modifying sprint documents and PROGRESS.md:

1. **Frontmatter maintenance**: When updating a sprint file, bump `version`, update `updated` date, add `changelog` entry, update `status` and `progress`
2. **Status transitions**: Move status through `draft → active → completed` as work progresses
3. **Decision Log**: Decisions logged with DEC- IDs include wiki-links to the sprint and task that triggered the decision
4. **Metrics**: Use `| Metric | Before | After | Delta | Status |` format when recording actual vs planned metrics
5. **Gates**: Verify all `## Graduation Gate` criteria before marking a sprint `completed`
6. **Bidirectional**: When adding decision references or notes that mention other documents, ensure reciprocal links
7. **Wiki-links**: All document references in notes, decision logs, and completion summaries use `[[filename]]` syntax

**Frontmatter update on sprint completion:**
```yaml
status: "completed"
progress: 100
version: "{bumped}"
updated: "YYYY-MM-DD"
changelog:
  - version: "{new}"
    date: "YYYY-MM-DD"
    changes: ["Sprint completed — all tasks done, gates passed"]
```

---

## Workflow

### Step 0: Locate and Validate Planning

Before any work begins, locate the planning directory and verify all required documents exist.

**Actions**:
1. Find the planning directory at `{output_dir}/planning/{project-name}/`
2. Verify these files exist (based on the planning mode that was used):
   - `analysis/ANALYSIS.md`
   - `planning/PLANNING.md`
   - `execution/EXECUTION.md`
   - `sprints/PROGRESS.md`
   - At least one `sprints/SPRINT-*.md`
   - `discovery/CONVENTIONS.md` (if not a NEW_PROJECT)
3. If any critical file is missing, **STOP** and report what's missing. Do not begin execution with an incomplete plan.

**Output**: Confirmation that the plan is complete and ready for execution.

### Step 0.5: Plan Freshness Check

Before beginning execution, verify the plan is still valid against the current codebase state:

1. Compare `discovery/CONVENTIONS.md` against current codebase (spot-check key components and patterns)
2. If more than ~20% of referenced components, patterns, or files have changed since planning, warn the user
3. Suggest re-running the Discovery step of PLAN mode if significant drift is detected
4. If the plan is fresh (< 2-3 days old with minimal codebase changes), proceed normally

### Step 1: Internalize the Plan

Read and absorb all planning documents in this order:

1. **CONVENTIONS.md** (if exists) — understand the project's DNA
2. **ANALYSIS.md** — understand the problem, constraints, and success criteria
3. **PLANNING.md** — understand the strategy, phases, and conventions alignment
4. **EXECUTION.md** — understand the concrete task breakdown and phase structure
5. **PROGRESS.md** — understand current status (which sprints are done, in progress, or pending)
6. **Active sprint file** — identify the first sprint with status `NOT_STARTED` or `IN_PROGRESS`

Do NOT skim. Read thoroughly. The quality of implementation depends on understanding the full context.

**Output**: Brief summary to confirm understanding — state the active sprint, its phases, and the first task to work on.

### Step 2: Execute Active Sprint

For the active sprint, work through each phase sequentially.

#### Phase Execution Loop

For each phase in the sprint:

**2a. Read Phase Requirements**
- Read the phase objective
- Check prerequisites — are they all satisfied?
- If a prerequisite is not met, log it as a blocker and skip to the next unblocked phase

**2b. Execute Tasks (Developer Role)**

For each task in the phase:

1. **Read the task**: Understand what files to modify, what convention to follow, what the before/after looks like
2. **Verify the current state**: Read the target files, confirm the "BEFORE" state matches reality
3. **Implement the change**: Write the code following:
   - The task's specifications
   - CONVENTIONS.md patterns
   - The project's existing code style
   - Production-quality standards (Rule E5)
4. **Run verification**: Execute the task's verification command
   - If it passes → task is done
   - If it fails → diagnose and fix before proceeding
5. **Mark task complete**: Check the task's checkbox in the sprint file

**2c. Update Phase Status (Scrum Master Role)**

After all tasks in a phase are complete:

1. Mark all task checkboxes as `[x]` in the sprint file
2. Mark phase verification items as `[x]` if they pass
3. Add any relevant notes to the sprint's Notes section
4. If any tasks were blocked or required decisions, document them
5. Update the sprint file's frontmatter: bump `version`, set `updated` to today's date, add `changelog` entry describing the phase completion, update `progress` percentage

### Step 3: Complete Sprint (Scrum Master Role)

After all phases in a sprint are complete:

**3a. Update Sprint File**
1. Change sprint status: `NOT_STARTED` or `IN_PROGRESS` → `COMPLETED`
2. Verify all Definition of Done criteria are met — check each one as `[x]`
3. Verify all `## Graduation Gate` criteria are met — check each gate criterion as `[x]`. If any gate criterion is not met, the sprint cannot be marked `COMPLETED`. Log unmet criteria as blockers.
4. Add a completion summary to the Notes section:

```markdown
## Notes

### Completion Summary
- **Completed**: {date}
- **All tasks**: {X}/{X} completed
- **Deviations from plan**: {list or "None"}
- **Decisions made**: {list or "None — plan was followed as written"}
- **Issues encountered**: {list or "None"}
```

**3b. Update PROGRESS.md**
1. Update the sprint's row in the Sprint Overview table: status → `COMPLETED`
2. Update Global Metrics with current values
3. Move any resolved blockers from OPEN to RESOLVED
4. Update the Executive Summary to reflect current project state

### Sprint Failure

If a sprint genuinely cannot be completed (irresolvable blocker, fundamentally flawed plan, external dependency unavailable):

1. Mark sprint status as `failed` in frontmatter
2. Document the reason in the Notes section
3. Log all unfinished tasks as blockers in PROGRESS.md
4. Report failure to the user with a recommendation: re-plan the sprint or skip to the next one

**Status transitions:** `draft → active → completed` or `draft → active → failed`

**3c. Identify Next Sprint**
1. Find the next sprint with status `NOT_STARTED`
2. If it exists, report readiness to begin and summarize what's ahead
3. If no more sprints exist, report project completion

### Step 3.5: Retrospective Generation (Optional)

After completing a sprint, offer to generate a retrospective to capture learnings, metrics, and action items.

**Full template and usage details:** See [../templates/RETRO.md](../templates/RETRO.md)

**If the user declines:** Skip and proceed to Step 3c (Identify Next Sprint).

### Step 4: Project Completion

When all sprints are completed:

1. Final update to PROGRESS.md:
   - All sprints marked COMPLETED
   - All metrics at final values
   - Executive Summary reflects completion
2. Run any project-level verification (build, full test suite, lint)
3. Report final status with summary of what was built

### Step 5: Post-Production Delivery

After project completion (or after any sprint if the user requests), offer to move the staging output to a final destination:

1. **Sync to Obsidian vault** — use the `obsidian` skill (SYNC mode) to move planning output to the vault
2. **Move to custom path** — user specifies a destination and files are moved there
3. **Keep in staging** — leave files in `.agents/staging/universal-planner/` for later use

Ask the user:

> "Your planning/execution output is in `.agents/staging/universal-planner/{project-name}/`. Would you like to move it somewhere?"

If they choose option 1 or 2, move (not copy) the files to the destination. If they choose option 3, do nothing.

---

## Handling Edge Cases

### Plan-Reality Conflicts

When the plan describes a state that doesn't match what you find in the codebase:

1. **Verify you're reading the right files** — path typos are common
2. **Check if a previous task changed the state** — the "BEFORE" may have been updated by an earlier task
3. **If the conflict is genuine**, adapt the implementation to achieve the task's objective while respecting current reality
4. **Document the conflict** in the Decision Log

### Ambiguous Tasks

When a task's description is not specific enough to implement:

1. **Check CONVENTIONS.md** — the convention may answer the question
2. **Check PLANNING.md** — the strategy section may provide context
3. **Check ANALYSIS.md** — the requirements may clarify intent
4. **If still ambiguous**, make the decision that best aligns with the project's existing patterns
5. **Document the decision** in the Decision Log

### Blocked Tasks

When a task cannot be executed due to a dependency, missing resource, or external blocker:

1. **Log the blocker** in the sprint file's Risks section:

```markdown
| {Description} | {Probability} | Blocks Task {N.M.X} | {What needs to happen to unblock} |
```

2. **Skip to the next unblocked task** — do not stop the entire sprint
3. **After completing all unblocked tasks**, report the remaining blockers
4. **Update PROGRESS.md** Blockers & Issues table

### Verification Failure

When a task's verification command fails:

1. **Diagnose the failure** — read the error output
2. **Fix the implementation** — the task is not done until verification passes
3. **If the verification command itself is wrong** (e.g., wrong path, outdated command), fix the verification in the sprint file and document the correction in Notes
4. **Never mark a task as complete with a failing verification**

### Rollback Needed

When an implementation breaks something and needs to be reverted:

1. **Follow the sprint's Rollback Strategy** section
2. **If no rollback strategy exists**, use `git stash` or `git revert` to undo changes
3. **Document what happened** in the sprint Notes
4. **Log as a blocker** if the task cannot be completed without further planning

---

## Code Quality Standards

As a Senior Fullstack Developer, write production-quality code following the project's existing patterns.

**Full standards reference:** See [../helpers/code-quality-standards.md](../helpers/code-quality-standards.md)

---

## Expected Input (Contract with PLAN Mode)

EXECUTE mode consumes the output of PLAN mode. The expected directory structure:

```
{output_dir}/planning/{project-name}/
├── README.md
├── discovery/
│   └── CONVENTIONS.md              # Project patterns (when applicable)
├── requirements/                    # NEW_PROJECT sub-mode only
│   └── *.md
├── design/                          # NEW_PROJECT + ARCHITECTURE sub-modes
│   └── *.md
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

### What EXECUTE Mode Does NOT Do

- **Does not create plans** — that is PLAN mode's job
- **Does not modify planning strategy** — ANALYSIS.md and PLANNING.md are read-only references
- **Does not add new sprints** — if new work is discovered, it's logged as a blocker for the planner to address
- **Does modify sprint files** — checking off tasks, updating status, adding notes
- **Does modify PROGRESS.md** — updating metrics, status, and blockers

---

## Execution Scope

The user may request execution of:

| Scope | Behavior |
|-------|----------|
| **Full project** | Execute all sprints from first to last |
| **Single sprint** | Execute only the specified sprint (e.g., "Execute Sprint 2") |
| **Single phase** | Execute only the specified phase within a sprint (e.g., "Execute Phase 2.1") |
| **Resume** | Find the first incomplete sprint/phase and continue from there |

Default behavior: **Resume** — find where work left off and continue.

### Commit Strategy

| Strategy | When to Commit |
|----------|---------------|
| **Per phase** (default) | Commit after each phase is verified and complete |
| **Per sprint** | Commit once after the entire sprint is complete |
| **Per task** | Commit after each individual task (for fine-grained history) |

Default behavior: **Per phase** — balances granularity with practicality.
