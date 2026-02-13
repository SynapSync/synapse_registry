---
name: obsidian
description: >
  Unified Obsidian vault operations via MCP: sync documents to vault, read notes for context,
  search knowledge, and validate markdown standards.
  Trigger: When user wants to read from or write to Obsidian vault.
license: Apache-2.0
metadata:
  author: synapsync
  version: "3.1"
  scope: [root]
  auto_invoke:
    - "sync * to obsidian"
    - "save * to obsidian"
    - "read obsidian notes about *"
    - "search my vault for *"
    - "check obsidian for *"
    - "guardar en obsidian"
    - "lee de obsidian"
    - "busca en obsidian"
  changelog:
    - version: "3.1"
      date: "2026-02-13"
      changes:
        - "Added i18n documentation for bilingual (EN/ES) design"
        - "Added Tool Dependencies section with MCP tool contracts"
        - "Reconciled type taxonomy to 14 types (removed note, meeting, reference)"
        - "Added ambiguous intent disambiguation step"
        - "Slimmed assets/README.md to minimal index"
        - "Added batch size limits (max 20 files)"
        - "Added Windows path support in fallback mode"
        - "Added negative weights for superseded/archived in priority ranking"
        - "Versioned the Obsidian markdown standard (v1.0)"
        - "Clarified cognitive.config.json and mcp__obsidian__write_note contracts"
    - version: "3.0"
      date: "2026-02-12"
      changes:
        - "Consolidated obsidian-sync + obsidian-reader into single skill"
        - "Mode-based architecture: SYNC mode (write) + READ mode (read/search)"
        - "Progressive disclosure: modes load only when relevant"
        - "Shared helpers across modes (frontmatter-generator, cross-ref-validator, etc.)"
        - "Follows 2026 best practices: single-agent with skills pattern"
allowed-tools: Read, Write, Glob, Grep, Bash, ToolSearch, AskUserQuestion
---

# Obsidian Vault Manager

## Assets

This skill uses a modular assets architecture. Detailed workflows, templates, and helpers are in the [assets/](assets/) directory:

- **[assets/modes/](assets/modes/)** - 2 operation modes with detailed workflows
- **[assets/helpers/](assets/helpers/)** - Shared helpers for frontmatter, cross-refs, ranking, batch operations

See [assets/README.md](assets/README.md) for the directory index.

> **Metadata note**: This file's YAML frontmatter defines runtime behavior (auto_invoke triggers, allowed-tools, scope). The `manifest.json` defines registry metadata (version, tags, providers, dependencies). The frontmatter is consumed by the Claude Code skill loader; the manifest is consumed by the `skills` CLI for installation and updates.

---

## Purpose

Unified skill for all Obsidian vault operations via MCP. Acts as a **bidirectional knowledge bridge** between the agent workspace and your Obsidian vault:

- **SYNC mode**: Write documents from workspace to vault (markdown reports, plans, analysis)
- **READ mode**: Read, search, and reason over vault notes as contextual knowledge source

Combines the capabilities of the former `obsidian-sync` and `obsidian-reader` skills into one cohesive tool with progressive disclosure.

---

## Language Support (i18n)

This skill supports **bilingual operation** (English + Spanish):

- **Trigger keywords**: Both English (`sync`, `read`, `search`) and Spanish (`guardar`, `lee`, `busca`) are recognized for mode detection.
- **`## Referencias` section header**: Uses the Spanish form intentionally as an Obsidian convention adopted by this project. All documents produced by this skill use `## Referencias` (not `## References`).
- **Example queries**: Documentation includes examples in both languages to reflect real bilingual usage.
- **Output language**: The skill responds in the **same language the user uses**. If the user writes in Spanish, respond in Spanish. If in English, respond in English. Document content is never translated — it is synced/read exactly as-is.

> **Convention**: `## Referencias` is a fixed section header. Never translate it to `## References` in generated documents.

---

## Critical Rules

> **RULE 1 — ALWAYS LOAD MCP TOOLS FIRST**
>
> Before calling ANY Obsidian MCP tool, use `ToolSearch` to load them:
> ```
> ToolSearch query: "+obsidian write"    # For SYNC operations
> ToolSearch query: "+obsidian read"     # For READ operations
> ToolSearch query: "+obsidian list"     # For vault browsing
> ```
> Never call `mcp__obsidian__*` tools without loading them first. They are deferred tools and will fail if not loaded.

> **RULE 2 — MODE DETECTION: AUTO-SELECT FROM USER INTENT**
>
> Detect the operation mode from the user's input. Never force a mode that doesn't match the scenario.

> **RULE 3 — PRESERVE CONTENT INTEGRITY (SYNC mode)**
>
> Read source files completely before writing. Never modify document body content (headings, paragraphs, tables, code blocks, `## Referencias` section). Only add/merge frontmatter metadata. Cross-reference fixes update the `related` frontmatter array only — never the document body.

> **RULE 4 — NEVER FABRICATE CONTENT (READ mode)**
>
> Only report information that exists verbatim in notes. Quote sources with paths. Distinguish between "the note says X" and "I interpret X based on notes".

> **RULE 5 — FOLLOW OBSIDIAN MARKDOWN STANDARD**
>
> All operations follow the [Obsidian markdown standard](assets/standards/obsidian-md-standard.md) specification for frontmatter, wiki-links, types, and cross-references.

---

## Tool Dependencies

This skill depends on two categories of tools:

### Native Claude Code Tools (provided by runtime)

These tools are part of the Claude Code environment and require no special setup:

| Tool | Usage in This Skill |
|------|-------------------|
| `ToolSearch` | Load deferred MCP tools before first use. Input: `query` string (e.g., `"+obsidian write"`). Output: loaded tool definitions. |
| `AskUserQuestion` | Prompt user for choices (vault destination, config paths). Input: `questions` array with `question`, `header`, `options`. Output: user selection. |
| `Read` | Read local files. Input: `file_path` (absolute). Output: file content with line numbers. |
| `Write` | Create/overwrite files. Input: `file_path`, `content`. |
| `Glob` | Find files by pattern. Input: `pattern` (e.g., `"**/*.md"`). Output: matching file paths. |
| `Grep` | Search file contents. Input: `pattern`, `path`, `type`. Output: matching lines/files. |
| `Bash` | Run shell commands. Input: `command` string. Output: stdout/stderr. |

### MCP Tools (require Obsidian REST API server)

These tools are **deferred** — they must be loaded via `ToolSearch` before first use. They will fail if called without loading.

| Tool | Parameters | Description |
|------|-----------|-------------|
| `mcp__obsidian__write_note` | `path` (string): vault-relative path. `content` (string): markdown body **without** frontmatter YAML block. `frontmatter` (object): key-value pairs to serialize as YAML. | Write a note to the vault. The MCP server handles serializing frontmatter and prepending it to content. |
| `mcp__obsidian__read_note` | `path` (string): vault-relative path. | Read a note. Returns content with frontmatter. |
| `mcp__obsidian__read_multiple_notes` | `paths` (string[]): array of vault-relative paths. | Read multiple notes in one call. |
| `mcp__obsidian__search_notes` | `query` (string): search query. | Full-text search across the vault. |
| `mcp__obsidian__list_directory` | `path` (string): vault-relative directory path. | List files and subdirectories. |
| `mcp__obsidian__get_vault_stats` | `recentCount` (number, optional): how many recent notes to return. | Get vault statistics and recently modified notes. |
| `mcp__obsidian__manage_tags` | `action` (string): `"list"`. | List all tags in the vault. |

> **Note**: The `mcp__obsidian__write_note` tool accepts `frontmatter` as a **separate parameter** (a JSON object), not as part of `content`. Pass raw markdown body in `content` and structured metadata in `frontmatter`. The MCP server serializes the frontmatter into YAML and prepends it. If directories in `path` don't exist, they are created automatically.

---

## Operation Modes

### Mode Detection

Auto-detect from user intent using these signals:

| Mode | Signals (EN) | Signals (ES) | Example Inputs |
|------|-------------|-------------|----------------|
| **SYNC** | "sync", "save", "store", "write", "move" + "obsidian" | "guardar", "sincronizar" + "obsidian" | "sync this report to obsidian", "guardar en obsidian" |
| **READ** | "read", "search", "find", "check", "consult", "what do my notes say" + "obsidian"/"vault"/"notes" | "lee", "busca", "consulta" + "obsidian"/"vault"/"notas" | "read my vault notes about X", "busca en obsidian" |

**Ambiguous intent resolution:** If the user's intent does not clearly match SYNC or READ signals (e.g., "help me with obsidian", "manage my notes", "obsidian" with no verb), ask the user to clarify:

```
AskUserQuestion:
  question: "What would you like to do with your Obsidian vault?"
  header: "Mode"
  options:
    - label: "Read / Search"
      description: "Read notes, search for information, or get project context from your vault"
    - label: "Sync / Write"
      description: "Save or sync documents from your workspace to your vault"
```

### Mode Capabilities Matrix

| Capability | SYNC Mode | READ Mode |
|-----------|:---------:|:---------:|
| Write to vault | ✅ | ❌ |
| Read from vault | ❌ | ✅ |
| Search vault | ❌ | ✅ |
| Generate frontmatter | ✅ | ❌ |
| Cross-ref fix (frontmatter) | ✅ | ❌ |
| Cross-ref diagnose | ✅ | ✅ |
| Batch operations | ✅ | ✅ |
| Vault browsing | ✅ | ✅ |
| Priority ranking | ❌ | ✅ |
| Standard compliance check | ❌ | ✅ |

---

## Mode Workflows

### SYNC Mode - Write to Obsidian Vault

Sync markdown documents from workspace to Obsidian vault with proper frontmatter and cross-reference validation.

**Full workflow:** [assets/modes/SYNC.md](assets/modes/SYNC.md)

**Quick summary:**
1. Identify source files (Glob workspace docs)
2. Load MCP tools
3. Browse vault and ask user for destination
4. Read source files
5. Generate frontmatter (→ [frontmatter-generator](assets/helpers/frontmatter-generator.md))
6. Write to vault with `mcp__obsidian__write_note`
7. Validate cross-references (→ [cross-ref-validator](assets/helpers/cross-ref-validator.md))
8. Report results

### READ Mode - Read from Obsidian Vault

Read, search, and reason over vault notes to provide contextual knowledge for decision-making.

**Full workflow:** [assets/modes/READ.md](assets/modes/READ.md)

**Quick summary:**
1. Load MCP tools (fallback to filesystem if MCP unavailable)
2. Parse user intent (read note, search, get project context, answer question)
3. Execute operation (search/read/reason)
4. Rank results by priority (→ [priority-ranking](assets/helpers/priority-ranking.md))
5. Present structured output with source citations

---

## Configuration Resolution

Before any operation, resolve `{output_base}` — the directory where skills store output documents (reports, plans, analysis). This is a **registry-wide convention** used by all SynapSync skills that produce output.

**Config file:** `cognitive.config.json` in the project root (current working directory).

```json
{
  "output_base": "~/.agents/my-project"
}
```

**Resolution steps:**
1. Check for `cognitive.config.json` in the project root
2. If found → read `output_base` and use it for all `{output_base}` references
3. If not found → infer project name from directory/git repo, ask user with `AskUserQuestion` (suggest `~/.agents/{project-name}/`), create the config file

---

## Shared Helpers

- **[frontmatter-generator](assets/helpers/frontmatter-generator.md)** - Generate Obsidian frontmatter following universal schema
- **[cross-ref-validator](assets/helpers/cross-ref-validator.md)** - Validate bidirectional references
- **[batch-sync-pattern](assets/helpers/batch-sync-pattern.md)** - Optimized batch file sync workflow
- **[priority-ranking](assets/helpers/priority-ranking.md)** - Rank search results by relevance

---

## Obsidian Output Standard

All operations follow the internal [Obsidian markdown standard](assets/standards/obsidian-md-standard.md):

1. **Frontmatter**: Universal schema with title, date, project, type, status, version, tags, changelog, related
2. **Type taxonomy**: 14 document types (analysis, plan, sprint-plan, technical-report, etc.)
3. **Wiki-links**: `[[note-name]]` format, never markdown links
4. **Bidirectional refs**: If A→B, then B→A
5. **Status transitions**: draft → active → completed → archived

For compliance validation, see [assets/validators/obsidian-linter.md](assets/validators/obsidian-linter.md).

---

## Integration with Other Skills

| Producer Skill | How obsidian Integrates |
|---------------|------------------------|
| `universal-planner` | SYNC: Saves planning docs to vault. READ: Provides historical plans as context |
| `code-analyzer` | SYNC: Saves technical reports. READ: Surfaces architecture notes |
| `universal-planner-executor` | READ: Retrieves sprint plans and progress |

**Composition pattern:**
```
Producer skill generates docs → obsidian SYNC mode writes to vault
Agent needs context → obsidian READ mode retrieves from vault
```

---

## Best Practices

**SYNC mode:**
- Verify source files exist before syncing
- Always ask user where to save (never assume destination)
- Validate cross-references after batch syncs
- Report exact vault paths where files were saved

**READ mode:**
- Try MCP first, fallback to filesystem if unavailable
- Scope searches to relevant folders (don't search entire vault unnecessarily)
- Always cite sources with exact note paths
- Distinguish quoted content from interpretation

---

## Limitations

- **MCP dependency**: Full functionality requires Obsidian REST API MCP server
- **Markdown only**: Handles `.md` files, not binary assets/images
- **Single vault**: Operates on one vault at a time
- **No bidirectional sync**: Writes TO vault (SYNC) or reads FROM vault (READ), not both-way sync
- **Read-only in READ mode**: Cannot modify notes in READ mode (use SYNC for writing)

---

## Troubleshooting

| Issue | Mode | Solution |
|-------|------|----------|
| "Tool not found: mcp__obsidian__*" | Both | Run `ToolSearch query: "+obsidian write"` first |
| "MCP server not connected" | Both | Start Obsidian, enable REST API plugin, or use filesystem fallback |
| "Note already exists" | SYNC | Confirm with user before overwriting |
| "No results found" | READ | Broaden search, check different folders, verify vault path |
| "Empty content" | SYNC | Verify source file path with Glob |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.1 | 2026-02-13 | Audit remediation: i18n docs, tool contracts, taxonomy reconciliation (14 types), disambiguation, batch limits, negative weights. |
| 3.0 | 2026-02-12 | Consolidated obsidian-sync + obsidian-reader. Mode-based architecture (SYNC + READ). Shared helpers. |
| 2.x | 2026-02-11 | (obsidian-sync v2.1.0) Assets pattern, cross-ref validation |
| 1.x | 2026-02-10 | (obsidian-reader v1.2.0) Compliance check, priority ranking |
