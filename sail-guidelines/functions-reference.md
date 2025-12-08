# Essential Functions Reference {#functions-reference}

> **Parent guides:**
> - `dynamic-sail-expression-guidelines.md` (mock data interfaces)
> - `record-type-handling-guidelines.md` (record types & queries)
>
> **Full API Reference:** `/ui-guidelines/reference/sail-api-schema.json`

---

## Critical Validation Rule

⚠️ **CRITICAL: Verify ALL functions exist in `/ui-guidelines/reference/sail-api-schema.json` before use**

### Functions That DO NOT Exist:
- `a!isPageLoad()` - Use pattern: `local!showValidation: false()` + set to `true()` on button click
- `property()` - Use dot notation instead: `object.field`
- `a!dateTimeValue()` - Use `dateTime()` instead

### Deprecated/Invalid Parameter Values:
- `batchSize: -1` - Use `batchSize: 5000` (queries), `batchSize: 1` (single aggregations)

---

## Preferred Functions

| Instead Of | Use | Reason |
|------------|-----|--------|
| `isnull()` | `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()` | More comprehensive null checking |
| Infix `&&`, `||` | `and()`, `or()`, `not()` | Appian syntax |
| `map()` | `a!forEach()` | Standard looping |
| `choose()` | `a!match()` | Better pattern matching |

### Other Preferred Patterns:
- **Array Operations**: `append()`, `a!update()` for immutable operations
- **Audit Functions**: `loggedInUser()`, `now()` for audit fields

---

## Quick Function Reference by Category

| Category | Functions |
|----------|-----------|
| **Array** | `a!flatten()`, `append()`, `index()`, `length()`, `where()`, `wherecontains()`, `intersection()`, `union()`, `difference()` |
| **Logical** | `and()`, `or()`, `not()`, `if()`, `a!match()` |
| **Null Checking** | `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()`, `a!defaultValue()` |
| **Looping** | `a!forEach()`, `filter()`, `reduce()`, `merge()` |
| **Text** | `concat()`, `find()`, `left()`, `right()`, `len()`, `substitute()`, `upper()`, `lower()`, `trim()` |
| **Date/Time** | `today()`, `now()`, `dateTime()`, `date()`, `time()`, `todate()`, `todatetime()`, `a!addDateTime()`, `a!subtractDateTime()` |
| **JSON** | `a!toJson()`, `a!fromJson()`, `a!jsonPath()` |
| **User/System** | `loggedInUser()`, `user()`, `group()` |
| **Query** | `a!queryRecordType()`, `a!recordData()`, `a!queryFilter()`, `a!pagingInfo()`, `a!aggregationFields()`, `a!measure()`, `a!grouping()` |

---

## JSON Functions

```sail
/* Convert to JSON */
a!toJson(
  value: a!map(name: "John", age: 30),
  removeNullOrEmptyFields: true
)

/* Parse from JSON */
a!fromJson('{"name":"John","age":30}')

/* Extract with JSONPath */
a!jsonPath(json: local!data, expression: "$.employees[0].name")
```

---

## contains() Usage

```sail
/* Simple array check */
contains({"id", "title"}, "title")  /* Returns true */

/* Check in map arrays (mock data) */
contains(
  local!items.name,
  "Alice"
)

/* Check in record arrays */
contains(
  local!records['recordType!Employee.fields.firstName'],
  "Alice"
)
```

---

## Array Functions Detail

### index()

```sail
/* Get single item by position */
index(local!items, 1, null)  /* First item, null if not found */

/* Get property from array */
index(local!items, "name", {})  /* All name values, empty array if not found */

/* Safe access with wherecontains */
index(local!items, wherecontains(local!targetId, local!items.id), null)
```

### wherecontains()

```sail
/* Find indices where value appears */
wherecontains(local!searchValue, local!array)  /* Returns array of indices */

/* Find matching items */
index(
  local!items,
  wherecontains(local!targetId, local!items.id),
  null
)
```

### a!forEach()

```sail
a!forEach(
  items: local!data,
  expression: a!map(
    id: fv!item.id,
    label: fv!item.name,
    isFirst: fv!isFirst,
    isLast: fv!isLast,
    position: fv!index,
    total: fv!itemCount
  )
)
```

**Available function variables:**
- `fv!item` - Current item
- `fv!index` - Current position (1-based)
- `fv!isFirst` - True if first item
- `fv!isLast` - True if last item
- `fv!itemCount` - Total number of items

---

## a!match() Pattern Matching

```sail
/* Simple status-based styling */
a!match(
  value: local!status,
  equals: "Active", "#059669",
  equals: "Pending", "#D97706",
  equals: "Inactive", "#6B7280",
  default: "#000000"
)

/* With whenTrue for complex conditions */
a!match(
  value: true(),
  whenTrue: local!score >= 90, "A",
  whenTrue: local!score >= 80, "B",
  whenTrue: local!score >= 70, "C",
  default: "F"
)
```

---

## Type Conversion Functions

| Function | Returns | Use Case |
|----------|---------|----------|
| `tointeger(value)` | Integer | IDs, counts, interval-to-number |
| `todecimal(value)` | Decimal | Currency, percentages |
| `tostring(value)` | Text (single string) | Display text (merges arrays!) |
| `touniformstring(array)` | Text array | Preserve array structure |
| `todate(value)` | Date | Date casting |
| `todatetime(value)` | DateTime | DateTime casting |
| `toboolean(value)` | Boolean | Flag conversion |
| `touser(value)` | User | User reference |
| `togroup(value)` | Group | Group reference |

⚠️ **CRITICAL**: `tostring({1, 2})` returns `"1; 2"` (single string). Use `touniformstring({1, 2})` to get `{"1", "2"}` (array).

---

## Null Checking Functions

```sail
/* Check if null or empty */
a!isNullOrEmpty(value)  /* Returns true if null, "", or {} */

/* Check if has value */
a!isNotNullOrEmpty(value)  /* Returns true if has content */

/* Provide default for null */
a!defaultValue(value, fallback)  /* Returns fallback if value is null */
```

---

## Query Functions (Record Data)

### a!queryRecordType()

```sail
a!queryRecordType(
  recordType: 'recordType!{uuid}Employee',
  fields: {
    'recordType!{uuid}Employee.fields.{uuid}firstName',
    'recordType!{uuid}Employee.fields.{uuid}lastName'
  },
  filters: a!queryLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: 'recordType!{uuid}Employee.fields.{uuid}status',
        operator: "=",
        value: "Active"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100)
)
```

### a!recordData() (for grids)

```sail
a!gridField(
  data: a!recordData(
    recordType: 'recordType!{uuid}Employee',
    filters: a!queryFilter(...)
  ),
  columns: {...}
)
```

### a!aggregationFields() (for charts/KPIs)

```sail
a!queryRecordType(
  recordType: 'recordType!{uuid}Order',
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: 'recordType!{uuid}Order.fields.{uuid}status',
        alias: "statusName"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        alias: "orderCount"
      ),
      a!measure(
        function: "SUM",
        field: 'recordType!{uuid}Order.fields.{uuid}amount',
        alias: "totalAmount"
      )
    }
  )
)
```

**Valid a!measure() functions:**
- `"COUNT"` - Count records
- `"SUM"` - Sum numeric field
- `"MIN"` - Minimum value
- `"MAX"` - Maximum value
- `"AVG"` - Average numeric field
- `"DISTINCT_COUNT"` - Count distinct values
