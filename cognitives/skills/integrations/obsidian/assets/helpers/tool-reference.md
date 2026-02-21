# Tool Reference

Detailed parameter contracts for all tools used by the obsidian skill. Load MCP tools via `ToolSearch` before first use (see SKILL.md Rule 1).

## Native Claude Code Tools (provided by runtime)

These tools are part of the Claude Code environment and require no special setup:

| Tool | Usage in This Skill |
|------|-------------------|
| `ToolSearch` | Load deferred MCP tools before first use. Input: `query` string (e.g., `"+obsidian write"`). Output: loaded tool definitions. |
| `AskUserQuestion` | Prompt user for choices (vault destination, config paths). Input: `questions` array with `question`, `header`, `options`. Output: user selection. |
| `Read` | Read local files. Input: `file_path` (absolute). Output: file content with line numbers. |
| `Write` | Create/overwrite files. Input: `file_path`, `content`. |
| `Glob` | Find files by pattern. Input: `pattern` (e.g., `"**/*.md"`). Output: matching file paths. |
| `Grep` | Search file contents. Input: `pattern`, `path`, `type`. Output: matching lines/files. |
| `Bash` | Run shell commands. Input: `command` string. Output: stdout/stderr. |

## MCP Tools (require Obsidian REST API server)

These tools are **deferred** — they must be loaded via `ToolSearch` before first use. They will fail if called without loading.

### Core Read/Write Tools

| Tool | Parameters | Description |
|------|-----------|-------------|
| `mcp__obsidian__write_note` | `path` (string): vault-relative path. `content` (string): markdown body **without** frontmatter YAML block. `frontmatter` (object, optional): key-value pairs to serialize as YAML. `mode` (string, optional): `"overwrite"` (default), `"append"`, or `"prepend"`. | Write a note to the vault. The MCP server serializes frontmatter and prepends it to content. Use `mode: "append"` to add content to an existing note without replacing it. |
| `mcp__obsidian__read_note` | `path` (string): vault-relative path. `prettyPrint` (boolean, optional). | Read a note. Returns content with frontmatter. |
| `mcp__obsidian__read_multiple_notes` | `paths` (string[], max 10): vault-relative paths. `includeContent` (boolean, optional, default true). `includeFrontmatter` (boolean, optional, default true). `prettyPrint` (boolean, optional). | Read multiple notes in one call. Use `includeContent: false` for metadata-only batch reads. |
| `mcp__obsidian__patch_note` | `path` (string): vault-relative path. `oldString` (string): exact string to replace. `newString` (string): replacement. `replaceAll` (boolean, optional, default false). | Efficient partial edit — replace a specific string without rewriting the entire note. Fails on multiple matches unless `replaceAll: true`. |
| `mcp__obsidian__delete_note` | `path` (string): vault-relative path. `confirmPath` (string): must exactly match `path`. | Delete a note permanently. Requires double confirmation. Always confirm with user before calling. |
| `mcp__obsidian__move_note` | `oldPath` (string): current path. `newPath` (string): destination path. `overwrite` (boolean, optional, default false). | Move or rename a note. Use for reorganization and archiving workflows. |

### Metadata Tools

| Tool | Parameters | Description |
|------|-----------|-------------|
| `mcp__obsidian__get_frontmatter` | `path` (string): vault-relative path. `prettyPrint` (boolean, optional). | Extract frontmatter without reading content. Fast path for ranking, filtering, and compliance checks. |
| `mcp__obsidian__update_frontmatter` | `path` (string): vault-relative path. `frontmatter` (object): fields to update. `merge` (boolean, optional, default true). | Update frontmatter without touching note body. Preferred over full read+write for metadata-only changes (cross-ref fixes, status updates). |
| `mcp__obsidian__get_notes_info` | `paths` (string[]): vault-relative paths. `prettyPrint` (boolean, optional). | Get metadata for multiple notes without reading content. Ideal for batch pre-checks, ranking, and existence validation. |

### Discovery Tools

| Tool | Parameters | Description |
|------|-----------|-------------|
| `mcp__obsidian__search_notes` | `query` (string): search text. `searchContent` (boolean, optional, default true). `searchFrontmatter` (boolean, optional, default false). `caseSensitive` (boolean, optional, default false). `limit` (number, optional, default 5, max 20). `prettyPrint` (boolean, optional). | Full-text search. Use `searchFrontmatter: true` for metadata queries. |
| `mcp__obsidian__list_directory` | `path` (string, optional, default "/"): vault-relative directory. `prettyPrint` (boolean, optional). | List files and subdirectories. |
| `mcp__obsidian__get_vault_stats` | `recentCount` (number, optional, default 5, max 20). `prettyPrint` (boolean, optional). | Get vault statistics and recently modified notes. |
| `mcp__obsidian__manage_tags` | `path` (string): vault-relative path to a **single note**. `operation` (string): `"add"`, `"remove"`, or `"list"`. `tags` (string[], required for add/remove). | Manage tags on a single note. **Not** a vault-wide tag listing tool. For vault-wide tag discovery, use `search_notes` with `searchFrontmatter: true`. |

## Important Gotchas

- **`write_note` frontmatter separation**: The `frontmatter` parameter is a **separate JSON object**, not part of `content`. Pass raw markdown body in `content` and structured metadata in `frontmatter`. The MCP server serializes the frontmatter into YAML and prepends it.
- **`write_note` auto-creates directories**: If directories in `path` don't exist, they are created automatically.
- **`write_note` mode**: `"overwrite"` (default) replaces the entire note, `"append"` adds to the end, `"prepend"` adds to the beginning.
- **`manage_tags` scope**: Operates on a **single note** only. For vault-wide tag discovery, use `search_notes` with `searchFrontmatter: true`.
- **`patch_note` multiple matches**: Fails on multiple matches unless `replaceAll: true`.
- **`delete_note` double confirmation**: `confirmPath` must exactly match `path`. Always confirm with user before calling.
