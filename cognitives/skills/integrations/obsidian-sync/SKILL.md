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
   b. Ask the user: _"Where are your output documents stored for this project?"_ — suggest `~/.agents/{project-name}/` as the default
   c. Create `cognitive.config.json` in the project root with their chosen path
   d. Inform the user the config was saved for future skill runs

**Config file format** (`cognitive.config.json`):
```json
{
  "output_base": "~/.agents/my-project"
}
```

> **IMPORTANT**: Every `{output_base}` reference in this skill depends on this resolution. If the config file cannot be read or created, ask the user for an explicit path before proceeding.

## Obsidian Output Standard

When syncing documents to Obsidian, follow the `obsidian-md-standard` Sync Profile:

1. **Frontmatter enrichment**: If a document has minimal frontmatter (only title/date/project/type/tags), enrich it with the full universal schema (add updated, status, version, changelog, related)
2. **Frontmatter preservation**: If a document already has rich frontmatter, preserve all existing fields — only add missing ones
3. **Frontmatter generation**: If a document has no frontmatter, generate the complete universal schema (see [assets/helpers/frontmatter-generator.md](assets/helpers/frontmatter-generator.md))
4. **Wiki-link preservation**: Never convert `[[wiki-links]]` to `[markdown](links)` — preserve them exactly
5. **Type inference**: Map document content to the 14-type taxonomy defined in [obsidian-md-standard](../obsidian-md-standard/SKILL.md#2-document-type-taxonomy)
6. **Cross-reference validation**: After syncing a batch of files, verify that `related` fields and `## Referencias` sections are bidirectional (see [assets/helpers/cross-ref-validator.md](assets/helpers/cross-ref-validator.md))
7. **Status**: New documents get `status: "active"`, documents with existing status are preserved

## Workflow

### Step 1: Identify What to Sync

Use `Glob` to discover source files based on user request (specific file, directory, pattern, or recent output).

### Step 2: Load Obsidian MCP Tools

Load required tools: `ToolSearch query: "+obsidian list"` and `ToolSearch query: "+obsidian write"`

### Step 3: Browse Vault and Present Options

List vault structure with `mcp__obsidian__list_directory`, build folder tree, present options via `AskUserQuestion`. If user specified destination, use it directly. Always include "Create new folder" option.

### Step 4: Read Source Files

Read all files in parallel using `Read` tool. Check for existing frontmatter, extract metadata.

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

**Frontmatter generation:**

See [assets/helpers/frontmatter-generator.md](assets/helpers/frontmatter-generator.md) for the complete frontmatter generation workflow.

**Type inference:**

Refer to [obsidian-md-standard](../obsidian-md-standard/SKILL.md#2-document-type-taxonomy) for the 14-type document taxonomy used in type inference.

**Wiki-link handling:**
- Preserve all existing `[[wiki-links]]` in document content exactly as-is
- Never convert `[[wiki-links]]` to `[markdown](relative-links)`
- If a document contains `## Referencias` section, preserve it and add to `related` frontmatter field

### Step 5.5: Cross-Reference Validation

After syncing a batch of files (2+ files), validate bidirectional references.

See [assets/helpers/cross-ref-validator.md](assets/helpers/cross-ref-validator.md) for the complete cross-reference validation workflow.

**Example output:**
```
Cross-reference validation:
- SPRINT-1-foundation.md references [[PROGRESS]] ✓ (PROGRESS references back)
- ANALYSIS.md references [[CONVENTIONS]] ✓ (CONVENTIONS references back)
- PLANNING.md references [[ANALYSIS]] ⚠ Fixed: added [[PLANNING]] to ANALYSIS.md related
```

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

When syncing an entire folder, process files efficiently to minimize latency and user interaction.

See [assets/helpers/batch-sync-pattern.md](assets/helpers/batch-sync-pattern.md) for the complete optimized batch sync workflow.

**Key principles:**
1. **Glob** all `.md` files once
2. **Read** all files in parallel
3. **Load** MCP tools once
4. **List** vault directory once
5. **Ask** user once for destination
6. **Write** all files sequentially
7. **Validate** cross-references after all writes
8. **Report** all results at the end

## Integration with Other Skills

This skill is the **output handler** for planning, analysis, and reporting skills. Composition pattern: producer skill generates documents locally → obsidian-sync picks them up and syncs to vault. User says "create X and save to obsidian" — both steps happen automatically.

## Configuration Options

**Sync Scope**: Single file, directory, glob pattern, or output from another skill.
**Destination Logic**: Use user-specified path, suggest existing project folder, offer to create new folder, or list multiple projects for selection.

## Best Practices

- **Before Sync**: Verify source files exist, MCP server connected, producer skill completed
- **During Sync**: Never modify content (only frontmatter), process writes sequentially, warn before overwriting
- **After Sync**: Report all synced paths, any failures, and suggest visual verification in Obsidian

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

See [assets/examples/smoke-test.md](assets/examples/smoke-test.md) for a complete end-to-end sync example with verification steps.

## Version History

- **2.0** (2026-02-11): Obsidian-native standard — full frontmatter schema, 14-type taxonomy, cross-reference validation, wiki-link preservation
- **1.0** (2026-02-10): Initial release with vault browsing, folder selection, and batch sync
