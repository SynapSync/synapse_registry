# Changelog

All notable changes to the SynapSync Registry are documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_No unreleased changes._

## [2026-02-14]

### Changed
- **obsidian** skill (integrations, v3.2.0): Full MCP tool coherence — all 13 Obsidian MCP tools documented and integrated (was 7). Added delete_note, patch_note, update_frontmatter, get_frontmatter, get_notes_info, move_note. Fixed manage_tags contract. Optimized cross-ref and ranking helpers with metadata-first tools. Added archive/delete and move/reorganize workflows.
- **obsidian** skill (integrations, v3.1.0): Audit remediation — i18n docs, tool contracts, 14-type taxonomy reconciliation, ambiguous intent disambiguation, batch limits, negative weights for superseded/archived.
- **universal-planner** skill (planning, v3.1.0): Audit remediation — 25 findings resolved across forensic audits.

### Added
- **obsidian** skill (integrations, v3.0.0): Consolidated obsidian-sync + obsidian-reader into unified skill with SYNC and READ modes. Progressive disclosure pattern. 4 shared helpers.
- **universal-planner** skill (planning, v3.0.0): Unified planning and execution with PLAN and EXECUTE modes. Modular assets pattern with 8 modes.

## [2026-01-28]

### Added
- **cognitive-register** skill (general, v1.0.0): Automates registration of new cognitives into the registry with proper structure, manifest schema, and registry index validation.
- **project-planner** skill (workflow, v1.0.0): Comprehensive project planning framework with analysis, planning, and execution phases.
- **feature-branch-manager** agent (general, v1.0.0): Git workflow agent for feature branch creation, pushing changes, and PR creation.
- **skill-creator** skill (general, v3.0.0): Meta-skill for creating new skills with basic and advanced templates. Migrated to SynapSync ecosystem.
- Initial registry structure with `registry.json`, category directories, and documentation (`README.md`, `CONTRIBUTING.md`, `CLAUDE.md`).
