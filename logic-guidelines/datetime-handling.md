# Date/Time Handling Rules {#datetime-critical-rules}

> **Parent guides:**
> - `dynamic-sail-expression-guidelines.md` (mock data interfaces)
> - `record-type-handling-guidelines.md` (record types & queries)
>
> **Quick Reference:** `logic-guidelines/null-safety-quick-ref.md` (Date/Time section)

---

## Correct Date/Time Functions

🚨 **CRITICAL**: Use the correct function for date/time creation

```sail
/* ✅ CORRECT - Use dateTime() for specific date/time creation */
dateTime(year(today()), month(today()), 1, 0, 0, 0)  /* Month to Date */

/* ❌ WRONG - a!dateTimeValue() does NOT exist in Appian */
a!dateTimeValue(year: year(today()), month: month(today()), day: 1)
```

---

## Type Casting with todate()

**Always cast date arithmetic in sample data to ensure consistent types:**

```sail
/* ❌ WRONG */
local!data: {
  a!map(dueDate: today()),        /* Type: Date */
  a!map(dueDate: today() + 1)     /* Type: DateTime - causes grid sort errors! */
}

/* ✅ RIGHT */
local!data: {
  a!map(dueDate: todate(today())),      /* Type: Date */
  a!map(dueDate: todate(today() + 1)),  /* Type: Date */
  a!map(dueDate: todate(today() + 7))   /* Type: Date */
}
```

---

## Date/DateTime Arithmetic Returns Intervals

Subtracting dates or datetimes returns an **Interval** type, not a Number:
- `now() - timestamp` → Interval (Day to Second)
- `today() - dateValue` → Interval (Day to Day)

**Cannot compare Intervals directly to Numbers:**

```sail
/* ❌ WRONG */
if(now() - fv!row.timestamp < 1, ...)  /* Error: Cannot compare Interval to Number */

/* ✅ RIGHT */
if(tointeger(now() - fv!row.timestamp) < 1, ...)  /* Convert Interval to Integer first */
```

---

## Query Filter Data Type Matching

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

### Common Type Conversions:
- **DateTime fields**: Use `a!subtractDateTime()`, `a!addDateTime()`, `now()`, `dateTime()`
- **Date fields**: Use `today()`, date arithmetic, `date()`
- **Number fields**: Use `tointeger()`, `todecimal()`
- **Text fields**: Use `totext()`

### Workflow Before Writing Date/DateTime Filters:
1. **Check data-model-context.md** for the actual field type
2. **Date field** → Use `today()`, `todate()`, date arithmetic (e.g., `today() - 30`)
3. **DateTime field** → Use `now()`, `dateTime()`, `a!subtractDateTime()`, `a!addDateTime()`

---

## Key Date/Time Functions

| Function | Use For |
|----------|---------|
| `todate()` | Cast to Date type (use for all date arithmetic in sample data) |
| `tointeger()` | Convert interval to whole days as integer |
| `text(value, format)` | Format numbers/dates/intervals as text |
| `today()` | Current date (Date type) |
| `now()` | Current date and time (DateTime type) |
| `dateTime(y, m, d, h, m, s)` | Create specific DateTime |
| `date(y, m, d)` | Create specific Date |
| `a!subtractDateTime()` | Subtract from DateTime (for past dates) |
| `a!addDateTime()` | Add to DateTime (for future dates) |

---

## Date Function Corrections

```sail
/* ❌ WRONG - addDateTime rejects negative values */
value: a!addDateTime(startDateTime: today(), days: -30)

/* ✅ CORRECT - Use subtractDateTime for past dates */
value: a!subtractDateTime(startDateTime: now(), days: 30)
```

---

## min()/max() Return Type Casting

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

### Rules:
- **Date arrays**: Wrap with `todate(min(...))` or `todate(max(...))`
- **DateTime arrays**: Wrap with `todatetime(min(...))` or `todatetime(max(...))`
- **Number arrays**: Wrap with `tointeger(...)` or `todecimal(...)` if specific type needed
- **Always cast** when using the result in comparisons or calculations

---

## text() Function with Date/DateTime Values

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

---

## Valid Operators by Data Type

The following operators are valid for each data type in `a!queryFilter`:

| Data Type | Valid Operators |
|-----------|----------------|
| **Text** | `=`, `<>`, `in`, `not in`, `starts with`, `not starts with`, `ends with`, `not ends with`, `includes`, `not includes`, `is null`, `not null`, `search` |
| **Integer, Float, Time** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Date, Date and Time** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Boolean** | `=`, `<>`, `in`, `not in`, `is null`, `not null` |

### Key Notes:
- `"between"` operator requires **two values** in an array: `value: {startValue, endValue}`
- `"in"` and `"not in"` operators accept arrays of values
- Text operators (`starts with`, `ends with`, `includes`, `search`) work ONLY with Text fields
- Date/DateTime comparison operators (`>`, `>=`, `<`, `<=`) require proper type matching

### Examples:

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
