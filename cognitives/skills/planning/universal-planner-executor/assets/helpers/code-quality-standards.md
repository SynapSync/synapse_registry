# Code Quality Standards

Production-quality standards to follow during task implementation (Role 1: Senior Developer).

## General

- Follow the project's existing code style — do not impose a different style
- Use meaningful variable and function names consistent with CONVENTIONS.md naming patterns
- Keep functions focused — one responsibility per function
- Handle errors at system boundaries (user input, API calls, file I/O)
- No magic numbers — use named constants
- No dead code — if something is removed, it's gone completely

## Frontend (when applicable)

- Use the project's existing component library — never create raw HTML elements when a component exists
- Follow the existing state management pattern
- Follow the existing styling approach (CSS modules, Tailwind, styled-components — whatever CONVENTIONS.md says)
- Ensure accessibility basics (semantic HTML, aria labels, keyboard navigation)
- Follow responsive patterns already established in the project

## Backend (when applicable)

- Follow the existing API route patterns and conventions
- Use the existing error handling approach (custom error classes, middleware, etc.)
- Follow the existing validation pattern (Zod, Joi, class-validator — whatever is in use)
- Use existing database access patterns (ORM, query builder, raw SQL — match what exists)
- Follow existing authentication and authorization patterns

## Testing (when applicable)

- Write tests using the project's testing framework and patterns
- Place test files where CONVENTIONS.md says they go
- Follow existing mocking and fixture patterns
- Test the behavior described in the task's acceptance criteria
- Run the existing test suite after changes to ensure no regressions

## Git Practices

- Commit after each completed phase (not after each subtask — too granular)
- Use conventional commit messages that reference the sprint and phase:
  ```
  feat(sprint-1): complete Phase 1.1 — database schema setup
  ```
- Do not commit broken code — verification must pass before committing
- Do not push to remote unless explicitly requested

## Cross-References

- **CONVENTIONS.md**: Project-specific patterns override these defaults
- **PLANNING.md**: Strategy context for architectural decisions
- **Sprint tasks**: Acceptance criteria define what "done" means
