# SAVE Mode

Saves session context to a brain document. Two sub-modes: **INIT** (create new) and **UPDATE** (merge into existing).

---

## Step 0 — Detect Sub-Mode

1. Check `{cwd}/.agents/project-brain/` for existing `.md` files
2. If **at least one file exists** → **UPDATE** (ask which file if multiple)
3. If **no files exist** → **INIT**

The user can override: "save as new brain" forces INIT even if one exists.

---

## Step 1 — Resolve Output Path (INIT only)

Ask before the first write:

> "Where should I save the brain document for **{project_name}**?
>
> 1. **Local** (default) — `.agents/project-brain/{project-name}.md`
> 2. **Custom path** — provide a root and I'll save to `{root}/{project-name}.md`"

Path resolution:
- **Option 1**: `{cwd}/.agents/project-brain/{project-name}.md` — create `.agents/project-brain/` if needed
- **Option 2**: `{user-root}/{project-name}.md` — save directly, no `project-brain/` namespace

`{project-name}` is inferred from the current directory name or git repository name (kebab-case).

For UPDATE, the path is already known from Step 0.

---

## Step 2 — Gather Session Context

Synthesize from the current conversation:

1. **Summary**: 2-3 sentences of what was accomplished this session
2. **Decisions**: Explicit decisions made (architecture choices, library selections, approach changes)
3. **Discoveries**: Non-obvious findings (bugs found, performance insights, undocumented behaviors)
4. **Files Changed**: Run `git diff --name-only` if git repo; otherwise ask the user
5. **Next Steps**: What should happen next, prioritized

For **INIT** only, also gather:
6. **Project Identity**: Name, purpose, stack, repository, key paths — infer from cwd or ask
7. **Key Files**: Critical project files and why they matter

### Confirmation Gate

**Present all gathered data to the user for review before writing.** Format it clearly:

```
Here's what I'll save to the brain document:

**Summary**: {summary}
**Decisions**: {list}
**Discoveries**: {list}
**Files Changed**: {list}
**Next Steps**: {list}

{For INIT: also show Project Identity and Key Files}

Confirm? I can adjust anything before saving.
```

Do NOT write until the user confirms.

---

## Step 3 — Write (INIT) or Merge (UPDATE)

### INIT Sub-Mode

1. Fill the BRAIN-DOCUMENT template (see [templates/BRAIN-DOCUMENT.md](../templates/BRAIN-DOCUMENT.md)):
   - Set all `{placeholders}` with gathered data
   - Session Log starts with `### Session 1 — {today's date}`
   - Accumulated Context starts empty (just headers) unless the user provided architecture decisions
   - Set metadata: `Last updated: {today}`, `Sessions: 1`
2. Write the file to the resolved path

### UPDATE Sub-Mode

Use the incremental merge algorithm (see [helpers/incremental-merge.md](../helpers/incremental-merge.md)):

1. Read the existing brain document
2. Detect format:
   - **v2.0** → proceed with merge
   - **v1.0 or free-form** → offer migration first (see incremental-merge helper)
3. Apply per-section merge:

| Section | Strategy |
|---------|----------|
| Metadata (date, session count) | Update |
| Project Identity | Update only changed fields |
| Active State | Full replace |
| Session Log | Prepend new entry |
| Accumulated Context > Architecture Decisions | Append rows |
| Accumulated Context > Patterns & Conventions | Append (skip duplicates) |
| Accumulated Context > Constraints & Gotchas | Append (skip duplicates) |
| Next Steps | Full replace |
| Key Files | Merge (add new, update changed, keep rest) |

4. Write the merged document

---

## Step 4 — Confirm

Show a summary of what was saved:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROJECT BRAIN SAVED
  Path: {path}
  Session: {N} | Date: {today}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{For INIT:}
Created new brain document with Session 1.

{For UPDATE:}
Added Session {N}.
Updated: Active State, Next Steps{, N new architecture decisions}{, N new patterns}.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

No further steps. The file is already where the user chose to save it.
