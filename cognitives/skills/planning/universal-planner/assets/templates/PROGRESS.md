---
title: "{{project_name}} - Progress Dashboard"
date: "{{date}}"
updated: "{{date}}"
project: "{{project_name}}"
type: "progress"
status: "active"
version: "1.0"
total_sprints: {{sprint_count}}
completed_sprints: 0
tags: ["{{project_name}}", "progress", "dashboard"]
changelog:
  - version: "1.0"
    date: "{{date}}"
    changes: ["Initial progress dashboard"]
related:
  - "[[EXECUTION]]"
  - "[[SPRINT-1-name]]"
---

# Progress Dashboard: {{project_name}}

**Mode:** {{mode}}
**Date:** {{date}}
**Total Sprints:** {{sprint_count}}

---

## Executive Summary

[1-2 paragraph overview of project status. Updated after each sprint completion.]

---

## Sprint Overview

| Sprint | Name | Status | Progress | Start Date | End Date | Notes |
|--------|------|--------|----------|------------|----------|-------|
| 1 | [[SPRINT-1-name]] | Not Started | 0% | {{start_date}} | {{end_date}} | — |
| 2 | [[SPRINT-2-name]] | Not Started | 0% | {{start_date}} | {{end_date}} | — |

**Status values:** `Not Started` | `In Progress` | `Completed` | `Failed`

---

## Global Metrics

| Metric | Target | Current | Delta | Status |
|--------|--------|---------|-------|--------|
| Total Tasks | {{total_tasks}} | 0 | -{{total_tasks}} | Not Started |
| Tasks Completed | {{total_tasks}} | 0 | -{{total_tasks}} | Not Started |
| Test Coverage | {{coverage_target}}% | {{current_coverage}}% | {{delta}}% | — |
| Sprints Completed | {{sprint_count}} | 0 | -{{sprint_count}} | Not Started |

---

## Blockers & Issues

| ID | Description | Impact | Sprint | Status | Resolution |
|----|-------------|--------|--------|--------|------------|
| — | No blockers at project start | — | — | — | — |

**Status values:** `Open` | `In Progress` | `Resolved` | `Won't Fix`

---

## Document Index

All documents generated for this project:

### Discovery
- [[CONVENTIONS]] — Codebase conventions and patterns

### Analysis
- [[ANALYSIS]] — Strategic analysis

### Planning
- [[PLANNING]] — Work plan and strategy

### Execution
- [[EXECUTION]] — Task breakdown and phase structure

### Sprints
- [[SPRINT-1-name]] — Sprint 1 plan

---

## References

**Parent Documents:**
- [[README]]
- [[EXECUTION]]

**Child Documents:**
- [[SPRINT-1-name]]

**Sibling Documents:**
- [[ANALYSIS]]
- [[PLANNING]]
