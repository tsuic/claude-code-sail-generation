# Common Conversion Patterns {#common-module}

Patterns used by BOTH form and display conversions. The sail-dynamic-converter agent references this module for every conversion regardless of interface type.

---

## 📑 Module Navigation {#common.nav}

- `{#common.query-construction}` - a!recordData() and a!queryRecordType() usage
- `{#common.relationship-navigation}` - Single continuous path syntax
- `{#common.dropdown-all-option}` - Converting "All" filter options
- `{#common.data-model-validation}` - Validating record types, fields, relationships
- `{#common.environment-objects}` - Constants, groups, process models
- `{#common.pattern-matching}` - Refactoring nested if() to a!match()

---

## Query Construction Patterns {#common.query-construction}

### When to Use Each Query Method {#common.query-construction.decision}

| Component Type | Query Method | Location |
|---------------|--------------|----------|
| Grids with field selections | `a!recordData()` | Directly in component |
| Grids with aggregations | `a!queryRecordType()` | Local variable |
| Charts | `a!recordData()` | Directly in component |
| KPI metrics | `a!queryRecordType()` with `a!aggregationFields()` | Local variable |
| Dropdown choices | `a!queryRecordType()` | Local variable |
| Other components | `a!queryRecordType()` | Local variable |

### a!recordData() Usage {#common.query-construction.record-data}

Use directly within grid and chart components:

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

### a!queryRecordType() Usage {#common.query-construction.query-record-type}

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
- [ ] `fetchTotalCount: true` - Required for KPI metrics using `.totalCount`
- [ ] `fields` parameter listing ALL fields needed for display

### Filter and Logical Expression Nesting {#common.query-construction.filters-nesting}

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

### Common Mistake - sorts Parameter {#common.query-construction.sorts-mistake}

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

## Relationship Navigation Syntax {#common.relationship-navigation}

### Single Continuous Path Rule {#common.relationship-navigation.path-rule}

When accessing fields through relationships, use a SINGLE continuous path - NOT separate bracket accesses.

```sail
/* ❌ WRONG - Double bracket syntax */
fv!row['recordType!Base.relationships.related']['recordType!Target.fields.field']

/* ✅ CORRECT - Single continuous path */
fv!row['recordType!Base.relationships.related.fields.field']
```

### Path Construction from Data Model {#common.relationship-navigation.construction}

Given from `data-model-context.md`:
- **Relationship:** `'recordType!{uuid}Base.relationships.{uuid}relationshipName'`
- **Target field:** `'recordType!{uuid}Target.fields.{uuid}fieldName'`

**Construct by appending `.fields.{uuid}fieldName` to the relationship path:**

```
'recordType!{uuid}Base.relationships.{uuid}relationshipName.fields.{uuid}fieldName'
```

**Key:** Drop the target record type prefix (`'recordType!{uuid}Target`) - only append `.fields.{uuid}fieldName`.

### Many-to-One vs One-to-Many {#common.relationship-navigation.types}

| Relationship Type | Navigation | Sorting | Example |
|------------------|------------|---------|---------|
| Many-to-one | Direct field access | ✅ Can sort on related fields | Case → Status lookup |
| One-to-many | Use `a!relatedRecordData()` or `length()` | ❌ Cannot sort | Case → Comments list |

**Many-to-one (direct access):**
```sail
/* No a!relatedRecordData() needed */
fv!row['recordType!Case.relationships.status.fields.statusName']
```

**One-to-many (requires special handling):**
```sail
/* Use a!relatedRecordData() for filtering/sorting/limiting */
a!gridField(
  data: a!recordData(
    recordType: 'recordType!Case',
    relatedRecordData: {
      a!relatedRecordData(
        relationship: 'recordType!Case.relationships.comments',
        limit: 5,
        sort: a!sortInfo(
          field: 'recordType!Comment.fields.createdOn',
          ascending: false
        )
      )
    }
  )
)
```

---

## Dropdown "All" Option Conversion {#common.dropdown-all-option}

### The Problem

**NEVER use `append()` to add "All" to query results** - creates List of Variant type errors.

```sail
/* ❌ WRONG - Creates List of Variant type error */
local!typeChoiceLabels: append(
  "All Types",
  index(local!types, 'recordType!Type.fields.typeName', {})
)
```

### The Solution: Use placeholder Parameter

**Mockup Pattern (static data with hardcoded "All"):**
```sail
local!filterType: "All",  /* Initialized to "All" */
a!dropdownField(
  choiceLabels: {"All Types", "Board", "Committee"},
  choiceValues: {"All", "Board", "Committee"},
  value: local!filterType,
  saveInto: local!filterType
)

/* Filter logic checks for "All" */
a!queryFilter(
  field: 'recordType!...typeId',
  operator: "=",
  value: local!selectedTypeId,
  applyWhen: local!filterType <> "All"
)
```

**Functional Pattern (query data with placeholder):**
```sail
local!filterType,  /* Uninitialized = null = placeholder shows */

/* Query for dropdown options */
local!types: a!queryRecordType(
  recordType: 'recordType!Type',
  fields: {
    'recordType!Type.fields.typeId',
    'recordType!Type.fields.typeName'
  },
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
).data,

a!dropdownField(
  choiceLabels: index(local!types, 'recordType!Type.fields.typeName', {}),
  choiceValues: index(local!types, 'recordType!Type.fields.typeName', {}),
  value: local!filterType,
  saveInto: local!filterType,
  placeholder: "All Types"  /* Replaces the hardcoded "All" option */
)

/* Filter logic checks for null (placeholder selected) */
a!queryFilter(
  field: 'recordType!...typeId',
  operator: "=",
  value: local!selectedTypeId,
  applyWhen: a!isNotNullOrEmpty(local!filterType)  /* Changed from <> "All" */
)
```

### Conversion Checklist {#common.dropdown-all-option.checklist}

- [ ] Remove "All" from choiceLabels/choiceValues - Don't append or prepend
- [ ] Add `placeholder: "All Types"` parameter - Replaces the hardcoded option
- [ ] Leave filter variable uninitialized - `local!filterType,` (no value)
- [ ] Update filter applyWhen logic - Change `<> "All"` to `a!isNotNullOrEmpty()`

---

## Data Model Validation {#common.data-model-validation}

### Purpose

**NEVER invent record types, fields, relationships, or UUIDs** - ONLY use what exists in `context/data-model-context.md`.

### Relationship Target Validation {#common.data-model-validation.relationships}

For EVERY relationship you plan to navigate:

**Step 1: Find relationship in source record type**
```
Source: Case
Relationship: assignedTo
Reference: 'recordType!Case.relationships.assignedTo'
Type: many-to-one
```

**Step 2: Find target record type definition**
- Search `data-model-context.md` for the target record type section
- Example: Relationship "assignedTo" → Search for "### Employee"

**Step 3: Decision Tree**

| Scenario | Action |
|----------|--------|
| Target record type IS defined | ✅ Proceed - use fields from target's Fields table |
| Target record type NOT defined | ⚠️ Check for foreign key fallback (Step 3A below) |

### Foreign Key Fallback Pattern {#common.data-model-validation.fk-fallback}

When relationship target is NOT found in data-model-context.md:

**Step 3A.1: Check for foreign key ID field**
- Go to source record type's Fields table
- Look for ID field matching relationship name:
  - Relationship: `caseType` → Look for: `caseTypeId` (Integer)
  - Relationship: `assignedTo` → Look for: `assignedToUser` (User)

**Step 3A.2: Decision**

| Found | Action |
|-------|--------|
| Foreign key ID field exists | Use direct field instead of relationship navigation |
| No foreign key found | Revert to mockup data pattern (preserve UX) |

**Example - Using foreign key fallback:**
```sail
/* TODO: Target record type for relationship 'caseType' not found
 * Cannot navigate: Case.relationships.caseType.fields.typeName
 * WORKAROUND: Using foreign key ID field 'caseTypeId' instead */
local!typeId: local!case['recordType!Case.fields.caseTypeId'],

value: if(
  a!isNullOrEmpty(local!typeId),
  "[Type not available]",
  "Type ID: " & local!typeId
)
```

**Example - Mockup data fallback (preserve UX):**
```sail
/* MOCKUP DATA - Client Profile View (Data Model Limitation):
 * Client record type not available in context/data-model-context.md
 * Using hardcoded sample data to preserve UX flow
 *
 * TODO: Add Client record type to enable live data */
local!clientCases: {
  a!map(caseNumber: "CASE-001", subject: "Sample Case", status: "Open"),
  a!map(caseNumber: "CASE-002", subject: "Another Sample", status: "Closed")
},

/* Visual indicator in UI */
a!richTextItem(text: "(Sample Data)", size: "SMALL", color: "#6B7280")
```

### Field Access Validation {#common.data-model-validation.fields}

For EVERY field you plan to access:

**Step 1:** Locate record type in `data-model-context.md`

**Step 2:** Verify correct Fields table (for relationships, use TARGET record type)

**Step 3:** Decision Tree

| Scenario | Action |
|----------|--------|
| Exact field name exists | ✅ Use field reference from table |
| Similar field exists | ✅ Use with ASSUMPTION comment |
| No match found | ❌ Use placeholder with TODO comment |

**Example - Similar field substitution:**
```sail
/* ASSUMPTION: No fullName field exists in Employee record type
 * Using firstName and lastName fields instead
 * Source: context/data-model-context.md Employee Fields table */
local!assigneeName: concat(
  a!defaultValue(ri!case['recordType!Case.relationships.assignedTo.fields.firstName'], ""),
  " ",
  a!defaultValue(ri!case['recordType!Case.relationships.assignedTo.fields.lastName'], "")
)
```

---

## Environment Object Validation {#common.environment-objects}

### Purpose

Never assume constants, groups, process models, or folders exist in the target environment.

### Environment References to Check {#common.environment-objects.checklist}

- [ ] **Constants** (`cons!*`) - Configuration values, groups, folders
- [ ] **Process Models** - Any `processModel` parameter value
- [ ] **Document Folders** - Any `target` parameter for file uploads
- [ ] **Groups** - Any `groups` parameter in `a!isUserMemberOfGroup()`
- [ ] **Expression Rules** (`rule!*`) - Unless explicitly required

### Handling Missing Environment Objects {#common.environment-objects.handling}

**Case A: Reference exists in mockup as simple pattern**
```sail
/* Mockup had: local!userRole = "Partner" */
/* ✅ KEEP IT - Don't convert to a!isUserMemberOfGroup() with constants */
local!isPartner: local!userRole = "Partner",
```

**Case B: Reference needed but doesn't exist**
```sail
/* TODO: Configure group constant for Partners access control
 * Create: cons!PARTNERS_GROUP
 * Assign all partner users to this group */
local!isPartner: a!isUserMemberOfGroup(
  username: loggedInUser(),
  groups: null /* TODO: Add group constant */
),

a!fileUploadField(
  label: "Upload Document",
  target: null, /* TODO: Add folder constant (cons!DOCUMENTS_FOLDER) */
  value: local!upload,
  saveInto: local!upload
)
```

---

## Pattern Matching Refactoring {#common.pattern-matching}

### When to Refactor nested if() to a!match()

**MANDATORY when:**
- Single variable compared against 3+ distinct enumerated values
- Pattern matching for: status codes, priorities, categories, types

**DO NOT refactor when:**
- Complex conditional logic with multiple variables
- Null safety checks (keep nested if() for short-circuit)
- Computed variables with side effects

### Refactoring Example {#common.pattern-matching.example}

```sail
/* ❌ BEFORE (nested if) - OUTDATED PATTERN */
if(status = "Open", "folder-open",
  if(status = "Closed", "check-circle",
    if(status = "Pending", "clock", "file")))

/* ✅ AFTER (a!match) - MODERN PATTERN */
a!match(
  value: status,
  equals: "Open", then: "folder-open",
  equals: "Closed", then: "check-circle",
  equals: "Pending", then: "clock",
  default: "file"
)
```

### Range-Based Comparisons with whenTrue {#common.pattern-matching.ranges}

For date ranges, numeric thresholds, or complex conditions:

```sail
a!match(
  value: true,
  whenTrue: fv!row.daysOverdue > 30, then: "#DC2626",  /* Red */
  whenTrue: fv!row.daysOverdue > 14, then: "#F59E0B",  /* Amber */
  whenTrue: fv!row.daysOverdue > 0, then: "#EAB308",   /* Yellow */
  default: "#10B981"  /* Green */
)
```

**Reference:** See `/logic-guidelines/pattern-matching.md` for complete a!match() patterns.
