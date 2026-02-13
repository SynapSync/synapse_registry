# Obsidian Skill Assets

This directory contains the detailed documentation, workflows, and helpers for the unified `obsidian` skill following the modular assets pattern.

## Directory Structure

```
assets/
├── README.md (this file)
├── modes/
│   ├── SYNC.md     - Write documents to Obsidian vault
│   └── READ.md     - Read, search, and reason over vault notes
├── helpers/
│   ├── frontmatter-generator.md  - Generate Obsidian frontmatter
│   ├── cross-ref-validator.md    - Validate bidirectional references
│   ├── batch-sync-pattern.md     - Optimized batch file sync
│   └── priority-ranking.md       - Rank search results by relevance
├── standards/
│   └── obsidian-md-standard.md   - Full specification (sections 1-12)
└── validators/
    └── obsidian-linter.md        - Compliance validation rules
```

---

## Modes (Operation Modes)

The `obsidian` skill has two primary operation modes, each with its own detailed workflow:

### SYNC Mode - [modes/SYNC.md](modes/SYNC.md)

**Purpose:** Write markdown documents from workspace to Obsidian vault

**Key Features:**
- Vault browsing and destination selection
- Frontmatter generation and enrichment
- Batch sync optimization
- Cross-reference validation
- Wiki-link preservation

**When to use:** User wants to save, sync, store, or move documents TO Obsidian

**Main workflow steps:**
1. Identify source files
2. Load MCP tools
3. Browse vault and ask user for destination
4. Read source files
5. Generate frontmatter
6. Write to vault
7. Validate cross-references
8. Report results

---

### READ Mode - [modes/READ.md](modes/READ.md)

**Purpose:** Read, search, and reason over vault notes as contextual knowledge source

**Key Features:**
- Full-text search across vault
- Frontmatter-aware filtering
- Project context assembly
- Priority ranking by relevance
- Standard compliance checking
- MCP-first with filesystem fallback

**When to use:** User wants to read, search, check, or consult notes FROM Obsidian

**Main operations:**
- READ_NOTE - Read a specific note
- READ_FOLDER - Read all notes in a directory
- SEARCH_TEXT - Full-text search
- SEARCH_TAG - Search by tags
- SEARCH_META - Search by frontmatter metadata
- PROJECT_CONTEXT - Build comprehensive project context
- REASON - Answer questions using vault content
- DISCOVER - Explore vault structure
- COMPLIANCE_CHECK - Validate Obsidian markdown standard compliance

---

## Helpers (Shared Utilities)

Helpers are reusable workflows and algorithms used by both modes:

### Frontmatter Generator - [helpers/frontmatter-generator.md](helpers/frontmatter-generator.md)

**Used by:** SYNC mode

**Purpose:** Generate Obsidian-native YAML frontmatter for markdown documents following the universal schema

**Key capabilities:**
- Detect existing frontmatter (none, minimal, rich)
- Extract metadata from document content (title, date, type, tags)
- Infer document type using 14-type taxonomy
- Generate complete universal schema with all required fields
- Merge with existing frontmatter without overwriting

**Output:** Complete YAML frontmatter block ready for vault notes

---

### Cross-Reference Validator - [helpers/cross-ref-validator.md](helpers/cross-ref-validator.md)

**Used by:** SYNC mode (after batch writes), READ mode (for compliance checks)

**Purpose:** Validate and fix bidirectional references between documents

**Key capabilities:**
- Collect references from `related` frontmatter array and `## Referencias` section
- Build directional reference map
- Identify one-directional references (A→B exists but B→A missing)
- Automatically fix missing reverse references
- Determine appropriate relationship category (Parent, Siblings, Children, Related)

**Output:** Validation report with fixes applied

**Why it matters:** Maintains knowledge graph integrity for Obsidian's graph view and backlinks

---

### Batch Sync Pattern - [helpers/batch-sync-pattern.md](helpers/batch-sync-pattern.md)

**Used by:** SYNC mode (when syncing 2+ files)

**Purpose:** Optimize workflow for syncing multiple files by parallelizing reads and minimizing user interaction

**Key optimizations:**
- Glob all files once (not per-file)
- Read all files in parallel
- Load MCP tools once (not per-file)
- List vault directory once
- Ask user once for destination (not per-file)
- Write files sequentially (for MCP safety)
- Validate cross-references once after all writes
- Report all results once

**Performance gain:** ~40% faster, 67% fewer user interactions vs. sequential per-file sync

---

### Priority Ranking - [helpers/priority-ranking.md](helpers/priority-ranking.md)

**Used by:** READ mode (for all search and context operations)

**Purpose:** Rank search results by relevance, recency, and importance

**Ranking algorithm:**
```
score = recency_weight + type_weight + relevance_weight + status_weight + version_weight
```

**Weight components:**
- **Recency:** Today (+3), This week (+2), This month (+1), Older (+0)
- **Type:** High types (+3), Medium (+2), Low (+1) — based on 14-type taxonomy
- **Relevance:** Title match (+3), Frontmatter (+2), Body (+1), Linked note (+0.5)
- **Status:** active (+3), draft (+2), completed (+1), superseded/archived (+0)
- **Version:** +1 per major version (v2.0 → +2)

**Output:** Sorted list of notes with top N most relevant results first

---

## Standards (Specification)

### Obsidian Markdown Standard - [standards/obsidian-md-standard.md](standards/obsidian-md-standard.md)

**Used by:** Both SYNC and READ modes, frontmatter-generator, cross-ref-validator

**Purpose:** The authoritative specification for Obsidian-native markdown output. Defines the universal frontmatter schema, 14-type document taxonomy, wiki-link conventions, bidirectional references, living document patterns, ID system, metric tables, graduation gates, and sequential numbering.

**Key sections:**
1. Universal Frontmatter Schema (required/extended fields)
2. Document Type Taxonomy (14 types)
3. Wiki-Link Convention
4. References Section (`## Referencias`)
5. Living Document Pattern (status transitions, versioning)
6. ID System (FR-, ADR-, T-, K-, P-, L-, A-, D-, M-)
7. Bidirectional References
8. Metric Tables
9. Graduation Gates
10. Sequential Numbering
11. Carried Forward Rules
12. Retrospective Template

---

## Validators (Compliance)

### Obsidian Linter - [validators/obsidian-linter.md](validators/obsidian-linter.md)

**Used by:** READ mode (COMPLIANCE_CHECK operation), SYNC mode (pre-write validation)

**Purpose:** Validate markdown documents against the Obsidian markdown standard. Checks frontmatter schema, wiki-link syntax, tag format, bidirectional cross-references, type taxonomy, and required sections.

**Key capabilities:**
- Parse and validate YAML frontmatter (required fields, types, formats)
- Check wiki-link syntax (`[[note-name]]` format, no spaces, no extensions)
- Validate tag format (lowercase, kebab-case, max 10)
- Verify bidirectional references between documents
- Check type against 14-type taxonomy
- Generate compliance reports with severity-based issue listing

**Output:** Compliance report with PASS/PARTIAL/FAIL status and actionable recommendations

---

## Migration Notes

This unified `obsidian` skill (v3.0.0) consolidates the former:
- **obsidian-sync** (v2.1.0) → now SYNC mode
- **obsidian-reader** (v1.2.0) → now READ mode

**Key changes:**
1. **Mode-based architecture** — single skill with progressive disclosure
2. **Shared helpers** — eliminated duplication between sync and reader
3. **Reduced LOC** — main SKILL.md is ~450 LOC (vs. 294 + 902 = 1196 LOC combined)
4. **Unified auto-invoke triggers** — both read and write operations in one skill
5. **Consistent standards** — both modes follow the internal Obsidian markdown standard (see [standards/obsidian-md-standard.md](standards/obsidian-md-standard.md))

**Breaking change:** Users should install `obsidian` v3.0.0 and remove old `obsidian-sync` and `obsidian-reader` skills.

---

## Usage Examples

### Example 1: Sync planning docs to vault

**User:** "sync {output_base}/planning/ to obsidian"

**Skill activates:** SYNC mode
**Helpers used:** batch-sync-pattern, frontmatter-generator, cross-ref-validator
**Result:** 3 files synced to `work/project/plans/` with full frontmatter and validated cross-refs

---

### Example 2: Get project context from vault

**User:** "what do my obsidian notes say about the agent-sync-sdk project?"

**Skill activates:** READ mode → PROJECT_CONTEXT operation
**Helpers used:** priority-ranking
**Result:** Structured summary with active plans, known issues, vision, key decisions

---

### Example 3: Search vault for technical debt

**User:** "search obsidian for race condition"

**Skill activates:** READ mode → SEARCH_TEXT operation
**Helpers used:** priority-ranking
**Result:** Top 5 notes ranked by relevance with quoted passages and source citations

---

## Best Practices

1. **Always load MCP tools first** — use `ToolSearch` before calling any `mcp__obsidian__*` tools
2. **Mode detection from intent** — let user input determine SYNC vs. READ mode naturally
3. **Cite sources in READ mode** — always include exact vault paths for quotes
4. **Validate after batch sync** — use cross-ref-validator for 2+ file syncs
5. **Rank results in READ mode** — apply priority-ranking when 3+ notes are found
6. **Follow the Obsidian markdown standard** — both modes comply with the internal standard for frontmatter, wiki-links, and types (see [standards/obsidian-md-standard.md](standards/obsidian-md-standard.md))

---

## File Size Summary

| File | LOC | Purpose |
|------|-----|---------|
| SKILL.md (main) | ~450 | Mode overview, rules, quick reference |
| modes/SYNC.md | ~200 | Complete SYNC workflow |
| modes/READ.md | ~550 | Complete READ workflow with 9 operations |
| helpers/frontmatter-generator.md | ~230 | Frontmatter generation logic |
| helpers/cross-ref-validator.md | ~270 | Cross-reference validation |
| helpers/batch-sync-pattern.md | ~280 | Batch sync optimization |
| helpers/priority-ranking.md | ~250 | Search result ranking |
| standards/obsidian-md-standard.md | ~300 | Full Obsidian markdown specification |
| validators/obsidian-linter.md | ~450 | Compliance validation rules |
| **Total** | **~2980** | Self-contained skill with internal standard |

**Note:** Total LOC increased slightly because:
1. READ mode gained new operations (COMPLIANCE_CHECK, DISCOVER)
2. Helpers extracted from inline content for reusability
3. More comprehensive documentation and examples

**But context efficiency improved:** Progressive disclosure means Claude only loads relevant mode + helpers, not entire 2230 LOC.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.0.0 | 2026-02-12 | Unified obsidian-sync + obsidian-reader. Mode-based architecture. 4 shared helpers. |
| 2.x | 2026-02-11 | (obsidian-sync v2.1.0) Assets pattern, cross-ref validation |
| 1.x | 2026-02-10 | (obsidian-reader v1.2.0) Compliance check, priority ranking |
