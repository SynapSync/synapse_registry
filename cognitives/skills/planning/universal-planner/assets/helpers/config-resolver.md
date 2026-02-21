# Configuration Resolver

## Purpose

Resolve the `{output_dir}` path that determines where all planning output documents are stored. For quick resolution, use [output-resolve.md](output-resolve.md) first — it covers the common case (config already persisted). This file contains the full persistence rules and error handling for first-time setup.

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

