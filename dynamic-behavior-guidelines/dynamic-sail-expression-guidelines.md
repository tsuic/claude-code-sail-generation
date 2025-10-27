# DYNAMIC SAIL UI EXPRESSION GUIDELINES

<critical_rules>
## 🚨 MANDATORY FOUNDATION RULES

<expression_structure>
1. **All SAIL expressions must begin with `a!localVariables()`** - even if no variables are defined
2. **ALL local variables must be declared before use** - No undeclared variables allowed
3. **Use only available Appian functions** - No JavaScript equivalents exist
4. **Appian data is immutable** - Use functional approaches like `append()` instead of mutation
5. **Always validate for null values** - Use `a!isNullOrEmpty()` and `a!isNotNullOrEmpty()`
6. **Set audit fields on create/update** - createdBy, createdOn, modifiedBy, modifiedOn
7. **Never use `append()` with record data in dropdown choices - use placeholders**
8. **For dropdowns with record data**: Use record IDs as choiceValues and record text fields as choiceLabels - NO value-to-ID translation needed
9. **wherecontains() returns arrays, not single values** - Don't use with index() for single value lookups
10. **Always try to use record types for populating read-only grids (`a!griField()`) and charts** - instead of using mock data.
</expression_structure>

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
- **Use a!recordData() directly in the grid and chart components** - When dealing with record data, avoid using local variables and instead use `a!recordData` directly in these components.
</record_type_usage>

<checkpoint>
🚨 MANDATORY CHECKPOINT: Before implementing any interface with record data, check if the record type has user filters. If it does AND the interface includes custom filters, STOP and ask the user to choose between built-in user filters vs custom filtering experience.
</checkpoint>
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
**Error 4: Mock Chart Patterns with Record Data**
- **Problem**: `categories: {...}, series: {...}`
- **Solution**: `data: a!recordData(...), config: a!columnChartConfig(...)`
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

2. **User Function Calls**: Always check for null user IDs first
   ```sail
   if(
     a!isNotNullOrEmpty(a!defaultValue(userIdField, null)),
     trim(
       user(userIdField, "firstName") & " " & user(userIdField, "lastName")
     ),
     "–"
   )
   ```

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
local!totalCases: index(local!caseCountQuery.data, 1, {}).case_count

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
local!openCases: index(local!openCasesQuery.data, 1, {}).open_count

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
local!totalRevenue: index(local!revenueSumQuery.data, 1, {}).total_revenue

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
local!avgOrderValue: index(local!avgOrderQuery.data, 1, {}).avg_order

/* ❌ WRONG - Using .totalCount for KPIs */
local!caseQuery: a!queryRecordType(
  recordType: recordType!Case,
  fields: {recordType!Case.fields.id},
  pagingInfo: a!pagingInfo(startIndex: 1, batchSize: 1),
  fetchTotalCount: true
),
local!totalCases: local!caseQuery.totalCount  /* AVOID - Use aggregation instead */
```
When to Use Each Approach:

Use .totalCount: ONLY for pagination in grids showing lists of records
Use a!measure() COUNT: For ALL KPI counts, metrics, and dashboard statistics
Use a!measure() SUM/AVG/MIN/MAX: For ALL calculated KPI values

Key Benefits of Aggregations:

Better performance (database-level calculation)
Consistent pattern for all metrics (COUNT, SUM, AVG, etc.)
More maintainable and scalable
Leverages record type's query optimization
</kpi_aggregation_pattern>

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
## One-to-Many Relationship Data Management
When creating or updating data in a form, always save data from related records with a one-to-many relationship on the base record type using the relationship.

```sail
/* ✅ CORRECT - Save comments on the Case record using relationship */
a!save(
  ri!case['recordType!Case.relationships.caseComment'],
  append(
    ri!case['recordType!Case.relationships.caseComment'],
    'recordType!Comment'(
      'recordType!Comment.fields.description': local!newComment
    )
  )
)

/* ❌ WRONG - Don't use separate local variables for related data */
local!comments: {...}  /* Avoid this pattern */
```
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
    'recordType!Case.fields.{41905c99-3332-4704-bf2e-c0ea6b8b2207}assignedTo',
    'recordType!Case.fields.{782fab03-6e79-464d-862d-9766558ead34}createdBy',
    'recordType!Case.fields.{24dc24a9-c3a8-4c5b-b0f2-227247049eb6}modifiedBy'
  }
)

/* ✅ CORRECT - Use the User field in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: if(
    a!isNotNullOrEmpty(fv!row['recordType!Case.fields.{41905c99...}assignedTo']),
    trim(
      user(fv!row['recordType!Case.fields.{41905c99...}assignedTo'], "firstName") & " " &
      user(fv!row['recordType!Case.fields.{41905c99...}assignedTo'], "lastName")
    ),
    "–"
  ),
  sortField: 'recordType!Case.fields.{41905c99-3332-4704-bf2e-c0ea6b8b2207}assignedTo'
)

/* ✅ CORRECT - Use the User field in forms */
a!pickerFieldUsers(
  label: "Assigned To",
  value: a!defaultValue(
    ri!case['recordType!Case.fields.{41905c99-3332-4704-bf2e-c0ea6b8b2207}assignedTo'],
    null
  ),
  saveInto: ri!case['recordType!Case.fields.{41905c99-3332-4704-bf2e-c0ea6b8b2207}assignedTo']
)

/* ❌ WRONG - Don't use the User relationship */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    'recordType!Case.relationships.{b2f0c709...}assignedToUser',  /* WRONG */
    'recordType!Case.relationships.{e102da15...}createdByUser',   /* WRONG */
    'recordType!Case.relationships.{8a2834b3...}modifiedByUser'   /* WRONG */
  }
)

/* ❌ WRONG - Don't use relationship in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: fv!row['recordType!Case.relationships.assignedToUser']  /* CAUSES ERRORS */
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
- [ ] **Single checkbox fields use direct assignment without null handling or conversion logic**
- [ ] **No `a!encryptedTextField()` used with synced record types - use `a!textField()` with warning banner instead**
- [ ] **`fv!identifier` ONLY used in grids with `a!recordData()` or grid recordActions - use primary key field in `a!forEach()`**
- [ ] **Record links in `a!forEach()` use primary key field as identifier, NOT `fv!identifier`**
- [ ] **Primary key field included in query when creating record links in `a!forEach()`**
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
</syntax_validation_checklist>


