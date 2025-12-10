# Null Safety - Quick Pattern Lookup

> **For comprehensive explanations, see:**
> - `record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md` → "🚨 MANDATORY: Null Safety Implementation" (#null-safety-implementation)
> - `logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` → "🚨 CRITICAL: Short-Circuit Evaluation Rules" (#short-circuit-rules)
> - `sail-dynamic-converter.md` → Step 5D.6 for enforcement workflow

## Detection Commands

Run these to find vulnerable patterns:

```bash
# Find all text() calls
grep -n "text(" output/interface.sail

# Find all user() calls
grep -n "user(" output/interface.sail

# Find all string concatenations
grep -n " & " output/interface.sail

# Find all todate() on fields
grep -n "todate(fv!row\|todate(ri!" output/interface.sail

# Find queryFilters without applyWhen
grep -B5 "a!queryFilter(" output/interface.sail | grep -v "applyWhen"
```

## Standard Patterns

| **Scenario** | **Protected Pattern** | **Fallback** |
|-------------|----------------------|-------------|
| **Display - Integer** | `if(a!isNotNullOrEmpty(field), field, "N/A")` | "N/A" |
| **Display - Decimal** | `if(a!isNotNullOrEmpty(field), field, "N/A")` | "N/A" |
| **Display - Text** | `if(a!isNotNullOrEmpty(field), field, "N/A")` | "N/A" |
| **Display - Date** | `if(a!isNotNullOrEmpty(field), text(todate(field), "MMM d, yyyy"), "N/A")` | "N/A" |
| **Display - DateTime** | `if(a!isNotNullOrEmpty(field), text(field, "MMM d, yyyy h:mm a"), "N/A")` | "N/A" |
| **Display - Time** | `if(a!isNotNullOrEmpty(field), text(field, "h:mm a"), "N/A")` | "N/A" |
| **user() function** | `if(a!isNotNullOrEmpty(userId), trim(user(userId, "firstName") & " " & user(userId, "lastName")), "N/A")` | "N/A" |
| **Concat - with field** | `"PREFIX-" & if(a!isNotNullOrEmpty(field), field, "N/A")` | "N/A" |
| **Concat - without formatting** | `a!defaultValue(field1, "") & " " & a!defaultValue(field2, "")` | "" |
| **Date arithmetic** | `if(a!isNotNullOrEmpty(field), todate(field + 30), null)` | null |
| **Date comparison** | `if(if(a!isNotNullOrEmpty(field), todate(field + 30) < today(), false), ...)` | false |
| **a!queryFilter (ri!/local!)** | `a!queryFilter(..., value: local!var, applyWhen: a!isNotNullOrEmpty(local!var))` | Filter skipped |
| **a!queryFilter (literal)** | `a!queryFilter(..., value: "Active")` - NO applyWhen needed | N/A |
| **Display field** | `a!defaultValue(field, "N/A")` | "N/A" |
| **Editable field** | `field` (direct - no a!defaultValue) | N/A |
| **not() function** | `not(a!defaultValue(var, false()))` | false() |

**Note:** For editable fields (textField, integerField, dateField, etc.), use the variable/rule input directly in both `value` and `saveInto` parameters. Do NOT use a!defaultValue(). Appian handles null values automatically in form fields.

## Form Input Components - Special Rules

**Editable form input components (textField, dateField, dropdownField, etc.) handle null automatically. Do NOT add null checking to `value` or `saveInto` parameters.**

### Input Field Pattern (value/saveInto)

```sail
/* ✅ CORRECT - Direct field binding */
a!textField(
  label: "Case Description",
  value: ri!submission['recordType!Case.fields.description'],
  saveInto: {
    ri!submission['recordType!Case.fields.description'],
    a!save(local!hasUnsavedChanges, true())
  },
  required: true()
)

/* ❌ WRONG - Unnecessary null checking */
a!textField(
  label: "Case Description",
  value: a!defaultValue(
    if(
      a!isNotNullOrEmpty(ri!submission),
      ri!submission['recordType!Case.fields.description'],
      null
    ),
    null
  ),
  saveInto: {
    if(
      a!isNotNullOrEmpty(ri!submission),
      a!save(ri!submission['recordType!Case.fields.description'], save!value),
      {}
    ),
    a!save(local!hasUnsavedChanges, true())
  }
)
```

**Why:** Appian form components are designed to handle null values in create/update forms. Adding null checks adds complexity without benefit.

**Applies to:** textField, integerField, dateField, dateTimeField, dropdownField, checkboxField, radioButtonField, paragraphField, fileUploadField, pickerField, etc.

### Dropdown Field Choice Parameters (choiceLabels/choiceValues)

**Exception:** For dropdownField, `choiceLabels` and `choiceValues` parameters that query data DO need null checking:

```sail
/* ✅ CORRECT - Null check for choice parameters */
a!dropdownField(
  label: "Position Type",
  choiceLabels: if(
    a!isNotNullOrEmpty(local!positionTypes),
    local!positionTypes['recordType!PositionType.fields.name'],
    {}
  ),
  choiceValues: if(
    a!isNotNullOrEmpty(local!positionTypes),
    local!positionTypes['recordType!PositionType.fields.id'],
    {}
  ),
  value: ri!submission['recordType!Case.fields.positionTypeId'],
  saveInto: {
    ri!submission['recordType!Case.fields.positionTypeId'],
    a!save(local!hasUnsavedChanges, true())
  }
)
```

**Why:** `choiceLabels` and `choiceValues` are arrays extracted from query results. If the query returns null/empty, accessing fields would crash. But `value`/`saveInto` still use direct field binding.

### Cross-Field Validation Pattern

**For validation logic that compares two fields, simplify null checks:**

```sail
/* ✅ CORRECT - Simplified validation */
validations: if(
  and(
    a!isNotNullOrEmpty(ri!submission['recordType!Case.fields.startDate']),
    a!isNotNullOrEmpty(ri!submission['recordType!Case.fields.endDate']),
    ri!submission['recordType!Case.fields.endDate'] <= ri!submission['recordType!Case.fields.startDate']
  ),
  "End Date must be after Start Date",
  null
)

/* ❌ WRONG - Over-defensive checking */
validations: if(
  and(
    a!isNotNullOrEmpty(
      if(
        a!isNotNullOrEmpty(ri!submission),
        ri!submission['recordType!Case.fields.startDate'],
        null
      )
    ),
    a!isNotNullOrEmpty(
      if(
        a!isNotNullOrEmpty(ri!submission),
        ri!submission['recordType!Case.fields.endDate'],
        null
      )
    ),
    if(...nested checks...)
  ),
  "End Date must be after Start Date",
  null
)
```

## Nested if() Pattern (Short-Circuit)

**Use when:** Accessing properties on computed variables OR comparing dates with arithmetic

```sail
/* ✅ CORRECT - Nested if() for short-circuit behavior */
if(
  if(
    a!isNotNullOrEmpty(variable),
    variable.property = "value",  /* OR: todate(variable + 30) < today() */
    false
  ),
  /* Then branch - condition is true */,
  /* Else branch - condition is false or variable is null */
)
```

**Why nested if():** SAIL's `and()` function does NOT short-circuit - it evaluates ALL arguments even if the first is false. This causes crashes when accessing properties on null/empty variables.

**Common scenarios requiring nested if():**
- Grid selections: `local!selectedItems.type = "Contract"`
- Filtered arrays: `local!activeUsers.role`
- Date comparisons with arithmetic: `todate(field + 30) < today()`
- Any property access on computed/derived variables

## Date/Time Field Handling

**Critical:** Date and DateTime fields require different functions. Always check field type in data model.

### Date Fields (type: Date)
```sail
/* ✅ Display Date field */
text: if(
  a!isNotNullOrEmpty(fv!row['recordType!...dateField']),
  text(todate(fv!row['recordType!...dateField']), "MMM d, yyyy"),
  "N/A"
)

/* ✅ Date arithmetic */
if(
  a!isNotNullOrEmpty(fv!row['recordType!...dateField']),
  todate(fv!row['recordType!...dateField'] + 30),
  null
)

/* ✅ Date filter */
a!queryFilter(
  field: 'recordType!X.fields.dateField',
  operator: ">=",
  value: today() - 30,  /* Use today(), date arithmetic */
  applyWhen: a!isNotNullOrEmpty('recordType!X.fields.dateField')
)
```

### DateTime Fields (type: DateTime)
```sail
/* ✅ Display DateTime field */
text: if(
  a!isNotNullOrEmpty(fv!row['recordType!...dateTimeField']),
  text(fv!row['recordType!...dateTimeField'], "MMM d, yyyy h:mm a"),
  "N/A"
)

/* ✅ DateTime arithmetic */
if(
  a!isNotNullOrEmpty(fv!row['recordType!...dateTimeField']),
  a!addDateTime(
    startDateTime: fv!row['recordType!...dateTimeField'],
    days: 30
  ),
  null
)

/* ✅ DateTime filter */
a!queryFilter(
  field: 'recordType!X.fields.dateTimeField',
  operator: ">=",
  value: a!subtractDateTime(startDateTime: now(), days: 30),  /* Use now(), a!subtractDateTime() */
  applyWhen: a!isNotNullOrEmpty('recordType!X.fields.dateTimeField')
)
```

### Time Fields (type: Time)
```sail
/* ✅ Display Time field */
text: if(
  a!isNotNullOrEmpty(fv!row['recordType!...timeField']),
  text(fv!row['recordType!...timeField'], "h:mm a"),
  "N/A"
)

/* ✅ Time filter */
a!queryFilter(
  field: 'recordType!X.fields.timeField',
  operator: ">=",
  value: time(9, 0, 0),  /* 9:00 AM */
  applyWhen: a!isNotNullOrEmpty('recordType!X.fields.timeField')
)
```

**Key Functions:**
- **Date fields:** `today()`, `todate()`, `date()`, date arithmetic (`today() - 30`)
- **DateTime fields:** `now()`, `dateTime()`, `a!subtractDateTime()`, `a!addDateTime()`
- **Time fields:** `time()`, `a!subtractTime()`, `a!addTime()`

**Reference:** See `record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md` "🚨 CRITICAL: Correct Date/Time Functions" (#datetime-critical-rules)

## Fallback Value Rules

| **Context** | **Fallback** | **Reason** |
|------------|-------------|-----------|
| Display (grid, richText, paragraph) | `"N/A"` | User-facing text |
| Editable fields (all types) | Use field directly (no wrapper) | Appian handles null automatically |
| Boolean logic (not, showWhen) | `false()` | Safe default for boolean context |
