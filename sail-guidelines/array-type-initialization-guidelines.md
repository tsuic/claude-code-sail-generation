# SAIL Array Type Initialization Guidelines

## 🚨 CRITICAL: Empty Array Type Declaration

**Problem:** In Appian, `{}` returns a **List of Variant** (untyped array), which causes type mismatch errors when used with typed operations.

**Impact:** Functions like `contains()`, `wherecontains()`, `union()`, `intersection()`, and `append()` require typed arrays.

---

## Mandatory Type Initialization Pattern

### ✅ ALWAYS Initialize Arrays with Type Declaration

```sail
/* ❌ WRONG - Untyped arrays cause errors */
local!selectedIds: {},
local!names: {},
local!dates: {},
local!flags: {},

/* ✅ CORRECT - Type-initialized arrays */
local!selectedIds: tointeger({}),      /* List of Integer */
local!names: totext({}),               /* List of Text */
local!dates: todate({}),               /* List of Date */
local!flags: toboolean({}),            /* List of Boolean */
local!decimals: tonumber({}),          /* List of Decimal */
local!users: touser({}),               /* List of User */
local!groups: togroup({}),             /* List of Group */
```

---

## Type Initialization Functions by Data Type

| Target Type | Initialization Function | Example |
|-------------|------------------------|---------|
| Integer | `tointeger({})` | `local!selectedIds: tointeger({})` |
| Text | `totext({})` | `local!names: totext({})` |
| Date | `todate({})` | `local!dueDates: todate({})` |
| DateTime | `todatetime({})` | `local!timestamps: todatetime({})` |
| Time | `totime({})` | `local!scheduledTimes: totime({})` |
| Boolean | `toboolean({})` | `local!flags: toboolean({})` |
| Decimal | `tonumber({})` | `local!prices: tonumber({})` |
| User | `touser({})` | `local!assignees: touser({})` |
| Group | `togroup({})` | `local!teams: togroup({})` |

---

## Common Error Scenarios & Solutions

### Error 1: contains() with Untyped Array

**❌ WRONG:**
```sail
local!selectedCourseIds: {},

/* Later in code... */
contains(local!selectedCourseIds, fv!item.id)  /* ERROR: Variant vs Integer */
```

**✅ CORRECT:**
```sail
local!selectedCourseIds: tointeger({}),

/* Later in code... */
contains(local!selectedCourseIds, fv!item.id)  /* ✓ Both Integer type */
```

---

### Error 2: wherecontains() with Untyped Array

**❌ WRONG:**
```sail
local!filterValues: {},

wherecontains(local!filterValues, local!dataArray)  /* ERROR: Type mismatch */
```

**✅ CORRECT:**
```sail
local!filterValues: totext({}),

wherecontains(local!filterValues, local!dataArray)  /* ✓ Typed array */
```

---

### Error 3: append() with First Item

**⚠️ AMBIGUOUS:**
```sail
local!items: {},

/* First append establishes type, but contains() before this fails */
a!save(local!items, append(local!items, 5))  /* Now List of Integer */
```

**✅ CORRECT:**
```sail
local!items: tointeger({}),

/* Type already established - all operations safe */
a!save(local!items, append(local!items, 5))
```

---

### Error 4: Parallel Arrays with Different Types

**❌ WRONG:**
```sail
/* Untyped parallel arrays */
local!prerequisiteCompletionDates: {},
local!prerequisiteIssuingCenters: {},
local!prerequisiteDocuments: {},
```

**✅ CORRECT:**
```sail
/* Type-initialized parallel arrays */
local!prerequisiteCompletionDates: todate({}),     /* List of Date */
local!prerequisiteIssuingCenters: totext({}),      /* List of Text */
local!prerequisiteDocuments: tointeger({}),        /* List of Integer (document IDs) */
```

---

## When Type Initialization is NOT Needed

### Arrays Initialized with Data

```sail
/* ✅ Type inferred from source data */
local!courseIds: local!availableCourses.id,        /* Already List of Integer */
local!courseNames: local!availableCourses.name,    /* Already List of Text */

/* ✅ Type inferred from literal array */
local!statuses: {"Open", "In Progress", "Closed"}, /* Already List of Text */
local!counts: {0, 5, 10, 15},                      /* Already List of Integer */
```

### Arrays That Will Be Fully Replaced

```sail
/* ✅ Acceptable if never used before replacement */
local!tempData: {},

/* Immediately replaced with typed data */
local!tempData: a!queryRecordType(...)['recordType!Case.fields.id']
```

---

## Complex Types: Maps and CDTs

### Arrays of Maps (Dictionary Type)

```sail
/* ❌ WRONG - Cannot type-cast a!map() arrays */
local!employers: tointeger({}),  /* Error: a!map is not Integer */

/* ✅ CORRECT - Initialize with empty map structure */
local!employers: {
  a!map(
    employerName: null,
    jobTitle: null,
    startDate: null,
    endDate: null
  )
}

/* ⚠️ ALTERNATIVE - If truly empty, use {} but document type */
/* Array of Map (employer records) - will be populated dynamically */
local!employers: {},
```

**Why:** `a!map()` creates a **Dictionary** type, which doesn't have a direct type-casting function. Initialize with a sample structure instead.

### Arrays of CDTs (Custom Data Types)

```sail
/* ✅ Type inferred from CDT constructor */
local!submissions: {},  /* Will hold CDT instances */

/* Type established on first assignment */
local!submissions: append(
  local!submissions,
  type!SubmissionCDT(title: "First", status: "Draft")
)

/* ✅ BETTER - Initialize with CDT type if known */
local!submissions: cast(type!SubmissionCDT, {})
```

---

## Decision Tree: How to Initialize Arrays

```
Is the array storing primitive values (Integer, Text, Date, Boolean)?
├─ YES → Use type initialization: tointeger({}), totext({}), todate({}), toboolean({})
└─ NO → Is it storing Maps or CDTs?
    ├─ Maps → Initialize with sample structure: {a!map(field1: null, field2: null)}
    └─ CDTs → Use cast(type!CDTName, {}) if available, or {} with comment
```

---

## Validation Checklist

**Before generating SAIL code, verify:**

- [ ] All arrays storing IDs are initialized with `tointeger({})`
- [ ] All arrays storing names/labels are initialized with `totext({})`
- [ ] All arrays storing dates are initialized with `todate({})`
- [ ] All arrays storing flags are initialized with `toboolean({})`
- [ ] Arrays of maps are initialized with sample structure or documented
- [ ] No `contains()` or `wherecontains()` calls on untyped `{}`
- [ ] No `append()` operations without type safety

---

## Quick Reference: Common Patterns

### Multi-Select Pattern (IDs)
```sail
/* Grid selection with typed array */
local!selectedRecordIds: tointeger({}),

a!gridField(
  selectionValue: local!selectedRecordIds,
  selectionSaveInto: local!selectedRecordIds
)
```

### Dynamic Form Fields (Parallel Arrays)
```sail
/* Parallel arrays for forEach-generated inputs */
local!fieldValues: totext({}),
local!fieldDates: todate({}),
local!fieldFlags: toboolean({}),

a!forEach(
  items: local!fieldDefinitions,
  expression: a!textField(
    value: index(local!fieldValues, fv!index, null),
    saveInto: a!save(
      local!fieldValues,
      a!update(data: local!fieldValues, index: fv!index, value: save!value)
    )
  )
)
```

### Filter/Search Pattern
```sail
/* Filter values with typed array */
local!filterStatusValues: totext({}),

wherecontains(local!filterStatusValues, local!allCases.status)
```

---

## Summary

**🚨 MANDATORY RULE:**
> **ALWAYS initialize empty arrays with type-casting functions when storing primitive types (Integer, Text, Date, Boolean, Decimal, User, Group).**

**Why this matters:**
- Prevents runtime type mismatch errors
- Makes code behavior predictable
- Improves code readability (type is self-documenting)
- Avoids debugging time on cryptic type errors

**Default pattern:**
```sail
local!arrayName: to<Type>({}),  /* Type-initialized empty array */
```
