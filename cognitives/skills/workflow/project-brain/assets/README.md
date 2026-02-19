# Project Brain — Assets

This directory contains the modular components of the `project-brain` skill.

## Directory Structure

### modes/ (2 files)

| File | Description |
|------|-------------|
| [LOAD.md](modes/LOAD.md) | Auto-discovery, multi-format parsing, and context briefing |
| [SAVE.md](modes/SAVE.md) | INIT (create new) and UPDATE (incremental merge) sub-modes |

### helpers/ (2 files)

| File | Description |
|------|-------------|
| [brain-config.md](helpers/brain-config.md) | Resolves `{brain_dir}` from AGENTS.md config with auto-discovery fallback |
| [incremental-merge.md](helpers/incremental-merge.md) | Per-section merge algorithm for SAVE UPDATE, session compaction, migration |

### templates/ (1 file)

| File | Description |
|------|-------------|
| [BRAIN-DOCUMENT.md](templates/BRAIN-DOCUMENT.md) | Standard v2.0 brain document format with all sections |
