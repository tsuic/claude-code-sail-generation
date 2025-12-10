# PROJECT INSTRUCTIONS - SAIL UI GENERATION

## PURPOSE AND GOALS
- Given a request, generate an Appian SAIL UI mockup
- Write generated output to a .sail file in the /output folder
- Use only valid SAIL components and the allowed parameter values for each
- Use modern, but business-appropriate styling
- Don't worry about querying live data, just hard-code sample content using local variables and a!map
- Don't use `ri!` or `recordtype!` references to live record data unless explicitly asked to
- Inline ALL logic - no `rule!` or `cons!` references unless explicitly specified!
  - ❌ SAIL does not support inline function definitions or helper expressions stored in variables
  - ❌ CANNOT create reusable logic: `local!calculateColor: rule!helper` (syntax error - rule references cannot be stored in variables)
  - ❌ CANNOT define inline helper functions or lambdas: `local!helper: expression` (not supported in SAIL)
  - ✅ Repeat logic inline wherever needed (even if duplicative across multiple columns/components)
  - ✅ For complex repeated logic, use if()/a!match() patterns directly in each location
- ‼️Syntax errors are DISASTROUS and MUST BE AVOIDED at any cost! Be METICULOUS about following instructions to avoid making mistakes!
- ❌Don't assume that a parameter or parameter value exists - ✅ONLY use values specifically described in `/ui-guidelines/reference/sail-api-schema.json`
- When converting mock to functional, apply ALL "Logic Refactoring Requirements" (see dedicated section below), refactor code structure for record queries (e.g., chart patterns), but preserve visual design

## ⚠️ BEFORE YOU BEGIN - MANDATORY RULES
1. ❌ NEVER nest sideBySideLayouts inside sideBySideLayouts
2. ❌ NEVER put arrays of components inside sideBySideLayouts
3. ❌ NEVER put columnsLayouts or cardLayouts inside sideBySideLayouts
4. ✅ ONLY richTextItems or richTextIcons are allowed inside richTextDisplayField
5. ✅ Each columnsLayout must have at least one AUTO-width columnLayout
6. ❌ choiceValues CANNOT be null or empty strings
7. ⚠️ ALWAYS check for null before comparisons/property access - use if() NOT and() (see NULL SAFETY RULES section)

If you violate any of these rules, STOP and reconsider your approach.

## 🚨 UNIVERSAL SAIL VALIDATION CHECKLIST

**This checklist applies to BOTH mock generation AND functional conversion.**

Use this checklist:
- ✅ When generating new mockup interfaces (primary agent)
- ✅ When converting mockups to functional (sail-dynamic-converter agent)
- ✅ Before calling validation sub-agents

### Before Writing Dynamic Code:
- [ ] Read `/logic-guidelines/local-variable-patterns.md` for data modeling philosophy (maps for entity data, separate variables for UI state)
- [ ] Read `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` if using arrays, loops, null checking in mock data interfaces
- [ ] Read `/record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md` if working with record types, queries, or relationships
- [ ] Remember that SAIL doesn't support regex

### Dynamic Form Field Validation:
- [ ] **Pattern Selection for Multi-Instance Forms** (see `/logic-guidelines/foreach-patterns.md`):
  - [ ] **Array of Maps** (PREFERRED): When collecting multiple instances of related data (work experiences, addresses, contacts, line items) → Use `local!items: {a!map(...)}` with `saveInto: fv!item.propertyName` ‼️
  - [ ] **Parallel Arrays** (ALTERNATIVE): Only when iterating over a FIXED source list to collect SEPARATE data → Use `index()` + `a!update()` pattern
- [ ] Parallel arrays type-initialized based on data type (see array-type-initialization-guidelines.md) ‼️
- [ ] NO `value: null, saveInto: null` in input fields (textField, dateField, fileUploadField, etc.) ‼️
- [ ] Multi-select checkbox fields use single array variable, NOT separate boolean variables ‼️ (see `/logic-guidelines/checkbox-patterns.md`)

### Syntax Validation:
- [ ] Starts with a!localVariables()
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes
- [ ] Escape double quotes like "", not like \" ✅ CHECK EVERY STRING VALUE
- [ ] Comments use /* */ not //
- [ ] `or(a,b)` NOT `a or b` ‼️
- [ ] Range comparisons use `a!match(whenTrue:)` NOT nested `if()` ‼️
- [ ] Empty arrays type-initialized: `tointeger({})`, `touniformstring({})`, `toboolean({})`, `todate({})`, `todatetime({})`, `todecimal({})`, `totime({})`, `touser({})`, `togroup({})` ‼️
- [ ] Text arrays use `touniformstring({})` NOT `tostring({})` (tostring merges to single string) ‼️
- [ ] NO untyped `{}` used with contains(), wherecontains(), union(), intersection() ‼️
- [ ] NO mixed-type appends that create List of Variant ‼️
- [ ] All null-unsafe operations protected (see "NULL SAFETY RULES" section) ‼️
  - Comparisons wrapped in if() short-circuit pattern
  - Property access checked before use
  - Function parameters use a!defaultValue() where needed
  - Grid selections use index(..., 1, null) pattern
- [ ] **Relationships ONLY used with: a!relatedRecordData(), null checks, array functions (a!forEach, length), or field navigation** ‼️
- [ ] **All other functions receive FIELD values (User, Text, Number, Date), NOT relationships** ‼️
- [ ] **user() function: Pass User FIELD or Text username - NEVER relationships** ‼️
- [ ] **NEVER use touser() - user() already accepts both User and Text types** ‼️
- [ ] Date arithmetic wrapped in todate() in sample data - use `todate(today() + 1)` ‼️
- [ ] No Interval-to-Number comparisons - use `tointeger()` to convert first ‼️
- [ ] index() wrapped in type converters for arithmetic - use `todate(index(...))`, `tointeger(index(...))`, etc. ‼️
- [ ] **Query result property access**: Field queries use `'recordType!Type.fields.name'`, aggregations use `"aliasName"` ‼️ (see `/record-query-guidelines/query-result-structures.md`)

### Function Variable Validation:
- [ ] ✅ In grid columns: ONLY use `fv!row` (NOT fv!index, NOT fv!item) ‼️
- [ ] ❌ NEVER use `fv!index` in grid columns - use grid's selectionValue instead ‼️
- [ ] ✅ Grid selectionValue is always a LIST - use `index(local!selected, 1, null)` to access
- [ ] ✅ In a!forEach(): Use `fv!index`, `fv!item`, `fv!isFirst`, `fv!isLast`
- [ ] ❌ NEVER use `fv!item` outside of a!forEach() ‼️

### Parameter Validation:
- [ ] Check to see that every parameter and value is listed in documentation before using!
- [ ] For functional interfaces: ALL a!measure() functions validated against sail-api-schema.json
- [ ] For functional interfaces: ALL a!queryFilter() operators validated against `/record-query-guidelines/query-filters-operators.md`

### Layout Validation:
- [ ] One top-level layout (HeaderContent/FormLayout/PaneLayout)
- [ ] No nested sideBySideLayouts
- [ ] No columns or card layouts inside sideBySideItems
- [ ] Only richTextItems or richTextIcons in richTextDisplayField
- [ ] At least one AUTO width column in each columnsLayout
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!

## 📚 DOCUMENTATION REQUIREMENT

**ALWAYS read component docs from `/ui-guidelines/` BEFORE writing code.** Never assume you know how a component works—read the documentation first, code second.

**Two-tier documentation structure:**
1. **Schema Reference** - `/ui-guidelines/reference/sail-api-schema.json` summarizes ALL SAIL components and functions with their parameters and valid values

### Schema Structure:
```json
{
  "components": {
    "a!componentName": {
      "description": "What it does",
      "category": "layout|input|display|chart|helper|...",
      "parameters": {
        "paramName": {
          "type": "Text|Integer|Boolean|...",
          "required": true|false,
          "validValues": ["OPTION1", "OPTION2", ...],  // ONLY these!
          "acceptsHexColors": true|false
        }
      },
      "specialNote": "Important warnings or constraints"
    }
  },
  "expressionFunctions": {
    "functionName": {
      "syntax": "functionName(param1, param2, ...)",
      "parameterCount": 3,
      "description": "What it does"
    }
  }
}
```

2. **Detailed Instructions** - Select components have dedicated instruction files (listed below) - don't use a component in code without first reading its instructions!!!

### Available Documentation Files:

**Core Reference (use for ALL components):**
- `reference/sail-api-schema.json` - Complete parameter reference for all SAIL components (JSON schema)

**Expression Grammar & Variables:**
- `reference/expression-grammar-instructions.md` - Expression grammar for calculation, logic, conversion functions (✅ ALWAYS check for function signatures)

**Layout Components:**
- `layouts/header-content-layout-instructions.md` - HeaderContentLayout guidelines
- `layouts/columns-layout-instructions.md` - ColumnsLayout guidelines
- `layouts/sidebyside-layout-instructions.md` - SideBySideLayout guidelines
- `layouts/form-layout-instructions.md` - FormLayout guidelines
- `layouts/pane-layout-instructions.md` - PaneLayout guidelines
- `layouts/wizard-layout-instructions.md` - WizardLayout guidelines
- `layouts/card-layout-instructions.md` - CardLayout guidelines

**Display Components:**
- `components/button-instructions.md` - Button and ButtonArrayLayout guidelines
- `components/grid-field-instructions.md` - GridField (read-only grid) guidelines
- `components/grid-layout-instructions.md` - GridLayout (editable grid) guidelines
- `components/rich-text-instructions.md` - Rich Text component guidelines
- `components/stamp-field-instructions.md` - Stamp Field guidelines
- `components/card-choice-field-instructions.md` - Card Choice Field guidelines
- `components/chart-instructions.md` - Chart component guidelines
- `components/image-field-instructions.md` - Image Field guidelines
- `components/tabular-data-display-pattern.md` - Custom tabular display pattern

**Icons:**
- `reference/rich-text-icon-aliases.md` - Valid icon aliases for richTextIcon (**MUST READ before using any icons**)

**All other components** (textField, dropdownField, etc.) are documented in `/ui-guidelines/reference/sail-api-schema.json` only.

### Documentation Lookup Process:

1. **Check if a dedicated instruction file exists** for the component (see list above)
   - If YES → Read the dedicated file for templates, patterns, and detailed rules
   - If NO → Use `/ui-guidelines/reference/sail-api-schema.json` for parameters and values

2. **For unfamiliar components** - Read the component entry in `/ui-guidelines/reference/sail-api-schema.json` first to understand basic parameters

### ❌ NEVER:
- Use parameters that aren't explicitly documented in either the reference or instruction files
- Put components in layouts that don't accept them
- Skip reading documentation because "it seems straightforward"

### ✅ ALWAYS:
- Start with `/ui-guidelines/reference/sail-api-schema.json` for parameter validation
- Read dedicated instruction files when available for templates and patterns
- Follow templates exactly from instruction files
- Verify against validation checklists
- **Read `/ui-guidelines/reference/rich-text-icon-aliases.md` in full before using ANY icons**

**THIS IS NOT OPTIONAL. Skipping documentation causes critical errors.**

## 🔄 DYNAMIC SAIL EXPRESSIONS

**When working with dynamic data (arrays, loops, conditionals), ALWAYS read the appropriate guidelines FIRST:**

### **FOUNDATIONAL SAIL SYNTAX (Required for ALL Interfaces)**
**Read:** `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md`

**Contains:** Universal SAIL syntax rules that apply to **both mock and functional interfaces:**
- ✅ **Language-specific syntax** (and/or/if functions, NOT JavaScript operators)
- ✅ **Null safety and short-circuit evaluation** patterns
- ✅ **Function parameter validation** (wherecontains, index, a!forEach, etc.)
- ✅ **Array manipulation, loops, property access**
- ✅ **Grid selection patterns** (two-variable approach, naming conventions)
- ✅ **Checkbox patterns** (initialization, multi-select vs single)
- ✅ **Chart data configuration**
- ✅ **Date/time type handling**
- ✅ **Pattern matching with a!match()**
- ✅ **Dynamic form field patterns**

**⚠️ Important:** This file contains **FOUNDATIONAL rules for ALL SAIL code** (both mock and dynamic interfaces).

### **RECORD TYPE INTEGRATION (When Using Record Data)**
**Read:** `/record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md`

**Contains:** Record-specific patterns built **ON TOP of LOGIC-PRIMARY-REFERENCE.md:**
- ✅ **Record type reference syntax** (UUID usage)
- ✅ **Form interface data patterns** (ri! vs queries decision tree)
- ✅ **Query construction** (a!queryRecordType, a!recordData)
- ✅ **Relationship navigation** (one-to-many, many-to-one)
- ✅ **Record type constructors** vs a!map()
- ✅ **Testing simulation variables**

**⚠️ Critical:** Functional interfaces with record types and data use **ALL rules from LOGIC-PRIMARY-REFERENCE.md PLUS** record-specific rules from this file.

### When to Read Dynamic Guidelines:
- ✅ Before using `a!forEach()`, `wherecontains()`, `index()`, or array operations
- ✅ Before filtering or searching arrays
- ✅ Before accessing properties on dynamic data
- ✅ Before concatenating variables (type safety)
- ✅ Before implementing conditional logic with data
- ✅ Before using `a!checkboxField()` - for proper variable initialization (null vs false)
- ✅ Before using variables in `required` parameter - for null-safe conditional logic
- ✅ **Remember:** SAIL doesn't support regex

**THIS IS NOT OPTIONAL for dynamic code. Static UIs may skip this.**
**THIS IS NOT OPTIONAL when using checkboxes or conditional `required` parameters.**

## INITIAL REQUEST CATEGORIZATION

Determine if the user wants a full page or just a component.

### Decision Criteria:

**Generate a SINGLE COMPONENT if the request:**
- Asks for "a grid", "a card", "a form", "a chart", etc. (note: "a" = one thing)
- Names a single component (grid, KPI, etc.) that's not a top-level layout
- Specifies columns, fields, or content WITHOUT mentioning "page" or "interface"
- Examples:
  - ✅ "Make a grid that shows..." → Generate ONLY a!gridLayout
  - ✅ "Create a card group with..." → Generate ONLY a!cardGroupLayout
  - ✅ "Build a form with these fields..." → Generate ONLY a!formLayout
  - ✅ "Show me a chart of..." → Generate ONLY a chart component

**Generate a FULL PAGE if the request:**
- Asks for "a page", "a dashboard", "an interface", "a screen"
- Mentions multiple distinct sections or areas (e.g., "header with KPIs and a grid below")
- Describes a complete user experience or workflow
- Names a top-level layout (header-content, form, wizard, panes)
- Examples:
  - ✅ "Create a dashboard that..." → Generate headerContentLayout with multiple sections
  - ✅ "Build a project management page..." → Generate full page structure
  - ✅ "Design an interface for..." → Generate full page structure

## CAPTURING USER REQUIREMENTS IN GENERATED CODE

When generating mockups, capture user-specified requirements as comments. **ONLY use requirements explicitly provided by the user - DO NOT invent or assume requirements.**

**File Header Comment Pattern:**
```sail
a!localVariables(
  /* REQUIREMENT: [Interface Purpose from user's screen definition]
   * Example: Case List View - Displays active cases assigned to current user with filtering */
```

**Query/Component-Level Comment Pattern:**
Before each data query or significant business logic component, ONLY if user specified the requirement:
```sail
  /* REQUIREMENT: [Specific data/logic requirement from user specification]
   * Example: Display cases where status is "Open" or "In Progress" and assignedTo equals current user */
  local!activeCasesQuery: a!queryRecordType(...)
```

**Grid Column Comment Pattern:**
For calculated/conditional columns, ONLY if user specified the business rule:
```sail
  a!gridColumn(
    label: "Priority",
    /* REQUIREMENT: [User-specified business rule]
     * Example: High priority cases (priority = 1) show in red, medium (priority = 2) in yellow, low (priority = 3) in gray */
    value: a!tagField(...)
  )
```

**Critical Rules:**
- ✅ ONLY capture requirements explicitly stated by the user
- ❌ DO NOT add requirement comments for standard UI patterns (sorting, formatting, basic display)
- ❌ DO NOT invent business rules or make assumptions about data logic
- ❌ DO NOT add comments for: standard formatting (dates, numbers, currency), basic sorting, default UI behaviors, standard SAIL patterns

**These comments serve as:**
- Documentation for developers
- Context for sail-dynamic-converter agent during conversion
- Traceability back to user requirements

## PAGE UI DESIGN PLANNING STEPS
When designing a full page, follow these planning steps (not necessary if user requests a single component):

1. Decide which top-level layout to use:
  - [ ] Pane layout - if the page features full-height (100vh) panes that might scroll independently, or,
  - [ ] Form layout - for single-step forms, or,
  - [ ] Wizard layout - for multi-step forms, or,
  - [ ] Header-content layout - for everything else
2. Read primary layout docs
  - [ ] If using FormLayout → Read `layouts/form-layout-instructions.md`
  - [ ] If using HeaderContentLayout → Read `layouts/header-content-layout-instructions.md`
  - [ ] If using PaneLayout → Read `layouts/pane-layout-instructions.md`
  - [ ] If using WizardLayout → Read `layouts/wizard-layout-instructions.md`
3. Plan the main page content layout using columnsLayout → Always read `layouts/columns-layout-instructions.md`
  - **For FormLayout/WizardLayout:** Use the `contentsWidth` parameter to control max content width (no columnsLayout needed unless splitting into multiple columns)
  - **For HeaderContentLayout:** Content fills full width by default. Use columnsLayout for either:
    - **Width constraint:** Limit all contents to a max width instead of spanning the full screen
      - Pattern: AUTO (gutter) + WIDE_PLUS (content) + AUTO (gutter)
      - The AUTO columns create responsive margins on both sides
    - **Multi-column layout:** Split contents into 2-3 columns for better space utilization
      - Equal widths: Use all AUTO columns
      - Mixed widths: Use AUTO for main content + fixed widths (e.g., MEDIUM_PLUS) for sidebars
  - **Decision checklist:**
    - [ ] Does content need a max width constraint? → Use gutter + WIDE_PLUS + gutter pattern
    - [ ] Should content be split into multiple columns? → Use 2-3 columns with appropriate widths
    - [ ] If NO to both → Skip columnsLayout
4. Use sideBySideLayout as needed to arrange groupings of content items, e.g. a stamp next to a rich text title next to a button → Always read `layouts/sidebyside-layout-instructions.md`
  - sideBysideItems CANNOT contain other sideBySideLayouts/items, cardLayouts, or columnLayouts
  - A sideBysideItem can only contain one component, not an array of components
  - If your plan requires an invalid sideBySideLayout, RECONSIDER THE DESIGN:
     - Break components up into separate sideBySideItems, OR,
     - Use a columnsLayout instead
5. Avoid redundant card nesting (too much boxiness) for sections containing card collections
  - ❌ DON'T wrap cardGroupLayout or lists of cards in a parent cardLayout
  - ✅ DO place section titles and card collections directly on page background
  - Example: Section heading → cardGroupLayout (NOT: cardLayout → Section heading + cardGroupLayout)

## LAYOUT SELECTION GUIDE

### Layout Hierarchy (Top to Bottom):
1. **Page Structure**: HeaderContentLayout/FormLayout/PaneLayout
2. **Content Sections**: ColumnsLayout → CardLayout/SectionLayout
3. **Component Arrangement**: SideBySideLayout (components only!)

### When to Use Each Layout:
#### ColumnsLayout vs SideBySideLayout
- **ColumnsLayout**: Page structure, fixed pixel widths
- **SideBySideLayout**: Icon + text, label + value, minimized (flex 0) layouts

## COMPONENT SELECTION GUIDE

### Form Inputs
- Use `radioButtonField` or `checkboxField` for short lists of options
- Alternatively, use `cardChoiceField` to show short lists of options in a more visually interesting way
- Use `dropdownField` for longer lists of options
- Use `styledTextEditorField` to allow user to enter formatted text

### List Display
- `gridField` is the simplest way to show tabular data, especially from records
- A custom tabular display pattern (`components/tabular-data-display-pattern.md`) can be used if the capabilities of `gridField` are too limiting (such as when each cell needs to show multiple components)
- Use `cardGroupLayout` to show a responsive grid of cards with each card representing a list item. This creates a more visually interesting list than a basic `gridField`.

### Decorative Data Display
- `stampField` is a colored circle or square that shows an icon or initials. Use to represent user initials, anchor list items, etc. Read `components/stamp-field-instructions.md`if using.
- Use `tagField` to show UI elements styled like tags or chips. Find `a!tagField` in `reference/sail-api-schema.json` if using.
- Use `richTextDisplayField` to show styled text and icons. Read `components/rich-text-instructions.md` if using.

### Common Patterns
Browse the `/ui-guidelines/patterns` folder for examples of how to compose common UI elements.

*ALWAYS* study the relevant patterns if the UI requires any of these elements:
- `card_lists.md` for list items (users, tasks, products, messages, etc.) shown as cards
- `kpis.md` for key performance indicator cards
- `messages.md` for message banners (info, warning, etc.)
- `tabs.md` for tab bars

### Special Rules
- When using sectionLayout, set labelColor: "STANDARD" (unless a specific color is required in the instructions)
- When not setting a label on a component, explicitly set labelPosition to "COLLAPSED" so that space is not reserved for the label (for more reliable alignment)

### Button Quick Rules
- [ ] Style is ONLY: `"OUTLINE"` | `"GHOST"` | `"LINK"` | `"SOLID"` (no "PRIMARY" or "ACCENT"!)
- [ ] Colors: `"ACCENT"` | `"SECONDARY"` | `"NEGATIVE"` | hex codes
- [ ] Primary action = `style: "SOLID"` + `color: "ACCENT"` (both required)
- [ ] Always wrapped in `a!buttonArrayLayout`

## STYLING
### Use this color scheme for generated SAIL UIs
- #F5F6F8: page background color
- #1C2C44: (optional) page header bar background color
- #FFFFFF: content card background color
- `ACCENT`: themed accent color (primary buttons, etc.)
- `STANDARD`: text and heading color

## ⚠️ NULL SAFETY RULES (CRITICAL)

SAIL cannot handle null values in most operations. **Check before using.**

### The Core Problem
- Comparing null values crashes: `local!id = fv!item.id` fails if `local!id` is null
- Accessing properties on null crashes: `local!data.type` fails if `local!data` is null
- Most functions reject null parameters: `text(null, "format")` fails

### Universal Pattern: Use if() for Short-Circuit Evaluation

✅ **RIGHT - if() short-circuits (safe):**
```sail
/* Pattern 1: Null-safe comparison */
showWhen: if(a!isNotNullOrEmpty(local!selectedId),
              local!selectedId = fv!item.id,
              false())

/* Pattern 2: Null-safe property access */
if(a!isNotNullOrEmpty(local!data),
   local!data.type = "Contract",
   false())
```

❌ **WRONG - and() does NOT short-circuit (crashes):**
```sail
/* and() evaluates ALL parameters even if first is false */
showWhen: and(a!isNotNullOrEmpty(local!data),
              local!data.type = "Contract")  /* CRASHES if null! */
```

### Common Null Safety Patterns

**1. Choice Field Initialization**
```sail
/* ✅ Uninitialized = unchecked/unselected (null state) */
local!agreeToTerms,  /* NOT false() */

/* ✅ Only initialize if pre-selected AND value exists in choiceValues */
local!agreeToTerms: true(),  /* Only if true() is in choiceValues */

/* ❌ NEVER use null/empty in choiceValues */
choiceValues: {true()}  /* NOT: {true(), null} or {true(), ""} */
```

**2. Input Field Data Storage**
```sail
/* ❌ NEVER leave inputs orphaned */
a!textField(value: null, saveInto: null)  /* User input goes nowhere! */

/* ✅ Always store to variables */
a!textField(value: local!name, saveInto: local!name)
```

**3. Functions That Reject Null**
```sail
/* Common functions that crash on null: text(), concat(), user(), not(), etc. */

/* ✅ Use a!defaultValue() wrapper */
text(a!defaultValue(fv!row.amount, 0), "$#,##0.00")
concat(a!defaultValue(fv!row.firstName, ""), " ", a!defaultValue(fv!row.lastName, ""))
not(a!defaultValue(ri!isActive, false()))

/* ✅ OR use if() to provide fallback */
if(a!isNullOrEmpty(fv!row.status), "N/A", text(fv!row.status, "format"))
```

**4. Grid Selection (Always Returns List)**
```sail
/* Grid selectionValue is ALWAYS a list, even for single-select */

/* ✅ Use index() to access first item safely */
local!selectedRow: index(local!selection, 1, null)  /* null if empty */

/* ✅ Check before using */
showWhen: if(a!isNotNullOrEmpty(local!selectedRow),
             local!selectedRow.id > 0,
             false())
```

**5. Relationship Field Access**
```sail
/* Relationships can be null or empty arrays */

/* ✅ Check before accessing fields */
if(a!isNotNullOrEmpty(fv!row['recordType!Case.relationships.assignedUser']),
   fv!row['recordType!Case.relationships.assignedUser'].firstName,
   "Unassigned")

/* ✅ Use a!defaultValue() for direct field access */
a!defaultValue(fv!row['recordType!Case.fields.priority'], "Medium")
```

### Quick Reference Table

| Scenario | Pattern | Example |
|----------|---------|---------|
| Comparison with nullable | `if(isNotNull(var), comparison, false)` | `if(a!isNotNullOrEmpty(local!id), local!id = 5, false())` |
| Property access | `if(isNotNull(obj), obj.prop, default)` | `if(a!isNotNullOrEmpty(data), data.type, "")` |
| Function parameter | `function(a!defaultValue(var, default))` | `text(a!defaultValue(amount, 0), "$#,##0")` |
| String concatenation | `a!defaultValue(field, "")` | `concat(a!defaultValue(first, ""), " ", a!defaultValue(last, ""))` |
| Boolean operations | `not(a!defaultValue(var, false()))` | `not(a!defaultValue(ri!isActive, false()))` |
| Grid selection | `index(selection, 1, null)` then check | `if(a!isNotNullOrEmpty(index(sel, 1, null)), ...)` |
| Date field display | `if(isNotNull(field), text(todate(field), "MMM d, yyyy"), "N/A")` | Use `todate()` wrapper |
| DateTime field display | `if(isNotNull(field), text(field, "MMM d, yyyy h:mm a"), "N/A")` | NO `todate()` wrapper |
| Time field display | `if(isNotNull(field), text(field, "h:mm a"), "N/A")` | Use `text()` directly |

### Where to Learn More
**Null Safety Topic Files (for detailed patterns):**
- `/logic-guidelines/short-circuit-evaluation.md` - Why if() vs and()/or()
- `/logic-guidelines/null-safety-quick-ref.md` - Complete quick reference table
- `/logic-guidelines/functions-reference.md` - Functions by category including null-rejecting functions

**Master guidelines (for comprehensive rules):**
- `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` #null-safety-implementation

## SYNTAX REQUIREMENTS
- Never use JavaScript syntax, operators (if, or, and), or keywords
     - **WRONG:** `if(a and b, ...)`
     - **RIGHT:** `if(and(a, b), ...)`
     - **WRONG:** `if(a or b, ...)`
     - **RIGHT:** `if(or(a, b), ...)`
- Use a!forEach() instead of apply() when iterating
- Double check that braces, parentheses, and quotes are matched
- Use /* */ for comments, not //
- Use "" to escape a double quote, not \"
- Choice values cannot be null or empty strings (use " " if necessary)
- Choice field value initialization:
  - Checkbox, radio, and dropdown field `value` parameters must contain ONLY values present in `choiceValues`
  - For unchecked/unselected state, leave the local variable uninitialized (null), do NOT set to false()
  - **WRONG:** `local!agreeToTerms: false()` with `choiceValues: {true()}`
  - **RIGHT:** `local!agreeToTerms,` (uninitialized = unchecked)
  - **RIGHT:** `local!agreeToTerms: true()` (pre-checked, if true() is in choiceValues)
- **Always check for null/empty before comparing values or accessing properties** - See "NULL SAFETY RULES" section above for complete patterns

### Dynamic Form Generation
- **Choose the right pattern** - See "Dynamic Form Field Validation" checklist above:
  - **Array of Maps** (PREFERRED): For multi-instance data entry (work experiences, addresses, line items) → `saveInto: fv!item.propertyName`
  - **Parallel Arrays**: Only when iterating a fixed source list to collect separate data → `index()` + `a!update()` pattern
- Read `/logic-guidelines/foreach-patterns.md` for complete pattern guidance before implementing
- NEVER use `value: null, saveInto: null` in input fields - See "NULL SAFETY RULES" section for details

## ⚠️ FUNCTION VARIABLES (fv!) - CRITICAL RULES

Function variables (fv!) are context-specific and ONLY available in certain SAIL functions.

**Most common mistake**: Using `fv!index` in grid columns (it doesn't exist - only `fv!row` is available)

**Detailed Topic Files:**
- `/logic-guidelines/foreach-patterns.md` - Complete a!forEach() function variables (fv!item, fv!index, etc.)
- `/logic-guidelines/grid-selection-patterns.md` - Two-variable approach and selection behavior

**Master guidelines:**
- `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` for comprehensive patterns

## TYPE HANDLING FOR DATE/TIME CALCULATIONS

### Always Cast Date Arithmetic with todate()
When using date arithmetic in sample data, cast results to ensure consistent types:

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
  a!map(dueDate: todate(today() + 7)),  /* Type: Date */
  a!map(dueDate: todate("03/14/2023"))   /* Type: Date, use MM/DD/YYYY */
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

### Key Functions
- `todate()` - Cast to Date type (use for all date arithmetic in sample data)
- `tointeger()` - Convert interval to whole days as integer
- `text(value, format)` - Format numbers/dates/intervals as text

## EXPRESSION STRUCTURE RULES
- All expressions must begin with a!localVariables() as the parent element
- Place the main interface as the last argument of a!localVariables()
   - When the top-level layout is `a!paneLayout`, `a!formLayout`, `a!wizardLayout`, or `a!headerContentLayout`, DON'T put it in an array ({})
- Define any local variables within the a!localVariables() function
- All form inputs should save into a corresponding local variable
- ButtonWidgets can't be on their own, they must be inside a ButtonArrayLayout
- Use cardLayout for content blocks, EXCEPT when the content is already a collection of cards (cardGroupLayout, multiple cardLayouts arranged in a list) - in those cases, place the cards directly on the page background without an outer wrapper card

## PARAMETER RESTRICTIONS
- Only use parameters explicitly defined in the documentation
- For parameters with listed valid values, only use those specific values
- Color values must use 6-character hex codes (#RRGGBB) or documented enumeration values (like "ACCENT").
  - Allowed color enumeration values vary across components. Only use values specified in the documentation for that component.
  - HTML color names like "RED" are invalid
- Icons must reference valid aliases (see `/ui-guidelines/reference/rich-text-icon-aliases.md`)
- RichTextItem align parameter allowed values are "LEFT", "CENTER", or "RIGHT", do not use "START" or "END"!
- Checkbox and radio button labels can only accept plain text, not rich text
- choiceValues CANNOT be null or empty strings ("")

## 🛑 MANDATORY DELEGATION CHECKLIST

### 🔄 Converting Mock to Functional Interface:

**REQUIRED ACTION:**
- [ ] **ALWAYS invoke sail-dynamic-converter agent** when user requests:
  - Converting static/mock interfaces to use live record data
  - Making mockups dynamic or connecting to real data
  - Using actual data from record types
- [ ] Use Task tool: `subagent_type: "sail-dynamic-converter"`

**❌ NEVER:**
- Attempt conversion yourself without invoking the agent
- Make up UUIDs or field references

### ✅ Validating SAIL Expressions:
👉 Always use tools to validate new expressions:
- [ ] *IF* mcp__appian-mcp-server__validate_sail is available, always call it for efficient syntax validation
- [ ] *OTHERWISE*, call these sub-agents (!!!ONLY!!! if mcp__appian-mcp-server__validate_sail is NOT available):
    - [ ] 1. **sail-schema-validator** - Validates function syntax
    - [ ] 2. **sail-icon-validator** - Checks for valid icon names
    - [ ] 3. **sail-code-reviewer** - Validates structure, syntax, and best practices