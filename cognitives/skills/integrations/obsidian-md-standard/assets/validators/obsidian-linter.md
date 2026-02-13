# Obsidian Markdown Linter

## Purpose

Validate markdown documents for Obsidian compliance according to the `obsidian-md-standard`. This linter ensures documents follow consistent frontmatter schemas, use proper wiki-link syntax, maintain bidirectional cross-references, and adhere to the 14-type taxonomy.

## What It Validates

### 1. Frontmatter Schema

**Required fields:**
- `title`: string - Document title
- `date`: string (YYYY-MM-DD) - Creation date
- `updated`: string (YYYY-MM-DD) - Last update date
- `project`: string - Project identifier (kebab-case)
- `type`: string - Must match 14-type taxonomy (see below)
- `status`: string - One of: active, draft, completed, superseded, archived
- `version`: string - Semantic version (e.g., "1.0", "2.3")
- `tags`: array - List of tags (max 10)
- `changelog`: array - Version history with version, date, changes
- `related`: array - Wiki-links to related documents (`[[note-name]]`)

**Optional fields:**
- `sprint`: number - Sprint number
- `phase`: string - Phase identifier (e.g., "2.1")
- `progress`: number - Progress percentage (0-100)
- `metrics`: object - Custom metrics
- `source`: string - Source path reference

**Field type validation:**
- `title`, `project`, `type`, `status`, `version`: must be strings
- `date`, `updated`: must be strings in YYYY-MM-DD format
- `tags`, `changelog`, `related`: must be arrays
- `sprint`: must be number
- `progress`: must be number between 0-100
- `metrics`: must be object

**Date format validation:**
- Pattern: `YYYY-MM-DD` (e.g., "2026-02-11")
- Invalid: "2026-2-11", "02/11/2026", "2026-02-11T00:00:00"

### 2. Wiki-Link Syntax

**Valid formats:**
- `[[note-name]]` - Simple wiki-link
- `[[note-name|display text]]` - Wiki-link with alias
- `[[folder/note-name]]` - Wiki-link with path

**Invalid formats:**
- `[note-name]` - Markdown link (missing double brackets)
- `[[note name with spaces]]` - Spaces in note name (should be kebab-case: `[[note-name-with-spaces]]`)
- `[text](relative-path.md)` - Relative markdown links for inter-document references

**Naming conventions for wiki-links:**
- Use kebab-case: `[[react-hooks]]`, `[[api-error-handling]]`
- No spaces: convert "API Error Handling" to `[[api-error-handling]]`
- No file extensions: `[[note]]` not `[[note.md]]`

### 3. Tag Format

**Valid formats:**
- `#tag` - Simple tag
- `#multi-word-tag` - Multi-word with hyphens
- `#nested/tag` - Nested tags with forward slash
- Tags in frontmatter: `tags: [tag1, tag2, tag3]`

**Invalid formats:**
- `# tag` - Space after hash
- `#tag with spaces` - Spaces within tag (should be `#tag-with-spaces`)
- `#tag_with_underscores` - Use hyphens instead: `#tag-with-hyphens`

**Tag limitations:**
- Maximum 10 tags per document
- Tags should be lowercase
- Use hyphens for multi-word tags

### 4. Cross-References (Bidirectionality)

**Related field bidirectionality:**
If document A has:
```yaml
related:
  - "[[document-b]]"
```

Then document B must have:
```yaml
related:
  - "[[document-a]]"
```

**Referencias section bidirectionality:**
If document A has:
```markdown
## Referencias
- [[document-b]]
```

Then document B should reference document A in its `## Referencias` section or `related` frontmatter.

**Validation rules:**
1. Check all `[[wiki-links]]` in the `related` field
2. For each link, verify the target document exists
3. For each link, verify the target document links back (either in `related` or `## Referencias`)
4. Flag one-directional references as Medium severity issues

### 5. Type Taxonomy (14 Types)

Documents must use one of these 14 approved types:

| Type | Description |
|------|-------------|
| `analysis` | General analysis documents |
| `conventions` | Project patterns and conventions reference |
| `requirements` | Functional/non-functional requirements |
| `architecture` | System design and architecture decisions |
| `plan` | Strategic planning and high-level plans |
| `execution-plan` | Concrete task breakdowns |
| `sprint-plan` | Sprint-level task plans |
| `progress` | Master progress dashboards |
| `technical-report` | Code/module analysis reports |
| `refactor-plan` | Refactoring recommendations |
| `retrospective` | Sprint/project retrospectives |
| `decision-log` | Architecture/engineering decisions |
| `data-model` | Entity relationships and storage |
| `flow-diagram` | Core flows and sequences |

**Invalid types:**
- Custom types not in the 14-type taxonomy
- Multiple types (must be single string, not array)
- Typos or variations (e.g., "strategic-plan" should be "plan")

### 6. Required Sections

**## Referencias section:**
- Documents should include a `## Referencias` section at the end
- Contains related documents as wiki-links
- Should be bidirectional (if A references B, B should reference A)

## How to Use

### In obsidian (READ mode)

When performing a COMPLIANCE_CHECK operation:

```markdown
See this document for complete validation rules.
```

Apply these validation checks:
1. Parse frontmatter YAML
2. Validate required fields exist
3. Validate field types and formats
4. Check wiki-link syntax
5. Check tag format
6. Verify bidirectional references
7. Check type taxonomy compliance
8. Verify `## Referencias` section exists

### In obsidian (SYNC mode)

When syncing documents from workspace to vault:

```markdown
Apply obsidian-linter rules when generating frontmatter and formatting documents.
```

Before writing a document:
1. Ensure all required frontmatter fields are present
2. Format dates as YYYY-MM-DD
3. Convert markdown links to wiki-links
4. Normalize tags (lowercase, kebab-case)
5. Verify type is in the 14-type taxonomy
6. Add `## Referencias` section if not present

### In universal-planner and other skills

When generating documents for Obsidian:

```markdown
Generate documents following obsidian-md-standard validation rules.
```

Use this linter as a checklist:
- Include all required frontmatter fields
- Use wiki-links for cross-references
- Use proper tag format
- Select type from the 14-type taxonomy
- Include `## Referencias` section

## Validation Errors

| Error | Severity | Fix |
|-------|----------|-----|
| Missing required frontmatter field (`title`, `date`, etc.) | High | Add field with appropriate value |
| Missing `updated` field | Low | Add `updated: "{today}"` to frontmatter |
| Missing `version` field | Low | Add `version: "1.0"` to frontmatter |
| Missing `changelog` field | Low | Add `changelog: [{version: "1.0", date: "{date}", changes: ["Initial creation"]}]` |
| Invalid date format (not YYYY-MM-DD) | Medium | Reformat date to YYYY-MM-DD |
| Invalid wiki-link syntax `[note]` | High | Change to `[[note]]` |
| Wiki-link with spaces `[[note name]]` | Medium | Change to kebab-case `[[note-name]]` |
| Relative markdown link `[text](./path.md)` | High | Convert to wiki-link `[[path]]` |
| Invalid tag format `#tag with spaces` | Medium | Change to `#tag-with-spaces` |
| Tag with underscore `#tag_name` | Low | Change to `#tag-name` |
| More than 10 tags | Medium | Remove least important tags |
| Type not in 14-type taxonomy | High | Select appropriate type from approved list |
| Missing `## Referencias` section | Medium | Add section at end of document |
| One-directional reference to `[[X]]` | Medium | Add reverse reference in target document |
| `related` field contains non-wiki-link | High | Format as `[[note-name]]` |

## Validation Procedure

### Step 1: Parse Frontmatter

```
1. Extract YAML between `---` markers
2. Parse as YAML object
3. If parse fails: ERROR (malformed YAML)
```

### Step 2: Check Required Fields

```
For each required field:
  If missing: ERROR
  If wrong type: ERROR
  If present and correct type: PASS
```

Required fields checklist:
- [ ] `title` (string)
- [ ] `date` (string, YYYY-MM-DD)
- [ ] `updated` (string, YYYY-MM-DD)
- [ ] `project` (string)
- [ ] `type` (string, must be in 14-type taxonomy)
- [ ] `status` (string, must be: active/draft/completed/superseded/archived)
- [ ] `version` (string)
- [ ] `tags` (array)
- [ ] `changelog` (array)
- [ ] `related` (array)

### Step 3: Validate Field Formats

```
date: Match /^\d{4}-\d{2}-\d{2}$/
updated: Match /^\d{4}-\d{2}-\d{2}$/
type: Must be in [analysis, conventions, requirements, architecture, plan, execution-plan, sprint-plan, progress, technical-report, refactor-plan, retrospective, decision-log, data-model, flow-diagram]
status: Must be in [active, draft, completed, superseded, archived]
version: Match /^\d+\.\d+$/
tags: Array, max length 10
related: Array, all items match /^\[\[.+\]\]$/
```

### Step 4: Check Wiki-Link Syntax

```
Find all wiki-links in document:
  Pattern: /\[\[([^\]]+)\]\]/g

For each wiki-link:
  If contains spaces: WARNING (should be kebab-case)
  If contains .md extension: WARNING (remove extension)
  If uses single brackets: ERROR (should be double brackets)
```

Find all markdown links between documents:
```
Pattern: /\[.+\]\(\.{0,2}\/.*\.md\)/g
For each match: ERROR (use wiki-links instead)
```

### Step 5: Check Tag Format

```
Find all inline tags:
  Pattern: /#([a-z0-9\-\/]+)/g

For each tag:
  If contains spaces: ERROR
  If contains uppercase: WARNING (should be lowercase)
  If contains underscores: WARNING (use hyphens instead)
```

### Step 6: Verify Bidirectional References

```
For each item in frontmatter.related:
  Extract note name from [[note-name]]
  Find target document
  If target not found: ERROR (broken link)
  If target found:
    Check target.related for reverse reference
    If not found: ERROR (one-directional reference)
```

### Step 7: Check Required Sections

```
Search for "## Referencias" heading
If not found: WARNING (missing Referencias section)
```

### Step 8: Generate Report

```markdown
## Compliance Report: {filename}
Date: {today}

### Status: {PASS/PARTIAL/FAIL}

### Issues Found: {count}

| Severity | Issue | Location |
|----------|-------|----------|
| High | Missing required field: `updated` | Frontmatter |
| Medium | One-directional reference to [[other-doc]] | Frontmatter.related |
| Low | Tag contains underscore: #my_tag | Line 45 |

### Recommendations:
1. Add missing `updated` field to frontmatter
2. Add reverse reference in other-doc.md
3. Change #my_tag to #my-tag
```

## Examples

### Example 1: Valid Document

```markdown
---
title: "Agent Sync SDK Strategic Analysis"
date: "2026-02-10"
updated: "2026-02-11"
project: "agent-sync-sdk"
type: "analysis"
status: "active"
version: "1.2"
tags: [strategy, roadmap, planning]
changelog:
  - version: "1.2"
    date: "2026-02-11"
    changes: ["Updated based on Q1 review"]
  - version: "1.0"
    date: "2026-02-10"
    changes: ["Initial creation"]
related:
  - "[[01-technical-debt]]"
  - "[[02-growth-vision]]"
---

# Agent Sync SDK Strategic Analysis

This analysis covers the strategic direction for the Agent Sync SDK project.

## Overview

See [[01-technical-debt]] for detailed technical issues.

## Next Steps

See [[02-growth-vision]] for long-term vision.

## Referencias
- [[01-technical-debt]]
- [[02-growth-vision]]
```

**Validation result:** PASS

All required fields present, correct types, wiki-links properly formatted, bidirectional references maintained.

### Example 2: Invalid Document (Multiple Issues)

```markdown
---
title: "My Project Plan"
date: "02/11/2026"
project: "my project"
type: "strategic-plan"
status: "in-progress"
tags: [strategy, roadmap, planning, architecture, design, implementation, testing, deployment, security, performance, monitoring]
---

# My Project Plan

See [technical details](./tech-doc.md) for more info.

This relates to [[other doc]] and uses tags like #my tag and #another_tag.
```

**Validation result:** FAIL

Issues found:
1. **High**: Missing required field: `updated`
2. **High**: Missing required field: `version`
3. **High**: Missing required field: `changelog`
4. **High**: Missing required field: `related`
5. **Medium**: Invalid date format: "02/11/2026" (should be "2026-02-11")
6. **Medium**: Project name has spaces: "my project" (should be "my-project")
7. **High**: Type not in taxonomy: "strategic-plan" (should be "plan")
8. **Medium**: Status not in approved list: "in-progress" (should be "active", "draft", "completed", "superseded", or "archived")
9. **Medium**: Too many tags (11, max is 10)
10. **High**: Uses relative markdown link `[text](./tech-doc.md)` (should be `[[tech-doc]]`)
11. **Medium**: Wiki-link with spaces: `[[other doc]]` (should be `[[other-doc]]`)
12. **Medium**: Tag with space: `#my tag` (should be `#my-tag`)
13. **Medium**: Tag with underscore: `#another_tag` (should be `#another-tag`)
14. **Medium**: Missing `## Referencias` section

### Example 3: One-Directional Reference Issue

**Document A (document-a.md):**
```yaml
---
# ... frontmatter ...
related:
  - "[[document-b]]"
---
```

**Document B (document-b.md):**
```yaml
---
# ... frontmatter ...
related:
  - "[[document-c]]"
---
```

**Issue:** Document A references document B, but document B does not reference document A back.

**Fix:** Add `[[document-a]]` to document-b.md's `related` field:
```yaml
related:
  - "[[document-a]]"
  - "[[document-c]]"
```

## Integration Notes

This validator is designed to be reusable across all SynapSync skills that produce or consume Obsidian markdown documents:

- **obsidian** (READ mode): Use for COMPLIANCE_CHECK operation
- **obsidian** (SYNC mode): Apply rules when syncing documents
- **universal-planner**: Generate documents that pass validation
- **universal-planner-executor**: Generate sprint and retrospective documents that pass validation
- **code-analyzer**: Generate reports that pass validation

By extracting these rules into a shared validator, we ensure consistency across all skills and make it easy to update validation logic in one place.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-12 | Initial extraction from obsidian (READ mode) COMPLIANCE_CHECK logic |
