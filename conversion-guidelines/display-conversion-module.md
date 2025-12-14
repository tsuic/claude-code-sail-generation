# Display Conversion Module {#display-module}

Patterns for converting read-only display interfaces: dashboards, KPIs, charts, grids, and list views.

---

## 📑 Module Navigation {#display.nav}

- `{#display.detection}` - How to identify display interfaces
- `{#display.chart-refactoring}` - Mandatory chart pattern conversion
- `{#display.chart-refactoring.grouping-fields}` - Grouping field validation
- `{#display.kpi-aggregation}` - KPI metric calculations
- `{#display.grid-patterns}` - Grid conversion patterns
- `{#display.grid-patterns.sortfield-rules}` - Grid column sorting rules
- `{#display.record-links}` - Converting navigation links
- `{#display.action-buttons}` - Record actions and related actions

---

## Interface Detection {#display.detection}

### Display Interface Indicators

A mockup is a **Display Interface** if it contains:

| Indicator | Example |
|-----------|---------|
| Dashboard layout | KPI cards, charts, summary metrics |
| Report/Analytics | Aggregated data, trends, comparisons |
| List views | Read-only grids with filter/search |
| Detail views | Record information display (no edit) |
| Charts | Bar, line, pie, column charts |
| No submission buttons | View/filter only controls |

### Decision Tree

```
Does interface primarily display data?
├─ YES → Continue checking
│   └─ Does it have charts or KPIs?
│       ├─ YES → Use DISPLAY MODULE with chart/KPI patterns
│       └─ NO → Use DISPLAY MODULE with grid patterns
│
└─ NO (creates/updates data) → Use FORM CONVERSION MODULE
```

### Display Interface Types

| Type | Characteristics | Key Patterns |
|------|-----------------|--------------|
| Dashboard | KPIs + charts + summary grid | Aggregation queries, chart config |
| Report | Filtered data grid + export | a!recordData(), sortField rules |
| List View | Searchable/filterable grid | Filters with applyWhen |
| Detail View | Single record display | Query by ID, relationship navigation |

---

## Chart Pattern Refactoring {#display.chart-refactoring}

### MANDATORY Refactoring

**All charts with record data MUST use the data + config pattern, NOT the categories + series pattern.**

### Mockup vs Record Data Pattern {#display.chart-refactoring.mockup-to-record}

```sail
/* ❌ MOCKUP PATTERN - Works with hardcoded data */
a!columnChartField(
  categories: {"Q1", "Q2", "Q3", "Q4"},
  series: {
    a!chartSeries(
      label: "Revenue",
      data: {100000, 125000, 150000, 175000}
    )
  }
)

/* ✅ RECORD DATA PATTERN - Required for live data */
a!columnChartField(
  data: a!recordData(
    recordType: 'recordType!Sale',
    filters: a!queryFilter(
      field: 'recordType!Sale.fields.year',
      operator: "=",
      value: 2024
    )
  ),
  config: a!columnChartConfig(
    primaryGrouping: a!grouping(
      field: 'recordType!Sale.fields.quarter',
      alias: "quarter"
    ),
    measures: {
      a!measure(
        function: "SUM",
        field: 'recordType!Sale.fields.amount',
        alias: "totalRevenue"
      )
    }
  )
)
```

### Chart Config Functions {#display.chart-refactoring.config-functions}

| Chart Type | Config Function |
|------------|-----------------|
| Column chart | `a!columnChartConfig()` |
| Bar chart | `a!barChartConfig()` |
| Line chart | `a!lineChartConfig()` |
| Pie chart | `a!pieChartConfig()` |
| Area chart | `a!areaChartConfig()` |

### Config Function Parameters

```sail
a!columnChartConfig(
  primaryGrouping: a!grouping(
    field: 'recordType!Record.fields.categoryField',
    alias: "category"
  ),
  secondaryGrouping: a!grouping(  /* Optional - for stacked/grouped charts */
    field: 'recordType!Record.fields.seriesField',
    alias: "series"
  ),
  measures: {
    a!measure(
      function: "COUNT",  /* or "SUM", "AVG", "MIN", "MAX", "DISTINCT_COUNT" */
      field: 'recordType!Record.fields.measureField',  /* Required for SUM/AVG/MIN/MAX */
      alias: "count"
    )
  },
  sort: {
    a!chartSort(field: "category", ascending: true)
  }
)
```

### Grouping Field Validation {#display.chart-refactoring.grouping-fields}

**🚨 BLOCKING GATE** - Cannot write chart code until grouping fields are validated.

**Rule:** Grouping fields MUST be Text, Date, DateTime, or Boolean. Integer/Decimal fields require relationship navigation to Text.

| Field Data Type | Action |
|-----------------|--------|
| **Text** | ✅ Use directly |
| **Date/DateTime** | ✅ Use with `interval` parameter |
| **Boolean** | ✅ Use directly |
| **Integer/Decimal** | ❌ STOP - Find Text alternative |

### Integer/Decimal Grouping Field Fix {#display.chart-refactoring.integer-fix}

When grouping field is Integer (e.g., foreign key ID):

**Step 1:** Find the relationship in data-model-context.md
```
Field: organizationTypeId (Integer)
Relationship: organizationType → ORGANIZATION_TYPE record type
```

**Step 2:** Find Text field in target record type
```
ORGANIZATION_TYPE Fields:
- typeId (Integer) - primary key
- typeName (Text) ← USE THIS
```

**Step 3:** Use relationship navigation
```sail
/* ❌ WRONG - Integer field */
primaryGrouping: a!grouping(
  field: 'recordType!Submission.fields.organizationTypeId',
  alias: "type"
)

/* ✅ CORRECT - Navigate to Text field */
primaryGrouping: a!grouping(
  field: 'recordType!Submission.relationships.organizationType.fields.typeName',
  alias: "type"
)
```

### Date/DateTime Grouping with Intervals {#display.chart-refactoring.intervals}

When grouping by Date or DateTime:

```sail
a!grouping(
  field: 'recordType!Sale.fields.saleDate',
  alias: "period",
  interval: "MONTH_SHORT_TEXT"  /* or "YEAR", "DATE_TEXT", "MONTH_OF_YEAR_NUMBER" */
)
```

**Common interval values:**
| Interval | Example Output |
|----------|----------------|
| `"MONTH_SHORT_TEXT"` | "Jan", "Feb", "Mar" |
| `"MONTH_TEXT"` | "January", "February" |
| `"YEAR"` | "2024", "2025" |
| `"DATE_TEXT"` | "Jan 15, 2024" |
| `"MONTH_OF_YEAR_NUMBER"` | 1, 2, 3 |

---

## KPI Aggregation Patterns {#display.kpi-aggregation}

### Single Value KPI {#display.kpi-aggregation.single}

For KPIs showing a single metric (total count, sum, average):

```sail
local!totalCases: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: a!aggregationFields(
    measures: {
      a!measure(function: "COUNT", alias: "total")
    }
  ),
  filters: a!queryFilter(
    field: 'recordType!Case.fields.status',
    operator: "=",
    value: "Open"
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1)
),

/* Extract value */
local!totalCount: if(
  a!isNotNullOrEmpty(local!totalCases.data),
  local!totalCases.data[1].total,
  0
),

/* Display in KPI card */
a!richTextDisplayField(
  value: a!richTextItem(
    text: local!totalCount,
    size: "LARGE_PLUS",
    style: "STRONG"
  )
)
```

### Grouped KPIs {#display.kpi-aggregation.grouped}

For KPIs showing breakdown by category:

```sail
local!casesByStatus: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(field: 'recordType!Case.fields.status', alias: "status")
    },
    measures: {
      a!measure(function: "COUNT", alias: "count")
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
).data,

/* Access grouped results */
a!forEach(
  items: local!casesByStatus,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: {
          a!richTextItem(text: fv!item.status, style: "STRONG"),
          a!richTextItem(text: fv!item.count, size: "LARGE")
        }
      )
    }
  )
)
```

### Value Extraction Patterns {#display.kpi-aggregation.extraction}

**Aggregation queries return maps, NOT record instances:**

```sail
/* ✅ CORRECT - Use alias as text property */
local!totalCases.data[1].total          /* Dot notation */
index(local!totalCases.data[1], "total", 0)  /* index() with default */

/* ❌ WRONG - Record field reference doesn't work on maps */
local!totalCases.data[1]['recordType!Case.fields.count']
```

**Reference:** See `/record-query-guidelines/query-result-structures.md` for complete property access patterns.

---

## Grid Patterns {#display.grid-patterns}

### Read-Only Grid with a!recordData()

```sail
a!gridField(
  label: "Active Cases",
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
  columns: {
    a!gridColumn(
      label: "Case Number",
      value: fv!row['recordType!Case.fields.caseNumber'],
      sortField: 'recordType!Case.fields.caseNumber'
    ),
    a!gridColumn(
      label: "Subject",
      value: fv!row['recordType!Case.fields.subject'],
      sortField: 'recordType!Case.fields.subject'
    ),
    a!gridColumn(
      label: "Status",
      value: fv!row['recordType!Case.fields.status'],
      sortField: 'recordType!Case.fields.status'
    )
  },
  pageSize: 20,
  showSearchBox: true,
  showRefreshButton: true
)
```

### sortField Rules {#display.grid-patterns.sortfield-rules}

**🚨 BLOCKING GATE** - sortField MUST end with `.fields.fieldName`

| sortField Pattern | Valid? | Fix |
|-------------------|--------|-----|
| `...fields.fieldName` | ✅ | Direct field - valid |
| `...relationships.rel.fields.fieldName` | ✅ | Related field (many-to-one) - valid |
| `...relationships.rel` | ❌ | Missing field - append `.fields.fieldName` |
| No `.fields.` anywhere | ❌ | Invalid - use proper field path |

**Common mistake:**
```sail
/* ❌ WRONG - Relationship only, no field */
sortField: 'recordType!Case.relationships.status'

/* ✅ CORRECT - Navigate to sortable field */
sortField: 'recordType!Case.relationships.status.fields.statusName'
```

### Grid with Related Record Data {#display.grid-patterns.related-data}

For grids needing one-to-many relationship data:

```sail
a!gridField(
  data: a!recordData(
    recordType: 'recordType!Case',
    relatedRecordData: {
      a!relatedRecordData(
        relationship: 'recordType!Case.relationships.comments',
        limit: 1,
        sort: a!sortInfo(
          field: 'recordType!Comment.fields.createdOn',
          ascending: false
        )
      )
    }
  ),
  columns: {
    /* Access latest comment through relationship */
    a!gridColumn(
      label: "Latest Comment",
      value: if(
        a!isNotNullOrEmpty(fv!row['recordType!Case.relationships.comments']),
        index(fv!row['recordType!Case.relationships.comments'], 1, null)['recordType!Comment.fields.text'],
        "No comments"
      )
    )
  }
)
```

---

## Record Links {#display.record-links}

### Converting dynamicLink to recordLink

Mockups use `a!dynamicLink()` as placeholders. Convert to `a!recordLink()` for record navigation.

### Detection

```bash
grep -n "a!dynamicLink" output/[mockup-file].sail
```

### Conversion Patterns {#display.record-links.patterns}

| Context | Identifier Source |
|---------|-------------------|
| Grid with `a!recordData()` | `fv!identifier` |
| `a!forEach()` over query `.data` | `fv!item[recordType!Record.fields.primaryKey]` |
| Detail view interface | `ri!recordId` |

**Grid column with record link:**
```sail
/* ❌ MOCKUP */
a!richTextItem(
  text: fv!row.caseNumber,
  link: a!dynamicLink(value: fv!row.id, saveInto: {})
)

/* ✅ FUNCTIONAL */
a!richTextItem(
  text: fv!row['recordType!Case.fields.caseNumber'],
  link: a!recordLink(
    recordType: 'recordType!Case',
    identifier: fv!identifier
  ),
  linkStyle: "STANDALONE"
)
```

**forEach over query results:**
```sail
/* In a!forEach where items come from a!queryRecordType().data */
a!richTextItem(
  text: fv!item['recordType!Case.fields.caseNumber'],
  link: a!recordLink(
    recordType: 'recordType!Case',
    identifier: fv!item['recordType!Case.fields.caseId']  /* Primary key field */
  )
)
```

---

## Action Buttons {#display.action-buttons}

### Record Actions (Create New) {#display.action-buttons.record-actions}

Use when action does NOT require a specific record identifier (e.g., "Create New Case").

```sail
/* ❌ MOCKUP */
a!buttonArrayLayout(
  buttons: {
    a!buttonWidget(
      label: "Create New Case",
      icon: "plus-circle",
      style: "SOLID",
      color: "ACCENT"
      /* TODO: Configure startProcess */
    )
  }
)

/* ✅ FUNCTIONAL */
a!recordActionField(
  actions: {
    a!recordActionItem(
      action: 'recordType!Case.actions.createCase'  /* From data-model-context.md */
    )
  },
  style: "TOOLBAR_PRIMARY",
  display: "LABEL_AND_ICON",
  align: "END"
)
```

### Related Actions (Edit/Delete) {#display.action-buttons.related-actions}

Use when action REQUIRES a specific record identifier (e.g., "Edit This Case").

**Key difference:** Related actions need `identifier` parameter.

**Grid row edit button:**
```sail
/* In grid column */
a!gridColumn(
  label: "Actions",
  value: a!recordActionField(
    actions: {
      a!recordActionItem(
        action: 'recordType!Case.actions.editCase',
        identifier: fv!identifier  /* From a!recordData() */
      )
    },
    style: "LINKS",
    display: "ICON"
  ),
  width: "ICON"
)
```

**Grid recordActions parameter:**
```sail
a!gridField(
  data: a!recordData(recordType: 'recordType!Case'),
  columns: { /* ... */ },
  recordActions: {
    a!recordActionItem(
      action: 'recordType!Case.actions.editCase',
      identifier: fv!identifier
    ),
    a!recordActionItem(
      action: 'recordType!Case.actions.deleteCase',
      identifier: fv!identifier
    )
  }
)
```

### Style Mapping {#display.action-buttons.style-mapping}

| Mockup Button Style | Record Action Style |
|---------------------|---------------------|
| `style: "SOLID", color: "ACCENT"` | `style: "TOOLBAR_PRIMARY"` |
| `style: "SOLID", color: "SECONDARY"` | `style: "TOOLBAR"` |
| `style: "OUTLINE"` | `style: "TOOLBAR"` |
| `style: "LINK"` | `style: "LINKS"` |

### Action Reference Validation {#display.action-buttons.validation}

- [ ] Action reference copied exactly from `data-model-context.md` **Record Actions** section
- [ ] UUIDs are complete (not placeholders)
- [ ] Related Actions have `identifier` parameter
- [ ] Identifier source matches context (`fv!identifier` for grids, `ri!recordId` for details)

---

## Display Conversion Checklist {#display.checklist}

Before completing display conversion:

**Charts:**
- [ ] All charts use data + config pattern (NOT categories + series)
- [ ] Chart config function matches chart type
- [ ] All grouping fields validated (Text, Date, DateTime, Boolean - no Integer)
- [ ] Integer FK groupings converted to relationship navigation to Text
- [ ] Date groupings have appropriate interval parameter

**KPIs:**
- [ ] Aggregation queries use `a!aggregationFields()` with `a!measure()`
- [ ] `a!measure()` function is valid: COUNT, SUM, AVG, MIN, MAX, DISTINCT_COUNT
- [ ] Value extraction uses alias (text property), not record field reference
- [ ] Null checks on aggregation results before display

**Grids:**
- [ ] All sortField values end with `.fields.fieldName`
- [ ] No sortField references relationship without field
- [ ] One-to-many relationships use `a!relatedRecordData()`
- [ ] Grid columns use `fv!row` (not `fv!index` or `fv!item`)

**Links and Actions:**
- [ ] `a!dynamicLink()` converted to `a!recordLink()`
- [ ] Record link identifier matches context
- [ ] Record actions converted to `a!recordActionField()`
- [ ] Related actions have `identifier` parameter
- [ ] Action references from data-model-context.md (with UUIDs)
