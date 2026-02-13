# Batch Sync Pattern Helper

## Purpose

Optimize the workflow for syncing multiple files to Obsidian by parallelizing reads, minimizing user interaction, and processing writes efficiently. This pattern significantly reduces latency when syncing entire directories or glob patterns.

## When to Use

- User asks to sync a directory (e.g., `{output_base}/planning/`)
- User asks to sync multiple files by pattern (e.g., "sync all reports from today")
- After another skill produces multiple documents and user wants all synced

## Antipattern: Sequential Per-File Sync

**Inefficient approach:**
```
For each file:
  1. Read file
  2. Load MCP tools
  3. List vault directory
  4. Ask user where to save
  5. Write file
  6. Report result
```

**Problems:**
- MCP tools loaded N times (once per file)
- Vault listed N times
- User asked N times for destination
- High latency — sequential blocking operations

## Optimized Batch Pattern

### Step 1: Discover All Files Once

Use `Glob` to collect all files to sync:

```
Glob pattern: "{output_base}/planning/**/*.md"
```

**Result:** List of absolute file paths:
```
[
  "/path/to/00-strategic-analysis.md",
  "/path/to/01-technical-debt.md",
  "/path/to/02-growth-vision.md"
]
```

### Step 2: Read All Files in Parallel

Make multiple `Read` tool calls in a single message:

```
Read("/path/to/00-strategic-analysis.md")
Read("/path/to/01-technical-debt.md")
Read("/path/to/02-growth-vision.md")
```

**Result:** All file contents loaded simultaneously, no sequential blocking.

### Step 3: Load MCP Tools Once

Load all required Obsidian MCP tools in one batch:

```
ToolSearch query: "+obsidian list"
ToolSearch query: "+obsidian write"
```

**Result:** Tools loaded once for the entire batch.

### Step 4: List Vault Directory Once

List the vault structure to build destination options:

```
mcp__obsidian__list_directory(path: "/")
mcp__obsidian__list_directory(path: "/work")
```

**Result:** Vault structure cached for all file destination decisions.

### Step 5: Ask User Once for Destination

Present a single `AskUserQuestion` for the entire batch:

```
AskUserQuestion:
  question: "Where should I save these 3 documents in your Obsidian vault?"
  header: "Batch sync destination"
  options:
    - label: "work/agent-sync-sdk/plans (Recommended)"
    - label: "work/agent-sync-sdk/"
    - label: "Create new folder"
```

**Result:** User answers once, destination applies to all files in batch.

### Step 6: Write Files Sequentially

Process writes one at a time to avoid MCP race conditions:

```
For each file:
  mcp__obsidian__write_note(
    path: "{destination}/{filename}.md",
    content: content,
    frontmatter: generated_frontmatter
  )
```

**Why sequential?** The Obsidian MCP server may not safely support parallel writes. Sequential writes ensure data integrity.

### Step 7: Validate Cross-References (Batch Only)

After all files are written, run cross-reference validation (see `cross-ref-validator.md`):

```
For each synced file pair (A, B):
  If A references B, verify B references A
  If missing, fix the reverse reference
```

**Result:** Knowledge graph integrity maintained across the batch.

### Step 8: Report All Results Once

Provide a single comprehensive report:

```
Synced 3 files to Obsidian:
  - work/agent-sync-sdk/plans/00-strategic-analysis.md
  - work/agent-sync-sdk/plans/01-technical-debt.md
  - work/agent-sync-sdk/plans/02-growth-vision.md

Cross-reference validation:
  ✓ All references bidirectional

Total: 3 files synced successfully to work/agent-sync-sdk/plans/
```

## Timing Comparison

**Sequential approach:**
```
File 1: Read (1s) + Load MCP (2s) + List vault (1s) + Ask user (user wait) + Write (1s) = ~5s + user wait
File 2: Read (1s) + Load MCP (2s) + List vault (1s) + Ask user (user wait) + Write (1s) = ~5s + user wait
File 3: Read (1s) + Load MCP (2s) + List vault (1s) + Ask user (user wait) + Write (1s) = ~5s + user wait

Total: ~15s + 3x user wait
```

**Batch pattern:**
```
Discover (0.5s)
Read all in parallel (1s)
Load MCP once (2s)
List vault once (1s)
Ask user once (user wait)
Write 3 files sequentially (3s)
Validate cross-refs (1s)
Report (0.5s)

Total: ~9s + 1x user wait
```

**Improvement:** ~40% faster, 67% fewer user interactions.

## Implementation Checklist

When implementing batch sync:

- [ ] Glob all files once at the start
- [ ] Read all files in parallel (multiple Read calls in one message)
- [ ] Load MCP tools once before any writes
- [ ] List vault structure once before asking user
- [ ] Ask user once for destination (not per file)
- [ ] Write files sequentially (not in parallel)
- [ ] Run cross-reference validation after all writes
- [ ] Report all results in a single summary

## Example: Full Batch Flow

**User request:** "sync {output_base}/planning/2026-02-10/ to obsidian"

**Step 1: Discover**
```bash
Glob("{output_base}/planning/2026-02-10/**/*.md")
# Found: 00-strategic-analysis.md, 01-technical-debt.md, 02-growth-vision.md
```

**Step 2: Read all in parallel**
```
Read("{output_base}/planning/2026-02-10/00-strategic-analysis.md")
Read("{output_base}/planning/2026-02-10/01-technical-debt.md")
Read("{output_base}/planning/2026-02-10/02-growth-vision.md")
```

**Step 3: Load MCP once**
```
ToolSearch("+obsidian list")
ToolSearch("+obsidian write")
```

**Step 4: List vault once**
```
mcp__obsidian__list_directory(path: "/")
mcp__obsidian__list_directory(path: "/work")
```

**Step 5: Ask user once**
```
AskUserQuestion: "Where should I save these 3 documents?"
User selects: "work/agent-sync-sdk/plans"
```

**Step 6: Write sequentially**
```
mcp__obsidian__write_note("work/agent-sync-sdk/plans/00-strategic-analysis.md", ...)
mcp__obsidian__write_note("work/agent-sync-sdk/plans/01-technical-debt.md", ...)
mcp__obsidian__write_note("work/agent-sync-sdk/plans/02-growth-vision.md", ...)
```

**Step 7: Validate cross-refs**
```
Cross-reference validation:
  ✓ 00-strategic-analysis ↔ 01-technical-debt (bidirectional)
  ✓ All references validated
```

**Step 8: Report**
```
Synced 3 files to Obsidian:
  - work/agent-sync-sdk/plans/00-strategic-analysis.md
  - work/agent-sync-sdk/plans/01-technical-debt.md
  - work/agent-sync-sdk/plans/02-growth-vision.md

3 files synced successfully to vault folder: work/agent-sync-sdk/plans/
```

## Limits

| Limit | Value | Rationale |
|-------|-------|-----------|
| Max files per batch | **20** | Beyond 20, sequential MCP writes become slow and context window fills with parallel reads |
| Max parallel reads | **10** | Claude Code supports multiple parallel tool calls but 10+ risks context overflow |
| Max total content | **~50,000 tokens** | Reading 20 large files may approach context limits; summarize or split if needed |

**For batches exceeding 20 files:**
1. Split into sub-batches of 20
2. Process each sub-batch with the full batch pattern (Steps 1-8)
3. Run cross-reference validation once after all sub-batches complete
4. Report consolidated results

---

## Edge Cases

### Single File Sync

If only 1 file is being synced, still follow the batch pattern but skip Step 7 (cross-reference validation). Single-file syncs don't benefit from batch optimizations but should use the same workflow for consistency.

### User Specifies Different Destinations

If the user says "save file A to folder X and file B to folder Y", that's NOT a batch sync. Process each file individually with its own destination.

### Empty Glob Result

If the glob pattern returns no files:
- Report to user: "No markdown files found in {path}"
- Do not proceed with sync workflow

### MCP Server Timeout

If the MCP server becomes unresponsive during batch writes:
- Report which files succeeded and which failed
- Suggest user check Obsidian REST API status
- Do not retry automatically (may cause duplicates)

## Best Practices

1. **Always glob first** — know the full scope before starting
2. **Parallelize reads, serialize writes** — reads are safe to parallelize, writes are not
3. **Ask once, apply to all** — minimize user interaction for better UX
4. **Validate after, not during** — batch cross-reference validation is more efficient
5. **Report comprehensively** — show all files synced and any validation fixes

## Limitations

- **Same destination for all files** — if files need different destinations, batch pattern doesn't apply
- **No partial retry** — if batch fails midway, user must retry the entire batch
- **Sequential write bottleneck** — large batches (50+ files) may be slow due to sequential writes
