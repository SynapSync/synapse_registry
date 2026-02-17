# Configuration Resolver

## Purpose

Resolve the `{output_dir}` path that determines where all planning output documents are stored. This is a **standardized workflow** used across all SynapSync skills that generate output.

## Why This Exists

Every skill that produces documents needs to know WHERE to save them. Instead of config files, we use a **deterministic staging path** — computed from the skill name and project name. No user interaction needed for path resolution.

## Staging Path Formula

```
{output_dir} = .agents/staging/{skill-name}/{project-name}/
```

- `{skill-name}` — the skill's name (e.g., `universal-planner`, `code-analyzer`, `sprint-forge`)
- `{project-name}` — inferred from the current directory name or git repository name

## Workflow

Follow these steps at the **beginning** of any skill execution that generates output:

### Step 1: Infer Project Name

Infer the project name from:

1. **Git repository name** (if in a git repo)
2. **Current directory name** (fallback)

```bash
# Get git repo name
git remote get-url origin | sed 's/.*\///' | sed 's/\.git$//'

# Or use directory name
basename $(pwd)
```

### Step 2: Compute Staging Path

Set `{output_dir}` using the formula:

```
{output_dir} = .agents/staging/universal-planner/{project-name}/
```

**Example:**

```
Project: my-awesome-app
{output_dir} = .agents/staging/universal-planner/my-awesome-app/
```

### Step 3: Create Directory

If the directory doesn't exist, create it:

```bash
mkdir -p .agents/staging/universal-planner/{project-name}
```

### Step 4: Present to User

Inform the user of the resolved path:

```
Output documents will be stored in: .agents/staging/universal-planner/{project-name}/

Proceed?
```

### Step 5: Use {output_dir}

Throughout the skill, use `{output_dir}` as a variable:

```
{output_dir}/planning/{feature-name}/
{output_dir}/technical/{module-name}/
{output_dir}/docs/{category}/
```

The skill replaces `{output_dir}` with the resolved value.

## Path Details

**Rules:**

- **Path type:** Relative to project root (always starts with `.agents/staging/`)
- **No trailing slash in the stored value:** `.agents/staging/universal-planner/my-project` (not `.agents/staging/universal-planner/my-project/`). When using the value, append `/` as needed (e.g., `{output_dir}/planning/`).
- **Deterministic:** Same project + same skill = same path, every time. No user input needed for resolution.

## Error Handling

### Directory Creation Fails

If the directory cannot be created (permissions issue):

```
ERROR: Cannot create staging directory: .agents/staging/universal-planner/{project-name}

Please check permissions or specify an alternative path.
```

### Project Name Cannot Be Inferred

If neither git remote nor directory name yields a usable slug:

```
Could not infer the project name. What should I call this project?
(This will be used for the output path: .agents/staging/universal-planner/{your-name}/)
```

## Example: Full Resolution Flow

**Scenario:** User invokes `universal-planner` in a project directory.

```
Step 1: Infer project name
→ Git repo: "my-awesome-app"
→ Project name: "my-awesome-app"

Step 2: Compute staging path
→ {output_dir} = .agents/staging/universal-planner/my-awesome-app/

Step 3: Create directory
→ mkdir -p .agents/staging/universal-planner/my-awesome-app

Step 4: Present to user
→ "Output documents will be stored in: .agents/staging/universal-planner/my-awesome-app/"

Step 5: Use output_dir
→ Planning output will go to:
   .agents/staging/universal-planner/my-awesome-app/planning/new-feature/
```

## Usage in Skills

When a skill needs to use this helper, include a reference in the skill's "Configuration Resolution" section:

```markdown
## Configuration Resolution

See [assets/helpers/config-resolver.md](assets/helpers/config-resolver.md) for the standardized workflow.

**Quick summary:**

1. Infer project name from directory/git
2. Set `{output_dir}` = `.agents/staging/{skill-name}/{project-name}/`
3. Create directory if needed
4. Use `{output_dir}/` for all output paths
```

Then invoke the workflow before any output generation.

## Rationale

**Why deterministic staging paths?**

- **No config files needed** — eliminates `cognitive.config.json` complexity
- **Predictable** — same project always gets the same path
- **Local-first** — output stays in the project directory until the user decides where it goes
- **Post-production delivery** — after generating docs, the user can sync to Obsidian vault, move to a custom path, or keep in staging

**Why `.agents/staging/`?**

- `.agents/` is a hidden directory (gitignored) — keeps project root clean
- `staging/` makes it clear these are temporary outputs awaiting delivery
- `{skill-name}/` prevents collision between skills

## Related

- Output format follows the Obsidian markdown conventions (frontmatter, wiki-links, type taxonomy)
- See `obsidian` skill (SYNC mode) for syncing staging output to Obsidian vault via MCP
- See SKILL.md Post-Production Delivery for the delivery workflow after generation

## Version

Created: 2026-02-12 (v2.1.0)
Updated: 2026-02-17 (v3.2.0) — Migrated from cognitive.config.json to deterministic staging paths
Pattern: Shared helper for output path resolution
