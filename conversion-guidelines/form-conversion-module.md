# Form Conversion Module {#form-module}

Patterns for converting CREATE/UPDATE form interfaces that use rule inputs (ri!) to bind form data.

---

## 📑 Module Navigation {#form.nav}

- `{#form.detection}` - How to identify form interfaces
- `{#form.ri-pattern}` - Rule input pattern overview
- `{#form.ri-pattern.comment-format}` - Structured comment format
- `{#form.ri-pattern.variable-mapping}` - Mapping mockup variables to ri!
- `{#form.audit-fields}` - Managing audit fields
- `{#form.wizard-handling}` - Multi-step wizard patterns
- `{#form.action-buttons}` - Form submission buttons

---

## Interface Detection {#form.detection}

### Form Interface Indicators

A mockup is a **Form Interface** if it contains:

| Indicator | Example |
|-----------|---------|
| Submission buttons | "Submit", "Save", "Create", "Update" |
| Create/Update intent | "New Case Form", "Edit Employee" |
| Wizard layout | `a!wizardLayout()` with step progression |
| Form layout with buttons | `a!formLayout()` with primary/secondary buttons |
| Editable fields with submit | textFields with corresponding save action |

### Decision Tree

```
Does interface have submission buttons?
├─ YES → Continue checking
│   └─ Does it create/update a record?
│       ├─ YES → Use FORM CONVERSION MODULE (ri! pattern)
│       └─ NO (just triggers process) → May use query pattern + a!startProcess()
│
└─ NO → Use DISPLAY CONVERSION MODULE
```

### NOT a Form Interface

These are **NOT** form interfaces (use display module instead):
- Filter dropdowns that filter a grid
- Search inputs that query data
- Read-only detail views (even if they have action buttons that launch separate forms)
- Dashboards with navigation controls

---

## Rule Input Pattern {#form.ri-pattern}

### Purpose

Form interfaces receive their data as **rule inputs (ri!)** from the calling context (process model, record action, related action). This allows forms to create or update record data.

### Pattern Overview

```sail
/* ==========================================================================
 * RULE INPUTS (ri!) - Configure in Interface Definition
 * ==========================================================================
 * Name: ri!case
 * Type: Case
 * Description: The case record being created or updated. Pass null for create mode.
 * ----------
 * Name: ri!isUpdate
 * Type: Boolean
 * Description: Flag indicating if form is in update mode (true) or create mode (false).
 * ----------
 * Name: ri!cancel
 * Type: Boolean
 * Description: Flag set to true when user cancels the form. Allows process model
 *              to take a different path based on cancellation vs submission.
 * ==========================================================================
 */
a!localVariables(
  /* Form uses ri! directly - no local copies */
  a!formLayout(
    contents: {
      a!textField(
        label: "Subject",
        value: ri!case['recordType!Case.fields.subject'],
        saveInto: ri!case['recordType!Case.fields.subject'],
        required: true
      )
    },
    buttons: a!buttonLayout(
      primaryButtons: {
        a!buttonWidget(
          label: if(ri!isUpdate, "Update", "Create"),
          submit: true,
          style: "SOLID",
          color: "ACCENT"
        )
      }
    )
  )
)
```

### Key Principles

1. **Form fields bind directly to ri!** - No local variable copies
2. **ri! is a parameter, not a variable** - Cannot initialize inside the interface
3. **Always null-check ri! before use** - Use `a!defaultValue()` or `if(a!isNotNullOrEmpty())`
4. **Document ri! in header comment** - Not in code

---

## Comment Format {#form.ri-pattern.comment-format}

### Structured Rule Input Documentation

Every form interface MUST have a header comment documenting all rule inputs:

```sail
/* ==========================================================================
 * RULE INPUTS (ri!) - Configure in Interface Definition
 * ==========================================================================
 * Name: ri!submission
 * Type: BoardCommitteeSubmission
 * Description: The submission record being created or updated. When creating a
 *              new submission, the calling process should pass a new record instance
 *              with partnerUsername pre-populated.
 * ----------
 * Name: ri!isUpdate
 * Type: Boolean
 * Description: Flag indicating if the form is in update mode. When true, form
 *              displays existing data for editing. When false, form is for new
 *              submission creation.
 * ----------
 * Name: ri!cancel
 * Type: Boolean
 * Description: Flag set to true when user cancels the form. Allows process model
 *              to take a different path based on cancellation vs submission.
 * ----------
 * Name: ri!allowEdit
 * Type: Boolean
 * Description: Flag indicating if the current user has permission to edit this
 *              submission. Used to control field editability and button visibility.
 * ==========================================================================
 */
```

### Format Requirements

| Element | Requirement |
|---------|-------------|
| Header | `RULE INPUTS (ri!) - Configure in Interface Definition` |
| Separator | `==========` line above and below |
| Between inputs | `----------` separator |
| Name | `Name: ri!variableName` |
| Type | `Type: RecordTypeName` or `Type: Boolean/Text/Integer` |
| Description | Multi-line explanation of purpose, usage, and any mode-specific behavior |

### Description Guidelines

Good descriptions answer:
- What data does this input contain?
- Who/what provides this value?
- How does the form use this input?
- Are there mode-specific behaviors?

```sail
/* ❌ BAD - Just restates the type */
* Description: The case record.

/* ✅ GOOD - Explains purpose and usage */
* Description: The case record being created or updated. When creating a new case,
*              the calling process should pass a new record instance with caseNumber
*              pre-populated from the sequence generator.
```

---

## Variable Mapping {#form.ri-pattern.variable-mapping}

### Converting Mockup Variables to ri!

| Mockup Variable | ri! Name | Record Type Example |
|----------------|----------|---------------------|
| `local!case` | `ri!case` | Case |
| `local!customer` | `ri!customer` | Customer |
| `local!order` | `ri!order` | Order |
| `local!employee` | `ri!employee` | Employee |
| `local!submission` | `ri!submission` | BoardCommitteeSubmission |
| `local!invoice` | `ri!invoice` | Invoice |
| `local!ticket` | `ri!ticket` | SupportTicket |
| `local!project` | `ri!project` | Project |
| `local!task` | `ri!task` | Task |
| `local!document` | `ri!document` | Document |

**Pattern:** Convert `local!{recordName}` → `ri!{recordName}` where {recordName} matches the primary record being created/updated.

### What to Convert vs Keep Local

| Variable Type | Action |
|--------------|--------|
| Primary record data (`local!case`) | Convert to `ri!case` |
| Mode flags (`local!isUpdate`) | Convert to `ri!isUpdate` |
| Permission flags (`local!canEdit`) | Convert to `ri!allowEdit` |
| UI state (`local!showDetails`) | KEEP as local! |
| Computed values (`local!totalAmount`) | KEEP as local! |
| Query results (`local!statusOptions`) | KEEP as local! |
| Temporary selections (`local!selectedIds`) | KEEP as local! |

### Field Binding Conversion

```sail
/* ❌ MOCKUP - Uses local variables */
local!organizationName,
a!textField(
  label: "Organization Name",
  value: local!organizationName,
  saveInto: local!organizationName
)

/* ✅ FUNCTIONAL - Uses ri! with record type field */
a!textField(
  label: "Organization Name",
  value: ri!submission['recordType!Submission.fields.organizationName'],
  saveInto: ri!submission['recordType!Submission.fields.organizationName']
)
```

---

## Audit Fields Management {#form.audit-fields}

### Purpose

Record types typically have audit fields that track creation and modification metadata. These must be set appropriately during save.

### Common Audit Fields

| Field | Type | Set On |
|-------|------|--------|
| `createdBy` | User | CREATE only |
| `createdOn` | DateTime | CREATE only |
| `modifiedBy` | User | CREATE and UPDATE |
| `modifiedOn` | DateTime | CREATE and UPDATE |

**Note:** Setting modifiedBy/modifiedOn on creation ensures these fields are never null, simplifying reporting and audit queries.

### Create Mode {#form.audit-fields.create-mode}

Set ALL audit fields when form creates a new record:

```sail
a!buttonWidget(
  label: "Submit",
  submit: true,
  style: "SOLID",
  color: "ACCENT",
  saveInto: {
    /* Set ALL audit fields on creation */
    a!save(ri!submission['recordType!Submission.fields.createdBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.createdOn'], now()),
    a!save(ri!submission['recordType!Submission.fields.modifiedBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.modifiedOn'], now())
  },
  showWhen: not(ri!isUpdate)
)
```

### Update Mode {#form.audit-fields.update-mode}

Set only modification audit fields when form updates existing record:

```sail
a!buttonWidget(
  label: "Save Changes",
  submit: true,
  style: "SOLID",
  color: "ACCENT",
  saveInto: {
    /* Only set modification audit fields on update */
    a!save(ri!submission['recordType!Submission.fields.modifiedBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.modifiedOn'], now())
  },
  showWhen: ri!isUpdate
)
```

**Rationale for two separate buttons:**
- Clearer code, easier to maintain
- Different labels for each mode ("Submit" vs "Save Changes")
- No conditional logic inside saveInto
- showWhen ensures only one button is visible at a time

---

## Wizard Handling {#form.wizard-handling}

### Wizard Layout Structure

Multi-step forms use `a!wizardLayout()` with step navigation:

```sail
a!localVariables(
  local!currentStep: 1,

  a!wizardLayout(
    steps: {
      a!wizardStep(label: "Basic Information"),
      a!wizardStep(label: "Contact Details"),
      a!wizardStep(label: "Review & Submit")
    },
    currentStep: local!currentStep,
    contents: {
      /* Step 1: Basic Information */
      showWhen(local!currentStep = 1,
        a!cardLayout(
          contents: { /* Step 1 fields */ }
        )
      ),
      /* Step 2: Contact Details */
      showWhen(local!currentStep = 2,
        a!cardLayout(
          contents: { /* Step 2 fields */ }
        )
      ),
      /* Step 3: Review & Submit */
      showWhen(local!currentStep = 3,
        a!cardLayout(
          contents: { /* Review section */ }
        )
      )
    },
    buttons: a!buttonLayout(
      secondaryButtons: {
        a!buttonWidget(
          label: "Back",
          saveInto: a!save(local!currentStep, local!currentStep - 1),
          showWhen: local!currentStep > 1
        )
      },
      primaryButtons: {
        a!buttonWidget(
          label: "Next",
          saveInto: a!save(local!currentStep, local!currentStep + 1),
          showWhen: local!currentStep < 3
        ),
        a!buttonWidget(
          label: "Submit",
          submit: true,
          style: "SOLID",
          color: "ACCENT",
          showWhen: local!currentStep = 3
        )
      }
    )
  )
)
```

### Wizard Conversion Considerations

| Mockup Element | Conversion Action |
|----------------|-------------------|
| Step content with local! | Convert field bindings to ri! |
| Step count | Keep same structure |
| Navigation buttons | Keep local!currentStep for UI state |
| Submit button | Add audit field saves, bind to ri! |
| Step validations | Convert to use ri! field paths |

---

## Form Action Buttons {#form.action-buttons}

### Create Button Pattern {#form.action-buttons.create}

Use for new record creation (when `ri!isUpdate` is false):

```sail
a!buttonWidget(
  label: "Submit",
  submit: true,
  style: "SOLID",
  color: "ACCENT",
  validate: true,
  saveInto: {
    /* Set ALL audit fields on creation */
    a!save(ri!submission['recordType!Submission.fields.createdBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.createdOn'], now()),
    a!save(ri!submission['recordType!Submission.fields.modifiedBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.modifiedOn'], now())
  },
  showWhen: not(ri!isUpdate)
)
```

### Update Button Pattern {#form.action-buttons.update}

Use for existing record updates (when `ri!isUpdate` is true):

```sail
a!buttonWidget(
  label: "Save Changes",
  submit: true,
  style: "SOLID",
  color: "ACCENT",
  validate: true,
  saveInto: {
    /* Only set modification audit fields on update */
    a!save(ri!submission['recordType!Submission.fields.modifiedBy'], loggedInUser()),
    a!save(ri!submission['recordType!Submission.fields.modifiedOn'], now())
  },
  showWhen: ri!isUpdate
)
```

**Key Differences:**

| Aspect | Create Button | Update Button |
|--------|---------------|---------------|
| Label | "Submit" | "Save Changes" |
| Audit Fields | All 4 (createdBy, createdOn, modifiedBy, modifiedOn) | Only 2 (modifiedBy, modifiedOn) |
| showWhen | `not(ri!isUpdate)` | `ri!isUpdate` |

**Rationale:**
- **Create mode sets all 4 fields**: Ensures modifiedBy/modifiedOn are never null on new records, simplifying reporting and audit queries
- **Update mode only sets 2 fields**: Preserves original creation metadata while tracking the latest modification

### Cancel Button Pattern

```sail
a!buttonWidget(
  label: "Cancel",
  style: "OUTLINE",
  color: "SECONDARY",
  submit: true,           /* Submits form to return control to process model */
  validate: false,        /* Skip validation on cancel */
  saveInto: {
    a!save(ri!cancel, true)  /* Signal cancellation to process model */
  }
)
```

**Why `submit: true` instead of `cancel: true`?**
- Using `cancel: true` discards all form data and does not pass values back to the process model
- Using `submit: true` with `ri!cancel: true` allows the process model to receive the cancellation signal and take a different path (e.g., skip record creation, show confirmation, etc.)

### Save Draft Pattern

```sail
a!buttonWidget(
  label: "Save Draft",
  style: "OUTLINE",
  color: "ACCENT",
  validate: false,        /* Don't validate - allow incomplete data */
  saveInto: {
    a!save(ri!submission['recordType!Submission.fields.status'], "Draft")
  }
)
```

### Form vs Display Action Buttons

| Button Purpose | In Form Module? | In Display Module? |
|----------------|-----------------|-------------------|
| Submit/Create form | ✅ Yes | ❌ No |
| Save/Update record | ✅ Yes | ❌ No |
| Cancel form | ✅ Yes | ❌ No |
| Navigate to another record | ❌ No | ✅ Yes |
| Launch create form (from list) | ❌ No | ✅ Yes |
| Launch edit form (from grid) | ❌ No | ✅ Yes |

---

## Common Form Conversion Mistakes {#form.mistakes}

### Mistake 1: Copying ri! to local variables

```sail
/* ❌ WRONG - Creates disconnected copy */
local!caseCopy: ri!case,
a!textField(
  value: local!caseCopy['recordType!Case.fields.title'],
  saveInto: local!caseCopy['recordType!Case.fields.title']
)
/* Saves only update local!caseCopy, not ri!case */

/* ✅ CORRECT - Direct ri! binding */
a!textField(
  value: ri!case['recordType!Case.fields.title'],
  saveInto: ri!case['recordType!Case.fields.title']
)
```

### Mistake 2: Initializing ri! inside interface

```sail
/* ❌ WRONG - Cannot initialize parameters */
ri!isUpdate: false(),

/* ✅ CORRECT - Document in comments only */
/* ri!isUpdate (Boolean) - passed from calling context */
```

### Mistake 3: Missing null checks on ri!

```sail
/* ❌ WRONG - Will crash if ri!case is null */
value: ri!case['recordType!Case.fields.title']

/* ✅ CORRECT - Safe for null ri! */
value: a!defaultValue(
  ri!case['recordType!Case.fields.title'],
  ""
)
```

### Mistake 4: Using a!map() for form data

```sail
/* ❌ WRONG - a!map() cannot save to records */
local!newCase: a!map(title: "New Case", status: "Open")

/* ✅ CORRECT - Use record type constructor */
/* The calling process should pass: */
ri!case: 'recordType!Case'(
  title: "",
  status: "Open"
)
```

---

## Form Conversion Checklist {#form.checklist}

Before completing form conversion:

- [ ] Header comment documents ALL rule inputs with Name/Type/Description (including ri!cancel)
- [ ] All form field bindings use `ri!record[field]` NOT local variables
- [ ] Create button sets ALL 4 audit fields (createdBy, createdOn, modifiedBy, modifiedOn)
- [ ] Update button sets only modifiedBy and modifiedOn
- [ ] Create button has `showWhen: not(ri!isUpdate)`
- [ ] Update button has `showWhen: ri!isUpdate`
- [ ] Both submit buttons have `submit: true` and `validate: true`
- [ ] Cancel button uses `submit: true` with `saveInto: a!save(ri!cancel, true)`
- [ ] Mode-specific logic uses `ri!isUpdate` flag
- [ ] No `local!` copies of `ri!` variables
- [ ] All `ri!` access has null safety where needed
- [ ] Wizard step count matches mockup
- [ ] All required field validations preserved
