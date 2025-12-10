# Query Result Data Structures {#query-result-structures}

> **Parent guide:** `record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md`
>
> **Related:**
> - `record-query-guidelines/kpi-aggregation-patterns.md` (aggregation patterns)
> - `logic-guidelines/functions-reference.md` (function reference)

---

## Universal Rule: Query Type Determines Property Access

**This principle applies to ALL components that use query results: dropdowns, checkboxes, radio buttons, forEach loops, grids, dynamic displays, etc.**

---

## Pattern 1: Regular Field Queries → Record Instances

**Query Structure:**
```sail
a!queryRecordType(
  recordType: 'recordType!{uuid}Type',
  fields: {
    'recordType!{uuid}Type.fields.{uuid}field1',
    'recordType!{uuid}Type.fields.{uuid}field2'
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

---

## Pattern 2: Aggregation Queries → Maps

**Query Structure:**
```sail
a!queryRecordType(
  recordType: 'recordType!{uuid}Type',
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

---

## Quick Decision Guide

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

---

## Common Mistake

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

---

## Why This Matters

**Record instances** are strongly typed objects that preserve the full record structure. They require explicit field paths to maintain type safety and relationship integrity.

**Maps** are simple key-value dictionaries created from aggregations. The aliases you define become the property names.

Using the wrong property access method causes:
- Empty/blank displays (properties not found)
- Runtime errors (invalid property access)
- Data binding failures (saves don't persist)

---

## Data Extraction Patterns

### Pattern 1: Aggregation Queries with NO Groupings

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

### Pattern 2: Regular Queries Returning Rows

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
  local!currentApplicant[1]['recordType!Applicant.fields.applicantId'],
  null
),

/* ❌ WRONG - Missing array indexing */
local!applicantId: a!defaultValue(
  local!currentApplicant['recordType!Applicant.fields.applicantId'],  /* ERROR */
  null
)
```

---

## How to Decide Which Pattern to Use

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

---

## Data Extraction Checklist

- [ ] Identified query type: aggregation (no groupings), aggregation (with groupings), or regular query?
- [ ] For aggregations with NO groupings: Using direct property access `.data.alias`?
- [ ] For regular queries: Using array indexing `[1]['field']` to get first row?
- [ ] Wrapped extraction in `a!defaultValue()` with appropriate default?
- [ ] Not over-complicating with nested `index()` calls when simpler pattern exists?
