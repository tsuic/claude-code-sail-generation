# RECORD TYPE HANDLING GUIDELINES

This document provides the specific record type definitions for use when creating SAIL expressions.

> **Note:** For detailed explanation of UUID syntax and Appian autocomplete usage, see the "Record Type Reference Syntax" section in `dynamic-sail-expression-guidelines.md`.

<quick_reference>
## Quick Reference

**Record Type Pattern**: `'recordType!RecordTypeName'`
**Field Pattern**: `'recordType!RecordTypeName.fields.fieldName'`
**Relationship Pattern**: `'recordType!RecordTypeName.relationships.relationshipName'`
**Related Field Pattern**: `'recordType!RecordTypeName.relationships.relationshipName.fields.fieldName'`

**Key Rules**:
- Always use the FULL reference string exactly as shown
- Relationships are for navigation, fields are for values
- Use single continuous path for related fields - ONLY ONE bracket for the entire path
</quick_reference>

<critical_rules>
## 🚨 CRITICAL RULES

<rule_1>
**When creating interfaces, use the available record type, record fields, relationships available to you.**
</rule_1>

<rule_2>
**Also use your knowledge of queries and data indexing.**
</rule_2>

<rule_3>
**Avoid using local variables to maintain record data and access the rule inputs directly.**
</rule_3>

<rule_4>
**If the form captures data on a record type on the many side of a one-to-many relationship, then use the main record type's relationships and their fields to access that data rather than creating new rule inputs or local variables.**
</rule_4>

<rule_5>
**NEVER confuse record type relationships with fields when building SAIL expressions.**
Remember:
- Relationships: Used for navigation to related records
- Fields: Used to display values, filtering, sorting
</rule_5>

<rule_6>
**Use record type constructors, not a!map(), when creating new record instances.**

Example: `'recordType!CaseNote'(...)` NOT `a!map(...)`

> **See:** "Creating New Record Instances" section in `dynamic-sail-expression-guidelines.md` for complete syntax and patterns.
</rule_6>
</critical_rules>

<critical_errors>
## ❌ Critical Errors to Avoid

❌ **Double brackets**: `[relationship][field]` → ✅ **Single path**: `[relationship.fields.field]`
❌ **Sort on relationships** → ✅ **Sort on fields only** (see "Grid Column Sorting Rules" in `dynamic-sail-expression-guidelines.md`)
❌ **User fields with dropdown** → ✅ **Use `a!pickerFieldUsers()`**
❌ **Group fields with dropdown** → ✅ **Use `a!pickerFieldGroups()`**
</critical_errors>

<relationship_types>
## Relationship Type Usage

**many-to-one**: Can sort on related fields, display directly
**one-to-many**: Cannot sort, use length() or a!forEach()
**one-to-one**: Like many-to-one

> **For detailed patterns on managing one-to-many relationships in forms**, see the "One-to-Many Relationship Data Management in Forms" section in `dynamic-sail-expression-guidelines.md`.
</relationship_types>

<field_mapping_strategies>
## Field Mapping Strategies

When data model fields don't match interface requirements, use these strategies:

### Strategy 1: Use Available Fields
**When to use:** Minor semantic differences (e.g., `firstName` + `lastName` vs `fullName`)

**How it works:**
- Use existing fields with different structure
- Add comment explaining the mapping decision
- Document in interface header

**Example:**
```sail
/* NOTE: Using firstName + lastName fields from Client instead of fullName */

a!textField(
  label: "First Name",
  value: a!defaultValue(
    ri!case['recordType!Case.relationships.client.fields.firstName'],
    ""
  ),
  saveInto: ri!case['recordType!Case.relationships.client.fields.firstName']
),
a!textField(
  label: "Last Name",
  value: a!defaultValue(
    ri!case['recordType!Case.relationships.client.fields.lastName'],
    ""
  ),
  saveInto: ri!case['recordType!Case.relationships.client.fields.lastName']
)
```

### Strategy 2: Local Variables for Reference Data
**When to use:** Missing reference tables (e.g., Case Status, Priority Levels, Case Types)

**How it works:**
- Define local variable with hardcoded list
- Use for dropdown choice labels and values
- Document data source in comment

**Example:**
```sail
a!localVariables(
  /* Case priorities reference data - used for dropdown options */
  local!casePriorities: {
    a!map(id: 1, label: "Low", value: "LOW"),
    a!map(id: 2, label: "Medium", value: "MEDIUM"),
    a!map(id: 3, label: "High", value: "HIGH"),
    a!map(id: 4, label: "Critical", value: "CRITICAL")
  },

  {
    a!dropdownField(
      label: "Priority",
      choiceLabels: local!casePriorities.label,
      choiceValues: local!casePriorities.value,
      value: ri!case['recordType!Case.fields.priority'],
      saveInto: ri!case['recordType!Case.fields.priority']
    )
  }
)
```

### Key Principle: Relationship-Based Data Access

**IMPORTANT:** In Appian, you can ONLY access related record types via defined relationships. You CANNOT perform SQL-style joins.

**✅ CORRECT - Single bracket for entire path:**
```sail
ri!case['recordType!Case.relationships.client.fields.firstName']
```

**❌ INCORRECT - Multiple brackets (invalid syntax):**
```sail
ri!case['recordType!Case.relationships.client']['recordType!Client.fields.firstName']
```

> **See Also:** The "Relationship Field Navigation Syntax" section in `dynamic-sail-expression-guidelines.md` for complete examples and additional context.
</field_mapping_strategies>
