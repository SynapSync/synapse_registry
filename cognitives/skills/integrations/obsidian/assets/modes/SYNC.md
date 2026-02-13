# SYNC Mode - Write to Obsidian Vault

## When to Use This Mode

- User explicitly asks to **sync**, **save**, **move**, or **store** files to Obsidian
- (ES) User says "guardar en obsidian", "sincronizar a obsidian", or similar in Spanish
- User asks to **create a report/plan AND save it to Obsidian** (this mode handles the Obsidian part after creation)
- User wants to **browse their vault** to choose where to place documents
- User asks to move an entire folder (e.g., `{output_base}/planning/`) to their Obsidian vault
- After another skill finishes generating documents, user wants them in Obsidian

## When NOT to Use This Mode

- User wants to read or search notes already in Obsidian (use READ mode)
- User wants to edit an existing Obsidian note in-place (use MCP tools directly)
- Files are not markdown or text-based (this mode is for `.md` content)

---

## Critical Rules

**RULE 1 - ALWAYS ASK WHERE TO SAVE**

Never assume the destination folder. Always:
1. List the vault's root directories
2. Let the user pick or specify the destination
3. If the user already specified a path (e.g., "save to work/my-project/plans"), confirm it exists or offer to create it

**RULE 2 - PRESERVE CONTENT INTEGRITY**

- Read the source file completely before writing to Obsidian
- Never modify the document body content (headings, paragraphs, tables, code blocks, `## Referencias` section)
- Only ADD or MERGE frontmatter metadata — never edit anything below the closing `---`
- If the file already has frontmatter, merge Obsidian-specific fields without overwriting existing ones
- Cross-reference fixes (via cross-ref-validator) update the `related` frontmatter array only

**RULE 3 - GENERATE MEANINGFUL FRONTMATTER**

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

**RULE 4 - REPORT RESULTS**

After syncing, always report:
- How many files were synced
- The exact Obsidian paths where they were saved
- Any files that were skipped and why

---

## Obsidian Output Standard

When syncing documents to Obsidian, follow the [Obsidian markdown standard](../standards/obsidian-md-standard.md) Sync rules:

1. **Frontmatter enrichment**: If a document has minimal frontmatter (only title/date/project/type/tags), enrich it with the full universal schema (add updated, status, version, changelog, related)
2. **Frontmatter preservation**: If a document already has rich frontmatter, preserve all existing fields — only add missing ones
3. **Frontmatter generation**: If a document has no frontmatter, generate the complete universal schema (see [../helpers/frontmatter-generator.md](../helpers/frontmatter-generator.md))
4. **Wiki-link preservation**: Never convert `[[wiki-links]]` to `[markdown](links)` — preserve them exactly
5. **Type inference**: Map document content to the 14-type taxonomy defined in the [Obsidian markdown standard](../standards/obsidian-md-standard.md)
6. **Cross-reference validation**: After syncing a batch of files, verify that `related` fields and `## Referencias` sections are bidirectional (see [../helpers/cross-ref-validator.md](../helpers/cross-ref-validator.md))
7. **Status**: New documents get `status: "active"`, documents with existing status are preserved

---

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

> **Important**: `content` is the raw markdown body **without** the `---` frontmatter block. `frontmatter` is a **separate JSON object** — the MCP server serializes it as YAML and prepends it to the content automatically. If the `path` includes directories that don't exist, they are created.

```
mcp__obsidian__write_note(
  path: "{vault-destination}/{filename}.md",
  content: "{markdown-body-without-frontmatter-block}",
  frontmatter: {
    "title": "Document Title",
    "date": "2026-02-10",
    "updated": "2026-02-12",
    "project": "agent-sync-sdk",
    "type": "analysis",
    "status": "active",
    "version": "1.0",
    "source": "{output_base}/planning/2026-02-10/00-strategic-analysis.md",
    "tags": ["agent-sync-sdk", "analysis", "strategy"],
    "changelog": [{"version": "1.0", "date": "2026-02-12", "changes": ["Synced to Obsidian"]}],
    "related": ["[[01-technical-debt]]", "[[02-growth-vision]]"]
  }
)
```

**Frontmatter generation:**

See [../helpers/frontmatter-generator.md](../helpers/frontmatter-generator.md) for the complete frontmatter generation workflow.

**Type inference:**

Refer to the [Obsidian markdown standard](../standards/obsidian-md-standard.md) for the 14-type document taxonomy used in type inference.

**Wiki-link handling:**
- Preserve all existing `[[wiki-links]]` in document content exactly as-is
- Never convert `[[wiki-links]]` to `[markdown](relative-links)`
- If a document contains `## Referencias` section, preserve it and add to `related` frontmatter field

### Step 5.5: Cross-Reference Validation

After syncing a batch of files (2+ files), validate bidirectional references.

See [../helpers/cross-ref-validator.md](../helpers/cross-ref-validator.md) for the complete cross-reference validation workflow.

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

---

## Batch Sync Pattern

When syncing an entire folder, process files efficiently to minimize latency and user interaction.

See [../helpers/batch-sync-pattern.md](../helpers/batch-sync-pattern.md) for the complete optimized batch sync workflow.

**Key principles:**
1. **Glob** all `.md` files once
2. **Read** all files in parallel
3. **Load** MCP tools once
4. **List** vault directory once
5. **Ask** user once for destination
6. **Write** all files sequentially
7. **Validate** cross-references after all writes
8. **Report** all results at the end

---

## Integration with Other Skills

This mode is the **output handler** for planning, analysis, and reporting skills. Composition pattern: producer skill generates documents locally → obsidian SYNC mode picks them up and syncs to vault. User says "create X and save to obsidian" — both steps happen automatically.

---

## Configuration Options

**Sync Scope**: Single file, directory, glob pattern, or output from another skill.
**Destination Logic**: Use user-specified path, suggest existing project folder, offer to create new folder, or list multiple projects for selection.

---

## Output Format Contract

Every SYNC operation MUST produce a response with these sections in this order:

```markdown
### Source Files
- {N} files detected in `{source_path}`
- [list each filename]

### Destination
- Vault folder: `{vault_destination}`
- [Created / Already existed]

### Write Results
| File | Status | Vault Path |
|------|--------|------------|
| {filename} | Synced | {vault_path} |
| {filename} | Skipped (already exists) | — |
| {filename} | Failed: {reason} | — |

### Cross-Reference Validation
- {N} bidirectional references verified
- {N} frontmatter fixes applied
- [list each fix if any]

### Warnings
- [any overwrites, missing sources, MCP issues — or "None"]
```

**Rules:**
- Always include all 5 sections, even if empty (use "None" or "N/A")
- Never omit Write Results — the user must know exactly what was written and where
- Failed writes must include the reason

---

## Best Practices

- **Before Sync**: Verify source files exist, MCP server connected, producer skill completed
- **During Sync**: Never modify content (only frontmatter), process writes sequentially, warn before overwriting
- **After Sync**: Report all synced paths, any failures, and suggest visual verification in Obsidian

---

## Limitations

- **Obsidian MCP required**: The Obsidian REST API MCP server must be configured and running
- **Markdown only**: This mode handles `.md` files. Binary assets, images, and non-text files are not synced
- **No bidirectional sync**: This mode writes TO Obsidian, it does not pull changes back from Obsidian
- **No conflict resolution**: If a note exists at the destination, it will be overwritten (with user confirmation)
- **Single vault**: Operates on the vault connected to the MCP server; cannot switch between multiple vaults

---

## Example: Full Sync Flow

**User request:** "sync {output_base}/planning/ to obsidian"

1. **Glob**: Find all `.md` files in `{output_base}/planning/`
2. **Read**: Read all files in parallel
3. **Load**: `ToolSearch query: "+obsidian write"`
4. **List vault**: `mcp__obsidian__list_directory(path: "/")`
5. **Ask user**: "Where should I save these 3 documents?" → User picks `work/agent-sync-sdk/plans`
6. **Write**: Sequential writes to `work/agent-sync-sdk/plans/00-strategic-analysis.md`, etc.
7. **Validate**: Check cross-references, fix missing bidirectional links
8. **Report**: "Synced 3 files to Obsidian: work/agent-sync-sdk/plans/"
