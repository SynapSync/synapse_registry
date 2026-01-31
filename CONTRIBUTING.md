# Contributing to SynapSync Registry

Thank you for your interest in contributing to the SynapSync Registry! This guide will help you submit your own cognitives.

## Before You Start

### Checklist

Before creating a cognitive, ensure:

- [ ] Your cognitive is **reusable** - it will benefit multiple users/projects
- [ ] Your cognitive is **stable** - the patterns won't change frequently
- [ ] Your cognitive is **valuable** - it provides guidance beyond obvious best practices
- [ ] A similar cognitive **doesn't already exist** in the registry

## Cognitive Types

| Type | When to Use | File |
|------|-------------|------|
| **Skill** | AI needs specific instructions or patterns | `SKILL.md` |
| **Agent** | Autonomous task execution with specific behaviors | `AGENT.md` |
| **Prompt** | Reusable prompts with variable substitution | `PROMPT.md` |
| **Workflow** | Multi-step processes combining multiple cognitives | `WORKFLOW.yaml` |
| **Tool** | External API integrations | `TOOL.md` |

## Submission Process

### 1. Fork the Repository

```bash
gh repo fork SynapSync/synapse-registry
cd synapse-registry
```

### 2. Create Your Cognitive Folder

```bash
# Pattern: cognitives/{type}s/{category}/{name}/
mkdir -p cognitives/skills/frontend/my-skill
```

### 3. Add Required Files

Every cognitive needs:

1. **`manifest.json`** - Metadata about the cognitive
2. **Content file** - The actual cognitive (SKILL.md, AGENT.md, etc.)

#### manifest.json

```json
{
  "$schema": "https://synapsync.dev/schemas/cognitive-manifest.json",
  "name": "my-skill",
  "type": "skill",
  "version": "1.0.0",
  "description": "Short description (max 100 chars)",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/yourusername"
  },
  "license": "MIT",
  "category": "frontend",
  "tags": ["react", "hooks", "patterns"],
  "providers": ["claude", "openai", "cursor"],
  "file": "SKILL.md",
  "createdAt": "2026-01-28T00:00:00Z",
  "updatedAt": "2026-01-28T00:00:00Z"
}
```

#### SKILL.md (or other content file)

```markdown
---
name: my-skill
description: >
  Short description of what this skill does.
  Trigger: When the AI should use this skill.
license: MIT
metadata:
  author: your-name
  version: "1.0"
  scope: [root]
  auto_invoke: "action that triggers this skill"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Purpose

One clear sentence explaining the skill's goal.

## When to Use This Skill

- Use case 1
- Use case 2
- Use case 3

## Critical Patterns

The most important rules AI must follow.

## Code Examples

\`\`\`typescript
// Your examples here
\`\`\`

## Commands

\`\`\`bash
# Useful commands
npm run build
\`\`\`
```

### 4. Update registry.json

Add your cognitive to the `cognitives` array:

```json
{
  "name": "my-skill",
  "type": "skill",
  "version": "1.0.0",
  "description": "Short description (max 100 chars)",
  "author": "your-name",
  "category": "frontend",
  "tags": ["react", "hooks", "patterns"],
  "providers": ["claude", "openai", "cursor"],
  "downloads": 0,
  "path": "cognitives/skills/frontend/my-skill"
}
```

### 5. Submit Pull Request

```bash
git checkout -b add-my-skill
git add .
git commit -m "Add my-skill cognitive"
git push origin add-my-skill
gh pr create
```

## Validation Requirements

Your PR must pass these validations:

- [ ] **Unique name** - No other cognitive with the same name exists
- [ ] **Valid manifest.json** - Matches the schema
- [ ] **Content file exists** - The file referenced in `manifest.file` exists
- [ ] **Frontmatter matches** - Frontmatter in content file matches manifest
- [ ] **Valid category** - Category is one of the allowed values
- [ ] **Tags limit** - Maximum 10 tags
- [ ] **Description length** - Maximum 100 characters

## Categories

Use one of these categories:

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
| `planning` | Project planning, SDLC, requirements, architecture |

## Provider Compatibility

Specify which AI providers your cognitive works with:

- `claude` - Anthropic Claude
- `openai` - OpenAI GPT
- `cursor` - Cursor IDE
- `windsurf` - Windsurf IDE
- `copilot` - GitHub Copilot
- `gemini` - Google Gemini
- `codex` - OpenAI Codex

## Best Practices

### DO

- Use clear, descriptive names (e.g., `react-hooks`, `api-error-handling`)
- Include specific triggers in your description
- Provide realistic code examples
- Include copy-paste ready commands
- Be explicit about which providers are supported
- Use local file references instead of web URLs

### DON'T

- Use generic names like `utils` or `helpers`
- Use toy examples with `foo`, `bar`, `example1`
- Include sensitive information or API keys
- Duplicate existing cognitives
- Make skills too broad (keep them focused)

## Naming Conventions

| Type | Pattern | Examples |
|------|---------|----------|
| Generic | `{technology}` | `typescript`, `react-hooks` |
| Specific | `{tech}-{feature}` | `react-testing`, `node-logging` |
| Framework | `{framework}-{component}` | `nextjs-api`, `express-middleware` |

## Questions?

- Open an issue: https://github.com/SynapSync/synapse-registry/issues
- Join our Discord: https://discord.gg/synapsync (coming soon)

## License

By contributing, you agree that your contributions will be licensed under the license you specify in your cognitive's manifest.json.
