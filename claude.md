# PROJECT INSTRUCTIONS - SAIL UI GENERATION

## PURPOSE AND GOALS
- Given a request, generate an Appian SAIL UI
- Write generated output to a .sail file in the /output folder
- Use only valid SAIL components and the allowed parameter values for each
- Use modern, but business-appropriate styling
- Don't worry about querying live data, just hard-code sample content using local variables and a!map
- Inline ALL logic - no `rule!` or `cons!` references unless explicitly specified!
- ‼️Syntax errors are DISASTROUS and MUST BE AVOIDED at any cost! Be METICULOUS about following instructions to avoid making mistakes!
- ❌Don't assume that a parameter or parameter value exists - ✅ONLY use values specifically described in `/ui-guidelines/0-sail-api-schema.json`
- When converting mock to functional, refactor code structure as needed to accommodate record queries (e.g., chart patterns) and changes to logic, but preserve visual design

## ⚠️ BEFORE YOU BEGIN - MANDATORY RULES
1. ❌ NEVER nest sideBySideLayouts inside sideBySideLayouts
2. ❌ NEVER put arrays of components inside sideBySideLayouts
3. ❌ NEVER put columnsLayouts or cardLayouts inside sideBySideLayouts
4. ✅ ONLY richTextItems or richTextIcons are allowed inside richTextDisplayField
5. ✅ Each columnsLayout must have at least one AUTO-width columnLayout
6. ❌ choiceValues CANNOT be null or empty strings

If you violate any of these rules, STOP and reconsider your approach.

## 📚 DOCUMENTATION REQUIREMENT

**ALWAYS read component docs from `/ui-guidelines/` BEFORE writing code.** Never assume you know how a component works—read the documentation first, code second.

**Two-tier documentation structure:**
1. **Schema Reference** - `/ui-guidelines/0-sail-api-schema.json` summarizes ALL SAIL components and functions with their parameters and valid values

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
- `0-sail-api-schema.json` - Complete parameter reference for all SAIL components (JSON schema)

**Expression Grammar & Variables:**
- `1-expression-grammar-instructions.md` - Expression grammar for calculation, logic, conversion functions (✅ ALWAYS check for function signatures)
- `2-local-variables-instructions.md` - Local variable usage and patterns

**Layout Components (3-*):**
- `3-header-content-layout-instructions.md` - HeaderContentLayout guidelines
- `3-columns-layout-instructions.md` - ColumnsLayout guidelines
- `3-sidebyside-layout-instructions.md` - SideBySideLayout guidelines
- `3-form-layout-instructions.md` - FormLayout guidelines
- `3-pane-layout-instructions.md` - PaneLayout guidelines
- `3-wizard-layout-instructions.md` - WizardLayout guidelines

**Display Components (4-*):**
- `4-button-instructions.md` - Button and ButtonArrayLayout guidelines
- `4-card-layout-instructions.md` - CardLayout guidelines
- `4-grid-field-instructions.md` - GridField (read-only grid) guidelines
- `4-grid-layout-instructions.md` - GridLayout (editable grid) guidelines
- `4-rich-text-instructions.md` - Rich Text component guidelines
- `4-stamp-field-instructions.md` - Stamp Field guidelines
- `4-card-choice-field-instructions.md` - Card Choice Field guidelines
- `4-chart-instructions.md` - Chart component guidelines
- `4-image-field-instructions.md` - Image Field guidelines
- `4-tabular-data-display-pattern.md` - Custom tabular display pattern

**Icons:**
- `5-rich-text-icon-aliases.md` - Valid icon aliases for richTextIcon (**MUST READ before using any icons**)

**All other components** (textField, dropdownField, etc.) are documented in `/ui-guidelines/0-sail-api-schema.json` only.

### Documentation Lookup Process:

1. **Check if a dedicated instruction file exists** for the component (see list above)
   - If YES → Read the dedicated file for templates, patterns, and detailed rules
   - If NO → Use `/ui-guidelines/0-sail-api-schema.json` for parameters and values

2. **For unfamiliar components** - Read the component entry in `/ui-guidelines/0-sail-api-schema.json` first to understand basic parameters

### ❌ NEVER:
- Use parameters that aren't explicitly documented in either the reference or instruction files
- Put components in layouts that don't accept them
- Skip reading documentation because "it seems straightforward"

### ✅ ALWAYS:
- Start with `/ui-guidelines/0-sail-api-schema.json` for parameter validation
- Read dedicated instruction files when available for templates and patterns
- Follow templates exactly from instruction files
- Verify against validation checklists
- **Read `/ui-guidelines/5-rich-text-icon-aliases.md` in full before using ANY icons**

**THIS IS NOT OPTIONAL. Skipping documentation causes critical errors.**

## 🔄 DYNAMIC SAIL EXPRESSIONS

**When working with dynamic data (arrays, loops, conditionals), ALWAYS read the appropriate guidelines FIRST:**

### **FOUNDATIONAL SAIL SYNTAX (Required for ALL Interfaces)**
**Read:** `/dynamic-behavior-guidelines/mock-interface.md`

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

**⚠️ Important:** Despite the "mock" in the filename, this file contains **FOUNDATIONAL rules for ALL SAIL code** (not just mockups).

### **RECORD TYPE INTEGRATION (When Using Record Data)**
**Read:** `/dynamic-behavior-guidelines/functional-interface.md`

**Contains:** Record-specific patterns built **ON TOP of mock-interface.md:**
- ✅ **Record type reference syntax** (UUID usage)
- ✅ **Form interface data patterns** (ri! vs queries decision tree)
- ✅ **Query construction** (a!queryRecordType, a!recordData)
- ✅ **Relationship navigation** (one-to-many, many-to-one)
- ✅ **Record type constructors** vs a!map()
- ✅ **Testing simulation variables**

**⚠️ Critical:** Functional interfaces use **ALL rules from mock-interface.md PLUS** record-specific rules from this file.

### When to Read Dynamic Guidelines:
- ✅ Before using `a!forEach()`, `wherecontains()`, `index()`, or array operations
- ✅ Before filtering or searching arrays
- ✅ Before accessing properties on dynamic data
- ✅ Before concatenating variables (type safety)
- ✅ Before implementing conditional logic with data
- ✅ Before using `a!checkboxField()` - for proper variable initialization (null vs false)
- ✅ Before using variables in `required` parameter - for null-safe conditional logic
- ✅ **Remember:** SAIL doesn't support regex

**THIS IS NOT OPTIONAL for dynamic code. Static forms may skip this.**
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

## PAGE UI DESIGN PLANNING STEPS
When designing a full page, follow these planning steps (not necessary if user requests a single component):

1. Decide which top-level layout to use:
  - [ ] Pane layout - if the page features full-height (100vh) panes that might scroll independently, or,
  - [ ] Form layout - for single-step forms, or,
  - [ ] Wizard layout - for multi-step forms, or,
  - [ ] Header-content layout - for everything else
2. Read primary layout docs
  - [ ] If using FormLayout → Read `3-form-layout-instructions.md`
  - [ ] If using HeaderContentLayout → Read `3-header-content-layout-instructions.md`
  - [ ] If using PaneLayout → Read `3-pane-layout-instructions.md`
  - [ ] If using WizardLayout → Read `3-wizard-layout-instructions.md`
3. Plan the main page content layout using columnsLayout → Always read `3-columns-layout-instructions.md`
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
4. Use sideBySideLayout as needed to arrange groupings of content items, e.g. a stamp next to a rich text title next to a button → Always read `3-sidebyside-layout-instructions.md`
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

### List Display
- `gridField` is the simplest way to show tabular data, especially from records
- A custom tabular display pattern (`4-tabular-data-display-pattern.md`) can be used if the capabilities of `gridField` are too limiting (such as when each cell needs to show multiple components)
- Use `cardGroupLayout` to show a responsive grid of cards with each card representing a list item. This creates a more visually interesting list than a basic `gridField`.

### Decorative Data Display
- `stampField` is a colored circle or square that shows an icon or initials. Use to represent user initials, anchor list items, etc. Read `4-stamp-field-instructions.md`if using.
- Use `tagField` to show UI elements styled like tags or chips. Find `a!tagField` in `0-sail-api-schema.json` if using.
- Use `richTextDisplayField` to show styled text and icons. Read `4-rich-text-instructions.md` if using.

### Common Patterns
Browse the `/ui-guidelines/patterns` folder for examples of how to compose common UI elements.

*ALWAYS* study the relevant patterns if the UI requires any of these elements:
- `card_lists.md` for list items (users, tasks, products, messages, etc.) shown as cards
- `kpis.md` for key performance indicator cards
- `messages.md` for message banners (info, warning, etc.)
- `tabs.md` for tab bars

### Dynamic Form Generation
- When using `forEach` to generate multiple input fields, each field MUST store data using the parallel array pattern with `fv!index`
- Read `/dynamic-behavior-guidelines/mock-interface.md` section on "Dynamic Form Fields with forEach" before implementing
- NEVER use `value: null, saveInto: null` in input fields - user input must be stored somewhere

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
- **Always check for null/empty before comparing values or accessing properties** - SAIL cannot handle null in comparisons or property access
     - **WRONG:** `showWhen: local!selectedId = fv!item.id` (fails if selectedId is null)
     - **WRONG:** `showWhen: and(a!isNotNullOrEmpty(local!data), local!data.type = "Contract")` (and() doesn't short-circuit!)
     - See `/dynamic-behavior-guidelines/mock-interface.md` - section "🚨 CRITICAL: Short-Circuit Evaluation Rules" for complete null safety patterns

### Pattern Matching with a!match()

For cleaner pattern matching (status codes, priority levels, categories), use `a!match()` instead of nested `if()` statements.

See `/dynamic-behavior-guidelines/mock-interface.md` - section "Using a!match() for Status-Based Lookups" for:
- Pattern: Status to Icon/Color mapping (a!match() vs parallel arrays)
- Pattern: Dynamic styling with stampField
- Pattern: Grid column conditional background colors
- Decision criteria: when to use a!match() vs when to use parallel arrays

### ⚠️ NULL SAFETY FOR COMMON FUNCTIONS

Many SAIL functions cannot accept null parameters and will cause runtime errors.

See `/dynamic-behavior-guidelines/mock-interface.md`:
- Section "🚨 CRITICAL: Short-Circuit Evaluation Rules" for if() vs and()/or() usage
- Section "Advanced: Functions That Reject Null" for a!defaultValue() patterns
- Section "🚨 MANDATORY: Null Safety Implementation" for complete implementation patterns

## ⚠️ FUNCTION VARIABLES (fv!) - CRITICAL RULES

Function variables (fv!) are context-specific and ONLY available in certain SAIL functions.

**Most common mistake**: Using `fv!index` in grid columns (it doesn't exist - only `fv!row` is available)

See `/dynamic-behavior-guidelines/mock-interface.md`:
- Section "⚠️ Function Variables (fv!) Reference" for complete a!forEach() function variables
- Section "Grid Selection Pattern: Two-Variable Approach" for complete grid selection patterns
- Section "⚠️ CRITICAL: Grid Selection Behavior" for selection behavior and common mistakes

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
- Icons must reference valid aliases (see `/ui-guidelines/5-rich-text-icon-aliases.md`)
- RichTextItem align parameter allowed values are "LEFT", "CENTER", or "RIGHT", do not use "START" or "END"!
- Checkbox and radio button labels can only accept plain text, not rich text
- choiceValues CANNOT be null or empty strings (“”)

## 🛑 MANDATORY DELEGATION CHECKLIST

### 🔄 Converting Mock to Functional Interface:
**WHEN user requests converting a static/mock interface to use real record data:**

**Trigger keywords:**
- "convert to functional interface"
- "make this dynamic" / "connect to real data" / "connect to records"
- "use actual data from [record type]"
- "transform [mockup] into functional interface"

**REQUIRED ACTION:**
- [ ] **ALWAYS invoke sail-dynamic-converter agent** - DO NOT attempt conversion manually
  - Agent reads `/context/data-model-context.md` for correct UUIDs and field references
  - Agent performs complete conversion with mandatory validation steps
  - Agent ensures 100% complete conversion (ALL steps, sections, fields)
  - Use Task tool: `subagent_type: "sail-dynamic-converter"`

**❌ NEVER:**
- Attempt conversion yourself without invoking the agent
- Make up UUIDs or field references
- Read functional-interface.md and convert manually

**✅ AGENT MUST:**
- Refactor code structure when required for record data (chart patterns, field references) and logic
- Preserve visual design and layout (colors, spacing, styling)

---

### ✅ Validating SAIL Expressions:
👉 Always use tools to validate new expressions:
- [ ] *IF* mcp__appian-mcp-server__validate_sail is available, always call it for efficient syntax validation
- [ ] *OTHERWISE*, call these sub-agents (!!!ONLY!!! if mcp__appian-mcp-server__validate_sail is NOT available):
    - [ ] 1. **sail-schema-validator** - Validates function syntax
    - [ ] 2. **sail-icon-validator** - Checks for valid icon names
    - [ ] 3. **sail-code-reviewer** - Validates structure, syntax, and best practices

**Expected Validation Errors (Safe to Ignore):**

When validating interfaces with rule inputs or environment-specific references, these errors are expected and can be safely ignored:

1. **Rule Input Errors**: `"Could not find variable 'ri!...'"`
   - Rule inputs (ri!) are defined at the interface/process level, not in the code itself
   - ✅ Safe to ignore IF the rule input is properly documented in interface comments
   - ✅ Safe to ignore IF the code follows the ri! pattern correctly (functional interface)

2. **Record Type UUID Errors**: `"Could not find recordType '...'"`
   - Record type UUIDs are environment-specific
   - ✅ Safe to ignore IF UUIDs are sourced from data-model-context.md
   - ✅ Safe to ignore IF code is intended for a specific Appian environment

3. **Constant/Expression Rule Errors**: `"Could not find constant/rule 'cons!/rule!'"`
   - Constants and expression rules exist in the target environment only
   - ✅ Safe to ignore IF properly documented

**Critical Errors (MUST Fix):**
- ❌ Invalid function names or parameters
- ❌ Syntax errors (mismatched braces, quotes)
- ❌ Undefined local variables (local! not declared in a!localVariables)

### Before Writing Dynamic Code:
- [ ] Read `/dynamic-behavior-guidelines/mock-interface.md` if using arrays, loops, null checking in mock data interfaces
- [ ] Read `/dynamic-behavior-guidelines/functional-interface.md` if working with record types, queries, or relationships
- [ ] Remember that SAIL doesn't support regex

### Dynamic Form Field Validation:
- [ ] forEach generating input fields stores to arrays - use `index()` + `a!update()` pattern ‼️
- [ ] Parallel arrays initialized as {} for multiple fields per forEach item ‼️
- [ ] NO `value: null, saveInto: null` in input fields (textField, dateField, fileUploadField, etc.) ‼️
- [ ] Multi-select checkbox fields use single array variable, NOT separate boolean variables ‼️ (see Multi-Checkbox Pattern in mock-interface.md)

### Syntax Validation:
- [ ] Starts with a!localVariables()
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes
- [ ] Escape double quotes like "", not like \" ✅ CHECK EVERY STRING VALUE
- [ ] Comments use /* */ not //
- [ ] `or(a,b)` NOT `a or b` ‼️
- [ ] Null checks before comparisons/property access - use `if()` NOT `and()` (see mock-interface.md section "🚨 CRITICAL: Short-Circuit Evaluation Rules") ‼️
- [ ] Null checks before text() formatting - use `if(isNullOrEmpty(value), "N/A", text(value, format))` ‼️
- [ ] Null checks for record field access - wrap in `a!defaultValue()` or check with `a!isNullOrEmpty()` ‼️
- [ ] Null checks before string concatenation - use `a!defaultValue(field, "")` ‼️
- [ ] Null checks before not() - use `not(a!defaultValue(ri!var, false()))` ‼️
- [ ] Date arithmetic wrapped in todate() in sample data - use `todate(today() + 1)` ‼️
- [ ] No Interval-to-Number comparisons - use `tointeger()` to convert first ‼️
- [ ] index() wrapped in type converters for arithmetic - use `todate(index(...))`, `tointeger(index(...))`, etc. ‼️

### Function Variable Validation:
- [ ] ✅ In grid columns: ONLY use `fv!row` (NOT fv!index, NOT fv!item) ‼️
- [ ] ❌ NEVER use `fv!index` in grid columns - use grid's selectionValue instead ‼️
- [ ] ✅ Grid selectionValue is always a LIST - use `index(local!selected, 1, null)` to access
- [ ] ✅ In a!forEach(): Use `fv!index`, `fv!item`, `fv!isFirst`, `fv!isLast`
- [ ] ❌ NEVER use `fv!item` outside of a!forEach() ‼️

### Parameter Validation:
- [ ] Check to see that every parameter and value is listed in documentation before using!

### Layout Validation:
- [ ] One top-level layout (HeaderContent/FormLayout/PaneLayout)
- [ ] No nested sideBySideLayouts
- [ ] No columns or card layouts inside sideBySideItems
- [ ] Only richTextItems or richTextIcons in richTextDisplayField
- [ ] At least one AUTO width column in each columnsLayout
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!