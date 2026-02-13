# Obsidian Markdown Standard

This is the authoritative specification for Obsidian-native markdown output. All operations in this skill (SYNC and READ modes) follow these rules.

---

### 1. Universal Frontmatter Schema

Every generated `.md` document MUST include YAML frontmatter with these fields:

#### Required Fields

```yaml
---
title: "Document Title"
date: "YYYY-MM-DD"           # Creation date
updated: "YYYY-MM-DD"        # Last modification date
project: "{project-name}"     # Kebab-case project identifier
type: "{document-type}"       # From the Document Type Taxonomy (section 2)
status: "draft"               # draft | active | completed | superseded | archived
version: "1.0"                # Document version (semver-ish)
tags:
  - "{project-name}"
  - "{type}"
  - "{additional-tags}"
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Initial creation"]
related:
  - "[[related-document-1]]"
  - "[[related-document-2]]"
---
```

#### Extended Fields (by document type)

| Field | Used By | Description |
|-------|---------|-------------|
| `sprint` | sprint-plan, progress | Sprint number (integer) |
| `phase` | sprint-plan, execution-plan | Phase identifier (e.g., "1.1") |
| `progress` | sprint-plan, progress | Completion percentage (0-100) |
| `previous_doc` | sprint-plan, retrospective | `"[[SPRINT-1-name]]"` |
| `next_doc` | sprint-plan | `"[[SPRINT-3-name]]"` |
| `parent_doc` | any child document | `"[[PROGRESS]]"` or `"[[README]]"` |
| `vision_ref` | sprint-plan, progress | `"[[growth-vision]]"` |
| `retro_refs` | sprint-plan, progress | `["[[RETRO-1-name]]"]` |
| `metrics` | sprint-plan, retrospective, progress | Inline metric summary object |
| `approved_by` | any gated document | Approver name |
| `approved_date` | any gated document | "YYYY-MM-DD" |
| `severity` | bug-fix analysis | critical / high / medium / low |
| `scope_modules` | refactor analysis | List of affected modules |

### 2. Document Type Taxonomy

| Type | Description | Typical Skills |
|------|-------------|----------------|
| `analysis` | General analysis document | universal-planner |
| `conventions` | Project patterns and conventions | universal-planner |
| `requirements` | Functional/non-functional requirements | universal-planner (NEW_PROJECT) |
| `architecture` | Architecture decisions and design | universal-planner (NEW_PROJECT, ARCHITECTURE) |
| `plan` | Strategic planning document | universal-planner |
| `execution-plan` | Concrete task breakdown | universal-planner |
| `sprint-plan` | Sprint-level task plan | universal-planner |
| `progress` | Master progress dashboard | universal-planner, universal-planner-executor |
| `technical-report` | Code/module analysis report | code-analyzer |
| `refactor-plan` | Refactoring recommendations | code-analyzer (v3) |
| `retrospective` | Sprint/project retrospective | universal-planner, universal-planner-executor |
| `decision-log` | Architecture/engineering decisions | universal-planner-executor |
| `data-model` | Entity relationships and storage | universal-planner (NEW_PROJECT) |
| `flow-diagram` | Core flows and sequences | universal-planner (NEW_PROJECT) |

### 3. Wiki-Link Convention

**Inter-document references MUST use wiki-links.** Markdown links are reserved for external URLs only.

| Pattern | Usage | Example |
|---------|-------|---------|
| `[[filename]]` | Reference another document | `[[CONVENTIONS]]` |
| `[[filename#Section]]` | Reference a specific section | `[[ANALYSIS#Success Criteria]]` |
| `[[filename]] (v1.2)` | Reference a specific version | `[[SPRINT-1-foundation]] (v1.0)` |
| `[[filename\|display text]]` | Aliased reference | `[[functional-requirements\|FR Spec]]` |
| `[text](https://...)` | External URL only | `[Obsidian docs](https://obsidian.md)` |

**Rules:**
- All inter-document references use `[[wiki-links]]`, never `[text](relative-path.md)`
- Filenames in wiki-links omit the `.md` extension
- Wiki-links are case-insensitive in Obsidian but use the actual filename casing for clarity

### 4. References Section

Every generated document MUST end with a `## Referencias` section. This section provides structured navigation between related documents.

```markdown
## Referencias

**Parent:** [[PROGRESS]] | [[README]]
**Siblings:** [[SPRINT-1-foundation]], [[SPRINT-3-testing]]
**Children:** [[RETRO-2-core-implementation]]
**Input Documents:** [[CONVENTIONS]], [[ANALYSIS]]
**External:** [Relevant external link](https://...)
```

**Categories (include only those that apply):**
- **Parent**: The document this one belongs to (e.g., PROGRESS for a sprint)
- **Siblings**: Documents at the same level (e.g., other sprints)
- **Children**: Documents spawned from this one (e.g., retro from sprint)
- **Input Documents**: Documents this one was derived from
- **External References**: External URLs relevant to this document

### 5. Living Document Pattern

Documents that evolve over time (sprint plans, progress dashboards, visions) follow the living document pattern:

**Versioning:** Track in frontmatter `version` field + `changelog` array.

**Status transitions:**
```
draft -> active -> completed -> superseded -> archived
```

| Status | Meaning |
|--------|---------|
| `draft` | Initial creation, not yet reviewed |
| `active` | Currently in use, may be updated |
| `completed` | Work described is finished |
| `superseded` | Replaced by a newer version (link to successor in `related`) |
| `archived` | Historical record, no longer active |

**Update protocol:** When modifying a living document:
1. Bump the `version` field
2. Update the `updated` date
3. Add an entry to `changelog`
4. Update `status` if the transition applies

### 6. ID System

Trackable IDs provide stable anchors for cross-referencing within and across documents.

| Prefix | Domain | Example |
|--------|--------|---------|
| `FR-` | Functional Requirement | FR-001, FR-002 |
| `NFR-` | Non-Functional Requirement | NFR-001 |
| `ADR-` / `DEC-` | Architecture/Engineering Decision | ADR-1, DEC-3 |
| `T-` | Task | T-1.1.1, T-2.3.1 |
| `K-` | Retrospective: Keep | K1, K2, K3 |
| `P-` | Retrospective: Problem | P1, P2 |
| `L-` | Retrospective: Learning | L1, L2 |
| `A-` | Retrospective: Action | A1, A2 |
| `D-` | Technical Debt item | D-001, D-002 |
| `M-` | Metric | M-001, M-002 |

**Rules:**
- IDs are scoped to the document they appear in (not globally unique)
- Reference from another document: `[[document-name#FR-001]]`
- Sequential numbering within each document
- Once assigned, an ID is never reused in that document (even if the item is removed)

### 7. Bidirectional References

If document A references document B, then document B MUST reference document A.

**Implementation:**
1. `related` array in frontmatter of both documents
2. `## Referencias` section at the end of both documents
3. When generating multiple documents, ensure bidirectionality before finishing

**Verification:** After generating a batch of documents, check that for every `[[X]]` in document Y, document X contains `[[Y]]` in its `related` field or `## Referencias` section.

### 8. Metric Tables

When reporting quantitative data, use the standard metric table format:

```markdown
| Metric | Before | After | Delta | Status |
|--------|--------|-------|-------|--------|
| Test coverage | 72% | 89% | +17% | IMPROVED |
| Build time | 45s | 32s | -13s | IMPROVED |
| Bundle size | 2.4MB | 1.8MB | -0.6MB | IMPROVED |
| Open bugs | 12 | 8 | -4 | IN_PROGRESS |
```

**Status values:** `NOT_STARTED` | `IN_PROGRESS` | `IMPROVED` | `DEGRADED` | `COMPLETED` | `AT_RISK`

Use this format in: sprint plans (planned vs actual), retrospectives (before/after), progress dashboards (target vs current), technical reports (metrics section).

### 9. Graduation Gates

Sprint plans and phase-gated documents use checkbox-based graduation criteria:

```markdown
## Graduation Gate

Sprint {N} is approved for completion when ALL criteria are met:

- [x] All tasks marked complete with passing verification
- [x] No open P0/P1 blockers
- [ ] Test coverage >= 85% for new code
- [ ] Build passes in CI
- [ ] Code reviewed and approved
- [ ] PROGRESS.md updated with final metrics
```

**Rules:**
- Gates use `- [ ]` / `- [x]` checkbox syntax
- Criteria must be verifiable (not subjective)
- A document with unmet gates cannot transition to `completed` status
- Gates are checked by the executor skill (universal-planner-executor) or manually

### 10. Sequential Numbering

Documents within the same directory that have a reading order MUST use numeric prefixes:

```
requirement-analysis/
├── 01-problem-definition.md
├── 02-goals-and-success-metrics.md
├── 03-stakeholders-and-personas.md
├── 04-functional-requirements.md
├── 05-non-functional-requirements.md
├── 06-assumptions-and-constraints.md
└── 07-out-of-scope.md
```

**Rules:**
- Use two-digit zero-padded prefixes: `01-`, `02-`, ..., `99-`
- Sequential numbering indicates reading order, not priority
- Sprints use their sprint number: `SPRINT-1-name.md`, `SPRINT-2-name.md`
- Retrospectives pair with sprints: `RETRO-1-name.md`

### 11. Carried Forward Rules

When a document is part of a sequence (e.g., Sprint 2 follows Sprint 1), include a section for items carried from the previous document:

```markdown
## Carried Forward from [[SPRINT-1-foundation]]

The following items were not completed in Sprint 1 and are carried into this sprint:

- [ ] T-1.2.3 — Implement caching layer (blocked by ADR-3 in Sprint 1)
- [ ] T-1.3.1 — Add integration tests for auth module

**Decisions inherited:**
- DEC-2: Use Redis for session storage ([[SPRINT-1-foundation#DEC-2]])
```

**Rules:**
- Only Sprint 2+ and sequential documents include this section
- Reference the source document with wiki-links
- Include specific task IDs and decision IDs
- Place this section after the sprint header but before the first phase

### 12. Retrospective Template

When a skill generates a retrospective document (optional feature in universal-planner and universal-planner-executor):

```markdown
---
title: "Retrospective: Sprint {N} — {Sprint Name}"
date: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
project: "{project-name}"
type: "retrospective"
status: "active"
version: "1.0"
sprint: {N}
previous_doc: "[[SPRINT-{N}-name]]"
tags:
  - "{project-name}"
  - "retrospective"
  - "sprint-{N}"
changelog:
  - version: "1.0"
    date: "YYYY-MM-DD"
    changes: ["Initial retrospective"]
related:
  - "[[SPRINT-{N}-name]]"
  - "[[SPRINT-{N+1}-name]]"
  - "[[PROGRESS]]"
---

# Retrospective: Sprint {N} — {Sprint Name}

## Context
{Brief description of what the sprint aimed to accomplish and its outcome}

## Keep (What Went Well)
- **K1**: {What to continue doing}
- **K2**: {What to continue doing}

## Problems (What Went Wrong)
- **P1**: {Issue encountered}
- **P2**: {Issue encountered}

## Learnings (What We Learned)
- **L1**: {Insight gained}
- **L2**: {Insight gained}

## Actions (What to Do Differently)
- **A1**: {Concrete action for next sprint} -> Assigned to: {who}
- **A2**: {Concrete action for next sprint} -> Assigned to: {who}

## Metrics

| Metric | Planned | Actual | Delta | Status |
|--------|---------|--------|-------|--------|
| Tasks completed | {N} | {N} | {+/-N} | {status} |
| {Custom metric} | {target} | {actual} | {delta} | {status} |

## Signals to Watch
- {Early warning indicator for next sprint}
- {Trend to monitor}

## Verdict
{One paragraph: was the sprint successful? Key takeaway for the team.}

## Referencias

**Parent:** [[PROGRESS]]
**Input Documents:** [[SPRINT-{N}-name]]
**Siblings:** [[RETRO-{N-1}-name]], [[RETRO-{N+1}-name]]
```

---

## Compliance Checklist

When validating that a skill's output follows this standard:

- [ ] Every `.md` file has YAML frontmatter with all required fields
- [ ] `type` field uses a value from the Document Type Taxonomy
- [ ] All inter-document references use `[[wiki-links]]` (no relative markdown links)
- [ ] Every document ends with `## Referencias`
- [ ] Living documents have `version` and `changelog` maintained
- [ ] IDs follow the prefix convention (FR-, ADR-, T-, K-, P-, L-, A-, D-, M-)
- [ ] Bidirectional references are reciprocal
- [ ] Metric tables use the standard format
- [ ] Graduation gates use verifiable checkbox criteria
- [ ] Sequential documents use `01-`, `02-` prefixes
- [ ] Sprint 2+ documents include `## Carried Forward`
- [ ] No `[text](relative-path.md)` patterns for inter-document links
