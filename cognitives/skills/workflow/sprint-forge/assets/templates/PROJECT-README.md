# {project_name} — Working Project

> Type: {work_type}
> Created: {date}
> Codebase: `{codebase_path}`

---

## What Is This

This directory contains the working artifacts for {description_of_work}. It is managed by the `sprint-forge` skill and follows an adaptive sprint workflow.

---

## For AI Agents — Mandatory Reading Order

If you are an AI agent resuming work on this project, read these files in order:

1. **This README** — You are here. Understand the project structure.
2. **ROADMAP.md** — The adaptive roadmap with all planned sprints and execution rules.
3. **Last completed sprint** — The most recent sprint file in `sprints/`. Read its retro, recommendations, and debt table.
4. **RE-ENTRY-PROMPTS.md** — Pre-written prompts for common actions. Copy the appropriate one.

---

## Directory Structure

```
{output_dir}/
├── README.md              ← This file
├── ROADMAP.md             ← Adaptive roadmap (living document)
├── RE-ENTRY-PROMPTS.md    ← Context recovery prompts
├── findings/              ← Analysis findings (one file per area)
│   ├── 01-{slug}.md
│   ├── 02-{slug}.md
│   └── ...
└── sprints/               ← Sprint documents (generated one at a time)
    ├── SPRINT-1-{slug}.md
    ├── SPRINT-2-{slug}.md
    └── ...
```

---

## Absolute Paths

| Resource | Path |
|----------|------|
| Codebase | `{codebase_path}` |
| Working Directory | `{output_dir}` |
| Findings | `{output_dir}/findings/` |
| Sprints | `{output_dir}/sprints/` |
| Roadmap | `{output_dir}/ROADMAP.md` |
| Re-entry Prompts | `{output_dir}/RE-ENTRY-PROMPTS.md` |

---

## Sprint System Rules

1. Sprints are generated **one at a time** — never pre-generated
2. Each sprint feeds from the previous sprint's retro and recommendations
3. The accumulated debt table passes from sprint to sprint, never losing items
4. The roadmap adapts based on what execution reveals
5. Re-entry prompts are updated after each sprint for context persistence

---

## Current State — Baseline

<!-- Filled during INIT with baseline metrics -->

| Metric | Value |
|--------|-------|
| {metric_name} | {metric_value} |

---

## Sprint Map

<!-- Updated as sprints are completed -->

| Sprint | Status | Focus | Key Deliverables |
|--------|--------|-------|-----------------|
| 1 | {status} | {focus} | {deliverables} |
