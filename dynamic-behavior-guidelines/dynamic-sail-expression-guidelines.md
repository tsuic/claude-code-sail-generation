# DYNAMIC SAIL UI EXPRESSION GUIDELINES

<critical_rules>
## 🚨 MANDATORY FOUNDATION RULES

<expression_structure>
1. **All SAIL expressions must begin with `a!localVariables()`** - even if no variables are defined
2. **ALL local variables must be declared before use** - No undeclared variables allowed
3. **Use only available Appian functions** - No JavaScript equivalents exist
4. **Appian data is immutable** - Use functional approaches for data manipulation:
   - `append(array, value)` - Add to end of array (both params must be arrays or compatible types)
   - `a!update(data: array, index: position, value: newValue)` - Insert/replace at position
   - `insert(array, value, index)` - Insert value at specific position
   - `remove(array, index)` - Remove value at position
5. **Always validate for null values** - Use `a!isNullOrEmpty()` and `a!isNotNullOrEmpty()`
6. **Set audit fields on create/update** - createdBy, createdOn, modifiedBy, modifiedOn
7. **Never use `append()` with record data in dropdown choices - use placeholders**
8. **For dropdowns with record data**: Use record IDs as choiceValues and record text fields as choiceLabels - NO value-to-ID translation needed
9. **wherecontains() signature**: `wherecontains(valuesToFind, arrayToSearchIn)` - Returns array of indices, always use with index() for extraction
10. **Always try to use record types for populating read-only grids (`a!gridField()`) and charts** - instead of using mock data.
</expression_structure>

<form_interface_patterns>
## 🚨 CRITICAL: Form Interface Data Patterns

**BEFORE writing ANY form/wizard interface, determine the data pattern:**

### Decision Tree:
```
Will users CREATE records? → Use ri! (Rule Input) pattern
Will users UPDATE records? → Use ri! (Rule Input) pattern
Is this ONLY displaying data? → Use query/a!recordData pattern
Is this a static mockup? → Use local variables with hardcoded data
```

### 🔴 MOST CRITICAL RULE:
**Forms that CREATE or UPDATE records MUST use rule inputs (ri!), NOT queries or local variables for the main record data.**

### User Request Keywords That Indicate Rule Input Pattern:
- "form to create/submit/add a [record]"
- "interface to update/edit a [record]"
- "wizard for creating/submitting"
- "application submission"
- "registration form"
- "edit page for [record]"
- "interface used to create or update"

### ✅ CORRECT: Rule Input Pattern (for Create/Update Forms)

**When to use**: Interface will be used to create new records or update existing records

```sail
/* Rule Inputs:
 * - ri!recordName: The record being created/updated (null for new, populated for update)
 * - ri!relatedRecord: Any related records needed for context
 */
a!localVariables(
  /* NO QUERY for the main record being edited! */

  /* Use local variables ONLY for transient UI state: */
  local!selectedOptions: null,
  local!dynamicArray: {},

  /* Bind form fields directly to rule inputs: */
  a!textField(
    label: "First Name",
    value: ri!recordName['recordType!{uuid}Type.fields.{uuid}firstName'],
    saveInto: ri!recordName['recordType!{uuid}Type.fields.{uuid}firstName'],
    required: true
  ),

  /* Validation checks rule input values: */
  a!buttonArrayLayout(
    buttons: {
      a!buttonWidget(
        label: "Submit",
        disabled: a!isNullOrEmpty(ri!recordName['recordType!{uuid}Type.fields.{uuid}firstName'])
      )
    }
  )
)
```

**Key characteristics of ri! pattern:**
- Main record data binds to `ri!recordName[...]`
- NO `a!queryRecordType()` for the record being created/updated
- Form fields save directly to `ri!` (auto-persists to record)
- Use `a!isNullOrEmpty()` for validation checks on rule inputs
- Local variables used ONLY for transient UI state (selections, dynamic arrays, temporary data)

### ❌ WRONG: Query Pattern (for Create/Update Forms)

**This pattern is ONLY for read-only displays, NOT for forms:**

```sail
/* DON'T DO THIS for create/update forms! */
a!localVariables(
  local!currentRecord: a!queryRecordType(...), /* WRONG for forms! */
  local!firstName: a!defaultValue(local!currentRecord[...], null), /* WRONG! */

  a!textField(
    value: local!firstName, /* WRONG - not saving to record! */
    saveInto: local!firstName /* WRONG - just saving to local variable! */
  )
)
```

**Why this is wrong:**
- Changes only update local variables, not the actual record
- Requires manual save logic to persist to record
- Doesn't follow Appian best practices for form interfaces
- Query is unnecessary overhead for create/update operations

### ✅ CORRECT: Query Pattern (for Read-Only Displays)

**When to use**: Displaying data without editing, dashboards, reports, read-only grids

```sail
a!localVariables(
  local!recordData: a!queryRecordType(
    recordType: 'recordType!{uuid}Type',
    filters: a!queryFilter(...)
  ),

  /* Display in read-only grid: */
  a!gridField(
    data: a!recordData(
      recordType: 'recordType!{uuid}Type',
      filters: a!queryFilter(...)
    ),
    columns: {
      a!gridColumn(
        label: "Name",
        value: fv!row['recordType!{uuid}Type.fields.{uuid}name']
      )
    }
  )
)
```

### Common Mistakes to Avoid:

1. **Using queries for the main record in create/update forms**
   - ❌ Wrong: `local!applicant: a!queryRecordType(...)` in a submission form
   - ✅ Right: `ri!applicant` as rule input

2. **Saving form inputs to local variables instead of rule inputs**
   - ❌ Wrong: `saveInto: local!firstName` when creating/updating a record
   - ✅ Right: `saveInto: ri!recordName['recordType!{uuid}Type.fields.{uuid}firstName']`

3. **Mixing patterns inappropriately**
   - ❌ Wrong: Using ri! for reference data that shouldn't be edited
   - ✅ Right: Use ri! for main record, queries for reference/lookup data

### MANDATORY CHECKLIST Before Coding Form Interfaces:

- [ ] Read user request carefully - does it mention "create", "update", "edit", "submit", "form", or "wizard"?
- [ ] If YES → Use ri! pattern for main record
- [ ] If NO (display only) → Use query/a!recordData pattern
- [ ] Main record data binds to ri!, NOT local variables
- [ ] NO a!queryRecordType() for the record being created/updated
- [ ] Local variables used ONLY for transient UI state (not main record fields)
- [ ] Form validation checks ri! values, not local variables
</form_interface_patterns>

<non_existent_objects_handling>
## 🚨 CRITICAL: Handling Non-Existent Constants and Environment Objects

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
    case: ri!case,
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
</non_existent_objects_handling>

<syntax_pattern_validation>
## 🚨 CRITICAL: Language-Specific Syntax Patterns

<conditional_syntax>
**Appian SAIL Conditional Syntax:**
```sail
/* ✅ CORRECT - Use if() function */
value: if(condition, trueValue, falseValue)

/* ❌ WRONG - Python/JavaScript ternary operator */
value: condition ? trueValue : falseValue
```
</conditional_syntax>

<language_pattern_violations>
**Never use patterns from other languages:**
- ❌ Python ternary: `condition ? value1 : value2`
- ❌ JavaScript arrow functions: `() => {}`
- ❌ Java/C# syntax: `public void`, `private static`
- ✅ Always use Appian SAIL function syntax: `functionName(parameters)`
</language_pattern_violations>
</syntax_pattern_validation>

<relationship_navigation_syntax>
🚨 CRITICAL: Relationship Field Navigation Syntax

**CORRECT Syntax:**
```sail
/* ✅ In grids - single continuous path */
fv!row['recordType!Case.relationships.status.fields.value']
fv!row['recordType!Case.relationships.priority.fields.name']

/* ✅ In forms - single continuous path */
ri!record['recordType!Case.relationships.status.fields.value']

/* ✅ In rule inputs - single continuous path */
ri!case['recordType!Case.relationships.caseComment.fields.description']
```

**WRONG Syntax - NEVER DO THIS:**
```sail
/* ❌ Double bracket navigation - CAUSES ERRORS */
fv!row['recordType!Case.relationships.status']['recordType!Status.fields.value']
ri!record['recordType!Case.relationships.status']['recordType!Status.fields.value']

/* ❌ Separate record type reference - INVALID */
fv!row['recordType!Case.relationships.status']['recordType!AnotherType.fields.value']
```

**Fundamental Rule**: Relationships provide a navigation path - use dot notation to traverse from base record → relationship → field in one continuous path. Never use double bracket syntax with separate record type references.
</relationship_navigation_syntax>

<sorting_rules>
🚨 CRITICAL: Grid Column Sorting Rules

**CORRECT Sorting:**
```sail
/* ✅ Sort on record fields only */
sortField: recordType!Case.fields.createdOn,       /* Field reference */
sortField: recordType!Case.fields.title,           /* Field reference */
sortField: recordType!Case.relationships.status.fields.value,        /* Field reference on a many-to-one related record */
sortField: recordType!Case.relationships.priority.fields.value,      /* Field reference on a many-to-one related record */
```

**WRONG Sorting - NEVER DO THIS:**
```sail
/* ❌ Never sort on relationships - CAUSES ERRORS */
sortField: recordType!Case.relationships.status,    /* Relationship - INVALID */
sortField: recordType!Case.relationships.priority,  /* Relationship - INVALID */
```

**Fundamental Rule**: 
- **Relationships** = Navigation to related records (no sorting allowed)
- **Fields** = Data values that can be sorted, filtered, displayed
- Always sort on record fields from either the base record type or a related record type with a many-to-one relationship from the base record type
</sorting_rules>

<record_type_usage>
- **Use available record types, fields, and relationships** - Don't create new ones
- **Access rule inputs directly** - Avoid local variables for record data
- **For one-to-many relationships** - Use main record type's relationships rather than new variables
- **NEVER confuse relationships with fields** - Relationships navigate, fields display values
- **Use aggregation queries for KPIs** - Leverage native `a!queryRecordType()` with `a!aggregationFields()` for better performance than manual filtering/calculations. Avoid manual calculations whenever possible, leverage aggregations instead.
- **Use a!recordData() directly in grid and chart components** - When dealing with record data, avoid using local variables and instead use `a!recordData` directly in these components. When using record data in charts, always use the `data` + `config` approach, never `categories` + `series`.
</record_type_usage>

<checkpoint>
🚨 MANDATORY CHECKPOINT: For grids with record data, ALWAYS check for and prefer:
1. User filters (userFilters parameter) over custom dropdowns
2. Built-in search (showSearchBox: true) over custom search fields
Only use custom filtering if built-in features are unavailable.
</checkpoint>

<array_manipulation_patterns>
## Array and Data Manipulation Patterns

<combining_data>
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
</combining_data>

<wherecontains_usage>
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
</wherecontains_usage>
</array_manipulation_patterns>
</critical_rules>

<button_widget_parameters>
## 🚨 CRITICAL: a!buttonWidget() Parameter Rules

**Valid Parameters ONLY:**
- `label`, `value`, `saveInto`, `submit`, `style`, `color`, `size`, `icon`
- `disabled`, `showWhen`, `validate`, `skipValidation`
- `loadingIndicator`, `confirmMessage`, `confirmHeader`, `link`

**❌ INVALID Parameters:**
- `validations` (does NOT exist - use form-level validations instead)

**✅ Validation Placement:**
- **Form validations**: On `a!formLayout()` validations parameter
- **Button validations**: On `a!buttonWidget()` → ✅ `validations` parameter exists
- **Field validations**: On individual field components
</button_widget_parameters>

<wizard_layout_parameters>
## 🚨 CRITICAL: a!wizardLayout() Parameters

**Valid Parameters:**
- `titleBar`, `isTitleBarFixed`, `showTitleBarDivider`, `backgroundColor`
- `style`, `showWhen`, `steps`, `contentsWidth`, `showStepHeadings`
- `focusOnFirstInput`, `primaryButtons`, `secondaryButtons`
- `showButtonDivider`, `isButtonFooterFixed`

**❌ INVALID Parameters:**
- `validations` (does NOT exist on wizard layout)

**✅ Validation Placement for Wizards:**
- **Form-level validations**: Place on individual `a!buttonWidget()` in `primaryButtons`
- **Field validations**: Place on individual field components within steps
</wizard_layout_parameters>

<common_critical_errors>
## 🚨 MOST COMMON CRITICAL ERRORS

These errors cause immediate interface failures and violate core SAIL patterns:

<error_1>
**Error 1: Initialized Dropdown Variables with Record Data**
- **Problem**: `local!filter: "All"` when choiceValues come from records
- **Solution**: `local!filter,` (uninitialized) + `placeholder: "All"`
</error_1>

<error_2>
**Error 2: Query Results in Grid/Chart Data**
- **Problem**: `data: local!queryResults` 
- **Solution**: `data: a!recordData(...)`
</error_2>

<error_3>
**Error 3: Data Type Mismatches in Query Filters**
- **Problem**: DateTime field + Date value
- **Solution**: Use matching data type functions
</error_3>

<error_4>
**Error 4: Invalid Chart Patterns**
- **Problem 1**: `categories: {...}, series: {...}` with record data
- **Solution 1**: `data: a!recordData(...), config: a!columnChartConfig(...)`
- **Problem 2**: `interval: "MONTH"` or `interval: "WEEK"` in a!grouping()
- **Solution 2**: Use valid intervals: "MONTH_SHORT_TEXT", "DATE_SHORT_TEXT", etc.
- **Problem 3**: `stacking: "NORMAL"` in chart config
- **Solution 3**: Place `stacking` on chart field, not in config
</error_4>

<error_5>
**Error 5: Non-existent Functions**
- **Problem**: Using `a!decimalField()`, `a!dateTimeValue()`
- **Solution**: Use `a!floatingPointField()`, `dateTime()` respectively
</error_5>

<error_6>
**Error 6: Invalid Parameters on Components**
- **Problem**: `validations` parameter on `a!wizardLayout()`
- **Solution**: Place validations on `a!buttonWidget()` or field components
</error_6>

<error_7>
**Error 7: Python/JavaScript Syntax in SAIL**
- **Problem**: `condition ? trueValue : falseValue`
- **Solution**: `if(condition, trueValue, falseValue)`
</error_7>

<error_8>
**Error 8: Passing Null to Functions That Reject It**
- **Problem**: `text(a!defaultValue(dateField, null), "format")` or `user(a!defaultValue(userId, null), "firstName")`
- **Solution**: Check for null with if() BEFORE calling these functions
```sail
if(a!isNotNullOrEmpty(a!defaultValue(field, null)), text(field, "format"), "–")
```
</error_8>

<error_9>
**Error 9: Using .totalCount for KPI Metrics**
- **Problem**: `local!caseCount: a!queryRecordType(..., fetchTotalCount: true).totalCount`
- **Solution**: Use aggregations for ALL KPIs with correct data extraction pattern
```sail
local!caseCountQuery: a!queryRecordType(
  fields: a!aggregationFields(
    groupings: {},  /* No groupings = single row result */
    measures: {a!measure(function: "COUNT", field: recordType!Case.fields.id, alias: "count")}
  )
),
/* For aggregations with NO groupings, use direct property access */
local!caseCount: a!defaultValue(
  local!caseCountQuery.data.count,  /* Direct access, not index() */
  0
)
```
</error_9>

<error_10>
**Error 10: Incorrect Array and Data Manipulation Functions**
- **Problem 1**: Using `append(map, array)` - append only works with arrays of compatible types
- **Solution 1**: Use `a!update(data: array, index: 1, value: map)` to insert at beginning
- **Problem 2**: Using `wherecontains()` with 3 parameters
- **Solution 2**: `wherecontains(value, array)` only takes 2 params - use nested index() for lookups
- **Problem 3**: Using `append()` to add single item to beginning of array
- **Solution 3**: Use `a!update()` or `insert()` for positional insertion
```sail
/* ❌ WRONG - append() expects compatible types */
local!combined: append(local!singleMap, local!arrayOfMaps)  /* ERROR */

/* ✅ RIGHT - Use a!update() to insert at position */
local!combined: a!update(data: local!arrayOfMaps, index: 1, value: local!singleMap)

/* ❌ WRONG - wherecontains() only takes 2 parameters */
icon: wherecontains(value, array, arrayToExtractFrom)

/* ✅ RIGHT - Use nested index() for lookups */
icon: index(
  index(configArray, wherecontains(value, configArray.field), {}).propertyName,
  1,
  "default"
)
```
</error_10>

<error_11>
**Error 11: Incorrect Query Data Extraction Pattern**
- **Problem 1**: Using array indexing on aggregations with no groupings
- **Solution 1**: Use direct property access for aggregations with `groupings: {}`
```sail
/* ❌ WRONG - Over-complicated for aggregations with no groupings */
local!kpiQuery: a!queryRecordType(
  fields: a!aggregationFields(groupings: {}, measures: {a!measure(...)})
),
local!value: index(index(local!kpiQuery.data, 1, {}).alias, 1, null)

/* ✅ RIGHT - Direct property access */
local!value: a!defaultValue(local!kpiQuery.data.alias, 0)
```

- **Problem 2**: Missing array indexing on regular field queries
- **Solution 2**: Use `[1]` to access first row of regular query results
```sail
/* ❌ WRONG - Missing array index for regular query */
local!userQuery: a!queryRecordType(
  fields: {recordType!User.fields.name}
).data,
local!name: local!userQuery['recordType!User.fields.name']  /* ERROR */

/* ✅ RIGHT - Index into first row */
local!name: a!defaultValue(
  local!userQuery[1]['recordType!User.fields.name'],
  ""
)
```

**Key Rule**:
- Aggregations with `groupings: {}` → Direct access: `query.data.alias`
- Regular queries with `fields: {...}` → Array indexing: `query[1]['field']`
</error_11>
</common_critical_errors>

<mandatory_null_safety>
## 🚨 MANDATORY: Null Safety Implementation

<null_checking_checkpoint>
**CHECKPOINT: Before finalizing any SAIL expression, verify EVERY direct field reference uses a!defaultValue()**

- ✅ `a!defaultValue(ri!record[recordType!Example.fields.field], "")` 
- ✅ `a!defaultValue(ri!record[recordType!Example.fields.field], null)`
- ✅ `a!defaultValue(ri!record[recordType!Example.relationships.rel], {})`
- ❌ `ri!record[recordType!Example.fields.field]` (naked field reference)
</null_checking_checkpoint>

<required_patterns>
**Required Null Safety Patterns:**

1. **Form Field Values**: Always wrap in `a!defaultValue()`
   ```sail
   value: a!defaultValue(ri!record[recordType!X.fields.title], ""),
   ```

2. **User Function Calls**: Always check for null user IDs BEFORE calling user() function
   ```sail
   /* ✅ CORRECT - Check for null BEFORE calling user() */
   if(
     a!isNotNullOrEmpty(a!defaultValue(userIdField, null)),
     trim(
       user(userIdField, "firstName") & " " & user(userIdField, "lastName")
     ),
     "–"
   )

   /* ❌ WRONG - Checking null INSIDE user() call - user() will fail if passed null */
   trim(
     user(a!defaultValue(userIdField, null), "firstName") & " " &
     user(a!defaultValue(userIdField, null), "lastName")
   )
   ```

   **Critical Note**: The user() function CANNOT accept null as the first parameter. If the field value is null, user() will cause an error. You MUST check for null with an if() statement BEFORE calling user(), not inside the user() function call.

   **Note on User Display Names:**
   - Use `user(userId, "firstName") & " " & user(userId, "lastName")` instead of `displayName`
   - The `displayName` field is actually a nickname and is not always populated
   - Wrap in `trim()` to clean up any extra whitespace
   - Use "–" (en dash) as fallback for null/empty users instead of text like "Unknown User" or "Unassigned"

3. **Array Operations**: Protect all array references
   ```sail
   length(a!defaultValue(ri!record[recordType!X.relationships.items], {}))
   ```

4. **Validation Logic**: Wrap all validation checks
   ```sail
   if(
     a!isNullOrEmpty(a!defaultValue(ri!record[recordType!X.fields.required], "")),
     "Field is required",
     null
   )
   ```
</required_patterns>

<implementation_reminder>
**🚨 CRITICAL REMINDER**: The `a!defaultValue()` function prevents interface failures by handling null field references gracefully. This is MANDATORY for all direct field access, not optional. Missing this causes immediate runtime errors.
</implementation_reminder>
</mandatory_null_safety>

<functions_that_reject_null>
## 🚨 CRITICAL: Functions That Cannot Accept Null Values

**Some Appian functions will fail immediately if passed null values, even with a!defaultValue(). These require if() checks BEFORE calling the function:**

<null_rejecting_functions>
**Functions That Reject Null:**
- `user(userId, property)` - Cannot accept null userId
- `group(groupId, property)` - Cannot accept null groupId
- `text(value, format)` - Cannot accept null value when formatting dates/numbers
- String manipulation functions on null: `upper()`, `lower()`, `left()`, `right()`, `find()`

```sail
/* ✅ CORRECT Pattern for null-rejecting functions */
if(
  a!isNotNullOrEmpty(a!defaultValue(fieldValue, null)),
  functionThatRejectsNull(fieldValue, otherParams),
  fallbackValue
)

/* ❌ WRONG - a!defaultValue() inside the function doesn't prevent the error */
functionThatRejectsNull(a!defaultValue(fieldValue, null), otherParams)
```

**Rule**: When a function operates ON a value (not just passing it through), check for null BEFORE calling the function. The a!defaultValue() wrapper alone is not sufficient for these functions.
</null_rejecting_functions>
</functions_that_reject_null>

<query_filters_with_rule_inputs>
## 🚨 CRITICAL: Protecting Query Filters That Use Rule Inputs

**Rule inputs can be null in CREATE scenarios or when related data doesn't exist yet. Query filters that use rule input values MUST use `applyWhen` to prevent runtime errors.**

<when_ri_values_are_null>
**When Rule Input Values Can Be Null:**

1. **CREATE Scenarios**: `ri!record` is null when creating a new record
2. **Related Record Filtering**: Parent record's ID field may not exist yet
3. **Optional Relationships**: Related records might not be populated
4. **Conditional Data**: Fields that are only populated under certain conditions

**The Problem**: Query filters with null values can cause runtime errors. Using `applyWhen` conditionally applies the filter only when the value exists.
</when_ri_values_are_null>

<applywhen_pattern>
**Required Pattern for Filters Using Rule Inputs:**

```sail
/* ✅ CORRECT - Use applyWhen to protect against null rule input values */
a!queryFilter(
  field: 'recordType!ChildRecord.fields.parentId',
  operator: "=",
  value: ri!parentRecord['recordType!ParentRecord.fields.id'],
  applyWhen: a!isNotNullOrEmpty(ri!parentRecord['recordType!ParentRecord.fields.id'])
)

/* ❌ WRONG - No applyWhen protection, will fail if ri!parentRecord is null or ID doesn't exist */
a!queryFilter(
  field: 'recordType!ChildRecord.fields.parentId',
  operator: "=",
  value: ri!parentRecord['recordType!ParentRecord.fields.id']
)
```

**Key Rule**: Any query filter whose `value` parameter comes from a rule input (ri!) MUST include an `applyWhen` check using `a!isNotNullOrEmpty()`.
</applywhen_pattern>

<common_scenarios>
**Common Scenarios Requiring applyWhen:**

**Scenario 1: Filtering Related Records in a Grid**
```sail
a!gridField(
  data: a!recordData(
    recordType: 'recordType!SupportingDocument',
    filters: a!queryFilter(
      field: 'recordType!SupportingDocument.fields.applicationId',
      operator: "=",
      value: ri!application['recordType!Application.fields.applicationId'],
      applyWhen: a!isNotNullOrEmpty(ri!application['recordType!Application.fields.applicationId'])
    )
  ),
  /* ... */
)
```

**Scenario 2: Querying Child Records Based on Parent**
```sail
local!childRecords: a!queryRecordType(
  recordType: 'recordType!Comment',
  filters: a!queryFilter(
    field: 'recordType!Comment.fields.taskId',
    operator: "=",
    value: ri!task['recordType!Task.fields.taskId'],
    applyWhen: a!isNotNullOrEmpty(ri!task['recordType!Task.fields.taskId'])
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: -1)
).data
```

**Scenario 3: Multiple Filters with Rule Inputs**
```sail
a!queryRecordType(
  recordType: 'recordType!Document',
  filters: a!queryLogicalExpression(
    operator: "AND",
    filters: {
      a!queryFilter(
        field: 'recordType!Document.fields.caseId',
        operator: "=",
        value: ri!case['recordType!Case.fields.caseId'],
        applyWhen: a!isNotNullOrEmpty(ri!case['recordType!Case.fields.caseId'])
      ),
      a!queryFilter(
        field: 'recordType!Document.fields.status',
        operator: "=",
        value: "Active"
        /* No applyWhen needed - literal values are never null */
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: -1)
)
```
</common_scenarios>

<applywhen_checklist>
**✅ CHECKPOINT: Before Finalizing Query Filters**

For every `a!queryFilter()` in your code, verify:
- [ ] Does the `value` parameter use a rule input (ri!)?
- [ ] If yes, have I added `applyWhen: a!isNotNullOrEmpty(value)`?
- [ ] Have I tested the interface in CREATE mode where ri! might be null?
- [ ] Are literal values (like "Active", 5, true) used without applyWhen? (correct - they're never null)
</applywhen_checklist>

<why_this_matters>
**Why This Matters:**

- **CREATE Forms**: When creating new records, `ri!record` is null and has no ID yet
- **Runtime Safety**: Queries with null filter values can fail or return unexpected results
- **User Experience**: Prevents interface errors when users create new records or when related data is missing
- **Best Practice**: Using `applyWhen` is the standard Appian pattern for conditional filtering

**Remember**: If a query filter's value comes from `ri!`, it MUST have `applyWhen`.
</why_this_matters>
</query_filters_with_rule_inputs>

<complex_scenario_handling>
## 🔥 Complex Scenario Handling

**For interfaces with multiple record types:**
- **Identify the primary (base) record type first**
- **Map all relationships before implementation**
- **Use relationship navigation instead of separate queries where possible**
- **Consolidate filters at the primary record level**
- **Avoid creating unnecessary local variables for related data**
</complex_scenario_handling>

<assumption_documentation>
## 📝 REQUIRED ASSUMPTION TRACKING

When making assumptions about:
- **Record relationships** - State what you're assuming about connections
- **Business logic** - Explain your interpretation of requirements  
- **User intent** - Clarify what you think they want when ambiguous
- **Data structure** - Note any inferred patterns from context

**Format:** "ASSUMPTION: [what you're assuming] - REASON: [why you're assuming this]"
</assumption_documentation>

<sail_structure>
## Essential SAIL Structure

<local_variables_pattern>
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
</local_variables_pattern>

<variable_declaration_rules>
- **With initial values**: `local!variable: value`
- **Without initial values**: `local!variable` (no null/empty placeholders)
- **For dropdowns**: Initialize to valid `choiceValue` OR use `placeholder`
- **For booleans**: Always explicit: `true()` or `false()`
</variable_declaration_rules>

<nested_context_variables>
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
</nested_context_variables>
</sail_structure>

<audit_fields_management>
## Audit Fields Management

<create_scenario>
Set ALL Fields
```sail
saveInto: {
  a!save(ri!record.fields.createdBy, loggedInUser()),
  a!save(ri!record.fields.createdOn, now()),
  a!save(ri!record.fields.modifiedBy, loggedInUser()),
  a!save(ri!record.fields.modifiedOn, now())
}
```
</create_scenario>

<update_scenario>
Set ONLY Modified Fields
```sail
saveInto: {
  a!save(ri!record.fields.modifiedBy, loggedInUser()),
  a!save(ri!record.fields.modifiedOn, now())
}
```
</update_scenario>

<related_record_creation>
```sail
'recordType!Comment'(
  'recordType!Comment.fields.description': local!commentText,
  'recordType!Comment.fields.createdBy': loggedInUser(),
  'recordType!Comment.fields.createdOn': now(),
  'recordType!Comment.fields.modifiedBy': loggedInUser(),
  'recordType!Comment.fields.modifiedOn': now()
)
```
</related_record_creation>
</audit_fields_management>

<data_querying_patterns>
## Data Querying Patterns - CRITICAL USAGE RULES

<mandatory_usage_rules>
🚨 MANDATORY: Use Cases by Function

<recorddata_usage>
a!recordData() - ONLY for Grid/Chart Data
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
</recorddata_usage>

<queryrecordtype_usage>
a!queryRecordType() - For ALL Other Data Queries
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
</queryrecordtype_usage>

<kpi_aggregation_pattern>
🚨 CRITICAL: Use Aggregations for KPI Calculations
ALWAYS use a!aggregationFields() with a!measure() for KPIs - NEVER use .totalCount for metrics
```sail
/* ✅ CORRECT - Aggregation for KPI counts */
local!caseCountQuery: a!queryRecordType(
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
/* For aggregation queries with NO groupings, access field directly */
local!totalCases: a!defaultValue(
  local!caseCountQuery.data.case_count,
  0
)

/* ✅ CORRECT - Aggregation for filtered KPI counts */
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
/* For aggregation queries with NO groupings, access field directly */
local!openCases: a!defaultValue(
  local!openCasesQuery.data.open_count,
  0
)

/* ✅ CORRECT - Aggregation for SUM */
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
/* For aggregation queries with NO groupings, access field directly */
local!totalRevenue: a!defaultValue(
  local!revenueSumQuery.data.total_revenue,
  0
)

/* ✅ CORRECT - Aggregation for AVERAGE */
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
/* For aggregation queries with NO groupings, access field directly */
local!avgOrderValue: a!defaultValue(
  local!avgOrderQuery.data.avg_order,
  0
)

/* ❌ WRONG - Using .totalCount for KPIs */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!totalCases: local!caseQuery.totalCount  /* AVOID - Use aggregation instead */
```

**When to Use Each Approach:**

| Use Case | Correct Approach | Why |
|----------|-----------------|-----|
| **KPI counts (dashboard metrics)** | `a!aggregationFields()` with `a!measure()` | Better performance, database-level calculation |
| **KPI calculations (SUM, AVG, MIN, MAX)** | `a!aggregationFields()` with `a!measure()` | ONLY way to calculate these metrics |
| **Pagination info in grids** | `.totalCount` property | Appropriate for showing "Showing X of Y results" |
| **Simple count for conditional logic** | `.totalCount` property | OK for one-off checks like "if(query.totalCount > 0)" |

**Key Benefits of Aggregations for KPIs:**
- Better performance (database-level calculation)
- Consistent pattern for all metrics (COUNT, SUM, AVG, MIN, MAX, etc.)
- More maintainable and scalable
- Leverages record type's query optimization
- Allows grouping and multiple measures in one query

**MANDATORY: ALWAYS use `a!aggregationFields()` for dashboard KPIs, metrics, and statistics. Only use `.totalCount` for pagination display or simple conditional checks.**
</kpi_aggregation_pattern>

<query_data_extraction_patterns>
🚨 CRITICAL: Query Data Extraction Patterns

**IMPORTANT: Different query types require different data extraction patterns.**

<aggregation_query_extraction>
**Pattern 1: Aggregation Queries with NO Groupings**

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
</aggregation_query_extraction>

<regular_query_extraction>
**Pattern 2: Regular Queries Returning Rows**

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
  local!currentApplicant[1]['recordType!Applicant.fields.applicantId'],  /* Index into first row */
  null
),
local!firstName: a!defaultValue(
  local!currentApplicant[1]['recordType!Applicant.fields.firstName'],  /* Index into first row */
  ""
),

/* ❌ WRONG - Trying to access property directly without array indexing */
local!applicantId: a!defaultValue(
  local!currentApplicant['recordType!Applicant.fields.applicantId'],  /* ERROR - Missing [1] */
  null
)
```
</regular_query_extraction>

<pattern_decision_guide>
**How to Decide Which Pattern to Use:**

| Query Type | When to Use | Data Extraction Pattern | Example |
|------------|-------------|------------------------|---------|
| **Aggregation (no groupings)** | KPIs, metrics, counts, SUM, AVG | Direct property access: `query.data.alias` | `local!count: query.data.total_count` |
| **Aggregation (with groupings)** | Grouped metrics, charts | Array iteration with matching | `index(results, wherecontains(value, results.field), {})` |
| **Regular query (fields list)** | Single record lookup, form data | Array indexing: `query[1]['field']` | `query[1]['recordType!X.fields.name']` |
| **Regular query (multiple rows)** | Lists, grids, dropdowns | Use `.data` property directly | `local!items: query.data` |

**Key Indicators:**
- See `groupings: {}`? → Use direct property access: `.data.alias`
- See `groupings: {a!grouping(...)}`? → Use `a!forEach()` or `index()` + `wherecontains()` for matching
- See `fields: { recordType!X.fields.y }`? → Use array indexing: `[1]['field']`
- Using `a!aggregationFields()`? → Check if groupings exist
  - No groupings → Direct access
  - Has groupings → Iterate or match with wherecontains()

**IMPORTANT: The index() + wherecontains() pattern is ONLY for:**
- Lookups from configuration/reference arrays (see wherecontains section)
- Aggregations WITH groupings where you need to match specific group values (see sparse aggregation section)

**NEVER use index() for aggregations with NO groupings - use direct property access instead.**
</pattern_decision_guide>

<common_mistakes>
**Common Mistakes to Avoid:**

```sail
/* ❌ MISTAKE 1: Array indexing on aggregations with no groupings */
local!kpiQuery: a!queryRecordType(
  fields: a!aggregationFields(groupings: {}, measures: {...})
),
local!value: local!kpiQuery.data[1].alias  /* WRONG - no need for [1] */

/* ✅ CORRECT */
local!value: local!kpiQuery.data.alias  /* Direct access */

/* ❌ MISTAKE 2: Direct access on regular queries */
local!userQuery: a!queryRecordType(
  fields: {recordType!User.fields.name}
).data,
local!name: local!userQuery['recordType!User.fields.name']  /* WRONG - missing [1] */

/* ✅ CORRECT */
local!name: local!userQuery[1]['recordType!User.fields.name']  /* Array indexing */

/* ❌ MISTAKE 3: Over-complicated extraction */
local!value: index(index(query.data, 1, {}).field, 1, null)  /* Too complex */

/* ✅ CORRECT - Simple pattern for aggregations */
local!value: a!defaultValue(query.data.field, defaultValue)
```
</common_mistakes>

<extraction_checklist>
**Data Extraction Checklist:**
- [ ] Identified query type: aggregation (no groupings), aggregation (with groupings), or regular query?
- [ ] For aggregations with NO groupings: Using direct property access `.data.alias`?
- [ ] For regular queries: Using array indexing `[1]['field']` to get first row?
- [ ] Wrapped extraction in `a!defaultValue()` with appropriate default?
- [ ] Not over-complicating with nested `index()` calls when simpler pattern exists?
</extraction_checklist>
</query_data_extraction_patterns>

<direct_record_usage>
Direct Record Type - For Simple Grids
```sail
/* ✅ Use direct record type when no filtering needed */
a!gridField(
  data: recordType!PurchaseOrder,
  /* Columns auto-generated from record list configuration */
)
```
</direct_record_usage>
</mandatory_usage_rules>

<critical_data_usage_violations>
🚨 CRITICAL VIOLATIONS TO AVOID:

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
</critical_data_usage_violations>

<sparse_aggregation_handling>
🚨 CRITICAL: Handling Sparse Aggregation Results
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
</sparse_aggregation_handling>

<filter_rules>
Critical Filter Rules

<filter_structure_options>
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
</filter_structure_options>
</filter_rules>

<aggregation_usage>
Aggregation Usage
```sail
/* ✅ CORRECT - Use fields parameter with aggregationFields */
a!queryRecordType(
  recordType: recordType!Case,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: recordType!Case.fields.status,
        alias: "status_group"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "case_count"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
)

/* ❌ WRONG - No separate aggregations parameter exists */
a!queryRecordType(
  recordType: recordType!Case,
  aggregations: {...}  /* This parameter doesn't exist */
)
```
</aggregation_usage>

<sorting_in_query>
Sorting in a!queryRecordType
```sail
/* ✅ CORRECT - Sort inside pagingInfo */
a!queryRecordType(
  recordType: recordType!Employee,
  fields: {...},
  pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: 100,
    sort: a!sortInfo(
      field: recordType!Employee.fields.lastName,
      ascending: true
    )
  ),
  fetchTotalCount: true
)

/* ❌ WRONG - No direct sort parameter exists */
a!queryRecordType(
  recordType: recordType!Employee,
  sort: a!sortInfo(...),  /* This parameter doesn't exist */
)
```
</sorting_in_query>
</data_querying_patterns>

<function_parameter_validation>
## 🚨 CRITICAL: Function Parameter Validation

<array_functions_exact_counts>
Array Functions - EXACT Parameter Counts
```sail
/* ✅ CORRECT - wherecontains() takes ONLY 2 parameters */
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
</array_functions_exact_counts>

<function_parameter_rules>
Common Function Parameter Rules
- **Always verify parameter counts match Appian documentation exactly**
- **Function signature errors cause immediate interface failures**
- **No optional parameters exist unless explicitly documented**
</function_parameter_rules>

<logical_functions_boolean_logic>
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
</logical_functions_boolean_logic>
</function_parameter_validation>

<component_usage_patterns>
## Component Usage Patterns

<button_widget_rules>
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
</button_widget_rules>

<user_group_field_components>
User and Group Field Components
**CRITICAL**: When using record fields of type User or Group in forms, use the appropriate picker components.

```sail
/* ✅ CORRECT - User fields */
a!pickerFieldUsers(
  label: "Assignee",
  value: ri!record['recordType!Example.fields.userField'],
  saveInto: ri!record['recordType!Example.fields.userField'],
  maxSelections: 1,
  placeholder: "Select a user"
)

/* ✅ CORRECT - Group fields */
a!pickerFieldGroups(
  label: "Team",
  value: ri!record['recordType!Example.fields.groupField'],
  saveInto: ri!record['recordType!Example.fields.groupField'],
  maxSelections: 1,
  placeholder: "Select a group"
)

/* ❌ WRONG - Don't use dropdowns for User/Group fields */
a!dropdownField(...)  /* Incorrect for User/Group types */
```
</user_group_field_components>

<encrypted_text_field_limitations>
Encrypted Text Field with Synced Record Types

**CRITICAL**: `a!encryptedTextField()` is NOT compatible with synced record types.
```sail
/* ❌ WRONG - Cannot use with synced record types */
a!encryptedTextField(
  label: "Password",
  value: ri!record['recordType!Example.fields.password'],
  saveInto: ri!record['recordType!Example.fields.password']
)

/* ✅ CORRECT - Use standard text field with warning banner */
a!messageBanner(
  primaryText: "Review required",
  secondarytext: "Encrypted text field changed to standard text field due to synced record type limitations. Consider implementing additional security measures for password handling.",
  backgroundColor: "WARN",
  showWhen: true()
),
a!textField(
  label: "Password",
  instructions: "Password must be between 8-16 characters",
  value: a!defaultValue(
    ri!record['recordType!Example.fields.password'],
    ""
  ),
  saveInto: ri!record['recordType!Example.fields.password'],
  required: true()
)
```
**Rule***: When synced record types require password or sensitive text fields:
1. Use a!textField() instead of a!encryptedTextField()
2. Add a!messageBanner() with backgroundColor: "WARN" above the field
3. Include clear message explaining the technical limitation
4. Mark as "Review required" to flag for stakeholder attention
5. This is an acceptable UX modification exception due to technical constraints
</encrypted_text_field_limitations>

<dropdown_field_critical_patterns>
Dropdown Field Rules - CRITICAL PATTERNS

<dropdown_initialization_critical>
🚨 CRITICAL: Dropdown Variable Initialization

**NEVER initialize dropdown variables when using record data:**
```sail
/* ❌ WRONG - Will cause dropdown failures */
local!selectedStatus: "All Statuses",  /* Value not in choiceValues */

/* ✅ CORRECT - Declare without initialization */
local!selectedStatus,  /* Starts as null, placeholder shows */
```

**Rule**: When dropdown choiceValues come from record queries, the variable must start uninitialized (null) to prevent value/choiceValues mismatches.
</dropdown_initialization_critical>

```sail
/* ✅ CORRECT - Record data dropdowns. Use query results directly  */
a!dropdownField(
  choiceLabels: local!statuses['recordType!Status.fields.value'],  /* Display text */
  choiceValues: local!statuses['recordType!Status.fields.id'],     /* Store IDs */
  value: local!selectedStatusId,                                   /* Variable stores ID */
  saveInto: local!selectedStatusId,
  placeholder: "All Statuses"  /* Use placeholder, not append() */
)

/* ✅ CORRECT - Use placeholder for "All" options instead */
choiceLabels: local!statuses.value,
placeholder: "All Statuses"

/* ❌ WRONG - Never use append() with record data */
choiceLabels: append("All", local!statuses.value)

/* ❌ WRONG - Never use value-to-ID translation */
local!selectedId: index(
  wherecontains(local!textValue, local!statuses.value),  /* wherecontains() returns array! */
  local!statuses.id,
  null
)

/* ❌ WRONG - wherecontains() with index() for single values */
wherecontains("text", array)  /* Returns [2, 5] not 2 */
```
</dropdown_field_critical_patterns>

<rich_text_display_field_structure>
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
      link: a!recordLink(recordType: recordType!Case, identifier: 1)
    )
  }
)
```

<available_rich_text_components>
Available Rich Text Components:
- `a!richTextItem()` - Text with formatting and optional links
- `a!richTextIcon()` - Icons with color and size
- `a!richTextImage()` - Embedded images
- `a!richTextBulletedList()` - Bullet point lists
- `a!richTextNumberedList()` - Numbered lists
- `char(10)` - Line breaks
- Plain text strings
</available_rich_text_components>
</rich_text_display_field_structure>

<grid_field_essentials>
Grid Field Essentials
**CRITICAL**: Grid column `value` property must be one of these specific component types:
- Text (string)
- `a!imageField()`
- `a!linkField()`
- `a!richTextDisplayField()`
- `a!tagField()`
- `a!buttonArrayLayout()`
- `a!recordActionField()`
- `a!progressBarField()`

```sail
a!gridField(
  data: a!recordData(
    recordType: recordType!PurchaseOrder,
    filters: {
      a!queryFilter(
        field: recordType!PurchaseOrder.fields.status,
        operator: "=",
        value: local!filterStatus,
        applyWhen: a!isNotNullOrEmpty(local!filterStatus)
      )
    }
  ),
  columns: {
    a!gridColumn(
      label: "Title",
      value: a!richTextDisplayField(
        value: {
          a!richTextItem(
            text: fv!row[recordType!PurchaseOrder.fields.title],
            link: a!recordLink(
              recordType: recordType!PurchaseOrder,
              identifier: fv!identifier
            )
          )
        }
      ),
      sortField: recordType!PurchaseOrder.fields.title,  /* ✅ Field reference only */
      width: "MEDIUM"
    )
  },
  emptyGridMessage: "No records found"  /* Text only - no rich text or components */
)
```
</grid_field_essentials>

<builtin_grid_features>
Built-in Grid Features (Always Prefer)

```sail
/* ✅ CORRECT - Use built-in user filters when available */
a!gridField(
  data: a!recordData(recordType: recordType!Case),
  userFilters: {
    recordType!Case.filters.Status,
    recordType!Case.filters.Priority
  },
  showSearchBox: true(),  /* Built-in text search */
  columns: { /* ... */ }
)

/* ❌ WRONG - Custom dropdowns when user filters exist */
local!filterStatus,  /* Unnecessary when user filters exist */
a!dropdownField(...),  /* Don't create custom filters */
a!gridField(
  data: a!recordData(
    recordType: recordType!Case,
    filters: { /* custom filters */ }
  )
)
```
</builtin_grid_features>

<record_links_and_identifiers>
## 🚨 CRITICAL: Record Links and Identifiers

<fv_identifier_availability>
**fv!identifier Availability Rules**

`fv!identifier` is ONLY automatically available in specific contexts where Appian provides it:

**✅ Available Contexts:**
1. **Grid columns with `a!recordData()`** - Identifier provided automatically
2. **Grid recordActions parameter** - For row-specific actions

**❌ NOT Available Contexts:**
1. **`a!forEach()` over query results** - Must use primary key field instead
2. **`a!forEach()` over `.data` property** - Must use primary key field instead
3. **Manual array iterations** - Must use primary key field instead

```sail
/* ✅ CORRECT - fv!identifier works in grids with a!recordData() */
a!gridField(
  data: a!recordData(recordType: recordType!Case),
  columns: {
    a!gridColumn(
      label: "Title",
      value: a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!row[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!identifier  /* ✅ Works - provided by a!recordData() */
          )
        )
      )
    )
  },
  recordActions: {
    a!recordActionItem(
      action: recordType!Case.actions.updateCase,
      identifier: fv!identifier  /* ✅ Works - provided by grid context */
    )
  }
)

/* ❌ WRONG - fv!identifier doesn't exist in a!forEach over query results */
local!cases: a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.caseId,
    recordType!Case.fields.title
  }
).data,

a!forEach(
  items: local!cases,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!item[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!identifier  /* ❌ ERROR - Not available in a!forEach */
          )
        )
      )
    }
  )
)

/* ✅ CORRECT - Use primary key field in a!forEach */
local!cases: a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.caseId,  /* Must query the primary key field */
    recordType!Case.fields.title
  }
).data,

a!forEach(
  items: local!cases,
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: fv!item[recordType!Case.fields.title],
          link: a!recordLink(
            recordType: recordType!Case,
            identifier: fv!item[recordType!Case.fields.caseId]  /* ✅ Use primary key */
          )
        )
      )
    }
  )
)
```
</fv_identifier_availability>

<record_link_identifier_rules>
**Record Link Identifier Rules:**

1. **When using `a!recordData()` in grids/charts**: Use `fv!identifier`
2. **When using `a!queryRecordType().data` with `a!forEach()`**: Use the primary key field
3. **Always query the primary key field** when you need to create record links in `a!forEach()`
4. **Primary key fields are typically**: `id`, `caseId`, `orderId`, `employeeId`, etc.

**Rule of Thumb**: If you're iterating with `a!forEach()` over query results and need record links, you MUST include the primary key field in your query and use it as the identifier.
</record_link_identifier_rules>
</record_links_and_identifiers>

<grid_selection_behavior>
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

### Rule Summary
- Grid `selectionValue` contains **identifiers** (integers for static data, record IDs for records)
- `selectionValue` does NOT contain full row objects with properties
- Use `index(dataArray, identifier, defaultValue)` to retrieve full objects
- Always check: "Am I iterating over a selectionValue? Then I need index()!"

### Quick Decision Tree
Before writing code with grid selections:
1. "Is this variable from a grid's selectionValue?" → YES = need index() lookup
2. "Am I accessing properties on fv!item?" → Must verify fv!item is an object, not an ID
3. "Did I use index() to look up the full object first?" → If NO, you'll get a runtime error
</grid_selection_behavior>

<user_filters_vs_custom_filters>
User Filters vs Custom Filters
**MANDATORY**: If record type has user filters AND interface has custom filters, ASK user to choose:
- Use built-in user filters (pros/cons)
- Keep custom filtering experience (pros/cons)

<builtin_user_filters>
Built-in User Filters
```sail
a!gridField(
  data: a!recordData(recordType: recordType!PurchaseOrder),
  userFilters: {
    recordType!PurchaseOrder.filters.PurchaseOrderStatus
  }
)
```
</builtin_user_filters>

<custom_filtering_experience>
Custom Filtering Experience
```sail
a!localVariables(
  local!filterStatus,
  local!statuses: a!queryRecordType(...).data,
  {
    a!dropdownField(
      choiceLabels: local!statuses[recordType!Status.fields.value],
      choiceValues: local!statuses[recordType!Status.fields.id],
      value: local!filterStatus,
      saveInto: local!filterStatus,
      placeholder: "All Statuses"
    ),
    a!gridField(
      data: a!recordData(
        recordType: recordType!PurchaseOrder,
        filters: {
          a!queryFilter(
            field: recordType!PurchaseOrder.fields.statusId,
            operator: "=",
            value: local!filterStatus,
            applyWhen: a!isNotNullOrEmpty(local!filterStatus)
          )
        }
      )
    )
  }
)
```
</custom_filtering_experience>
</user_filters_vs_custom_filters>

<conditional_visibility_showwhen>
Conditional Visibility - showWhen Pattern
```sail
/* ✅ Use showWhen instead of if() around components */
a!textField(
  label: "Details",
  value: local!details,
  saveInto: local!details,
  showWhen: local!showDetails
)

/* ✅ Complex conditions with showWhen */
a!columnChartField(
  showWhen: and(
    local!reportType = "custom",
    contains(local!visibleCharts, "sales")
  )
)
```
</conditional_visibility_showwhen>

<selection_component_patterns>
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
</selection_component_patterns>

<single_checkbox_field_pattern>
Single Checkbox Field Pattern

**When using `a!checkboxField()` with a single choice (one choiceLabel/choiceValue pair):**
```sail
/* ✅ CORRECT - Direct assignment, no null handling needed */
a!checkboxField(
  label: "Options",
  choiceLabels: {"Enable Feature"},
  choiceValues: {true()},
  value: ri!record['recordType!Example.fields.booleanField'],
  saveInto: ri!record['recordType!Example.fields.booleanField'],
  choiceLayout: "STACKED"
)

/* ❌ WRONG - Unnecessary null checking and conversion logic */
a!checkboxField(
  label: "Options",
  choiceLabels: {"Enable Feature"},
  choiceValues: {true()},
  value: if(
    a!defaultValue(ri!record['recordType!Example.fields.booleanField'], false()),
    {true()},
    {}
  ),
  saveInto: {
    a!save(
      ri!record['recordType!Example.fields.booleanField'],
      contains(save!value, true())
    )
  }
)
```
Rule: Single checkbox fields automatically handle null-to-false conversion. Use direct assignment for both value and saveInto parameters without a!defaultValue(), if(), or contains() logic.
</single_checkbox_field_pattern>

</component_usage_patterns>

<one_to_many_relationship_management>
## 🚨 CRITICAL: One-to-Many Relationship Data Management in Forms

**When creating or updating data in a form using the ri! pattern, manage one-to-many related records through the parent record's relationship field. NEVER query them separately or use local variables.**

### Core Principle:
**In create/update forms, the relationship field IS the data source. No queries, no copies.**

### ✅ CORRECT Pattern - Direct Relationship Access

**Displaying related records in forms:**
```sail
/* Iterate directly over the relationship - Case has many Comments */
a!forEach(
  items: ri!case['recordType!Case.relationships.caseComment'],
  expression: a!cardLayout(
    contents: {
      a!paragraphField(
        label: "Comment " & fv!index,
        /* Access fields through fv!item */
        value: fv!item['recordType!Comment.fields.description'],
        saveInto: fv!item['recordType!Comment.fields.description'],
        height: "MEDIUM"
      ),
      a!dateField(
        label: "Date",
        value: fv!item['recordType!Comment.fields.commentDate'],
        saveInto: fv!item['recordType!Comment.fields.commentDate']
      )
    }
  )
)
```

**Adding new related records:**
```sail
a!buttonWidget(
  label: "Add Comment",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      append(
        ri!case['recordType!Case.relationships.caseComment'],
        'recordType!Comment'(
          'recordType!Comment.fields.commentDate': today(),
          'recordType!Comment.fields.createdBy': loggedInUser()
        )
      )
    )
  }
)
```

**Removing related records:**
```sail
a!buttonWidget(
  label: "Remove Comment",
  icon: "trash",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      remove(
        ri!case['recordType!Case.relationships.caseComment'],
        fv!index  /* Remove item at current index in forEach */
      )
    )
  },
  showWhen: length(ri!case['recordType!Case.relationships.caseComment']) > 1
)
```

**Counting related records:**
```sail
a!richTextItem(
  text: "Total Comments: " & length(
    ri!case['recordType!Case.relationships.caseComment']
  )
)
```

**Checking if relationship is empty:**
```sail
if(
  a!isNullOrEmpty(ri!case['recordType!Case.relationships.caseComment']),
  /* Show message when no comments */
  a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: "No comments added yet. Click 'Add Comment' to begin.",
          color: "SECONDARY"
        )
      )
    }
  ),
  /* Show comments when data exists */
  a!forEach(
    items: ri!case['recordType!Case.relationships.caseComment'],
    expression: ...
  )
)
```

### ❌ WRONG Pattern - Separate Queries or Local Variables

**DON'T DO THIS:**
```sail
/* ❌ WRONG - Querying related data separately */
local!caseComments: a!queryRecordType(
  recordType: 'recordType!Comment',
  filters: a!queryFilter(
    field: 'recordType!Comment.fields.caseId',
    operator: "=",
    value: ri!case['recordType!Case.fields.caseId']
  )
).data,

/* ❌ WRONG - Managing in local variable */
a!forEach(
  items: local!caseComments,  /* Don't use local variables! */
  expression: ...
)

/* ❌ WRONG - Copying relationship to local variable */
local!comments: ri!case['recordType!Case.relationships.caseComment']
/* This creates a COPY - changes won't save to the relationship */
```

### Why This Pattern Is Mandatory:
1. **Automatic persistence**: Changes to relationship fields auto-save
2. **Correct foreign keys**: Appian manages the parent-child links
3. **Single source of truth**: No sync issues between copies
4. **Simpler code**: No manual save logic needed

### Pattern Summary Table:

| Action | Use This Pattern |
|--------|------------------|
| **Display** | `a!forEach(items: ri!case['...relationships.caseComment'], ...)` |
| **Add** | `append(ri!case['...relationships.caseComment'], 'recordType!Comment'(...))` |
| **Remove** | `remove(ri!case['...relationships.caseComment'], fv!index)` |
| **Edit** | `fv!item['recordType!Comment.fields.description']` (in forEach) |
| **Count** | `length(ri!case['...relationships.caseComment'])` |
| **Check if empty** | `a!isNullOrEmpty(ri!case['...relationships.caseComment'])` |
</one_to_many_relationship_management>

<related_record_field_references>
## Related Record Field References
Don't use relationships to display values. Instead, use the first text field from the related record type.

```sail
/* ✅ CORRECT - Use specific field path with single continuous navigation */
ri!case['recordType!Case.relationships.caseComment.fields.description']

/* ❌ WRONG - Don't use bare relationship */
ri!case['recordType!Case.relationships.caseComment']

/* ❌ WRONG - Double bracket syntax */
ri!case['recordType!Case.relationships.caseComment']['recordType!Comment.fields.description']

/* ✅ CORRECT - For counting related records */
length(ri!case['recordType!Case.relationships.caseComment.fields.description'])

/* ✅ CORRECT - For displaying related data in grids */
fv!item['recordType!Comment.fields.description']
```
</related_record_field_references>

<user_field_vs_relationship>
## 🚨 CRITICAL: User/Group Fields vs Relationships

**When the data model shows BOTH a field AND a relationship for users, ALWAYS use the FIELD reference, NEVER the relationship.**

<critical_distinction>
Many record types have both:
- **Field** (e.g., `assignedTo`, `createdBy`, `modifiedBy`): User type field
- **Relationship** (e.g., `assignedToUser`, `createdByUser`, `modifiedByUser`): many-to-one relationship to User record type

**ALWAYS query and display using the FIELD, NOT the relationship:**
</critical_distinction>

<correct_user_field_usage>
```sail
/* ✅ CORRECT - Use the User field directly in queries */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.assignedTo,
    recordType!Case.fields.createdBy,
    recordType!Case.fields.modifiedBy
  }
)

/* ✅ CORRECT - Use the User field in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: if(
    a!isNotNullOrEmpty(fv!row[recordType!Case.fields.assignedTo]),
    trim(
      user(fv!row[recordType!Case.fields.assignedTo], "firstName") & " " &
      user(fv!row[recordType!Case.fields.assignedTo], "lastName")
    ),
    "–"
  ),
  sortField: recordType!Case.fields.assignedTo
)

/* ✅ CORRECT - Use the User field in forms */
a!pickerFieldUsers(
  label: "Assigned To",
  value: a!defaultValue(
    ri!case[recordType!Case.fields.assignedTo],
    null
  ),
  saveInto: ri!case[recordType!Case.fields.assignedTo]
)

/* ❌ WRONG - Don't use the User relationship */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.relationships.assignedToUser,  /* WRONG */
    recordType!Case.relationships.createdByUser,   /* WRONG */
    recordType!Case.relationships.modifiedByUser   /* WRONG */
  }
)

/* ❌ WRONG - Don't use relationship in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: fv!row[recordType!Case.relationships.assignedToUser]  /* CAUSES ERRORS */
)
```
</correct_user_field_usage>

<rule_of_thumb>
**Rule of Thumb for Fields vs Relationships:**

| Data Type | When to Use | Example |
|-----------|-------------|---------|
| **User field** | Always use the FIELD | `assignedTo`, `createdBy`, `modifiedBy` |
| **Group field** | Always use the FIELD | `teamGroup`, `departmentGroup` |
| **Date/DateTime field** | Always use the FIELD | `createdOn`, `modifiedOn`, `dueDate` |
| **Text/Number/Boolean field** | Always use the FIELD | `title`, `caseId`, `isActive` |
| **Related record data** | Use the RELATIONSHIP to navigate | `refCaseStatus.fields.value`, `teamRelationship.fields.teamname` |

**Key Principle:**
- **Fields** store scalar values (User, Date, Text, Number, Boolean) → Access directly
- **Relationships** navigate to related records via foreign keys → Use for accessing fields on the related record
</rule_of_thumb>

<why_both_exist>
**Why Both Field and Relationship Exist:**
- The **field** (e.g., `assignedTo`) stores the actual User value and is what you use for queries, displays, and forms
- The **relationship** (e.g., `assignedToUser`) exists primarily for advanced relationship modeling and is rarely used in interfaces
- The relationship may provide access to additional User record properties, but for standard use cases (displaying names, filtering by user, etc.), always use the field
</why_both_exist>
</user_field_vs_relationship>

<related_record_access_in_forms>
## 🚨 CRITICAL: Accessing Related Record Data in Forms

**When building forms, use a SINGLE rule input for the main record and access ALL related data through relationships.**

### ✅ CORRECT Pattern - Single Rule Input with Relationship Navigation

**Form interface signature:**
```sail
/* ✅ CORRECT - Single rule input for main record */
/* Rule Inputs:
 *   ri!case (Case) - The case record being edited
 */
```

**Accessing many-to-one relationships (parent/related records):**
```sail
/* Access customer name through Case → Customer relationship */
a!textField(
  label: "Customer Name",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.customerName'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.customerName']
)

/* Access customer email through same relationship */
a!textField(
  label: "Customer Email",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.email'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.email']
)

/* Access customer phone through same relationship */
a!textField(
  label: "Customer Phone",
  value: ri!case['recordType!Case.relationships.refCustomer.fields.phone'],
  saveInto: ri!case['recordType!Case.relationships.refCustomer.fields.phone']
)
```

**Accessing one-to-many relationships (child records):**
```sail
/* Display case comments through Case → Comment relationship */
a!forEach(
  items: ri!case['recordType!Case.relationships.caseComment'],
  expression: a!cardLayout(
    contents: {
      a!paragraphField(
        label: "Comment " & fv!index,
        value: fv!item['recordType!Comment.fields.description'],
        saveInto: fv!item['recordType!Comment.fields.description']
      )
    }
  )
)
```

### ❌ WRONG Pattern - Multiple Rule Inputs for Related Records

**DON'T DO THIS:**
```sail
/* ❌ WRONG - Separate rule inputs for related records */
/* Rule Inputs:
 *   ri!case (Case) - The case record
 *   ri!customer (Customer) - The related customer  /* DON'T DO THIS */
 */

/* ❌ WRONG - Accessing customer fields from separate rule input */
a!textField(
  label: "Customer Name",
  value: ri!customer['recordType!Customer.fields.customerName'],  /* WRONG */
  saveInto: ri!customer['recordType!Customer.fields.customerName']
)
```

### When to Use This Pattern:

| Relationship Type | Example | Use This Pattern |
|-------------------|---------|------------------|
| **Many-to-one (parent)** | Case → Customer | `ri!case['...relationships.refCustomer.fields.customerName']` |
| **Many-to-one (reference)** | Case → Status | `ri!case['...relationships.refCaseStatus.fields.statusName']` |
| **One-to-many (children)** | Case → Comments | `ri!case['...relationships.caseComment']` (see one-to-many section) |
| **One-to-one** | Case → Details | `ri!case['...relationships.caseDetails.fields.description']` |

### Why This Pattern Is Mandatory:

1. **Maintains data integrity**: Single rule input ensures all changes are coordinated
2. **Simpler interface signature**: Only one parameter instead of many
3. **Correct foreign key handling**: Appian manages the relationships automatically
4. **Easier to call**: Invoking interface only requires passing the main record
5. **Prevents orphaned data**: Related records stay properly linked to parent

### Pattern for Review Sections:

When displaying read-only data for review, use the same relationship navigation pattern:

```sail
/* ✅ CORRECT - Review section accessing multiple relationships */
a!sectionLayout(
  label: "Case Summary",
  contents: {
    a!columnsLayout(
      columns: {
        a!columnLayout(
          contents: {
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Customer: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refCustomer.fields.customerName']
                )
              }
            ),
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Status: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refCaseStatus.fields.statusName']
                )
              }
            )
          }
        ),
        a!columnLayout(
          contents: {
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Priority: ", style: "STRONG"),
                a!richTextItem(
                  text: ri!case['recordType!Case.relationships.refPriority.fields.priorityName']
                )
              }
            ),
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(text: "Total Comments: ", style: "STRONG"),
                a!richTextItem(
                  text: length(ri!case['recordType!Case.relationships.caseComment'])
                )
              }
            )
          }
        )
      }
    )
  }
)
```

### Key Principle:
**One record type is the "owner" of the form → Make it the rule input → Access everything else through relationships**
</related_record_access_in_forms>

<date_time_critical_rules>
## Date/Time Critical Rules

<correct_datetime_functions>
🚨 CRITICAL: Correct Date/Time Functions
```sail
/* ✅ CORRECT - Use dateTime() for specific date/time creation */
dateTime(year(today()), month(today()), 1, 0, 0, 0)  /* Month to Date */

/* ❌ WRONG - a!dateTimeValue() does NOT exist in Appian */
a!dateTimeValue(year: year(today()), month: month(today()), day: 1)
```
</correct_datetime_functions>

<query_filter_type_matching>
🚨 CRITICAL: Query Filter Data Type Matching

**The a!queryFilter function requires exact data type matching between field and value:**

```sail
/* ❌ WRONG - Date arithmetic with DateTime field */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  value: today() - 30  /* Date value - TYPE MISMATCH */
)

/* ✅ CORRECT - Use DateTime functions for DateTime fields */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  value: a!subtractDateTime(startDateTime: now(), days: 30)  /* DateTime value */
)

/* ✅ CORRECT - Date field with Date value */
a!queryFilter(
  field: recordType!Case.fields.dueDate,  /* Date field */
  value: today() - 30  /* Date value */
)
```

**Common Type Conversions:**
- **DateTime fields**: Use `a!subtractDateTime()`, `a!addDateTime()`, `now()`, `dateTime()`
- **Date fields**: Use `today()`, date arithmetic, `date()`
- **Number fields**: Use `tointeger()`, `todecimal()` 
- **Text fields**: Use `totext()`
</query_filter_type_matching>

<type_matching_prevents_failures>
Type Matching (Prevents Interface Failures)
```sail
/* ✅ Date field with Date value */
a!queryFilter(
  field: recordType!Case.fields.dueDate,  /* Date field */
  operator: ">=",
  value: today() - 30  /* Date arithmetic */
)

/* ✅ DateTime field with DateTime value */
a!queryFilter(
  field: recordType!Case.fields.createdOn,  /* DateTime field */
  operator: ">=", 
  value: a!subtractDateTime(startDateTime: now(), days: 30)
)

/* ❌ WRONG - Type mismatch causes failures */
a!queryFilter(
  field: recordType!Case.fields.dueDate,    /* Date field */
  value: a!subtractDateTime(...)            /* DateTime - FAILS */
)
```
</type_matching_prevents_failures>

<date_function_corrections>
Date Function Corrections
```sail
/* ❌ WRONG - addDateTime rejects negative values */
value: a!addDateTime(startDateTime: today(), days: -30)

/* ✅ CORRECT - Use subtractDateTime for past dates */
value: a!subtractDateTime(startDateTime: now(), days: 30)
```
</date_function_corrections>

<text_function_with_dates>
🚨 CRITICAL: text() Function with Date/DateTime Values

**The text() function CANNOT accept null values. Always check for null before calling text():**

```sail
/* ❌ WRONG - Passing null to text() causes errors */
text(a!defaultValue(fv!row['recordType!Case.fields.createdOn'], null), "MMM d, yyyy")

/* ✅ CORRECT - Check for null BEFORE calling text() */
if(
  a!isNullOrEmpty(a!defaultValue(fv!row['recordType!Case.fields.createdOn'], null)),
  "–",
  text(fv!row['recordType!Case.fields.createdOn'], "MMM d, yyyy")
)

/* ✅ CORRECT - Alternative pattern with defaultValue as fallback string */
if(
  a!isNullOrEmpty(a!defaultValue(fv!row['recordType!Case.fields.dueDate'], null)),
  "No due date",
  text(fv!row['recordType!Case.fields.dueDate'], "MM/DD/YYYY")
)
```

**Rule**: When formatting dates with text(), ALWAYS wrap in a null check that returns a fallback string (like "–" or "N/A"), NOT null.
</text_function_with_dates>
</date_time_critical_rules>

<chart_data_configuration>
## Chart Data Configuration

<record_data_charts_recommended>
Record Data Charts (Recommended)
```sail
a!barChartField(
  data: a!recordData(
    recordType: recordType!Employee,
    filters: {...}
  ),
  config: a!barChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Employee.fields.department,
      alias: "department_primaryGrouping"
    ),
    measures: {
      a!measure(
        label: "Count",
        function: "COUNT",
        field: recordType!Employee.fields.id,
        alias: "employeeCount_measure1"
      )
    }
  )
)
```
</record_data_charts_recommended>

<mock_data_charts_prototyping>
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
</mock_data_charts_prototyping>

<chart_data_extraction_rules>
Chart Data Extraction Rules
**CRITICAL**: Charts are display-only components
- **Cannot extract data from chart components** - Only from queries
- **Use separate aggregation queries for KPIs** - Don't try to read chart data
</chart_data_extraction_rules>
</chart_data_configuration>

<chart_components_usage>
## Chart Components Usage

<available_chart_types>
**Available Chart Functions:**
1. `a!areaChartField()` - Filled areas under lines for trends and cumulative values
2. `a!barChartField()` - Horizontal bars for comparing categories
3. `a!columnChartField()` - Vertical bars for comparing values across categories
4. `a!lineChartField()` - Connected points for trends over time
5. `a!pieChartField()` - Pie slices for part-to-whole relationships
6. `a!scatterChartField()` - Points on X/Y axes for correlations (record data only)
</available_chart_types>

<chart_shared_parameters>
**Parameters Shared by All Chart Types:**
- `label`, `labelPosition` (usually "COLLAPSED"), `instructions`
- `height` - Values vary by type:
  - Column/Line/Area/Bar: "MICRO", "SHORT", "MEDIUM", "TALL" (Bar also has "AUTO")
  - Pie/Scatter: "SHORT", "MEDIUM", "TALL"
- `showWhen`, `accessibilityText`
- `xAxisTitle`, `yAxisTitle` (not available for pie charts)
- `showLegend` (column, line, bar, area only - NOT pie)
- `showDataLabels`, `colorScheme`
</chart_shared_parameters>

<chart_stacking_property>
🚨 CRITICAL: Stacking Property

**ONLY these chart types have a `stacking` property:**
- `a!areaChartField()`
- `a!barChartField()`
- `a!columnChartField()`

**The `stacking` property is on the CHART FIELD, NOT in the config:**
```sail
/* ✅ CORRECT - stacking on chart field */
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(...),
  stacking: "NORMAL"  /* On chart field level */
)

/* ❌ WRONG - stacking in config (parameter doesn't exist there) */
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(
    stacking: "NORMAL"  /* INVALID - not a config parameter */
  )
)
```

**Valid stacking values:** "NONE" (default), "NORMAL", "PERCENT_TO_TOTAL"
</chart_stacking_property>

<chart_data_approaches>
**Two Data Approaches for Charts:**

**Approach 1: Static Mockup Data** (categories + series)
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

**Approach 2: Record Data** (data + config)
- Use for: ALL charts when connecting to live record data
- ⚠️ Scatter charts ONLY work with this approach
- Structure:
```sail
a!columnChartField(
  data: a!recordData(...),
  config: a!columnChartConfig(
    primaryGrouping: a!grouping(...),
    measures: {a!measure(...)}
  )
)
```

❌ **NEVER mix approaches:** Don't use `categories` + `series` with record data
❌ **NEVER use scatter charts with static mockup data** - they require record data
</chart_data_approaches>

<chart_config_parameters>
**Valid Parameters for Chart Config Functions:**
- `primaryGrouping` - a!grouping() for main data grouping
- `secondaryGrouping` - a!grouping() for multi-series charts
- `measures` - Array of a!measure() for aggregations
- `sort` - a!sortInfo() for ordering results
- `dataLimit` - Maximum number of data points
- `link` - Dynamic link for click actions
- `showIntervalsWithNoData` - Boolean for showing empty intervals

❌ **INVALID Parameters (Don't Use):**
- `stacking` - This is on the chart field, NOT in config
- `aggregations` - Use `measures` instead
- `aggregationFields` - Use `measures` instead
</chart_config_parameters>

<chart_interval_values>
🚨 CRITICAL: Valid Interval Values for a!grouping()

**The `interval` parameter in a!grouping() can ONLY be used with Date/DateTime/Time fields.**

**Valid interval values:**
- "AUTO" (default), "YEAR"
- "MONTH_OF_YEAR", "MONTH_OF_YEAR_SHORT_TEXT", "MONTH_OF_YEAR_TEXT"
- "MONTH_TEXT", "MONTH_SHORT_TEXT", "MONTH_DATE"
- "DATE", "DATE_SHORT_TEXT", "DATE_TEXT"
- "DAY_OF_MONTH"
- "HOUR_OF_DAY", "HOUR"
- "MINUTE_OF_HOUR", "MINUTE"

```sail
/* ✅ CORRECT - Valid interval values */
a!grouping(
  field: recordType!Case.fields.createdOn,
  alias: "month_grouping",
  interval: "MONTH_SHORT_TEXT"  /* Valid - shows "Jan", "Feb", etc. */
)

a!grouping(
  field: recordType!Case.fields.modifiedOn,
  alias: "date_grouping",
  interval: "DATE_SHORT_TEXT"  /* Valid - shows short date format */
)

/* ❌ WRONG - Invalid interval values */
a!grouping(
  field: recordType!Case.fields.createdOn,
  alias: "month_grouping",
  interval: "MONTH"  /* INVALID - not in allowed list */
)

a!grouping(
  field: recordType!Case.fields.modifiedOn,
  alias: "week_grouping",
  interval: "WEEK"  /* INVALID - not in allowed list */
)
```

**Rule**: Only use interval values from the documented list above. For weekly groupings, use "DATE_SHORT_TEXT" or "DATE" instead.
</chart_interval_values>

<chart_record_data_example>
**Complete Record Data Chart Example:**
```sail
a!columnChartField(
  labelPosition: "COLLAPSED",
  data: a!recordData(
    recordType: recordType!Case,
    filters: a!queryFilter(
      field: recordType!Case.fields.isActive,
      operator: "=",
      value: true
    )
  ),
  config: a!columnChartConfig(
    primaryGrouping: a!grouping(
      field: recordType!Case.relationships.status.fields.value,
      alias: "status_grouping"
    ),
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "case_count"
      )
    },
    dataLimit: 20
  ),
  xAxisTitle: "Status",
  yAxisTitle: "Number of Cases",
  showDataLabels: true,
  height: "MEDIUM"
)
```
</chart_record_data_example>
</chart_components_usage>

<kpi_performance_calculations>
## KPI and Performance Calculations
**Best Practice**: Use aggregation queries for KPIs - Leverage native `a!queryRecordType()` with `a!aggregationFields()` for better performance than manual filtering/calculations.

```sail
/* ✅ CORRECT - Aggregation query for KPI calculation */
local!caseStats: a!queryRecordType(
  recordType: recordType!Case,
  fields: a!aggregationFields(
    groupings: {
      a!grouping(
        field: recordType!Case.fields.status,
        alias: "status_group"
      )
    },
    measures: {
      a!measure(
        function: "COUNT",
        field: recordType!Case.fields.id,
        alias: "total_cases"
      )
    }
  ),
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 100),
  fetchTotalCount: true
).data,

/* ❌ WRONG - Manual filtering and calculations */
local!allCases: a!queryRecordType(...).data,
local!openCases: length(filter(rule: local!allCases.status = "Open", data: local!allCases))
```
</kpi_performance_calculations>

<record_actions>
## Record Actions

<critical_recordactionfield_usage>
🚨 CRITICAL: Use a!recordActionField() for Standalone Actions
```sail
/* ✅ CORRECT - Standalone record actions */
a!recordActionField(
  actions: {
    a!recordActionItem(
      action: recordType!Case.actions.newCase
    )
  },
  style: "TOOLBAR_PRIMARY"
)

/* ❌ WRONG - Don't use button widgets for record actions */
a!buttonWidget(
  saveInto: a!recordActionItem(...)  /* Invalid pattern */
)

/* ❌ WRONG - Don't use a!startProcess for record actions */
a!buttonWidget(
  saveInto: a!startProcess(processModel: ...)  /* Use recordActionField instead */
)
```
</critical_recordactionfield_usage>

<recordactionitem_function>
a!recordActionItem() Function
```sail
/* Grid record actions */
recordActions: {
  a!recordActionItem(
    action: recordType!Case.actions.updateCase,
    identifier: fv!identifier
  )
}

/* Standalone record action */
a!recordActionField(
  actions: {
    a!recordActionItem(
      action: recordType!Case.actions.newCase
    )
  },
  style: "TOOLBAR_PRIMARY"
)
```
</recordactionitem_function>

<record_action_implementation_rules>
Record Action Implementation Rules
- **For standalone record actions**: Always use `a!recordActionField()` with `a!recordActionItem()`
- **For grid record actions**: Use `recordActions` parameter with `a!recordActionItem()`
- **Never use `a!startProcess()`** when record actions are available
- **Never use button widgets** to trigger record actions
</record_action_implementation_rules>
</record_actions>

<create_update_scenarios>
## Create/Update Scenarios

<critical_null_checking>
Critical Null Checking
```sail
/* ✅ CORRECT - Direct field references */
a!defaultValue(ri!employee[recordType!Employee.fields.firstName], "N/A")

/* ❌ WRONG - Function results (will fail) */
a!defaultValue(user(local!id, "firstName"), "Unknown")

/* ✅ CORRECT alternative */
if(
  a!isNotNullOrEmpty(local!userId),
  user(local!userId, "firstName"), 
  "Unknown"
)
```
</critical_null_checking>

<record_instance_creation>
Record Instance Creation
```sail
'recordType!Case'(
  'recordType!Case.fields.title': "New Case",
  'recordType!Case.fields.priority': 1
)
```
</record_instance_creation>

<form_field_with_record_data>
Form Field with Record Data
```sail
a!textField(
  value: ri!order[recordType!Order.fields.description],
  saveInto: ri!order[recordType!Order.fields.description],
  validations: if(
    a!isNullOrEmpty(ri!order[recordType!Order.fields.description]),
    "Description is required",
    null
  )
)
```
</form_field_with_record_data>
</create_update_scenarios>

<essential_functions_reference>
## Essential Functions Reference

<preferred_functions>
Preferred Functions
- **Null Checking**: `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()` over `isnull()`
- **Logical**: `and()`, `or()`, `not()` over infix operators
- **Looping**: `a!forEach()` over `map()`
- **Matching**: `a!match()` over `choose()`
- **Array Operations**: `append()`, `a!update()` for immutable operations
- **Audit Functions**: `loggedInUser()`, `now()` for audit fields
</preferred_functions>

<json_functions>
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
</json_functions>

<contains_usage>
contains() Usage
```sail
/* Arrays */
contains({"id", "title"}, "title")  /* Returns true */

/* Record arrays */
contains(
  local!records[recordType!Employee.fields.firstName], 
  "Alice"
)
```
</contains_usage>

<available_appian_functions>
Available Appian Functions (Use Only These)

<core_functions>
Core Functions:
- **Array**: `a!flatten()`, `append()`, `index()`, `length()`, `where()`, `wherecontains()`
- **Logical**: `and()`, `or()`, `not()`, `if()`, `a!match()`
- **Null Checking**: `a!isNullOrEmpty()`, `a!isNotNullOrEmpty()`, `a!defaultValue()`
- **Looping**: `a!forEach()`, `filter()`, `reduce()`, `merge()`
- **Text**: `concat()`, `find()`, `left()`, `len()`, `substitute()`, `upper()`, `lower()`
- **Date/Time**: `today()`, `now()`, `dateTime()`, `a!addDateTime()`, `a!subtractDateTime()`
- **JSON**: `a!toJson()`, `a!fromJson()`, `a!jsonPath()`
- **User/System**: `loggedInUser()`, `user()`
</core_functions>

<query_functions>
Query Functions:
- **Primary**: `a!queryRecordType()`, `a!recordData()`
- **Filters**: `a!queryFilter()`, `a!queryLogicalExpression()`
- **Paging**: `a!pagingInfo()`, `a!sortInfo()`
- **Aggregation**: `a!aggregationFields()`, `a!grouping()`, `a!measure()`
</query_functions>
</available_appian_functions>
</essential_functions_reference>

<when_implementation_fails>
## 🔧 When Implementation Fails

**If interface fails to load:**
1. **Check all parentheses and brackets are matched** - Use IDE bracket matching
2. **Verify all local variables are declared at top** - No undeclared variable usage
3. **Confirm a!recordData() only used in grids/charts** - Never in local variables
4. **Validate function parameter counts** - Use function validation checkpoint
5. **Check field vs relationship usage** - User/Group/Date/Text/Number fields use FIELD references, NOT relationships; relationships only for navigating to related record data
6. **Verify record type references are exact** - No truncated UUIDs
7. **Confirm all saveInto targets are valid** - Local variables or rule inputs only
8. **Check null handling** - Use a!isNotNullOrEmpty() for validation
9. **Verify relationship navigation syntax** - Single continuous path, no double brackets
10. **Check grid column sorting** - Only sort on fields, never on relationships
</when_implementation_fails>

<syntax_validation_checklist>
## 🚨 SYNTAX VALIDATION CHECKLIST

<critical_syntax_checks>
Critical Syntax:
- [ ] Expression starts with `a!localVariables()`
- [ ] **ALL local variables declared before use**
- [ ] **`a!recordData()` used ONLY inside `a!gridField()` or charts**
- [ ] **`a!queryRecordType()` used for all other data queries**
- [ ] **Audit fields set on create/update operations**
- [ ] **`a!pickerFieldUsers()` used for User fields, `a!pickerFieldGroups()` for Group fields**
- [ ] **Function parameter counts verified: `wherecontains(value, array)`, `contains(array, value)`**
- [ ] **Relationship navigation uses single continuous path: `record.relationships.relation.fields.field`**
- [ ] **Grid sorting uses ONLY field references, NEVER relationship references**
- [ ] **ALL direct field references wrapped in `a!defaultValue()`**
- [ ] **User function calls protected with null checking via `if()` statements**
- [ ] **Array operations use `a!defaultValue()` with empty array fallbacks**

<array_function_validation>
Array Function Validation:
- [ ] **append() used only with array + array or array + compatible scalar**
- [ ] **wherecontains() called with exactly 2 parameters: `wherecontains(value, array)`**
- [ ] **a!update() used for inserting/replacing at specific index positions**
- [ ] **Single items prepended to arrays use `a!update()` or `insert()`, NOT `append()`**
- [ ] **No mixing of incompatible types in `append()` (e.g., map + array)**
</array_function_validation>
- [ ] **Form validations use `a!defaultValue()` for field references**
- [ ] **No naked field references (ri!record[field] without a!defaultValue)**
- [ ] **Dropdown variables with record data are uninitialized (declared without values)**
- [ ] **All a!queryFilter value parameters match field data types (DateTime to DateTime, etc.)**
- [ ] **Charts use a!recordData() with config parameter, not categories/series**
- [ ] **Grids use a!recordData() directly, not query results in local variables**
- [ ] **All functions exist in Appian (no made-up functions like a!decimalField)**
- [ ] **No Python/JavaScript syntax patterns (use if() not ternary operators)**
- [ ] **a!wizardLayout() has no validations parameter**
- [ ] **a!buttonWidget() parameters are all valid**
- [ ] **a!floatingPointField() used for decimal values, not a!decimalField()**
- [ ] All parentheses `()` and curly brackets `{}` properly matched
- [ ] Field references use square brackets: `fv!row[recordType!Name.fields.field]`
- [ ] No `a!flatten()` in filter arrays
- [ ] `applyWhen` used for conditional filters instead of `if()` around them
- [ ] `fetchTotalCount: true` always set in `a!queryRecordType()`
- [ ] Sort configured inside `a!pagingInfo()`, not directly on query
- [ ] Placeholder always set on dropdowns when value can be null
- [ ] `showWhen` used instead of `if()` around components
- [ ] Date/DateTime type matching in filters
- [ ] Record actions use only `action` and `identifier` parameters
- [ ] **One-to-many data saved on base record using relationships**
- [ ] **Related record values use specific field paths, not bare relationships**
- [ ] **`emptyGridMessage` contains text only - no rich text or components**
- [ ] **Aggregation uses `fields: a!aggregationFields()` not separate `aggregations` parameter**
- [ ] **Never use `append()` with record data in dropdown choices - use placeholders**
- [ ] **Proper boolean logic in `and()` and `or()` functions**
- [ ] **Use `dateTime()` function, never `a!dateTimeValue()` (doesn't exist)**
- [ ] **Local variables in nested contexts use `a!localVariables()` blocks**
- [ ] **Sparse aggregation data handled with record-based matching, not position matching**
- [ ] **Rich text display fields use arrays of rich text components**
- [ ] **Grid column values use only approved component types**
- [ ] **Record actions use `a!recordActionField()` not button widgets**
- [ ] **KPIs use a!aggregationFields() with a!measure(), NOT .totalCount**
- [ ] **Aggregation queries with NO groupings use direct property access: `query.data.alias`**
- [ ] **Regular field queries use array indexing for first row: `query[1]['field']`**
- [ ] **Query data extraction pattern matches query type (aggregation vs regular)**
- [ ] **Single checkbox fields use direct assignment without null handling or conversion logic**
- [ ] **No `a!encryptedTextField()` used with synced record types - use `a!textField()` with warning banner instead**
- [ ] **`fv!identifier` ONLY used in grids with `a!recordData()` or grid recordActions - use primary key field in `a!forEach()`**
- [ ] **Record links in `a!forEach()` use primary key field as identifier, NOT `fv!identifier`**
- [ ] **Primary key field included in query when creating record links in `a!forEach()`**
- [ ] **text() function with dates wrapped in null check that returns string fallback (NOT null)**
- [ ] **user() and group() functions called ONLY after null checking with if() statement**
- [ ] **No null values passed to functions that operate on values (user, group, text, upper, lower, etc.)**
- [ ] **All date/time formatting with text() has fallback string like "–" or "N/A"**
- [ ] **Charts use a!recordData() with config parameter when using record data**
- [ ] **Chart interval values are from valid list (MONTH_SHORT_TEXT, DATE_SHORT_TEXT, etc.) - NOT "MONTH" or "WEEK"**
- [ ] **Stacking property (if used) is on chart field level, NOT in config**
- [ ] **Chart config uses only valid parameters: primaryGrouping, secondaryGrouping, measures, sort, dataLimit, link, showIntervalsWithNoData**
- [ ] **Scatter charts ONLY use record data approach (data + config), never categories + series**
</critical_syntax_checks>

<relationship_navigation_validation>
🚨 CRITICAL: Relationship Navigation Validation
- [ ] **All relationship field references use single continuous path**
- [ ] **No double bracket syntax: `record.relation.field` NOT `[record.relation][otherRecord.field]`**
- [ ] **Grid sorting references fields only, never relationships**
- [ ] **Related record values accessed through relationships with proper field paths**
- [ ] **User/Group fields use FIELD references (assignedTo, createdBy) NOT relationship references (assignedToUser, createdByUser)**
- [ ] **Date/DateTime fields use FIELD references (createdOn, modifiedOn) NOT relationship references**
- [ ] **Scalar fields (Text, Number, Boolean) use FIELD references, NOT relationships**
</relationship_navigation_validation>

<form_data_pattern_validation>
🚨 CRITICAL: Form Data Pattern Validation
- [ ] **Form interfaces use SINGLE rule input for main record (e.g., ri!case), not multiple inputs for related records**
- [ ] **All related record data accessed through relationships from main rule input**
- [ ] **Many-to-one relationships accessed via: `ri!mainRecord['...relationships.relatedRecord.fields.fieldName']`**
- [ ] **One-to-many relationships accessed directly: `ri!mainRecord['...relationships.childRecords']` (no local variables)**
- [ ] **No separate queries for related data that exists as relationships**
- [ ] **No local variables copying relationship data (changes won't save)**
- [ ] **Non-existent constants/process models use `null` with TODO comments, not assumed names**
- [ ] **Only use fields that exist in the data model (check context/data-model-context.md)**
- [ ] **No invented field names (e.g., "legalName" when only firstName/lastName exist)**
- [ ] **One-to-many add operations use: `append(ri!record['...relationships.children'], cast(...))`**
- [ ] **One-to-many remove operations use: `remove(ri!record['...relationships.children'], fv!index)`**
- [ ] **One-to-many edit operations use: `fv!item['recordType!Child.fields.fieldName']` in a!forEach**
</form_data_pattern_validation>

<dropdown_record_data_validation>
Dropdown & Record Data Validation:
- [ ] **Dropdown choiceValues use record IDs, choiceLabels use record text fields**
- [ ] **No append() used with record data - placeholders used instead**
- [ ] **No value-to-ID translation logic - dropdowns store IDs directly**
- [ ] **No wherecontains() + index() patterns for single value lookups**
- [ ] **Filter variables contain IDs that match database field types**
</dropdown_record_data_validation>

<layout_validation>
Layout Validation:
- [ ] No `sideBySideLayout` in grid columns
- [ ] Rich text contains only allowed elements
- [ ] `emptyGridMessage` used instead of conditional grid rendering
- [ ] Grid selection parameters configured when using record actions
</layout_validation>

<grid_features_validation>
Grid Features:
- [ ] Used userFilters parameter when record type has user filters
- [ ] Used showSearchBox: true for text search (not custom search fields)
- [ ] No custom filter dropdowns when built-in features available
</grid_features_validation>
</syntax_validation_checklist>


