---
name: obsidian-sync
description: >
  Syncs markdown reports, plans, and documents from the workspace to an Obsidian vault via MCP.
  Trigger: When the user asks to sync, save, move, or store reports/plans/documents to Obsidian.
license: Apache-2.0
metadata:
  author: synapsync
  version: "2.0"
  scope: [root]
  auto_invoke:
    - "sync report to obsidian"
    - "save plan to obsidian"
    - "move documents to obsidian"
    - "store in obsidian"
    - "guardar en obsidian"
    - "sincronizar a obsidian"
  changelog:
    - version: "2.0"
      date: "2026-02-11"
      changes:
        - "Obsidian-native standard integration: full frontmatter schema"
        - "Expanded frontmatter from 5 fields to complete universal schema"
        - "Added Step 5.5: Cross-Reference Validation for batch syncs"
        - "Wiki-link preservation rules"
        - "Expanded type taxonomy to 14 document types"
    - version: "1.0"
      date: "2026-02-10"
      changes:
        - "Initial release with vault browsing, folder selection, and batch sync"
        - "Support for single file, folder, and glob pattern sync"
        - "Auto-generates Obsidian frontmatter from file metadata"
        - "Interactive folder picker via AskUserQuestion"
allowed-tools: Read, Glob, Grep, Bash, ToolSearch, AskUserQuestion
---

## Purpose

Sync markdown reports, plans, and documentation generated in the workspace to an Obsidian vault using the Obsidian MCP server. Acts as the "last mile" helper that takes output produced by other skills (planners, analyzers, reporters) and persists it in the user's knowledge base.

## When to Use This Skill

- User explicitly asks to **sync**, **save**, **move**, or **store** files to Obsidian
- User says "guardar en obsidian", "sincronizar a obsidian", or similar in Spanish
- User asks to **create a report/plan AND save it to Obsidian** (this skill handles the Obsidian part after creation)
- User wants to **browse their vault** to choose where to place documents
- User asks to move an entire folder (e.g., `{output_base}/planning/`) to their Obsidian vault
- After another skill finishes generating documents, user wants them in Obsidian

### When NOT to Use

- User wants to read or search notes already in Obsidian (use MCP tools directly)
- User wants to edit an existing Obsidian note in-place (use MCP tools directly)
- Files are not markdown or text-based (this skill is for `.md` content)

## Critical Rules

**RULE 1 - ALWAYS LOAD MCP TOOLS FIRST**

Before calling ANY Obsidian MCP tool, you MUST use `ToolSearch` to load them:

```
ToolSearch query: "+obsidian write"    # For writing notes
ToolSearch query: "+obsidian list"     # For listing directories
ToolSearch query: "+obsidian read"     # For reading notes
```

Never call `mcp__obsidian__*` tools without loading them first via ToolSearch. They are deferred tools and will fail if not loaded.

**RULE 2 - ALWAYS ASK WHERE TO SAVE**

Never assume the destination folder. Always:
1. List the vault's root directories
2. Let the user pick or specify the destination
3. If the user already specified a path (e.g., "save to work/my-project/plans"), confirm it exists or offer to create it

**RULE 3 - PRESERVE CONTENT INTEGRITY**

- Read the source file completely before writing to Obsidian
- Never modify the document content (headings, tables, code blocks, etc.)
- Only ADD frontmatter metadata if the file doesn't already have it
- If the file already has frontmatter, merge Obsidian-specific fields without overwriting existing ones

**RULE 4 - GENERATE MEANINGFUL FRONTMATTER**

Every note written to Obsidian MUST include frontmatter following the universal schema:

```yaml
---
title: "Document Title"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "{project-name}"
type: "{document-type}"
status: "active"
version: "1.0"
tags: [relevant, tags, here]
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Synced to Obsidian"]
related:
  - "[[related-document]]"
---
```

Infer these values from:
- `title`: First H1 heading in the document, or filename
- `date`: File modification date, or today's date
- `updated`: Today's date (sync date)
- `project`: Current working directory name or git repo name
- `type`: Infer from content using the 14-type taxonomy (see expanded type inference table below)
- `status`: `"active"` for new documents, preserve existing status
- `version`: `"1.0"` for new documents, preserve existing version
- `tags`: Infer from project name, document type, and key topics
- `changelog`: Add sync entry
- `related`: Extract from `[[wiki-links]]` found in document content, or from `## Referencias` section

**RULE 5 - REPORT RESULTS**

After syncing, always report:
- How many files were synced
- The exact Obsidian paths where they were saved
- Any files that were skipped and why

## Configuration Resolution

Before starting any workflow step, resolve the `{output_base}` path that determines where source documents are located.

1. **Check** for `cognitive.config.json` in the project root (current working directory)
2. **If found**: read the `output_base` value and use it for all `{output_base}` references in this skill
3. **If NOT found**:
   a. Infer the project name from the current directory name or git repository name
   b. Ask the user: _"Where are your output documents stored for this project?"_ — suggest `~/obsidian-vault/{project-name}/` as the default
   c. Create `cognitive.config.json` in the project root with their chosen path
   d. Inform the user the config was saved for future skill runs

**Config file format** (`cognitive.config.json`):
```json
{
  "output_base": "~/obsidian-vault/my-project"
}
```

> **IMPORTANT**: Every `{output_base}` reference in this skill depends on this resolution. If the config file cannot be read or created, ask the user for an explicit path before proceeding.

## Obsidian Output Standard

When syncing documents to Obsidian, follow the `obsidian-md-standard`:

1. **Frontmatter enrichment**: If a document has minimal frontmatter (only title/date/project/type/tags), enrich it with the full universal schema (add updated, status, version, changelog, related)
2. **Frontmatter preservation**: If a document already has rich frontmatter, preserve all existing fields — only add missing ones
3. **Frontmatter generation**: If a document has no frontmatter, generate the complete universal schema
4. **Wiki-link preservation**: Never convert `[[wiki-links]]` to `[markdown](links)` — preserve them exactly
5. **Type inference**: Map document content to the 14-type taxonomy defined in the standard
6. **Cross-reference validation**: After syncing a batch of files, verify that `related` fields and `## Referencias` sections are bidirectional — if A references B, B should reference A
7. **Status**: New documents get `status: "active"`, documents with existing status are preserved

## Workflow

### Step 1: Identify What to Sync

Determine the source files from the user's request:

| User Says | Action |
|-----------|--------|
| "sync this report to obsidian" | Identify the most recently created/discussed report in context |
| "move {output_base}/planning/ to obsidian" | Glob all `.md` files in that directory |
| "save 00-strategic-analysis.md to obsidian" | Sync that specific file |
| "sync all reports from today to obsidian" | Find today's `.md` files in `{output_base}/` or similar |
| "create plan X and save to obsidian" | Wait for plan creation, then sync the output |

**Discovery commands:**

```
# Find all markdown files in a directory
Glob pattern: "{output_base}/planning/**/*.md"

# Find recently created reports
Glob pattern: "{output_base}/**/*.md"

# Find specific file
Glob pattern: "**/{filename}.md"
```

### Step 2: Load Obsidian MCP Tools

Always load the required tools before using them:

```
ToolSearch query: "+obsidian list"     # Loads mcp__obsidian__list_directory
ToolSearch query: "+obsidian write"    # Loads mcp__obsidian__write_note
```

Load both in parallel if possible. Only load `read` or `search` if you need to check existing content.

### Step 3: Browse Vault and Present Options

List the vault structure and present folder options to the user:

```
mcp__obsidian__list_directory(path: "/")           # Root level
mcp__obsidian__list_directory(path: "/work")        # One level deeper if needed
```

Build a folder tree and present it using `AskUserQuestion`:

```
AskUserQuestion:
  question: "Where should I save the documents in your Obsidian vault?"
  header: "Vault folder"
  options:
    - label: "work/project-name/plans"
      description: "Inside your project's plans folder"
    - label: "work/project-name/"
      description: "At the project root in your vault"
    - label: "Create new folder"
      description: "I'll create a new folder path for you"
```

**Important behaviors:**
- If the user already specified a destination (e.g., "save to work/agent-sync-sdk/plans"), skip the question and use that path directly
- If a project folder already exists in the vault, suggest it as the first (recommended) option
- Always include "Create new folder" as an option
- If user picks "Create new folder" or "Other", ask for the desired path

### Step 4: Read Source Files

For each file to sync:

1. Read the full content using the `Read` tool
2. Check if frontmatter already exists (starts with `---`)
3. Extract the first H1 heading for the title
4. Determine the project name from cwd or git

### Step 5: Write to Obsidian

For each file, call `mcp__obsidian__write_note` with:

```
mcp__obsidian__write_note(
  path: "{vault-destination}/{filename}.md",
  content: "{file-content-without-frontmatter}",
  frontmatter: {
    "title": "Document Title",
    "date": "2026-02-10",
    "project": "agent-sync-sdk",
    "type": "strategic-analysis",
    "source": "{output_base}/planning/2026-02-10/00-strategic-analysis.md",
    "tags": ["agent-sync-sdk", "strategy", "plan"]
  }
)
```

**Frontmatter generation logic:**

| Field | Source | Fallback |
|-------|--------|----------|
| `title` | First `# Heading` in document | Filename without extension, titlecased |
| `date` | Date in filename or directory path (e.g., `2026-02-10`) | Today's date |
| `project` | Git repo name or directory name | Working directory basename |
| `type` | Infer from content keywords (see table below) | `"note"` |
| `source` | Relative path from workspace root | Absolute path |
| `tags` | Project name + type + key content topics | `[project-name]` |

**Type inference (expanded taxonomy):**

| Content Contains | Type |
|-----------------|------|
| "analysis", "analisis", "report" | `"analysis"` |
| "conventions", "patterns", "convenciones" | `"conventions"` |
| "requirements", "requisitos", "functional" | `"requirements"` |
| "architecture", "arquitectura", "ADR" | `"architecture"` |
| "planning", "plan de trabajo", "strategy", "estrategico" | `"plan"` |
| "execution", "task breakdown", "ejecucion" | `"execution-plan"` |
| "sprint", "todo", "checklist" | `"sprint-plan"` |
| "progress", "dashboard", "tracking" | `"progress"` |
| "technical report", "module analysis", "code analysis" | `"technical-report"` |
| "refactor", "refactoring", "improvement" | `"refactor-plan"` |
| "retrospective", "retro", "keep/problem/learning" | `"retrospective"` |
| "decision", "decision log", "DEC-" | `"decision-log"` |
| "data model", "entity", "ER diagram", "modelo de datos" | `"data-model"` |
| "flow", "sequence diagram", "core flows" | `"flow-diagram"` |
| "deuda tecnica", "technical debt", "code quality" | `"technical-report"` |
| "crecimiento", "growth", "vision" | `"plan"` |

**Wiki-link handling:**
- Preserve all existing `[[wiki-links]]` in document content exactly as-is
- Never convert `[[wiki-links]]` to `[markdown](relative-links)`
- If a document contains `## Referencias` section, preserve it and add to `related` frontmatter field

### Step 5.5: Cross-Reference Validation

After syncing a batch of files (2+ files), validate bidirectional references:

1. **Collect all `related` fields** from the frontmatter of synced files
2. **Collect all `[[wiki-links]]`** found in `## Referencias` sections
3. **For each reference A→B**: Verify that document B also references A
4. **If a reference is one-directional**: Add the missing reverse reference to the document's `related` array and `## Referencias` section
5. **Report any fixes made** in the sync summary

**Example:**
```
Cross-reference validation:
- SPRINT-1-foundation.md references [[PROGRESS]] ✓ (PROGRESS references back)
- ANALYSIS.md references [[CONVENTIONS]] ✓ (CONVENTIONS references back)
- PLANNING.md references [[ANALYSIS]] ⚠ Fixed: added [[PLANNING]] to ANALYSIS.md related
```

This step ensures the knowledge graph has no broken links when documents are synced in batches.

### Step 6: Report Results

After all files are written, report a summary:

```
Synced to Obsidian:
- work/agent-sync-sdk/plans/00-strategic-analysis.md
- work/agent-sync-sdk/plans/01-technical-debt.md
- work/agent-sync-sdk/plans/02-growth-vision.md

3 files synced successfully to vault folder: work/agent-sync-sdk/plans/
```

## Batch Sync Pattern

When syncing an entire folder, process files efficiently:

1. **Glob** all `.md` files in the source directory
2. **Read** all files in parallel (multiple Read calls in one message)
3. **Load** MCP tools once (ToolSearch)
4. **List** vault directory once to build options
5. **Ask** user once for destination (not per file)
6. **Write** all files in sequence (Obsidian MCP may not support parallel writes safely)
7. **Report** all results at the end

## Integration with Other Skills

This skill is designed to be the **output handler** for other skills:

| Producing Skill | What It Creates | obsidian-sync Role |
|----------------|-----------------|-------------------|
| `project-planner` | `{output_base}/planning/{project}/` plans | Sync planning docs to Obsidian |
| `code-analyzer` | `{output_base}/technical/module-analysis/` reports | Sync analysis reports to Obsidian |
| `sdlc-planner` | SDLC Phase 1 & 2 documents | Sync requirements & design docs |
| `universal-planner` | Adaptive planning documents | Sync any planning output |
| Custom team analysis | `{output_base}/planning/` reports | Sync team-generated reports |

**Composition pattern:** When the user says "create a plan and save it to obsidian":
1. The planner skill runs first and produces documents locally
2. This skill then picks up those documents and syncs them to the vault
3. The user only needs one instruction; the skills compose naturally

## Configuration Options

### By Sync Scope

| Scope | Command | Behavior |
|-------|---------|----------|
| **Single file** | "sync this file to obsidian" | Sync one specific file |
| **Directory** | "sync {output_base}/planning/ to obsidian" | Sync all .md files in directory |
| **Pattern** | "sync all reports from today" | Glob and sync matching files |
| **Output** | "create X and save to obsidian" | Wait for creation, then sync |

### By Destination Logic

| Scenario | Behavior |
|----------|----------|
| User specifies path | Use it directly, create folders if needed |
| Project folder exists in vault | Suggest it as recommended option |
| Project folder doesn't exist | Offer to create `work/{project-name}/` |
| Multiple projects in vault | List all and let user choose |

## Best Practices

### Before Sync
- Verify the source files exist and are readable
- Check that the Obsidian MCP server is connected (ToolSearch will fail if not)
- If syncing output from another skill, ensure that skill has completed

### During Sync
- Never modify document content -- only add/merge frontmatter
- Use the `mcp__obsidian__write_note` with `mode: "overwrite"` for clean writes
- If a note already exists at the destination, warn the user before overwriting
- Process files sequentially to avoid MCP race conditions

### After Sync
- Always report the full list of synced paths
- If any files failed, report which ones and why
- Suggest the user check the notes in Obsidian for visual verification

## Limitations

- **Obsidian MCP required**: The Obsidian REST API MCP server must be configured and running
- **Markdown only**: This skill handles `.md` files. Binary assets, images, and non-text files are not synced
- **No bidirectional sync**: This skill writes TO Obsidian, it does not pull changes back from Obsidian
- **No conflict resolution**: If a note exists at the destination, it will be overwritten (with user confirmation)
- **Single vault**: Operates on the vault connected to the MCP server; cannot switch between multiple vaults

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Tool not found: mcp__obsidian__*" | MCP tools not loaded | Run `ToolSearch query: "+obsidian write"` first |
| "MCP server not connected" | Obsidian REST API not running | Start Obsidian and enable the REST API plugin |
| "Permission denied" | Tool not in allowed permissions | Add `mcp__obsidian__write_note` to `.claude/settings.local.json` |
| "Note already exists" | Duplicate sync | Confirm with user before overwriting |
| "Empty content" | Source file doesn't exist | Verify path with `Glob` before reading |
| Frontmatter corruption | File has non-standard frontmatter | Read file first, detect existing frontmatter, merge carefully |

## Example: Full Sync Flow

**User says:** "sincroniza los reportes de {output_base}/planning/2026-02-10/ a obsidian"

**Step 1 - Discover files:**
```
Glob("{output_base}/planning/2026-02-10/**/*.md")
# Found: 00-strategic-analysis.md, 01-technical-debt.md, 02-growth-vision.md
```

**Step 2 - Load MCP tools:**
```
ToolSearch("+obsidian list")
ToolSearch("+obsidian write")
```

**Step 3 - Browse vault:**
```
mcp__obsidian__list_directory(path: "/")
# Found: work/
mcp__obsidian__list_directory(path: "/work")
# Found: agent-sync-sdk/, bmtz/, wdt/
```

**Step 4 - Ask user:**
```
AskUserQuestion:
  "Where should I save the 3 reports in your Obsidian vault?"
  options:
    - "work/agent-sync-sdk/plans (Recommended)"  # Project folder exists
    - "work/agent-sync-sdk/"                       # Project root
    - "Create new folder"
```

**Step 5 - Read & Write:**
```
# Read all 3 files in parallel
Read("{output_base}/planning/2026-02-10/00-strategic-analysis.md")
Read("{output_base}/planning/2026-02-10/01-technical-debt.md")
Read("{output_base}/planning/2026-02-10/02-growth-vision.md")

# Write each to Obsidian with generated frontmatter
mcp__obsidian__write_note(
  path: "work/agent-sync-sdk/plans/00-strategic-analysis.md",
  content: "...",
  frontmatter: { title: "Analisis Estrategico...", date: "2026-02-10", project: "agent-sync-sdk", type: "strategic-analysis", tags: [...] }
)
# ... repeat for each file
```

**Step 6 - Report:**
```
Synced 3 files to Obsidian:
  - work/agent-sync-sdk/plans/00-strategic-analysis.md
  - work/agent-sync-sdk/plans/01-technical-debt.md
  - work/agent-sync-sdk/plans/02-growth-vision.md
```

## Version History

- **2.0** (2026-02-11): Obsidian-native standard — full frontmatter schema, 14-type taxonomy, cross-reference validation, wiki-link preservation
- **1.0** (2026-02-10): Initial release with vault browsing, folder selection, and batch sync
