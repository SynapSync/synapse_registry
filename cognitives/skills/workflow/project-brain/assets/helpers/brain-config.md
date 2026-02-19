# Brain Directory Configuration

Helper for resolving `{brain_dir}` — the directory where brain documents are stored. Both LOAD and SAVE modes call this before any file operations.

---

## Config Format

The brain directory is persisted in `{cwd}/AGENTS.md` inside an HTML comment block:

```markdown
<!-- synapsync:config -->
brain_dir: .agents/project-brain
<!-- /synapsync:config -->
```

- HTML comment delimiters — invisible when rendered, safe to append
- Simple `key: value` lines inside the block
- Relative paths only, no trailing slash
- Extensible for future synapsync keys

---

## Resolution Algorithm

Run this **before** any path-dependent step in LOAD or SAVE:

### Step 1 — Read AGENTS.md

1. Read `{cwd}/AGENTS.md`
2. Scan for a `<!-- synapsync:config -->` … `<!-- /synapsync:config -->` block
3. If the block exists and contains a `brain_dir:` line → extract the value, set `{brain_dir}`, done

### Step 2 — Auto-Discovery Fallback

If AGENTS.md doesn't exist, has no config block, or the block has no `brain_dir:` key:

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

After resolving `{brain_dir}`, persist the value to AGENTS.md so future sessions skip the resolution:

| Scenario | Action |
|----------|--------|
| No AGENTS.md exists | Create `{cwd}/AGENTS.md` with just the config block |
| AGENTS.md exists, no config block | Append the config block at the end of the file |
| Config block exists, `brain_dir` value is different | Update the `brain_dir:` line in place |
| Config block exists, `brain_dir` value is the same | No-op |

**Config block to write:**

```markdown

<!-- synapsync:config -->
brain_dir: {brain_dir}
<!-- /synapsync:config -->
```

When appending, add a blank line before the block for separation.

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
| Config block is malformed (missing closing tag, no key-value lines) | Ignore the block, fall back to auto-discovery, warn user |
