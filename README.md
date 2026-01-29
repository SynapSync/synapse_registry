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
├── skills/                             # AI instruction skills
│   ├── general/                        # General-purpose skills
│   ├── frontend/                       # Frontend development
│   ├── backend/                        # Backend development
│   ├── database/                       # Database & ORMs
│   ├── devops/                         # CI/CD & infrastructure
│   ├── security/                       # Security analysis
│   ├── testing/                        # Testing & QA
│   ├── analytics/                      # Data analysis
│   ├── automation/                     # Task automation
│   └── integrations/                   # External services
│
├── agents/                             # Autonomous AI agents
│   ├── general/
│   └── automation/
│
├── prompts/                            # Reusable prompt templates
│   ├── general/
│   └── frontend/
│
├── workflows/                          # Multi-step AI workflows
│   └── devops/
│
└── tools/                              # External integrations
    └── integrations/
```

## Available Cognitives

### Skills

| Name | Category | Version | Description |
|------|----------|---------|-------------|
| [skill-creator](skills/general/skill-creator/) | general | 3.0.0 | Creates AI skills following SynapSync spec with templates and best practices |
| [project-planner](skills/workflow/project-planner/) | workflow | 1.2.0 | Planning-only framework that produces analysis, planning, and execution-plan documents |
| [cognitive-register](skills/general/cognitive-register/) | general | 1.0.0 | Registers new cognitives into the SynapSync Registry with proper structure and validation |
| [code-analyzer](skills/analytics/code-analyzer/) | analytics | 1.0.0 | Analyzes code modules and generates structured technical reports with architecture diagrams |

### Agents

| Name | Category | Version | Description |
|------|----------|---------|-------------|
| [feature-branch-manager](agents/general/feature-branch-manager/) | general | 1.0.0 | Git workflow manager for feature branch creation, pushing changes, and PR creation |

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
| `integrations` | External services (Supabase, Stripe, etc.) |

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to submit your own cognitives.

### Quick Start

1. Fork this repository
2. Create a folder: `{type}s/{category}/{your-cognitive-name}/`
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
