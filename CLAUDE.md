# CLAUDE.md - SynapSync Registry

## Project Overview

This is the **SynapSync Registry** — the official public registry of cognitives (skills, agents, prompts, workflows, tools). It is a content-only repository with no build system, no dependencies, and no executable code.

Cognitives are reusable AI instructions that help AI assistants understand project patterns and conventions. They work across multiple providers (Claude, OpenAI, Cursor, Windsurf, Copilot, Gemini) and are installed via the `skills` CLI:

```bash
npx skills add owner/repo    # Install cognitives from a registry
npx skills update             # Update installed cognitives
```

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

### Skills
- **skill-creator** (`cognitives/skills/general/skill-creator/`) — Meta-skill for creating new skills with templates. Includes `assets/` with basic and advanced templates.
- **universal-planner** (`cognitives/skills/planning/universal-planner/`) — Unified planning and execution skill with PLAN and EXECUTE modes. Covers new projects, features, refactors, bug fixes, tech debt, and architecture changes. Uses modular assets pattern with 8 modes (2 top-level + 6 planning sub-modes).
- **code-analyzer** (`cognitives/skills/analytics/code-analyzer/`) — Analyzes code modules and generates structured technical reports with architecture diagrams.
- **obsidian** (`cognitives/skills/integrations/obsidian/`) — Unified Obsidian vault manager with SYNC and READ modes. Syncs documents to vault and reads/searches notes via MCP. Includes the Obsidian markdown standard specification and linter as internal assets. Claude-only.
- **sprint-forge** (`cognitives/skills/workflow/sprint-forge/`) — Adaptive sprint workflow with 3 modes (INIT, SPRINT, STATUS). Deep analysis, evolving roadmap, one-at-a-time sprints, formal debt tracking, and re-entry prompts for context persistence. Language-agnostic. Modular assets: 3 modes, 4 helpers, 4 templates.

### Agents
- **feature-branch-manager** (`cognitives/agents/general/feature-branch-manager/`) — Git workflow agent for branch creation, pushing, and PR creation. Claude-only.

## Internal Tooling (not published)

- **cognitive-register** (`core/register/`) — Automates registration of new cognitives into the registry. Used internally by contributors.

## Valid Categories

`general`, `frontend`, `backend`, `database`, `devops`, `security`, `testing`, `analytics`, `automation`, `integrations`, `planning`, `workflow`

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

**Important**: Do NOT put `output_base` in frontmatter. Output paths are resolved per-project at runtime via `cognitive.config.json` (see below).

### Per-Project Output Configuration (`cognitive.config.json`)

Skills that produce output documents (reports, plans, analysis, etc.) use a `{output_base}` variable for all output paths. This variable is resolved at runtime from a per-project config file, allowing each project to have its own output destination.

**Config file**: `cognitive.config.json` at the project root (current working directory).

```json
{
  "output_base": "~/.agents/my-project"
}
```

**How skills resolve `{output_base}`**:
1. Check for `cognitive.config.json` in the project root
2. If found — read `output_base` and use it
3. If not found — ask the user for a path (suggest `~/.agents/{project-name}/`), create the config file, proceed

**When creating a new skill that produces output**, you MUST:
1. Use `{output_base}` for all output paths (e.g., `{output_base}/planning/`, `{output_base}/technical/`)
2. Include a `## Configuration Resolution` section before the Workflow section
3. Never hardcode output paths — no `.synapsync/`, `.agents/`, or absolute paths

**Standard Configuration Resolution section** (copy this into new skills):

```markdown
## Configuration Resolution

Before starting any workflow step, resolve the `{output_base}` path that determines where all output documents are stored.

1. **Check** for `cognitive.config.json` in the project root (current working directory)
2. **If found**: read the `output_base` value and use it for all `{output_base}` references in this skill
3. **If NOT found**:
   a. Infer the project name from the current directory name or git repository name
   b. Ask the user: _"Where should I store output documents for this project?"_ — suggest `~/.agents/{project-name}/` as the default
   c. Create `cognitive.config.json` in the project root with their chosen path
   d. Inform the user the config was saved for future skill runs
```

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
- Skills that produce output MUST use `{output_base}` variable (never hardcoded paths)
- Skills that produce output MUST include a `## Configuration Resolution` section
- No `output_base` field in SKILL.md frontmatter (resolved at runtime via `cognitive.config.json`)

## Working on This Repo

- No build steps, no tests, no package manager — this is a pure content registry
- Changes typically involve adding new cognitives or updating existing ones
- Always keep `registry.json` in sync when adding/removing cognitives
- Empty category directories are intentional placeholders
