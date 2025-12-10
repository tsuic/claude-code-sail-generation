# FUNCTIONAL INTERFACE GUIDELINES - RECORD TYPES & QUERIES

## 📑 Quick Navigation Index {#nav-index}

**How to use this index:**
1. Find the topic you need below
2. For extracted files, read the file directly
3. For inline sections, use Grep tool or Ctrl+F to find the section in this file

### 📁 Extracted Topic Files (Read These for Detailed Patterns):

**Shared Foundations (used by both mockup and functional interfaces):**
- `/sail-guidelines/local-variable-patterns.md` - Data modeling, mockup vs functional differences
- `/sail-guidelines/short-circuit-evaluation.md` - Why if() vs and()/or() for null safety
- `/sail-guidelines/null-safety-quick-ref.md` - Quick pattern lookup table
- `/sail-guidelines/functions-reference.md` - Essential functions by category
- `/sail-guidelines/datetime-handling.md` - Date/time type matching & operators

**Record Type Patterns (functional interfaces):**
- `/record-type-guidelines/query-result-structures.md` - Property access by query type
- `/record-type-guidelines/form-interface-patterns.md` - ri! pattern, testing simulation
- `/record-type-guidelines/one-to-many-management.md` - Relationship data in forms
- `/record-type-guidelines/user-group-fields.md` - User/Group fields vs relationships
- `/record-type-guidelines/query-filters-operators.md` - Filter patterns, nesting rules
- `/record-type-guidelines/kpi-aggregation-patterns.md` - Dashboard aggregations

### 🚨 Critical Sections in This File (Read These First):
- **Mandatory Foundation Rules** → `"## 🚨 MANDATORY FOUNDATION RULES"`
- **Record Type Reference Syntax** → `"## ⚠️ Record Type Reference Syntax"`
- **Handling Non-Existent Constants** → `"## ⚠️ IMPORTANT: Handling Non-Existent Constants"`
- **Essential SAIL Structure** → `"## Essential SAIL Structure"`
- **Documenting Unused Local Variables** → `"## 📝 Documenting Unused Local Variables"`
- **Relationship Field Navigation Syntax** → `"## 🚨 CRITICAL: Relationship Field Navigation Syntax"`
- **Creating New Record Instances** → `"## Creating New Record Instances"`
- **Grid Column Sorting Rules** → `"## 🚨 CRITICAL: Grid Column Sorting Rules"`

### By Task Type:
- **Using query results in components** → `/record-type-guidelines/query-result-structures.md`
- **Accessing properties on queried data** → `/record-type-guidelines/query-result-structures.md`
- **Building a form/wizard (create/update)** → `/record-type-guidelines/form-interface-patterns.md`
- **Testing simulation variables** → `/record-type-guidelines/form-interface-patterns.md`
- **Handling non-existent constants** → `"## ⚠️ IMPORTANT: Handling Non-Existent Constants"`
- **Creating new record instances** → `"## Creating New Record Instances"`
- **Handling data model mismatches** → `"## Field Mapping Strategies"`
- **Multi-type form entry patterns** → `"## Multi-Type Form Entry Pattern"`
- **Displaying data in grids or charts** → `/record-type-guidelines/query-filters-operators.md`
- **Nesting query logical expressions** → `/record-type-guidelines/query-filters-operators.md`
- **Managing one-to-many relationships** → `/record-type-guidelines/one-to-many-management.md`
- **User/Group fields in forms** → `/record-type-guidelines/user-group-fields.md`
- **Displaying user names** → `/record-type-guidelines/user-group-fields.md`
- **Working with dates and times** → `/sail-guidelines/datetime-handling.md`
- **KPI and aggregation calculations** → `/record-type-guidelines/kpi-aggregation-patterns.md`
- **Pattern matching with record fields** → `"## Pattern Matching with Record Fields"`
- **Record links and identifiers** → `"## Record Links and Identifiers"`
- **Implementing record actions** → `"## Record Actions"`
- **Create/Update scenarios** → `"## Create/Update Scenarios"`
- **Role-based access control** → `"## Group-Based Access Control Pattern"`

### By Error Type:
- **"Property not found" on query results** → `/record-type-guidelines/query-result-structures.md`
- **Empty dropdown/checkbox from queries** → `/record-type-guidelines/query-result-structures.md`
- **forEach showing blank data** → `/record-type-guidelines/query-result-structures.md`
- **"Variable not defined"** → `"## 🚨 MANDATORY FOUNDATION RULES"`
- **"Constant not found"** → `"## ⚠️ IMPORTANT: Handling Non-Existent Constants"`
- **Null reference errors** → `/sail-guidelines/null-safety-quick-ref.md`
- **Short-circuit evaluation errors** → `/sail-guidelines/short-circuit-evaluation.md`
- **Record type reference errors** → `"## ⚠️ Record Type Reference Syntax"`
- **Relationship navigation errors** → `/record-type-guidelines/user-group-fields.md`
- **Grid column sorting errors** → `"## 🚨 CRITICAL: Grid Column Sorting Rules"`
- **Using a!map() instead of record constructor** → `"## Creating New Record Instances"`
- **Query returning only primary key** → `/record-type-guidelines/query-filters-operators.md`
- **Query .totalCount is null** → `/record-type-guidelines/query-filters-operators.md`
- **Using sorts instead of sort** → `/record-type-guidelines/query-filters-operators.md`
- **Query filter nesting errors** → `/record-type-guidelines/query-filters-operators.md`
- **Copying ri! to local variables** → `/record-type-guidelines/form-interface-patterns.md`
- **DateTime vs Date type mismatch** → `/sail-guidelines/datetime-handling.md`
- **Query filter errors with rule inputs** → `/record-type-guidelines/query-filters-operators.md`
- **user() on relationship instead of field** → `/record-type-guidelines/user-group-fields.md`
- **Button/wizard configuration errors** → `"## ⚠️ a!buttonWidget() Parameter Rules"`
- **not() with null values** → `/sail-guidelines/null-safety-quick-ref.md`

### Validation & Troubleshooting:
- **Quick troubleshooting guide** → `"## 🔧 Quick Troubleshooting"`
- **Common critical errors** → `"## Common Critical Errors"`
- **Final validation checklist** → `"## Syntax Validation Checklist"`
- **Essential functions reference** → `/sail-guidelines/functions-reference.md`

---

## 🚨 MANDATORY FOUNDATION RULES

1. **All SAIL expressions must begin with `a!localVariables()`** - even if no variables are defined
2. **ALL local variables must be declared before use** - No undeclared variables allowed
3. **Use only available Appian functions** - No JavaScript equivalents exist
4. **Appian data is immutable** - Use functional approaches for data manipulation:
   - `append(array, value)` - Add to end of array (both params must be arrays or compatible types)
   - `a!update(data: array, index: position, value: newValue)` - Insert/replace at position
   - `insert(array, value, index)` - Insert value at specific position
   - `remove(array, index)` - Remove value at position
5. **Always validate for null values** - Use `a!isNullOrEmpty()` and `a!isNotNullOrEmpty()`
6. **Set audit fields on create/update** - createdBy, createdOn, modifiedBy, modifiedOn
7. **Never use `append()` with record data in dropdown choices - use placeholders**
8. **Query result data structure determines property access method**:
   - **Regular field queries** (`fields: {record field references}`) → Returns array of **record instances**
     - Access properties using **full record field references**: `'recordType!Type.fields.fieldName'`
     - Examples: `index(array, 'recordType!Type.fields.name', {})`, `fv!item['recordType!Type.fields.id']`
   - **Aggregation queries** (`a!aggregationFields(groupings, measures)`) → Returns array of **maps**
     - Access properties using **text alias** from query: `"aliasName"`
     - Examples: `index(array, "statusAlias", {})`, `fv!item.countAlias`, `array.groupingAlias`
   - **This applies to ALL components**: dropdowns, checkboxes, radio buttons, forEach loops, grids, charts, etc.
9. **Always try to use record types for populating read-only grids (`a!gridField()`) and charts** - instead of using mock data.
10. **Rule inputs (ri!) are interface parameters, NOT local variables** - Never initialize ri! inside the interface
    - ❌ `ri!isUpdate: false()` - WRONG: Cannot initialize parameters
    - ✅ `/* ri!isUpdate (Boolean) */` - RIGHT: Document in comments only
    - ✅ Always null-check: `a!isNotNullOrEmpty(ri!param)` or `a!defaultValue(ri!param, default)`

## 🚨 CRITICAL: Query Result Data Structures

### Universal Rule: Query Type Determines Property Access

**This principle applies to ALL components that use query results: dropdowns, checkboxes, radio buttons, forEach loops, grids, dynamic displays, etc.**

#### Pattern 1: Regular Field Queries → Record Instances

**Query Structure:**
```sail
a!queryRecordType(
  recordType: 'recordType!Type',
  fields: {
    'recordType!Type.fields.field1',
    'recordType!Type.fields.field2'
  }
).data
```

**Returns:** Array of **record instances** (typed objects)

**Property Access:** Use **full record field references**

**Examples:**
```sail
/* Dropdown choices */
choiceLabels: index(local!queryData, 'recordType!Type.fields.name', {})

/* Checkbox choices */
choiceLabels: index(local!queryData, 'recordType!Type.fields.label', {})

/* Radio button choices */
choiceLabels: index(local!queryData, 'recordType!Type.fields.displayName', {})

/* forEach loop accessing properties */
a!forEach(
  items: local!queryData,
  expression: a!cardLayout(
    contents: {
      a!textField(
        value: fv!item['recordType!Type.fields.title']
      ),
      a!textField(
        value: fv!item['recordType!Type.fields.description']
      )
    }
  )
)

/* Grid column (when not using a!recordData) */
a!gridColumn(
  value: fv!row['recordType!Type.fields.status']
)
```

#### Pattern 2: Aggregation Queries → Maps

**Query Structure:**
```sail
a!queryRecordType(
  recordType: 'recordType!Type',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: 'recordType!Type.fields.category', alias: "categoryName")
    },
    measures: {
      a!measure(function: "COUNT", alias: "itemCount")
    }
  )
).data
```

**Returns:** Array of **maps** (untyped dictionaries with alias keys)

**Property Access:** Use **text alias** from query definition

**Examples:**
```sail
/* Dropdown choices */
choiceLabels: index(local!aggregationData, "categoryName", {})

/* forEach loop accessing aggregation results */
a!forEach(
  items: local!aggregationData,
  expression: a!cardLayout(
    contents: {
      a!textField(
        value: fv!item.categoryName  /* Dot notation works too */
      ),
      a!integerField(
        value: fv!item.itemCount
      )
    }
  )
)

/* Direct property access */
local!firstCategory: local!aggregationData[1].categoryName
```

#### Quick Decision Guide

**Ask yourself: What type of query am I using?**

1. **Does my query use `fields: {record field references}`?**
   - ✅ YES → You have **record instances**
   - → Use: `'recordType!Type.fields.fieldName'` everywhere

2. **Does my query use `a!aggregationFields(groupings, measures)`?**
   - ✅ YES → You have **maps**
   - → Use: `"aliasName"` (the alias from your query)

**Apply this same logic to:**
- ✅ Dropdown `choiceLabels`/`choiceValues`
- ✅ Checkbox `choiceLabels`/`choiceValues`
- ✅ Radio button `choiceLabels`/`choiceValues`
- ✅ `a!forEach()` accessing `fv!item` properties
- ✅ Grid columns accessing data (when not using `a!recordData`)
- ✅ Any property access on query results

#### Common Mistake

❌ **WRONG: Using text property names on record instances**
```sail
local!users: a!queryRecordType(
  fields: {'recordType!User.fields.username'}
).data,

/* These will ALL fail: */
choiceLabels: index(local!users, "username", {}),           /* ❌ Dropdown */
choiceValues: index(local!users, "userId", {}),             /* ❌ Checkbox */
a!forEach(items: local!users, expression: fv!item.username) /* ❌ forEach */
```

✅ **RIGHT: Using record field references on record instances**
```sail
/* These will ALL work: */
choiceLabels: index(local!users, 'recordType!User.fields.username', {}),
choiceValues: index(local!users, 'recordType!User.fields.userId', {}),
a!forEach(
  items: local!users,
  expression: fv!item['recordType!User.fields.username']
)
```

#### Why This Matters

**Record instances** are strongly typed objects that preserve the full record structure. They require explicit field paths to maintain type safety and relationship integrity.

**Maps** are simple key-value dictionaries created from aggregations. The aliases you define become the property names.

Using the wrong property access method causes:
- Empty/blank displays (properties not found)
- Runtime errors (invalid property access)
- Data binding failures (saves don't persist)

## ⚠️ Record Type Reference Syntax

### Quick Reference

**Record Type Pattern**: `'recordType!RecordTypeName'`
**Field Pattern**: `'recordType!RecordTypeName.fields.fieldName'`
**Relationship Pattern**: `'recordType!RecordTypeName.relationships.relationshipName'`
**Related Field Pattern**: `'recordType!RecordTypeName.relationships.relationshipName.fields.fieldName'`

**Key Rules**:
- Always use the FULL reference string exactly as shown
- Relationships are for navigation, fields are for values
- Use single continuous path for related fields - ONLY ONE bracket for the entire path

---

**In these guidelines, record types are shown with clean semantic names for readability:**

```sail
/* Example syntax (for documentation purposes): */
'recordType!Case.fields.title'
'recordType!Employee.relationships.department.fields.name'
'recordType!Task.relationships.assignee.fields.username'
```

### ⚠️ CRITICAL: These are EXAMPLES, not actual working code!

**In actual Appian SAIL code, you MUST use fully qualified references with UUIDs:**

```sail
/* Actual Appian syntax (what you'll see in the designer): */
'recordType!{abc-123}Case.fields.{def-456}title'
'recordType!{ghi-789}Employee.relationships.{jkl-012}department.fields.{mno-345}name'
```

### How to Get Correct References in Appian Designer:

1. **Start typing** the record type reference: `'recordType!`
2. **Press Ctrl+Space** (or Cmd+Space on Mac) to open autocomplete
3. **Select your record type** from the list (e.g., "Case")
4. **Continue typing** `.fields.` or `.relationships.`
5. **Press Ctrl+Space again** to see available fields/relationships
6. **Select the field/relationship** you need
7. **Appian automatically inserts** the correct UUIDs

### Key Points:

- ✅ **Always use Appian's autocomplete** to get qualified references
- ✅ **Each UUID is unique** to your environment
- ✅ **UUIDs are auto-generated** by Appian when you create record types/fields
- ❌ **Never manually type UUIDs** or copy them between different fields
- ❌ **Never use the example syntax** directly in working code

### For Code Generation:

When generating code, use the **placeholder pattern** to indicate where developers need to substitute actual references:

```sail
/* Generated code pattern: */
ri!case['recordType!Case.fields.title']
fv!row['recordType!Employee.relationships.department.fields.name']

/* Developers replace with actual qualified references from their Appian environment */
```

This approach:
- Makes generated code readable
- Clearly shows the semantic structure
- Requires developers to use proper Appian tooling for actual references
- Prevents UUID copy-paste errors

## 🚨 CRITICAL: Form Interface Data Patterns

**BEFORE writing ANY form/wizard interface, determine the data pattern:**

### Decision Tree:
```
Will users CREATE records? → Use ri! (Rule Input) pattern
Will users UPDATE records? → Use ri! (Rule Input) pattern
Is this ONLY displaying data? → Use query/a!recordData pattern
Is this a static mockup? → Use local variables with hardcoded data
```

### 🔴 MOST CRITICAL RULE:
**Forms that CREATE or UPDATE records MUST use rule inputs (ri!), NOT queries or local variables for the main record data.**

### User Request Keywords That Indicate Rule Input Pattern:
- "form to create/submit/add a [record]"
- "interface to update/edit a [record]"
- "wizard for creating/submitting"
- "application submission"
- "registration form"
- "edit page for [record]"
- "interface used to create or update"

### ✅ CORRECT: Rule Input Pattern (for Create/Update Forms) {#rule-input-pattern}

**When to use**: Interface will be used to create new records or update existing records

```sail
/* Rule Inputs:
 * - ri!recordName: The record being created/updated (null for new, populated for update)
 * - ri!relatedRecord: Any related records needed for context
 */
a!localVariables(
  /* NO QUERY for the main record being edited! */

  /* Use local variables ONLY for transient UI state: */
  local!selectedOptions: null,
  local!dynamicArray: {},

  /* Bind form fields directly to rule inputs: */
  a!textField(
    label: "First Name",
    value: ri!recordName['recordType!Person.fields.firstName'],
    saveInto: ri!recordName['recordType!Person.fields.firstName'],
    required: true
  ),

  /* Validation checks rule input values: */
  a!buttonArrayLayout(
    buttons: {
      a!buttonWidget(
        label: "Submit",
        disabled: a!isNullOrEmpty(ri!recordName['recordType!Person.fields.firstName'])
      )
    }
  )
)
```

**Key characteristics of ri! pattern:**
- Main record data binds to `ri!recordName[...]`
- NO `a!queryRecordType()` for the record being created/updated
- Form fields save directly to `ri!` (auto-persists to record)
- Use `a!isNullOrEmpty()` for validation checks on rule inputs
- Local variables used ONLY for transient UI state (selections, dynamic arrays, temporary data)
- **Exception: Local variables ARE appropriate for reference/lookup data** (dropdown options, status lists, priority levels for missing reference tables)
- ❌ NEVER copy rule inputs to local variables - this breaks data binding to process models
- ✅ Reference `ri!` directly throughout the interface (even in nested conditionals)

### 🚨 Testing Simulation Variables - FOR MANUAL DEVELOPMENT ONLY

⚠️ **IMPORTANT: This pattern is for manual development in Appian Designer, NOT for code generation.**

**When to use this pattern:**
- ✅ You are manually writing/testing an interface in Appian Designer
- ✅ You want to test the interface standalone (without a process model)
- ✅ You will find-replace `local!ri_` → `ri!` before production deployment

**When NOT to use this pattern:**
- ❌ You are generating code programmatically
- ❌ You are using the sail-dynamic-converter agent
- ❌ You want production-ready code immediately

**For Code Generation**: Use the direct `ri!` pattern shown in "✅ CORRECT: Rule Input Pattern" section above (#rule-input-pattern). Skip the testing simulation entirely.

---

When creating standalone testable interfaces during **manual development**, you may use simulation variables to mock rule inputs. However, **these MUST be clearly marked and completely removed before production deployment.**

**Pattern for Development/Testing:**
```sail
a!localVariables(
  /* ============================================
   * TESTING SIMULATION - REMOVE FOR PRODUCTION
   * These simulate rule inputs for standalone testing
   * ============================================ */
  local!ri_submission: 'recordType!Submission'(),  /* DELETE IN PRODUCTION */
  local!ri_isUpdate: false(),                             /* DELETE IN PRODUCTION */

  /* ❌ DO NOT create intermediate variables that copy ri! values */
  /* local!isUpdateMode: local!ri_isUpdate,  <-- NEVER DO THIS */

  /* ✅ Use simulated ri! directly throughout interface */
  a!formLayout(
    titleBar: if(
      local!ri_isUpdate,  /* ✅ Direct reference to simulated ri! */
      "Edit Submission",
      "New Submission"
    ),
    contents: {
      a!textField(
        value: local!ri_submission['recordType!Submission.fields.title'],
        saveInto: local!ri_submission['recordType!Submission.fields.title']
      )
    }
  )
)
```

**For Production Deployment:**
```sail
a!localVariables(
  /* TESTING SIMULATION lines completely removed */

  /* ✅ Use actual ri! throughout interface */
  a!formLayout(
    titleBar: if(
      ri!isUpdate,  /* ✅ Now references actual rule input */
      "Edit Submission",
      "New Submission"
    ),
    contents: {
      a!textField(
        value: ri!submission['recordType!Submission.fields.title'],
        saveInto: ri!submission['recordType!Submission.fields.title']
      )
    }
  )
)
```

**CRITICAL RULES:**
1. ✅ Simulation variables MUST be clearly marked with "TESTING" or "SIMULATION" comments
2. ✅ Use `local!ri_*` naming convention to distinguish from real `ri!` inputs
3. ❌ NEVER create intermediate local variables that copy ri! values
4. ❌ NEVER wrap entire ri! variables in `a!defaultValue()` - Always use for specific field access instead
   - ❌ Wrong: `a!defaultValue(ri!submission, {})` - wrapping entire rule input
   - ✅ Right: `a!defaultValue(ri!submission['recordType!Type.fields.name'], "")` - wrapping field access
5. ✅ Reference simulated `local!ri_*` (or real `ri!`) directly throughout the interface
6. ✅ REMOVE all `local!ri_*` simulation variables before production deployment
7. ✅ Do a find-replace: `local!ri_` → `ri!` when moving to production

**Why This Matters:**
- Copying `ri!` to local variables breaks the binding to the process model
- Changes saved to local copies are NOT persisted to the record
- The process model receives the original `ri!` values, not your local copies
- This causes "data not saving" bugs that are hard to debug

### ❌ WRONG: Query Pattern (for Create/Update Forms)

**This pattern is ONLY for read-only displays, NOT for forms:**

```sail
/* DON'T DO THIS for create/update forms! */
a!localVariables(
  local!currentRecord: a!queryRecordType(...), /* WRONG for forms! */
  local!firstName: a!defaultValue(local!currentRecord[...], null), /* WRONG! */

  a!textField(
    value: local!firstName, /* WRONG - not saving to record! */
    saveInto: local!firstName /* WRONG - just saving to local variable! */
  )
)
```

**Why this is wrong:**
- Changes only update local variables, not the actual record
- Requires manual save logic to persist to record
- Doesn't follow Appian best practices for form interfaces
- Query is unnecessary overhead for create/update operations

### ✅ CORRECT: Query Pattern (for Read-Only Displays)

**When to use**: Displaying data without editing, dashboards, reports, read-only grids

```sail
a!localVariables(
  local!recordData: a!queryRecordType(
    recordType: 'recordType!Type',
    filters: a!queryFilter(...)
  ),

  /* Display in read-only grid: */
  a!gridField(
    data: a!recordData(
      recordType: 'recordType!Type',
      filters: a!queryFilter(...)
    ),
    columns: {
      a!gridColumn(
        label: "Name",
        value: fv!row['recordType!Type.fields.name']
      )
    }
  )
)
```

### Common Mistakes to Avoid:

1. **Using queries for the main record in create/update forms**
   - ❌ Wrong: `local!applicant: a!queryRecordType(...)` in a submission form
   - ✅ Right: `ri!applicant` as rule input

2. **Saving form inputs to local variables instead of rule inputs**
   - ❌ Wrong: `saveInto: local!firstName` when creating/updating a record
   - ✅ Right: `saveInto: ri!recordName['recordType!Type.fields.firstName']`

3. **Mixing patterns inappropriately**
   - ❌ Wrong: Using ri! for reference data that shouldn't be edited
   - ✅ Right: Use ri! for main record, queries for reference/lookup data
   - ✅ Alternative: Use local variables with hardcoded lists for missing reference tables

4. **Using a!map() or {} for record instances**
   - ❌ Wrong: Using `a!map()` or empty `{}` to create record instances
   - ✅ Right: See "Creating New Record Instances" section for proper record type constructor syntax

5. **Detecting record type by null field check**
   - ❌ Wrong: Using `a!isNotNullOrEmpty()` on specific fields to infer record type
   - ✅ Right: Use dedicated type ID field - See "Multi-Type Form Entry Pattern" section
   - **Why:** Fields can be null for multiple reasons (not entered yet, optional, cleared). Use explicit type indicators instead.

### MANDATORY CHECKLIST Before Coding Form Interfaces:

- [ ] Read user request carefully - does it mention "create", "update", "edit", "submit", "form", or "wizard"?
- [ ] If YES → Use ri! pattern for main record
- [ ] If NO (display only) → Use query/a!recordData pattern
- [ ] Main record data binds to ri!, NOT local variables
- [ ] NO a!queryRecordType() for the record being created/updated
- [ ] Local variables used ONLY for transient UI state OR reference/lookup data (not main record fields)
- [ ] Form validation checks ri! values, not local variables
- [ ] All record instances created with record type constructor syntax `'recordType!RecordTypeName'(...)`, not `a!map()` or `{}`
- [ ] All one-to-many relationships use typed records when appending
- [ ] Type discrimination uses dedicated type ID fields, not null field checks

## ⚠️ IMPORTANT: Handling Non-Existent Constants and Environment Objects {#handling-non-existent-constants}

**Never assume constants, process models, groups, folders, integrations, or environment-specific objects exist. Always use placeholders with TODO comments.**

**This applies to ALL generated code, including:**
- Group constants in `a!isUserMemberOfGroup()`
- Folder constants in `a!fileUploadField()`
- Process model constants in `a!startProcess()`
- Any `cons!` reference
- Any `rule!` reference (unless explicitly specified by user)

### The Problem:
Generated code often references objects that don't exist in the target environment:
- Constants (`cons!FOLDER_NAME`, `cons!PROCESS_MODEL`, `cons!GROUP_NAME`)
- Groups (in `a!isUserMemberOfGroup()`)
- Process models (for `a!startProcess()`)
- Document folders (for file upload targets)
- Integration objects
- Expression rules

### ✅ CORRECT Pattern - Placeholder with TODO

```sail
/* Group-based security checks */
a!isUserMemberOfGroup(
  username: loggedInUser(),
  groups: null  /* TODO: Add group constant for case managers */
)

/* File upload fields */
a!fileUploadField(
  label: "Upload Supporting Document",
  target: null,  /* TODO: Add constant value for case documents folder */
  value: local!documentUpload,
  saveInto: local!documentUpload
)

/* Process model references */
a!startProcess(
  processModel: null,  /* TODO: Add constant for case submission process model */
  processParameters: {
    case: ri!case,
    submittedBy: loggedInUser()
  }
)
```

### ❌ WRONG Pattern - Assuming Objects Exist

```sail
/* DON'T DO THIS */
a!isUserMemberOfGroup(
  username: loggedInUser(),
  groups: cons!CASE_MANAGERS_GROUP  /* This constant may not exist! */
)

a!fileUploadField(
  target: cons!CASE_DOCUMENTS_FOLDER,  /* This constant may not exist! */
  ...
)

a!startProcess(
  processModel: cons!SUBMIT_CASE_PROCESS,  /* May not exist! */
  ...
)
```

### TODO Comment Format:
```sail
/* TODO: Add constant value for [specific purpose] */
/* TODO: Configure [object type] - [what it should reference] */
/* TODO: Add integration object for [external system] */
```

### Why This Matters:
1. **Generated code runs immediately** for UI/UX testing
2. **Clear configuration points** - developers search for "TODO"
3. **Self-documenting** - explains what needs configuration
4. **Prevents runtime errors** from missing objects

## ⚠️ Language-Specific Syntax Patterns

**Appian SAIL Conditional Syntax:**
```sail
/* ✅ CORRECT - Use if() function */
value: if(condition, trueValue, falseValue)

/* ❌ WRONG - Python/JavaScript ternary operator */
value: condition ? trueValue : falseValue
```

**Never use patterns from other languages:**
- ❌ Python ternary: `condition ? value1 : value2`
- ❌ JavaScript arrow functions: `() => {}`
- ❌ Java/C# syntax: `public void`, `private static`
- ✅ Always use Appian SAIL function syntax: `functionName(parameters)`

## Essential SAIL Structure

See `/sail-guidelines/local-variable-patterns.md` for complete local variable patterns.

**Key differences for functional interfaces:**
- **Use `ri!` for entity data** being created/updated (never copy to `local!`)
- **Use queries for reference data** and display lists
- **Use `local!` only for UI state** (selections, toggles, pagination)

**Quick reference:**
- **With initial values**: `local!variable: value`
- **Without initial values**: `local!variable` (no null/empty placeholders)
- **For dropdowns**: Initialize to valid `choiceValue` OR use `placeholder`
- **For booleans**: Always explicit: `true()` or `false()`

For scope rules and nested context patterns, see `/sail-guidelines/local-variable-patterns.md#scope-rules`.

## 📝 Documenting Unused Local Variables {#unused-variables-decision-tree}

### Decision Tree

```
Is the variable unused?
├─ YES → Is there a clear future use?
│   ├─ YES → Document with UNUSED comment (see template below)
│   └─ NO → REMOVE IT
└─ NO → No action needed
```

### Template (One-Line Format)

```sail
/* UNUSED - [Name] ([Category]): [Why not used] | [Future use or decision] */
local!variable: value,
```

### Categories & Examples

**Future Enhancement** - Feature planned but not built yet
```sail
/* UNUSED - caseTypes (Future): Text field used; picker planned for Phase 2 case type management */
local!caseTypes: a!queryRecordType('recordType!{...}Case Type', ...).data,
```

**Deferred** - Feature postponed
```sail
/* UNUSED - advancedFilters (Deferred): Phase 1 basic search only per ticket #1234 */
local!showAdvancedFilters: false,
local!filterDateRange,
```

**Alternative** - Different approach available
```sail
/* UNUSED - weightedSLA (Alternative): Client chose flat SLA over priority-weighted */
local!weightedSLA: sum(a!forEach(local!cases, expression: fv!item.hours * fv!item.weight)),
```

**Config** - Waiting for configuration system
```sail
/* UNUSED - pageSize (Config): User preferences not implemented; using default 25 */
local!userPageSize: 50,
```

**Requirements Changed** - Was needed, temporarily disabled
```sail
/* UNUSED - emailValidation (ReqChanged): Disabled for 60-day migration period */
local!isValidEmail: regexmatch("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$", local!email),
```

### Performance Warning

Add performance note if query >0.5s or >500 records:

```sail
/* UNUSED - allCases (Future): Pre-load for export feature | 5000 records, 3s load */
local!allCases: a!queryRecordType(..., batchSize: 5000).data,
```

**Rule**: If >1s and no near-term use → REMOVE

### Quick Reference

| Keep & Document | Remove Immediately |
|-----------------|-------------------|
| ✅ Planned features | ❌ Debug/test code |
| ✅ Deferred work | ❌ Dead refactors |
| ✅ Alternative logic (with reason) | ❌ No clear purpose |
| ✅ Awaiting config system | ❌ Duplicate functionality |

## 🚨 CRITICAL: Relationship Field Navigation Syntax

**CORRECT Syntax:**
```sail
/* ✅ In grids - single continuous path */
fv!row['recordType!Case.relationships.status.fields.value']
fv!row['recordType!Case.relationships.priority.fields.name']

/* ✅ In forms - single continuous path */
ri!record['recordType!Case.relationships.status.fields.value']

/* ✅ In rule inputs - single continuous path */
ri!case['recordType!Case.relationships.caseComment.fields.description']
```

**WRONG Syntax - NEVER DO THIS:**
```sail
/* ❌ Double bracket navigation - CAUSES ERRORS */
fv!row['recordType!Case.relationships.status']['recordType!Status.fields.value']
ri!record['recordType!Case.relationships.status']['recordType!Status.fields.value']

/* ❌ Separate record type reference - INVALID */
fv!row['recordType!Case.relationships.status']['recordType!AnotherType.fields.value']
```

**Fundamental Rule**: Relationships provide a navigation path - use dot notation to traverse from base record → relationship → field in one continuous path. Never use double bracket syntax with separate record type references.

## 🚨 CRITICAL: Grid Column Sorting Rules

**CORRECT Sorting:**
```sail
/* ✅ Sort on record fields only */
sortField: 'recordType!Case.fields.createdOn',       /* Field reference */
sortField: 'recordType!Case.fields.title',           /* Field reference */
sortField: 'recordType!Case.relationships.status.fields.value',        /* Related field */
sortField: 'recordType!Case.relationships.priority.fields.value',      /* Related field */
```

**WRONG Sorting - NEVER DO THIS:**
```sail
/* ❌ Never sort on relationships - CAUSES ERRORS */
sortField: 'recordType!Case.relationships.status',    /* Relationship - INVALID */
sortField: 'recordType!Case.relationships.priority',  /* Relationship - INVALID */
```

**Fundamental Rule**:
- **Relationships** = Navigation to related records (no sorting allowed)
- **Fields** = Data values that can be sorted, filtered, displayed
- Always sort on record fields from either the base record type or a related record type with a many-to-one relationship from the base record type

- **Use available record types, fields, and relationships** - Don't create new ones
- **Access rule inputs directly** - Avoid local variables for record data
- **For one-to-many relationships** - Use main record type's relationships rather than new variables
- **NEVER confuse relationships with fields** - Relationships navigate, fields display values
- **KPI Metrics** - ALWAYS use `a!aggregationFields()` with `a!measure()` for dashboard KPIs and metrics. Only use `.totalCount` for pagination display ("Showing X of Y") or simple conditional checks. See Error 9 and KPI Aggregation Pattern sections for details.
- **Use a!recordData() directly in grid and chart components** - When dealing with record data, avoid using local variables and instead use `a!recordData` directly in these components. When connecting charts to **live record types**, always use the `data` + `config` approach, never `categories` + `series`. For static mockups with hardcoded data, use `categories` + `series` instead.

🚨 MANDATORY CHECKPOINT: For grids with record data, ALWAYS check for and prefer:
1. User filters (userFilters parameter) over custom dropdowns
2. Built-in search (showSearchBox: true) over custom search fields
Only use custom filtering if built-in features are unavailable.

## Creating New Record Instances

### ❌ WRONG - Using a!map() for Records
```sail
/* INCORRECT - a!map() creates untyped maps, not record instances */
append(
  ri!case['recordType!Case.relationships.caseNotes'],
  a!map(
    'recordType!CaseNote.fields.noteText': "Follow up needed",
    'recordType!CaseNote.fields.noteType': "Status Update"
  )
)
```

### ✅ CORRECT - Using Record Type Constructor
```sail
/* CORRECT - Use record type constructor syntax */
append(
  ri!case['recordType!Case.relationships.caseNotes'],
  'recordType!CaseNote'(
    'recordType!CaseNote.fields.noteText': "Follow up needed",
    'recordType!CaseNote.fields.noteType': "Status Update"
  )
)
```

### Record Constructor Rules:
1. **Always use the full record type reference as a function**: `'recordType!RecordTypeName'(...)`
2. **Use parentheses, not curly braces**: `RecordType'()` not `RecordType'{}'`
3. **Field names must be fully qualified**: `'recordType!RecordType.fields.fieldName': value`
4. **This applies to all one-to-many relationships**: Case notes, contact history, document attachments, etc.

### Common Patterns:

**Adding an empty record:**
```sail
append(
  ri!case.caseNotes,
  'recordType!CaseNote'()  /* Empty parentheses for default values */
)
```

**Adding a record with initial values:**
```sail
append(
  ri!case.caseNotes,
  'recordType!CaseNote'(
    'recordType!CaseNote.fields.noteTypeId': 1,
    'recordType!CaseNote.fields.noteText': null,
    'recordType!CaseNote.fields.createdDate': today()
  )
)
```

**Why this matters:**
- `a!map()` creates untyped dictionary objects
- Record type constructors create properly typed record instances
- Typed instances are required for record relationships to work correctly
- Type checking happens at save time, catching errors earlier

## Field Mapping Strategies for Data Model Mismatches

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

## Multi-Type Form Entry Pattern

When a single relationship contains multiple types of records (e.g., Phone Contacts AND Email Contacts in one table, or Internal Notes AND External Communications in one list):

### Pattern: Use Type ID Field

**Data Model Setup:**
- Single record type: `CaseContact`
- Type field: `contactMethodTypeId` (1 = Phone, 2 = Email)
- Shared fields: `contactName`, `contactDate`, `notes`
- Phone-specific: `phoneNumber`, `callDuration`
- Email-specific: `emailAddress`, `emailSubject`

**UI Implementation:**
```sail
a!forEach(
  items: ri!case['recordType!Case.relationships.caseContacts'],
  expression: a!cardLayout(
    contents: {
      /* Card title based on type */
      a!richTextDisplayField(
        labelPosition: "COLLAPSED",
        value: a!richTextItem(
          text: if(
            fv!item['recordType!CaseContact.fields.contactMethodTypeId'] = 2,
            "Email Contact",
            "Phone Contact"
          ),
          size: "MEDIUM",
          style: "STRONG"
        )
      ),

      /* Phone contact fields - show when type = 1 */
      if(
        fv!item['recordType!CaseContact.fields.contactMethodTypeId'] = 1,
        {
          a!textField(
            label: "Phone Number",
            value: fv!item['recordType!CaseContact.fields.phoneNumber'],
            saveInto: fv!item['recordType!CaseContact.fields.phoneNumber']
          ),
          a!integerField(
            label: "Call Duration (minutes)",
            value: fv!item['recordType!CaseContact.fields.callDuration'],
            saveInto: fv!item['recordType!CaseContact.fields.callDuration']
          )
        },
        {}
      ),

      /* Email contact fields - show when type = 2 */
      if(
        fv!item['recordType!CaseContact.fields.contactMethodTypeId'] = 2,
        {
          a!textField(
            label: "Email Address",
            value: fv!item['recordType!CaseContact.fields.emailAddress'],
            saveInto: fv!item['recordType!CaseContact.fields.emailAddress']
          ),
          a!textField(
            label: "Subject Line",
            value: fv!item['recordType!CaseContact.fields.emailSubject'],
            saveInto: fv!item['recordType!CaseContact.fields.emailSubject']
          )
        },
        {}
      )
    }
  )
)
```

**Add Buttons:**
```sail
a!buttonArrayLayout(
  buttons: {
    a!buttonWidget(
      label: "Add Phone Contact",
      icon: "phone",
      style: "OUTLINE",
      saveInto: {
        a!save(
          ri!case['recordType!Case.relationships.caseContacts'],
          append(
            ri!case['recordType!Case.relationships.caseContacts'],
            'recordType!CaseContact'(
              'recordType!CaseContact.fields.contactMethodTypeId': 1,  /* Set type on creation */
              'recordType!CaseContact.fields.contactName': null,
              'recordType!CaseContact.fields.phoneNumber': null,
              'recordType!CaseContact.fields.callDuration': null
            )
          )
        )
      }
    ),
    a!buttonWidget(
      label: "Add Email Contact",
      icon: "envelope",
      style: "OUTLINE",
      saveInto: {
        a!save(
          ri!case['recordType!Case.relationships.caseContacts'],
          append(
            ri!case['recordType!Case.relationships.caseContacts'],
            'recordType!CaseContact'(
              'recordType!CaseContact.fields.contactMethodTypeId': 2,  /* Set type on creation */
              'recordType!CaseContact.fields.contactName': null,
              'recordType!CaseContact.fields.emailAddress': null,
              'recordType!CaseContact.fields.emailSubject': null
            )
          )
        )
      }
    )
  },
  align: "START"
)
```

**Key Points:**
1. **Set `typeId` immediately on record creation** - Don't rely on other field values to infer type
2. **Use `typeId` for all conditional display logic** - Check the type field, not whether specific fields are null/empty
3. **Don't use null/empty field checks for type detection** - Fields can be null for many reasons unrelated to type
4. **Each button creates the same record type** - Only difference is the `typeId` value and which fields are initialized
5. **Initialize type-specific fields to null** - Makes it clear which fields belong to which type


## ⚠️ a!buttonWidget() Parameter Rules

**Valid Parameters ONLY:**
- `label`, `value`, `saveInto`, `submit`, `style`, `color`, `size`, `icon`
- `disabled`, `showWhen`, `validate`, `skipValidation`
- `loadingIndicator`, `confirmMessage`, `confirmHeader`, `link`

**❌ INVALID Parameters:**
- `validations` (does NOT exist - use form-level validations instead)

**✅ Validation Placement:**
- **Form validations**: On `a!formLayout()` validations parameter
- **Field validations**: On individual field components

## ⚠️ a!wizardLayout() Parameters

**Valid Parameters:**
- `titleBar`, `isTitleBarFixed`, `showTitleBarDivider`, `backgroundColor`
- `style`, `showWhen`, `steps`, `contentsWidth`, `showStepHeadings`
- `focusOnFirstInput`, `primaryButtons`, `secondaryButtons`
- `showButtonDivider`, `isButtonFooterFixed`

**❌ INVALID Parameters:**
- `validations` (does NOT exist on wizard layout)

**✅ Validation Placement for Wizards:**
- **Form-level validations**: Place on individual `a!buttonWidget()` in `primaryButtons`
- **Field validations**: Place on individual field components within steps

## 🚨 MANDATORY: Null Safety Implementation {#null-safety-implementation}

> **🔗 Quick Reference:** For fast pattern lookup, see `/sail-guidelines/null-safety-quick-ref.md`
> **🔧 Enforcement:** For functional interfaces, see `sail-dynamic-converter.md` Step 5D.6
> **📖 This section:** Explains WHY null safety matters and HOW the patterns work

**CHECKPOINT: Before finalizing any SAIL expression, verify EVERY direct field reference uses a!defaultValue()**

- ✅ `a!defaultValue(ri!record['recordType!Example.fields.field'], "")`
- ✅ `a!defaultValue(ri!record['recordType!Example.fields.field'], null)`
- ✅ `a!defaultValue(ri!record['recordType!Example.relationships.rel'], {})`
- ❌ `ri!record['recordType!Example.fields.field']` (naked field reference)

**Required Null Safety Patterns:**

1. **Form Field Values**: Always wrap in `a!defaultValue()`
   ```sail
   value: a!defaultValue(ri!record['recordType!X.fields.title'], ""),
   ```

2. **User Function Calls**: Always check for null user IDs BEFORE calling user() function
   ```sail
   /* ✅ CORRECT - Check for null BEFORE calling user() */
   if(
     a!isNotNullOrEmpty(a!defaultValue(userIdField, null)),
     trim(
       user(userIdField, "firstName") & " " & user(userIdField, "lastName")
     ),
     "–"
   )

   /* ❌ WRONG - Checking null INSIDE user() call - user() will fail if passed null */
   trim(
     user(a!defaultValue(userIdField, null), "firstName") & " " &
     user(a!defaultValue(userIdField, null), "lastName")
   )
   ```

   **Critical Note**: The user() function CANNOT accept null as the first parameter. If the field value is null, user() will cause an error. You MUST check for null with an if() statement BEFORE calling user(), not inside the user() function call.

   **Note on User Display Names:**
   - Use `user(userId, "firstName") & " " & user(userId, "lastName")` instead of `displayName`
   - The `displayName` field is actually a nickname and is not always populated
   - Wrap in `trim()` to clean up any extra whitespace
   - Use "–" (en dash) as fallback for null/empty users instead of text like "Unknown User" or "Unassigned"

3. **Array Operations**: Protect all array references
   ```sail
   length(a!defaultValue(ri!record['recordType!X.relationships.items'], {}))
   ```

4. **Validation Logic**: Wrap all validation checks
   ```sail
   if(
     a!isNullOrEmpty(a!defaultValue(ri!record['recordType!X.fields.required'], "")),
     "Field is required",
     null
   )
   ```

**🚨 CRITICAL REMINDER**: The `a!defaultValue()` function prevents interface failures by handling null field references gracefully. This is MANDATORY for all direct field access, not optional. Missing this causes immediate runtime errors.

### Advanced: Functions That Reject Null

**Some functions fail even with `a!defaultValue()` and require `if()` checks BEFORE calling:**

**Null-Rejecting Functions:**
- `user(userId, property)`, `group(groupId, property)` - Cannot accept null ID
- `text(value, format)` - Cannot format null dates/numbers
- String manipulation: `upper()`, `lower()`, `left()`, `right()`, `find()` - Fail on null
- **Logical operators**: `not()` - Cannot accept null value

**Required Pattern:**
```sail
/* ✅ CORRECT - Check for null BEFORE calling function */
if(
  a!isNotNullOrEmpty(a!defaultValue(fieldValue, null)),
  functionThatRejectsNull(fieldValue, otherParams),
  fallbackValue
)

/* ❌ WRONG - a!defaultValue() wrapper doesn't prevent the error */
functionThatRejectsNull(a!defaultValue(fieldValue, null), otherParams)
```

**Rule**: When a function operates ON a value (transforms/formats it), check for null BEFORE calling. The `a!defaultValue()` wrapper alone is insufficient.

#### Special Case: not() with Variables and Rule Inputs

**The `not()` function cannot accept null. When using `not()` with variables or rule inputs that might be null, use `a!defaultValue()` to provide a fallback:**

```sail
/* ❌ WRONG - Direct use of not() with potentially null value */
readOnly: not(ri!isEditable)  /* Fails if ri!isEditable is null */
disabled: not(local!allowEdits)  /* Fails if local!allowEdits is null */

/* ✅ CORRECT - Use a!defaultValue() to provide fallback */
readOnly: not(a!defaultValue(ri!isEditable, false()))  /* Returns true if null */
disabled: not(a!defaultValue(local!allowEdits, false()))  /* Returns true if null */

/* ✅ ALTERNATIVE - Use if() to check for null first */
readOnly: if(
  a!isNullOrEmpty(ri!isEditable),
  true(),  /* Default to read-only if null */
  not(ri!isEditable)
)
```

**Common scenarios requiring null protection:**
- `readOnly: not(ri!isEditable)` → Use `not(a!defaultValue(ri!isEditable, false()))`
- `disabled: not(local!allowEdits)` → Use `not(a!defaultValue(local!allowEdits, false()))`
- `showWhen: not(local!isHidden)` → Use `not(a!defaultValue(local!isHidden, false()))`

**Best Practice**: Always wrap rule inputs and variables in `a!defaultValue()` before passing to `not()`. Choose the default value (`true()` or `false()`) based on the desired behavior when the value is null.

### 🚨 CRITICAL: Null Safety for Computed Variables

**Computed variables that derive from empty arrays require special null checking with nested if() statements.**

**⚠️ IMPORTANT:** SAIL's `and()` and `or()` functions **DO NOT short-circuit**. For detailed explanation and examples of short-circuit evaluation, see the **"🚨 CRITICAL: Short-Circuit Evaluation Rules"** section (#short-circuit-rules).

#### Pattern for Null-Safe Property Access on Computed Variables

**Always use nested if() pattern when accessing properties on computed variables:**

```sail
if(
  if(
    a!isNotNullOrEmpty(local!variable),
    /* Safe to access properties here - variable is guaranteed not empty */
    local!variable.propertyName = "expectedValue",
    /* Return safe default - false, null, or {} depending on context */
    false
  ),
  /* Then branch */,
  /* Else branch */
)
```

#### Why This Matters

**Without proper null safety:**
- Interface fails to load with cryptic property access errors
- Users see error pages instead of forms
- No graceful degradation - complete failure

**With nested if() pattern:**
- Interface loads successfully even when data is empty
- Conditional UI elements hide/show correctly
- Professional user experience with no errors

## Group-Based Access Control Pattern

When implementing role-based access control in SAIL interfaces, use Group type parameters with integer mock IDs for mockups.

### ✅ CORRECT Pattern

```sail
/* ===== INTERFACE PARAMETERS ===== */
/* ri!currentUserGroup (Group): Group of the logged-in user for access control */
/* TODO: Replace integer group IDs with actual Group constant objects once available */

/* ===== GROUP CONSTANTS (Mock - using integers until Group constants are available) ===== */
/* TODO: Replace with cons!PARTNER_GROUP and cons!INDEPENDENCE_TEAM_GROUP */
local!PARTNER_GROUP_ID: 1,
local!INDEPENDENCE_TEAM_GROUP_ID: 2,

/* ===== CONDITIONAL DISPLAY FLAGS ===== */
/* TODO: Once Group constants are available, compare ri!currentUserGroup directly to cons!PARTNER_GROUP */
local!isPartner: a!defaultValue(ri!currentUserGroup, local!PARTNER_GROUP_ID) = local!PARTNER_GROUP_ID,
local!isIndependenceTeam: a!defaultValue(ri!currentUserGroup, local!INDEPENDENCE_TEAM_GROUP_ID) = local!INDEPENDENCE_TEAM_GROUP_ID
```

### ❌ WRONG Pattern (Text-based roles)

```sail
/* DON'T USE TEXT TYPE FOR ROLES */
/* ri!userRole (Text): "Partner" or "Independence Team" */
local!isPartner: ri!userRole = "Partner"
```

### Key Rules

1. **Use Group type for role-based rule inputs** - Not Text type
2. **Define mock group ID constants** - Use integers (1, 2, 3, etc.) as placeholders
3. **Add TODO comments** - Document that integers should be replaced with Group constants
4. **Use a!defaultValue() for comparisons** - Safely handle null group values
5. **Specify constant names in TODOs** - Help future developers know which constants to create (e.g., `cons!PARTNER_GROUP`)

### Why Use Group Type Instead of Text

- **Security**: Groups are managed in Appian's security model, not hardcoded strings
- **Maintainability**: Group membership changes don't require code updates
- **Type Safety**: Group type provides proper validation and prevents typos
- **Best Practice**: Aligns with Appian's security architecture

## ⚠️ Protecting Query Filters That Use Variable Values

**Variables (both ri! and local!) can be null or empty. Query filters that use variable values MUST use `applyWhen` to prevent runtime errors and unexpected behavior.**

**When Variable Values Can Be Null/Empty:**

1. **CREATE Scenarios**: `ri!record` is null when creating a new record
2. **Related Record Filtering**: Parent record's ID field may not exist yet
3. **Optional Relationships**: Related records might not be populated
4. **Conditional Data**: Fields that are only populated under certain conditions
5. **Uninitialized filter variables**: `local!filterStatus,` (declared without value)
6. **Search boxes**: Empty text fields default to empty string or null
7. **Optional dropdowns**: User hasn't selected a value yet
8. **Date range filters**: User leaves start/end date empty
9. **Cleared filters**: User clicks "Clear Filters" button

**The Problem**: Query filters with null values can cause runtime errors. Using `applyWhen` conditionally applies the filter only when the value exists.

**Required Pattern for Filters Using Rule Inputs:**

```sail
/* ✅ CORRECT - Use applyWhen to protect against null rule input values */
a!queryFilter(
  field: 'recordType!ChildRecord.fields.parentId',
  operator: "=",
  value: ri!parentRecord['recordType!ParentRecord.fields.id'],
  applyWhen: a!isNotNullOrEmpty(ri!parentRecord['recordType!ParentRecord.fields.id'])
)

/* ❌ WRONG - No applyWhen protection, will fail if ri!parentRecord is null or ID doesn't exist */
a!queryFilter(
  field: 'recordType!ChildRecord.fields.parentId',
  operator: "=",
  value: ri!parentRecord['recordType!ParentRecord.fields.id']
)
```

**Required Pattern for Filters Using Local Variables:**

```sail
/* ✅ CORRECT - Use applyWhen to protect against null/empty local variable values */
a!queryFilter(
  field: 'recordType!Case.fields.status',
  operator: "=",
  value: local!selectedStatus,
  applyWhen: a!isNotNullOrEmpty(local!selectedStatus)
)

/* ✅ CORRECT - Search filter with local variable */
a!queryFilter(
  field: 'recordType!Organization.fields.name',
  operator: "includes",
  value: local!searchText,
  applyWhen: a!isNotNullOrEmpty(local!searchText)
)

/* ✅ CORRECT - Date range filter with local variable */
a!queryFilter(
  field: 'recordType!Case.fields.startDate',
  operator: ">=",
  value: local!filterStartDateFrom,
  applyWhen: a!isNotNullOrEmpty(local!filterStartDateFrom)
)

/* ❌ WRONG - No applyWhen protection, filter may behave unexpectedly when local! is null/empty */
a!queryFilter(
  field: 'recordType!Case.fields.status',
  operator: "=",
  value: local!selectedStatus
)
```

**Key Rule**: Any query filter whose `value` parameter comes from a **variable** (ri! or local!) MUST include an `applyWhen` check using `a!isNotNullOrEmpty()`. Literal values (strings, numbers, booleans, function results like `loggedInUser()`) do NOT need `applyWhen`.

**Common Scenarios Requiring applyWhen:**

**Single Filter Example (Grid with Related Records):**
```sail
a!gridField(
  data: a!recordData(
    recordType: 'recordType!SupportingDocument',
    filters: a!queryFilter(
      field: 'recordType!SupportingDocument.fields.applicationId',
      operator: "=",
      value: ri!application['recordType!Application.fields.applicationId'],
      applyWhen: a!isNotNullOrEmpty(ri!application['recordType!Application.fields.applicationId'])
    )
  ),
  /* ... */
)
```

**Multiple Filters Example (Combining Variables and Literals):**
```sail
a!queryRecordType(
  recordType: 'recordType!Document',
  filters: a!queryLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: 'recordType!Document.fields.caseId',
        operator: "=",
        value: ri!case['recordType!Case.fields.caseId'],
        applyWhen: a!isNotNullOrEmpty(ri!case['recordType!Case.fields.caseId'])  /* Protect rule input */
      ),
      a!queryFilter(
        field: 'recordType!Document.fields.name',
        operator: "includes",
        value: local!searchText,
        applyWhen: a!isNotNullOrEmpty(local!searchText)  /* Protect local variable */
      ),
      a!queryFilter(
        field: 'recordType!Document.fields.status',
        operator: "=",
        value: "Active"  /* No applyWhen needed - literal values are never null */
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 5000)
)
```

**✅ CHECKPOINT: Before Finalizing Query Filters**

For every `a!queryFilter()` in your code, verify:
- [ ] Does the `value` parameter use a **variable** (ri! or local!)?
- [ ] If yes, have I added `applyWhen: a!isNotNullOrEmpty(value)`?
- [ ] Have I tested the interface when filter variables are null/empty?
- [ ] Are literal values (like "Active", 5, true, loggedInUser()) used without applyWhen? (correct - they're never null)

**Remember**: If a query filter's value comes from `ri!` or `local!`, it MUST have `applyWhen: a!isNotNullOrEmpty()`.

## 🔥 Complex Scenario Handling

**For interfaces with multiple record types:**
- **Identify the primary (base) record type first**
- **Map all relationships before implementation**
- **Use relationship navigation instead of separate queries where possible**
- **Consolidate filters at the primary record level**
- **Avoid creating unnecessary local variables for related data**

## 📝 REQUIRED ASSUMPTION TRACKING

When making assumptions about:
- **Record relationships** - State what you're assuming about connections
- **Business logic** - Explain your interpretation of requirements
- **User intent** - Clarify what you think they want when ambiguous
- **Data structure** - Note any inferred patterns from context

**Format:** "ASSUMPTION: [what you're assuming] - REASON: [why you're assuming this]"

## Audit Fields Management

Set ALL Fields
```sail
saveInto: {
  a!save(ri!record.fields.createdBy, loggedInUser()),
  a!save(ri!record.fields.createdOn, now()),
  a!save(ri!record.fields.modifiedBy, loggedInUser()),
  a!save(ri!record.fields.modifiedOn, now())
}
```

Set ONLY Modified Fields
```sail
saveInto: {
  a!save(ri!record.fields.modifiedBy, loggedInUser()),
  a!save(ri!record.fields.modifiedOn, now())
}
```

```sail
'recordType!Comment'(
  'recordType!Comment.fields.description': local!commentText,
  'recordType!Comment.fields.createdBy': loggedInUser(),
  'recordType!Comment.fields.createdOn': now(),
  'recordType!Comment.fields.modifiedBy': loggedInUser(),
  'recordType!Comment.fields.modifiedOn': now()
)
```

## Data Querying Patterns - CRITICAL USAGE RULES

🚨 MANDATORY: Use Cases by Function

a!recordData() - ONLY for Grid/Chart Data
```sail
/* ✅ Use a!recordData() ONLY inside grids/charts */
a!gridField(
  data: a!recordData(
    recordType: recordType!Employee,
    filters: {
      a!queryFilter(
        field: recordType!Employee.fields.isActive,
        operator: "=",
        value: true,
        applyWhen: a!isNotNullOrEmpty(local!filterValue)
      )
    }
  )
)

/* ❌ WRONG - Never use a!recordData() outside grids/charts */
local!cases: a!recordData(recordType!Case)  /* This is incorrect */
```

a!queryRecordType() - For ALL Other Data Queries
```sail
/* ✅ Use a!queryRecordType() for ALL other data querying */
local!employees: a!queryRecordType(
  recordType: recordType!Employee,
  fields: {
    recordType!Employee.fields.id,
    recordType!Employee.fields.name
  },
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: a!sortInfo(
      field: recordType!Employee.fields.name,
      ascending: true
    )
  ),
  fetchTotalCount: true
).data
```

### ❌ COMMON MISTAKE: Using `sorts` (plural) as Parameter Name in a!queryRecordType()

**The `sorts` parameter does NOT exist in `a!queryRecordType()`.** Sorting is configured inside `a!pagingInfo()` using the `sort` parameter (singular, not plural). Note that `a!pagingInfo()`'s `sort` parameter accepts an **array** of `a!sortInfo()` functions, but the parameter name is still `sort` (singular).

**WRONG:**
```sail
/* ❌ ERROR: sorts doesn't exist as a parameter */
local!positionTypes: a!queryRecordType(
  recordType: 'recordType!PositionType',
  fields: {...},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  sorts: {  /* ❌ Invalid parameter */
    a!sortInfo(
      field: 'recordType!PositionType.fields.displayOrder',
      ascending: true
    )
  }
).data
```

**CORRECT:**
```sail
/* ✅ Sort goes INSIDE pagingInfo, parameter name is 'sort' (singular) */
local!positionTypes: a!queryRecordType(
  recordType: 'recordType!PositionType',
  fields: {...},
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: a!sortInfo(  /* ✅ Correct: inside pagingInfo, singular 'sort' */
      field: 'recordType!PositionType.fields.displayOrder',
      ascending: true
    )
  )
).data
```

**Key Points:**
- Parameter name is `sort` (singular), not `sorts` (plural)
- `sort` is a parameter of `a!pagingInfo()`, not `a!queryRecordType()`
- `sort` accepts an array of `a!sortInfo()` (despite being singular, it takes multiple sort criteria)

🚨 CRITICAL: a!queryRecordType() Fields Parameter - MUST SPECIFY ALL FIELDS

**WITHOUT the `fields` parameter, a!queryRecordType() ONLY returns the PRIMARY KEY field. All other fields will be NULL!**

```sail
/* ❌ WRONG - No fields parameter means ONLY primary key is returned */
local!submissions: a!queryRecordType(
  recordType: recordType!Submission,
  filters: a!queryFilter(
    field: recordType!Submission.fields.userId,
    operator: "=",
    value: loggedInUser()
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10),
  fetchTotalCount: true
).data

/* When you try to display fields in a!forEach(): */
a!forEach(
  items: local!submissions,
  expression: fv!item['recordType!Submission.fields.title']  /* NULL! Field was not queried! */
)

/* ✅ CORRECT - Explicitly list ALL fields you need to display */
local!submissions: a!queryRecordType(
  recordType: recordType!Submission,
  fields: {
    recordType!Submission.fields.submissionId,      /* Primary key */
    recordType!Submission.fields.title,             /* Display field */
    recordType!Submission.fields.status,            /* Display field */
    recordType!Submission.fields.createdOn,         /* Display field */
    recordType!Submission.relationships.user.fields.name  /* Related field */
  },
  filters: a!queryFilter(
    field: recordType!Submission.fields.userId,
    operator: "=",
    value: loggedInUser()
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10),
  fetchTotalCount: true
).data

/* Now all fields are available in a!forEach(): */
a!forEach(
  items: local!submissions,
  expression: fv!item['recordType!Submission.fields.title']  /* ✅ Returns actual value */
)
```

**Key Rules:**
- **ALWAYS include `fields` parameter** with ALL fields you need to display
- **Include primary key field** if you need to create record links
- **Include related record fields** using relationship dot notation
- **Check data model context** to confirm available fields before querying

🚨 CRITICAL: fetchTotalCount Parameter - REQUIRED for .totalCount Access

**The `fetchTotalCount: true` parameter is REQUIRED if you plan to use `.totalCount` property:**

```sail
/* ❌ WRONG - Missing fetchTotalCount means .totalCount is not available */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1)
),
local!count: local!caseQuery.totalCount  /* ERROR or NULL - fetchTotalCount not set! */

/* ✅ CORRECT - Include fetchTotalCount: true */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true  /* REQUIRED for .totalCount */
),
local!count: local!caseQuery.totalCount  /* ✅ Returns actual count */
```

**When to use `fetchTotalCount: true`:**
- When displaying KPI metrics using `.totalCount`
- When showing pagination info ("Showing X of Y results")
- When conditionally displaying content based on result count
- **ALWAYS include it** - there's minimal performance impact and it prevents errors

🚨 CRITICAL: Use Aggregations for KPI Calculations
ALWAYS use a!aggregationFields() with a!measure() for KPIs - NEVER use .totalCount for metrics
```sail
/* ✅ CORRECT - Aggregation for KPI counts */
local!caseCountQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: a!aggregationFields(
    groupings: {},
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "case_count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
/* For aggregation queries with NO groupings, access field directly */
local!totalCases: a!defaultValue(
  local!caseCountQuery.data.case_count,
  0
)

/* ✅ CORRECT - Aggregation for filtered KPI counts */
local!openCasesQuery: a!queryRecordType(
  recordType: recordType!Case,
  filters: a!queryFilter(
    field: recordType!Case.fields.status,
    operator: "=",
    value: "Open"
  ),
  fields: a!aggregationFields(
    groupings: {},
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "open_count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
/* For aggregation queries with NO groupings, access field directly */
local!openCases: a!defaultValue(
  local!openCasesQuery.data.open_count,
  0
)

/* ✅ CORRECT - Aggregation for SUM */
local!revenueSumQuery: a!queryRecordType(
  recordType: recordType!Order,
  fields: a!aggregationFields(
    groupings: {},
    measures: {
      a!measure(
        function: "SUM",
        field: recordType!Order.fields.amount,
        alias: "total_revenue"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
/* For aggregation queries with NO groupings, access field directly */
local!totalRevenue: a!defaultValue(
  local!revenueSumQuery.data.total_revenue,
  0
)

/* ✅ CORRECT - Aggregation for AVERAGE */
local!avgOrderQuery: a!queryRecordType(
  recordType: recordType!Order,
  fields: a!aggregationFields(
    groupings: {},
    measures: {
      a!measure(
        function: "AVG",
        field: recordType!Order.fields.amount,
        alias: "avg_order"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
/* For aggregation queries with NO groupings, access field directly */
local!avgOrderValue: a!defaultValue(
  local!avgOrderQuery.data.avg_order,
  0
)

/* ❌ WRONG - Using .totalCount for KPIs */
local!caseQuery: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: {'recordType!Case.fields.id'},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!totalCases: local!caseQuery.totalCount  /* AVOID - Use aggregation instead */
```

**When to Use Each Approach:**

| Use Case | Correct Approach | Why |
|----------|-----------------|-----|
| **KPI counts (dashboard metrics)** | `a!aggregationFields()` with `a!measure()` | Better performance, database-level calculation |
| **KPI calculations (SUM, AVG, MIN, MAX)** | `a!aggregationFields()` with `a!measure()` | ONLY way to calculate these metrics |
| **Pagination info in grids** | `.totalCount` property | Appropriate for showing "Showing X of Y results" |
| **Simple count for conditional logic** | `.totalCount` property | OK for one-off checks like "if(query.totalCount > 0)" |

**Key Benefits of Aggregations for KPIs:**
- Better performance (database-level calculation)
- Consistent pattern for all metrics (COUNT, SUM, AVG, MIN, MAX, etc.)
- More maintainable and scalable
- Leverages record type's query optimization
- Allows grouping and multiple measures in one query

**MANDATORY: ALWAYS use `a!aggregationFields()` for dashboard KPIs, metrics, and statistics. Only use `.totalCount` for pagination display or simple conditional checks.**

🚨 CRITICAL: Query Data Extraction Patterns

**IMPORTANT: Different query types require different data extraction patterns.**

**Pattern 1: Aggregation Queries with NO Groupings**

When using `a!aggregationFields()` with `groupings: {}` (no groupings), the query returns a SINGLE ROW with aggregated values. Access fields directly from `.data` property:

```sail
/* ✅ CORRECT - Direct property access for aggregations with no groupings */
local!totalAppsQuery: a!queryRecordType(
  recordType: recordType!Application,
  fields: a!aggregationFields(
    groupings: {},  /* NO groupings */
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Application.fields.id,
        alias: "total_count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!totalApplications: a!defaultValue(
  local!totalAppsQuery.data.total_count,  /* Direct property access */
  0
),

/* ❌ WRONG - Unnecessary array indexing */
local!totalApplications: a!defaultValue(
  index(index(local!totalAppsQuery.data, 1, {}).total_count, 1, null),  /* Too complex! */
  0
)
```

---

## Dashboard KPI Aggregation Patterns

For dashboards and reports displaying KPIs, **ALWAYS prefer database aggregations over array processing** to avoid the 5,000 record limit and improve performance.

### ❌ WRONG: Array Processing (Slow, Limited to 5,000 Records)

```sail
local!allSubmissions: a!queryRecordType(
  recordType: 'recordType!Submission',
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 5000)  /* Hard limit! */
).data,

local!totalCount: count(local!allSubmissions),  /* Only counts up to 5,000 */
local!pendingCount: count(
  wherecontains("Pending", local!allSubmissions.status)
)
```

**Problems:**
- Fetches 5,000 rows (slow, memory-intensive)
- Silent data truncation if total > 5,000
- Client-side filtering/counting inefficient

### ✅ RIGHT: Database Aggregation (Fast, Scalable)

**Subsection 1: Single Aggregation (No Grouping)**

Use when you need ONE aggregated value (total count, sum, average):

```sail
local!totalCountQuery: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    groupings: {},  /* NO groupings */
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "total"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1)  /* Returns 1 row */
),
local!totalCount: a!defaultValue(
  local!totalCountQuery.data.total,  /* ✅ Dot notation (property() does NOT exist!) */
  0
)
```

**Subsection 2: Grouped Aggregations**

Use when counting/summing across categories (status, priority, etc.):

```sail
local!statusGroups: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: 'recordType!Submission.fields.status',
        alias: "status"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 5000)  /* Up to 5,000 groups */
).data,

/* Extract specific group counts */
local!pendingCount: index(
  index(
    local!statusGroups,
    wherecontains("Pending", local!statusGroups.status),
    null
  ),
  1,
  a!map(count: 0)
).count  /* ✅ Use dot notation */
```

**Subsection 3: Multiple Measures**

Use when computing multiple aggregations per group (count + sum, count + avg):

```sail
local!departmentStats: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: 'recordType!Submission.relationships.department.fields.name',
        alias: "department"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "submission_count"
      ),
      a!measure(
        function: "SUM",
        field: 'recordType!Submission.fields.requestedAmount',
        alias: "total_amount"
      ),
      a!measure(
        function: "AVG",
        field: 'recordType!Submission.fields.requestedAmount',
        alias: "avg_amount"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 5000)
).data
```

**Subsection 4: Value Extraction Pattern**

After querying aggregated data, extract values using this pattern:

```sail
/* For single aggregation (no grouping) */
local!value: a!defaultValue(
  local!queryResult.data.alias_name,  /* ✅ Direct dot notation */
  0  /* Default value */
)

/* For grouped aggregations */
local!value: index(
  index(
    local!queryResult,
    wherecontains("Group Name", local!queryResult.group_alias),
    null
  ),
  1,
  a!map(measure_alias: 0)  /* Default map */
).measure_alias  /* ✅ Dot notation */
```

**🚨 CRITICAL: The property() function does NOT exist in SAIL. Always use dot notation for property access.**

**Batch Size Guidelines:**
- **Grouped results**: `batchSize: 5000` (supports up to 5,000 unique groups)
- **Single aggregation with no grouping**: `batchSize: 1` (returns exactly 1 row)
- **❌ NEVER**: `batchSize: -1` (deprecated/not supported)

---

**Pattern 2: Regular Queries Returning Rows**

When using `fields: { ... }` (field list) instead of aggregations, the query returns an ARRAY of rows. You must index into the array to access individual rows:

```sail
/* ✅ CORRECT - Array indexing for regular queries */
local!currentApplicant: a!queryRecordType(
  recordType: recordType!Applicant,
  filters: a!queryFilter(
    field: recordType!Applicant.fields.userId,
    operator: "=",
    value: loggedInUser()
  ),
  fields: {
    recordType!Applicant.fields.applicantId,
    recordType!Applicant.fields.firstName,
    recordType!Applicant.fields.lastName
  },
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
).data,

/* Extract from FIRST row using array index [1] */
local!applicantId: a!defaultValue(
  local!currentApplicant[1]['recordType!Applicant.fields.applicantId'],  /* Index into first row */
  null
),
local!firstName: a!defaultValue(
  local!currentApplicant[1]['recordType!Applicant.fields.firstName'],  /* Index into first row */
  ""
),

/* ❌ WRONG - Trying to access property directly without array indexing */
local!applicantId: a!defaultValue(
  local!currentApplicant['recordType!Applicant.fields.applicantId'],  /* ERROR - Missing [1] */
  null
)
```

**How to Decide Which Pattern to Use:**

| Query Type | When to Use | Data Extraction Pattern | Example |
|------------|-------------|------------------------|---------|
| **Aggregation (no groupings)** | KPIs, metrics, counts, SUM, AVG | Direct property access: `query.data.alias` | `local!count: query.data.total_count` |
| **Aggregation (with groupings)** | Grouped metrics, charts | Array iteration with matching | `index(results, wherecontains(value, results.field), {})` |
| **Regular query (fields list)** | Single record lookup, form data | Array indexing: `query[1]['field']` | `query[1]['recordType!X.fields.name']` |
| **Regular query (multiple rows)** | Lists, grids, dropdowns | Use `.data` property directly | `local!items: query.data` |

**Key Indicators:**
- See `groupings: {}`? → Use direct property access: `.data.alias`
- See `groupings: {a!grouping(...)}`? → Use `a!forEach()` or matching for specific group values
- See `fields: { recordType!X.fields.y }`? → Use array indexing: `[1]['field']`
- Using `a!aggregationFields()`? → Check if groupings exist
  - No groupings → Direct access
  - Has groupings → Iterate or match with wherecontains()

**NEVER use index() for aggregations with NO groupings - use direct property access instead.**

**Common Mistakes to Avoid:**

```sail
/* ❌ MISTAKE 1: Array indexing on aggregations with no groupings */
local!kpiQuery: a!queryRecordType(
  fields: a!aggregationFields(groupings: {}, measures: {...})
),
local!value: local!kpiQuery.data[1].alias  /* WRONG - no need for [1] */

/* ✅ CORRECT */
local!value: local!kpiQuery.data.alias  /* Direct access */

/* ❌ MISTAKE 2: Direct access on regular queries */
local!userQuery: a!queryRecordType(
  fields: {'recordType!User.fields.name'}
).data,
local!name: local!userQuery['recordType!User.fields.name']  /* WRONG - missing [1] */

/* ✅ CORRECT */
local!name: local!userQuery[1]['recordType!User.fields.name']  /* Array indexing */

/* ❌ MISTAKE 3: Over-complicated extraction */
local!value: index(index(query.data, 1, {}).field, 1, null)  /* Too complex */

/* ✅ CORRECT - Simple pattern for aggregations */
local!value: a!defaultValue(query.data.field, defaultValue)
```

**Data Extraction Checklist:**
- [ ] Identified query type: aggregation (no groupings), aggregation (with groupings), or regular query?
- [ ] For aggregations with NO groupings: Using direct property access `.data.alias`?
- [ ] For regular queries: Using array indexing `[1]['field']` to get first row?
- [ ] Wrapped extraction in `a!defaultValue()` with appropriate default?
- [ ] Not over-complicating with nested `index()` calls when simpler pattern exists?

Direct Record Type - For Simple Grids
```sail
/* ✅ Use direct record type when no filtering needed */
a!gridField(
  data: recordType!PurchaseOrder,
  /* Columns auto-generated from record list configuration */
)
```

🚨 CRITICAL VIOLATIONS TO AVOID:

❌ **NEVER use query results in grid data parameter:**
```sail
local!cases: a!queryRecordType(...).data,
a!gridField(data: local!cases)  /* WRONG */
```

❌ **NEVER use query results for chart categories/series:**
```sail
a!columnChartField(
  categories: local!queryResults.field,  /* WRONG */
  series: {...}
)
```

✅ **ALWAYS use a!recordData() directly:**
```sail
a!gridField(
  data: a!recordData(recordType: recordType!Example)
)

a!columnChartField(
  data: a!recordData(recordType: recordType!Example),
  config: a!columnChartConfig(...)
)
```

🚨 CRITICAL: Handling Sparse Aggregation Results
- **Aggregation queries only return records that exist** - Missing statuses/categories won't appear in results
- **Never assume array position matching** between full reference lists and aggregation results
- **Use record-based matching instead of index position matching**

```sail
/* ❌ WRONG - Assumes position matching */
index(wherecontains(value, aggregationResults.field), aggregationResults.count, 0)

/* ✅ CORRECT - Handle missing records properly */
a!forEach(
  items: allStatuses,
  expression: a!localVariables(
    local!matchingRecord: index(
      aggregationResults,
      wherecontains(fv!item.value, aggregationResults.status_group),
      {}
    ),
    if(
      length(local!matchingRecord) > 0,
      local!matchingRecord.count,
      0
    )
  )
)
```

Critical Filter Rules

```sail
/* ✅ CORRECT - Simple array with conditional filters */
filters: {
  a!queryFilter(
    field: recordType!Case.fields.statusId,
    operator: "=",
    value: local!selectedStatus,
    applyWhen: a!isNotNullOrEmpty(local!selectedStatus)
  )
}

/* ✅ CORRECT - Single logical expression */
filters: a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(...),
    a!queryFilter(...)
  }
)

/* ❌ WRONG - Never use a!flatten() in filters */
filters: a!flatten({...})  /* Will break interface */

/* ❌ WRONG - Never use if() around filters */
filters: {
  if(condition, filter1, null)  /* Use applyWhen instead */
}

/* ❌ WRONG - Never wrap logical expression in array */
filters: {a!queryLogicalExpression(...)}  /* Remove array wrapper */
```

### ⚠️ CRITICAL: Nesting Query Logical Expressions

**The `filters` parameter ONLY accepts `a!queryFilter()` - NOT nested `a!queryLogicalExpression()`**

When combining AND + OR logic (e.g., "user = current AND (status = A OR status = B)"), use the `logicalExpressions` parameter.

#### ❌ WRONG - Mixing Types in filters Parameter
```sail
/* This will cause a validation error! */
filters: a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(field: "user", operator: "=", value: loggedInUser()),
    a!queryLogicalExpression(  /* ❌ ERROR: Cannot nest here! */
      operator: "OR",
      filters: {
        a!queryFilter(field: "status", operator: "=", value: "SUBMITTED"),
        a!queryFilter(field: "status", operator: "=", value: "VALIDATED")
      }
    )
  }
)
```

**Error Message:** "Expression evaluation error: Invalid type - expected a!queryFilter"

#### ✅ CORRECT - Use logicalExpressions Parameter
```sail
filters: a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(
      field: 'recordType!Submission.fields.user',
      operator: "=",
      value: loggedInUser()
    )
  },
  logicalExpressions: {  /* ✅ Nested expressions go here */
    a!queryLogicalExpression(
      operator: "OR",
      filters: {
        a!queryFilter(
          field: 'recordType!Submission.relationships.status.fields.statusCode',
          operator: "=",
          value: "SUBMITTED"
        ),
        a!queryFilter(
          field: 'recordType!Submission.relationships.status.fields.statusCode',
          operator: "=",
          value: "VALIDATED"
        )
      }
    )
  }
)
```

#### Parameter Rules:
| Parameter | Accepts | Purpose |
|-----------|---------|---------|
| `filters` | **ONLY** `a!queryFilter()` | Direct field comparisons |
| `logicalExpressions` | **ONLY** `a!queryLogicalExpression()` | Nested AND/OR logic |
| `operator` | `"AND"` or `"OR"` | How to combine filters/expressions |

#### Common Patterns:

**User Filter + Status OR:**
```sail
a!queryLogicalExpression(
  operator: "AND",
  filters: {a!queryFilter(field: "owner", ...)},
  logicalExpressions: {
    a!queryLogicalExpression(
      operator: "OR",
      filters: {
        a!queryFilter(field: "status", operator: "=", value: "Active"),
        a!queryFilter(field: "status", operator: "=", value: "Pending")
      }
    )
  }
)
```

**Multiple Nested ORs:**
```sail
a!queryLogicalExpression(
  operator: "AND",
  filters: {a!queryFilter(field: "department", ...)},
  logicalExpressions: {
    a!queryLogicalExpression(operator: "OR", filters: {...}),
    a!queryLogicalExpression(operator: "OR", filters: {...})
  }
)
```

Aggregation Usage
```sail
/* ✅ CORRECT - Use fields parameter with aggregationFields */
a!queryRecordType(
  recordType: recordType!Case,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: recordType!Case.fields.status,
        alias: "status_group"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "case_count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
)

/* ❌ WRONG - No separate aggregations parameter exists */
a!queryRecordType(
  recordType: recordType!Case,
  aggregations: {...}  /* This parameter doesn't exist */
)
```

Sorting in a!queryRecordType
```sail
/* ✅ CORRECT - Sort inside pagingInfo */
a!queryRecordType(
  recordType: recordType!Employee,
  fields: {...},
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: a!sortInfo(
      field: recordType!Employee.fields.lastName,
      ascending: true
    )
  ),
  fetchTotalCount: true
)

/* ❌ WRONG - No direct sort parameter exists */
a!queryRecordType(
  recordType: recordType!Employee,
  sort: a!sortInfo(...),  /* This parameter doesn't exist */
)
```

## ⚠️ Function Parameter Validation

Array Functions - EXACT Parameter Counts
```sail
/* ✅ CORRECT - wherecontains() takes ONLY 2 parameters */
wherecontains(value, array)

/* ✅ CORRECT - contains() takes ONLY 2 parameters */
contains(array, value)

/* ✅ CORRECT - index() takes 2 or 3 parameters */
index(array, position)
index(array, position, default)

/* ❌ WRONG - Never add extra parameters */
wherecontains(value, array, 1)  /* Third parameter doesn't exist */
contains(array, value, true)    /* Third parameter doesn't exist */
```

Common Function Parameter Rules
- **Always verify parameter counts match Appian documentation exactly**
- **Function signature errors cause immediate interface failures**
- **No optional parameters exist unless explicitly documented**

Logical Functions - Proper Boolean Logic
```sail
/* ✅ CORRECT - Use proper boolean logic in and() */
and(
  or(condition1, fallback1),
  or(condition2, fallback2)
)

/* ✅ CORRECT - Multiple conditions */
and(
  a!isNotNullOrEmpty(local!value),
  local!value > 0,
  local!isEnabled
)
```

### 🚨 CRITICAL: Short-Circuit Evaluation Rules {#short-circuit-rules}

**SAIL's `and()` and `or()` functions DO NOT short-circuit** - they evaluate ALL arguments even if the result is already determined.

#### ❌ WRONG: Using and() for Null Safety
```sail
/* ❌ ERROR - and() evaluates BOTH arguments */
/* If local!computedData is empty, the second argument still evaluates */
/* This causes: "Invalid index: Cannot index property 'type' of Null" */
and(
  a!isNotNullOrEmpty(local!computedData),
  local!computedData.type = "Contract"  /* CRASHES if computedData is empty */
)
```

#### ✅ CORRECT: Use Nested if() for Short-Circuit Behavior
```sail
/* ✅ if() short-circuits - only evaluates the returned branch */
if(
  if(
    a!isNotNullOrEmpty(local!computedData),
    local!computedData.type = "Contract",  /* Only evaluated when not empty */
    false
  ),
  /* Then branch - show registration code field */,
  /* Else branch - hide field */
)
```

#### When to Use Nested if() vs and()

**Use nested if() when:**
- Checking null/empty before property access on computed variables
- Any scenario where the second condition CANNOT be safely evaluated if the first is false
- Accessing properties on variables that could be empty arrays or null

**Use and() when:**
- All conditions are independent and can be safely evaluated in any order
- All variables involved are guaranteed to have values (not null, not empty)
- Simple boolean combinations without property access

#### Quick Reference Table

| Function | Short-Circuits? | Use For |
|----------|----------------|---------|
| `if()` | ✅ Yes - Only evaluates returned branch | Null-safe property access, conditional logic, binary conditions |
| `and()` | ❌ No - Evaluates all arguments | Independent boolean conditions only (never for null safety) |
| `or()` | ❌ No - Evaluates all arguments | Independent boolean conditions only (never for null safety) |
| `a!match()` | ✅ Yes - Only evaluates matched branch | Pattern matching - single value against 3+ options (status, category, priority) |

## Component Usage Patterns

User and Group Field Components
**CRITICAL**: When using record fields of type User or Group in forms, use the appropriate picker components.

```sail
/* ✅ CORRECT - User fields */
a!pickerFieldUsers(
  label: "Assignee",
  value: ri!record['recordType!Example.fields.userField'],
  saveInto: ri!record['recordType!Example.fields.userField'],
  maxSelections: 1,
  placeholder: "Select a user"
)

/* ✅ CORRECT - Group fields */
a!pickerFieldGroups(
  label: "Team",
  value: ri!record['recordType!Example.fields.groupField'],
  saveInto: ri!record['recordType!Example.fields.groupField'],
  maxSelections: 1,
  placeholder: "Select a group"
)

/* ❌ WRONG - Don't use dropdowns for User/Group fields */
a!dropdownField(...)  /* Incorrect for User/Group types */
```

Encrypted Text Field with Synced Record Types

**CRITICAL**: `a!encryptedTextField()` is NOT compatible with synced record types.
```sail
/* ❌ WRONG - Cannot use with synced record types */
a!encryptedTextField(
  label: "Password",
  value: ri!record['recordType!Example.fields.password'],
  saveInto: ri!record['recordType!Example.fields.password']
)

/* ✅ CORRECT - Use standard text field with warning banner */
a!messageBanner(
  primaryText: "Review required",
  secondarytext: "Encrypted text field changed to standard text field due to synced record type limitations. Consider implementing additional security measures for password handling.",
  backgroundColor: "WARN",
  showWhen: true()
),
a!textField(
  label: "Password",
  instructions: "Password must be between 8-16 characters",
  value: a!defaultValue(
    ri!record['recordType!Example.fields.password'],
    ""
  ),
  saveInto: ri!record['recordType!Example.fields.password'],
  required: true()
)
```
**Rule**: When synced record types require password or sensitive text fields:
1. Use a!textField() instead of a!encryptedTextField()
2. Add a!messageBanner() with backgroundColor: "WARN" above the field
3. Include clear message explaining the technical limitation
4. Mark as "Review required" to flag for stakeholder attention
5. This is an acceptable UX modification exception due to technical constraints

Dropdown Field Rules - CRITICAL PATTERNS

🚨 CRITICAL: Dropdown Variable Initialization

**NEVER initialize dropdown variables when using record data:**
```sail
/* ❌ WRONG - Will cause dropdown failures */
local!selectedStatus: "All Statuses",  /* Value not in choiceValues */

/* ✅ CORRECT - Declare without initialization */
local!selectedStatus,  /* Starts as null, placeholder shows */
```

**Rule**: When dropdown choiceValues come from record queries, the variable must start uninitialized (null) to prevent value/choiceValues mismatches.

```sail
/* ✅ CORRECT - Record data dropdowns. Use query results directly  */
a!dropdownField(
  choiceLabels: local!statuses['recordType!Status.fields.value'],  /* Display text */
  choiceValues: local!statuses['recordType!Status.fields.id'],     /* Store IDs */
  value: local!selectedStatusId,                                   /* Variable stores ID */
  saveInto: local!selectedStatusId,
  placeholder: "All Statuses"  /* Use placeholder, not append() */
)

/* ✅ CORRECT - Use placeholder for "All" options instead */
choiceLabels: local!statuses.value,
placeholder: "All Statuses"

/* ❌ WRONG - Never use append() with record data */
choiceLabels: append("All", local!statuses.value)

/* ❌ WRONG - Never use value-to-ID translation */
local!selectedId: index(
  wherecontains(local!textValue, local!statuses.value),  /* wherecontains() returns array! */
  local!statuses.id,
  null
)

/* ❌ WRONG - wherecontains() with index() for single values */
wherecontains("text", array)  /* Returns [2, 5] not 2 */
```

### Record Foreign Key Selection Pattern

#### Efficient Dropdown Pattern (✅ PREFERRED)

**Use Case:** Form dropdowns that select foreign key relationships (e.g., selecting a Case Type, Priority, Status, Department, etc.)

```sail
/* Query for reference data */
local!caseTypes: a!queryRecordType(
  recordType: 'recordType!Case_Type',
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 500  /* Adjust based on expected reference data size */
  ),
  fields: {
    'recordType!Case_Type.fields.id',
    'recordType!Case_Type.fields.name'
  },
  fetchTotalCount: true
).data,

/* ✅ CORRECT - Direct field access (most efficient) */
a!dropdownField(
  label: "Case Type",
  choiceLabels: local!caseTypes['recordType!Case_Type.fields.name'],
  choiceValues: local!caseTypes['recordType!Case_Type.fields.id'],
  value: ri!case.caseTypeId,
  saveInto: ri!case.caseTypeId,
  placeholder: "Select a case type",
  required: true
)

/* ❌ AVOID - forEach is less efficient and unnecessary */
a!dropdownField(
  label: "Case Type",
  choiceLabels: a!forEach(
    items: local!caseTypes,
    expression: fv!item['recordType!Case_Type.fields.name']
  ),
  choiceValues: a!forEach(
    items: local!caseTypes,
    expression: fv!item['recordType!Case_Type.fields.id']
  ),
  value: ri!case.caseTypeId,
  saveInto: ri!case.caseTypeId,
  placeholder: "Select a case type"
)
```

#### Key Points

1. **pagingInfo is REQUIRED** in `a!queryRecordType()`
   - Set appropriate `batchSize` for reference data (typically 100-1000)
   - For large reference datasets, consider implementing search-as-you-type pattern

2. **Direct field access is more efficient**
   - `local!items['recordType!X.fields.name']` automatically extracts the field from all items
   - No need for `a!forEach()` to iterate and extract

3. **Works for both filtered and unfiltered queries**
   - Same pattern applies whether filtering active records or querying all items

4. **Sorting reference data**
   - Use `sort` parameter in `a!pagingInfo()` for custom display order
   - Common for priorities, statuses with display order fields

#### When to Use This Pattern

**✅ Use for ALL many-to-one relationships:**
- Reference data: Status, Priority, Type, Category
- Lookup tables: Department, Location, Region
- Parent records: Organization, Customer, Project
- ANY relationship where the form record points to ONE related record

**Create vs Edit Mode:**
- **Create mode**: Initialize foreign key field as `null`, show full dropdown list
- **Edit mode**: Foreign key field contains existing ID, dropdown pre-selects current value

**❌ NOT for one-to-many relationships:**
- When parent manages multiple children (Case → Comments, Organization → Submissions)
- Use direct relationship access instead (see "One-to-Many Relationship Data Management")

Rich Text Display Field Structure
**CRITICAL**: `a!richTextDisplayField()` value parameter takes arrays of rich text components.

```sail
/* ✅ CORRECT - value takes array of rich text components */
a!richTextDisplayField(
  value: {
    a!richTextIcon(icon: "user", color: "SECONDARY"),
    a!richTextItem(text: "Display text", style: "STRONG")
  }
)

/* ❌ WRONG - Cannot nest other field components in rich text */
a!richTextDisplayField(
  value: a!linkField(...)  /* Invalid nesting */
)

/* ✅ CORRECT - Use link property in richTextItem */
a!richTextDisplayField(
  value: {
    a!richTextItem(
      text: "Click here",
      link: a!recordLink(recordType: recordType!Case, identifier: 1)
    )
  }
)
```

Available Rich Text Components:
- `a!richTextItem()` - Text with formatting and optional links
- `a!richTextIcon()` - Icons with color and size
- `a!richTextImage()` - Embedded images
- `a!richTextBulletedList()` - Bullet point lists
- `a!richTextNumberedList()` - Numbered lists
- `char(10)` - Line breaks
- Plain text strings

Grid Field Essentials
**CRITICAL**: Grid column `value` property must be one of these specific component types:
- Text (string)
- `a!imageField()`
- `a!linkField()`
- `a!richTextDisplayField()`
- `a!tagField()`
- `a!buttonArrayLayout()`
- `a!recordActionField()`
- `a!progressBarField()`

```sail
a!gridField(
  data: a!recordData(
    recordType: recordType!PurchaseOrder,
    filters: {
      a!queryFilter(
        field: recordType!PurchaseOrder.fields.status,
        operator: "=",
        value: local!filterStatus,
        applyWhen: a!isNotNullOrEmpty(local!filterStatus)
      )
    }
  ),
  columns: {
    a!gridColumn(
      label: "Title",
      value: a!richTextDisplayField(
        value: {
          a!richTextItem(
            text: fv!row[recordType!PurchaseOrder.fields.title],
            link: a!recordLink(
              recordType: recordType!PurchaseOrder,
              identifier: fv!identifier
            )
          )
        }
      ),
      sortField: recordType!PurchaseOrder.fields.title,  /* ✅ Field reference only */
      width: "MEDIUM"
    )
  },
  emptyGridMessage: "No records found"  /* Text only - no rich text or components */
)
```

Built-in Grid Features (Always Prefer)

```sail
/* ✅ CORRECT - Use built-in user filters when available */
a!gridField(
  data: a!recordData(recordType: recordType!Case),
  userFilters: {
    recordType!Case.filters.Status,
    recordType!Case.filters.Priority
  },
  showSearchBox: true(),  /* Built-in text search */
  columns: { /* ... */ }
)

/* ❌ WRONG - Custom dropdowns when user filters exist */
local!filterStatus,  /* Unnecessary when user filters exist */
a!dropdownField(...),  /* Don't create custom filters */
a!gridField(
  data: a!recordData(
    recordType: recordType!Case,
    filters: { /* custom filters */ }
  )
)
```

## Record Links and Identifiers

**fv!identifier Availability Rules**

`fv!identifier` is ONLY automatically available in specific contexts where Appian provides it:

**✅ Available Contexts:**
1. **Grid columns with `a!recordData()`** - Identifier provided automatically
2. **Grid recordActions parameter** - For row-specific actions

**❌ NOT Available Contexts:**
1. **`a!forEach()` over query results** - Must use primary key field instead
2. **`a!forEach()` over `.data` property** - Must use primary key field instead
3. **Manual array iterations** - Must use primary key field instead

```sail
/* ✅ CORRECT - fv!identifier works in grids with a!recordData() */
a!gridField(
  data: a!recordData(recordType: recordType!Case),
  columns: {
    a!gridColumn(
      label: "Title",
      value: a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!row[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!identifier  /* ✅ Works - provided by a!recordData() */
          )
        )
      )
    )
  },
  recordActions: {
    a!recordActionItem(
      action: recordType!Case.actions.updateCase,
      identifier: fv!identifier  /* ✅ Works - provided by grid context */
    )
  }
)

/* ❌ WRONG - fv!identifier doesn't exist in a!forEach over query results */
local!cases: a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.caseId,
    recordType!Case.fields.title
  }
).data,

a!forEach(
  items: local!cases,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!item[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!identifier  /* ❌ ERROR - Not available in a!forEach */
          )
        )
      )
    }
  )
)

/* ✅ CORRECT - Use primary key field in a!forEach */
local!cases: a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.caseId,  /* Must query the primary key field */
    recordType!Case.fields.title
  }
).data,

a!forEach(
  items: local!cases,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!item[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!item[recordType!Case.fields.caseId]  /* ✅ Use primary key */
          )
        )
      )
    }
  )
)
```

**Record Link Identifier Rules:**

1. **When using `a!recordData()` in grids/charts**: Use `fv!identifier`
2. **When using `a!queryRecordType().data` with `a!forEach()`**: Use the primary key field
3. **Always query the primary key field** when you need to create record links in `a!forEach()`
4. **Primary key fields are typically**: `id`, `caseId`, `orderId`, `employeeId`, etc.

**Rule of Thumb**: If you're iterating with `a!forEach()` over query results and need record links, you MUST include the primary key field in your query and use it as the identifier.

## Pattern Matching with Record Fields

When displaying record data with conditional styling, **PREFER `a!match()` over nested `if()`** for cleaner code.

### ✅ Best Practice: Status-Based Styling
```sail
a!gridColumn(
  label: "Status",
  value: a!tagField(
    tags: a!tagItem(
      text: a!defaultValue(
        fv!row['recordType!Case.relationships.status.fields.statusName'],
        ""
      ),
      backgroundColor: a!match(
        value: a!defaultValue(
          fv!row['recordType!Case.relationships.status.fields.statusCode'],
          ""
        ),
        equals: "OPEN", then: "ACCENT",
        equals: "IN_PROGRESS", then: "#3B82F6",
        equals: "RESOLVED", then: "POSITIVE",
        equals: "CLOSED", then: "SECONDARY",
        default: "STANDARD"
      )
    ),
    labelPosition: "COLLAPSED"
  )
)
```

**Key Points:**
- Wrap `a!match()` value in `a!defaultValue()` for null safety
- Use status codes (not display names) for reliable matching
- Provide a sensible `default` for unexpected values
- Much cleaner than nested `if()` statements

**Why a!match() for Record Data:**
```sail
/* ❌ AVOID - Nested if() with long record field paths (hard to read) */
backgroundColor: if(
  a!defaultValue(fv!row['recordType!...statusCode'], "") = "INTEGRATED",
  "POSITIVE",
  if(
    or(
      a!defaultValue(fv!row['recordType!...statusCode'], "") = "SUBMITTED",
      a!defaultValue(fv!row['recordType!...statusCode'], "") = "VALIDATED"
    ),
    "ACCENT",
    "SECONDARY"
  )
)

/* ✅ PREFER - a!match() with one value extraction (much cleaner) */
a!match(
  value: a!defaultValue(fv!row['recordType!...statusCode'], ""),
  equals: "INTEGRATED", then: "POSITIVE",
  equals: "SUBMITTED", then: "ACCENT",
  equals: "VALIDATED", then: "ACCENT",
  default: "SECONDARY"
)
```

**Benefits with Record Fields:**
- Long record field paths written once (in `value`), not repeated
- Easier to update field references
- Clearer mapping of status codes to colors/icons
- Less error-prone when editing

See `/dynamic-behavior-guidelines/dynamic-sail-expression-guidelines.md` section "Using a!match() for Status-Based Lookups" for complete `a!match()` guidance and decision criteria.

## 🚨 CRITICAL: One-to-Many Relationship Data Management in Forms

**When creating or updating data in a form using the ri! pattern, manage one-to-many related records through the parent record's relationship field. NEVER query them separately or use local variables.**

### Core Principle:
**In create/update forms, the relationship field IS the data source. No queries, no copies.**

### ✅ CORRECT Pattern - Direct Relationship Access

**Displaying related records in forms:**
```sail
/* Iterate directly over the relationship - Case has many Comments */
a!forEach(
  items: ri!case['recordType!Case.relationships.caseComment'],
  expression: a!cardLayout(
    contents: {
      a!paragraphField(
        label: "Comment " & fv!index,
        /* Access fields through fv!item */
        value: fv!item['recordType!Comment.fields.description'],
        saveInto: fv!item['recordType!Comment.fields.description'],
        height: "MEDIUM"
      ),
      a!dateField(
        label: "Date",
        value: fv!item['recordType!Comment.fields.commentDate'],
        saveInto: fv!item['recordType!Comment.fields.commentDate']
      )
    }
  )
)
```

**Adding new related records:**
```sail
a!buttonWidget(
  label: "Add Comment",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      append(
        ri!case['recordType!Case.relationships.caseComment'],
        'recordType!Comment'(
          'recordType!Comment.fields.commentDate': today(),
          'recordType!Comment.fields.createdBy': loggedInUser()
        )
      )
    )
  }
)
```

**Removing related records:**
```sail
a!buttonWidget(
  label: "Remove Comment",
  icon: "trash",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      remove(
        ri!case['recordType!Case.relationships.caseComment'],
        fv!index  /* Remove item at current index in forEach */
      )
    )
  },
  showWhen: length(ri!case['recordType!Case.relationships.caseComment']) > 1
)
```

**Counting related records:**
```sail
a!richTextItem(
  text: "Total Comments: " & length(
    ri!case['recordType!Case.relationships.caseComment']
  )
)
```

**Checking if relationship is empty:**
```sail
if(
  a!isNullOrEmpty(ri!case['recordType!Case.relationships.caseComment']),
  /* Show message when no comments */
  a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: "No comments added yet. Click 'Add Comment' to begin.",
          color: "SECONDARY"
        )
      )
    }
  ),
  /* Show comments when data exists */
  a!forEach(
    items: ri!case['recordType!Case.relationships.caseComment'],
    expression: ...
  )
)
```

### ❌ WRONG Pattern - Separate Queries or Local Variables

**DON'T DO THIS:**
```sail
/* ❌ WRONG - Querying related data separately */
local!caseComments: a!queryRecordType(
  recordType: 'recordType!Comment',
  filters: a!queryFilter(
    field: 'recordType!Comment.fields.caseId',
    operator: "=",
    value: ri!case['recordType!Case.fields.caseId']
  )
).data,

/* ❌ WRONG - Managing in local variable */
a!forEach(
  items: local!caseComments,  /* Don't use local variables! */
  expression: ...
)

/* ❌ WRONG - Copying relationship to local variable */
local!comments: ri!case['recordType!Case.relationships.caseComment']
/* This creates a COPY - changes won't save to the relationship */
```

### Why This Pattern Is Mandatory:
1. **Automatic persistence**: Changes to relationship fields auto-save
2. **Correct foreign keys**: Appian manages the parent-child links
3. **Single source of truth**: No sync issues between copies
4. **Simpler code**: No manual save logic needed

### Pattern Summary Table:

| Action | Use This Pattern |
|--------|------------------|
| **Display** | `a!forEach(items: ri!case['...relationships.caseComment'], ...)` |
| **Add** | `append(ri!case['...relationships.caseComment'], 'recordType!Comment'(...))` |
| **Remove** | `remove(ri!case['...relationships.caseComment'], fv!index)` |
| **Edit** | `fv!item['recordType!Comment.fields.description']` (in forEach) |
| **Count** | `length(ri!case['...relationships.caseComment'])` |
| **Check if empty** | `a!isNullOrEmpty(ri!case['...relationships.caseComment'])` |

## Related Record Field References
Don't use relationships to display values. Instead, use the first text field from the related record type.

```sail
/* ✅ CORRECT - Use specific field path with single continuous navigation */
ri!case['recordType!Case.relationships.caseComment.fields.description']

/* ❌ WRONG - Don't use bare relationship */
ri!case['recordType!Case.relationships.caseComment']

/* ❌ WRONG - Double bracket syntax */
ri!case['recordType!Case.relationships.caseComment']['recordType!Comment.fields.description']

/* ✅ CORRECT - For counting related records */
length(ri!case['recordType!Case.relationships.caseComment.fields.description'])

/* ✅ CORRECT - For displaying related data in grids */
fv!item['recordType!Comment.fields.description']
```

## User/Group Fields vs Relationships

**When the data model shows BOTH a field AND a relationship for users, ALWAYS use the FIELD reference, NEVER the relationship.**

Many record types have both:
- **Field** (e.g., `assignedTo`, `createdBy`, `modifiedBy`): User type field
- **Relationship** (e.g., `assignedToUser`, `createdByUser`, `modifiedByUser`): many-to-one relationship to User record type

**ALWAYS query and display using the FIELD, NOT the relationship:**

```sail
/* ✅ CORRECT - Use the User field directly in queries */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.assignedTo,
    recordType!Case.fields.createdBy,
    recordType!Case.fields.modifiedBy
  }
)

/* ✅ CORRECT - Use the User field in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: if(
    a!isNotNullOrEmpty(fv!row[recordType!Case.fields.assignedTo]),
    trim(
      user(fv!row[recordType!Case.fields.assignedTo], "firstName") & " " &
      user(fv!row[recordType!Case.fields.assignedTo], "lastName")
    ),
    "–"
  ),
  sortField: recordType!Case.fields.assignedTo
)

/* ✅ CORRECT - Use the User field in forms */
a!pickerFieldUsers(
  label: "Assigned To",
  value: a!defaultValue(
    ri!case[recordType!Case.fields.assignedTo],
    null
  ),
  saveInto: ri!case[recordType!Case.fields.assignedTo]
)

/* ❌ WRONG - Don't use the User relationship */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.relationships.assignedToUser,  /* WRONG */
    recordType!Case.relationships.createdByUser,   /* WRONG */
    recordType!Case.relationships.modifiedByUser   /* WRONG */
  }
)

/* ❌ WRONG - Don't use relationship in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: fv!row[recordType!Case.relationships.assignedToUser]  /* CAUSES ERRORS */
)
```

**Rule of Thumb for Fields vs Relationships:**

| Data Type | When to Use | Example |
|-----------|-------------|---------|
| **User field** | Always use the FIELD | `assignedTo`, `createdBy`, `modifiedBy` |
| **Group field** | Always use the FIELD | `teamGroup`, `departmentGroup` |
| **Date/DateTime field** | Always use the FIELD | `createdOn`, `modifiedOn`, `dueDate` |
| **Text/Number/Boolean field** | Always use the FIELD | `title`, `caseId`, `isActive` |
| **Related record data** | Use the RELATIONSHIP to navigate | `refCaseStatus.fields.value`, `teamRelationship.fields.teamname` |

**Key Principle:**
- **Fields** store scalar values (User, Date, Text, Number, Boolean) → Access directly
- **Relationships** navigate to related records via foreign keys → Use for accessing fields on the related record

**Why Both Field and Relationship Exist:**
- The **field** (e.g., `assignedTo`) stores the actual User value and is what you use for queries, displays, and forms
- The **relationship** (e.g., `assignedToUser`) exists primarily for advanced relationship modeling and is rarely used in interfaces
- The relationship may provide access to additional User record properties, but for standard use cases (displaying names, filtering by user, etc.), always use the field

### ⚠️ CRITICAL: Type Incompatibility - Relationships vs Fields

**Relationships are navigation paths, NOT scalar values:**

- **Fields** return scalar types: `User`, `Text`, `Number`, `Date`, `Boolean`
- **Relationships** return:
  - **One-to-many**: Array of records (e.g., `Comment Record[]`)
  - **Many-to-one or one-to-one**: Single record instance (e.g., `Customer Record`)

**This causes TYPE MISMATCH errors when passing to most functions:**

```sail
/* ❌ WRONG - Type mismatch: user() expects User (scalar), not User Record (relationship) */
user(
  fv!row['recordType!Case.relationships.assignedToUser'],  /* Returns User Record */
  "firstName"
)

/* ✅ CORRECT - Field returns User (scalar) */
user(
  fv!row['recordType!Case.fields.assignedTo'],  /* Returns User */
  "firstName"
)
```

**Valid uses of relationships:**

1. **a!relatedRecordData()** - Filter, sort, and limit one-to-many related records

   **Purpose:** Use within `a!recordData()` or `a!queryRecordType()` to filter, sort, and limit records from a **one-to-many relationship**.

   **Key Constraints:**
   - **ONE-TO-MANY relationships ONLY** — Does NOT work with many-to-one
   - **Requires data sync enabled** on the record type
   - **Cannot be used in aggregations** or records-powered charts
   - **Default limit is 10** — Always specify limit if you need more (max 100 for grids, 250 for queryRecordByIdentifier)
   - Inherits default filters from the related record type

   **Parameters:**
   | Parameter | Required | Description |
   |-----------|----------|-------------|
   | `relationship` | Yes | One-to-many relationship reference |
   | `filters` | No | Filter related records (AND logic) |
   | `sort` | No | Sort related records |
   | `limit` | No | Max records (default: 10, max: 100/250) |

   **Pattern: Get Latest Related Record**
   ```sail
   /* Get only the most recent comment for each case */
   a!relatedRecordData(
     relationship: 'recordType!Case.relationships.comments',
     sort: a!sortInfo(
       field: 'recordType!Comment.fields.createdOn',
       ascending: false
     ),
     limit: 1
   )
   ```

   **Pattern: Filter Related Records**
   ```sail
   /* Get only active line items */
   a!relatedRecordData(
     relationship: 'recordType!Order.relationships.lineItems',
     filters: a!queryFilter(
       field: 'recordType!LineItem.fields.status',
       operator: "=",
       value: "Active"
     ),
     limit: 50
   )
   ```

   **Pattern: Grid with Filtered Related Data**
   ```sail
   a!gridField(
     data: a!recordData(
       recordType: 'recordType!Case',
       relatedRecordData: {
         a!relatedRecordData(
           relationship: 'recordType!Case.relationships.comments',
           filters: a!queryFilter(
             field: 'recordType!Comment.fields.isPublic',
             operator: "=",
             value: true
           ),
           sort: a!sortInfo(
             field: 'recordType!Comment.fields.createdOn',
             ascending: false
           ),
           limit: 5
         )
       }
     ),
     columns: { ... }
   )
   ```

   **Common Mistakes:**
   ```sail
   /* ❌ WRONG - Many-to-one relationship (use direct field access instead) */
   a!relatedRecordData(
     relationship: 'recordType!Case.relationships.status'  /* This is many-to-one! */
   )

   /* ✅ CORRECT - For many-to-one, access fields directly without a!relatedRecordData() */
   fv!row['recordType!Case.relationships.status.fields.statusName']

   /* ❌ WRONG - Using in aggregation query */
   a!queryRecordType(
     recordType: 'recordType!Case',
     fields: a!aggregationFields(...),
     relatedRecordData: { ... }  /* Not supported with aggregations! */
   )

   /* ❌ WRONG - Assuming all related records are returned */
   a!relatedRecordData(
     relationship: 'recordType!Order.relationships.lineItems'
     /* Missing limit - only returns 10 by default! */
   )

   /* ✅ CORRECT - Specify limit when you need more than 10 */
   a!relatedRecordData(
     relationship: 'recordType!Order.relationships.lineItems',
     limit: 100
   )
   ```

2. **Null checking functions** - Check for existence of related records
   ```sail
   /* ✅ CORRECT - Check if case has any comments (one-to-many) */
   if(
     a!isNullOrEmpty(
       fv!row['recordType!Case.relationships.comments']  /* Returns Comment[] */
     ),
     "No comments",
     "Has comments"
   )

   /* ✅ CORRECT - Check if case has an assigned customer (many-to-one) */
   if(
     a!isNotNullOrEmpty(
       fv!row['recordType!Case.relationships.customer']  /* Returns Customer Record */
     ),
     "Customer assigned",
     "No customer"
   )
   ```

3. **Array manipulation functions** - Process one-to-many relationships
   ```sail
   /* ✅ CORRECT - a!forEach over one-to-many relationship (returns array) */
   a!forEach(
     items: ri!case['recordType!Case.relationships.comments'],  /* Returns Comment[] */
     expression: a!cardLayout(
       contents: {
         a!richTextDisplayField(
           value: {
             a!richTextItem(
               text: fv!item['recordType!Comment.fields.commentText']  /* Navigate to field */
             )
           }
         )
       }
     )
   )

   /* ✅ CORRECT - length() counts related records in one-to-many */
   a!richTextDisplayField(
     value: {
       a!richTextItem(
         text: "Comments: " &
           if(
             a!isNullOrEmpty(ri!case['recordType!Case.relationships.comments']),
             "0",
             length(ri!case['recordType!Case.relationships.comments'])
           )
       )
     }
   )

   /* ✅ CORRECT - wherecontains() filters relationship arrays */
   wherecontains(
     "High",
     ri!case['recordType!Case.relationships.comments'].fields.priority
   )
   ```

4. **Navigation to related record fields** - Access fields on the related record
   ```sail
   /* ✅ CORRECT - Navigate through many-to-one relationship to get related field */
   fv!row['recordType!Case.relationships.customer.fields.companyName']

   /* ✅ CORRECT - Navigate through one-to-one relationship */
   fv!row['recordType!Case.relationships.resolution.fields.resolvedDate']
   ```

**Common type mismatch errors:**

```sail
/* ❌ WRONG - concat() expects Text fields, not relationship */
concat(
  fv!row['recordType!Case.relationships.customer'],  /* Returns Customer Record */
  " - ",
  fv!row['recordType!Case.fields.caseNumber']
)

/* ✅ CORRECT - Navigate to field on related record */
concat(
  fv!row['recordType!Case.relationships.customer.fields.companyName'],  /* Returns Text */
  " - ",
  fv!row['recordType!Case.fields.caseNumber']
)

/* ❌ WRONG - text() expects Date/Number field, not relationship */
text(
  fv!row['recordType!Case.relationships.priority'],  /* Returns Priority Record */
  "MMM d, yyyy"
)

/* ✅ CORRECT - Navigate to field on related record */
text(
  fv!row['recordType!Case.relationships.priority.fields.dueDate'],  /* Returns Date */
  "MMM d, yyyy"
)

/* ❌ WRONG - Arithmetic operators expect Number fields, not relationships */
fv!row['recordType!Case.relationships.estimatedHours'] + 10  /* Type error */

/* ✅ CORRECT - Use the Number field */
fv!row['recordType!Case.fields.estimatedHours'] + 10

/* ❌ WRONG - user() on many-to-one relationship instead of field */
user(
  fv!row['recordType!Case.relationships.assignedToUser'],  /* Returns User Record */
  "firstName"
)

/* ✅ CORRECT - Use the User field directly */
user(
  fv!row['recordType!Case.fields.assignedTo'],  /* Returns User */
  "firstName"
)
```

**Validation rule:**

| Function Category | Accepts Relationships? | Parameter Type Expected | Use Instead |
|------------------|------------------------|-------------------------|-------------|
| **a!relatedRecordData()** | ✅ YES | Relationship | Only function designed for relationships |
| **a!isNullOrEmpty(), a!isNotNullOrEmpty()** | ✅ YES | Any type | Check existence of related records |
| **Array functions** (a!forEach, length, wherecontains, index, etc.) | ✅ YES (one-to-many only) | Array | Iterate/manipulate relationship arrays |
| **Navigation to fields** | ✅ YES | Relationship path | `relationships.relationshipName.fields.fieldName` |
| **user()** | ❌ NO | **User** or **Text** (field values) | Use `fields.fieldName` (User type), NOT relationships |
| **text(), concat()** | ❌ NO | Text/Number/Date (field values) | Use `fields.fieldName` or navigate to related field |
| **Arithmetic (+, -, *, /)** | ❌ NO | Number (field values) | Use `fields.fieldName` or navigate to related field |
| **Date functions (datetext, etc.)** | ❌ NO | Date/DateTime (field values) | Use `fields.fieldName` or navigate to related field |
| **Comparison (=, <, >, etc.)** | ❌ NO | Scalar values | Use `fields.fieldName` or navigate to related field |
| **All other functions** | ❌ NO | Check schema for expected type | Use `fields.fieldName` or navigate to related field |

**Quick decision tree:**

1. **Is it a!relatedRecordData()?** → ✅ Relationship OK
2. **Is it a null check (a!isNullOrEmpty/a!isNotNullOrEmpty)?** → ✅ Relationship OK
3. **Is it an array function (a!forEach, length, wherecontains) AND a one-to-many relationship?** → ✅ Relationship OK
4. **Are you navigating further with `.fields.fieldName`?** → ✅ Relationship OK (as path)
5. **Passing relationship directly to any other function?** → ❌ WRONG - use the field instead

**Remember:**
- Many-to-one/one-to-one relationships return **single record instances** → Cannot use with array functions
- One-to-many relationships return **arrays of records** → Can use with array functions (a!forEach, length, etc.)
- When in doubt: **navigate to the field** on the related record instead of passing the relationship directly

### ⚠️ CRITICAL: Displaying User Names

**The user() function extracts display properties from User data:**

```sail
/* ❌ WRONG - Passing relationship (returns record instance, not User scalar) */
user(fv!row['recordType!Case.relationships.assignedToUser'], "firstName")

/* ✅ CORRECT - Use the User FIELD */
user(fv!row['recordType!Case.fields.assignedTo'], "firstName")

/* ✅ ALSO CORRECT - user() also accepts Text username */
user("john.smith", "firstName")
```

**Valid user() properties:**
- `"firstName"` - User's first name
- `"lastName"` - User's last name
- `"email"` - User's email address
- `"username"` - User's username

**Complete pattern for displaying user names:**
```sail
/* Display full name from User field */
if(
  a!isNotNullOrEmpty(fv!row['recordType!Case.fields.assignedTo']),
  trim(
    user(fv!row['recordType!Case.fields.assignedTo'], "firstName") & " " &
    user(fv!row['recordType!Case.fields.assignedTo'], "lastName")
  ),
  "Unassigned"
)
```

**What user() accepts:**
- ✅ User field value: `user(userField, "firstName")`
- ✅ Text username: `user("john.smith", "firstName")`
- ❌ Relationship: `user(relationship, "firstName")` - **WRONG**

**Key Rule:**
Relationships return record instances, not User scalar values. Always use the User **FIELD**, not the relationship.

## Accessing Related Record Data in Forms

**When building forms, use a SINGLE rule input for the main record and access ALL related data through relationships.**

### ✅ CORRECT Pattern - Single Rule Input with Relationship Navigation

**Form interface signature:**
```sail
/* ✅ CORRECT - Single rule input for main record */
/* Rule Inputs:
 *   ri!case (Case) - The case record being edited
 */
```

**Accessing many-to-one relationships (parent/related records):**
```sail
/* Access customer name through Case → Customer relationship */
a!textField(
  label: "Customer Name",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.customerName'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.customerName']
)

/* Access customer email through same relationship */
a!textField(
  label: "Customer Email",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.email'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.email']
)

/* Access customer phone through same relationship */
a!textField(
  label: "Customer Phone",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.phone'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.phone']
)
```

**Accessing one-to-many relationships (child records):**
```sail
/* Display case comments through Case → Comment relationship */
a!forEach(
  items: ri!case['recordType!Case.relationships.caseComment'],
  expression: a!cardLayout(
    contents: {
      a!paragraphField(
        label: "Comment " & fv!index,
        value: fv!item['recordType!Comment.fields.description'],
        saveInto: fv!item['recordType!Comment.fields.description']
      )
    }
  )
)
```

### ❌ WRONG Pattern - Multiple Rule Inputs for Related Records

**DON'T DO THIS:**
```sail
/* ❌ WRONG - Separate rule inputs for related records */
/* Rule Inputs:
 *   ri!case (Case) - The case record
 *   ri!customer (Customer) - The related customer  /* DON'T DO THIS */
 */

/* ❌ WRONG - Accessing customer fields from separate rule input */
a!textField(
  label: "Customer Name",
  value: ri!customer['recordType!Customer.fields.customerName'],  /* WRONG */
  saveInto: ri!customer['recordType!Customer.fields.customerName']
)
```

### When to Use This Pattern:

| Relationship Type | Example | Use This Pattern |
|-------------------|---------|------------------|
| **Many-to-one (parent)** | Case → Customer | `ri!case['...relationships.refCustomer.fields.customerName']` |
| **Many-to-one (reference)** | Case → Status | `ri!case['...relationships.refCaseStatus.fields.statusName']` |
| **One-to-many (children)** | Case → Comments | `ri!case['...relationships.caseComment']` (see one-to-many section) |
| **One-to-one** | Case → Details | `ri!case['...relationships.caseDetails.fields.description']` |

### Why This Pattern Is Mandatory:

1. **Maintains data integrity**: Single rule input ensures all changes are coordinated
2. **Simpler interface signature**: Only one parameter instead of many
3. **Correct foreign key handling**: Appian manages the relationships automatically
4. **Easier to call**: Invoking interface only requires passing the main record
5. **Prevents orphaned data**: Related records stay properly linked to parent

### Pattern for Review Sections:

When displaying read-only data for review, use the same relationship navigation pattern:

```sail
/* ✅ CORRECT - Review section accessing multiple relationships */
a!sectionLayout(
  label: "Case Summary",
  contents: {
    a!columnsLayout(
      columns: {
        a!columnLayout(
          contents: {
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Customer: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refCustomer.fields.customerName']
                )
              }
            ),
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Status: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refCaseStatus.fields.statusName']
                )
              }
            )
          }
        ),
        a!columnLayout(
          contents: {
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Priority: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refPriority.fields.priorityName']
                )
              }
            ),
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Total Comments: ", style: "STRONG"),
                a!richTextItem(
                  text: length(ri!case['recordType!Case.relationships.caseComment'])
                )
              }
            )
          }
        )
      }
    )
  }
)
```

### Key Principle:
**One record type is the "owner" of the form → Make it the rule input → Access everything else through relationships**

## Date/Time Critical Rules {#datetime-critical-rules}

🚨 CRITICAL: Correct Date/Time Functions
```sail
/* ✅ CORRECT - Use dateTime() for specific date/time creation */
dateTime(year(today()), month(today()), 1, 0, 0, 0)  /* Month to Date */

/* ❌ WRONG - a!dateTimeValue() does NOT exist in Appian */
a!dateTimeValue(year: year(today()), month: month(today()), day: 1)
```

🚨 CRITICAL: Query Filter Data Type Matching

**The a!queryFilter function requires exact data type matching between field and value:**

```sail
/* ❌ WRONG - Date arithmetic with DateTime field */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  value: today() - 30  /* Date value - TYPE MISMATCH */
)

/* ✅ CORRECT - Use DateTime functions for DateTime fields */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  value: a!subtractDateTime(startDateTime: now(), days: 30)  /* DateTime value */
)

/* ✅ CORRECT - Date field with Date value */
a!queryFilter(
  field: recordType!Case.fields.dueDate,  /* Date field */
  value: today() - 30  /* Date value */
)
```

**Common Type Conversions:**
- **DateTime fields**: Use `a!subtractDateTime()`, `a!addDateTime()`, `now()`, `dateTime()`
- **Date fields**: Use `today()`, date arithmetic, `date()`
- **Number fields**: Use `tointeger()`, `todecimal()`
- **Text fields**: Use `totext()`

**⚠️ WORKFLOW: Before Writing Date/DateTime Filters:**
1. **Check data-model-context.md** for the actual field type
2. **Date field** → Use `today()`, `todate()`, date arithmetic (e.g., `today() - 30`)
3. **DateTime field** → Use `now()`, `dateTime()`, `a!subtractDateTime()`, `a!addDateTime()`

### Valid Operators by Data Type

The following operators are valid for each data type in `a!queryFilter`:

| Data Type | Valid Operators |
|-----------|----------------|
| **Text** | `=`, `<>`, `in`, `not in`, `starts with`, `not starts with`, `ends with`, `not ends with`, `includes`, `not includes`, `is null`, `not null`, `search` |
| **Integer, Float, Time** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Date, Date and Time** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Boolean** | `=`, `<>`, `in`, `not in`, `is null`, `not null` |

**Key Notes:**
- `"between"` operator requires **two values** in an array: `value: {startValue, endValue}`
- `"in"` and `"not in"` operators accept arrays of values
- Text operators (`starts with`, `ends with`, `includes`, `search`) work ONLY with Text fields
- Date/DateTime comparison operators (`>`, `>=`, `<`, `<=`) require proper type matching (see examples above)

**Examples:**

```sail
/* ✅ Using "between" with Date field */
a!queryFilter(
  field: recordType!Case.fields.dueDate,
  operator: "between",
  value: {today() - 30, today()}  /* Array of two dates */
)

/* ✅ Using "in" with Integer field */
a!queryFilter(
  field: recordType!Order.fields.statusId,
  operator: "in",
  value: {1, 2, 3}  /* Array of valid status IDs */
)

/* ✅ Using "starts with" with Text field */
a!queryFilter(
  field: recordType!Product.fields.productCode,
  operator: "starts with",
  value: "PROD-"
)

/* ❌ WRONG - "between" with single value */
a!queryFilter(
  field: recordType!Case.fields.dueDate,
  operator: "between",
  value: today()  /* ERROR: between requires array of 2 values */
)

/* ❌ WRONG - Text operator on Date field */
a!queryFilter(
  field: recordType!Case.fields.dueDate,
  operator: "starts with",  /* ERROR: Invalid for Date fields */
  value: "2024"
)
```

🚨 CRITICAL: min()/max() Return Type Casting

**The min() and max() functions return variant types that may need explicit casting for comparisons:**

```sail
/* ❌ WRONG - min() result used directly without type casting */
local!startDates: a!forEach(
  items: local!courses,
  expression: fv!item.startDate  /* Array of Date values */
),
local!earliestStart: min(local!startDates),  /* Returns variant */
local!isUrgent: local!earliestStart < today() + 30  /* May cause type error */

/* ✅ CORRECT - Cast min() result to proper type */
local!startDates: a!forEach(
  items: local!courses,
  expression: fv!item.startDate  /* Array of Date values */
),
local!earliestStart: todate(min(local!startDates)),  /* Explicit Date type */
local!isUrgent: local!earliestStart < today() + 30  /* Date comparison works */
```

**Rules:**
- **Date arrays**: Wrap with `todate(min(...))` or `todate(max(...))`
- **DateTime arrays**: Wrap with `todatetime(min(...))` or `todatetime(max(...))`
- **Number arrays**: Wrap with `tointeger(...)` or `todecimal(...)` if specific type needed
- **Always cast** when using the result in comparisons or calculations

Type Matching (Prevents Interface Failures)
```sail
/* ✅ Date field with Date value */
a!queryFilter(
  field: recordType!Case.fields.dueDate,  /* Date field */
  operator: ">=",
  value: today() - 30  /* Date arithmetic */
)

/* ✅ DateTime field with DateTime value */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  operator: ">=",
  value: a!subtractDateTime(startDateTime: now(), days: 30)
)

/* ❌ WRONG - Type mismatch causes failures */
a!queryFilter(
  field: recordType!Case.fields.dueDate,    /* Date field */
  value: a!subtractDateTime(...)            /* DateTime - FAILS */
)
```

Date Function Corrections
```sail
/* ❌ WRONG - addDateTime rejects negative values */
value: a!addDateTime(startDateTime: today(), days: -30)

/* ✅ CORRECT - Use subtractDateTime for past dates */
value: a!subtractDateTime(startDateTime: now(), days: 30)
```

🚨 CRITICAL: text() Function with Date/DateTime Values

**The text() function CANNOT accept null values. Always check for null before calling text():**

```sail
/* ❌ WRONG - Passing null to text() causes errors */
text(a!defaultValue(fv!row['recordType!Case.fields.createdOn'], null), "MMM d, yyyy")

/* ✅ CORRECT - Check for null BEFORE calling text() */
if(
  a!isNullOrEmpty(a!defaultValue(fv!row['recordType!Case.fields.createdOn'], null)),
  "–",
  text(fv!row['recordType!Case.fields.createdOn'], "MMM d, yyyy")
)

/* ✅ CORRECT - Alternative pattern with defaultValue as fallback string */
if(
  a!isNullOrEmpty(a!defaultValue(fv!row['recordType!Case.fields.dueDate'], null)),
  "No due date",
  text(fv!row['recordType!Case.fields.dueDate'], "MM/DD/YYYY")
)
```

**Rule**: When formatting dates with text(), ALWAYS wrap in a null check that returns a fallback string (like "–" or "N/A"), NOT null.

## Chart Data Configuration

Record Data Charts (Recommended)
```sail
a!barChartField(
  data: a!recordData(
    recordType: recordType!Employee,
    filters: {...}
  ),
  config: a!barChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Employee.fields.department,
      alias: "department_primaryGrouping"
    ),
    measures: {
      a!measure(
        label: "Count",
        function: "COUNT",
        field: recordType!Employee.fields.id,
        alias: "employeeCount_measure1"
      )
    }
  )
)
```

Mock Data Charts (Prototyping)
```sail
a!barChartField(
  categories: {"Sales", "Engineering"},
  series: {
    a!chartSeries(
      label: "Employees",
      data: {25, 45}
    )
  }
)
```

Chart Data Extraction Rules
**CRITICAL**: Charts are display-only components
- **Cannot extract data from chart components** - Only from queries
- **Use separate aggregation queries for KPIs** - Don't try to read chart data

## Chart Components Usage

**Available Chart Functions:**
1. `a!areaChartField()` - Filled areas under lines for trends and cumulative values
2. `a!barChartField()` - Horizontal bars for comparing categories
3. `a!columnChartField()` - Vertical bars for comparing values across categories
4. `a!lineChartField()` - Connected points for trends over time
5. `a!pieChartField()` - Pie slices for part-to-whole relationships
6. `a!scatterChartField()` - Points on X/Y axes for correlations (record data only)

**Parameters Shared by All Chart Types:**
- `label`, `labelPosition` (usually "COLLAPSED"), `instructions`
- `height` - Values vary by type:
  - Column/Line/Area/Bar: "MICRO", "SHORT", "MEDIUM", "TALL" (Bar also has "AUTO")
  - Pie/Scatter: "SHORT", "MEDIUM", "TALL"
- `showWhen`, `accessibilityText`
- `xAxisTitle`, `yAxisTitle` (not available for pie charts)
- `showLegend` (column, line, bar, area only - NOT pie)
- `showDataLabels`, `colorScheme`

🚨 CRITICAL: Stacking Property

**ONLY these chart types have a `stacking` property:**
- `a!areaChartField()`
- `a!barChartField()`
- `a!columnChartField()`

**The `stacking` property is on the CHART FIELD, NOT in the config:**
```sail
/* ✅ CORRECT - stacking on chart field */
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(...),
  stacking: "NORMAL"  /* On chart field level */
)

/* ❌ WRONG - stacking in config (parameter doesn't exist there) */
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(
    stacking: "NORMAL"  /* INVALID - not a config parameter */
  )
)
```

**Valid stacking values:** "NONE" (default), "NORMAL", "PERCENT_TO_TOTAL"

**Two Data Approaches for Charts:**

**Approach 1: Static Mockup Data** (categories + series)
- Use for: Column, Line, Bar, Area, Pie charts with hardcoded sample data
- Structure:
```sail
a!columnChartField(
  categories: {"Q1", "Q2", "Q3", "Q4"},
  series: {
    a!chartSeries(label: "Sales", data: {100, 120, 115, 140}, color: "#3B82F6")
  }
)
```

**Approach 2: Record Data** (data + config)
- Use for: ALL charts when connecting to live record data
- ⚠️ Scatter charts ONLY work with this approach
- Structure:
```sail
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(
    primaryGrouping: a!grouping(...),
    measures: {a!measure(...)}
  )
)
```

❌ **NEVER mix approaches:** Don't use `categories` + `series` with record data
❌ **NEVER use scatter charts with static mockup data** - they require record data

**Valid Parameters for Chart Config Functions:**
- `primaryGrouping` - a!grouping() for main data grouping
- `secondaryGrouping` - a!grouping() for multi-series charts
- `measures` - Array of a!measure() for aggregations
- `sort` - a!sortInfo() for ordering results
- `dataLimit` - Maximum number of data points
- `link` - Dynamic link for click actions
- `showIntervalsWithNoData` - Boolean for showing empty intervals

❌ **INVALID Parameters (Don't Use):**
- `stacking` - This is on the chart field, NOT in config
- `aggregations` - Use `measures` instead
- `aggregationFields` - Use `measures` instead

🚨 CRITICAL: Valid Interval Values for a!grouping()

**The `interval` parameter in a!grouping() can ONLY be used with Date/DateTime/Time fields.**

**Valid interval values:**
- "AUTO" (default), "YEAR"
- "MONTH_OF_YEAR", "MONTH_OF_YEAR_SHORT_TEXT", "MONTH_OF_YEAR_TEXT"
- "MONTH_TEXT", "MONTH_SHORT_TEXT", "MONTH_DATE"
- "DATE", "DATE_SHORT_TEXT", "DATE_TEXT"
- "DAY_OF_MONTH"
- "HOUR_OF_DAY", "HOUR"
- "MINUTE_OF_HOUR", "MINUTE"

```sail
/* ✅ CORRECT - Valid interval values */
a!grouping(
  field: recordType!Case.fields.createdOn,
  alias: "month_grouping",
  interval: "MONTH_SHORT_TEXT"  /* Valid - shows "Jan", "Feb", etc. */
)

a!grouping(
  field: recordType!Case.fields.modifiedOn,
  alias: "date_grouping",
  interval: "DATE_SHORT_TEXT"  /* Valid - shows short date format */
)

/* ❌ WRONG - Invalid interval values */
a!grouping(
  field: recordType!Case.fields.createdOn,
  alias: "month_grouping",
  interval: "MONTH"  /* INVALID - not in allowed list */
)

a!grouping(
  field: recordType!Case.fields.modifiedOn,
  alias: "week_grouping",
  interval: "WEEK"  /* INVALID - not in allowed list */
)
```

**Rule**: Only use interval values from the documented list above. For weekly groupings, use "DATE_SHORT_TEXT" or "DATE" instead.

**Complete Record Data Chart Example:**
```sail
a!columnChartField(
  labelPosition: "COLLAPSED",
  data: a!recordData(
    recordType: recordType!Case,
    filters: a!queryFilter(
      field: recordType!Case.fields.isActive,
      operator: "=",
      value: true
    )
  ),
  config: a!columnChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Case.relationships.status.fields.value,
      alias: "status_grouping"
    ),
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "case_count"
      )
    },
    dataLimit: 20
  ),
  xAxisTitle: "Status",
  yAxisTitle: "Number of Cases",
  showDataLabels: true,
  height: "MEDIUM"
)
```

## KPI and Performance Calculations
**Best Practice**: Use aggregation queries for KPIs - Leverage native `a!queryRecordType()` with `a!aggregationFields()` for better performance than manual filtering/calculations.

```sail
/* ✅ CORRECT - Aggregation query for KPI calculation */
local!caseStats: a!queryRecordType(
  recordType: recordType!Case,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: recordType!Case.fields.status,
        alias: "status_group"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "total_cases"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
).data,

/* ❌ WRONG - Manual filtering and calculations */
local!allCases: a!queryRecordType(...).data,
local!openCases: length(filter(rule: local!allCases.status = "Open", data: local!allCases))
```

## Record Actions

🚨 CRITICAL: Use a!recordActionField() for Standalone Actions
```sail
/* ✅ CORRECT - Standalone record actions */
a!recordActionField(
  actions: {
    a!recordActionItem(
      action: recordType!Case.actions.newCase
    )
  },
  style: "TOOLBAR_PRIMARY"
)

/* ❌ WRONG - Don't use button widgets for record actions */
a!buttonWidget(
  saveInto: a!recordActionItem(...)  /* Invalid pattern */
)

/* ❌ WRONG - Don't use a!startProcess for record actions */
a!buttonWidget(
  saveInto: a!startProcess(processModel: ...)  /* Use recordActionField instead */
)
```

a!recordActionItem() Function
```sail
/* Grid record actions */
recordActions: {
  a!recordActionItem(
    action: recordType!Case.actions.updateCase,
    identifier: fv!identifier
  )
}

/* Standalone record action */
a!recordActionField(
  actions: {
    a!recordActionItem(
      action: recordType!Case.actions.newCase
    )
  },
  style: "TOOLBAR_PRIMARY"
)
```

Record Action Implementation Rules
- **For standalone record actions**: Always use `a!recordActionField()` with `a!recordActionItem()`
- **For grid record actions**: Use `recordActions` parameter with `a!recordActionItem()`
- **Never use `a!startProcess()`** when record actions are available
- **Never use button widgets** to trigger record actions

## Create/Update Scenarios

Critical Null Checking
```sail
/* ✅ CORRECT - Direct field references */
a!defaultValue(ri!employee[recordType!Employee.fields.firstName], "N/A")

/* ❌ WRONG - Function results (will fail) */
a!defaultValue(user(local!id, "firstName"), "Unknown")

/* ✅ CORRECT alternative */
if(
  a!isNotNullOrEmpty(local!userId),
  user(local!userId, "firstName"),
  "Unknown"
)
```

Record Instance Creation
```sail
'recordType!Case'(
  'recordType!Case.fields.title': "New Case",
  'recordType!Case.fields.priority': 1
)
```

Form Field with Record Data
```sail
a!textField(
  value: ri!order[recordType!Order.fields.description],
  saveInto: ri!order[recordType!Order.fields.description],
  validations: if(
    a!isNullOrEmpty(ri!order[recordType!Order.fields.description]),
    "Description is required",
    null
  )
)
```

## Essential Functions Reference

⚠️ **CRITICAL: Verify ALL functions exist in `/validation/sail-api-schema.json` before use**

Common functions that DO NOT exist:
- `a!isPageLoad()` - Use pattern: `local!showValidation: false()` + set to `true()` on button click
- `property()` - Use dot notation instead: `object.field`

Preferred Functions
- **Null Checking**: `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()` over `isnull()`
- **Logical**: `and()`, `or()`, `not()` over infix operators
- **Looping**: `a!forEach()` over `map()`
- **Matching**: `a!match()` over `choose()`
- **Array Operations**: `append()`, `a!update()` for immutable operations
- **Audit Functions**: `loggedInUser()`, `now()` for audit fields

### Quick Function Reference by Category

| Category | Functions |
|----------|-----------|
| Array | `a!flatten()`, `append()`, `index()`, `length()`, `where()`, `wherecontains()` |
| Logical | `and()`, `or()`, `not()`, `if()`, `a!match()` |
| Null Checking | `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()`, `a!defaultValue()` |
| Looping | `a!forEach()`, `filter()`, `reduce()`, `merge()` |
| Text | `concat()`, `find()`, `left()`, `len()`, `substitute()`, `upper()`, `lower()` |
| Date/Time | `today()`, `now()`, `dateTime()`, `a!addDateTime()`, `a!subtractDateTime()` |
| JSON | `a!toJson()`, `a!fromJson()`, `a!jsonPath()` |
| User/System | `loggedInUser()`, `user()` |
| Query | `a!queryRecordType()`, `a!recordData()`, `a!queryFilter()`, `a!pagingInfo()`, `a!aggregationFields()` |

### JSON Functions Usage

```sail
/* Convert to JSON */
a!toJson(
  value: a!map(name: "John", age: 30),
  removeNullOrEmptyFields: true
)

/* Parse from JSON */
a!fromJson('{"name":"John","age":30}')

/* Extract with JSONPath */
a!jsonPath(json: local!data, expression: "$.employees[0].name")
```

### contains() Usage

```sail
/* Arrays */
contains({"id", "title"}, "title")  /* Returns true */

/* Record arrays */
contains(
  local!records[recordType!Employee.fields.firstName],
  "Alice"
)
```

## 🔧 Quick Troubleshooting

If your interface fails to load, check:
1. **Syntax basics** - All parentheses/brackets matched, variables declared at top
2. **Data patterns** - a!recordData() only in grids/charts (see Data Querying Patterns - CRITICAL USAGE RULES)
3. **Null handling** - All rule inputs protected (see MANDATORY: Null Safety Implementation)
4. **Relationships** - Single continuous path, no double brackets (see Relationship Navigation Syntax)

## Common Critical Errors

These errors cause immediate interface failures and violate core SAIL patterns:

### Error 1:
**Error 1: Initialized Dropdown Variables with Record Data**
- **Problem**: `local!filter: "All"` when choiceValues come from records
- **Solution**: `local!filter,` (uninitialized) + `placeholder: "All"`

### Error 2:
**Error 2: Query Results in Grid/Chart Data**
- **Problem**: `data: local!queryResults`
- **Solution**: `data: a!recordData(...)`

### Error 3:
**Error 3: Data Type Mismatches in Query Filters**
- **Problem**: DateTime field + Date value
- **Solution**: Use matching data type functions

### Error 4:
**Error 4: Invalid Chart Patterns**
- **Problem 1**: `categories: {...}, series: {...}` with record data
- **Solution 1**: `data: a!recordData(...), config: a!columnChartConfig(...)`
- **Problem 2**: `interval: "MONTH"` or `interval: "WEEK"` in a!grouping()
- **Solution 2**: Use valid intervals: "MONTH_SHORT_TEXT", "DATE_SHORT_TEXT", etc.
- **Problem 3**: `stacking: "NORMAL"` in chart config
- **Solution 3**: Place `stacking` on chart field, not in config

### Error 5:
**Error 5: Non-existent Functions**
- **Problem**: Using `a!decimalField()`, `a!dateTimeValue()`
- **Solution**: Use `a!floatingPointField()`, `dateTime()` respectively

### Error 6:
**Error 6: Invalid Parameters on Components**
- **Problem**: `validations` parameter on `a!wizardLayout()`
- **Solution**: Place validations on `a!buttonWidget()` or field components

### Error 7:
**Error 7: Python/JavaScript Syntax in SAIL**
- **Problem**: `condition ? trueValue : falseValue`
- **Solution**: `if(condition, trueValue, falseValue)`

### Error 8:
**Error 8: Passing Null to Functions That Reject It**
- **Problem**: `text(a!defaultValue(dateField, null), "format")` or `user(a!defaultValue(userId, null), "firstName")`
- **Solution**: Check for null with if() BEFORE calling these functions
```sail
if(a!isNotNullOrEmpty(a!defaultValue(field, null)), text(field, "format"), "–")
```

### Error 9:
**Error 9: Using .totalCount for KPI Metrics**
- **Problem**: `local!caseCount: a!queryRecordType(..., fetchTotalCount: true).totalCount`
- **Solution**: Use aggregations for ALL KPIs with correct data extraction pattern
```sail
local!caseCountQuery: a!queryRecordType(
  fields: a!aggregationFields(
    groupings: {},  /* No groupings = single row result */
    measures: {a!measure(function: "COUNT", field: 'recordType!Case.fields.id', alias: "count")}
  )
),
/* For aggregations with NO groupings, use direct property access */
local!caseCount: a!defaultValue(
  local!caseCountQuery.data.count,  /* Direct access, not index() */
  0
)
```

### Error 10:
**Error 10: Incorrect Array and Data Manipulation Functions**
- **Problem 1**: Using `append(map, array)` - append only works with arrays of compatible types
- **Solution 1**: Use `a!update(data: array, index: 1, value: map)` to insert at beginning
- **Problem 2**: Using `wherecontains()` incorrectly
- **Solution 2**: See "Array Manipulation Patterns" section (mock data guidelines)
- **Problem 3**: Using `append()` to add single item to beginning of array
- **Solution 3**: Use `a!update()` or `insert()` for positional insertion
```sail
/* ❌ WRONG - append() expects compatible types */
local!combined: append(local!singleMap, local!arrayOfMaps)  /* ERROR */

/* ✅ RIGHT - Use a!update() to insert at position */
local!combined: a!update(data: local!arrayOfMaps, index: 1, value: local!singleMap)
```

### Error 11:
**Error 11: Incorrect Query Data Extraction Pattern**
- **Problem 1**: Using array indexing on aggregations with no groupings
- **Solution 1**: Use direct property access for aggregations with `groupings: {}`
```sail
/* ❌ WRONG - Over-complicated for aggregations with no groupings */
local!kpiQuery: a!queryRecordType(
  fields: a!aggregationFields(groupings: {}, measures: {a!measure(...)})
),
local!value: index(index(local!kpiQuery.data, 1, {}).alias, 1, null)

/* ✅ RIGHT - Direct property access */
local!value: a!defaultValue(local!kpiQuery.data.alias, 0)
```

- **Problem 2**: Missing array indexing on regular field queries
- **Solution 2**: Use `[1]` to access first row of regular query results
```sail
/* ❌ WRONG - Missing array index for regular query */
local!userQuery: a!queryRecordType(
  fields: {'recordType!User.fields.name'}
).data,
local!name: local!userQuery['recordType!User.fields.name']  /* ERROR - Query returns array */

/* ✅ RIGHT - Index into first row */
local!name: a!defaultValue(
  local!userQuery[1]['recordType!User.fields.name'],
  ""
)
```

**Key Rule**:
- Aggregations with `groupings: {}` → Direct access: `query.data.alias`
- Regular queries with `fields: {...}` → Array indexing: `query[1]['field']`

### Error 12:
**Error 12: Using Text Property Names on Record Instances**

**Symptoms:** Empty choices, blank displays, "property not found" errors

**Cause:** Using `"textPropertyName"` on field query results (record instances)

**Incorrect Code:**
```sail
local!positions: a!queryRecordType(
  fields: {
    'recordType!Position.fields.name',
    'recordType!Position.fields.id'
  }
).data,

/* ❌ WRONG - Text property names don't work on record instances */
choiceLabels: index(local!positions, "name", {}),
choiceValues: index(local!positions, "id", {}),
a!forEach(
  items: local!positions,
  expression: fv!item.name  /* Also fails */
)
```

**Correct Code:**
```sail
/* ✅ RIGHT - Use full record field references */
choiceLabels: index(local!positions, 'recordType!Position.fields.name', {}),
choiceValues: index(local!positions, 'recordType!Position.fields.id', {}),
a!forEach(
  items: local!positions,
  expression: fv!item['recordType!Position.fields.name']
)
```

**Decision Rule:**
- If query uses `fields: {...}` → Use record field references everywhere
- If query uses `a!aggregationFields()` → Use text alias from query
- See "Query Result Data Structures" section for complete patterns

## Syntax Validation Checklist

Before finalizing any SAIL interface, verify these critical items:

### Foundation & Structure
- [ ] **Expression starts with `a!localVariables()`** (see MANDATORY FOUNDATION RULES)
- [ ] **a!recordData() ONLY in grids/charts** (see Data Querying Patterns - CRITICAL USAGE RULES)
- [ ] **Form data uses ri! pattern correctly** (see CRITICAL: Form Interface Data Patterns)
- [ ] **NO local variable copies of ri! values** - ri! referenced directly throughout interface
- [ ] **ALL testing simulation variables removed** - No `local!ri_*` variables in production code
- [ ] **NO `sorts:` parameter in a!queryRecordType()** - Use `sort:` inside `pagingInfo` instead
- [ ] **All functions verified in schema** - No a!isPageLoad(), property(), or assumed functions

### Null Safety & Short-Circuit Evaluation
- [ ] **All null checks implemented** (see MANDATORY: Null Safety Implementation)
- [ ] **Computed variables protected with nested `if()`** - NOT `and()` (see Short-Circuit Evaluation Rules)
- [ ] **Property access on arrays uses nested `if()`** when array could be empty
- [ ] **No `and()` used for null-safe property access** - Use nested `if()` instead

### Function Validation
- [ ] **Function parameters match documented signatures** (see CRITICAL: Function Parameter Validation)
- [ ] **All functions exist in Appian** (see Available Appian Functions)
- [ ] **Short-circuit evaluation rules followed** (see Short-Circuit Evaluation Rules)
  - Use nested `if()` for null-safe property access
  - Use `and()`/`or()` only for independent conditions

### Component Patterns
- [ ] **Relationship navigation follows single-path pattern** (see Relationship Navigation Syntax)
- [ ] **Record actions use a!recordActionField()** (see Record Actions)

### Access Control
- [ ] **Group-based access uses Group type (not Text) with integer mock IDs and TODO notes** (see Group-Based Access Control Pattern)

Each item above links to its authoritative section for complete rules and examples.
