# Priority Ranking Algorithm Helper

## Purpose

Rank search results from Obsidian vault queries by relevance, recency, and importance. When multiple notes match a query, this algorithm helps surface the most valuable and current information first.

## When to Use

- After executing a SEARCH_TEXT, SEARCH_TAG, or SEARCH_META operation
- When returning multiple notes from a PROJECT_CONTEXT query
- When answering questions that have multiple source notes (REASON operation)
- Any time more than 3 notes are found for a user query

---

## Priority Ranking Algorithm

When multiple notes are found, rank them using this weighted score:

```
score = recency_weight + type_weight + relevance_weight + status_weight + version_weight

recency_weight:
  - Today:       +3
  - This week:   +2
  - This month:  +1
  - Older:       +0

type_weight:
  - High types:   +3
  - Medium types:  +2
  - Low types:     +1

relevance_weight:
  - Exact match in title:     +3
  - Match in frontmatter:     +2
  - Match in body:            +1
  - Match in linked note:     +0.5

status_weight:
  - active:      +3
  - draft:       +2
  - completed:   +1
  - superseded:  -1
  - archived:    -1

version_weight:
  - Higher version number: +1 per major version
  - Example: v2.0 scores +2, v1.0 scores +1
```

---

## Type Weight Mapping

Based on the 14-type taxonomy from the [Obsidian markdown standard](../standards/obsidian-md-standard.md):

| Type | Weight | Rationale |
|------|--------|-----------|
| `analysis` | High (+3) | Strategic documents with high value |
| `plan` | High (+3) | Active planning documents |
| `execution-plan` | High (+3) | Concrete actionable plans |
| `sprint-plan` | High (+3) | Active sprint work |
| `progress` | High (+3) | Master tracking dashboards |
| `conventions` | Medium (+2) | Reference material |
| `requirements` | Medium (+2) | Foundational specs |
| `architecture` | Medium (+2) | Design decisions |
| `technical-report` | Medium (+2) | Code analysis |
| `refactor-plan` | Medium (+2) | Improvement proposals |
| `retrospective` | Medium (+2) | Historical learnings |
| `decision-log` | Medium (+2) | Engineering decisions |
| `data-model` | Low (+1) | Supporting diagrams |
| `flow-diagram` | Low (+1) | Supporting diagrams |

---

## Recency Calculation

Calculate days since last update using the `updated` frontmatter field (or `date` if `updated` is missing):

```
days_old = today - note.updated

if days_old == 0:
  recency_weight = 3
elif days_old <= 7:
  recency_weight = 2
elif days_old <= 30:
  recency_weight = 1
else:
  recency_weight = 0
```

---

## Relevance Scoring

Check where the query term appears in the note:

### Title Match (Highest Priority)
```
if query_term in note.frontmatter.title.lower():
  relevance_weight += 3
```

### Frontmatter Match
```
if query_term in note.frontmatter.tags or \
   query_term in note.frontmatter.project or \
   query_term in note.frontmatter.type:
  relevance_weight += 2
```

### Body Match
```
if query_term in note.content.lower():
  relevance_weight += 1
```

### Linked Note Match
```
for linked_note in note.frontmatter.related:
  if query_term in linked_note:
    relevance_weight += 0.5
```

**For multi-term queries**, sum the relevance scores for each term.

---

## Status Weight

Extract from `status` frontmatter field:

```yaml
---
status: "active"
---
```

| Status | Weight | Rationale |
|--------|--------|-----------|
| `active` | +3 | Current work in progress |
| `draft` | +2 | Being developed |
| `completed` | +1 | Finished but still relevant |
| `superseded` | -1 | Replaced by newer version — demoted |
| `archived` | -1 | Historical only — demoted |

**Default:** If `status` is missing, assume `"active"` (+3).

---

## Version Weight

Extract from `version` frontmatter field:

```yaml
---
version: "2.3"
---
```

Calculate weight as the major version number:
```
version_weight = int(version.split('.')[0])
```

Examples:
- `v1.0` → +1
- `v2.0` → +2
- `v3.5` → +3

**Default:** If `version` is missing, assume `"1.0"` (+1).

---

## Example Scoring

**Query:** "race condition"

**Note A:**
```yaml
---
title: "Technical Debt Analysis"
date: "2026-02-10"
updated: "2026-02-10"
type: "technical-debt"
status: "active"
version: "1.0"
tags: ["race-condition", "lockfile"]
---
```
**Body:** "The LockFileManager has a race condition in the read-modify-write cycle..."

**Score:**
- Recency: 2 (this week)
- Type: 2 (technical-report is medium)
- Relevance: 2 (tags) + 1 (body) = 3
- Status: 3 (active)
- Version: 1 (v1.0)
- **Total: 11**

**Note B:**
```yaml
---
title: "Race Condition Fix for LockFileManager"
date: "2026-01-15"
updated: "2026-01-15"
type: "note"
status: "completed"
version: "1.0"
---
```
**Body:** "Fixed the race condition by adding mutex..."

**Score:**
- Recency: 0 (older than 30 days)
- Type: 1 (note is low)
- Relevance: 3 (title) + 1 (body) = 4
- Status: 1 (completed)
- Version: 1 (v1.0)
- **Total: 7**

**Result:** Note A ranks higher (11 > 7) despite Note B having the query term in the title, because Note A is more recent, has higher status, and is a more important document type.

---

## Implementation Checklist

When implementing priority ranking:

- [ ] Parse frontmatter from all matching notes
- [ ] Calculate each weight component (recency, type, relevance, status, version)
- [ ] Sum weights to get total score for each note
- [ ] Sort notes by score (descending)
- [ ] Return top N notes (typically 5-10)
- [ ] Include score in debug output (optional, for transparency)

---

## Presenting Ranked Results

After ranking, present results with context:

```
Found 8 notes matching "race condition", showing top 5:

1. **work/agent-sync-sdk/plans/01-technical-debt.md** (Score: 11)
   Type: technical-debt | Date: 2026-02-10 | Status: active
   > "El LockFileManager realiza operaciones read-modify-write sin mutex..."

2. **work/agent-sync-sdk/plans/00-strategic-analysis.md** (Score: 9)
   Type: plan | Date: 2026-02-10 | Status: active
   > "Condicion de carrera en LockFileManager (P0)..."

3. **work/agent-sync-sdk/decisions/DEC-005-mutex-strategy.md** (Score: 8)
   Type: decision-log | Date: 2026-02-08 | Status: completed
   > "Decision: Use async mutex from 'async-mutex' package..."

...
```

---

## Edge Cases

### Case 1: Ties

If two notes have the same score, use these tiebreakers in order:
1. More recent `updated` date wins
2. Higher `version` wins
3. Alphabetical by title

### Case 2: Missing Frontmatter

If a note lacks frontmatter:
- Assume defaults: `type: "note"`, `status: "active"`, `version: "1.0"`
- Use file modification date for recency
- Relevance score still applies (search in body text)

### Case 3: Very Old Notes

If all notes are older than 30 days (recency_weight = 0 for all), rely entirely on type, relevance, status, and version.

### Case 4: Single Result

If only one note matches, skip ranking and present it directly (no need to calculate a score).

---

## Best Practices

1. **Always rank when N > 3** — present top results first
2. **Show scores in debug mode** — helps users understand why a note ranked high
3. **Limit results to top 10** — prevents information overload
4. **Explain ranking** — add a note like "Sorted by relevance and recency" in the output
5. **Preserve all results** — even if showing top 10, mention "X additional notes found" if there are more

---

## Integration with READ Mode Operations

| Operation | When to Apply Ranking |
|-----------|----------------------|
| READ_NOTE | Never (single note) |
| READ_FOLDER | Always (sort before presenting) |
| SEARCH_TEXT | Always (rank by relevance) |
| SEARCH_TAG | Always (rank by type + recency) |
| SEARCH_META | Always (rank by status + version) |
| PROJECT_CONTEXT | Always (prioritize active plans and reports) |
| REASON | Always (use top-ranked notes as sources) |
| DISCOVER | Never (structural listing, not relevance-based) |
| COMPLIANCE_CHECK | Never (validation listing, not relevance-based) |

---

## Performance Notes

- Ranking is computationally cheap (simple arithmetic)
- Parse frontmatter once, reuse for all weight calculations
- For large result sets (50+ notes), consider limiting frontmatter parsing to first 20 results, then rank only those
- Cache parsed frontmatter if the same notes are queried multiple times in a session
