# Configuration Resolver

## Purpose

Resolve the `{output_dir}` path that determines where all planning output documents are stored. This is a **standardized workflow** used across all SynapSync skills that generate output.

## Why This Exists

Every skill that produces documents needs to know WHERE to save them. The **single source of truth** is the branded AGENTS.md block — a persistent config that remembers the path across sessions. When no config exists (first-time use), skills **ask the user** for their preferred path, persist it to AGENTS.md, and never ask again.

## Resolution Priority

1. **AGENTS.md branded block** (primary) → `<!-- synapsync-skills:start -->` Configuration table → `output_dir` row
2. **Ask the user** (first-time only) → offer default or custom path → persist to AGENTS.md

**IMPORTANT**: Skills must NEVER silently write to a path without asking the user first. The default staging path is only an **option** offered to the user, not an automatic fallback.

## Default Staging Path (offered as option)

When asking the user, offer this as the default option:

```
.agents/staging/{skill-name}/{project-name}/
```

- `{skill-name}` — the skill's name (e.g., `universal-planner`, `code-analyzer`, `sprint-forge`)
- `{project-name}` — inferred from the current directory name or git repository name

## Workflow

Follow these steps at the **beginning** of any skill execution that generates output:

### Step 1: Check AGENTS.md Branded Block

Before anything else, check if `{output_dir}` is already persisted in the project's AGENTS.md:

1. Read `{cwd}/AGENTS.md`
2. Scan for `<!-- synapsync-skills:start -->` … `<!-- synapsync-skills:end -->` block
3. Find `## Configuration` table → look for an `output_dir` row
4. If found → set `{output_dir}` to the value, **skip to Step 4** (present to user)
5. If not found → continue to Step 2 (ask user)

### Step 2: Ask the User

If no `output_dir` is configured, **ask the user** where they want output stored:

1. Infer the project name from git repo or directory name
2. Present two options:

```
AskUserQuestion:
  question: "Where should output documents be stored?"
  header: "Output dir"
  options:
    - label: "Default (Recommended)"
      description: ".agents/staging/{skill-name}/{project-name}/"
    - label: "Custom path"
      description: "Provide a relative path from project root"
```

3. If user chooses **default** → set `{output_dir}` = `.agents/staging/{skill-name}/{project-name}/`
4. If user chooses **custom** → set `{output_dir}` to the path the user provides

### Step 3: Persist to AGENTS.md

Persist `{output_dir}` to the Configuration table in AGENTS.md so future sessions resolve at Step 1 directly. Follow the 6-case persistence rules from [project-brain brain-config.md](../../../workflow/project-brain/assets/helpers/brain-config.md).

### Step 4: Present to User

Inform the user of the resolved path:

```
Output documents will be stored in: {output_dir}/

Proceed?
```

### Step 5: Create Directory and Use {output_dir}

1. Create the directory if it doesn't exist
2. Throughout the skill, use `{output_dir}` as a variable:

```
{output_dir}/planning/{feature-name}/
{output_dir}/technical/{module-name}/
{output_dir}/docs/{category}/
```

The skill replaces `{output_dir}` with the resolved value.

## Path Details

**Rules:**

- **Path type:** Relative to project root. Can be any user-configured value (e.g., `docs/planning`, `output/reports`, or `.agents/staging/...`).
- **No trailing slash in the stored value:** `docs/planning` (not `docs/planning/`). When using the value, append `/` as needed (e.g., `{output_dir}/planning/`).
- **Resolved once:** After first resolution, the value is persisted in AGENTS.md and reused in all future sessions.

## Error Handling

### Directory Creation Fails

If the directory cannot be created (permissions issue):

```
ERROR: Cannot create directory: {output_dir}

Please check permissions or specify an alternative path.
```

### Project Name Cannot Be Inferred

If neither git remote nor directory name yields a usable slug:

```
Could not infer the project name. What should I call this project?
(This will be used for the default output path: .agents/staging/{skill-name}/{your-name}/)
```

## Example: Full Resolution Flow

**Scenario A:** User invokes `universal-planner` in a project with AGENTS.md configured.

```
Step 1: Check AGENTS.md branded block
→ Found <!-- synapsync-skills:start --> block
→ Configuration table has output_dir = "docs/planning"
→ {output_dir} = docs/planning
→ Skip to Step 4

Step 4: Present to user
→ "Output documents will be stored in: docs/planning/"

Step 5: Use output_dir
→ Planning output will go to:
   docs/planning/planning/new-feature/
```

**Scenario B:** First-time use — no AGENTS.md exists.

```
Step 1: Check AGENTS.md branded block
→ No AGENTS.md found → continue to Step 2

Step 2: Ask the user
→ "Where should output documents be stored?"
→ User chooses: "Custom path" → provides "my-project/planning"
→ {output_dir} = my-project/planning

Step 3: Persist to AGENTS.md
→ Create AGENTS.md with branded block containing output_dir = "my-project/planning"
→ Next invocation will resolve from AGENTS.md directly (Scenario A)

Step 4: Present to user
→ "Output documents will be stored in: my-project/planning/"

Step 5: Create directory and use output_dir
→ mkdir -p my-project/planning
→ Planning output will go to:
   my-project/planning/planning/new-feature/
```

**Scenario C:** First-time use — user chooses default.

```
Step 1: Check AGENTS.md branded block
→ No AGENTS.md found → continue to Step 2

Step 2: Ask the user
→ "Where should output documents be stored?"
→ User chooses: "Default" → .agents/staging/universal-planner/my-awesome-app/
→ {output_dir} = .agents/staging/universal-planner/my-awesome-app

Step 3: Persist to AGENTS.md
→ Create AGENTS.md with branded block containing output_dir row
→ Next invocation will resolve from AGENTS.md directly (Scenario A)

Step 4: Present to user
→ "Output documents will be stored in: .agents/staging/universal-planner/my-awesome-app/"

Step 5: Create directory and use output_dir
→ mkdir -p .agents/staging/universal-planner/my-awesome-app
```

## Usage in Skills

When a skill needs to use this helper, include a reference in the skill's "Configuration Resolution" section:

```markdown
## Configuration Resolution

See [assets/helpers/config-resolver.md](assets/helpers/config-resolver.md) for the standardized workflow.

**Quick summary:**

1. Check `AGENTS.md` branded block for persisted `output_dir` → if found, use it
2. If not found → **ask the user** (default `.agents/staging/...` or custom path)
3. Persist chosen value to AGENTS.md Configuration table
4. Use `{output_dir}/` for all output paths
```

Then invoke the workflow before any output generation.

## Rationale

**Why AGENTS.md branded block as single source?**

- **Persistent** — resolved once, remembered across all sessions and skills
- **User-configurable** — users choose their own path, not forced into staging
- **Shared** — all skills read/write the same Configuration table, avoiding fragmentation
- **Visible** — config lives in a committed file, not hidden state

**Why ask the user instead of silent fallback?**

- **User control** — the user decides where their output goes from the very first invocation
- **No surprises** — output never ends up in an unexpected directory
- **One-time cost** — the user is asked only once; the answer is persisted for all future sessions

**Why `.agents/staging/` as the default option?**

- `.agents/` is a hidden directory (gitignored) — keeps project root clean
- `staging/` makes it clear these are temporary outputs awaiting delivery
- `{skill-name}/` prevents collision between skills
- It's a sensible default for users who don't have a preference

## Related

- Output format follows the Obsidian markdown conventions (frontmatter, wiki-links, type taxonomy)
- See `obsidian` skill (SYNC mode) for syncing staging output to Obsidian vault via MCP
- See SKILL.md Post-Production Delivery for the delivery workflow after generation

## Version

Created: 2026-02-12 (v2.1.0)
Updated: 2026-02-20 (v4.0.0) — Breaking: staging is no longer a silent fallback. Skills MUST ask the user when no AGENTS.md config exists. Rewrote entire workflow, examples, rationale.
Pattern: Shared helper for output path resolution
