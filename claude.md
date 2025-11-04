# PROJECT INSTRUCTIONS - SAIL UI GENERATION

## PURPOSE AND GOALS
- Given a request, generate an Appian SAIL UI
- Write generated output to a .sail file in the /output folder
- Use only valid SAIL components and the allowed parameter values for each
- Use modern, but business-appropriate styling
- Don't worry about making it functional, just hard-code sample content
- ‼️Syntax errors are DISASTROUS and MUST BE AVOIDED at any cost! Be METICULOUS about following instructions to avoid making mistakes!
- ❌Don’t assume that a parameter or parameter value exists - ✅ONLY use values specifically described in documentation (in the /ui-guidelines folder)!

## ⚠️ BEFORE YOU BEGIN - MANDATORY RULES
1. ❌ NEVER nest sideBySideLayouts inside sideBySideLayouts
2. ❌ NEVER put arrays of components inside sideBySideLayouts
3. ❌ NEVER put columnsLayouts or cardLayouts inside sideBySideLayouts
4. ✅ ONLY richTextItems or richTextIcons are allowed inside richTextDisplayField
5. ❌ choiceValues CANNOT be null or empty strings

If you violate any of these rules, STOP and reconsider your approach.

## 📚 DOCUMENTATION REQUIREMENT

**ALWAYS read component docs from `/ui-guidelines/` BEFORE writing code.** Never assume you know how a component works—read the documentation first, code second.

**Two-tier documentation structure:**
1. **Component Reference** - `0-sail-component-reference.md` contains ALL SAIL components with their parameters and valid values
2. **Detailed Instructions** - Select components have dedicated instruction files (listed below)

### Available Documentation Files:

**Core Reference (use for ALL components):**
- `0-sail-component-reference.md` - Complete parameter reference for all SAIL components

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
- `5-rich-text-icon-aliases.md` - Valid icon aliases for richTextIcon

**All other components** (textField, dropdownField, buttonWidget, etc.) are documented in `0-sail-component-reference.md` only.

### Documentation Lookup Process:

1. **Check if a dedicated instruction file exists** for the component (see list above)
   - If YES → Read the dedicated file for templates, patterns, and detailed rules
   - If NO → Use `0-sail-component-reference.md` for parameters and values

2. **For unfamiliar components** - Read the component entry in `0-sail-component-reference.md` first to understand basic parameters

### ❌ NEVER:
- Use parameters that aren't explicitly documented in either the reference or instruction files
- Put components in layouts that don't accept them
- Skip reading documentation because "it seems straightforward"

### ✅ ALWAYS:
- Start with `0-sail-component-reference.md` for parameter validation
- Read dedicated instruction files when available for templates and patterns
- Follow templates exactly from instruction files
- Verify against validation checklists

**THIS IS NOT OPTIONAL. Skipping documentation causes critical errors.**

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
3. Plan the main page content layout using columnsLayout
4. Use sideBySideLayout as needed to arrange groupings of content items, e.g. a stamp next to a rich text title next to a button
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
- `stampField` is a colored circle or square that shows an icon or initials. Use to represent user initials, anchor list items, etc.
- Use `tagField` to show UI elements styled like tags or chips

### Common Patterns
Browse the `/ui-guidelines/patterns` folder for examples of how to compose common UI elements.

*ALWAYS* study the relevant patterns if the UI requires any of these elements:
- `card_lists.md` for list items (users, tasks, products, messages, etc.) shown as cards
- `kpis.md` for key performance indicator cards
- `messages.md` for message banners (info, warning, etc.)
- `tabs.md` for tab bars

### Special Rules
- Avoid using the KPIField unless data can be sourced dynamically from a record. The KPIField doesn't work well for static mockup KPI values.
- When using sectionLayout, set labelColor: "STANDARD" (unless a specific color is required in the instructions)
- When not setting a label on a component, explicitly set labelPosition to “COLLAPSED” so that space is not reserved for the label (for more reliable alignment)

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
- **Always check for null before comparing values** - SAIL cannot compare null to numbers/text
     - **WRONG:** `showWhen: local!selectedId = fv!item.id` (fails if selectedId is null)
     - **RIGHT:** `showWhen: and(not(isnull(local!selectedId)), local!selectedId = fv!item.id)`
     - Common scenarios: selection states, conditional visibility, dynamic styling
     - Any local variable that starts as null and gets populated later needs null checking

### ⚠️ NULL SAFETY FOR COMMON FUNCTIONS

Many SAIL functions cannot accept null parameters and will cause runtime errors. Always check for null before passing values to these functions:

#### Functions That Cannot Accept Null:

**text() function:**
```sail
❌ WRONG:
text(fv!row.createdDate, "MMM d, yyyy")  /* Fails if createdDate is null */

✅ RIGHT - Option 1 (if statement):
if(
  isnull(fv!row.createdDate),
  "N/A",
  text(fv!row.createdDate, "MMM d, yyyy")
)

✅ RIGHT - Option 2 (a!defaultValue):
text(
  a!defaultValue(fv!row.createdDate, today()),
  "MMM d, yyyy"
)
```

**Concatenation with null:**
```sail
❌ WRONG:
text: "CASE-" & fv!row.caseId  /* Fails if caseId is null */

✅ RIGHT:
text: "CASE-" & a!defaultValue(fv!row.caseId, "")
```

**Common scenarios requiring null checks:**
- ✅ **Record fields from database** - Can be null if not required or not populated
- ✅ **Related record fields** - Can be null if relationship is not populated
- ✅ **User-typed fields** - Text/Number/Date inputs can be null initially
- ✅ **Calculated fields** - Results of operations can be null
- ✅ **Date/Time formatting** - Always check before text(), datetext(), datetimetext()
- ✅ **Mathematical operations** - Division, multiplication with null values

## ⚠️ FUNCTION VARIABLES (fv!) - CRITICAL RULES

Function variables (fv!) are context-specific and ONLY available in certain SAIL functions.

### Available Function Variables by Context

**In a!forEach():**
- ✅ `fv!index` - Current iteration index (1-based)
- ✅ `fv!item` - Current item value
- ✅ `fv!isFirst` - Boolean, true on first iteration
- ✅ `fv!isLast` - Boolean, true on last iteration

**In a!gridField() columns:**
- ✅ `fv!row` - Current row data (ONLY variable available!)
- ❌ `fv!index` - NOT AVAILABLE in grid columns
- ❌ `fv!item` - NOT AVAILABLE in grid columns

**In a!wizardLayout():**
- ✅ `fv!activeStepIndex` - Current step number
- ✅ `fv!isFirstStep` - Boolean for first step
- ✅ `fv!isLastStep` - Boolean for last step

### ⚠️ MOST COMMON MISTAKE: Using fv!index in Grid Columns

**❌ WRONG - This will cause an error:**
```sail
a!gridColumn(
  label: "Name",
  value: a!richTextItem(
    text: fv!row.name,
    link: a!dynamicLink(
      value: fv!index,  /* ERROR: fv!index doesn't exist in grid columns! */
      saveInto: local!selectedIndex
    )
  )
)
```

**✅ RIGHT - Use grid's built-in selection:**
```sail
a!gridField(
  data: local!items,
  columns: {
    a!gridColumn(
      label: "Name",
      value: fv!row.name  /* Only fv!row is available */
    )
  },
  selectable: true,
  selectionValue: local!selectedRows,  /* This is a LIST of selected row data */
  selectionSaveInto: local!selectedRows,
  maxSelections: 1
)

/* Access selected data (selectionValue is always a LIST): */
local!firstSelected: index(local!selectedRows, 1, null)
```

### Key Points
- Grid `selectionValue` is ALWAYS a list, even with `maxSelections: 1`
- Use `index(local!selectedRows, 1, null)` to get the first selected item
- Check length before accessing: `if(length(local!selectedRows) > 0, ...)`

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

### Key Functions
- `todate()` - Cast to Date type (use for all date arithmetic in sample data)
- `tointeger()` - Convert interval to whole days as integer
- `text(value, format)` - Format numbers/dates/intervals as text

## EXPRESSION STRUCTURE RULES
- All expressions must begin with a!localVariables() as the parent element
- Place the main interface as the last argument of a!localVariables()
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
- ButtonWidgets only take "ACCENT" or hex codes as color values
- Icons must reference valid aliases (see `/ui-guidelines/5-rich-text-icon-aliases.md`)
- RichTextItem align parameter allowed values are "LEFT", "CENTER", or "RIGHT", do not use "START" or "END"!
- Checkbox and radio button labels can only accept plain text, not rich text
- choiceValues CANNOT be null or empty strings (“”)

## 🛑 MANDATORY VALIDATION CHECKLIST
👉 Always call validation sub-agents to code review new expressions:
1. **sail-schema-validator** - Validates function syntax
2. **sail-icon-validator** - Checks for valid icon names
3. **sail-code-reviewer** - Validates structure, syntax, and best practices

### Syntax Validation:
- [ ] Starts with a!localVariables()
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes
- [ ] Escape double quotes like "", not like \" ✅ CHECK EVERY STRING VALUE
- [ ] Comments use /* */ not //
- [ ] `or(a,b)` NOT `a or b` ‼️
- [ ] Null checks before comparisons - use `and(not(isnull(variable)), variable = value)` ‼️
- [ ] Null checks before text() formatting - use `if(isnull(value), "N/A", text(value, format))` ‼️
- [ ] Null checks for record field access - wrap in `a!defaultValue()` or check with `isnull()` ‼️
- [ ] Null checks before string concatenation - use `a!defaultValue(field, "")` ‼️
- [ ] Date arithmetic wrapped in todate() in sample data - use `todate(today() + 1)` ‼️
- [ ] No Interval-to-Number comparisons - use `tointeger()` to convert first ‼️

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
- [ ] At least one AUTO width column in columnsLayout
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!