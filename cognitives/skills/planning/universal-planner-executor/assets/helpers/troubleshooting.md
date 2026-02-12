# Troubleshooting Guide

Common issues during sprint execution and how to resolve them.

## Plan Directory Not Found

**Symptom**: Cannot find `{output_base}/planning/{project-name}/`

**Resolution**: Verify the path exists. The user may need to run `universal-planner` first or specify the correct project name. Check that `cognitive.config.json` has the correct `output_base` path.

## CONVENTIONS.md References Components That Don't Exist

**Symptom**: The plan references components, libraries, or patterns that don't exist in the current codebase

**Resolution**: The codebase may have changed since the plan was written. Verify the current state of the codebase, adapt the implementation to use what actually exists, and document the discrepancy in the Decision Log.

## Verification Command Fails But Implementation Is Correct

**Symptom**: Task verification fails, but the code implementation is correct

**Resolution**: The verification command may be outdated or have incorrect expectations. Fix the verification command in the sprint file, document the correction in Notes, and proceed.

## Task Depends on Something from a Future Sprint

**Symptom**: A task requires functionality that's planned for a later sprint

**Resolution**: This is a planning error. Log it as a blocker, skip the task, and report it. The planner may need to reorder tasks.

## Sprint Has No Tasks — Only Headers

**Symptom**: Sprint file has phase structure but no concrete tasks

**Resolution**: The plan is incomplete. Stop execution and report that the sprint file needs to be populated by `universal-planner`.

## Build Breaks After Implementing a Task

**Symptom**: Tests or build process fails after a task completion

**Resolution**: Diagnose the failure. If the task's implementation is correct but breaks something else, the plan may have missed a dependency. Fix the regression, document it in the Decision Log, and continue.

## Not Sure What Framework/Library to Use

**Symptom**: Task requires a technical decision not specified in the plan

**Resolution**: Always check CONVENTIONS.md first. If the answer isn't there, check the project's `package.json` (or equivalent dependency file). Match what the project already uses. Never introduce a new library when the plan doesn't call for it.

## Related Documents

- **Critical Rules**: See SKILL.md for enforcement rules
- **Decision Log Format**: See [decision-log.md](decision-log.md)
- **Edge Cases**: See SKILL.md "Handling Edge Cases" section
