# Obsidian-Sync Assets

This directory contains helper workflows and examples that support the obsidian-sync skill.

## Structure

```
assets/
├── README.md                           # This file
├── helpers/                            # Reusable workflow helpers
│   ├── frontmatter-generator.md        # Frontmatter generation logic
│   ├── cross-ref-validator.md          # Bidirectional reference validation
│   └── batch-sync-pattern.md           # Efficient batch file sync workflow
└── examples/                           # Test scenarios and examples
    └── smoke-test.md                   # Basic sync verification test
```

## Helpers

- **frontmatter-generator.md** — Extract metadata from documents and generate Obsidian frontmatter following the universal schema. References `obsidian-md-standard` for type inference.
- **cross-ref-validator.md** — Validate and fix bidirectional references between synced documents to maintain knowledge graph integrity.
- **batch-sync-pattern.md** — Optimize multi-file sync operations by parallelizing reads and minimizing user interaction.

## Examples

- **smoke-test.md** — A simple test scenario for verifying obsidian-sync functionality with 3 files of different document types.

## Usage

These assets are referenced from the main SKILL.md file. They provide detailed sub-workflows that keep the main skill document focused and concise.
