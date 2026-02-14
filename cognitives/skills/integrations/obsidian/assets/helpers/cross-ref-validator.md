# Cross-Reference Validation Helper

## Purpose

Validate and fix bidirectional references between documents synced to Obsidian. When document A references document B, document B must also reference document A to maintain knowledge graph integrity. This helper ensures all references are reciprocal.

## When to Use

- After syncing a batch of files (2+ files) to Obsidian
- When building or updating an interconnected knowledge graph
- When validating that related documents have consistent cross-references

## Why This Matters

Obsidian's graph view and backlinks rely on bidirectional references. One-directional references create:
- **Broken navigation** — users can't navigate back to the source document
- **Incomplete graph view** — missing edges in the knowledge graph
- **Lost context** — related documents appear unconnected

**Example:**
```
ANALYSIS.md references [[CONVENTIONS]] ✓
CONVENTIONS.md does NOT reference [[ANALYSIS]] ✗
```

Result: The graph shows ANALYSIS → CONVENTIONS but not CONVENTIONS → ANALYSIS. The user reading CONVENTIONS has no indication that ANALYSIS depends on it.

## Workflow

### Reference Collection Strategy (v3.2)

> **Fast path** (frontmatter only): Use `mcp__obsidian__get_frontmatter` to extract the `related` array without reading the full document. Use when only frontmatter `related` needs validation.
>
> **Full path** (frontmatter + body): Use `mcp__obsidian__read_note` to parse both `frontmatter.related` and the `## Referencias` body section.

```
# Fast path — metadata only
mcp__obsidian__get_frontmatter(path: "work/project/SPRINT-1.md")
# Returns: { related: ["[[PROGRESS]]", "[[SPRINT-2]]"], ... }

# Full path — when body section also needs checking
mcp__obsidian__read_note(path: "work/project/SPRINT-1.md")
```

### Step 1: Collect References from Synced Files

For each document synced in the batch, collect references from two sources:

#### Source 1: Frontmatter `related` array

```yaml
---
related:
  - "[[ANALYSIS]]"
  - "[[CONVENTIONS]]"
  - "[[PROGRESS]]"
---
```

#### Source 2: `## Referencias` section

```markdown
## Referencias

**Parent:** [[PROGRESS]]
**Siblings:** [[SPRINT-1]], [[SPRINT-3]]
**Input Documents:** [[ANALYSIS]], [[CONVENTIONS]]
```

Extract all `[[wiki-links]]` from both sources.

### Step 2: Build Reference Map

Create a directional reference map:

```
Document A → [B, C, D]
Document B → [A, E]
Document C → [A]
Document D → []
Document E → [B]
```

### Step 3: Identify One-Directional References

For each reference A → B:
- Check if B → A exists
- If NOT, mark as **missing reverse reference**

**Example findings:**
```
ANALYSIS → CONVENTIONS ✓ (CONVENTIONS → ANALYSIS exists)
ANALYSIS → PROGRESS ✗ (PROGRESS does NOT reference ANALYSIS)
SPRINT-2 → SPRINT-1 ✗ (SPRINT-1 does NOT reference SPRINT-2)
```

### Step 4: Fix Missing Reverse References

For each missing reverse reference B → A, use `update_frontmatter` (v3.2 — preferred over full read+write):

```
# Step 1: Get current frontmatter to read existing related array
mcp__obsidian__get_frontmatter(path: "work/project/PROGRESS.md")
# Returns: { related: ["[[SPRINT-1]]"], ... }

# Step 2: Update frontmatter with the missing reference appended
mcp__obsidian__update_frontmatter(
  path: "work/project/PROGRESS.md",
  frontmatter: {
    "related": ["[[SPRINT-1]]", "[[SPRINT-2]]"]
  },
  merge: true
)
```

> **Why `update_frontmatter` instead of full read+write**: This tool modifies ONLY the frontmatter metadata, leaving the document body untouched. It is faster, safer, and directly implements the rule that cross-ref fixes only update the `related` frontmatter array — never the document body. With `merge: true`, other frontmatter fields are preserved.

> **Important**: Only update the `related` array in frontmatter. Never edit the `## Referencias` body section — that section is populated at document creation time and is the author's curated navigation. The `related` frontmatter array is the machine-maintained source of truth for bidirectional references.

### Step 5: Report Validation Results

After all fixes are applied, report a summary:

```
Cross-reference validation complete:

✓ SPRINT-1 ↔ PROGRESS (bidirectional)
✓ ANALYSIS ↔ CONVENTIONS (bidirectional)
⚠ Fixed: Added [[PLANNING]] to ANALYSIS frontmatter related array
⚠ Fixed: Added [[SPRINT-2]] to SPRINT-1 frontmatter related array
⚠ Fixed: Added [[PROGRESS]] to SPRINT-2 frontmatter related array

3 files validated, 3 frontmatter fixes applied.
```

## Example: Full Validation Flow

**Scenario:** Synced 3 files:
- `SPRINT-1-foundation.md`
- `SPRINT-2-core.md`
- `PROGRESS.md`

**Step 1: Collect references**

```
SPRINT-1.md:
  frontmatter.related: ["[[PROGRESS]]"]
  Referencias: Parent: [[PROGRESS]], Siblings: [[SPRINT-2]]

SPRINT-2.md:
  frontmatter.related: ["[[PROGRESS]]", "[[SPRINT-1]]"]
  Referencias: Parent: [[PROGRESS]], Siblings: [[SPRINT-1]]

PROGRESS.md:
  frontmatter.related: ["[[SPRINT-1]]"]
  Referencias: Children: [[SPRINT-1]], [[SPRINT-2]]
```

**Step 2: Build map**

```
SPRINT-1 → [PROGRESS, SPRINT-2]
SPRINT-2 → [PROGRESS, SPRINT-1]
PROGRESS → [SPRINT-1]
```

**Step 3: Identify issues**

```
✓ SPRINT-1 → PROGRESS (PROGRESS → SPRINT-1 exists)
✓ SPRINT-1 → SPRINT-2 (SPRINT-2 → SPRINT-1 exists)
✓ SPRINT-2 → PROGRESS (PROGRESS has SPRINT-2 in Referencias Children)
✗ SPRINT-2 → PROGRESS (PROGRESS frontmatter does NOT include SPRINT-2)
```

**Step 4: Fix (frontmatter only)**

Read `PROGRESS.md`, add `"[[SPRINT-2]]"` to frontmatter `related` array:

```yaml
# Before
related:
  - "[[SPRINT-1]]"

# After
related:
  - "[[SPRINT-1]]"
  - "[[SPRINT-2]]"
```

> Note: The `## Referencias` section in PROGRESS.md already lists `[[SPRINT-2]]` under Children. Only the frontmatter `related` array was missing it. We fix frontmatter only; the body is untouched.

**Step 5: Report**

```
Cross-reference validation:
✓ SPRINT-1 ↔ PROGRESS (bidirectional)
✓ SPRINT-1 ↔ SPRINT-2 (bidirectional)
⚠ Fixed: Added [[SPRINT-2]] to PROGRESS frontmatter related array

3 files validated, 1 frontmatter fix applied.
```

## Edge Cases

### Case 1: Self-references

If a document references itself (`[[SELF]]`), ignore it. No action needed.

### Case 2: Missing Referenced Document

If document A references `[[B]]` but document B was not synced and may not exist in the vault:

**Check existence (v3.2):**
```
mcp__obsidian__get_notes_info(paths: ["work/project/B.md"])
# If returns empty/error, the note does not exist
```

- **Report as warning** — "ANALYSIS references [[MISSING-DOC]] which does not exist in vault"
- **Do not attempt to fix** — the reference may be intentional (forward reference to a future document)

### Case 3: External References

If a document references a URL `[text](https://...)`, ignore it. This validator only handles wiki-links.

### Case 4: Circular References

If A → B and B → A already exist, that's correct. No action needed.

### Case 5: Multiple Documents with Same Name

If the vault has multiple documents with the same name in different folders (e.g., `work/project-a/PLAN.md` and `work/project-b/PLAN.md`):
- Use the full vault path in the report: `work/project-a/PLAN.md → [[CONVENTIONS]]`
- When adding reverse references, Obsidian will handle disambiguation

## Best Practices

1. **Run validation after every batch sync** — ensure consistency as soon as files are synced
2. **Report all fixes to the user** — transparency helps users understand what changed
3. **Collect from both sources, fix only frontmatter** — read references from both `related` array and `## Referencias` section, but only fix the `related` frontmatter array (never edit the document body)
4. **Don't fix external references** — only validate and fix wiki-links to documents in the vault

## Integration with Obsidian-Sync Workflow

This helper is invoked at **Step 5.5: Cross-Reference Validation** in the SYNC mode workflow, immediately after writing all files but before reporting results.

```
Step 5: Write to Obsidian
  → Write all files
Step 5.5: Cross-Reference Validation (THIS HELPER)
  → Validate bidirectionality
  → Fix missing reverse references
  → Report fixes
Step 6: Report Results
  → Include validation summary
```

## Limitations

- **Only validates synced documents** — does not scan the entire vault for references
- **No conflict resolution** — if a document has conflicting references, all are preserved
- **No relationship inference** — only validates what's explicitly declared in `related` and `## Referencias`
- **Batch-only** — single-file syncs skip validation (no batch to validate)
