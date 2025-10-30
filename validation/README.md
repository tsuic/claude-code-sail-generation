# SAIL Validation System

## Overview

This directory contains the **schema-based validation system** for SAIL code generation. This system provides fast, accurate validation of SAIL functions, parameters, and values.

## Files

### `sail-api-schema.json`
Complete structured reference of all SAIL components and functions:
- **Purpose:** Machine-readable API specification
- **Structure:** JSON with direct property access
- **Contents:**
  - All UI components (layouts, inputs, displays, charts)
  - All expression functions (logic, data, conversion)
  - All parameters with type information
  - All valid enumeration values
- **Size:** Comprehensive but single-file
- **Lookup Speed:** O(1) - instant property access

### How to Use

The schema is automatically used by the `sail-schema-validator` agent. No manual intervention needed.

---

## Validator Comparison

There are now **TWO** validation agents available:

### 1. **sail-function-validator** (Original)
**Location:** `.claude/agents/sail-function-validator.md`

**Approach:**
- Reads markdown documentation files
- Searches text for function/parameter definitions
- Parses prose to extract valid values
- Multiple file reads required

**Pros:**
- Works directly from documentation
- No schema maintenance needed
- Human-readable source

**Cons:**
- Slower (text search vs. property lookup)
- May miss items buried in prose
- Multiple file reads
- Parsing ambiguity

**When to Use:**
- When you want to validate directly from docs
- For double-checking schema-based results
- When schema might be outdated

---

### 2. **sail-schema-validator** (New - Recommended)
**Location:** `.claude/agents/sail-schema-validator.md`

**Approach:**
- Loads structured JSON schema
- Direct property lookups
- Algorithmic validation
- Single file read

**Pros:**
- ⚡ **Much faster** (O(1) lookups)
- 🎯 **More accurate** (structured data)
- ✅ **Complete** (exhaustive enumerations)
- 🔍 **Transparent** (shows exact schema paths)
- 🚀 **Efficient** (single file, direct access)

**Cons:**
- Requires schema maintenance
- Schema must stay in sync with docs

**When to Use:**
- **Default choice** for all validation
- When speed matters (large files)
- When you need certainty (no parsing ambiguity)

---

## Validation Workflow

### Recommended Flow

1. **Generate SAIL code** (main agent)
2. **Run sail-schema-validator** (fast, accurate)
3. **Run sail-icon-validator** (icons only)
4. **Run sail-code-reviewer** (syntax & structure)

### Comparison Testing Flow

To compare both validators:

1. **Generate SAIL code**
2. **Run sail-schema-validator** → Note results
3. **Run sail-function-validator** → Note results
4. **Compare:** Did they find the same errors?
5. **Report differences** for schema improvement

---

## Schema Maintenance

### Updating the Schema

If SAIL documentation is updated:

1. Review changes in `/ui-guidelines/*.md`
2. Update corresponding entries in `sail-api-schema.json`
3. Test validation on known-good and known-bad code
4. Commit schema updates with description

### Schema Structure

```json
{
  "components": {
    "a!functionName": {
      "category": "layout|input|display|...",
      "parameters": {
        "paramName": {
          "type": "Text|Integer|Boolean|...",
          "required": true|false,
          "validValues": ["VALUE1", "VALUE2", "hex"]
        }
      }
    }
  },
  "expressionFunctions": {
    "functionName": {
      "syntax": "functionName(param1, param2)",
      "parameterCount": 2 | "variadic"
    }
  }
}
```

---

## Performance Comparison

**Example: Validating a 500-line SAIL file with 50 function calls**

| Validator | Method | Estimated Time | File Reads |
|-----------|--------|----------------|------------|
| **sail-function-validator** | Markdown search | ~30-60 seconds | 10-20 files |
| **sail-schema-validator** | JSON lookup | ~5-10 seconds | 1 file |

**Speed improvement: 3-6x faster** ⚡

---

## Error Reporting

Both validators provide:
- Exact line numbers
- Function and parameter names
- Current invalid value
- List of valid values
- Suggested fix

**Schema validator additionally shows:**
- Exact schema path (transparency)
- Validation algorithm used
- Performance metrics

---

## Future Enhancements

Potential improvements:

1. **Auto-generate schema from docs**
   - Parse markdown → JSON schema
   - Keep schema always in sync

2. **Schema versioning**
   - Track Appian version compatibility
   - Multiple schemas for different versions

3. **Extended validation**
   - Parameter type checking
   - Required parameter enforcement
   - Cross-parameter validation rules

4. **IDE integration**
   - Real-time validation in editor
   - Autocomplete from schema

---

## Questions?

**Q: Which validator should I use?**
A: Use `sail-schema-validator` by default. It's faster and more accurate.

**Q: Why keep the old validator?**
A: For comparison testing and as a backup if schema gets out of sync.

**Q: How do I know the schema is accurate?**
A: Run both validators and compare results. Report any differences.

**Q: What if I find a schema error?**
A: Update `sail-api-schema.json` and note the change in git commit.

**Q: Does the schema cover everything?**
A: It covers all components and expression functions from the documentation. Icon validation is separate (sail-icon-validator).

---

## Summary

The new **schema-based validation** provides:
- ⚡ **3-6x faster** validation
- 🎯 **More accurate** (no parsing ambiguity)
- ✅ **Complete coverage** (exhaustive lists)
- 🔍 **Transparent** (shows schema paths)

Use `sail-schema-validator` as your primary validation tool, with the original `sail-function-validator` available for comparison and verification.
