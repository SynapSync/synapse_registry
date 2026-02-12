# Configuration Resolver

## Purpose

Resolve the `{output_base}` path that determines where all planning output documents are stored. This is a **standardized workflow** used across all SynapSync skills that generate output.

## Why This Exists

Every skill that produces documents needs to know WHERE to save them. Instead of duplicating this logic in every skill, we centralize it here. Skills reference this helper and follow the same pattern.

## Workflow

Follow these steps at the **beginning** of any skill execution that generates output:

### Step 1: Check for Config File

Look for `cognitive.config.json` in the **project root** (current working directory):

```bash
# Check if file exists
ls cognitive.config.json
```

### Step 2: If Found → Read output_base

If the file exists, read the `output_base` value:

```json
{
  "output_base": "~/.agents/my-project"
}
```

Use this value for all `{output_base}` references throughout the skill.

**Example:**

```
{output_base}/planning/my-feature/
→ ~/.agents/my-project/planning/my-feature/
```

### Step 3: If NOT Found → Resolve Interactively

If the file doesn't exist, resolve the path interactively:

#### 3a. Infer Project Name

Infer the project name from:

1. **Git repository name** (if in a git repo)
2. **Current directory name** (fallback)

```bash
# Get git repo name
git remote get-url origin | sed 's/.*\///' | sed 's/\.git$//'

# Or use directory name
basename $(pwd)
```

#### 3b. Ask User

Prompt the user with a suggested default:

```
Where should I store output documents for this project?

Suggested: ~/.agents/{project-name}/

Your choice: _____
```

**Important:** Make it easy to accept the default (e.g., pressing Enter accepts suggestion).

#### 3c. Create Config File

Once the user provides a path, create `cognitive.config.json` in the project root:

```json
{
  "output_base": "~/.agents/my-project"
}
```

```bash
# Example using Write tool
echo '{"output_base":"~/.agents/my-project"}' > cognitive.config.json
```

#### 3d. Inform User

Tell the user the config was saved:

```
✅ Configuration saved to cognitive.config.json
   Output will be stored in: ~/.agents/my-project/

   This path will be used for all future skill runs in this project.
```

### Step 4: Use {output_base}

Throughout the skill, use `{output_base}` as a variable:

```
{output_base}/planning/{feature-name}/
{output_base}/technical/{module-name}/
{output_base}/docs/{category}/
```

The skill replaces `{output_base}` with the resolved value.

## Config File Format

```json
{
  "output_base": "/absolute/path/to/output/directory"
}
```

**Rules:**

- **Required field:** `output_base` (string)
- **Path type:** Absolute path (can use `~` for home directory)
- **No trailing slash:** `~/.agents/my-project` ✅ (not `~/.agents/my-project/` ❌)

**Optional fields (future):**

- `default_mode`: Default planning mode
- `templates_dir`: Custom templates directory
- `obsidian_vault`: Obsidian vault name (for MCP integration)

## Error Handling

### Path Doesn't Exist

If the user provides a path that doesn't exist, offer to create it:

```
⚠️  Path doesn't exist: ~/.agents/my-project

Would you like me to create it? (Y/n): _____
```

If yes, create the directory:

```bash
mkdir -p ~/.agents/my-project
```

### Path Not Writable

If the path exists but isn't writable:

```
❌ Path is not writable: ~/.agents/my-project

Please choose a different path or fix permissions.

Your choice: _____
```

### JSON Malformed

If `cognitive.config.json` exists but is invalid JSON:

```
❌ Error reading cognitive.config.json: Invalid JSON

Please fix the file or delete it to create a new one.

Expected format:
{
  "output_base": "/path/to/output"
}
```

Do NOT proceed — ask the user to fix the file.

## Path Expansion

Always expand paths before using them:

| User Input                    | Expanded Path                               |
| ----------------------------- | ------------------------------------------- |
| `~/.agents/my-project` | `/Users/username/.agents/my-project` |
| `./output`                    | `/current/working/directory/output`         |
| `/absolute/path`              | `/absolute/path`                            |

Use the shell or language-specific path expansion (e.g., `os.path.expanduser()` in Python, `path.resolve()` in Node.js).

## Usage in Skills

When a skill needs to use this helper, include a reference in the skill's "Configuration Resolution" section:

```markdown
## Configuration Resolution

See [assets/helpers/config-resolver.md](assets/helpers/config-resolver.md) for the standardized workflow.

**Quick summary:**

1. Check `cognitive.config.json` → read `output_base`
2. If not found → ask user, create config
3. Use `{output_base}/` for all output paths
```

Then invoke the workflow before any output generation.

## Example: Full Resolution Flow

**Scenario:** User invokes `universal-planner` in a project without `cognitive.config.json`.

```
Step 1: Check for cognitive.config.json
→ File not found

Step 2: Infer project name
→ Git repo: "my-awesome-app"
→ Project name: "my-awesome-app"

Step 3: Ask user
→ "Where should I store output documents for this project?"
→ Suggested: ~/.agents/my-awesome-app/
→ User presses Enter (accepts default)

Step 4: Create config
→ Write cognitive.config.json:
   {
     "output_base": "~/.agents/my-awesome-app"
   }

Step 5: Inform user
→ "✅ Configuration saved to cognitive.config.json"

Step 6: Use output_base
→ Planning output will go to:
   ~/.agents/my-awesome-app/planning/new-feature/
```

## Rationale

**Why not hardcode paths?**

- Different users have different preferences (some use `~/Documents/`, some use `~/.agents/`)
- Projects live in different locations

**Why cognitive.config.json in project root?**

- **Per-project config:** Each project can have its own output destination
- **Version controlled:** The config can be committed to git (optional)
- **Discoverable:** Easy to find and edit

**Why ask only once?**

- **Better UX:** Don't interrupt the user every time
- **Consistency:** All output goes to the same place

**Why not use a global config?**

- Projects have different needs
- Some users want outputs in Obsidian, others in project docs/
- Per-project is more flexible

## Related

- See `obsidian-md-standard` for output format specifications
- See `obsidian-sync` for syncing output to Obsidian vault via MCP

## Version

Created: 2026-02-12 (v2.1.0)
Pattern: Shared helper for output path resolution
