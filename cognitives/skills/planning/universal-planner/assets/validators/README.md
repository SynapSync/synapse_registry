# Output Validators

This directory contains JSON schemas for validating universal-planner output.

## Purpose

The output schema defines the **contract** between `universal-planner` and downstream skills (like `universal-planner-executor`). It ensures that:

1. **All required files are generated** for the selected mode
2. **File paths are valid** and follow conventions
3. **Metadata is complete** for tracking and auditing

## Schema: output-schema.json

### Overview

The schema validates a JSON object representing the output of a universal-planner run:

```json
{
  "planning_dir": "/path/to/output",
  "mode": "NEW_FEATURE",
  "project_name": "my-feature",
  "files": {
    "README.md": "/path/to/README.md",
    "analysis/ANALYSIS.md": "/path/to/analysis/ANALYSIS.md",
    ...
  },
  "metadata": {
    "created_at": "2026-02-12T10:30:00Z",
    "skill_version": "2.1.0",
    "total_files": 7
  }
}
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `planning_dir` | string | Absolute path to planning directory |
| `mode` | enum | One of: NEW_PROJECT, NEW_FEATURE, REFACTOR, BUG_FIX, TECH_DEBT, ARCHITECTURE |
| `project_name` | string | Project name in kebab-case |
| `files` | object | Map of file paths (keys are relative, values are absolute paths) |

### Mode-Specific Requirements

The schema enforces different file requirements based on mode:

#### NEW_PROJECT Mode
**Required files (18):**
- README.md
- 7 requirements files (problem-definition, goals-and-metrics, etc.)
- 6 design files (system-overview, architecture-decisions, etc.)
- analysis/ANALYSIS.md
- planning/PLANNING.md
- execution/EXECUTION.md
- sprints/PROGRESS.md

#### ARCHITECTURE Mode
**Required files (14):**
- README.md
- discovery/CONVENTIONS.md
- 6 design files
- analysis/ANALYSIS.md
- planning/PLANNING.md
- execution/EXECUTION.md
- sprints/PROGRESS.md

#### NEW_FEATURE, REFACTOR, BUG_FIX, TECH_DEBT Modes
**Required files (6):**
- README.md
- discovery/CONVENTIONS.md
- analysis/ANALYSIS.md
- planning/PLANNING.md
- execution/EXECUTION.md
- sprints/PROGRESS.md

## Usage

### For universal-planner

At the end of the planning workflow, generate a validation object and verify it against the schema:

```typescript
const output = {
  planning_dir: outputPath,
  mode: detectedMode,
  project_name: projectName,
  files: generatedFiles,
  metadata: {
    created_at: new Date().toISOString(),
    skill_version: "2.1.0",
    total_files: Object.keys(generatedFiles).length,
    estimated_duration: estimatedDuration,
    sprint_count: sprintPlans.length
  }
};

// Validate against schema
const isValid = validateSchema(output, outputSchema);
if (!isValid) {
  console.error("Output validation failed:", errors);
}
```

### For universal-planner-executor

At the **start** of execution (Step 0.5: Plan Validation), read the planning directory and validate:

```typescript
// Step 0.5: Validate Plan Structure
const planningDir = "./planning/my-feature/";

// 1. Discover files in planning directory
const files = discoverFiles(planningDir);

// 2. Build validation object
const output = {
  planning_dir: planningDir,
  mode: readModeFromREADME(planningDir),
  project_name: extractProjectName(planningDir),
  files: files
};

// 3. Validate against schema
const isValid = validateSchema(output, outputSchema);

if (!isValid) {
  console.error("❌ Plan validation failed:");
  console.error("Missing files:", getMissingFiles(errors));
  console.error("Invalid paths:", getInvalidPaths(errors));

  // Stop execution with clear error
  throw new Error("Plan structure is incomplete. Please re-run universal-planner.");
}

console.log("✅ Plan validation passed");
```

### Validation Tools

**Node.js (ajv):**
```javascript
const Ajv = require("ajv");
const ajv = new Ajv();
const schema = require("./output-schema.json");

const validate = ajv.compile(schema);
const valid = validate(output);

if (!valid) {
  console.log(validate.errors);
}
```

**Python (jsonschema):**
```python
import jsonschema

with open("output-schema.json") as f:
    schema = json.load(f)

try:
    jsonschema.validate(output, schema)
    print("✅ Valid")
except jsonschema.ValidationError as e:
    print(f"❌ Invalid: {e.message}")
```

## Benefits

### Early Error Detection
Catch missing files immediately instead of failing mid-execution.

### Clear Error Messages
Schema validation provides specific errors:
- "Missing required file: discovery/CONVENTIONS.md"
- "Invalid mode: 'FEATURE' (must be 'NEW_FEATURE')"
- "Invalid project name: 'My Feature' (must be kebab-case)"

### Contract Documentation
The schema serves as executable documentation of what universal-planner produces.

### Breaking Change Prevention
If universal-planner changes its output structure, the schema catches it immediately.

## Extending the Schema

### Adding New Modes

To add a new mode (e.g., "MIGRATION"):

1. Add to the `mode` enum:
```json
"mode": {
  "enum": ["NEW_PROJECT", "NEW_FEATURE", ..., "MIGRATION"]
}
```

2. Add mode-specific requirements:
```json
{
  "if": {
    "properties": { "mode": { "const": "MIGRATION" } }
  },
  "then": {
    "properties": {
      "files": {
        "required": ["README.md", "discovery/CONVENTIONS.md", ...]
      }
    }
  }
}
```

### Adding Optional Files

Files not in the `required` array are optional but still validated if present:

```json
"files": {
  "properties": {
    "sprints/SPRINT-1.md": {
      "type": "string",
      "description": "Optional sprint plan"
    }
  }
}
```

## Version History

- **v1.0** (2026-02-12): Initial schema with 6 modes and mode-specific requirements

## Related

- `universal-planner/SKILL.md` - Planning skill that produces this output
- `universal-planner-executor/SKILL.md` - Execution skill that consumes this output
- JSON Schema Draft 7: https://json-schema.org/draft-07/schema
