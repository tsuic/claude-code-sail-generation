# SAIL LocalVariables Usage Instructions

## Overview
LocalVariables provides a way to define and manage temporary variables within a SAIL interface. It must be the top-level parent element of every SAIL expression and can also be used within the interface to create scoped variables for specific sections.

## ✅ MANDATORY RULE: All SAIL expressions must begin with a!localVariables()
Every SAIL interface must have `a!localVariables()` as the outermost wrapper, even if no local variables are defined.

```sail
/* CORRECT - Always start with localVariables */
a!localVariables(
  local!userName: "John Doe",
  local!isVisible: true(),
  
  /* Main interface as final parameter */
  a!formLayout(
    contents: {
      a!textField(
        label: "Name",
        value: local!userName,
        saveInto: local!userName
      )
    }
  )
)
```

## Core LocalVariables Structure

### Basic Syntax
```sail
a!localVariables(
  /* Variable definitions (optional) */
  local!variableName1: value1,
  local!variableName2,              /* No initial value - just declare by name */
  local!variableName3: value3,
  
  /* Main interface (required - always last parameter) */
  interfaceExpression
)
```

### Key Rules
- **Variable definitions come first**: All local variable assignments before the interface
- **Interface expression is last**: The actual UI components come as the final parameter
- **No trailing commas**: Don't add commas after the last interface expression
- **Local prefix required**: All variables must start with `local!`
- **No placeholder values**: Variables without initial values should be declared by name only, not nulls or empty strings
- **Rules must already exist**: You cannot define new rules inline; only call existing rule objects
- **Escape quotes properly**: To escape double quotes use "" not \"

## Two Usage Patterns: Global and Scoped Variables

### Pattern 1: Global Variables (Top-Level)
Variables needed throughout the entire interface should be defined at the top level.

### Pattern 2: Scoped Variables (Nested)
Variables needed only within specific sections can be scoped using nested `a!localVariables()`.

```sail
a!localVariables(
  /* Global variables - used throughout interface */
  local!currentUser: loggedInUser(),
  local!userRole: "ADMIN",
  
  a!formLayout(
    contents: {
      /* Section 1 with its own scoped variables */
      a!localVariables(
        local!sectionTitle: "Personal Information",
        local!isExpanded: false(),
        local!validationMessage,
        
        a!sectionLayout(
          label: local!sectionTitle,
          isCollapsible: true(),
          isInitiallyCollapsed: not(local!isExpanded),
          contents: {
            /* Section content using scoped variables */
          }
        )
      ),
      
      /* Section 2 with different scoped variables */
      a!localVariables(
        local!chartData: rule!getChartData(local!currentUser),
        local!selectedPeriod: "LAST_30_DAYS",
        
        a!sectionLayout(
          label: "Analytics",
          contents: {
            a!columnChartField(
              data: local!chartData,
              /* Chart configuration */
            )
          }
        )
      )
    }
  )
)
```

## Variable Declaration Patterns

### Variable Initialization Best Practices:
- **Dropdown values**: Always initialize with a valid choice value OR set a placeholder on the dropdown
- **Radio/Checkbox values**: Can be left uninitialized
- **Text fields**: Can be left uninitialized (will default to empty string)
- **Boolean fields**: Initialize with `true()` or `false()` for clarity
- **Date fields**: Can be left uninitialized or set to default dates

Example:
```sail
local!statusFilter: " ",  // Valid choice value for "All" option
local!searchText,         // OK to leave uninitialized
local!isActive: true(),   // Boolean should be explicit
```

### ✅ CORRECT Variable Declarations
```sail
a!localVariables(
  /* Variables with initial values */
  local!pageTitle: "Employee Dashboard",
  local!currentYear: year(today()),
  local!maxItems: 10,
  local!isVisible: true(),
  
  /* Variables without initial values - declare by name only */
  local!firstName,
  local!lastName,
  local!selectedDepartment,
  local!submissionDate,
  
  /* Rule calls to existing rules */
  local!userData: rule!getCurrentUserData(),
  local!permissions: rule!getUserPermissions(local!userData.id),
  
  /* Interface */
)
```

### ❌ WRONG Variable Declarations
```sail
a!localVariables(
  /* DON'T use placeholder values */
  local!firstName: "",              /* ❌ Don't use empty string */
  local!lastName: null,             /* ❌ Don't use null */
  local!selectedItems: {},          /* ❌ Don't use empty array unless intentional */
  
  /* DON'T try to define rules inline */
  local!customRule: rule!myNewRule(param: _), /* ❌ Cannot define rules */
  
  /* Interface */
)
```

### ✅ CORRECT Use With Dropdowns
```sail
a!localVariables(
  local!status: " ", /*Initialized to choiceValue of Select status choice*/
  /*Interface*/
  ...
  a!dropdownField(
    choiceLabels: {"Select status", "Pending", "Active", "Completed"},
    choiceValues: {" ", "Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status
  )
  ...
)

a!localVariables(
  local!status, /*No initial value, but dropdown has placeholder*/
  /*Interface*/
  ...
  a!dropdownField(
    choiceLabels: {"Pending", "Active", "Completed"},
    choiceValues: {"Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status,
    placeholder: "Select status"
  )
  ...
)
```

### ❌ WRONG Use With Dropdowns
```sail

a!localVariables(
  local!status, /*No initial value (null) AND dropdown is missing a placeholder*/
  /*Interface*/
  ...
  a!dropdownField(
    choiceLabels: {"Select status", "Pending", "Active", "Completed"},
    choiceValues: {" ", "Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status,
  )
  ...
)
```

### ✅ CORRECT Use With Radio Buttons
```sail
a!localVariables(
  local!status, /*No initial value (null)*/
  /*Interface*/
  ...
 a!radioButtonField(
    choiceLabels: {"Pending", "Active", "Completed"},
    choiceValues: {"Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status,
  )
  ...
)

a!localVariables(
  local!status: “Pending”, /*Initial value matches valid choiceValue/
  /*Interface*/
  ...
 a!radioButtonField(
    choiceLabels: {"Pending", "Active", "Completed"},
    choiceValues: {"Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status,
  )
  ...
)
```

### ❌ WRONG Use With Radio Buttons
```sail

a!localVariables(
  local!status: “ “, /*Initial value doesn’t match any choiceValue in radio button field*/
  /*Interface*/
  ...
 a!radioButtonField(
    choiceLabels: {"Pending", "Active", "Completed"},
    choiceValues: {"Pending", "Active", "Completed"},
    value: local!status,
    saveInto: local!status,
  )
  ...
)
```

## Rule Usage in Local Variables

### ✅ CORRECT Rule Usage
Rules must already exist as objects in your Appian system before they can be called.

```sail
a!localVariables(
  /* Calling existing rules with parameters */
  local!userData: rule!getUserData(loggedInUser()),
  local!permissions: rule!getUserPermissions(local!userData.id),
  
  /* Interface */
)
```
### ❌ INVALID Rule Usage
You cannot define new rules inline or create rule-like functions within local variables.

```sail
a!localVariables(
  /* ❌ WRONG - Cannot define rules inline */
  local!isPhotoSelected: rule!isPhotoSelected(photoId: _, selectedIds: local!selectedPhotoIds),
  
  /* ❌ WRONG - Cannot create rule definitions */
  local!calculateTotal: rule!sum(items: _, field: "price"),
  
  /* ❌ WRONG - Cannot define custom rule logic */
  local!customFilter: rule!filter(data: _, criteria: local!filterCriteria),
  
  /* Interface */
)
```

## Best Practices Summary

### ✅ DO:
- Always wrap expressions in `a!localVariables()`
- Define variables before the interface
- Call existing rules only - never try to define new ones inline
- Pre-calculate expensive operations
- Break complex logic into multiple variables
- Declare variables by name only when they don't need initial values
- Use scoped variables to keep calculations close to where they're used

### ❌ DON'T:
- Put variables after the interface expression
- Try to define new rules inline as variable values
- Recalculate the same value multiple times
- Create circular dependencies between variables
- Omit the `local!` prefix
- Add placeholder values like `""`, `null`, or `{}` unless intentional

## Validation Checklist

### Syntax Validation:
- [ ] Expression starts with `a!localVariables()`
- [ ] All variable names use `local!` prefix
- [ ] Variables defined before interface expression
- [ ] Double quotes escaped like "" (NOT \") in values
- [ ] No circular dependencies between variables
- [ ] Only calls to existing rules, no inline rule definitions

### Variable Declaration Validation:
- [ ] Variables without meaningful defaults declared by name only
- [ ] Initial values used only when specific defaults needed
- [ ] No unnecessary empty strings, nulls, or empty arrays
- [ ] Consistent declaration style throughout interface

### Rule Usage Validation:
- [ ] All rule calls reference existing rule objects
- [ ] No attempts to define rules inline
- [ ] Rule parameters are correctly formatted
- [ ] Alternative approaches used when rules don't exist

### Dropdown Value Validation:
- [ ] Variables initialized to a valid choiceValue *unless* a placeholder is set on the dropdown
