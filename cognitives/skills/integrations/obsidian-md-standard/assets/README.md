# Obsidian MD Standard Assets

This directory contains validators and tools for the `obsidian-md-standard` skill.

## Directory Structure

```
assets/
├── README.md                          # This file
└── validators/
    └── obsidian-linter.md             # Validation rules and procedures
```

## Validators

### validators/obsidian-linter.md

Comprehensive validation rules for Obsidian-native markdown documents. Used by the `obsidian` skill (COMPLIANCE_CHECK operation) and any skill that generates markdown output.

**Key validations:**
- Frontmatter schema (required fields, types, formats)
- Wiki-link syntax (`[[note-name]]` format)
- Tag format (`#tag` or `#multi-word-tag`)
- Bidirectional cross-references
- Type taxonomy compliance (14 approved types)
- Required sections (`## Referencias`)

## Version

Assets structure created: 2026-02-12 (v1.1.0)
