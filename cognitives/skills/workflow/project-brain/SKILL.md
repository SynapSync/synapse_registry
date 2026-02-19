---
name: project-brain
description: >
  Session memory for AI agents — load context at the start, save sessions at the end,
  evolve knowledge across sessions. Like a professional's notebook: open before work,
  write a summary when done, persist between sessions.
  Trigger: When starting a session and need to recover context, or ending a session and
  want to save what happened.
license: Apache-2.0
metadata:
  author: synapsync
  version: "2.0"
  scope: [root]
  auto_invoke:
    # English triggers — LOAD
    - "load project brain"
    - "read project brain"
    - "restore context from"
    - "recover session context"
    - "load brain document"
    - "brief me on the project"
    - "what's the project state"
    - "load context from"
    - "pick up where we left off"
    # English triggers — SAVE
    - "save project brain"
    - "save session"
    - "update the brain"
    - "save what we did"
    - "write session summary"
    - "persist this session"
    # Spanish triggers — LOAD
    - "carga el brain del proyecto"
    - "lee el brain"
    - "recupera el contexto"
    - "ponme al dia del proyecto"
    - "carga el contexto de sesion"
    - "retoma la sesion desde"
    - "recupera la sesion anterior"
    # Spanish triggers — SAVE
    - "guarda el brain del proyecto"
    - "guarda la sesion"
    - "actualiza el brain"
    - "guarda lo que hicimos"
    - "escribe el resumen de sesion"
    - "persiste esta sesion"
  changelog:
    - version: "2.0"
      date: "2026-02-19"
      changes:
        - "Added SAVE mode with INIT and UPDATE sub-modes"
        - "Auto-discovery of brain documents in .agents/project-brain/"
        - "Standard brain document format (BRAIN-DOCUMENT template)"
        - "Incremental merge algorithm for non-destructive updates"
        - "Session Log with newest-first ordering and compaction at 15+ entries"
        - "Backward-compatible parsing: v2.0, v1.0, and free-form formats"
        - "Interactive path resolution (ask once, remember)"
        - "Modular assets architecture (modes, helpers, templates)"
    - version: "1.0"
      date: "2026-02-18"
      changes:
        - "Initial release — single LOAD mode, Obsidian MCP + filesystem fallback, format-agnostic parsing"
allowed-tools: Read, Edit, Write, Glob, Grep, ToolSearch, AskUserQuestion
---

# Project Brain

## Assets

This skill uses a modular assets architecture. Detailed workflows, helpers, and templates are in the [assets/](assets/) directory:

- **[assets/modes/](assets/modes/)** — LOAD and SAVE mode workflows
- **[assets/helpers/](assets/helpers/)** — Incremental merge algorithm
- **[assets/templates/](assets/templates/)** — Standard brain document format

See [assets/README.md](assets/README.md) for full directory documentation.

---

## Purpose

Project Brain is **session memory for AI agents**. It bridges the gap between sessions so any agent can pick up exactly where the last one left off — and save what it learned before shutting down.

**Design principle**: Agents behave like professionals with a notebook. Open the notebook before work (LOAD), write a summary when done (SAVE), and the notebook persists between sessions. Memory is a natural part of the workflow, not an extra step.

**What it does:**
- **LOAD**: Reads a brain document, parses structured context, delivers a concise briefing
- **SAVE**: Captures session context, creates or incrementally updates a brain document

**What a brain document is:**
A markdown file that captures project state, session history, architecture decisions, and next steps. The standard format (v2.0) has defined sections, but the skill also reads v1.0 and free-form documents.

---

## Critical Rules

> **RULE 1 — NO FABRICATION**
>
> Only report information that exists in the brain document (LOAD) or was explicitly discussed in the session (SAVE). Never infer, guess, or complete missing data.

> **RULE 2 — USER CONFIRMS BEFORE WRITE**
>
> In SAVE mode, always present the gathered session data to the user for review before writing. Never write without confirmation.

> **RULE 3 — INCREMENTAL NOT DESTRUCTIVE**
>
> SAVE UPDATE merges new data into existing sections. It never overwrites the full document. Accumulated Context is append-only. Session Log is prepend-only.

> **RULE 4 — FORMAT BACKWARD-COMPATIBLE**
>
> LOAD parses three formats: v2.0 standard, v1.0 sections, and free-form markdown. SAVE UPDATE detects the format and offers migration if the document isn't v2.0.

> **RULE 5 — PATH RESOLUTION ONCE**
>
> Ask for the path once and remember it for the session. Auto-discovery in `.agents/project-brain/` runs first. Don't re-ask unless the user wants to change the path.

> **RULE 6 — LANGUAGE MATCH**
>
> Respond in the same language the user used. Brain document content is presented as-is, never translated.

---

## Mode Detection

| Mode | EN Signals | ES Signals | What It Does |
|------|-----------|-----------|-------------|
| **LOAD** | "load brain", "restore context", "brief me", "pick up where we left off" | "carga el brain", "recupera el contexto", "ponme al dia" | Auto-discovers brain, reads it, delivers context briefing |
| **SAVE** | "save brain", "save session", "update brain", "persist session" | "guarda el brain", "guarda la sesion", "actualiza el brain" | Gathers session data, creates or updates brain document |

**Disambiguation**: If the user's intent is unclear, ask:

> "Do you want me to **load** a brain document (restore context) or **save** the current session (capture what we did)?"

---

## Quick Start

### LOAD Mode

Use at the start of a session to restore context:

```
Load the project brain.
```

This will: check `.agents/project-brain/` for existing documents, read the brain, parse sections, and deliver a context briefing with project identity, active state, last session, and next steps.

**Full workflow:** See [assets/modes/LOAD.md](assets/modes/LOAD.md)

### SAVE Mode

Use at the end of a session to persist what happened:

```
Save the session to the brain.
```

This will: detect if a brain exists (UPDATE) or not (INIT), gather session summary/decisions/discoveries/files/next-steps, confirm with you, and write or merge the brain document.

**Full workflow:** See [assets/modes/SAVE.md](assets/modes/SAVE.md)

---

## Capabilities Matrix

| Capability | LOAD | SAVE (INIT) | SAVE (UPDATE) |
|-----------|:----:|:-----------:|:-------------:|
| Auto-discover brain documents | Yes | No | Yes |
| Read brain from Obsidian MCP | Yes | No | No |
| Read brain from filesystem | Yes | No | No |
| Parse v2.0, v1.0, free-form | Yes | No | Yes |
| Deliver context briefing | Yes | No | No |
| Create new brain document | No | Yes | No |
| Incremental merge | No | No | Yes |
| Gather session context | No | Yes | Yes |
| Offer format migration | No | No | Yes |

---

## Integration with Other Skills

| Skill | Integration |
|-------|------------|
| `sprint-forge` | LOAD reads sprint-forge re-entry prompts. SAVE captures sprint progress as session entries. |
| `obsidian` | LOAD can read brain documents from Obsidian vault via MCP with filesystem fallback. |
| `universal-planner` | LOAD reads planning documents. SAVE captures planning decisions. |

**Composition patterns:**
```
session start  → project-brain LOAD  → agent is briefed → work happens
session end    → project-brain SAVE  → session persisted → next agent can LOAD
```

```
sprint-forge INIT  → generates findings + roadmap
project-brain SAVE → captures sprint-forge session → brain document created
new session        → project-brain LOAD → full context restored
```

---

## Limitations

1. **Markdown only**: Handles `.md` files; does not parse `.yaml`, `.json`, or other formats
2. **Single file**: One brain document per project — not a recursive folder reader
3. **No synthesis**: If the brain document is outdated, the briefing reflects that
4. **MCP for Obsidian only in LOAD**: SAVE always writes to filesystem (Obsidian syncs via the `obsidian` skill if needed)
5. **Session Log size**: Compacted at 15+ entries — older sessions become a summary paragraph
6. **No auto-save**: SAVE must be explicitly invoked — the agent doesn't auto-save on exit

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-02-19 | SAVE mode (INIT + UPDATE), auto-discovery, standard brain format, incremental merge, session compaction, backward-compatible parsing, modular assets |
| 1.0 | 2026-02-18 | Initial release — LOAD mode, Obsidian MCP + filesystem fallback, format-agnostic parsing |
