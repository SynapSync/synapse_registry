# Changelog

All notable changes to the SynapSync Registry are documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **code-analyzer** skill (analytics, v1.0.0): Analyzes code modules and generates structured technical reports with Mermaid architecture diagrams. Supports three analysis depths (v1: explanation, v2: + diagrams, v3: + refactor recommendations).

### Changed
- **project-planner** skill (v1.2.0): Added context-first planning rules — mandatory Codebase Discovery step, CONVENTIONS.md reference document, pattern alignment enforcement, and deviation justification requirements.
- **project-planner** skill (v1.1.0): Refactored to planning-only scope — skill creates all planning documents but does not execute tasks. Execution responsibility delegated to a dedicated execution skill.

## [2026-01-28]

### Added
- **cognitive-register** skill (general, v1.0.0): Automates registration of new cognitives into the registry with proper structure, manifest schema, and registry index validation.
- **project-planner** skill (workflow, v1.0.0): Comprehensive project planning framework with analysis, planning, and execution phases.
- **feature-branch-manager** agent (general, v1.0.0): Git workflow agent for feature branch creation, pushing changes, and PR creation.
- **skill-creator** skill (general, v3.0.0): Meta-skill for creating new skills with basic and advanced templates. Migrated to SynapSync ecosystem.
- Initial registry structure with `registry.json`, category directories, and documentation (`README.md`, `CONTRIBUTING.md`, `CLAUDE.md`).
