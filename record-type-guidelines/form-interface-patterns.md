# Form Interface Data Patterns {#form-interface-patterns}

> **Parent guide:** `record-type-handling-guidelines.md`
>
> **Related:**
> - `record-type-guidelines/one-to-many-management.md` (relationship management)
> - `sail-guidelines/null-safety-quick-ref.md` (null checking)

---

## Decision Tree

**BEFORE writing ANY form/wizard interface, determine the data pattern:**

```
Will users CREATE records? → Use ri! (Rule Input) pattern
Will users UPDATE records? → Use ri! (Rule Input) pattern
Is this ONLY displaying data? → Use query/a!recordData pattern
Is this a static mockup? → Use local variables with hardcoded data
```

---

## 🔴 MOST CRITICAL RULE

**Forms that CREATE or UPDATE records MUST use rule inputs (ri!), NOT queries or local variables for the main record data.**

---

## User Request Keywords That Indicate Rule Input Pattern

- "form to create/submit/add a [record]"
- "interface to update/edit a [record]"
- "wizard for creating/submitting"
- "application submission"
- "registration form"
- "edit page for [record]"
- "interface used to create or update"

---

## ✅ CORRECT: Rule Input Pattern (for Create/Update Forms) {#rule-input-pattern}

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

---

## 🚨 Testing Simulation Variables - FOR MANUAL DEVELOPMENT ONLY

⚠️ **IMPORTANT: This pattern is for manual development in Appian Designer, NOT for code generation.**

**When to use this pattern:**
- ✅ You are manually writing/testing an interface in Appian Designer
- ✅ You want to test the interface standalone (without a process model)
- ✅ You will find-replace `local!ri_` → `ri!` before production deployment

**When NOT to use this pattern:**
- ❌ You are generating code programmatically
- ❌ You are using the sail-dynamic-converter agent
- ❌ You want production-ready code immediately

**For Code Generation**: Use the direct `ri!` pattern shown above. Skip the testing simulation entirely.

---

**Pattern for Development/Testing:**
```sail
a!localVariables(
  /* ============================================
   * TESTING SIMULATION - REMOVE FOR PRODUCTION
   * These simulate rule inputs for standalone testing
   * ============================================ */
  local!ri_submission: 'recordType!{uuid}Submission'(),  /* DELETE IN PRODUCTION */
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
        value: local!ri_submission['recordType!{uuid}Submission.fields.{uuid}title'],
        saveInto: local!ri_submission['recordType!{uuid}Submission.fields.{uuid}title']
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
        value: ri!submission['recordType!{uuid}Submission.fields.{uuid}title'],
        saveInto: ri!submission['recordType!{uuid}Submission.fields.{uuid}title']
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

---

## ❌ WRONG: Query Pattern (for Create/Update Forms)

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

---

## ✅ CORRECT: Query Pattern (for Read-Only Displays)

**When to use**: Displaying data without editing, dashboards, reports, read-only grids

```sail
a!localVariables(
  local!recordData: a!queryRecordType(
    recordType: 'recordType!{uuid}Type',
    filters: a!queryFilter(...)
  ),

  /* Display in read-only grid: */
  a!gridField(
    data: a!recordData(
      recordType: 'recordType!{uuid}Type',
      filters: a!queryFilter(...)
    ),
    columns: {
      a!gridColumn(
        label: "Name",
        value: fv!row['recordType!{uuid}Type.fields.{uuid}name']
      )
    }
  )
)
```

---

## Common Mistakes to Avoid

1. **Using queries for the main record in create/update forms**
   - ❌ Wrong: `local!applicant: a!queryRecordType(...)` in a submission form
   - ✅ Right: `ri!applicant` as rule input

2. **Saving form inputs to local variables instead of rule inputs**
   - ❌ Wrong: `saveInto: local!firstName` when creating/updating a record
   - ✅ Right: `saveInto: ri!recordName['recordType!{uuid}Type.fields.{uuid}firstName']`

3. **Mixing patterns inappropriately**
   - ❌ Wrong: Using ri! for reference data that shouldn't be edited
   - ✅ Right: Use ri! for main record, queries for reference/lookup data
   - ✅ Alternative: Use local variables with hardcoded lists for missing reference tables

4. **Using a!map() or {} for record instances**
   - ❌ Wrong: Using `a!map()` or empty `{}` to create record instances
   - ✅ Right: See "Creating New Record Instances" section in parent guide

5. **Detecting record type by null field check**
   - ❌ Wrong: Using `a!isNotNullOrEmpty()` on specific fields to infer record type
   - ✅ Right: Use dedicated type ID field
   - **Why:** Fields can be null for multiple reasons (not entered yet, optional, cleared). Use explicit type indicators instead.

---

## MANDATORY CHECKLIST Before Coding Form Interfaces

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
