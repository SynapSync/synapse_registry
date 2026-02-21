# Brain Directory Resolution

Resolves `{brain_dir}` — the directory where brain documents are stored. Run this before any path-dependent operation.

## Algorithm

1. **Read** `{cwd}/AGENTS.md`
2. **Scan** for `<!-- synapsync-skills:start -->` … `<!-- synapsync-skills:end -->` block
3. If found → find `## Configuration` table → look for `brain_dir` row → extract value → set `{brain_dir}`, **done**
4. If not found (no AGENTS.md, no block, or no `brain_dir` row) → **ask the user**:
   - Default (Recommended): `.agents/staging/project-brain/`
   - Or custom path via "Other"
5. **Persist** the chosen value to AGENTS.md — see [brain-config.md](brain-config.md) for persistence rules and block template
6. **Validate**: directory not existing is OK for SAVE INIT (will create). For LOAD, report error and ask for alternative path.

After resolution, `{brain_dir}` is set for all subsequent operations.
