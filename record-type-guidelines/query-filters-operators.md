# Query Filters and Operators {#query-filters-operators}

> **Parent guide:** `record-type-handling-guidelines.md`
>
> **Related:**
> - `record-type-guidelines/query-result-structures.md` (query patterns)
> - `sail-guidelines/datetime-handling.md` (date/time filters)

---

## a!recordData() - ONLY for Grid/Chart Data

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

---

## a!queryRecordType() - For ALL Other Data Queries

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

---

## ❌ COMMON MISTAKE: Using `sorts` (plural) as Parameter Name

**The `sorts` parameter does NOT exist in `a!queryRecordType()`.** Sorting is configured inside `a!pagingInfo()` using the `sort` parameter (singular, not plural).

**WRONG:**
```sail
/* ❌ ERROR: sorts doesn't exist as a parameter */
local!positionTypes: a!queryRecordType(
  recordType: 'recordType!{uuid}RBC Position Type',
  fields: {...},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  sorts: {  /* ❌ Invalid parameter */
    a!sortInfo(
      field: 'recordType!{uuid}RBC Position Type.fields.{uuid}displayOrder',
      ascending: true
    )
  }
).data
```

**CORRECT:**
```sail
/* ✅ Sort goes INSIDE pagingInfo, parameter name is 'sort' (singular) */
local!positionTypes: a!queryRecordType(
  recordType: 'recordType!{uuid}RBC Position Type',
  fields: {...},
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: a!sortInfo(  /* ✅ Correct: inside pagingInfo, singular 'sort' */
      field: 'recordType!{uuid}RBC Position Type.fields.{uuid}displayOrder',
      ascending: true
    )
  )
).data
```

**Key Points:**
- Parameter name is `sort` (singular), not `sorts` (plural)
- `sort` is a parameter of `a!pagingInfo()`, not `a!queryRecordType()`
- `sort` accepts an array of `a!sortInfo()` (despite being singular, it takes multiple sort criteria)

---

## 🚨 CRITICAL: Fields Parameter - MUST SPECIFY ALL FIELDS

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
```

**Key Rules:**
- **ALWAYS include `fields` parameter** with ALL fields you need to display
- **Include primary key field** if you need to create record links
- **Include related record fields** using relationship dot notation
- **Check data model context** to confirm available fields before querying

---

## 🚨 CRITICAL: fetchTotalCount Parameter

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

---

## Critical Filter Rules

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

---

## ⚠️ CRITICAL: Nesting Query Logical Expressions

**The `filters` parameter ONLY accepts `a!queryFilter()` - NOT nested `a!queryLogicalExpression()`**

When combining AND + OR logic (e.g., "user = current AND (status = A OR status = B)"), use the `logicalExpressions` parameter.

### ❌ WRONG - Mixing Types in filters Parameter

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

### ✅ CORRECT - Use logicalExpressions Parameter

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

### Parameter Rules

| Parameter | Accepts | Purpose |
|-----------|---------|---------|
| `filters` | **ONLY** `a!queryFilter()` | Direct field comparisons |
| `logicalExpressions` | **ONLY** `a!queryLogicalExpression()` | Nested AND/OR logic |
| `operator` | `"AND"` or `"OR"` | How to combine filters/expressions |

---

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

**Required Pattern for Filters Using Rule Inputs:**

```sail
/* ✅ CORRECT - Use applyWhen to protect against null rule input values */
a!queryFilter(
  field: 'recordType!ChildRecord.fields.parentId',
  operator: "=",
  value: ri!parentRecord['recordType!ParentRecord.fields.id'],
  applyWhen: a!isNotNullOrEmpty(ri!parentRecord['recordType!ParentRecord.fields.id'])
)

/* ❌ WRONG - No applyWhen protection, will fail if ri!parentRecord is null */
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

---

## ✅ CHECKPOINT: Before Finalizing Query Filters

For every `a!queryFilter()` in your code, verify:
- [ ] Does the `value` parameter use a **variable** (ri! or local!)?
- [ ] If yes, have I added `applyWhen: a!isNotNullOrEmpty(value)`?
- [ ] Have I tested the interface when filter variables are null/empty?
- [ ] Are literal values (like "Active", 5, true, loggedInUser()) used without applyWhen? (correct - they're never null)

**Remember**: If a query filter's value comes from `ri!` or `local!`, it MUST have `applyWhen: a!isNotNullOrEmpty()`.

---

## Handling Sparse Aggregation Results

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

---

## 🚨 CRITICAL VIOLATIONS TO AVOID

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
