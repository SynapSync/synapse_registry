# Frontmatter Generation Helper

## Purpose

Generate Obsidian-native YAML frontmatter for markdown documents following the universal schema defined in the [Obsidian markdown standard](../standards/obsidian-md-standard.md). This helper extracts metadata from document content and infers missing fields using intelligent fallbacks.

## When to Use

- When syncing a document that has no existing frontmatter
- When enriching a document that has minimal frontmatter (only title/date/project/type/tags)
- When generating frontmatter for documents produced by other SynapSync skills

## Workflow

### Step 1: Check for Existing Frontmatter

Read the document and determine if it already has frontmatter:

```markdown
---
existing: "frontmatter"
---

# Document content...
```

**Decision tree:**
- **No frontmatter** → Generate complete universal schema
- **Minimal frontmatter** (5 fields or fewer) → Enrich with missing fields
- **Rich frontmatter** (6+ fields) → Preserve all, only add missing required fields

### Step 2: Extract Metadata from Content

| Field | Extraction Source | Example |
|-------|------------------|---------|
| `title` | First `# Heading` in document | `# Strategic Analysis` → `"Strategic Analysis"` |
| `date` | Date in filename (`YYYY-MM-DD`) or directory path | `2026-02-10/report.md` → `"2026-02-10"` |
| `project` | Git repo name or working directory basename | `agent-sync-sdk/` → `"agent-sync-sdk"` |
| `type` | Content-based inference (see Type Inference below) | "analysis", "sprint", "strategic" keywords → `"plan"` |
| `tags` | Project name + type + key content topics | `["agent-sync-sdk", "plan", "strategy"]` |

### Step 3: Infer Document Type

Refer to the [Obsidian markdown standard](../standards/obsidian-md-standard.md) for the complete 14-type taxonomy.

**Quick mapping table** (see full taxonomy in [standards/obsidian-md-standard.md](../standards/obsidian-md-standard.md)):

| Content Keywords | Type |
|-----------------|------|
| "analysis", "analisis", "report" | `analysis` |
| "conventions", "patterns" | `conventions` |
| "requirements", "requisitos" | `requirements` |
| "architecture", "arquitectura", "ADR" | `architecture` |
| "planning", "strategy", "estrategico" | `plan` |
| "execution", "task breakdown" | `execution-plan` |
| "sprint", "todo", "checklist" | `sprint-plan` |
| "progress", "dashboard", "tracking" | `progress` |
| "technical report", "module analysis" | `technical-report` |
| "refactor", "refactoring" | `refactor-plan` |
| "retrospective", "retro", "keep/problem" | `retrospective` |
| "decision", "decision log", "DEC-" | `decision-log` |
| "data model", "entity", "ER diagram" | `data-model` |
| "flow", "sequence diagram" | `flow-diagram` |

**Fallback:** If no keywords match, use `"analysis"` (the most general type in the 14-type taxonomy).

### Step 4: Generate Field Mappings

| Field | Source | Fallback |
|-------|--------|----------|
| `title` | First `# Heading` | Filename (titlecased, no extension) |
| `date` | Filename/path date pattern | Today's date (YYYY-MM-DD) |
| `updated` | N/A | Today's date (sync date) |
| `project` | Git repo name or cwd basename | Working directory basename |
| `type` | Content inference (Step 3) | `"analysis"` |
| `status` | Preserve existing or `"active"` for new | `"active"` |
| `version` | Preserve existing or `"1.0"` for new | `"1.0"` |
| `tags` | `[project, type, ...topics]` | `[project]` |
| `changelog` | Preserve existing or new entry | `[{"version": "1.0", "date": "YYYY-MM-DD", "changes": ["Synced to Obsidian"]}]` |
| `related` | Extract from `[[wiki-links]]` in content or `## Referencias` | `[]` |

### Step 5: Build Frontmatter Object

Construct the final frontmatter object following the universal schema:

```yaml
---
title: "Document Title"
date: "2026-02-10"
updated: "2026-02-12"
project: "agent-sync-sdk"
type: "plan"
status: "active"
version: "1.0"
tags:
  - "agent-sync-sdk"
  - "plan"
  - "strategy"
changelog:
  - version: "1.0"
    date: "2026-02-12"
    changes: ["Synced to Obsidian"]
related:
  - "[[ANALYSIS]]"
  - "[[CONVENTIONS]]"
---
```

### Step 6: Handle Extended Fields (Optional)

For specific document types, add extended fields as defined in the [Obsidian markdown standard](../standards/obsidian-md-standard.md):

| Field | Applicable Types | Extraction |
|-------|-----------------|------------|
| `sprint` | sprint-plan, progress, retrospective | Extract number from filename: `SPRINT-2-name.md` → `2` |
| `phase` | sprint-plan, execution-plan | Extract from content or filename |
| `progress` | sprint-plan, progress | `0` for new, preserve for existing |
| `previous_doc` | sprint-plan, retrospective | `"[[SPRINT-{N-1}-name]]"` |
| `next_doc` | sprint-plan | `"[[SPRINT-{N+1}-name]]"` |
| `parent_doc` | any child document | `"[[PROGRESS]]"` or `"[[README]]"` |

## Merge Rules

When enriching existing frontmatter:

1. **Never overwrite existing fields** — preserve all values already present
2. **Add missing required fields** — ensure title, date, updated, project, type, status, version, tags, changelog, related exist
3. **Preserve field order** — place new fields after existing ones or follow schema order
4. **Update `updated` date** — always set to today's date (sync date)
5. **Append to `changelog`** — add new entry without removing existing ones

## Example: Full Generation

**Input document** (no frontmatter):

```markdown
# Strategic Analysis — Agent Sync SDK

This document provides an analysis of the current architecture...

## Key Findings

...

## Referencias

**Parent:** [[PROGRESS]]
**Input Documents:** [[CONVENTIONS]], [[REQUIREMENTS]]
```

**Generated frontmatter:**

```yaml
---
title: "Strategic Analysis — Agent Sync SDK"
date: "2026-02-10"
updated: "2026-02-12"
project: "agent-sync-sdk"
type: "analysis"
status: "active"
version: "1.0"
tags:
  - "agent-sync-sdk"
  - "analysis"
  - "strategic"
  - "architecture"
changelog:
  - version: "1.0"
    date: "2026-02-12"
    changes: ["Synced to Obsidian"]
related:
  - "[[PROGRESS]]"
  - "[[CONVENTIONS]]"
  - "[[REQUIREMENTS]]"
---
```

## Example: Enrichment

**Input document** (minimal frontmatter):

```markdown
---
title: "Sprint 2: Core Implementation"
date: "2026-02-10"
project: "agent-sync-sdk"
type: "sprint-plan"
tags: ["agent-sync-sdk", "sprint-2"]
---

# Sprint 2: Core Implementation

...
```

**Enriched frontmatter:**

```yaml
---
title: "Sprint 2: Core Implementation"
date: "2026-02-10"
updated: "2026-02-12"
project: "agent-sync-sdk"
type: "sprint-plan"
status: "active"
version: "1.0"
sprint: 2
progress: 0
previous_doc: "[[SPRINT-1-foundation]]"
parent_doc: "[[PROGRESS]]"
tags:
  - "agent-sync-sdk"
  - "sprint-2"
changelog:
  - version: "1.0"
    date: "2026-02-12"
    changes: ["Synced to Obsidian"]
related: []
---
```

## Best Practices

1. **Always reference the Obsidian markdown standard for type taxonomy** — see [../standards/obsidian-md-standard.md](../standards/obsidian-md-standard.md)
2. **Extract wiki-links from content** — scan for `[[filename]]` patterns and add to `related` array
3. **Preserve content integrity** — never modify document content, only add/merge frontmatter
4. **Use intelligent fallbacks** — infer missing data from context rather than leaving fields empty
5. **Follow merge rules** — when enriching, never overwrite existing user-defined values
