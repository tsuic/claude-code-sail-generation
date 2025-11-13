# DYNAMIC SAIL UI EXPRESSION GUIDELINES - MOCK DATA INTERFACES

This guide covers dynamic SAIL expressions using **local variables with hardcoded/mock data** - no record types required. For record type integration patterns, see the record-interface.md guide.

## 📑 Quick Navigation Index

### 🚨 Critical Sections (Read These First):
- **Lines 43-57**: Mandatory Foundation Rules
- **Lines 59-103**: Essential SAIL Structure
- **Lines 208-469**: a!forEach() Function Variables Reference
- **Lines 788-925**: Null Safety Implementation (including computed variables and short-circuit evaluation)
- **Lines 1257-1427**: Single Checkbox Field Pattern (initialization and null checking)
- **Lines 1429-1800**: Grid Selection Patterns (naming conventions and two-variable approach)
- **Lines 1991-2044**: Date/Time Type Matching

### By Task Type:
- **Working with arrays and loops** → Lines 208-469 (a!forEach() Reference), Lines 470-787 (Array Patterns)
- **Managing grid selections (ID arrays + full data)** → Lines 1429-1800 (Complete Grid Selection Guide)
- **Building charts with mock data** → Lines 2045-2183 (Chart Data Configuration)
- **Working with dates and times** → Lines 1991-2044 (Date/Time Critical Rules)
- **Using checkboxes with proper initialization** → Lines 1257-1427 (Single Checkbox Field Pattern)

### By Error Type:
- **"Variable not defined" errors** → Lines 43-57 (Mandatory Foundation Rules)
- **Null reference errors** → Lines 788-1100 (Null Safety Implementation)
- **Invalid function parameters** → Lines 750-787 (Function Parameter Validation)
- **Short-circuit evaluation errors (and/or vs if)** → Lines 828-925 (Short-Circuit Evaluation Rules)
- **Property access errors (property() function)** → Lines 472-659 (Dot Notation & Derived Data Patterns)
- **Syntax errors (and/or, if statements)** → Lines 166-207 (Language-Specific Syntax Patterns)
- **Grid selection not working** → Lines 1191-1289 (Grid Selection Behavior), Lines 1537-1800 (Implementation Pattern)
- **Grid selection variable naming errors** → Lines 1429-1536 (Variable Naming Conventions)
- **Property access on grid selectionValue (trying to access .field on ID array)** → Lines 1801-2137 (Grid Selection Anti-Patterns)
- **Type mismatch: Cannot index property into Integer/Text** → Lines 1801-2137 (Grid Selection Anti-Patterns)
- **DateTime vs Date type mismatch in filters** → Lines 1991-2044 (Date/Time Type Matching)
- **Checkbox initialization errors (false vs null)** → Lines 1280-1340 (Variable Initialization for Pattern 2)
- **Checkbox state checking errors (length vs null)** → Lines 1365-1427 (Common Mistakes - save!value)

### Validation & Troubleshooting:
- **Final validation checklist** → Lines 2184-2374 (Syntax Validation Checklist)

---

## 🚨 MANDATORY FOUNDATION RULES

1. **All SAIL expressions must begin with `a!localVariables()`** - even if no variables are defined
2. **ALL local variables must be declared before use** - No undeclared variables allowed
3. **Use only available Appian functions** - No JavaScript equivalents exist
4. **Appian data is immutable** - Use functional approaches for data manipulation:
   - `append(array, value)` - Add to end of array (both params must be arrays or compatible types)
   - `a!update(data: array, index: position, value: newValue)` - Insert/replace at position
   - `insert(array, value, index)` - Insert value at specific position
   - `remove(array, index)` - Remove value at position
5. **Always validate for null values** - Use `a!isNullOrEmpty()` and `a!isNotNullOrEmpty()`
6. **wherecontains()**: See "Using wherecontains() Correctly" in Array Manipulation Patterns section for complete usage
7. **Single checkbox variables MUST be initialized to null, NOT false()** - See Single Checkbox Field Pattern for complete pattern
8. **Local variables are ONLY for UI state** - Mock data, selections, transient state
9. **Always try to use record types for read-only grids and charts** instead of mock data when possible

## Essential SAIL Structure

```sail
a!localVariables(
  /* Variable definitions first - ALL must be declared */
  local!userName: "John Doe",
  local!selectedStatus,  /* No initial value - declare by name only */
  local!isVisible: true(),

  /* Interface expression last */
  a!formLayout(
    contents: {
      /* Interface components */
    }
  )
)
```

- **With initial values**: `local!variable: value`
- **Without initial values**: `local!variable` (no null/empty placeholders)
- **For dropdowns**: Initialize to valid `choiceValue` OR use `placeholder`
- **For booleans**: Always explicit: `true()` or `false()`

🚨 CRITICAL: Local Variable Scope in Nested Contexts
- **Local variables MUST be declared at the top of `a!localVariables()` or in new `a!localVariables()` blocks**
- **Cannot declare variables inline within expressions**

```sail
/* ❌ WRONG - Cannot declare variables inline */
a!forEach(
  items: data,
  expression: local!temp: someValue, /* Invalid syntax */
  otherExpression
)

/* ✅ CORRECT - Use nested a!localVariables() */
a!forEach(
  items: data,
  expression: a!localVariables(
    local!temp: someValue,
    /* Use local!temp in expression here */
    someExpression
  )
)
```

## ⚠️ IMPORTANT: Handling Non-Existent Constants and Environment Objects

**Never assume constants, process models, or environment-specific objects exist. Always use placeholders with TODO comments.**

### The Problem:
Generated code often references objects that don't exist in the target environment:
- Constants (`cons!FOLDER_NAME`, `cons!PROCESS_MODEL`)
- Process models (for `a!startProcess()`)
- Document folders (for file upload targets)
- Integration objects
- Expression rules

### ✅ CORRECT Pattern - Placeholder with TODO

```sail
/* File upload fields */
a!fileUploadField(
  label: "Upload Supporting Document",
  target: null,  /* TODO: Add constant value for case documents folder */
  value: local!documentUpload,
  saveInto: local!documentUpload
)

/* Process model references */
a!startProcess(
  processModel: null,  /* TODO: Add constant for case submission process model */
  processParameters: {
    case: local!caseData,
    submittedBy: loggedInUser()
  }
)
```

### ❌ WRONG Pattern - Assuming Objects Exist

```sail
/* DON'T DO THIS */
a!fileUploadField(
  target: cons!CASE_DOCUMENTS_FOLDER,  /* This constant may not exist! */
  ...
)

a!startProcess(
  processModel: cons!SUBMIT_CASE_PROCESS,  /* May not exist! */
  ...
)
```

### TODO Comment Format:
```sail
/* TODO: Add constant value for [specific purpose] */
/* TODO: Configure [object type] - [what it should reference] */
/* TODO: Add integration object for [external system] */
```

### Why This Matters:
1. **Generated code runs immediately** for UI/UX testing
2. **Clear configuration points** - developers search for "TODO"
3. **Self-documenting** - explains what needs configuration
4. **Prevents runtime errors** from missing objects

## ⚠️ Language-Specific Syntax Patterns

**Appian SAIL Conditional Syntax:**
```sail
/* ✅ CORRECT - Use if() function */
value: if(condition, trueValue, falseValue)

/* ❌ WRONG - Python/JavaScript ternary operator */
value: condition ? trueValue : falseValue
```

**Never use patterns from other languages:**
- ❌ Python ternary: `condition ? value1 : value2`
- ❌ JavaScript arrow functions: `() => {}`
- ❌ Java/C# syntax: `public void`, `private static`
- ✅ Always use Appian SAIL function syntax: `functionName(parameters)`

🚨 CRITICAL: Grid Column Sorting Rules

**CORRECT Sorting:**
```sail
/* ✅ Sort on fields only */
sortField: 'field',       /* Field reference */
```

**WRONG Sorting - NEVER DO THIS:**
```sail
/* ❌ Never sort on relationships or computed values */
sortField: local!computedValue,  /* INVALID */
```

**Fundamental Rule**:
- **Fields** = Data values that can be sorted, filtered, displayed
- Always sort on field references, not computed expressions or relationships

- **KPI Metrics** - Use direct property access on mock data: `length(local!items)`, `sum(local!items.price)`, etc.
- **Use arrays and a!forEach() for iteration** - When dealing with mock data lists

🚨 MANDATORY CHECKPOINT: For grids with mock data, consider:
1. Could this use record data instead? (preferred for real data)
2. If using mock data, ensure data structure is clear and well-documented

## 🚨 CRITICAL: a!forEach() Function Variables Reference

### Available Function Variables in a!forEach()

When using `a!forEach()`, Appian automatically provides these function variables within the `expression` parameter:

| Variable | Type | Description | Common Use Cases |
|----------|------|-------------|------------------|
| `fv!item` | Any | Current item value from the array | Accessing properties, creating UI components, data transformations |
| `fv!index` | Integer | Current iteration position (1-based) | Array manipulation, numbering, position-based logic |
| `fv!isFirst` | Boolean | `true` only on first iteration | Special formatting for first item, conditional headers |
| `fv!isLast` | Boolean | `true` only on last iteration | Special formatting for last item, conditional footers |
| `fv!itemCount` | Integer | Total number of items in array | Progress indicators, conditional logic based on total |

**⚠️ CRITICAL:** These variables are **ONLY** available inside `a!forEach()` expressions. They do NOT exist in grid columns, chart configurations, or other iteration functions.

---

### fv!item - Accessing Current Item

**Purpose:** Access the current item's value or properties during iteration

**SAIL-Specific Syntax:**
- **Map properties:** Use dot notation: `fv!item.title`
- **Scalar values:** Use `fv!item` directly

```sail
/* Map data with dot notation */
a!forEach(
  items: {
    a!map(title: "Overview", icon: "info-circle"),
    a!map(title: "Details", icon: "list")
  },
  expression: a!sectionLayout(
    label: fv!item.title,  /* Dot notation for maps */
    contents: {
      a!richTextIcon(icon: fv!item.icon)
    }
  )
)
```

---

### fv!index - Current Position (1-Based)

**Purpose:** Get the current iteration position for array manipulation or position-based logic

**IMPORTANT:** Appian uses 1-based indexing. First item is index 1, not 0.

#### Critical Pattern: Removing Items from Arrays
```sail
/* Common pattern: Remove button for dynamic lists */
a!forEach(
  items: local!items,
  expression: a!cardLayout(
    contents: {
      a!textField(
        label: "Item " & fv!index,  /* Use for labeling */
        value: fv!item.text,
        saveInto: fv!item.text
      )
    },
    link: a!dynamicLink(
      label: "Remove",
      value: fv!index,  /* Pass index to identify which item to remove */
      saveInto: {
        a!save(
          local!items,
          remove(
            local!items,
            fv!index  /* Remove at this position */
          )
        )
      }
    )
  )
)
```

#### Parallel Array Lookups (Status/Icon Mapping)
```sail
/* Map colors and icons to status values by position */
local!statuses: {"Open", "In Progress", "Completed"},
local!icons: {"folder-open", "clock", "check-circle"},
local!colors: {"#EF4444", "#F59E0B", "#10B981"},

a!forEach(
  items: local!statuses,
  expression: a!stampField(
    icon: index(local!icons, fv!index, "file"),      /* Match by position */
    backgroundColor: index(local!colors, fv!index, "#6B7280"),
    contentColor: "#FFFFFF",
    size: "MEDIUM"
  )
)
```

---

### fv!isFirst - First Iteration Detection

**Purpose:** Detect the first iteration for conditional headers or skipping separators

```sail
a!forEach(
  items: local!sections,
  expression: {
    /* Add divider before all items EXCEPT the first */
    if(
      fv!isFirst,
      {},  /* No divider for first item */
      a!columnsLayout(
        columns: {a!columnLayout(contents: {}, width: "FILL")},
        marginBelow: "STANDARD"
      )
    ),
    /* Then show the content */
    a!cardLayout(
      contents: {
        a!richTextDisplayField(value: fv!item.content)
      }
    )
  }
)
```

---

### fv!isLast - Last Iteration Detection

**Purpose:** Detect the last iteration for conditional footers, "Add" buttons, or skipping separators

#### Critical Pattern: Add Button After Last Item
```sail
a!forEach(
  items: local!invoiceItems,
  expression: {
    /* Show each line item */
    a!columnsLayout(
      columns: {
        a!columnLayout(
          contents: {a!richTextDisplayField(value: fv!item.description)}
        ),
        a!columnLayout(
          contents: {a!richTextDisplayField(value: "$" & fv!item.amount)},
          width: "NARROW"
        )
      }
    ),
    /* Show "Add" button or total only after last item */
    if(
      fv!isLast,
      a!richTextDisplayField(
        value: a!richTextItem(
          text: "Total: $" & sum(local!invoiceItems.amount),
          size: "LARGE",
          style: "STRONG"
        )
      ),
      {}
    )
  }
)
```

---

### fv!itemCount - Total Item Count

**Purpose:** Access the total number of items for progress indicators or conditional logic

```sail
/* Progress indicator pattern */
a!forEach(
  items: local!uploadQueue,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: "Processing " & fv!index & " of " & fv!itemCount,
          style: "STRONG"
        )
      ),
      a!textField(
        label: "File",
        value: fv!item.filename,
        readOnly: true
      )
    }
  )
)
```

---

### Combining Multiple Variables

```sail
/* Dynamic remove button logic with fv!itemCount and fv!isLast */
a!forEach(
  items: local!lineItems,
  expression: a!cardLayout(
    contents: {
      a!textField(
        label: "Item " & fv!index,
        value: fv!item.name
      )
    },
    link: if(
      and(
        fv!itemCount > 1,  /* Only show remove if more than 1 item */
        not(fv!isLast)     /* Keep at least the last item */
      ),
      a!dynamicLink(
        label: "Remove",
        value: fv!index,
        saveInto: a!save(local!lineItems, remove(local!lineItems, fv!index))
      ),
      {}
    )
  )
)
```

---

### ⚠️ Common Mistakes

#### ❌ MISTAKE: Accessing properties on scalar values
```sail
/* ❌ WRONG - fv!item is a string, not an object */
a!forEach(
  items: {"Open", "Closed"},
  expression: fv!item.status  /* ❌ ERROR */
)

/* ✅ RIGHT */
a!forEach(
  items: {"Open", "Closed"},
  expression: a!tagField(text: fv!item)  /* ✅ fv!item IS the value */
)
```

---

### Best Practices Summary

#### ✅ DO:
- **Understand fv!item type** - Scalar, map, or object?
- **Use fv!index for array manipulation** - `remove()`, `insert()`, `a!update()`
- **Use fv!isFirst/isLast for conditional rendering** - Headers, footers, dividers
- **Remember fv!index is 1-based** - Matches Appian's `index()` function
- **Combine variables for complex logic** - e.g., `and(fv!itemCount > 1, not(fv!isLast))`

#### ❌ DON'T:
- **Don't access properties on scalar fv!item** - Check your data type first
- **Don't use 0-based indexing** - Appian is 1-based throughout
- **Don't use fv! variables outside a!forEach()** - They don't exist in other contexts
- **Don't forget null checks on fv!item properties** - Map fields can be null


## Array and Data Manipulation Patterns

### Accessing Properties Across Arrays - Dot Notation

**The ONLY way to access a property across all items in an array of maps is using dot notation.**

#### ✅ CORRECT: Dot Notation
```sail
local!items: {
  a!map(id: 1, name: "Item A", price: 100),
  a!map(id: 2, name: "Item B", price: 200),
  a!map(id: 3, name: "Item C", price: 300)
},

/* Access a single property across all items */
local!allNames: local!items.name,
/* Returns: {"Item A", "Item B", "Item C"} */

local!allPrices: local!items.price,
/* Returns: {100, 200, 300} */

/* Use in calculations */
local!totalPrice: sum(local!items.price),
/* Returns: 600 */

/* Use in comparisons */
local!contractTypes: intersection(local!items.type, {"Contract"}),
/* Returns all "Contract" values found */
```

#### ❌ WRONG: property() Function Does NOT Exist
```sail
/* ❌ ERROR - property() is not a valid SAIL function */
local!allNames: property(local!items, "name", {}),

/* ❌ ERROR - This syntax is invalid */
sum(property(local!items, "price"))
```

**Key Rules:**
- Use `array.propertyName` to extract property values across all items
- Works with any array of maps (local variables with mock data)
- Returns an array of the property values in the same order
- Returns empty array `{}` if source array is empty
- Returns `null` elements for items missing that property

---

### Deriving Full Data from ID Arrays

**Common Pattern:** Grid selections store IDs only, but you need full row data for business logic.

**Solution:** Use `a!forEach() + index() + wherecontains()` to derive full objects from ID array.

#### The Pattern

```sail
/* Step 1: Source data (all available items) */
local!availableItems: {
  a!map(id: 1, name: "Item A", type: "Public", price: 100),
  a!map(id: 2, name: "Item B", type: "Contract", price: 200),
  a!map(id: 3, name: "Item C", type: "Public", price: 150)
},

/* Step 2: ID array (from grid selection, user input, etc.) */
local!selectedIds: {1, 3},

/* Step 3: Derive full data using forEach + index + wherecontains */
local!selectedItems: a!forEach(
  items: local!selectedIds,
  expression: index(
    local!availableItems,
    wherecontains(fv!item, local!availableItems.id),
    null
  )
),
/* Returns: {
  a!map(id: 1, name: "Item A", type: "Public", price: 100),
  a!map(id: 3, name: "Item C", type: "Public", price: 150)
} */

/* Step 4: Use derived data for business logic */
local!totalPrice: sum(local!selectedItems.price),
/* Returns: 250 */

local!hasContractType: length(
  intersection(local!selectedItems.type, {"Contract"})
) > 0
/* Returns: false (no Contract items selected) */
```

---

### Finding a Single Matching Item by ID

**Common Pattern:** You have a single ID and need to find the matching item from an array to access its fields.

**✅ CORRECT: Use index() + wherecontains() + dot notation**

```sail
/* Pattern: Find one item by ID and extract a field */
local!selectedOrgId: 5,
local!organizations: {
  a!map(id: 3, name: "Org A", type: "Nonprofit"),
  a!map(id: 5, name: "Org B", type: "Corporation"),
  a!map(id: 7, name: "Org C", type: "Government")
},

/* Get the organization type for the selected organization */
local!orgType: a!defaultValue(
  index(
    local!organizations,
    wherecontains(local!selectedOrgId, local!organizations.id),
    null
  ).type,  /* Use dot notation to extract the field */
  ""
)
/* Returns: "Corporation" */
```

**❌ WRONG: Using a!forEach() creates array with nulls**

```sail
/* ❌ DON'T DO THIS - Returns array like {null, "Corporation", null} */
local!orgType: a!defaultValue(
  index(
    a!forEach(
      items: local!organizations,
      expression: if(
        fv!item.id = local!selectedOrgId,
        fv!item.type,  /* Only ONE item matches */
        null  /* Everything else is null */
      )
    ),
    1,  /* ❌ ERROR: First element might be null! */
    null
  ),
  ""
)
```

**Why a!forEach() is wrong:**
- Creates an array where most elements are `null`
- `index(..., 1, null)` grabs the FIRST element, which could be `null`
- No guarantee the matching item is at position 1

**Key Rules:**
- Use `wherecontains(singleId, array.idField)` to find the position
- Use `index(array, position, null)` to get the matching item
- Use dot notation `.fieldName` to extract the field
- Wrap in `a!defaultValue()` to handle not-found cases

---

#### How It Works

1. **a!forEach(items: local!selectedIds, ...)** - Iterate over each selected ID
2. **fv!item** - Current ID being processed (e.g., 1, then 3)
3. **wherecontains(fv!item, local!availableItems.id)** - Find position of this ID in source array
   - Searches `{1, 2, 3}` (all IDs) for `fv!item` (current ID)
   - Returns array of positions: `{1}` or `{3}`
4. **index(local!availableItems, positions, null)** - Get full object at that position
   - Returns the complete `a!map(id: ..., name: ..., type: ..., price: ...)`
5. **null** - Default value if ID not found (defensive programming)

#### Common Use Cases

**Use Case 1: Grid Selection + Conditional Logic**
```sail
local!selectedCourseIds: {2, 4},  /* From grid selection */
local!selectedCourses: a!forEach(
  items: local!selectedCourseIds,
  expression: index(
    local!availableCourses,
    wherecontains(fv!item, local!availableCourses.id),
    null
  )
),

/* Show field only if Contract course selected */
if(
  if(
    a!isNotNullOrEmpty(local!selectedCourses),
    length(intersection(local!selectedCourses.type, {"Contract"})) > 0,
    false
  ),
  a!textField(label: "Registration Code", ...),
  {}
)
```

**Use Case 2: Calculating Totals**
```sail
local!cartItemIds: {5, 12, 8},
local!cartItems: a!forEach(
  items: local!cartItemIds,
  expression: index(
    local!productCatalog,
    wherecontains(fv!item, local!productCatalog.productId),
    null
  )
),

local!cartTotal: sum(local!cartItems.price),
local!taxableItems: length(
  wherecontains(true, local!cartItems.isTaxable)
)
```

**Use Case 3: Remove Button in Display**
```sail
/* Display selected items with Remove buttons */
a!forEach(
  items: local!selectedItems,  /* Already derived from IDs */
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(value: fv!item.name),
      a!buttonArrayLayout(
        buttons: {
          a!buttonWidget(
            label: "Remove",
            value: fv!item.id,
            saveInto: {
              a!save(
                local!selectedIds,
                remove(local!selectedIds, wherecontains(fv!item.id, local!selectedIds))
              )
            }
          )
        }
      )
    }
  )
)
```

---

### Combining Different Data Types

```sail
/* ❌ WRONG - append() expects compatible types */
local!kpiMap: a!map(name: "Total", count: 100),
local!kpiArray: {a!map(...), a!map(...)},
local!combined: append(local!kpiMap, local!kpiArray)  /* ERROR: Can't append map to array */

/* ✅ RIGHT - Use a!update() to insert at position */
local!kpiMap: a!map(name: "Total", count: 100),
local!kpiArray: {a!map(...), a!map(...)},
local!combined: a!update(data: local!kpiArray, index: 1, value: local!kpiMap)

/* ✅ ALTERNATIVE - Use insert() */
local!combined: insert(local!kpiArray, local!kpiMap, 1)

/* ✅ CORRECT - append() with arrays */
local!array1: {1, 2, 3},
local!array2: {4, 5, 6},
local!combined: append(local!array1, local!array2)  /* Returns {1, 2, 3, 4, 5, 6} */
```

**Key Rules:**
- `append(array, value)` - Both parameters must be arrays or compatible scalar/array combinations
- `a!update(data: array, index: position, value: newValue)` - Insert or replace at any position
- `insert(array, value, index)` - Insert value at specific position (pushes existing items down)

### Using wherecontains() Correctly

**Function Signature:** `wherecontains(valuesToFind, arrayToSearchIn)`
- **Returns:** Array of indices (1-based) where values are found
- **Always returns an array**, even if only one match

```sail
/* ❌ WRONG - wherecontains() only takes 2 parameters */
icon: wherecontains(value, statusArray, iconArray)  /* INVALID - 3 params */

/* ✅ RIGHT - Use nested index() for lookups */
local!statusConfig: a!forEach(
  items: {"Open", "Closed", "Pending"},
  expression: a!map(
    status: fv!item,
    icon: index({"folder-open", "check-circle", "clock"}, fv!index, "file"),
    color: index({"#059669", "#6B7280", "#F59E0B"}, fv!index, "#000000")
  )
),

/* Extract matching config */
icon: index(
  index(
    local!statusConfig,
    wherecontains("Open", local!statusConfig.status),
    {}
  ).icon,
  1,
  "file"
)

/* How it works:
1. wherecontains("Open", local!statusConfig.status) → {1}
2. index(local!statusConfig, {1}, {}) → {a!map(status: "Open", icon: "folder-open", ...)}
3. .icon → {"folder-open"}
4. index(..., 1, "file") → "folder-open"
*/
```

**Common Pattern for Lookups:**
```sail
/* Find value from parallel arrays */
local!statuses: {"Open", "Closed", "Pending"},
local!colors: {"#059669", "#6B7280", "#F59E0B"},

local!color: index(
  local!colors,
  wherecontains("Open", local!statuses),
  "#000000"  /* Default color */
)
/* Returns: "#059669" (first element of colors array) */
```

## ⚠️ Function Parameter Validation

Array Functions - EXACT Parameter Counts
```sail
/* ✅ CORRECT - wherecontains() takes ONLY 2 parameters (see Array Manipulation Patterns for usage) */
wherecontains(value, array)

/* ✅ CORRECT - contains() takes ONLY 2 parameters */
contains(array, value)

/* ✅ CORRECT - index() takes 2 or 3 parameters */
index(array, position)
index(array, position, default)

/* ❌ WRONG - Never add extra parameters */
wherecontains(value, array, 1)  /* Third parameter doesn't exist */
contains(array, value, true)    /* Third parameter doesn't exist */
```

Common Function Parameter Rules
- **Always verify parameter counts match Appian documentation exactly**
- **Function signature errors cause immediate interface failures**
- **No optional parameters exist unless explicitly documented**

Logical Functions - Proper Boolean Logic
```sail
/* ✅ CORRECT - Use proper boolean logic in and() */
and(
  or(condition1, fallback1),
  or(condition2, fallback2)
)

/* ✅ CORRECT - Multiple conditions */
and(
  a!isNotNullOrEmpty(local!value),
  local!value > 0,
  local!isEnabled
)
```

### 🚨 CRITICAL: Short-Circuit Evaluation Rules

**SAIL's `and()` and `or()` functions DO NOT short-circuit** - they evaluate ALL arguments even if the result is already determined.

#### ❌ WRONG: Using and() for Null Safety
```sail
/* ❌ ERROR - and() evaluates BOTH arguments */
/* If local!computedData is empty, the second argument still evaluates */
/* This causes: "Invalid index: Cannot index property 'type' of Null" */
and(
  a!isNotNullOrEmpty(local!computedData),
  local!computedData.type = "Contract"  /* CRASHES if computedData is empty */
)
```

#### ✅ CORRECT: Use Nested if() for Short-Circuit Behavior
```sail
/* ✅ if() short-circuits - only evaluates the returned branch */
if(
  if(
    a!isNotNullOrEmpty(local!computedData),
    local!computedData.type = "Contract",  /* Only evaluated when not empty */
    false
  ),
  /* Then branch - show registration code field */,
  /* Else branch - hide field */
)
```

#### When to Use Nested if() vs and()

**Use nested if() when:**
- Checking null/empty before property access on computed variables
- Any scenario where the second condition CANNOT be safely evaluated if the first is false
- Accessing properties on variables that could be empty arrays or null

**Use and() when:**
- All conditions are independent and can be safely evaluated in any order
- All variables involved are guaranteed to have values (not null, not empty)
- Simple boolean combinations without property access

#### Quick Reference Table

| Function | Short-Circuits? | Use For |
|----------|----------------|---------|
| `if()` | ✅ Yes - Only evaluates returned branch | Null-safe property access, conditional logic |
| `and()` | ❌ No - Evaluates all arguments | Independent boolean conditions only |
| `or()` | ❌ No - Evaluates all arguments | Independent boolean conditions only |
| `a!match()` | ✅ Yes - Only evaluates matched branch | Pattern matching with multiple conditions |

#### Common Scenarios Requiring Nested if()

**Scenario 1: Computed Variables from Grid Selections**
```sail
/* Grid selection derives full data */
local!selectedItems: a!forEach(
  items: local!selectedIds,
  expression: index(...)
),

/* ❌ WRONG - Crashes when no items selected */
showWhen: and(
  length(local!selectedItems) > 0,
  local!selectedItems.type = "Contract"  /* ERROR if empty */
)

/* ✅ RIGHT - Nested if() prevents crash */
showWhen: if(
  if(
    a!isNotNullOrEmpty(local!selectedItems),
    length(intersection(local!selectedItems.type, {"Contract"})) > 0,
    false
  ),
  true,
  false
)
```

**Scenario 2: Array Property Access**
```sail
/* ❌ WRONG - Crashes if items array is empty */
and(
  length(local!items) > 0,
  local!items.price > 100  /* ERROR if items is {} */
)

/* ✅ RIGHT */
if(
  if(
    a!isNotNullOrEmpty(local!items),
    length(where(local!items.price > 100)) > 0,
    false
  ),
  /* Then branch */,
  /* Else branch */
)
```

## 🚨 MANDATORY: Null Safety Implementation

**CHECKPOINT: Before finalizing any SAIL expression, verify EVERY direct field reference uses a!defaultValue()**

- ✅ `a!defaultValue(local!variable, "")`
- ✅ `a!defaultValue(local!variable, null)`
- ✅ `a!defaultValue(local!array, {})`
- ❌ `local!variable` (naked variable reference without null safety)

**Required Null Safety Patterns:**

1. **Form Field Values**: Always wrap in `a!defaultValue()`
   ```sail
   value: a!defaultValue(local!title, ""),
   ```

2. **Array Operations**: Protect all array references
   ```sail
   length(a!defaultValue(local!items, {}))
   ```

3. **Validation Logic**: Wrap all validation checks
   ```sail
   if(
     a!isNullOrEmpty(a!defaultValue(local!required, "")),
     "Field is required",
     null
   )
   ```

**🚨 CRITICAL REMINDER**: The `a!defaultValue()` function prevents interface failures by handling null field references gracefully. This is MANDATORY for all direct field access, not optional. Missing this causes immediate runtime errors.

### Advanced: Functions That Reject Null

**Some functions fail even with `a!defaultValue()` and require `if()` checks BEFORE calling:**

**Null-Rejecting Functions:**
- `user(userId, property)`, `group(groupId, property)` - Cannot accept null ID
- `text(value, format)` - Cannot format null dates/numbers
- String manipulation: `upper()`, `lower()`, `left()`, `right()`, `find()` - Fail on null

**Required Pattern:**
```sail
/* ✅ CORRECT - Check for null BEFORE calling function */
if(
  a!isNotNullOrEmpty(a!defaultValue(fieldValue, null)),
  functionThatRejectsNull(fieldValue, otherParams),
  fallbackValue
)

/* ❌ WRONG - a!defaultValue() wrapper doesn't prevent the error */
functionThatRejectsNull(a!defaultValue(fieldValue, null), otherParams)
```

**Rule**: When a function operates ON a value (transforms/formats it), check for null BEFORE calling. The `a!defaultValue()` wrapper alone is insufficient.

### 🚨 CRITICAL: Null Safety for Computed Variables

**Computed variables that derive from empty arrays require special null checking with nested if() statements.**

**⚠️ IMPORTANT:** SAIL's `and()` and `or()` functions **DO NOT short-circuit**. For detailed explanation and examples of short-circuit evaluation, see the **"🚨 CRITICAL: Short-Circuit Evaluation Rules"** section (lines 836-933).

#### Pattern for Null-Safe Property Access on Computed Variables

**Always use nested if() pattern when accessing properties on computed variables:**

```sail
if(
  if(
    a!isNotNullOrEmpty(local!variable),
    /* Safe to access properties here - variable is guaranteed not empty */
    local!variable.propertyName = "expectedValue",
    /* Return safe default - false, null, or {} depending on context */
    false
  ),
  /* Then branch */,
  /* Else branch */
)
```

#### Common Scenarios Requiring Nested if()

1. **Computed variables from grid selections:**
```sail
local!selectedItemIds: {},
local!selectedItems: a!forEach(
  items: local!selectedItemIds,
  expression: index(local!allItems, wherecontains(fv!item, local!allItems.id), null)
),

/* ✅ Accessing properties */
if(
  if(
    a!isNotNullOrEmpty(local!selectedItems),
    length(intersection(local!selectedItems.type, {"Contract"})) > 0,
    false
  ),
  /* Show additional fields */,
  {}
)
```

2. **Filtered or derived arrays:**
```sail
local!activeUsers: a!forEach(
  items: local!allUsers,
  expression: if(fv!item.status = "Active", fv!item, null)
),

/* ✅ Checking properties */
if(
  if(
    a!isNotNullOrEmpty(local!activeUsers),
    wherecontains("ADMIN", local!activeUsers.role),
    false
  ),
  /* Show admin panel */,
  {}
)
```

#### Why This Matters

**Without proper null safety:**
- Interface fails to load with cryptic property access errors
- Users see error pages instead of forms
- No graceful degradation - complete failure

**With nested if() pattern:**
- Interface loads successfully even when data is empty
- Conditional UI elements hide/show correctly
- Professional user experience with no errors

## Component Usage Patterns

Button Widget Rules
**CRITICAL**: `a!buttonWidget` does NOT have a `validations` parameter.

```sail
/* ❌ WRONG - Button widgets don't support validations */
a!buttonWidget(
  label: "Submit",
  validations: {...}  /* This parameter doesn't exist */
)

/* ✅ CORRECT - Use form-level validations */
a!formLayout(
  contents: {...},
  buttons: a!buttonWidget(label: "Submit"),
  validations: {
    /* Form validations go here */
  }
)
```

Dropdown Field Rules - CRITICAL PATTERNS

🚨 CRITICAL: Dropdown Variable Initialization

**NEVER initialize dropdown variables when using dynamic data:**
```sail
/* ❌ WRONG - Will cause dropdown failures */
local!selectedStatus: "All Statuses",  /* Value not in choiceValues */

/* ✅ CORRECT - Declare without initialization */
local!selectedStatus,  /* Starts as null, placeholder shows */
```

**Rule**: When dropdown choiceValues come from dynamic data or arrays, the variable must start uninitialized (null) to prevent value/choiceValues mismatches.

```sail
/* ✅ CORRECT - Mock data dropdowns */
local!statuses: {"Open", "In Progress", "Closed"},
a!dropdownField(
  choiceLabels: local!statuses,  /* Display text */
  choiceValues: local!statuses,  /* Store same values */
  value: local!selectedStatus,   /* Variable stores status text */
  saveInto: local!selectedStatus,
  placeholder: "All Statuses"  /* Use placeholder, not append() */
)

/* ✅ CORRECT - Use placeholder for "All" options instead */
choiceLabels: local!statuses,
placeholder: "All Statuses"

/* ❌ WRONG - Never use append() with dynamic data */
choiceLabels: append("All", local!statuses)
```

Rich Text Display Field Structure
**CRITICAL**: `a!richTextDisplayField()` value parameter takes arrays of rich text components.

```sail
/* ✅ CORRECT - value takes array of rich text components */
a!richTextDisplayField(
  value: {
    a!richTextIcon(icon: "user", color: "SECONDARY"),
    a!richTextItem(text: "Display text", style: "STRONG")
  }
)

/* ❌ WRONG - Cannot nest other field components in rich text */
a!richTextDisplayField(
  value: a!linkField(...)  /* Invalid nesting */
)

/* ✅ CORRECT - Use link property in richTextItem */
a!richTextDisplayField(
  value: {
    a!richTextItem(
      text: "Click here",
      link: a!dynamicLink(
        label: "Click",
        value: local!data,
        saveInto: local!data
      )
    )
  }
)
```

Available Rich Text Components:
- `a!richTextItem()` - Text with formatting and optional links
- `a!richTextIcon()` - Icons with color and size
- `a!richTextImage()` - Embedded images
- `a!richTextBulletedList()` - Bullet point lists
- `a!richTextNumberedList()` - Numbered lists
- `char(10)` - Line breaks
- Plain text strings

Grid Field Essentials
**CRITICAL**: Grid column `value` property must be one of these specific component types:
- Text (string)
- `a!imageField()`
- `a!linkField()`
- `a!richTextDisplayField()`
- `a!tagField()`
- `a!buttonArrayLayout()`
- `a!progressBarField()`

```sail
a!gridField(
  data: local!items,
  columns: {
    a!gridColumn(
      label: "Title",
      value: a!richTextDisplayField(
        value: {
          a!richTextItem(
            text: fv!row.title,
            link: a!dynamicLink(
              label: fv!row.title,
              value: fv!row.id,
              saveInto: local!selectedId
            )
          )
        }
      ),
      width: "MEDIUM"
    )
  },
  emptyGridMessage: "No records found"  /* Text only - no rich text or components */
)
```

## ⚠️ GRID SELECTION BEHAVIOR - CRITICAL RULE

### selectionValue Contains Identifiers, NOT Full Objects

**MOST COMMON MISTAKE**: Assuming `selectionValue` contains full row data

```sail
❌ WRONG:
a!gridField(
  data: local!courses,
  selectable: true,
  selectionValue: local!selectedCourses,
  selectionSaveInto: local!selectedCourses
)

/* Later... */
a!forEach(
  items: local!selectedCourses,  /* This is selectionValue from a grid */
  expression: fv!item.name        /* ❌ ERROR: fv!item is an integer, not an object! */
)

✅ RIGHT:
a!forEach(
  items: local!selectedCourses,
  expression: a!localVariables(
    local!course: index(local!courses, fv!item, a!map()),  /* Look up full object */
    local!course.name  /* ✅ Now we can access properties */
  )
)
```

**Error you'll see if you get this wrong:**
```
Expression evaluation error: Invalid index: Cannot index property 'name' of type Text into type Number (Integer)
```

### Quick Reference

**Key Rules:**
- Grid `selectionValue` contains **identifiers** (integers for static data, positions in array)
- `selectionValue` does NOT contain full row objects with properties
- Use `index(dataArray, identifier, defaultValue)` to retrieve full objects

**Before writing code with grid selections, ask:**
1. "Is this variable from a grid's selectionValue?" → YES = need index() lookup
2. "Am I accessing properties on fv!item?" → Must verify fv!item is an object, not an ID
3. "Did I use index() to look up the full object first?" → If NO, you'll get a runtime error

Selection Component Patterns
```sail
/* ✅ Single array variable with checkbox controls */
a!localVariables(
  local!visibleColumns: {"id", "title", "status"},
  {
    a!checkboxField(
      choiceValues: {"id", "title", "status"},
      value: local!visibleColumns,
      saveInto: local!visibleColumns
    ),
    a!gridColumn(
      showWhen: contains(local!visibleColumns, "id")
    )
  }
)
```

Single Checkbox Field Pattern

**Pattern 1: Boolean Variable (Simple Toggle)**

When binding a single checkbox directly to a boolean variable with no dependent logic:

```sail
/* ✅ CORRECT - Direct assignment for boolean variables */
local!enableFeature,  /* null by default */
a!checkboxField(
  label: "Options",
  choiceLabels: {"Enable Feature"},
  choiceValues: {true},
  value: local!enableFeature,
  saveInto: local!enableFeature,
  choiceLayout: "STACKED"
)
```

**Pattern 2: Local Variable with Dependent Field Clearing**

When using a single checkbox with local variables that start as null or need to clear dependent fields:

**Critical: Variable Initialization for Pattern 2**

When using Pattern 2 (local variables with checkboxes), nullable boolean variables MUST be initialized to `null`, NOT `false`:

```sail
/* ✅ CORRECT - Null-initialized */
a!localVariables(
  local!caseUrgent,      /* null by default */
  local!requiresReview,  /* null by default */
  local!publicRecord,    /* null by default */
  ...
)

/* ❌ WRONG - False-initialized */
a!localVariables(
  local!caseUrgent: false,      /* ERROR: false is not a valid choiceValue! */
  local!requiresReview: false,
  local!publicRecord: false,
  ...
)
```

**Why?** Single checkboxes with `choiceValues: {true}` can only represent two states:
- **Checked**: `{true}` (stored as the value `true`)
- **Unchecked**: `{}` or `null` (NOT `false`)

Since `choiceValues` can only contain `{true}`, the variable must be `null` when unchecked. Initializing to `false` creates a mismatch between the variable state and the checkbox's valid values.

**Complete Pattern 2 Example:**

```sail
/* ✅ CORRECT - Null-aware toggle pattern with dependent field clearing */
a!localVariables(
  /* Initialize checkbox variable to null, NOT false */
  local!caseUrgent,        /* null by default */
  local!assignedTo,
  local!escalationReason,

  {
    a!checkboxField(
      label: "Case Priority",
      choiceLabels: {"This is an urgent case requiring immediate attention"},
      choiceValues: {true},
      value: if(a!defaultValue(local!caseUrgent, false), {true}, {}),
      saveInto: {
        a!save(local!caseUrgent, if(a!isNotNullOrEmpty(save!value), true, null)),
        a!save(local!assignedTo, if(a!isNotNullOrEmpty(save!value), "urgent-team@example.com", local!assignedTo)),
        a!save(local!escalationReason, if(a!isNullOrEmpty(save!value), null, local!escalationReason))
      }
    ),
    /* Dependent fields check null state */
    a!textField(
      label: "Escalation Reason",
      value: local!escalationReason,
      saveInto: local!escalationReason,
      required: a!isNotNullOrEmpty(local!caseUrgent),
      showWhen: a!isNotNullOrEmpty(local!caseUrgent)
    )
  }
)
```

**Key Differences:**
- **Pattern 1**: Use when binding to a boolean variable with no side effects
- **Pattern 2**: Use when the checkbox state affects other fields or starts as null

**Common Mistakes:**
```sail
/* ❌ WRONG - Using conditional value binding unnecessarily */
value: if(local!caseUrgent, {true}, {})

/* ✅ RIGHT - Direct assignment */
value: local!caseUrgent

/* ❌ WRONG - Using save!value in conditional */
saveInto: {
  a!save(local!var, or(save!value = {true})),
  if(or(save!value = {true}), ...) /* ERROR: save!value not allowed here */
}

/* ✅ RIGHT - Check local variable state, not save!value */
saveInto: {
  if(a!isNullOrEmpty(local!var), ...)
}

/* ❌ WRONG - Using length() on save!value */
saveInto: {
  a!save(local!var, if(length(save!value) > 0, true, null))  /* ERROR: fails when null */
}

/* ✅ RIGHT - Use a!isNotNullOrEmpty() */
saveInto: {
  a!save(local!var, if(a!isNotNullOrEmpty(save!value), true, null))
}
```

**Critical Rule:** `save!value` can ONLY be used inside the `value` parameter of `a!save(target, value)`. It cannot be used in conditionals, the target parameter, or anywhere outside `a!save()`.

## 🚨 MANDATORY: Variable Naming Conventions for Grid Selections

### The Naming Problem

Grid `selectionValue` stores **ONLY identifiers** (Integer Array or Text Array), NOT full row objects. Variables that store these IDs MUST use naming conventions that make this clear.

### ❌ WRONG - Ambiguous Names That Suggest Full Objects
```sail
local!selectedCases: {},      /* ❌ WRONG: Suggests full case objects */
local!selectedTasks: {},      /* ❌ WRONG: Suggests full task objects */
local!selectedEmployees: {},  /* ❌ WRONG: Suggests full employee objects */
local!chosenItems: {},        /* ❌ WRONG: Suggests full item data */
```

**Why this is dangerous:**
- Code readers assume these variables contain full objects
- Leads to property access errors like `local!selectedCases.title` (ERROR: trying to access .title on integer array)
- Runtime error: "Cannot index property 'title' of type Text into type Number (Integer)"

### ✅ CORRECT - Clear Names That Indicate ID Arrays
```sail
/* Option 1: "Ids" suffix (recommended for primary keys) */
local!selectedCaseIds: {},       /* ✅ CLEAR: Integer array of case IDs */
local!selectedTaskIds: {},       /* ✅ CLEAR: Integer array of task IDs */
local!selectedEmployeeIds: {},   /* ✅ CLEAR: Integer array of employee IDs */

/* Option 2: "Keys" suffix (recommended for text identifiers) */
local!selectedStatusKeys: {},    /* ✅ CLEAR: Text array of status keys */
local!selectedCategoryKeys: {},  /* ✅ CLEAR: Text array of category keys */

/* Option 3: "Indexes" suffix (recommended for positional selection) */
local!selectedRowIndexes: {},    /* ✅ CLEAR: Integer array of row positions */
```

### Naming Convention Rules

**MANDATORY naming pattern for grid selection ID arrays:**

1. **For Integer IDs** (most common):
   - ✅ Use suffix: `Ids`
   - Examples: `local!selectedCaseIds`, `local!selectedTaskIds`, `local!chosenEmployeeIds`

2. **For Text Keys**:
   - ✅ Use suffix: `Keys`
   - Examples: `local!selectedStatusKeys`, `local!selectedCategoryKeys`

3. **For Array Indexes**:
   - ✅ Use suffix: `Indexes`
   - Examples: `local!selectedRowIndexes`

4. **Computed Variables** (full data derived from IDs):
   - ✅ Use descriptive name WITHOUT suffix
   - Examples: `local!selectedCases`, `local!selectedTasks`, `local!selectedEmployees`

### Complete Example with Correct Naming

```sail
a!localVariables(
  /* Available data - all cases */
  local!allCases: {
    a!map(id: 1, title: "Case A", priority: "High"),
    a!map(id: 2, title: "Case B", priority: "Low"),
    a!map(id: 3, title: "Case C", priority: "High")
  },

  /* ✅ CORRECT: ID array with "Ids" suffix */
  local!selectedCaseIds: {},

  /* ✅ CORRECT: Computed variable with descriptive name (no suffix) */
  local!selectedCases: a!forEach(
    items: local!selectedCaseIds,
    expression: index(
      local!allCases,
      wherecontains(fv!item, local!allCases.id),
      null
    )
  ),

  /* Grid configuration */
  a!gridField(
    data: local!allCases,
    columns: {
      a!gridColumn(label: "Title", value: fv!row.title),
      a!gridColumn(label: "Priority", value: fv!row.priority)
    },
    selectable: true,
    selectionValue: local!selectedCaseIds,  /* ✅ Use ID variable */
    selectionSaveInto: local!selectedCaseIds
  ),

  /* ❌ WRONG: Trying to access properties on ID array */
  /* local!selectedCaseIds.title */  /* ERROR! */

  /* ✅ CORRECT: Access properties on computed variable */
  local!selectedCases.title  /* Works! Returns array of titles */
)
```

### Enforcement Checklist

**Before writing grid selection code, verify:**
- [ ] ID array variable name ends with "Ids", "Keys", or "Indexes"
- [ ] Computed variable name is descriptive WITHOUT suffix
- [ ] `selectionValue` and `selectionSaveInto` use the ID variable (with suffix)
- [ ] Property access (`.fieldName`) ONLY uses computed variable (no suffix)
- [ ] No property access attempted on ID array variable


## 🚨 CRITICAL: Grid Selection Implementation Pattern - Two-Variable Approach

### The Core Problem
Grid `selectionValue` stores **ONLY identifiers** (Integer Array or Text Array), NOT full row data. Trying to access row properties directly from `selectionValue` will cause runtime errors.

### ❌ WRONG Pattern - Single Variable (Common Mistake)
```sail
local!selectedItems: {},  /* ❌ Trying to use one variable for both selection and data */

a!gridField(
  data: local!availableItems,
  columns: {...},
  selectionValue: local!selectedItems,  /* ❌ This stores IDs only! */
  selectionSaveInto: local!selectedItems
)

/* Later trying to access row data */
if(
  length(
    intersection(
      local!selectedItems.type,  /* ❌ ERROR: selectedItems contains IDs, not objects! */
      {"Contract"}
    )
  ) > 0,
  ...
)
```

**Error you'll see:**
```
Expression evaluation error: Invalid index: Cannot index property 'type' of type Text into type Number (Integer)
```

### ✅ CORRECT Pattern - Two-Variable Approach

**Step 1: Declare TWO variables**
```sail
local!availableItems: {
  a!map(id: 1, name: "Item A", type: "Public"),
  a!map(id: 2, name: "Item B", type: "Contract"),
  a!map(id: 3, name: "Item C", type: "Public")
},
local!selectedItemIds: {},  /* Stores grid selection (IDs only) */
local!selectedItems: a!forEach(  /* Computed: derives full data from IDs */
  items: local!selectedItemIds,
  expression: index(
    local!availableItems,
    wherecontains(fv!item, local!availableItems.id),
    null
  )
),
```

**How the computed variable works:**
1. `a!forEach()` iterates over each ID in `local!selectedItemIds` (e.g., {1, 3})
2. For each ID (`fv!item`), `wherecontains(fv!item, local!availableItems.id)` finds the position in the array
3. `index()` retrieves the full map at that position
4. Result: An array of complete objects for all selected IDs

**Step 2: Configure grid to use the IDs variable**
```sail
a!gridField(
  data: local!availableItems,
  columns: {
    a!gridColumn(label: "Name", value: fv!row.name),
    a!gridColumn(label: "Type", value: fv!row.type)
  },
  selectable: true,
  selectionValue: local!selectedItemIds,  /* ✅ Use IDs variable */
  selectionSaveInto: local!selectedItemIds  /* ✅ Save to IDs variable */
)
```

**Step 3: Access full data using the computed variable (with null safety)**
```sail
/* ✅ CORRECT: Use nested if() for null-safe property access */
if(
  if(
    a!isNotNullOrEmpty(local!selectedItems),
    length(
      intersection(
        local!selectedItems.type,  /* ✅ Safe: has full data */
        {"Contract"}
      )
    ) > 0,
    false  /* Return safe default when empty */
  ),
  /* Show registration code field */,
  {} /* Hide field */
)
```

**Step 4: Display selected items**
```sail
a!forEach(
  items: local!selectedItems,  /* ✅ Iterate over full data */
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: {
          a!richTextItem(text: fv!item.name, style: "STRONG"),
          " - ",
          fv!item.type
        }
      )
    }
  )
)
```

**Step 5: Remove items (modify IDs only)**
```sail
/* Remove button in forEach */
a!buttonWidget(
  label: "Remove",
  value: fv!item.id,
  saveInto: a!save(
    local!selectedItemIds,  /* ✅ Modify IDs variable only */
    remove(local!selectedItemIds, wherecontains(fv!item.id, local!selectedItemIds))
  )
)
```

### Critical Rules - COMPLETE ENFORCEMENT CHECKLIST

**Before writing ANY grid with selection, verify ALL of these:**

1. ✅ **Variable Naming Convention (MANDATORY)**:
   - [ ] ID array variable name ends with "Ids", "Keys", or "Indexes"
   - [ ] Computed variable name is descriptive WITHOUT suffix
   - [ ] Variable names clearly distinguish between IDs and full data
   - Example: `local!selectedCaseIds` (IDs) vs `local!selectedCases` (computed data)

2. ✅ **Two-Variable Pattern (MANDATORY)**:
   - [ ] TWO variables declared: one for IDs, one computed for full data
   - [ ] ID variable initialized as empty array: `{}`
   - [ ] Computed variable uses `a!forEach() + index() + wherecontains()` pattern
   - [ ] Both variables declared before use

3. ✅ **Grid Configuration (MANDATORY)**:
   - [ ] `selectionValue` parameter uses ID variable (with suffix)
   - [ ] `selectionSaveInto` parameter uses ID variable (with suffix)
   - [ ] Grid `selectionValue` treated as ID array, NEVER as full row data

4. ✅ **Property Access Rules (MANDATORY)**:
   - [ ] ALL property access (`.fieldName`) uses computed variable ONLY
   - [ ] NEVER attempt property access on ID array variable
   - [ ] Null checks precede all property access on computed variable

5. ✅ **Null Safety (MANDATORY)**:
   - [ ] Use nested `if()` for null-safe property access (NOT `and()`)
   - [ ] Pattern: `if(a!isNotNullOrEmpty(computed), computed.property, defaultValue)`
   - [ ] `and()` does NOT short-circuit - see Short-Circuit Evaluation Rules

6. ✅ **Data Derivation (MANDATORY)**:
   - [ ] Use `a!forEach() + index() + wherecontains()` to derive full data from IDs
   - [ ] Never use `filter()` for deriving data (requires fv!item context)
   - [ ] Never save to computed variable (it recalculates automatically)

7. ✅ **Iteration Patterns (MANDATORY)**:
   - [ ] When iterating to display data: use computed variable (full data)
   - [ ] When modifying selection: modify ID variable only
   - [ ] Never iterate over ID array expecting full objects

8. ✅ **Conditional Logic (MANDATORY)**:
   - [ ] When checking properties: use computed variable with null checks
   - [ ] Never check properties on ID array variable
   - [ ] Pattern: `if(a!isNotNullOrEmpty(computed), <property check>, false)`

9. ✅ **Selection Modifications (MANDATORY)**:
   - [ ] All `saveInto` operations modify ID array ONLY
   - [ ] Use `append()`, `remove()`, `a!save()` on ID variable
   - [ ] Computed variable updates automatically

10. ✅ **Grid Context (MANDATORY)**:
    - [ ] Grid `selectionValue` is ALWAYS a list (even with `maxSelections: 1`)
    - [ ] Use `index(selectionValue, 1, null)` to get first selection from list
    - [ ] Check `length(selectionValue) > 0` before accessing selections

11. ✅ **Code Review (MANDATORY)**:
    - [ ] Search code for ID variable name - verify NO property access attempted
    - [ ] Search code for computed variable name - verify ALL property access uses it
    - [ ] Verify naming convention followed consistently throughout interface

### Complete Working Example
```sail
a!localVariables(
  local!availableCourses: {
    a!map(id: 1, number: "OSHA #500", name: "Construction Safety", type: "Public"),
    a!map(id: 2, number: "OSHA #501", name: "Maritime Safety", type: "Public"),
    a!map(id: 3, number: "OSHA #5600", name: "Disaster Response", type: "Contract")
  },
  local!selectedCourseIds: {},
  local!selectedCourses: a!forEach(
    items: local!selectedCourseIds,
    expression: index(
      local!availableCourses,
      wherecontains(fv!item, local!availableCourses.id),
      null
    )
  ),
  local!registrationCode,
  {
    a!gridField(
      data: local!availableCourses,
      columns: {
        a!gridColumn(label: "Number", value: fv!row.number),
        a!gridColumn(label: "Name", value: fv!row.name),
        a!gridColumn(label: "Type", value: fv!row.type)
      },
      selectable: true,
      selectionValue: local!selectedCourseIds,
      selectionSaveInto: local!selectedCourseIds
    ),
    /* Show registration code field if contract course selected */
    if(
      if(
        a!isNotNullOrEmpty(local!selectedCourses),
        length(
          intersection(
            local!selectedCourses.type,
            {"Contract"}
          )
        ) > 0,
        false
      ),
      a!textField(
        label: "Registration Code",
        value: local!registrationCode,
        saveInto: local!registrationCode,
        required: true
      ),
      {}
    )
  }
)
```


## 🚨 CRITICAL ANTI-PATTERNS - DO NOT DO THIS

### Anti-Pattern 1: Property Access on ID Array Variable

**THE ERROR:**
```sail
a!localVariables(
  local!allTasks: {
    a!map(id: 1, title: "Review contract", status: "Open"),
    a!map(id: 2, title: "Update case file", status: "Closed"),
    a!map(id: 3, title: "Schedule hearing", status: "Open")
  },

  /* ❌ WRONG: Variable name suggests objects but stores IDs */
  local!selectedTasks: {},

  a!gridField(
    data: local!allTasks,
    columns: {
      a!gridColumn(label: "Title", value: fv!row.title),
      a!gridColumn(label: "Status", value: fv!row.status)
    },
    selectable: true,
    selectionValue: local!selectedTasks,  /* Stores integers {1, 3}, NOT objects! */
    selectionSaveInto: local!selectedTasks
  ),

  /* ❌ WRONG: Trying to access .status property on integer array */
  a!textField(
    label: "Selected Task Status",
    value: local!selectedTasks.status,  /* ERROR: Cannot access .status on {1, 3}! */
    readOnly: true
  )
)
```

**Runtime Error:**
```
Expression evaluation error: Invalid index: Cannot index property 'status' of type Text into type Number (Integer)
```

**THE FIX:**
```sail
a!localVariables(
  local!allTasks: {
    a!map(id: 1, title: "Review contract", status: "Open"),
    a!map(id: 2, title: "Update case file", status: "Closed"),
    a!map(id: 3, title: "Schedule hearing", status: "Open")
  },

  /* ✅ CORRECT: Clear naming - stores IDs only */
  local!selectedTaskIds: {},

  /* ✅ CORRECT: Computed variable derives full data */
  local!selectedTasks: a!forEach(
    items: local!selectedTaskIds,
    expression: index(
      local!allTasks,
      wherecontains(fv!item, local!allTasks.id),
      null
    )
  ),

  a!gridField(
    data: local!allTasks,
    columns: {
      a!gridColumn(label: "Title", value: fv!row.title),
      a!gridColumn(label: "Status", value: fv!row.status)
    },
    selectable: true,
    selectionValue: local!selectedTaskIds,  /* ✅ Use ID variable */
    selectionSaveInto: local!selectedTaskIds
  ),

  /* ✅ CORRECT: Access properties on computed variable */
  a!textField(
    label: "Selected Task Status",
    value: joinarray(local!selectedTasks.status, ", "),  /* ✅ Works! */
    readOnly: true
  )
)
```

### Anti-Pattern 2: Using forEach on ID Array Without Lookup

**THE ERROR:**
```sail
a!localVariables(
  local!allEmployees: {
    a!map(id: 101, name: "Alice Smith", department: "Legal"),
    a!map(id: 102, name: "Bob Jones", department: "Finance"),
    a!map(id: 103, name: "Carol White", department: "Legal")
  },

  /* ❌ WRONG: Ambiguous variable name */
  local!selectedEmployees: {},

  a!gridField(
    data: local!allEmployees,
    columns: {...},
    selectionValue: local!selectedEmployees,  /* Stores {101, 103} */
    selectionSaveInto: local!selectedEmployees
  ),

  /* ❌ WRONG: Iterating over IDs as if they were objects */
  a!forEach(
    items: local!selectedEmployees,  /* This is {101, 103}, NOT employee objects! */
    expression: a!richTextDisplayField(
      value: a!richTextItem(
        text: fv!item.name  /* ERROR: fv!item is 101, not an object! */
      )
    )
  )
)
```

**Runtime Error:**
```
Expression evaluation error: Invalid index: Cannot index property 'name' of type Text into type Number (Integer)
```

**THE FIX:**
```sail
a!localVariables(
  local!allEmployees: {
    a!map(id: 101, name: "Alice Smith", department: "Legal"),
    a!map(id: 102, name: "Bob Jones", department: "Finance"),
    a!map(id: 103, name: "Carol White", department: "Legal")
  },

  /* ✅ CORRECT: Clear ID variable naming */
  local!selectedEmployeeIds: {},

  /* ✅ CORRECT: Computed variable with full data */
  local!selectedEmployees: a!forEach(
    items: local!selectedEmployeeIds,
    expression: index(
      local!allEmployees,
      wherecontains(fv!item, local!allEmployees.id),
      null
    )
  ),

  a!gridField(
    data: local!allEmployees,
    columns: {...},
    selectionValue: local!selectedEmployeeIds,  /* ✅ Use ID variable */
    selectionSaveInto: local!selectedEmployeeIds
  ),

  /* ✅ CORRECT: Iterate over computed variable with full data */
  a!forEach(
    items: local!selectedEmployees,  /* Full employee objects */
    expression: a!richTextDisplayField(
      value: a!richTextItem(
        text: fv!item.name  /* ✅ Works! fv!item is now a complete employee object */
      )
    )
  )
)
```

### Anti-Pattern 3: Conditional Logic on ID Array Properties

**THE ERROR:**
```sail
a!localVariables(
  local!allCases: {
    a!map(id: 1, title: "Case A", isUrgent: true),
    a!map(id: 2, title: "Case B", isUrgent: false),
    a!map(id: 3, title: "Case C", isUrgent: true)
  },

  /* ❌ WRONG: Stores IDs but name suggests objects */
  local!selectedCases: {},

  a!gridField(
    data: local!allCases,
    columns: {...},
    selectionValue: local!selectedCases,  /* Stores {1, 3} */
    selectionSaveInto: local!selectedCases
  ),

  /* ❌ WRONG: Trying to filter/check properties on ID array */
  a!textField(
    label: "Urgency Notes",
    instructions: "Required for urgent cases",
    value: local!urgencyNotes,
    saveInto: local!urgencyNotes,
    showWhen: length(
      a!forEach(
        items: local!selectedCases,  /* IDs: {1, 3} */
        expression: if(fv!item.isUrgent, fv!item, null)  /* ERROR: fv!item is integer! */
      )
    ) > 0
  )
)
```

**Runtime Error:**
```
Expression evaluation error: Invalid index: Cannot index property 'isUrgent' of type Boolean (Boolean) into type Number (Integer)
```

**THE FIX:**
```sail
a!localVariables(
  local!allCases: {
    a!map(id: 1, title: "Case A", isUrgent: true),
    a!map(id: 2, title: "Case B", isUrgent: false),
    a!map(id: 3, title: "Case C", isUrgent: true)
  },

  /* ✅ CORRECT: Clear ID variable naming */
  local!selectedCaseIds: {},

  /* ✅ CORRECT: Computed variable with full data */
  local!selectedCases: a!forEach(
    items: local!selectedCaseIds,
    expression: index(
      local!allCases,
      wherecontains(fv!item, local!allCases.id),
      null
    )
  ),

  a!gridField(
    data: local!allCases,
    columns: {...},
    selectionValue: local!selectedCaseIds,  /* ✅ Use ID variable */
    selectionSaveInto: local!selectedCaseIds
  ),

  /* ✅ CORRECT: Check properties on computed variable with null safety */
  a!textField(
    label: "Urgency Notes",
    instructions: "Required for urgent cases",
    value: local!urgencyNotes,
    saveInto: local!urgencyNotes,
    showWhen: if(
      a!isNotNullOrEmpty(local!selectedCases),  /* Null check first */
      length(
        intersection(
          local!selectedCases.isUrgent,  /* ✅ Access property on full data */
          {true}
        )
      ) > 0,
      false
    )
  )
)
```

### Key Takeaways from Anti-Patterns

**Every anti-pattern shares these root causes:**
1. ❌ Ambiguous variable naming (no "Ids"/"Keys"/"Indexes" suffix)
2. ❌ Only ONE variable created (missing computed variable)
3. ❌ Property access attempted on ID array

**Every fix requires:**
1. ✅ Clear variable naming with suffix for IDs
2. ✅ TWO variables (IDs + computed)
3. ✅ Property access ONLY on computed variable
4. ✅ Null checking before property access

## Date/Time Critical Rules

### Correct Date/Time Functions

🚨 CRITICAL: Use the correct function for date/time creation
```sail
/* ✅ CORRECT - Use dateTime() for specific date/time creation */
dateTime(year(today()), month(today()), 1, 0, 0, 0)  /* Month to Date */

/* ❌ WRONG - a!dateTimeValue() does NOT exist in Appian */
a!dateTimeValue(year: year(today()), month: month(today()), day: 1)
```

### Type Casting with todate()

**Always cast date arithmetic in sample data to ensure consistent types:**

**WRONG:**
```sail
local!data: {
  a!map(dueDate: today()),        /* Type: Date */
  a!map(dueDate: today() + 1)     /* Type: DateTime - causes grid sort errors! */
}
```

**RIGHT:**
```sail
local!data: {
  a!map(dueDate: todate(today())),      /* Type: Date */
  a!map(dueDate: todate(today() + 1)),  /* Type: Date */
  a!map(dueDate: todate(today() + 7))   /* Type: Date */
}
```

### Date/DateTime Arithmetic Returns Intervals

Subtracting dates or datetimes returns an **Interval** type, not a Number:
- `now() - timestamp` → Interval (Day to Second)
- `today() - dateValue` → Interval (Day to Day)

**Cannot compare Intervals directly to Numbers:**
```sail
/* WRONG */
if(now() - fv!row.timestamp < 1, ...)  /* Error: Cannot compare Interval to Number */

/* RIGHT */
if(tointeger(now() - fv!row.timestamp) < 1, ...)  /* Convert Interval to Integer first */
```

### Key Date/Time Functions
- `todate()` - Cast to Date type (use for all date arithmetic in sample data)
- `tointeger()` - Convert interval to whole days as integer
- `text(value, format)` - Format numbers/dates/intervals as text

## Chart Data Configuration

Mock Data Charts (Prototyping)
```sail
a!barChartField(
  categories: {"Sales", "Engineering"},
  series: {
    a!chartSeries(
      label: "Employees",
      data: {25, 45}
    )
  }
)
```

Chart Data Extraction Rules
**CRITICAL**: Charts are display-only components
- **Cannot extract data from chart components** - Only from queries
- **Use separate calculations for KPIs** - Don't try to read chart data

## Chart Components Usage

**Available Chart Functions:**
1. `a!areaChartField()` - Filled areas under lines for trends and cumulative values
2. `a!barChartField()` - Horizontal bars for comparing categories
3. `a!columnChartField()` - Vertical bars for comparing values across categories
4. `a!lineChartField()` - Connected points for trends over time
5. `a!pieChartField()` - Pie slices for part-to-whole relationships

**Parameters Shared by All Chart Types:**
- `label`, `labelPosition` (usually "COLLAPSED"), `instructions`
- `height` - Values vary by type:
  - Column/Line/Area/Bar: "MICRO", "SHORT", "MEDIUM", "TALL" (Bar also has "AUTO")
  - Pie: "SHORT", "MEDIUM", "TALL"
- `showWhen`, `accessibilityText`
- `xAxisTitle`, `yAxisTitle` (not available for pie charts)
- `showLegend` (column, line, bar, area only - NOT pie)
- `showDataLabels`, `colorScheme`

🚨 CRITICAL: Stacking Property

**ONLY these chart types have a `stacking` property:**
- `a!areaChartField()`
- `a!barChartField()`
- `a!columnChartField()`

**The `stacking` property is on the CHART FIELD, NOT in the config:**
```sail
/* ✅ CORRECT - stacking on chart field */
a!columnChartField(
  categories: {"Q1", "Q2", "Q3", "Q4"},
  series: {
    a!chartSeries(label: "Sales", data: {100, 120, 115, 140})
  },
  stacking: "NORMAL"  /* On chart field level */
)

/* ❌ WRONG - stacking doesn't exist for mock data charts with categories/series */
```

**Valid stacking values:** "NONE" (default), "NORMAL", "PERCENT_TO_TOTAL"

**For Mock Data: Static Mockup Data** (categories + series)
- Use for: Column, Line, Bar, Area, Pie charts with hardcoded sample data
- Structure:
```sail
a!columnChartField(
  categories: {"Q1", "Q2", "Q3", "Q4"},
  series: {
    a!chartSeries(label: "Sales", data: {100, 120, 115, 140}, color: "#3B82F6")
  }
)
```

❌ **NEVER use scatter charts with static mockup data** - they require record data

## Essential Functions Reference

⚠️ **CRITICAL: Verify ALL functions exist in `/validation/sail-api-schema.json` before use**

Common functions that DO NOT exist:
- `a!isPageLoad()` - Use pattern: `local!showValidation: false()` + set to `true()` on button click
- `property()` - Use dot notation instead: `object.field`

Preferred Functions
- **Null Checking**: `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()` over `isnull()`
- **Logical**: `and()`, `or()`, `not()` over infix operators
- **Looping**: `a!forEach()` over `map()`
- **Matching**: `a!match()` over `choose()`
- **Array Operations**: `append()`, `a!update()` for immutable operations
- **Audit Functions**: `loggedInUser()`, `now()` for audit fields

JSON Functions
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

contains() Usage
```sail
/* Arrays */
contains({"id", "title"}, "title")  /* Returns true */

/* Map arrays */
contains(
  local!items.name,
  "Alice"
)
```

## Quick Function Reference

| Category | Functions |
|----------|-----------|
| Array | `a!flatten()`, `append()`, `index()`, `length()`, `where()`, `wherecontains()` |
| Logical | `and()`, `or()`, `not()`, `if()`, `a!match()` |
| Null Checking | `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()`, `a!defaultValue()` |
| Looping | `a!forEach()`, `filter()`, `reduce()`, `merge()` |
| Text | `concat()`, `find()`, `left()`, `len()`, `substitute()`, `upper()`, `lower()` |
| Date/Time | `today()`, `now()`, `dateTime()` |
| JSON | `a!toJson()`, `a!fromJson()`, `a!jsonPath()` |
| User/System | `loggedInUser()`, `user()` |

## 🔧 Quick Troubleshooting

If your interface fails to load, check:
1. **Syntax basics** - All parentheses/brackets matched, variables declared at top
2. **Null handling** - All variables protected (see MANDATORY: Null Safety Implementation)
3. **Grid selections** - Two-variable pattern with proper naming conventions

## Syntax Validation Checklist

Before finalizing any SAIL interface with mock data, verify these critical items:

### Foundation & Structure
- [ ] **Expression starts with `a!localVariables()`** (see MANDATORY FOUNDATION RULES)
- [ ] **All functions verified in schema** - No a!isPageLoad(), property(), or assumed functions

### Grid Selection Pattern (Mock Data)
- [ ] **Grid selection uses two-variable approach** (see CRITICAL: Grid Selection Implementation Pattern)
  - [ ] ID array variable for `selectionValue` (e.g., `local!selectedCaseIds`, `local!selectedTaskIds`)
  - [ ] **ID variable name MUST end with "Ids", "Keys", or "Indexes"** (MANDATORY naming convention)
  - [ ] Computed variable using `a!forEach() + index() + wherecontains()` pattern
  - [ ] **Computed variable name is descriptive WITHOUT suffix** (e.g., `local!selectedCases`, `local!selectedTasks`)
  - [ ] All `saveInto` operations modify ID array only
- [ ] **Grid `selectionValue` treated as ID array**, never as full row data
- [ ] **NO property access on ID array variable** - ALL property access uses computed variable
- [ ] **Computed variables have null checks** before property access (see next section)
- [ ] **Variable names clearly distinguish IDs from full data** - ambiguous names cause runtime errors

### Null Safety & Short-Circuit Evaluation
- [ ] **All null checks implemented** (see MANDATORY: Null Safety Implementation)
- [ ] **Computed variables protected with nested `if()`** - NOT `and()` (see Short-Circuit Evaluation Rules)
- [ ] **Property access on arrays uses nested `if()`** when array could be empty
- [ ] **No `and()` used for null-safe property access** - Use nested `if()` instead

### Array & Property Access
- [ ] **Dot notation used for property access** (e.g., `local!items.price`)
- [ ] **NO usage of `property()` function** - Function does not exist in SAIL
- [ ] **Single item lookup uses `index() + wherecontains()`** - NOT `a!forEach()` with nulls (see Finding a Single Matching Item by ID)
- [ ] **Array functions use correct parameter order** (see Array and Data Manipulation Patterns)
- [ ] **Derived data pattern follows `a!forEach() + index() + wherecontains()`** (see Deriving Full Data from ID Arrays)

### Function Validation
- [ ] **Function parameters match documented signatures** (see CRITICAL: Function Parameter Validation)
- [ ] **All functions exist in Appian** (see Available Appian Functions)
- [ ] **Short-circuit evaluation rules followed** (see Short-Circuit Evaluation Rules)
  - Use nested `if()` for null-safe property access
  - Use `and()`/`or()` only for independent conditions

### Component Patterns
- [ ] **Checkbox boolean variables are null-initialized, NOT false-initialized** (see Single Checkbox Field Pattern - Variable Initialization)
- [ ] **Checkbox saveInto uses a!isNotNullOrEmpty(save!value), NOT length(save!value)** (see save!value Null Checking)
- [ ] **Multi-checkbox saveInto checks for null before using contains()** (see Multi-Checkbox Pattern)

Each item above links to its authoritative section for complete rules and examples.
