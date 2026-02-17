# Troubleshooting Guide

Common issues and resolutions for both PLAN and EXECUTE modes.

---

## PLAN Mode Issues

### "Analysis is never-ending"

**Resolution**: Set a hard scope boundary. Document unknowns as risks, not blockers. Move to planning with incomplete analysis if needed — the plan can account for investigation tasks.

### "Plan proposes patterns that conflict with existing codebase"

**Resolution**: Codebase Discovery was skipped or incomplete. Go back and create/update CONVENTIONS.md. Review every proposal against documented conventions.

### "Not sure which sub-mode to use"

**Resolution**: Ask the user. If the work involves both a new feature and refactoring, use NEW_FEATURE sub-mode and include refactoring as a phase within the execution plan.

### "Input is too vague"

**Resolution**: Make broader assumptions and document them prominently in ANALYSIS.md. For NEW_PROJECT sub-mode, document in `assumptions-and-constraints.md`. Still generate all required files.

### "Sprint todos get out of sync with execution phases"

**Resolution**: Create sprint plans AFTER finalizing the execution plan. Map each sprint task to a specific execution phase. Review alignment before handoff.

### "Tasks don't fit into a single phase"

**Resolution**: Cross-cutting concerns (testing, documentation, monitoring) should be tracked as support tasks within the sprint where they're most relevant, or as a dedicated verification phase.

---

## EXECUTE Mode Issues

### Plan Directory Not Found

**Symptom**: Cannot find `{output_dir}/planning/{project-name}/`

**Resolution**: Verify the path exists. The user may need to run PLAN mode first or specify the correct project name. The staging path should be `.agents/staging/universal-planner/{project-name}/`.

### CONVENTIONS.md References Components That Don't Exist

**Symptom**: The plan references components, libraries, or patterns that don't exist in the current codebase

**Resolution**: The codebase may have changed since the plan was written. Verify the current state, adapt the implementation to use what actually exists, and document the discrepancy in the Decision Log.

### Verification Command Fails But Implementation Is Correct

**Symptom**: Task verification fails, but the code implementation is correct

**Resolution**: The verification command may be outdated or have incorrect expectations. Fix the verification command in the sprint file, document the correction in Notes, and proceed.

### Task Depends on Something from a Future Sprint

**Symptom**: A task requires functionality planned for a later sprint

**Resolution**: This is a planning error. Log as blocker, skip the task, and report it. PLAN mode may need to reorder tasks.

### Sprint Has No Tasks — Only Headers

**Symptom**: Sprint file has phase structure but no concrete tasks

**Resolution**: The plan is incomplete. Stop execution and report that the sprint file needs to be populated via PLAN mode.

### Build Breaks After Implementing a Task

**Symptom**: Tests or build process fails after task completion

**Resolution**: Diagnose the failure. If the task's implementation is correct but breaks something else, the plan may have missed a dependency. Fix the regression, document in Decision Log, and continue.

### Not Sure What Framework/Library to Use

**Symptom**: Task requires a technical decision not specified in the plan

**Resolution**: Always check CONVENTIONS.md first. If not there, check `package.json` (or equivalent). Match what the project already uses. Never introduce a new library when the plan doesn't call for it.

---

## Related Documents

- **PLAN mode rules**: See [PLAN.md](../modes/PLAN.md)
- **EXECUTE mode rules**: See [EXECUTE.md](../modes/EXECUTE.md)
- **Decision Log format**: See [decision-log.md](decision-log.md)
- **Code Quality Standards**: See [code-quality-standards.md](code-quality-standards.md)
