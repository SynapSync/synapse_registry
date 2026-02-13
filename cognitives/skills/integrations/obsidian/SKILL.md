---
name: obsidian
description: >
  Unified Obsidian vault operations via MCP: sync documents to vault, read notes for context,
  search knowledge, and validate markdown standards.
  Trigger: When user wants to read from or write to Obsidian vault.
license: Apache-2.0
metadata:
  author: synapsync
  version: "3.0"
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

See [assets/README.md](assets/README.md) for full directory documentation.

---

## Purpose

Unified skill for all Obsidian vault operations via MCP. Acts as a **bidirectional knowledge bridge** between the agent workspace and your Obsidian vault:

- **SYNC mode**: Write documents from workspace to vault (markdown reports, plans, analysis)
- **READ mode**: Read, search, and reason over vault notes as contextual knowledge source

Combines the capabilities of the former `obsidian-sync` and `obsidian-reader` skills into one cohesive tool with progressive disclosure.

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
> Read source files completely before writing. Never modify document content. Only add/merge frontmatter metadata.

> **RULE 4 — NEVER FABRICATE CONTENT (READ mode)**
>
> Only report information that exists verbatim in notes. Quote sources with paths. Distinguish between "the note says X" and "I interpret X based on notes".

> **RULE 5 — FOLLOW OBSIDIAN-MD-STANDARD**
>
> All operations follow the `obsidian-md-standard` specification for frontmatter, wiki-links, types, and cross-references.

---

## Operation Modes

### Mode Detection

Auto-detect from user intent using these signals:

| Mode | Signals | Example Inputs |
|------|---------|----------------|
| **SYNC** | "sync", "save", "store", "write", "move", "guardar", "sincronizar" + "obsidian" | "sync this report to obsidian", "save the analysis to my vault", "guardar en obsidian" |
| **READ** | "read", "search", "find", "check", "consult", "what do my notes say", "lee", "busca", "consulta" + "obsidian"/"vault"/"notes" | "read my vault notes about X", "search obsidian for decisions", "what do my notes say about the project?" |

### Mode Capabilities Matrix

| Capability | SYNC Mode | READ Mode |
|-----------|:---------:|:---------:|
| Write to vault | ✅ | ❌ |
| Read from vault | ❌ | ✅ |
| Search vault | ❌ | ✅ |
| Generate frontmatter | ✅ | ❌ |
| Cross-ref validation | ✅ | ✅ |
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

Before any operation, resolve `{output_base}` path:

1. Check `cognitive.config.json` in project root
2. If found → use `output_base` value
3. If not found → ask user, suggest `~/.agents/{project-name}/`, create config

```json
{
  "output_base": "~/.agents/my-project"
}
```

---

## Shared Helpers

- **[frontmatter-generator](assets/helpers/frontmatter-generator.md)** - Generate Obsidian frontmatter following universal schema
- **[cross-ref-validator](assets/helpers/cross-ref-validator.md)** - Validate bidirectional references
- **[batch-sync-pattern](assets/helpers/batch-sync-pattern.md)** - Optimized batch file sync workflow
- **[priority-ranking](assets/helpers/priority-ranking.md)** - Rank search results by relevance

---

## Obsidian Output Standard

All operations follow the `obsidian-md-standard` skill:

1. **Frontmatter**: Universal schema with title, date, project, type, status, version, tags, changelog, related
2. **Type taxonomy**: 14 document types (analysis, plan, sprint-plan, technical-report, etc.)
3. **Wiki-links**: `[[note-name]]` format, never markdown links
4. **Bidirectional refs**: If A→B, then B→A
5. **Status transitions**: draft → active → completed → archived

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
| 3.0 | 2026-02-12 | Consolidated obsidian-sync + obsidian-reader. Mode-based architecture (SYNC + READ). Shared helpers. |
| 2.x | 2026-02-11 | (obsidian-sync v2.1.0) Assets pattern, cross-ref validation |
| 1.x | 2026-02-10 | (obsidian-reader v1.2.0) Compliance check, priority ranking |
