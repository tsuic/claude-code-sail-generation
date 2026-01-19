# Query Construction and Result Handling {#queries-module}

> **Parent guide:** `/conversion-guidelines/CONVERSION-PRIMARY-REFERENCE.md`
>
> **Related modules:**
> - `/conversion-guidelines/common-conversion-patterns.md` - Navigation index
> - `/conversion-guidelines/conversion-relationships.md` - Relationship navigation patterns
> - `/conversion-guidelines/conversion-field-mapping.md` - Field reference syntax
> - `/conversion-guidelines/validation-enforcement-module.md` - Query result validation

Patterns for constructing queries, handling results, and managing query parameters during mockup-to-functional conversion.

---

## 📑 Module Navigation {#queries.nav}

- `{#queries.construction}` - Query function selection and decision tree
- `{#queries.record-data}` - a!recordData() usage and restrictions
- `{#queries.query-record-type}` - a!queryRecordType() usage patterns
- `{#queries.filters-nesting}` - Filter and logical expression nesting
- `{#queries.sorts-mistake}` - Common parameter naming error
- `{#queries.result-structures}` - Query type determines property access
- `{#queries.parameters}` - fields, fetchTotalCount, applyWhen requirements
- `{#queries.operators}` - Valid operators by data type

---

## Query Construction Patterns {#queries.construction}

### Query Function Selection Decision Tree {#queries.construction.decision-tree}

**START HERE:** When converting mockup data to live queries, follow this decision tree:

```
Question 1: Will the query be reused in multiple places OR used for calculations?
├─ YES → Use a!queryRecordType() in local variable
│   └─ Question 2: What are you querying for?
│       ├─ KPI/Aggregation → Use a!aggregationFields() with a!measure()
│       │   └─ Multiple KPIs share same grouping? (e.g., counts by status)
│       │       ├─ YES → Single query with a!grouping(), extract values per KPI
│       │       └─ NO → Separate queries with different filters
│       ├─ Dropdown choices → Use fields: {...} with specific fields
│       └─ Multiple component display → Use fields: {...} with specific fields
│
└─ NO (single-use only) → Question 3: What component?
    ├─ a!gridField() → Use a!recordData() directly in data parameter
    └─ Chart component → Use a!recordData() directly in data parameter
```

**Key Rules:**
1. **Never store `a!recordData()` in a local variable** - it's syntactically invalid
2. **KPIs use aggregation queries** - don't derive from grid data via iteration
3. **Optimize related KPIs** - use grouping when KPIs share the same dimension
4. **One query per purpose** - grid query ≠ KPI query ≠ dropdown query

**💡 VISUAL DESIGN NOTE:**
Query patterns focus on data transformation only. When converting, preserve ALL visual design from mockup (layouts, components, styling). Change ONLY data sources (local! → queries, hardcoded → record fields).

---

### When to Use Each Query Method {#queries.construction.decision}

| Component Type | Query Method | Location |
|---------------|--------------|----------|
| Grids with field selections | `a!recordData()` | Directly in component |
| Grids with aggregations | `a!queryRecordType()` | Local variable |
| Charts | `a!recordData()` | Directly in component |
| KPI metrics | `a!queryRecordType()` with `a!aggregationFields()` | Local variable |
| Dropdown choices | `a!queryRecordType()` | Local variable |
| Other components | `a!queryRecordType()` | Local variable |

### a!recordData() Usage {#queries.record-data}

🚨 **CRITICAL RESTRICTION:** `a!recordData()` can ONLY be used as a direct parameter value inside:
- `a!gridField(data: a!recordData(...))`
- Chart components (e.g., `a!columnChartField(data: a!recordData(...))`)

❌ **INVALID:** Storing in a local variable
```sail
local!query: a!recordData(...)  /* SYNTAX ERROR - NOT ALLOWED */
```

✅ **VALID:** Direct usage in component

```sail
a!gridField(
  data: a!recordData(
    recordType: 'recordType!Case',
    filters: a!queryLogicalExpression(
      operator: "AND",
      filters: {
        a!queryFilter(
          field: 'recordType!Case.fields.status',
          operator: "=",
          value: "Open"
        )
      }
    )
  ),
  columns: { ... }
)
```

**If you need to reuse query results:** Use `a!queryRecordType()` instead (see next section).

### a!queryRecordType() Usage {#queries.query-record-type}

Use in local variables for non-grid/chart components:

```sail
local!cases: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: {
    'recordType!Case.fields.caseId',
    'recordType!Case.fields.title',
    'recordType!Case.fields.status'
  },
  filters: a!queryFilter(
    field: 'recordType!Case.fields.status',
    operator: "=",
    value: "Open"
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
).data,
```

**🚨 CRITICAL: Required Parameters**

Every `a!queryRecordType()` MUST have:
- [ ] `pagingInfo: a!pagingInfo(startIndex: 1, batchSize: N)` - REQUIRED parameter
- [ ] `fetchTotalCount: true` - **ALWAYS REQUIRED** (enables pagination count display)
- [ ] `fields` parameter listing ALL fields needed for display

### Filter and Logical Expression Nesting {#queries.filters-nesting}

**CRITICAL RULE:** The `filters` parameter accepts ONLY `a!queryFilter()`. Nested `a!queryLogicalExpression()` must go in the `logicalExpressions` parameter.

```sail
/* ❌ WRONG - Mixing filter types in filters array */
filters: a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(...),
    a!queryLogicalExpression(...)  /* ERROR! */
  }
)

/* ✅ CORRECT - Proper nesting */
filters: a!queryLogicalExpression(
  operator: "AND",
  filters: {
    a!queryFilter(field: '...status', operator: "=", value: "Open")
  },
  logicalExpressions: {
    a!queryLogicalExpression(
      operator: "OR",
      filters: {
        a!queryFilter(field: '...priority', operator: "=", value: "High"),
        a!queryFilter(field: '...priority', operator: "=", value: "Critical")
      }
    )
  }
)
```

### Common Mistake - sorts Parameter {#queries.sorts-mistake}

**CRITICAL:** The parameter is `sort` (singular), NOT `sorts` (plural).

```sail
/* ❌ WRONG - sorts doesn't exist */
a!queryRecordType(
  sorts: { a!sortInfo(...) }  /* Invalid parameter! */
)

/* ✅ CORRECT - sort inside pagingInfo */
a!queryRecordType(
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: {
      a!sortInfo(field: 'recordType!Case.fields.createdOn', ascending: false)
    }
  )
)
```

---

## Query Result Data Structures {#queries.result-structures}

### Universal Rule: Query Type Determines Property Access

**This principle applies to ALL components that use query results: dropdowns, checkboxes, radio buttons, forEach loops, grids, dynamic displays, etc.**

### Pattern 1: Regular Field Queries → Record Instances {#queries.result-structures.field-queries}

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

```sail
/* Dropdown/Checkbox/Radio choices */
choiceLabels: index(local!queryData, 'recordType!Type.fields.name', {})
choiceValues: index(local!queryData, 'recordType!Type.fields.id', {})

/* forEach loop */
a!forEach(
  items: local!queryData,
  expression: fv!item['recordType!Type.fields.title']
)

/* Grid column (when not using a!recordData) */
a!gridColumn(
  value: fv!row['recordType!Type.fields.status']
)
```

### Pattern 2: Aggregation Queries → Maps {#queries.result-structures.aggregation-queries}

**Query Structure:**
```sail
a!queryRecordType(
  recordType: 'recordType!Type',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: 'recordType!Type.fields.category', alias: "categoryName")
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Type.fields.id',  /* field is REQUIRED even for COUNT */
        alias: "itemCount"
      )
    }
  )
).data
```

**Returns:** Array of **maps** (untyped dictionaries with alias keys)

**Property Access:** Use **text alias** from query definition

```sail
/* Dropdown choices */
choiceLabels: index(local!aggregationData, "categoryName", {})

/* forEach loop - dot notation works */
a!forEach(
  items: local!aggregationData,
  expression: fv!item.categoryName
)

/* Direct property access - check for empty first */
local!firstCategory: if(
  a!isNotNullOrEmpty(local!aggregationData),
  local!aggregationData[1].categoryName,
  null
)
```

### Data Extraction Patterns {#queries.result-structures.extraction}

**Critical:** When no records match, `.data` returns an **empty list**. Always check before indexing.

| Query Type | Data Extraction Pattern | Example |
|------------|------------------------|---------|
| **Aggregation (no groupings)** | Check empty, then access: `if(a!isNotNullOrEmpty(query.data), query.data[1].alias, default)` | `if(a!isNotNullOrEmpty(q.data), q.data[1].total, 0)` |
| **Aggregation (with groupings)** | Check empty, then iterate with alias | `if(a!isNullOrEmpty(data), emptyState, forEach)` |
| **Regular query (single record)** | Check empty, then index: `if(a!isNotNullOrEmpty(query.data), query.data[1], null)` | See `/conversion-guidelines/validation-enforcement-module.md#validation.query-result-handling.single` |
| **Regular query (multiple rows)** | Check empty, then use `.data` | `if(a!isNullOrEmpty(query.data), emptyState, forEach)` |

**Reference:** See `/conversion-guidelines/validation-enforcement-module.md#validation.query-result-handling` for complete patterns.

### Common Mistake {#queries.result-structures.mistake}

```sail
/* ❌ WRONG - Text property names on record instances */
local!users: a!queryRecordType(
  fields: {'recordType!User.fields.username'}
).data,
choiceLabels: index(local!users, "username", {}),  /* FAILS */
a!forEach(items: local!users, expression: fv!item.username)  /* FAILS */

/* ✅ CORRECT - Record field references on record instances */
choiceLabels: index(local!users, 'recordType!User.fields.username', {}),
a!forEach(
  items: local!users,
  expression: fv!item['recordType!User.fields.username']
)
```

### Quick Decision Guide

1. **Does query use `fields: {record field references}`?** → Record instances → Use `'recordType!Type.fields.fieldName'`
2. **Does query use `a!aggregationFields(groupings, measures)`?** → Maps → Use `"aliasName"`

---

## Query Parameter Requirements {#queries.parameters}

### CRITICAL: fields Parameter {#queries.parameters.fields}

**WITHOUT the `fields` parameter, a!queryRecordType() ONLY returns the PRIMARY KEY field. All other fields will be NULL!**

```sail
/* ❌ WRONG - No fields parameter means ONLY primary key is returned */
local!submissions: a!queryRecordType(
  recordType: recordType!Submission,
  filters: a!queryFilter(...),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10)
).data
/* All fields except primary key will be null! */

/* ✅ CORRECT - Explicitly list ALL fields you need */
local!submissions: a!queryRecordType(
  recordType: recordType!Submission,
  fields: {
    recordType!Submission.fields.submissionId,      /* Primary key */
    recordType!Submission.fields.title,             /* Display field */
    recordType!Submission.fields.status,            /* Display field */
    recordType!Submission.fields.createdOn,         /* Display field */
    recordType!Submission.relationships.user.fields.name  /* Related field */
  },
  filters: a!queryFilter(...),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 10)
).data
```

### CRITICAL: fetchTotalCount Parameter {#queries.parameters.fetch-total-count}

**The `fetchTotalCount: true` parameter is ALWAYS REQUIRED on `a!queryRecordType()` calls.**

```sail
/* ❌ WRONG - Missing fetchTotalCount */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1)
),
local!count: local!caseQuery.totalCount  /* ERROR or NULL */

/* ✅ CORRECT - Include fetchTotalCount: true */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!count: local!caseQuery.totalCount  /* Returns actual count */
```

### Protecting Filters with applyWhen {#queries.parameters.apply-when}

**Variables (both ri! and local!) can be null or empty. Query filters using variables MUST use `applyWhen`.**

```sail
/* ✅ CORRECT - applyWhen protects against null */
a!queryFilter(
  field: 'recordType!Case.fields.status',
  operator: "=",
  value: local!selectedStatus,
  applyWhen: a!isNotNullOrEmpty(local!selectedStatus)
)

/* ✅ CORRECT - Rule input protection */
a!queryFilter(
  field: 'recordType!Document.fields.caseId',
  operator: "=",
  value: ri!case['recordType!Case.fields.caseId'],
  applyWhen: a!isNotNullOrEmpty(ri!case['recordType!Case.fields.caseId'])
)

/* ❌ WRONG - No applyWhen with variable value */
a!queryFilter(
  field: 'recordType!Case.fields.status',
  operator: "=",
  value: local!selectedStatus  /* May be null! */
)
```

**Key Rule**: Any filter whose `value` comes from a **variable** (ri! or local!) MUST include `applyWhen: a!isNotNullOrEmpty()`. Literal values do NOT need applyWhen.

### Valid Operators by Data Type {#queries.operators}

| Data Type | Valid Operators |
|-----------|----------------|
| **Text** | `=`, `<>`, `in`, `not in`, `starts with`, `not starts with`, `ends with`, `not ends with`, `includes`, `not includes`, `is null`, `not null`, `search` |
| **Integer, Decimal, Time** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Date, DateTime** | `=`, `<>`, `>`, `>=`, `<`, `<=`, `between`, `in`, `not in`, `is null`, `not null` |
| **Boolean** | `=`, `<>`, `in`, `not in`, `is null`, `not null` |
