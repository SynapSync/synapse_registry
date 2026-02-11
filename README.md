# SynapSync Registry

The official public registry of cognitives (skills, agents, prompts, workflows, tools) for SynapSync CLI.

## What is SynapSync?

SynapSync is a CLI tool for orchestrating AI capabilities across multiple providers (Claude, OpenAI, Cursor, Windsurf, Copilot, and more). It manages "cognitives" - reusable AI instructions that help AI assistants understand your project patterns and conventions.

## Installing Cognitives

Use the SynapSync CLI to search and install cognitives:

```bash
# Search for cognitives
synapsync search react

# Install a cognitive
synapsync install skill-creator

# List installed cognitives
synapsync list
```

## Registry Structure

```
synapse-registry/
├── README.md                           # This file
├── CONTRIBUTING.md                     # Guide for contributors
├── registry.json                       # Central index of all cognitives
│
├── cognitives/                         # Public registry content (downloadable)
│   ├── skills/                         # AI instruction skills
│   │   ├── general/                    # General-purpose skills
│   │   ├── frontend/                   # Frontend development
│   │   ├── backend/                    # Backend development
│   │   ├── database/                   # Database & ORMs
│   │   ├── devops/                     # CI/CD & infrastructure
│   │   ├── security/                   # Security analysis
│   │   ├── testing/                    # Testing & QA
│   │   ├── analytics/                  # Data analysis
│   │   ├── automation/                 # Task automation
│   │   ├── planning/                   # Project planning & SDLC
│   │   └── integrations/              # External services & Obsidian
│   │
│   ├── agents/                         # Autonomous AI agents
│   │   ├── general/
│   │   └── automation/
│   │
│   ├── prompts/                        # Reusable prompt templates
│   │   ├── general/
│   │   └── frontend/
│   │
│   ├── workflows/                      # Multi-step AI workflows
│   │   └── devops/
│   │
│   └── tools/                          # External integrations
│       └── integrations/
│
└── core/                               # Internal project tooling (not published)
    └── register/                       # Cognitive registration automation
```

## Available Cognitives

### Skills

| Name | Category | Version | Description |
|------|----------|---------|-------------|
| [skill-creator](cognitives/skills/general/skill-creator/) | general | 3.0.0 | Creates AI skills following SynapSync spec with templates and best practices |
| [project-planner](cognitives/skills/planning/project-planner/) | planning | 1.2.0 | Planning-only framework that produces analysis, planning, and execution-plan documents |
| [sdlc-planner](cognitives/skills/planning/sdlc-planner/) | planning | 1.0.0 | Generates SDLC Phase 1 (Requirements) and Phase 2 (Design) documentation from a product idea |
| [universal-planner](cognitives/skills/planning/universal-planner/) | planning | 1.1.0 | Adaptive planning skill for any software scenario: new projects, features, refactors, and more |
| [universal-planner-executor](cognitives/skills/planning/universal-planner-executor/) | planning | 1.0.0 | Senior developer executor that implements universal-planner sprints and tracks progress |
| [code-analyzer](cognitives/skills/analytics/code-analyzer/) | analytics | 1.0.0 | Analyzes code modules and generates structured technical reports with architecture diagrams |
| [obsidian-sync](cognitives/skills/integrations/obsidian-sync/) | integrations | 1.0.0 | Syncs markdown reports, plans, and documents from the workspace to an Obsidian vault via MCP |
| [obsidian-reader](cognitives/skills/integrations/obsidian-reader/) | integrations | 1.0.0 | Reads, searches, and reasons over Obsidian vault notes as a contextual knowledge source |

### Agents

| Name | Category | Version | Description |
|------|----------|---------|-------------|
| [feature-branch-manager](cognitives/agents/general/feature-branch-manager/) | general | 1.0.0 | Git workflow manager for feature branch creation, pushing changes, and PR creation |

---

## Obsidian Integration

The registry includes two complementary skills that form a **bidirectional knowledge bridge** between the agent's workspace and an [Obsidian](https://obsidian.md) vault. Together, they turn Obsidian into a persistent knowledge layer for AI agents -- plans, reports, decisions, and documentation flow in and out of the vault seamlessly.

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Agent Workspace                          │
│                                                                 │
│  project-planner ──┐                                            │
│  code-analyzer ────┤  produce .md files   ┌──────────────────┐  │
│  sdlc-planner ─────┤ ───────────────────> │  obsidian-sync   │  │
│  universal-planner ┘  (.agents/, .synapsync/) │  (WRITE)    │  │
│                                           └────────┬─────────┘  │
│                                                    │             │
│                                           Obsidian MCP Server    │
│                                                    │             │
│                                           ┌────────▼─────────┐  │
│  Agent needs context ────────────────────>│ obsidian-reader  │  │
│  "what do my notes say about X?"          │  (READ)          │  │
│  "project status from obsidian"           └────────┬─────────┘  │
│                                                    │             │
│                    structured context, summaries,   │             │
│                    source citations, priority ranking│             │
│                                                    ▼             │
│                              Agent uses knowledge to reason      │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 │  mcp__obsidian__*
                                 ▼
                    ┌─────────────────────────┐
                    │     Obsidian Vault       │
                    │                         │
                    │  work/                  │
                    │    project-a/           │
                    │      plans/             │
                    │        00-strategy.md   │
                    │        01-tech-debt.md  │
                    │    project-b/           │
                    │      reports/           │
                    │        analysis.md      │
                    └─────────────────────────┘
```

### The Two Skills

| | obsidian-sync | obsidian-reader |
|---|---|---|
| **Direction** | Workspace **-->** Vault | Vault **-->** Agent |
| **Purpose** | Persist reports, plans, and docs into the vault | Retrieve knowledge from the vault to inform decisions |
| **Trigger** | "sync to obsidian", "save plan to obsidian" | "read from obsidian", "what do my notes say about X?" |
| **MCP Tools** | `write_note`, `list_directory` | `read_note`, `search_notes`, `list_directory`, `get_vault_stats` |
| **Fallback** | N/A (requires MCP to write) | Filesystem read via `Read`/`Glob`/`Grep` if MCP is unavailable |

### How They Work Together

#### 1. Write Flow (obsidian-sync)

When a skill produces documentation (plans, reports, analysis), `obsidian-sync` handles the last mile:

```
User: "create a technical analysis and save it to obsidian"

1. code-analyzer skill runs  -->  produces .agents/reports/analysis.md
2. obsidian-sync activates   -->  reads the local file
3. Lists vault folders       -->  asks user where to save
4. Writes to vault           -->  work/my-project/reports/analysis.md
                                  (with auto-generated frontmatter)
```

**Key behaviors:**
- Auto-generates Obsidian frontmatter (`title`, `date`, `project`, `type`, `tags`) from file content
- Lets the user choose the destination folder interactively
- Supports single file, folder, or glob pattern sync
- Never modifies document content -- only adds metadata

#### 2. Read Flow (obsidian-reader)

When the agent needs context that lives in the vault, `obsidian-reader` retrieves and structures it:

```
User: "what's the current state of agent-sync-sdk?"

1. obsidian-reader activates  -->  loads MCP tools
2. Locates project folder     -->  work/agent-sync-sdk/
3. Reads all project notes    -->  plans/, reports/, etc.
4. Parses frontmatter         -->  extracts type, date, tags
5. Ranks by relevance         -->  active plans > historical
6. Synthesizes answer         -->  "Maturity 3.0/5, top issue: race condition..."
                                   with source citations
```

**Key behaviors:**
- Prioritizes notes by recency, type, and relevance (weighted scoring)
- Follows `[[wikilinks]]` to discover related notes
- Returns structured output with source citations for every claim
- Falls back to filesystem reading if MCP is unavailable

#### 3. Round-Trip: The Knowledge Cycle

The real power emerges when both skills operate across sessions:

```
Session 1 (Monday):
  - Team runs strategic analysis with code-analyzer
  - obsidian-sync saves results to vault
  - Vault now contains: work/my-project/plans/00-strategy.md

Session 2 (Wednesday):
  - User asks: "based on Monday's analysis, what should I work on first?"
  - obsidian-reader retrieves Monday's strategy from the vault
  - Agent uses that context to prioritize today's work

Session 3 (Friday):
  - User creates sprint report
  - obsidian-sync saves it to vault alongside the original strategy
  - Vault now has a growing timeline of project knowledge
```

This creates a **persistent memory** that survives across conversations, projects, and time.

### Frontmatter Contract

Both skills share a common frontmatter schema to ensure interoperability. When `obsidian-sync` writes a note, `obsidian-reader` knows how to interpret it:

```yaml
---
title: "Document Title"              # From first H1 heading or filename
date: "2026-02-10"                   # Creation/sync date
project: "agent-sync-sdk"            # Project identifier
type: "strategic-analysis"           # Document type (see taxonomy)
source: ".agents/plan/2026-02-10/"   # Original workspace path
tags: [strategy, roadmap, plan]      # For cross-cutting discovery
---
```

**Type taxonomy** (used for filtering and priority ranking):

| Type | Priority | Description |
|------|----------|-------------|
| `strategic-analysis` | High | Project strategy and direction |
| `plan` | High | Actionable plans with timelines |
| `sprint-plan` | High | Sprint-level task breakdowns |
| `technical-debt` | High | Known issues and debt tracking |
| `architecture` | Medium | System design and decisions |
| `requirements` | Medium | Feature requirements |
| `growth-vision` | Medium | Growth analysis and vision |
| `analysis` | Medium | General analysis documents |
| `code-review` | Medium | Code review findings |
| `report` | Low | General reports |
| `note` | Low | Unstructured notes |

### Prerequisites

Both skills require the **Obsidian MCP server** for full functionality:

1. **Install Obsidian** and open your vault
2. **Install the Local REST API plugin** in Obsidian (Community Plugins > Local REST API)
3. **Configure the MCP server** in your Claude Code settings (`~/.claude/.mcp.json`):

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": ["-y", "obsidian-mcp"],
      "env": {
        "OBSIDIAN_API_KEY": "your-api-key",
        "OBSIDIAN_API_URL": "https://127.0.0.1:27124"
      }
    }
  }
}
```

4. **Grant permissions** in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__obsidian__list_directory",
      "mcp__obsidian__write_note",
      "mcp__obsidian__read_note",
      "mcp__obsidian__search_notes",
      "mcp__obsidian__get_vault_stats"
    ]
  }
}
```

> `obsidian-reader` can fall back to direct filesystem access if the MCP server is not available, but `obsidian-sync` requires MCP for writing.

### Usage Examples

```bash
# Write to Obsidian
"sync .agents/plan/ to obsidian"
"create a technical report and save it to obsidian"
"move today's reports to my vault"

# Read from Obsidian
"what do my obsidian notes say about the project?"
"search obsidian for architecture decisions"
"give me context from my vault for this task"
"summarize the plans in work/agent-sync-sdk/"

# Combined workflows
"analyze this module, generate a report, and save it to obsidian"
"check my obsidian notes for the last sprint plan, then create the next one"
```

### Integration with Other Skills

The Obsidian skills are designed to compose with every other skill in the registry:

```
┌─────────────────────┐     produces      ┌───────────────┐     writes     ┌──────────┐
│  project-planner    │ ──────────────── > │ .md documents │ ─────────── > │          │
│  code-analyzer      │                   │ in workspace  │               │ Obsidian │
│  sdlc-planner       │                   └───────────────┘               │  Vault   │
│  universal-planner  │                          ▲                        │          │
│  (any future skill) │                          │                        │          │
└─────────────────────┘                   obsidian-sync                   │          │
                                                                          │          │
┌─────────────────────┐     consumes      ┌───────────────┐     reads     │          │
│  project-planner    │ < ──────────────  │   structured  │ < ────────── │          │
│  universal-planner  │                   │   context     │               │          │
│  any decision task  │                   └───────────────┘               │          │
│  (any future skill) │                          ▲                        │          │
└─────────────────────┘                   obsidian-reader                  └──────────┘
```

| Producing Skill | What It Creates | obsidian-sync Persists | obsidian-reader Retrieves |
|----------------|-----------------|----------------------|--------------------------|
| `project-planner` | Planning documents | Analysis, planning, execution plans | Historical plans as context for new planning |
| `code-analyzer` | Technical reports | Module analysis with Mermaid diagrams | Architecture knowledge for future analysis |
| `sdlc-planner` | SDLC Phase 1 & 2 | Requirements and design docs | Previous phases to inform next ones |
| `universal-planner` | Adaptive plans | Any planning output | Past decisions and strategies |
| Custom team analysis | Ad-hoc reports | Team-generated deliverables | Organizational knowledge over time |

---

## Cognitive Types

| Type | Description | File |
|------|-------------|------|
| **Skill** | Reusable instructions for AI assistants | `SKILL.md` |
| **Agent** | Autonomous AI entities with specific behaviors | `AGENT.md` |
| **Prompt** | Reusable prompt templates with variables | `PROMPT.md` |
| **Workflow** | Multi-step processes combining agents and prompts | `WORKFLOW.yaml` |
| **Tool** | External integrations and functions | `TOOL.md` |

## Categories

| Category | Description |
|----------|-------------|
| `general` | General-purpose cognitives |
| `frontend` | UI, React, CSS, components |
| `backend` | APIs, servers, backend services |
| `database` | Database queries, migrations, ORMs |
| `devops` | CI/CD, infrastructure, deployment |
| `security` | Security analysis, vulnerability scanning |
| `testing` | Testing strategies, QA automation |
| `analytics` | Data analysis, research, benchmarking |
| `automation` | Task automation, workflows |
| `integrations` | External services, Obsidian, and knowledge management |
| `planning` | Project planning, SDLC, requirements, architecture |

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to submit your own cognitives.

### Quick Start

1. Fork this repository
2. Create a folder: `cognitives/{type}s/{category}/{your-cognitive-name}/`
3. Add `manifest.json` and your cognitive file (e.g., `SKILL.md`)
4. Add an entry to `registry.json`
5. Submit a Pull Request

## Links

- **SynapSync CLI**: https://github.com/SynapSync/synapse-cli
- **Documentation**: https://synapsync.dev/docs
- **Issues**: https://github.com/SynapSync/synapse-registry/issues

## License

All cognitives in this registry are individually licensed. Check each cognitive's `manifest.json` for its specific license.

The registry structure and tooling are licensed under MIT.
