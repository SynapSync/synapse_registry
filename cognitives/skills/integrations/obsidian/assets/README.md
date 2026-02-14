# Obsidian Skill Assets

Modular assets for the unified `obsidian` skill. Detailed workflows, helpers, and standards load on-demand via progressive disclosure. Both modes (SYNC and READ) support filesystem fallback when the Obsidian MCP server is unavailable.

## Directory Structure

```
assets/
├── README.md              — This index file
├── modes/
│   ├── SYNC.md            — Write documents to vault (SYNC mode workflow)
│   └── READ.md            — Read, search, and reason over vault notes (READ mode workflow)
├── helpers/
│   ├── frontmatter-generator.md  — Generate/enrich Obsidian frontmatter
│   ├── cross-ref-validator.md    — Validate bidirectional references
│   ├── batch-sync-pattern.md     — Optimized batch file sync
│   └── priority-ranking.md       — Rank search results by relevance
├── standards/
│   └── obsidian-md-standard.md   — Authoritative spec (14-type taxonomy, frontmatter schema, wiki-links)
└── validators/
    └── obsidian-linter.md        — Compliance validation rules
```

## Filesystem Fallback (v3.3.0)

Both SYNC and READ modes detect access mode at startup (Step 0). If the Obsidian MCP server is unavailable, all operations fall back to native filesystem tools (Read, Write, Edit, Glob, Grep, Bash). Helpers (frontmatter-generator, cross-ref-validator, batch-sync-pattern, priority-ranking) all include fallback alternatives for each MCP tool call.

## Migration Notes (v3.0.0)

This unified `obsidian` skill consolidates the former `obsidian-sync` (v2.1.0) and `obsidian-reader` (v1.2.0). Install `obsidian` v3.0.0 and remove the old skills.
