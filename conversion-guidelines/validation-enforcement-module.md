# Validation Enforcement Module {#validation-module}

Post-conversion validation and cleanup steps. **Always executed** regardless of interface type. These steps ensure code quality before output.

---

## 📑 Module Navigation {#validation.nav}

- `{#validation.unused-variables}` - Detect and remove/document unused variables
- `{#validation.null-safety}` - Enforce null safety patterns
- `{#validation.type-matching}` - Verify query filter type compatibility
- `{#validation.pre-flight-checklist}` - Final validation before output

---

## Unused Variable Detection {#validation.unused-variables}

### Purpose

Mockups often have unused variables that should not carry forward to functional interfaces. Unused variables cause confusion, trigger Appian Designer warnings, and violate best practices.

### Automated Detection {#validation.unused-variables.detection}

Run this command to find all local variables and their occurrence counts:

```bash
grep -o 'local![a-zA-Z_]*' output/[filename].sail | sort | uniq -c | sort -rn
```

**Example output:**
```
  12 local!viewMode
   9 local!selectedSubmissionIds
   8 local!submissionsQuery
   1 local!dateRangeFilter          ← UNUSED (count = 1)
   1 local!selectedSubmissions      ← UNUSED (count = 1)
```

**Interpretation:** Variables with count = 1 appear ONLY in their declaration → **UNUSED**

### Removal vs Documentation Decision {#validation.unused-variables.decision}

| Scenario | Action |
|----------|--------|
| No clear future use | **REMOVE** - Delete the variable declaration entirely |
| Documented future use | **KEEP** - Add UNUSED comment template |

**UNUSED Comment Template (if keeping variable):**
```sail
/* UNUSED - [Name] ([Category]): [Why not used] | [Future use or decision] */
local!variable: value,
```

**Common Mockup Variables to REMOVE:**
- Filter variables that weren't implemented (`local!dateRangeFilter`)
- UI state variables not needed (`local!showAdvanced`)
- Computed variables never referenced (`local!selectedSubmissions`)
- Placeholder variables from templates

### Re-Verification {#validation.unused-variables.reverification}

After removing unused variables:

```bash
grep -o 'local![a-zA-Z_]*' output/[filename].sail | sort | uniq -c | sort -rn
```

**Pass criteria:** ALL variables must have count ≥ 2 (or have UNUSED comment)

**🛑 BLOCKING:** Cannot proceed to null safety enforcement until:
- [ ] Bash verification shows NO variables with count = 1 (except documented)
- [ ] Cleanup documented in conversion summary

---

## Null Safety Enforcement {#validation.null-safety}

### Purpose

Null reference errors cause **complete interface failures**. Users see error pages instead of functional interfaces. There is no graceful degradation.

### Automated Detection Commands {#validation.null-safety.detection}

Run ALL of these commands to find potentially vulnerable patterns:

```bash
# Find all text() calls - may crash on null
grep -n "text(" output/[filename].sail > /tmp/null_check_text.txt
echo "Found $(wc -l < /tmp/null_check_text.txt) text() calls"

# Find all user() calls - crashes on null user reference
grep -n "user(" output/[filename].sail > /tmp/null_check_user.txt
echo "Found $(wc -l < /tmp/null_check_user.txt) user() calls"

# Find all string concatenations with &
grep -n " & " output/[filename].sail > /tmp/null_check_concat.txt
echo "Found $(wc -l < /tmp/null_check_concat.txt) concatenation instances"

# Find all todate() calls on fields - may crash on null
grep -n "todate(fv!row\|todate(ri!" output/[filename].sail > /tmp/null_check_todate.txt
echo "Found $(wc -l < /tmp/null_check_todate.txt) todate() calls on fields"

# Find all queryFilters (check for applyWhen)
grep -n "a!queryFilter(" output/[filename].sail > /tmp/null_check_filters.txt
echo "Found $(wc -l < /tmp/null_check_filters.txt) queryFilter instances"

# Find all dropdownField instances
grep -n "a!dropdownField(" output/[filename].sail > /tmp/null_check_dropdown.txt
echo "Found $(wc -l < /tmp/null_check_dropdown.txt) dropdownField instances"
```

### Context-Aware Review {#validation.null-safety.review}

**CRITICAL:** Not all field references need null safety. Distinguish between:

| Context | Null Safety Required? |
|---------|----------------------|
| Display contexts (grid columns, richText, read-only fields) | ✅ YES |
| Editable input contexts (form field `value`/`saveInto`) | ❌ NO |
| Choice parameters (dropdown `choiceLabels`/`choiceValues`) | ✅ YES |

### Review text() Calls {#validation.null-safety.review-text}

For each text() call in `/tmp/null_check_text.txt`:

- [ ] **SKIP** if inside form input component (textField.value, dateField.value, etc.)
- [ ] For display contexts: Verify wrapped in `if(a!isNotNullOrEmpty(...), text(...), "N/A")`
- [ ] If NOT wrapped → Mark for correction

**Document:** "Reviewed [N] text() calls, [M] in display contexts, [P] need protection"

### Review user() Calls {#validation.null-safety.review-user}

For each user() call in `/tmp/null_check_user.txt`:

- [ ] **SKIP** if showing current user (auto-populated fields using `loggedInUser()`)
- [ ] For display contexts: Verify wrapped in `if(a!isNotNullOrEmpty(...), user(...), "N/A")`
- [ ] If NOT wrapped → Mark for correction

### Review Concatenations {#validation.null-safety.review-concat}

For each `&` concatenation in `/tmp/null_check_concat.txt`:

- [ ] **SKIP** if inside form input value/saveInto
- [ ] For display contexts:
  - If concatenating with text(): Verify if() wrapping with "N/A" fallback
  - If concatenating without text(): Verify `a!defaultValue(field, "")` wrapping

### Review Date Operations {#validation.null-safety.review-todate}

For each todate() call in `/tmp/null_check_todate.txt`:

- [ ] **SKIP** if inside form dateField.value
- [ ] For display contexts:
  - If used in arithmetic: Verify wrapped in if() before arithmetic
  - If used in comparison: Verify nested if() pattern for short-circuit

### Review Query Filters {#validation.null-safety.review-filters}

For each a!queryFilter() in `/tmp/null_check_filters.txt`:

- [ ] For filters with **variable values**: Verify has `applyWhen: a!isNotNullOrEmpty(variable)`
- [ ] For filters with **constants/functions**: No applyWhen needed
- [ ] **NO SKIPPING** - all queryFilters with variables need applyWhen

### Review Dropdown Fields {#validation.null-safety.review-dropdown}

For each a!dropdownField() in `/tmp/null_check_dropdown.txt`:

- [ ] `choiceLabels`: Has `if(a!isNotNullOrEmpty(queryResult), queryResult['field'], {})`
- [ ] `choiceValues`: Has `if(a!isNotNullOrEmpty(queryResult), queryResult['field'], {})`
- [ ] `value`: Direct field binding (NO null check needed)
- [ ] `saveInto`: Direct field binding (NO null check needed)

### Correction Patterns {#validation.null-safety.correction}

**Correcting text() calls:**
```sail
/* ❌ BEFORE */
text: text(fv!row['recordType!...field'], "0000")

/* ✅ AFTER */
text: if(
  a!isNotNullOrEmpty(fv!row['recordType!...field']),
  text(fv!row['recordType!...field'], "0000"),
  "N/A"
)
```

**Correcting user() calls:**
```sail
/* ❌ BEFORE */
text: user(fv!row['recordType!...userId'], "username")

/* ✅ AFTER */
text: if(
  a!isNotNullOrEmpty(fv!row['recordType!...userId']),
  user(fv!row['recordType!...userId'], "username"),
  "N/A"
)
```

**Correcting concatenation with text():**
```sail
/* ❌ BEFORE */
text: "ID-" & text(field, "0000")

/* ✅ AFTER */
text: "ID-" & if(
  a!isNotNullOrEmpty(field),
  text(field, "0000"),
  "N/A"
)
```

**Correcting date arithmetic:**
```sail
/* ❌ BEFORE */
todate(fv!row['recordType!...startDate'] + 30)

/* ✅ AFTER */
if(
  a!isNotNullOrEmpty(fv!row['recordType!...startDate']),
  todate(fv!row['recordType!...startDate'] + 30),
  null
)
```

**Correcting date comparisons (nested if for short-circuit):**
```sail
/* ❌ BEFORE */
color: if(
  todate(fv!row['recordType!...date'] + 30) < today(),
  "#DC2626",
  "STANDARD"
)

/* ✅ AFTER */
color: if(
  if(
    a!isNotNullOrEmpty(fv!row['recordType!...date']),
    todate(fv!row['recordType!...date'] + 30) < today(),
    false
  ),
  "#DC2626",
  "STANDARD"
)
```

**Correcting a!queryFilter:**
```sail
/* ❌ BEFORE */
a!queryFilter(
  field: 'recordType!X.fields.name',
  operator: "includes",
  value: local!searchText
)

/* ✅ AFTER */
a!queryFilter(
  field: 'recordType!X.fields.name',
  operator: "includes",
  value: local!searchText,
  applyWhen: a!isNotNullOrEmpty(local!searchText)
)
```

**Correcting form inputs (REMOVE over-defensive null checks):**

For editable form input components:
- [ ] Remove `a!defaultValue()` wrapper from `value` parameter
- [ ] Remove `if(a!isNotNullOrEmpty(ri!))` wrapper from `saveInto`
- [ ] Simplify cross-field validations
- [ ] KEEP null checks for `choiceLabels`/`choiceValues` (query results)

### Re-Verification {#validation.null-safety.reverification}

After applying corrections, re-run detection:

```bash
# Re-run all detection commands
grep -n "text(" output/[filename].sail > /tmp/null_check_text_v2.txt
grep -n "user(" output/[filename].sail > /tmp/null_check_user_v2.txt
# ... etc

# Manually review each instance
# Verify ALL match protected patterns
```

**Document summary:**
```
Null Safety Enforcement Summary:
- Protected [N] text() calls (all verified)
- Protected [M] user() calls (all verified)
- Protected [P] concatenations (all verified)
- Protected [Q] todate() calls (all verified)
- Added applyWhen to [R] queryFilters (all verified)
- Total corrections: [N+M+P+Q+R]
```

**🛑 BLOCKING:** Cannot proceed to type matching until:
- [ ] All detection commands executed and counts documented
- [ ] Manual review completed for ALL instances found
- [ ] All corrections applied using patterns above
- [ ] Re-verification confirms 100% pattern compliance

---

## Query Filter Type Matching {#validation.type-matching}

### Purpose

Field type in `a!queryFilter()` MUST match value type. Mismatches cause runtime errors.

### Type Compatibility Table {#validation.type-matching.table}

| Field Type | Valid Value Expressions | Invalid (Will Fail) |
|------------|------------------------|---------------------|
| **Date** | `today()`, `todate()`, `date()`, `datevalue()`, `eomonth()`, `edate()`, date arithmetic | `now()`, `a!subtractDateTime()`, `userdatetime()` |
| **DateTime** | `now()`, `todatetime()`, `datetime()`, `a!subtractDateTime()`, `a!addDateTime()`, `userdatetime()` | `today()`, `todate()`, `eomonth()`, `edate()` |
| **Text** | `"literal"`, `tostring()`, `concat()`, Text variable | Integer, Boolean, Date |
| **Number (Integer)** | `123`, `tointeger()`, Integer variable | `"123"` (text), dates |
| **Number (Decimal)** | `123.45`, `todecimal()`, Decimal variable | `"123.45"` (text), dates |
| **Boolean** | `true()`, `false()`, Boolean variable | `"true"` (text), `1` (integer) |
| **User** | `loggedInUser()`, `touser()`, User variable | `"username"` (text without touser) |

**Note:** Integer and Decimal are interchangeable. All other types require exact match.

### Local Variable Tracing {#validation.type-matching.tracing}

When filter value is a local variable, trace back to declaration:

```sail
/* Variable declaration */
local!filterDate: today(),           /* ← Initialized with today() → Type: Date */

/* Later in a!queryFilter */
a!queryFilter(
  field: '...membershipEndDate',     /* ← Field type: Date (from data-model-context.md) */
  operator: ">=",
  value: local!filterDate            /* ← Variable type: Date ✅ MATCH */
)
```

### Common Mistakes and Fixes {#validation.type-matching.fixes}

| Mismatch | Fix |
|----------|-----|
| DateTime field + Date value | Change `today()` → `now()`, `todate()` → `todatetime()` |
| Date field + DateTime value | Change `now()` → `today()`, `a!subtractDateTime()` → `todate(today() - N)` |
| Integer field + Text value | Change `"123"` → `123`, or wrap in `tointeger()` |
| Text field + Integer value | Change `123` → `"123"`, or wrap in `tostring()` |

### Verification Checklist {#validation.type-matching.checklist}

For EACH `a!queryFilter()` in the generated file:

- [ ] Identify field type from `data-model-context.md`
- [ ] Check value expression type
- [ ] If mismatch → Apply fix from table above
- [ ] If local variable → Trace to declaration, confirm type

**Reference:** See `/logic-guidelines/datetime-handling.md` for complete type compatibility.

---

## Pre-Flight Checklist {#validation.pre-flight-checklist}

**🚨 MANDATORY** - Complete ALL items before writing output file.

### Source Reading Verification {#validation.pre-flight.reading}

- [ ] Did I read the mockup file from `/output/`?
- [ ] Did I detect interface type and load correct module(s)?
- [ ] Did I read `data-model-context.md` for record types?
- [ ] Did I read `/ui-guidelines/reference/sail-api-schema.json` for parameters?

### Data Model Verification {#validation.pre-flight.data-model}

- [ ] All relationships validated against `data-model-context.md`
- [ ] All target record types identified (or marked missing)
- [ ] All field access validated (or alternatives documented)
- [ ] All assumptions documented with ASSUMPTION comments
- [ ] All missing data documented with TODO comments

### Implementation Verification {#validation.pre-flight.implementation}

- [ ] All mock data replaced with queries
- [ ] All mandatory refactoring applied (nested if → a!match, charts → data+config)
- [ ] All visual design preserved (colors, spacing, heights, widths)
- [ ] All decisions documented in code comments
- [ ] Record type constructors used (not a!map) where creating/updating

### Form Interface Verification (if applicable) {#validation.pre-flight.form}

- [ ] **🚨 MANDATORY RULE INPUTS (all 3 required):**
  - [ ] `ri!{recordName}` - The record being created/updated
  - [ ] `ri!isUpdate` - Boolean flag (true=update, false=create)
  - [ ] `ri!cancel` - Boolean flag for cancellation signaling
- [ ] **DO NOT derive mode from field checks** - Use `ri!isUpdate` directly
- [ ] **REMOVE delete buttons** - Deletion handled from list views, not forms
- [ ] Used structured RULE INPUTS comment format with ALL 3 inputs documented
- [ ] Each rule input has Name/Type/Description
- [ ] Form fields bind to `ri!recordName[...]`, NOT local variables
- [ ] Create button: `showWhen: not(ri!isUpdate)`, sets ALL 4 audit fields
- [ ] Update button: `showWhen: ri!isUpdate`, sets only modifiedBy/modifiedOn
- [ ] Cancel button: `submit: true, validate: false, saveInto: a!save(ri!cancel, true)`
- [ ] **RUN full form checklist:** `form-conversion-module.md {#form.checklist}`

### Validation Enforcement Verification {#validation.pre-flight.validation}

- [ ] Unused variable detection run (bash verification output)
- [ ] All unused variables removed or documented
- [ ] Null safety detection run (all 5+ commands)
- [ ] All null safety corrections applied
- [ ] Re-verification confirms 100% compliance
- [ ] Query filter type matching verified for ALL filters

### Action Conversion Verification (if applicable) {#validation.pre-flight.actions}

- [ ] Action buttons converted to `a!recordActionField()` where available
- [ ] Related Actions have `identifier` parameter
- [ ] `a!dynamicLink()` converted to `a!recordLink()` for navigation

### Universal SAIL Validation {#validation.pre-flight.universal}

- [ ] Starts with `a!localVariables()`
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes, escaped with `""` not `\"`
- [ ] Comments use `/* */` not `//`
- [ ] Uses `and()`, `or()`, `not()` functions NOT operators
- [ ] No nested sideBySideLayouts
- [ ] At least one AUTO width column in each columnsLayout
- [ ] Grid columns use `fv!row` (NOT fv!index, NOT fv!item)
- [ ] Variables declared in dependency order (no forward references)

### Dropdown "All" Option Validation {#validation.pre-flight.dropdown-all}

For EACH dropdownField with "All/Any" filter option:
- [ ] ❌ VERIFY: choiceLabels does NOT use `append()` with query data
- [ ] ❌ VERIFY: choiceValues does NOT use `append()` with query data
- [ ] ✅ VERIFY: Uses `placeholder: "All..."` parameter instead
- [ ] ✅ VERIFY: Filter variable is uninitialized (not set to "All")
- [ ] ✅ VERIFY: Filter applyWhen uses `a!isNotNullOrEmpty()` (not `<> "All"`)

### Variable Declaration Order {#validation.pre-flight.variable-order}

- [ ] All local variables declared in dependency order
- [ ] Variables with no dependencies declared first
- [ ] Variables that reference other `local!` variables declared AFTER their dependencies
- [ ] No forward references (using a variable before it's declared)

**Common patterns requiring reordering:**
1. Date range filters: `local!selectedOption` BEFORE `local!computedDate: a!match(value: local!selectedOption)`
2. Query filters: `local!filterValue` BEFORE `local!query: a!queryRecordType(...filter: local!filterValue)`
3. Computed from queries: `local!queryResult` BEFORE `local!displayData: local!queryResult.data`

### Completeness Check {#validation.pre-flight.completeness}

- [ ] Conversion is 100% complete (ALL sections, ALL fields)
- [ ] TODO comments documented (if any)
- [ ] Wizard steps match (static vs dynamic)
- [ ] Form fields match (static vs dynamic)

**If ANY answer is "No", STOP and complete that step before writing output.**

---

## Final Output Steps {#validation.output}

After passing pre-flight checklist:

1. **Write output file:** `/output/[original-name]-functional.sail`

2. **Document conversion summary:**
   - Data sources connected (record types used)
   - Logic refactoring applied (counts)
   - Validation blockers encountered (if any)
   - Assumptions made about data model

3. **Invoke validation sub-agents:**
   - sail-schema-validator (function syntax)
   - sail-icon-validator (icon aliases)
   - sail-code-reviewer (structure, best practices)

4. **Review validation results:**
   - Expected errors: Record type UUIDs, ri! variables, cons!/rule! references
   - Critical errors: Invalid functions, syntax errors → FIX and re-validate
