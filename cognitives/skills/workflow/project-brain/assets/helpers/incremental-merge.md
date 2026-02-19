# Incremental Merge

Helper for SAVE UPDATE mode. Merges new session data into an existing brain document without destroying accumulated knowledge.

---

## Algorithm

1. **Read** the full brain document
2. **Split** by lines that start with `## ` into sections — but **only** when the line is NOT inside a code fence (``` or ~~~). To determine this: track whether you are inside a code fence by counting opening/closing fence markers as you scan top-to-bottom.
3. **Identify** each section by its heading text
4. **Apply** the per-section merge strategy (see table below)
5. **Reassemble** the document preserving section order

---

## Per-Section Merge Strategy

| Section | Strategy | Details |
|---------|----------|---------|
| **Metadata** (title line, "Last updated", "Sessions") | **Update** | Increment session count, update date |
| **Project Identity** | **Update fields** | Only replace fields that changed; keep the rest as-is |
| **Active State** | **Full replace** | Overwrite entire table with current state |
| **Session Log** | **Prepend** | Insert new session entry at the top (after the `<!-- -->` comment) |
| **Accumulated Context > Architecture Decisions** | **Append rows** | Add new rows to the table; never remove existing rows |
| **Accumulated Context > Patterns & Conventions** | **Append** | Add new items; skip exact duplicates |
| **Accumulated Context > Constraints & Gotchas** | **Append** | Add new items; skip exact duplicates |
| **Next Steps** | **Full replace** | Overwrite entirely — priorities change every session |
| **Key Files** | **Merge** | Add new entries, update changed descriptions, keep untouched entries |

---

## Session Log Compaction

When the Session Log exceeds **15 entries**, compact the oldest sessions:

1. Identify sessions older than the most recent 10
2. **Archive**: Write the individual entries to `{cwd}/{brain_dir}/archive/{project-name}-sessions-1-{M}.md`
3. Collapse them into a single summary block in the brain document:

```markdown
### Older Sessions (1-{M})

{One-paragraph summary covering what sessions 1 through M accomplished, key decisions made, and major milestones reached.}

> Full entries archived: `{brain_dir}/archive/{project-name}-sessions-1-{M}.md`
```

4. Place the summary block **at the bottom** of the Session Log (after all individual entries)
5. Remove the individual entries for sessions 1-{M}

This keeps the Session Log focused on recent context while preserving historical knowledge in the archive.

---

## Defensive Parsing

If the document does not match the v2.0 standard format:

1. **Attempt section identification** by heading text (case-insensitive)
2. If sections cannot be identified:
   - **Do not restructure** the document
   - **Append** the new session entry at the end of the document under a `## Session Log` heading
   - **Warn** the user: "Could not identify standard sections. Session appended at end of document."
3. Offer migration: "This document isn't v2.0 format. Want me to migrate it? Original content will be preserved as Session 0."

---

## Migration from v1.0 or Free-Form

When the user accepts migration:

1. Read the entire existing document content
2. Create a new document using the BRAIN-DOCUMENT template
3. Place the original content under `### Session 0 — {original_date_or_today}` with:
   - **Summary**: "Migrated from previous format. Original content preserved below."
   - The full original content as a blockquote
4. Fill **Project Identity** and **Active State** by inferring from the original content (confirm with user)
5. Set **Next Steps** based on any "next steps" or "pending" sections found in the original

---

## Duplicate Detection

For append-only sections (Patterns, Constraints), detect duplicates by:

1. Normalize: lowercase, trim whitespace, remove leading `- `
2. Compare against existing items using the normalized form
3. Exact match → skip the new item
4. If the new item conveys the same meaning as an existing item, skip it
5. If uncertain whether it's a duplicate, append the new item without annotation
