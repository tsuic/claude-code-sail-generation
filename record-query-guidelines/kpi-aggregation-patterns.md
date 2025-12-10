# Dashboard KPI Aggregation Patterns {#kpi-aggregation-patterns}

> **Parent guide:** `record-type-handling-guidelines.md`
>
> **Related:**
> - `record-query-guidelines/query-result-structures.md` (query patterns)
> - `record-query-guidelines/query-filters-operators.md` (filter patterns)

---

## Core Rule

For dashboards and reports displaying KPIs, **ALWAYS prefer database aggregations over array processing** to avoid the 5,000 record limit and improve performance.

---

## ❌ WRONG: Array Processing (Slow, Limited to 5,000 Records)

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

---

## ✅ RIGHT: Database Aggregation (Fast, Scalable)

### Single Aggregation (No Grouping)

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

### Grouped Aggregations

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

### Multiple Measures

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

---

## Value Extraction Pattern

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

---

## Valid a!measure() Functions

| Function | Description | Field Required? |
|----------|-------------|-----------------|
| `"COUNT"` | Count records | Yes (any field) |
| `"SUM"` | Sum numeric values | Yes (numeric field) |
| `"AVG"` | Average numeric values | Yes (numeric field) |
| `"MIN"` | Minimum value | Yes |
| `"MAX"` | Maximum value | Yes |
| `"DISTINCT_COUNT"` | Count unique values | Yes |

---

## Complete KPI Examples

### Total Count

```sail
local!totalCasesQuery: a!queryRecordType(
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
local!totalCases: a!defaultValue(
  local!totalCasesQuery.data.case_count,
  0
)
```

### Filtered Count

```sail
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
local!openCases: a!defaultValue(
  local!openCasesQuery.data.open_count,
  0
)
```

### Sum

```sail
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
local!totalRevenue: a!defaultValue(
  local!revenueSumQuery.data.total_revenue,
  0
)
```

### Average

```sail
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
local!avgOrderValue: a!defaultValue(
  local!avgOrderQuery.data.avg_order,
  0
)
```

---

## When to Use Each Approach

| Use Case | Correct Approach | Why |
|----------|-----------------|-----|
| **KPI counts (dashboard metrics)** | `a!aggregationFields()` with `a!measure()` | Better performance, database-level calculation |
| **KPI calculations (SUM, AVG, MIN, MAX)** | `a!aggregationFields()` with `a!measure()` | ONLY way to calculate these metrics |
| **Pagination info in grids** | `.totalCount` property | Appropriate for showing "Showing X of Y results" |
| **Simple count for conditional logic** | `.totalCount` property | OK for one-off checks like "if(query.totalCount > 0)" |

---

## Key Benefits of Aggregations for KPIs

- Better performance (database-level calculation)
- Consistent pattern for all metrics (COUNT, SUM, AVG, MIN, MAX, etc.)
- More maintainable and scalable
- Leverages record type's query optimization
- Allows grouping and multiple measures in one query

---

## Batch Size Guidelines

- **Grouped results**: `batchSize: 5000` (supports up to 5,000 unique groups)
- **Single aggregation with no grouping**: `batchSize: 1` (returns exactly 1 row)
- **❌ NEVER**: `batchSize: -1` (deprecated/not supported)

---

## Common Mistakes to Avoid

```sail
/* ❌ MISTAKE 1: Array indexing on aggregations with no groupings */
local!kpiQuery: a!queryRecordType(
  fields: a!aggregationFields(groupings: {}, measures: {...})
),
local!value: local!kpiQuery.data[1].alias  /* WRONG - no need for [1] */

/* ✅ CORRECT */
local!value: local!kpiQuery.data.alias  /* Direct access */

/* ❌ MISTAKE 2: Using .totalCount for KPIs */
local!caseQuery: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: {'recordType!Case.fields.id'},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!totalCases: local!caseQuery.totalCount  /* AVOID - Use aggregation instead */

/* ❌ MISTAKE 3: Over-complicated extraction */
local!value: index(index(query.data, 1, {}).field, 1, null)  /* Too complex */

/* ✅ CORRECT - Simple pattern for aggregations */
local!value: a!defaultValue(query.data.field, defaultValue)
```

---

## MANDATORY Rule

**ALWAYS use `a!aggregationFields()` for dashboard KPIs, metrics, and statistics. Only use `.totalCount` for pagination display or simple conditional checks.**
