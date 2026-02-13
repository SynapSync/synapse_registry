# READ Mode - Read from Obsidian Vault

## When to Use This Mode

- User asks to **read, consult, or check** notes in Obsidian
- User asks "what do my notes say about X?" or "check my plans in obsidian"
- User needs **project context** that lives in Obsidian (plans, decisions, architecture docs)
- User asks to **summarize** recent reports or plans stored in the vault
- User asks to **search** for specific topics, decisions, or information across the vault
- User wants to **use Obsidian notes as context** for a current task or decision
- Another skill or agent needs knowledge that resides in the vault (multi-agent context)
- User asks "what was the status of X?" referencing previously synced documents
- User says "lee de obsidian", "busca en mis notas", "consulta obsidian"

## When NOT to Use This Mode

- User wants to **write** to Obsidian (use SYNC mode instead)
- User wants to **edit** an existing note in-place (use MCP tools directly)
- The information is already in the current workspace (use Read/Grep/Glob directly)
- User asks about files that are clearly local to the project, not in the vault

---

## Critical Rules

**RULE 1 - MCP FIRST, FILESYSTEM FALLBACK**

Always attempt to use Obsidian MCP tools first. They provide the most reliable access to the vault with proper path resolution and plugin support.

```
# Step 1: Try to load MCP tools
ToolSearch query: "+obsidian read"
ToolSearch query: "+obsidian search"
ToolSearch query: "+obsidian list"
```

If ToolSearch returns no results or tools fail with connection errors, switch to **filesystem fallback mode** (see Fallback Strategy section).

**RULE 2 - NEVER FABRICATE CONTENT**

Only report information that exists verbatim in the notes. When reasoning over content:
- Quote relevant passages with the source note path
- Clearly distinguish between "the note says X" and "based on the notes, I interpret X"
- If information is not found, say so explicitly rather than guessing

**RULE 3 - RESPECT VAULT STRUCTURE**

Obsidian vaults have semantic meaning in their structure:
- **Folders** = categories/projects/topics
- **Tags** (in frontmatter or inline `#tag`) = cross-cutting classification
- **Wikilinks** (`[[note-name]]`) = relationships between concepts
- **Frontmatter** = structured metadata (date, type, project, status)
- **Folder hierarchy** = scope and context

Read and interpret all of these, not just the body text.

**RULE 4 - PRIORITIZE BY RELEVANCE**

When retrieving information, rank by:
1. **Active/current** over historical (check `date` frontmatter, prefer recent)
2. **Directly referenced** over tangentially related
3. **Plans and decisions** over raw notes (check `type` frontmatter)
4. **Tagged/structured** over unstructured notes
5. **Notes with more backlinks** often represent key concepts

**RULE 5 - STRUCTURED OUTPUT FOR COMPOSABILITY**

When another skill or agent requests knowledge, return structured summaries:
- Source note path
- Key findings
- Relevant quotes
- Confidence level (exact match vs. inferred)
- Related notes that may contain additional context

---

## Capabilities

### Reading
- Read individual notes by path
- Read all notes in a folder (recursive)
- Read notes matching a pattern (glob)
- Parse and extract frontmatter metadata
- Extract inline tags (`#tag`)
- Detect and follow wikilinks (`[[note]]`)

### Searching
- Full-text search across the vault
- Filter by frontmatter fields (project, type, date, tags)
- Filter by folder/path
- Search by tag combinations
- Find notes linking to a specific note (backlinks)

### Reasoning
- Summarize content from multiple notes
- Correlate information across documents
- Answer questions using vault content as source
- Identify the most recent/relevant version of a topic
- Build a context snapshot for the current task

### Discovery
- Map vault structure (folder tree)
- List projects and their documents
- Identify recently modified notes
- Surface notes related to the current working directory/project

### Standard Compliance Check
- Report which documents follow the `obsidian-md-standard`
- Identify documents missing required frontmatter fields
- Flag one-directional references (A→B exists but B→A missing)
- List documents without `## Referencias` sections
- Check that `type` values match the 14-type taxonomy

---

## Workflow

### Step 0: Detect Access Mode

Before any vault operation, determine the access strategy:

```
# Attempt MCP connection
ToolSearch query: "+obsidian read"
```

| Result | Mode | Behavior |
|--------|------|----------|
| Tools loaded successfully | **MCP Mode** | Use `mcp__obsidian__*` tools for all operations |
| ToolSearch returns no obsidian tools | **Fallback Mode** | Ask user for vault path, use Read/Glob/Grep |
| Tools load but fail on call | **Fallback Mode** | Warn user MCP may be disconnected, switch to filesystem |

**If entering Fallback Mode**, inform the user:

```
The Obsidian MCP server doesn't appear to be connected. I can still read your vault
directly from the filesystem. What is the path to your Obsidian vault?
(e.g., ~/Documents/MyVault or ~/obsidian-vault)
```

### Step 1: Understand the Request

Parse the user's intent into one of these operations:

| User Intent | Operation | Example |
|-------------|-----------|---------|
| Read specific note | `READ_NOTE` | "lee la nota de arquitectura del proyecto X" |
| Read a folder | `READ_FOLDER` | "lee todos los planes en work/agent-sync-sdk/" |
| Search by topic | `SEARCH_TEXT` | "busca decisiones sobre la base de datos" |
| Search by tag | `SEARCH_TAG` | "encuentra notas con tag #strategy" |
| Search by metadata | `SEARCH_META` | "dame los reportes de febrero 2026" |
| Get project context | `PROJECT_CONTEXT` | "dame el contexto del proyecto agent-sync-sdk" |
| Answer a question | `REASON` | "segun mis notas, cual es el estado del proyecto?" |
| Explore structure | `DISCOVER` | "que tengo en mi vault?" |
| Check standard compliance | `COMPLIANCE_CHECK` | "which notes follow the obsidian standard?" |

### Step 2: Execute the Operation

#### READ_NOTE - Read a Specific Note

**MCP Mode:**
```
mcp__obsidian__read_note(path: "work/agent-sync-sdk/plans/00-strategic-analysis.md")
```

**Fallback Mode:**
```
Read(file_path: "/path/to/vault/work/agent-sync-sdk/plans/00-strategic-analysis.md")
```

After reading:
1. Parse frontmatter (title, date, project, type, tags)
2. Extract wikilinks (`[[referenced-note]]`)
3. Extract inline tags (`#tag-name`)
4. Present a structured summary + full content if requested

#### READ_FOLDER - Read All Notes in a Directory

**MCP Mode:**
```
mcp__obsidian__list_directory(path: "work/agent-sync-sdk/plans")
# Then read each .md file found
mcp__obsidian__read_note(path: "work/agent-sync-sdk/plans/00-strategic-analysis.md")
mcp__obsidian__read_note(path: "work/agent-sync-sdk/plans/01-technical-debt.md")
# ... etc
```

**Fallback Mode:**
```
Glob(pattern: "/path/to/vault/work/agent-sync-sdk/plans/**/*.md")
# Then Read each file
```

After reading all notes:
1. Sort by date (frontmatter `date` field or filename)
2. Build a table of contents with title + type + date
3. Summarize each note in 1-2 sentences
4. Identify relationships between notes (shared tags, wikilinks)

#### SEARCH_TEXT - Full-Text Search

**MCP Mode:**
```
mcp__obsidian__search_notes(query: "race condition LockFileManager")
```

**Fallback Mode:**
```
Grep(pattern: "race condition", path: "/path/to/vault", type: "md")
# Then Read matching files for context
```

Present results as:
```
Found N notes matching "query":

1. **work/agent-sync-sdk/plans/01-technical-debt.md**
   > "El LockFileManager realiza operaciones read-modify-write sin mutex..."
   Type: technical-debt | Date: 2026-02-10

2. **work/agent-sync-sdk/plans/00-strategic-analysis.md**
   > "Condicion de carrera en el LockFileManager (P0)..."
   Type: strategic-analysis | Date: 2026-02-10
```

#### SEARCH_TAG - Search by Tag

**MCP Mode:**
```
mcp__obsidian__search_notes(query: "tag:#strategy")
# or
mcp__obsidian__manage_tags(action: "list")  # List all tags first
```

**Fallback Mode:**
```
# Search in frontmatter
Grep(pattern: "tags:.*strategy", path: "/path/to/vault", type: "md")
# Search inline tags
Grep(pattern: "#strategy", path: "/path/to/vault", type: "md")
```

#### SEARCH_META - Search by Metadata

Filter notes by frontmatter fields:

```
# Find all notes for a specific project
Grep(pattern: "project: agent-sync-sdk", path: "/path/to/vault", type: "md")

# Find all notes of a specific type
Grep(pattern: "type: technical-debt", path: "/path/to/vault", type: "md")

# Find all notes from a date range
Grep(pattern: "date: \"2026-02", path: "/path/to/vault", type: "md")
```

#### PROJECT_CONTEXT - Build Project Context

This is the **most powerful operation** -- it assembles a comprehensive context snapshot for a project:

1. **Locate project folder** in vault:
   ```
   mcp__obsidian__list_directory(path: "work")
   # Find folder matching project name
   ```

2. **Read all notes** in the project folder (recursive)

3. **Sort and classify** by type:
   - Plans & roadmaps (type: plan, strategic-analysis)
   - Technical debt & issues (type: technical-debt)
   - Architecture docs (type: architecture)
   - Sprint plans (type: sprint-plan)
   - Reports & analysis (type: analysis, growth-vision)

4. **Build a context summary**:
   ```
   ## Project Context: agent-sync-sdk
   Last updated: 2026-02-10

   ### Active Plans
   - 00-strategic-analysis.md: Roadmap Q1-Q4 2026, 32 action items
   - Key priority: Transition from "motor" to "producto usable" in 4-6 weeks

   ### Known Issues
   - 01-technical-debt.md: 18 findings (5 critical, 8 medium, 5 low)
   - Top P0: Race condition in LockFileManager

   ### Vision
   - 02-growth-vision.md: Maturity score 3.0/5
   - Target: npm + CLI + registry in 3 months

   ### Key Decisions
   - [extracted from notes where type includes "decision" or content discusses trade-offs]

   ### Related Notes
   - [any notes in other folders that link to this project]
   ```

5. **Present to user** or pass to requesting agent/skill

#### REASON - Answer Questions Using Vault

When the user asks a question that requires reasoning over vault content:

1. **Identify relevant notes** using SEARCH_TEXT + SEARCH_TAG + SEARCH_META
2. **Read the top N most relevant notes** (aim for 3-7, max 10)
3. **Extract relevant passages** that address the question
4. **Synthesize an answer** citing sources:

   ```
   Based on your Obsidian notes:

   [Answer to the question with reasoning]

   Sources:
   - work/agent-sync-sdk/plans/00-strategic-analysis.md (Section 5.1)
   - work/agent-sync-sdk/plans/01-technical-debt.md (Section 3.1)

   Note: [Any caveats about completeness or recency of information]
   ```

#### DISCOVER - Explore Vault Structure

Map the vault and present an overview:

```
mcp__obsidian__list_directory(path: "/")
# Recursively list first 2 levels
mcp__obsidian__list_directory(path: "/work")
mcp__obsidian__list_directory(path: "/work/agent-sync-sdk")
# ... for each subfolder
```

**Also use vault stats if available:**
```
mcp__obsidian__get_vault_stats(recentCount: 10)
```

Present as:
```
Your Obsidian Vault:

work/
  agent-sync-sdk/
    plans/          (3 notes - last updated 2026-02-10)
  bmtz/
    ...
  wdt/
    ...

Stats: X total notes, Y folders
Recently modified: [list of 5-10 most recent]
```

#### COMPLIANCE_CHECK - Standard Compliance Report

Analyze documents in a project folder against the obsidian-md-standard.

**Validation rules:** See [obsidian-md-standard/assets/validators/obsidian-linter.md](../../obsidian-md-standard/assets/validators/obsidian-linter.md) for complete validation rules and procedures.

**Quick summary of what to validate:**
1. **Frontmatter schema**: Required fields (title, date, updated, project, type, status, version, tags, changelog, related) with correct types and formats
2. **Wiki-link syntax**: `[[note-name]]` format, no spaces, no `.md` extensions
3. **Tag format**: `#tag` or `#multi-word-tag`, no spaces or underscores
4. **Bidirectional cross-references**: If A→B exists in `related`, verify B→A exists
5. **Type taxonomy**: Must be one of the 14 approved types (analysis, conventions, requirements, architecture, plan, execution-plan, sprint-plan, progress, technical-report, refactor-plan, retrospective, decision-log, data-model, flow-diagram)
6. **Required sections**: Contains `## Referencias` section

**Workflow:**
1. **List all .md files** in the project folder
2. **For each file**, apply validation checks from obsidian-linter
3. **Generate compliance report:**

```markdown
## Standard Compliance Report: {project-name}
Date: {today}

### Summary
- **Total documents**: {N}
- **Fully compliant**: {N} ({percent}%)
- **Partial compliance**: {N}
- **Non-compliant**: {N}

### Issues Found

| Document | Issue | Severity |
|----------|-------|----------|
| {filename} | Missing `updated` field | Low |
| {filename} | No `## Referencias` section | Medium |
| {filename} | One-directional reference to [[X]] | Medium |
| {filename} | Uses relative markdown link instead of wiki-link | High |

### Recommendations
1. {Specific fix for most common issue}
2. {Specific fix for next most common issue}
```

### Step 3: Present Results

Always structure output clearly:

**For single notes:**
- Show frontmatter metadata as a header table
- Present content (full or summarized based on length)
- List outgoing links and tags

**For multiple notes:**
- Table of contents first (title, type, date, path)
- Then individual summaries
- Highlight connections between notes

**For questions/reasoning:**
- Direct answer first
- Supporting evidence with source citations
- Caveats about information completeness
- Suggestions for where to find more information

---

## Fallback Strategy (No MCP)

When the Obsidian MCP server is not available, the mode operates in filesystem mode:

### Vault Discovery

Ask the user for the vault path if not known:
```
AskUserQuestion:
  question: "What is the path to your Obsidian vault?"
  header: "Vault path"
  options:
    - label: "~/obsidian-vault"
      description: "Common default location"
    - label: "~/Documents/Obsidian"
      description: "Documents folder"
```

### Reading Notes (Fallback)

```
# Read a specific note
Read(file_path: "/absolute/path/to/vault/note.md")

# List directory contents
Bash(command: "ls -la /path/to/vault/work/")

# Search content
Grep(pattern: "search term", path: "/path/to/vault", type: "md")

# Find by glob
Glob(pattern: "/path/to/vault/**/*.md")
```

### Limitations in Fallback Mode

| Feature | MCP Mode | Fallback Mode |
|---------|----------|---------------|
| Read notes | Full support | Full support |
| List directories | Full support | Full support (via Bash ls) |
| Search content | Optimized vault search | Grep (slower on large vaults) |
| Frontmatter parsing | Native | Manual parsing from Read output |
| Tags management | Native API | Grep-based search |
| Backlinks | If MCP supports it | Manual wikilink grep |
| Vault stats | Native API | Bash wc/find |
| Note metadata | Native API | Parsed from frontmatter |

---

## Frontmatter Parsing

This mode relies heavily on frontmatter for intelligent filtering.

**For validation rules and schema requirements**, see [obsidian-md-standard/assets/validators/obsidian-linter.md](../../obsidian-md-standard/assets/validators/obsidian-linter.md).

**Expected fields for reading/filtering:**

```yaml
---
title: "Document Title"
date: "2026-02-10"
updated: "2026-02-11"
project: "agent-sync-sdk"
type: "strategic-analysis"
status: "active"
version: "1.2"
tags: [strategy, roadmap, plan]
changelog:
  - version: "1.2"
    date: "2026-02-11"
    changes: ["Updated strategy based on Q1 review"]
  - version: "1.0"
    date: "2026-02-10"
    changes: ["Initial creation"]
related:
  - "[[01-technical-debt]]"
  - "[[02-growth-vision]]"
sprint: 2
phase: "2.1"
progress: 65
metrics:
  tasks_completed: 12
  tasks_total: 18
source: "{output_base}/planning/2026-02-10/"
---
```

### Type Taxonomy (aligned with obsidian-md-standard)

Use these types for filtering and prioritization:

| Type | Priority | Description |
|------|----------|-------------|
| `analysis` | High | General analysis documents |
| `conventions` | Medium | Project patterns and conventions reference |
| `requirements` | Medium | Functional/non-functional requirements |
| `architecture` | Medium | System design and architecture decisions |
| `plan` | High | Strategic planning and high-level plans |
| `execution-plan` | High | Concrete task breakdowns |
| `sprint-plan` | High | Sprint-level task plans |
| `progress` | High | Master progress dashboards |
| `technical-report` | Medium | Code/module analysis reports |
| `refactor-plan` | Medium | Refactoring recommendations |
| `retrospective` | Medium | Sprint/project retrospectives |
| `decision-log` | Medium | Architecture/engineering decisions |
| `data-model` | Low | Entity relationships and storage |
| `flow-diagram` | Low | Core flows and sequences |
| `note` | Low | Unstructured notes |
| `meeting` | Low | Meeting notes |
| `reference` | Low | Reference material |

---

## Relationship Mapping

### Related Field (Primary Source)

The `related` field in frontmatter is the **primary source** of document relationships in the obsidian-md-standard:

```yaml
related:
  - "[[01-technical-debt]]"
  - "[[02-growth-vision]]"
  - "[[SPRINT-1-foundation]]"
```

When building relationship maps:
1. **First**: Check `related` in frontmatter — these are explicit, curated relationships
2. **Second**: Check `## Referencias` section — structured navigation links
3. **Third**: Check wikilinks in body text — implicit references
4. **Fourth**: Check backlinks — notes that reference this one

The `related` field and `## Referencias` section follow the bidirectionality rule: if A lists B in `related`, B should list A.

### Wikilinks

Detect and follow `[[wikilinks]]` to understand relationships:

```
# In a note:
"See [[01-technical-debt]] for details on the race condition."
"This connects to the [[architecture]] decisions from Sprint 3."
```

When the user asks about a topic, also check notes that are **linked from** the primary results.

### Backlinks

Find notes that link TO a specific note:

**MCP Mode:**
```
mcp__obsidian__search_notes(query: "[[00-strategic-analysis]]")
```

**Fallback Mode:**
```
Grep(pattern: "\\[\\[00-strategic-analysis\\]\\]", path: "/path/to/vault", type: "md")
```

### Tag Networks

Tags create cross-cutting relationships:
```
# Find all notes sharing a tag
Grep(pattern: "agent-sync-sdk", path: "/path/to/vault", type: "md")
```

---

## Integration with Other Skills

| Skill | How READ mode Integrates |
|-------|--------------------------|
| `obsidian` SYNC mode | Read notes that were previously synced; verify sync status |
| `project-planner` | Provide existing project context before planning begins |
| `code-analyzer` | Supply architecture notes as reference for analysis |
| `universal-planner` | Feed historical plans and decisions as input context |
| `sdlc-planner` | Provide requirements docs and previous SDLC phases |

---

## Best Practices

### Before Reading
- Always try MCP first before falling back to filesystem
- Scope searches to relevant folders when possible (don't search entire vault for project-specific info)
- Check if the user has already mentioned the vault location or project in conversation context

### During Reading
- Parse frontmatter on every note read -- it's the primary metadata source
- When reading multiple notes, process them in parallel when possible
- For large notes (>500 lines), summarize instead of presenting full content unless asked
- Track wikilinks as you read -- they form the knowledge graph

### After Reading
- Always cite sources with exact note paths
- Distinguish between quoted content and your interpretation
- If information seems outdated (old date), warn the user
- Suggest related notes the user might want to check
- If the query couldn't be fully answered, explain what's missing

### Performance
- For DISCOVER operations, limit to 2 levels of directory depth initially
- For SEARCH operations, prefer MCP search over Grep on large vaults
- For PROJECT_CONTEXT, cache the folder listing and reuse within the same conversation
- Avoid reading more than 10 full notes in a single operation unless explicitly requested

---

## Limitations

- **Read-only**: This mode does not modify vault content (use SYNC mode for writing)
- **No real-time sync**: Reads the vault state at query time; doesn't watch for changes
- **Markdown only**: Processes `.md` files; ignores images, PDFs, and other attachments
- **No graph view**: Cannot render Obsidian's graph view; provides text-based relationship mapping
- **MCP dependency**: Full functionality requires the Obsidian MCP server; fallback mode has reduced capabilities
- **No plugin data**: Cannot access Obsidian plugin-specific data (Dataview queries, Kanban boards, etc.)
- **Single vault**: Operates on one vault at a time (the one connected via MCP or specified by the user)
- **Context window**: Very large vaults may require targeted queries; reading everything is not feasible
