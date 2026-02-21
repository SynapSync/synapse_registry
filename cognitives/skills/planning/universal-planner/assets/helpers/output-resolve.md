# Output Directory Resolution

Resolves `{output_dir}` — the directory where planning documents are stored. Run this before any path-dependent operation.

## Algorithm

1. **Read** `{cwd}/AGENTS.md`
2. **Scan** for `<!-- synapsync-skills:start -->` … `<!-- synapsync-skills:end -->` block
3. If found → find `## Configuration` table → look for `output_dir` row → extract value → set `{output_dir}`, **done**
4. If not found (no AGENTS.md, no block, or no `output_dir` row) → **ask the user**:
   - Default (Recommended): `.agents/staging/universal-planner/{project-name}/`
   - Or custom path via "Other"
5. **Persist** the chosen value to AGENTS.md — see [config-resolver.md](config-resolver.md) for persistence rules and block template
6. **Create** the directory if it doesn't exist

After resolution, `{output_dir}` is set for all subsequent operations.
