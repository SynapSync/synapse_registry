# Brain Directory Configuration

Helper for resolving `{brain_dir}` — the directory where brain documents are stored. Both LOAD and SAVE modes call this before any file operations.

---

## Config Format

The brain directory is persisted in `{cwd}/AGENTS.md` inside the **SynapSync Skills block** — a branded, visible section where installed skills store their configuration.

### Block Template

```markdown
<!-- synapsync-skills:start -->
# {Project Name} Skills Guidelines

## How to Use This Guide

This section of the `AGENTS.md` file contains project-specific guidelines and available skills from [SynapSync Registry](https://github.com/SynapSync/synapse-registry).

## Configuration

| Key | Value | Description |
|-----|-------|-------------|
| `brain_dir` | `.agents/project-brain` | Session memory for AI agents — load context, save sessions, evolve knowledge |

---
<!-- synapsync-skills:end -->
```

### Block Rules

- **Delimiters**: `<!-- synapsync-skills:start -->` and `<!-- synapsync-skills:end -->`
- **`{Project Name}`**: inferred from the current directory name or git repository name, title-cased (e.g., `my-app` → `My App`)
- **Configuration table**: single `Key | Value | Description` table where any skill can add/update its own rows
- `Description` column contains the skill's short description (from manifest) so readers know what each key is for
- Any installed skill can add its config keys to the Configuration table (e.g., `brain_dir`, `output_dir`)

---

## Resolution Algorithm

Run this **before** any path-dependent step in LOAD or SAVE:

### Step 1 — Read AGENTS.md

1. Read `{cwd}/AGENTS.md`
2. Scan for a `<!-- synapsync-skills:start -->` … `<!-- synapsync-skills:end -->` block
3. If the block exists → find `## Configuration` table → look for a `brain_dir` row
4. If the `brain_dir` row exists → extract the value, set `{brain_dir}`, done

### Step 2 — Auto-Discovery Fallback

If AGENTS.md doesn't exist, has no SynapSync Skills block, or the block has no `brain_dir` key in the Configuration table:

1. Scan the default path `{cwd}/.agents/project-brain/` for `.md` files
2. If **brain files found** → set `{brain_dir}` = `.agents/project-brain`, then **persist** to AGENTS.md (see Persistence Rules below)
3. If **no brain files found** → ask the user:

```
AskUserQuestion:
  question: "Where should brain documents be stored?"
  header: "Brain dir"
  options:
    - label: "Default"
      description: ".agents/project-brain/ (recommended)"
    - label: "Custom path"
      description: "Provide a relative path from project root"
```

4. Set `{brain_dir}` to the chosen path, then **persist** to AGENTS.md

### Step 3 — Validate

After resolving `{brain_dir}`:
- If the directory does not exist yet, that's OK — SAVE INIT will create it
- If `{brain_dir}` points to a path that cannot be created (e.g., inside a read-only directory), report the error and ask for a different path

---

## Persistence Rules

After resolving `{brain_dir}`, persist the value to AGENTS.md so future sessions skip the resolution.

| # | Scenario | Action |
|---|----------|--------|
| 1 | No AGENTS.md exists | Create `{cwd}/AGENTS.md` with the full branded block (template below) including the `brain_dir` row |
| 2 | AGENTS.md exists, no `<!-- synapsync-skills:start -->` block | Append the full branded block at the end of the file (with a blank line for separation) |
| 3 | Block exists, no `## Configuration` section | Add `## Configuration` section with the `brain_dir` row before the closing `---` line |
| 4 | Block exists, `## Configuration` exists, no `brain_dir` row | Add `brain_dir` row to the Configuration table |
| 5 | Block exists, `## Configuration` exists, `brain_dir` value is different | Update the `brain_dir` row in place |
| 6 | Block exists, `## Configuration` exists, `brain_dir` value is the same | No-op |

### Block to Write (cases 1 and 2)

```markdown

<!-- synapsync-skills:start -->
# {Project Name} Skills Guidelines

## How to Use This Guide

This section of the `AGENTS.md` file contains project-specific guidelines and available skills from [SynapSync Registry](https://github.com/SynapSync/synapse-registry).

## Configuration

| Key | Value | Description |
|-----|-------|-------------|
| `brain_dir` | {brain_dir} | Session memory for AI agents — load context, save sessions, evolve knowledge |

---
<!-- synapsync-skills:end -->
```

When appending (case 2), add a blank line before the block for separation.

---

## Variable Usage

Once `{brain_dir}` is resolved, all path references in LOAD, SAVE, and helpers use it:

| Variable | Expands To | Example |
|----------|-----------|---------|
| `{brain_dir}/` | Brain document directory | `.agents/project-brain/` |
| `{brain_dir}/{project-name}.md` | Default brain file path | `.agents/project-brain/my-app.md` |
| `{brain_dir}/archive/` | Session archive directory | `.agents/project-brain/archive/` |

---

## Error Handling

| Error | Action |
|-------|--------|
| AGENTS.md exists but is not readable | Warn user, fall back to auto-discovery |
| AGENTS.md is not writable (persistence fails) | Warn user, continue with resolved `{brain_dir}` in memory — the session still works, but the next session will re-resolve |
| `brain_dir` path in AGENTS.md points to a non-existent directory | Check if it's a LOAD (error — brain expected) or SAVE INIT (OK — will create). For LOAD, report the path and ask user to confirm or provide an alternative |
| SynapSync Skills block is malformed (missing closing tag, no Configuration table) | Ignore the block, fall back to auto-discovery, warn user |
