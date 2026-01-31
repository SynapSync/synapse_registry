# CLAUDE.md - SynapSync Registry

## Project Overview

This is the **SynapSync Registry** — the official public registry of cognitives (skills, agents, prompts, workflows, tools) for the SynapSync CLI. It is a content-only repository with no build system, no dependencies, and no executable code.

SynapSync is a CLI tool for orchestrating AI capabilities across multiple providers (Claude, OpenAI, Cursor, Windsurf, Copilot, Gemini). Cognitives are reusable AI instructions that help AI assistants understand project patterns and conventions.

## Repository Structure

```
synapse-registry/
├── registry.json                        # Central index of all cognitives (source of truth)
├── cognitives/                          # Public registry content (downloadable)
│   ├── skills/{category}/{name}/        # AI instruction skills (SKILL.md + manifest.json)
│   ├── agents/{category}/{name}/        # Autonomous AI agents (AGENT.md + manifest.json)
│   ├── prompts/{category}/{name}/       # Reusable prompt templates (PROMPT.md + manifest.json)
│   ├── workflows/{category}/{name}/     # Multi-step processes (WORKFLOW.yaml + manifest.json)
│   └── tools/{category}/{name}/         # External integrations (TOOL.md + manifest.json)
└── core/                                # Internal project tooling (not published)
    └── register/                        # Cognitive registration automation
```

Every cognitive lives in `cognitives/{type}s/{category}/{name}/` and must contain:
1. `manifest.json` — metadata, version, author, tags, provider compatibility
2. A content file — `SKILL.md`, `AGENT.md`, `PROMPT.md`, `WORKFLOW.yaml`, or `TOOL.md`

## Current Cognitives

- **skill-creator** (`cognitives/skills/general/skill-creator/`) — Meta-skill for creating new skills with templates. Includes `assets/` with basic and advanced templates.
- **feature-branch-manager** (`cognitives/agents/general/feature-branch-manager/`) — Git workflow agent for branch creation, pushing, and PR creation. Claude-only.
- **project-planner** (`cognitives/skills/planning/project-planner/`) — Planning-only framework that produces analysis, planning, and execution-plan documents.
- **code-analyzer** (`cognitives/skills/analytics/code-analyzer/`) — Analyzes code modules and generates structured technical reports with architecture diagrams.
- **sdlc-planner** (`cognitives/skills/planning/sdlc-planner/`) — Generates SDLC Phase 1 (Requirements) and Phase 2 (Design) documentation from a product idea.

## Internal Tooling (not published)

- **cognitive-register** (`core/register/`) — Automates registration of new cognitives into the registry. Used internally by contributors.

## Valid Categories

`general`, `frontend`, `backend`, `database`, `devops`, `security`, `testing`, `analytics`, `automation`, `integrations`, `planning`

## Valid Providers

`claude`, `openai`, `cursor`, `windsurf`, `copilot`, `gemini`, `codex`

## Cognitive Types

| Type | Content File | Description |
|------|-------------|-------------|
| skill | `SKILL.md` | Reusable AI instructions with YAML frontmatter |
| agent | `AGENT.md` or `{name}.md` | Autonomous AI entities with specific behaviors |
| prompt | `PROMPT.md` | Reusable prompts with variable substitution |
| workflow | `WORKFLOW.yaml` | Multi-step processes combining multiple cognitives |
| tool | `TOOL.md` | External API integrations |

## Key Conventions

### manifest.json Schema

```json
{
  "$schema": "https://synapsync.dev/schemas/cognitive-manifest.json",
  "name": "cognitive-name",
  "type": "skill|agent|prompt|workflow|tool",
  "version": "semver",
  "description": "Max 100 characters",
  "author": { "name": "", "url": "", "email": "" },
  "license": "Apache-2.0",
  "category": "one of the valid categories",
  "tags": ["max", "10", "tags"],
  "providers": ["claude", "openai"],
  "file": "SKILL.md",
  "repository": { "type": "git", "url": "" },
  "createdAt": "ISO 8601",
  "updatedAt": "ISO 8601"
}
```

### registry.json

The central index at the root. When adding a cognitive, an entry must also be added here with: `name`, `type`, `version`, `description`, `author`, `category`, `tags`, `providers`, `downloads` (starts at 0), and `path`.

### Naming Conventions

- Use kebab-case for cognitive names: `react-hooks`, `api-error-handling`
- Names should be descriptive, not generic (`utils`, `helpers` are bad)
- Pattern: `{technology}`, `{tech}-{feature}`, or `{framework}-{component}`

### SKILL.md Frontmatter

Skills use YAML frontmatter with: `name`, `description`, `license`, `metadata` (author, version, scope, auto_invoke), and `allowed-tools`.

## Commit Convention

This project uses conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, etc. with optional scope in parentheses (e.g., `feat(agents): ...`).

## Validation Rules (for PRs)

- Cognitive name must be unique across the registry
- `manifest.json` must match the schema
- Content file referenced in `manifest.file` must exist
- Frontmatter in content file must match manifest metadata
- Category must be from the valid categories list
- Maximum 10 tags per cognitive
- Description maximum 100 characters

## Working on This Repo

- No build steps, no tests, no package manager — this is a pure content registry
- Changes typically involve adding new cognitives or updating existing ones
- Always keep `registry.json` in sync when adding/removing cognitives
- Empty category directories are intentional placeholders
