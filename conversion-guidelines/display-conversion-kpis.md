# Display Conversion - KPI Patterns {#display-kpis}

> **Parent guide:** `/conversion-guidelines/CONVERSION-PRIMARY-REFERENCE.md`
>
> **Related modules:**
> - `/conversion-guidelines/display-conversion-core.md` - Interface detection
> - `/conversion-guidelines/common-conversion-patterns.md` - Query patterns
> - `/conversion-guidelines/validation-enforcement-module.md` - Post-conversion validation
>
> **Foundational rules:** `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md`

Patterns for converting KPI metrics from static values to aggregation queries, including value extraction and null safety.

---

## 📑 Module Navigation {#display-kpis.nav}

- `{#display-kpis.aggregation}` - KPI aggregation patterns
- `{#display-kpis.aggregation.grouped}` - Related KPIs (shared grouping)
- `{#display-kpis.aggregation.single}` - Unrelated KPIs (different filters)
- `{#display-kpis.aggregation.extraction}` - Value extraction patterns

---

## KPI Aggregation Patterns {#display-kpis.aggregation}

🚨 **REUSE PREVENTION RULE:**

**KPIs MUST use dedicated aggregation queries with `a!queryRecordType()`.** Never try to reuse grid queries or derive KPIs by iterating over query results.

❌ **WRONG:** Storing a!recordData() in variable
```sail
local!gridQuery: a!recordData(...),  /* SYNTAX ERROR - can't store a!recordData */
```

❌ **WRONG:** Deriving KPIs from grid data via iteration
```sail
local!items: a!queryRecordType(...).data,
local!active: length(wherecontains(true, a!forEach(items: local!items, ...)))
/* Inefficient - should use aggregation query */
```

✅ **CORRECT:** Use aggregation queries (patterns below)

**💡 VISUAL DESIGN NOTE:**
These examples show data transformation patterns only (query construction and value extraction). The mockup's visual design (cardLayout, sideBySideLayout, stampField, colors, spacing, etc.) MUST be preserved exactly during conversion. Only the data sources change - the UX components stay identical.

---

### Pattern 1: Related KPIs (Shared Grouping) {#display-kpis.aggregation.grouped}

**Use when:** Multiple KPIs break down the same dataset by a common dimension (status, type, category, etc.)

**Example:** Open count, Closed count, In Progress count (all grouped by status)

```sail
/* Single query with grouping returns all status counts */
local!casesByStatus: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: 'recordType!Case.fields.status', alias: "status")
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Case.fields.id',  /* Required even for COUNT */
        alias: "count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
).data,

/* Extract individual KPI values using dot notation + array indexing */
local!openCount: if(
  a!isNotNullOrEmpty(local!casesByStatus),
  if(
    contains("Open", local!casesByStatus.status),
    local!casesByStatus.count[
      wherecontains("Open", local!casesByStatus.status)[1]
    ],
    0
  ),
  0
),

local!closedCount: if(
  a!isNotNullOrEmpty(local!casesByStatus),
  if(
    contains("Closed", local!casesByStatus.status),
    local!casesByStatus.count[
      wherecontains("Closed", local!casesByStatus.status)[1]
    ],
    0
  ),
  0
),

local!inProgressCount: if(
  a!isNotNullOrEmpty(local!casesByStatus),
  if(
    contains("In Progress", local!casesByStatus.status),
    local!casesByStatus.count[
      wherecontains("In Progress", local!casesByStatus.status)[1]
    ],
    0
  ),
  0
),

/* Display in KPI cards */
a!cardLayout(
  contents: {
    a!richTextDisplayField(
      value: {
        a!richTextItem(text: "Open Cases", size: "STANDARD", color: "SECONDARY"),
        char(10),
        a!richTextItem(text: local!openCount, size: "LARGE", style: "STRONG")
      }
    )
  }
)
```

**Alternative: Using a!forEach() when order is predictable**

If you know the exact order of grouped results or need to iterate through all groups:

```sail
local!casesByStatus: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: 'recordType!Case.fields.status', alias: "status")
    },
    measures: {
      a!measure(function: "COUNT", field: 'recordType!Case.fields.id', alias: "count")
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
).data,

/* Iterate through all status groups to create dynamic KPI cards */
a!forEach(
  items: local!casesByStatus,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: {
          a!richTextItem(text: fv!item.status, size: "STANDARD", color: "SECONDARY"),
          char(10),
          a!richTextItem(text: fv!item.count, size: "LARGE", style: "STRONG")
        }
      )
    }
  )
)
```

**When to use this pattern:**
- ✅ Multiple KPIs showing counts/sums BY the same field (status, type, category, priority)
- ✅ You know the specific grouping values ahead of time
- ✅ Values are relatively stable (e.g., "Open", "Closed" statuses won't change frequently)

**Dot notation access patterns:**
- `local!casesByStatus.status` → Array of all status values `{"Open", "Closed", "In Progress"}`
- `local!casesByStatus.count` → Array of all count values `{15, 23, 8}`
- `local!casesByStatus.count[1]` → First count value (positional access)
- `wherecontains("Open", local!casesByStatus.status)[1]` → Position of "Open" in status array

---

### Pattern 2: Unrelated KPIs (Different Filters) {#display-kpis.aggregation.single}

**Use when:** KPIs have different filter criteria and can't share a common grouping

**Example:** Total submissions, Active memberships (no end date), Pending review submissions

```sail
/* Total count - no filters */
local!totalCount: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
).data[1].count,

/* Active count - filter by null end date */
local!activeCount: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "count"
      )
    }
  ),
  filters: a!queryFilter(
    field: 'recordType!Submission.fields.endDate',
    operator: "is null"
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
).data[1].count,

/* Pending count - filter by status AND date range */
local!pendingCount: a!queryRecordType(
  recordType: 'recordType!Submission',
  fields: a!aggregationFields(
    measures: {
      a!measure(
        function: "COUNT",
        field: 'recordType!Submission.fields.id',
        alias: "count"
      )
    }
  ),
  filters: a!queryLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: 'recordType!Submission.fields.status',
        operator: "=",
        value: "Pending Review"
      ),
      a!queryFilter(
        field: 'recordType!Submission.fields.submittedDate',
        operator: ">",
        value: today() - 30
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
).data[1].count
```

**When to use this pattern:**
- ✅ KPIs have completely different filter criteria
- ✅ Can't be grouped by a single common dimension
- ✅ Each KPI represents a distinct business metric

---

### Value Extraction Patterns {#display-kpis.aggregation.extraction}

**Aggregation queries return maps, NOT record instances:**

```sail
/* ✅ CORRECT - Use alias as property via dot notation */
local!result.data[1].count          /* Single value from aggregation */
local!grouped.status                /* Array of status values from grouping */
local!grouped.count                 /* Array of count values from grouping */
local!grouped.count[1]              /* First count value (positional) */

/* ❌ WRONG - Record field reference doesn't work on aggregation maps */
local!result.data[1]['recordType!Case.fields.count']  /* Invalid */
```

**Null safety for aggregation results:**

```sail
/* Always check .data before indexing - Pattern 2 (single value) */
local!count: if(
  a!isNotNullOrEmpty(local!query.data),
  local!query.data[1].count,
  0  /* Default when no results */
)

/* Check for empty results before accessing grouped data - Pattern 1 */
local!openCount: if(
  a!isNotNullOrEmpty(local!casesByStatus),
  if(
    contains("Open", local!casesByStatus.status),
    local!casesByStatus.count[
      wherecontains("Open", local!casesByStatus.status)[1]
    ],
    0
  ),
  0
)
```

**Reference:** See `/conversion-guidelines/common-conversion-patterns.md#common.query-result-structures` for complete property access patterns.

---

## KPI Conversion Checklist {#display-kpis.checklist}

**KPIs:**
- [ ] Aggregation queries use `a!aggregationFields()` with `a!measure()`
- [ ] `a!measure()` function is valid: COUNT, SUM, AVG, MIN, MAX, DISTINCT_COUNT
- [ ] **`a!measure()` has ALL 3 required parameters: `function`, `field`, `alias`** (field is required even for COUNT!)
- [ ] Value extraction uses alias (text property), not record field reference
- [ ] Null checks on aggregation results before display
- [ ] Related KPIs (shared dimension) use Pattern 1 (grouped query)
- [ ] Unrelated KPIs (different filters) use Pattern 2 (separate queries)
- [ ] Mockup visual design preserved exactly (only data sources changed)
