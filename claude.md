# PROJECT INSTRUCTIONS - SAIL UI GENERATION

## PURPOSE AND GOALS
- Given a request, generate an Appian SAIL UI mockup
- Write generated output to a .sail file in the /output folder
- Use only valid SAIL components and the allowed parameter values for each
- Use modern, but business-appropriate styling
- Don't worry about querying live data, just hard-code sample content using local variables and a!map
- NEVER use `ri!` or `recordtype!` references in mockups - mockups are pure UX prototypes
- Use `local!` variables for ALL data AND control parameters (isUpdate, cancel)
- Initialize control parameters: `local!isUpdate: false()`, `local!cancel: false()`
- The sail-dynamic-converter agent will transform local! → ri! in Phase 2
- Inline ALL logic - no `rule!` or `cons!` references unless explicitly specified!
  - ❌ SAIL does not support inline function definitions or helper expressions stored in variables
  - ❌ CANNOT create reusable logic: `local!calculateColor: rule!helper` (syntax error - rule references cannot be stored in variables)
  - ❌ CANNOT define inline helper functions or lambdas: `local!helper: function(x, y)(...)` or `local!helper: expression` (invalid SAIL syntax)
  - ✅ Repeat logic inline wherever needed (even if duplicative across multiple columns/components)
  - ✅ For complex repeated logic, use if()/a!match() patterns directly in each location
- 💡 **When logic is repeated 3+ times**: Add TODO comment for future extraction:
  ```sail
  /* TODO: Extract to expression rule - repeated logic for status calculation
   * Used in: Status column tag, Status column color, Filter dropdown
   * Logic: if(and(startDate <= today(), endDate >= today()), "Current", ...) */
  ```
- ‼️Syntax errors are DISASTROUS and MUST BE AVOIDED at any cost! Be METICULOUS about following instructions to avoid making mistakes!
- ❌Don't assume that a parameter or parameter value exists - ✅ONLY use values specifically described in the appropriate schema files (`/ui-guidelines/reference/schemas/*.json`)

## ⚠️ BEFORE YOU BEGIN - MANDATORY RULES
1. ❌ NEVER nest sideBySideLayouts inside sideBySideLayouts
2. ❌ NEVER put arrays of components inside sideBySideLayouts
3. ❌ NEVER put columnsLayouts or cardLayouts inside sideBySideLayouts
4. ✅ ONLY richTextItems or richTextIcons are allowed inside richTextDisplayField
5. ✅ Each columnsLayout must have at least one AUTO-width columnLayout
6. ❌ choiceValues CANNOT be null or empty strings
7. ⚠️ ALWAYS check for null before comparisons/property access - use if() NOT and() (see NULL SAFETY RULES section)
8. ⚠️ Grid record-only parameters (`showSearchBox`, `userFilters`, `recordActions`) cause runtime errors with local data - use custom search/filter UX with TODO comments for mockups instead
9. ❌ NEVER use runtime generators (rand(), now(), today()) for sample data - use hardcoded static values instead

If you violate any of these rules, STOP and reconsider your approach.

---

# PHASE 1: UNDERSTAND THE TASK

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

---

# PHASE 2: PLAN THE UI

## PAGE UI DESIGN PLANNING STEPS
When designing a full page, follow these planning steps (not necessary if user requests a single component):

1. Decide which top-level layout to use:
  - [ ] Pane layout - if the page features full-height (100vh) panes that might scroll independently, or,
  - [ ] Form layout - for single-step forms, or,
  - [ ] Wizard layout - for multi-step forms, or,
  - [ ] Header-content layout - for everything else
2. Read primary layout docs
  - [ ] If using FormLayout → Read `ui-guidelines/layouts/form-layout-instructions.md`
  - [ ] If using HeaderContentLayout → Read `ui-guidelines/layouts/header-content-layout-instructions.md`
  - [ ] If using PaneLayout → Read `ui-guidelines/layouts/pane-layout-instructions.md`
  - [ ] If using WizardLayout → Read `ui-guidelines/layouts/wizard-layout-instructions.md`
3. Plan the main page content layout using columnsLayout → Always read `ui-guidelines/layouts/columns-layout-instructions.md`
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
4. Use sideBySideLayout as needed to arrange groupings of content items, e.g. a stamp next to a rich text title next to a button → Always read `ui-guidelines/layouts/sidebyside-layout-instructions.md`
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
- A custom tabular display pattern (`ui-guidelines/components/tabular-data-display-pattern.md`) can be used if the capabilities of `gridField` are too limiting (such as when each cell needs to show multiple components)
- Use `cardGroupLayout` to show a responsive grid of cards with each card representing a list item. This creates a more visually interesting list than a basic `gridField`.

### Decorative Data Display
- `stampField` is a colored circle or square that shows an icon or initials. Use to represent user initials, anchor list items, etc. Read `ui-guidelines/components/stamp-field-instructions.md`if using.
- Use `tagField` to show UI elements styled like tags or chips. Find `a!tagField` in `ui-guidelines/reference/schemas/display-components-schema.json` if using.
- Use `richTextDisplayField` to show styled text and icons. Read `ui-guidelines/components/rich-text-instructions.md` if using.

### Common Patterns
Browse the `/ui-guidelines/patterns` folder for examples of how to compose common UI elements.

*ALWAYS* study the relevant patterns if the UI requires any of these elements:
- `ui-guidelines/patterns/card_lists.md` for list items (users, tasks, products, messages, etc.) shown as cards
- `ui-guidelines/patterns/kpis.md` for key performance indicator cards
- `ui-guidelines/patterns/messages.md` for message banners (info, warning, etc.)
- `ui-guidelines/patterns/tabs.md` for tab bars

### Special Rules
- When using sectionLayout, set labelColor: "STANDARD" (unless a specific color is required in the instructions)
- When not setting a label on a component, explicitly set labelPosition to "COLLAPSED" so that space is not reserved for the label (for more reliable alignment)

### Button Quick Rules
- [ ] Style is ONLY: `"OUTLINE"` | `"GHOST"` | `"LINK"` | `"SOLID"` (no "PRIMARY" or "ACCENT"!)
- [ ] Colors: `"ACCENT"` | `"SECONDARY"` | `"NEGATIVE"` | hex codes
- [ ] Primary action = `style: "SOLID"` + `color: "ACCENT"` (both required)
- [ ] Always wrapped in `a!buttonArrayLayout`

### Grid Search and Filters

**Mockups:** Create custom search/filter UX with TODO-CONVERTER comments:
```sail
/* TODO-CONVERTER: Convert to showSearchBox: true */
a!textField(label: "Search", value: local!searchText, saveInto: local!searchText)

/* TODO-CONVERTER: Convert to userFilters if available, otherwise document as TODO */
a!dropdownField(
  label: "Filter by Status",
  placeholder: "All Statuses",
  choiceLabels: {"Active", "Completed", "Cancelled"},
  choiceValues: {"Active", "Completed", "Cancelled"},
  value: local!statusFilter,
  saveInto: local!statusFilter
)
```

**Exception:** Multi-grid filters (apply to multiple grids/charts) remain as custom UX - no TODO-CONVERTER comment.

---

### Form Button Field-Setting

Use TODO-CONVERTER comments to indicate field-setting:

```sail
/* TODO-CONVERTER: Set status to "Approved" */
/* TODO-CONVERTER: Set approvedBy to current user */
/* TODO-CONVERTER: Set approvedDate to current timestamp */
a!buttonWidget(
  label: "Approve",
  saveInto: a!save(local!status, "Approved"),  /* Mockup uses local! + text */
  submit: true(),
  style: "SOLID",
  color: "ACCENT"
)

/* TODO-CONVERTER: Read-only field - value set in button saveInto */
a!textField(
  label: "Status",
  value: local!status,
  readOnly: true  /* No saveInto */
)
```

**Rules:**
- TODO-CONVERTER ONLY for fields the button sets (not user-editable fields)
- Use text values in mockups (`"Approved"`) - converter resolves to IDs if needed

---

### Form Control Parameters

Initialize control parameters as local! with TODO-CONVERTER comments:

```sail
a!localVariables(
  local!isUpdate: false(),   /* TODO-CONVERTER: Transform to ri!isUpdate */
  local!cancel: false(),     /* TODO-CONVERTER: Transform to ri!cancel */

  a!formLayout(
    titleBar: if(a!defaultValue(local!isUpdate, false()), "Update", "Create"),
    contents: { /* ... */ },
    buttons: a!buttonLayout(
      primaryButtons: {
        /* TODO-CONVERTER: Set all form fields to corresponding record type fields */
        a!buttonWidget(
          label: if(a!defaultValue(local!isUpdate, false()), "Update", "Submit"),
          submit: true()
        )
      },
      secondaryButtons: {
        /* TODO-CONVERTER: Set local!cancel to true, transform to ri!cancel */
        a!buttonWidget(
          label: "Cancel",
          saveInto: a!save(local!cancel, true())
        )
      }
    )
  )
)
```

**Required:**
- Initialize: `local!isUpdate: false()`, `local!cancel: false()`
- Use `a!defaultValue(local!isUpdate, false())` in conditionals
- All references use `local!`, never `ri!`

---

### Comment Types

| Prefix | Use For |
|--------|---------|
| `TODO-CONVERTER:` | Set field to X, Increment Y, Add audit fields, Transform to ri!, Convert to showSearchBox/userFilters |
| `TODO:` | Send email, Trigger process, Configure webhook, Add user filter, Add translation set |
| `TODO-DATA-MODEL:` | Add field to table, Create relationship |
| `REQUIREMENT:` | User-specified business rules (see `/logic-guidelines/documentation-patterns.md`) |

```sail
/* ✅ Field-setting */
/* TODO-CONVERTER: Set status to "Approved" */
/* TODO-CONVERTER: Set approvedBy to current user */

/* ✅ Process activity */
/* TODO: Configure process model to send approval email */

/* ❌ WRONG - Process activity misclassified */
/* TODO-CONVERTER: Send notification email */  /* Use TODO! */
```

---

### Mockup Boundaries

**❌ NEVER in mockups:**
- `ri!` (use `local!` with TODO-CONVERTER)
- `recordtype!` references (use `a!map()`)
- `a!recordData()`, `a!queryRecordType()` (use `local!` with sample data)
- `'recordType!Case.fields.status'` (use simple property: `fv!row.status`)
- Grid parameters: `showSearchBox`, `userFilters`, `recordActions` (use custom UX with TODO comments)

**✅ ALWAYS in mockups:**
- `local!` variables with `a!map()` sample data
- Simple property names (`.status` not `['recordType!Case.fields.status']`)
- Custom search/filter UX with TODO-CONVERTER comments
- Control parameters: `local!isUpdate: false()`, `local!cancel: false()`
- **Static hardcoded sample values** (no rand(), no runtime generation)

```sail
/* ✅ MOCKUP - Static sample data */
local!caseNumber: "CASE-2024-5847",
local!submittedDate: date(2025, 1, 15),
local!priority: "High",
local!cases: {
  a!map(id: 1, title: "Case A", status: "Open"),
  a!map(id: 2, title: "Case B", status: "Closed")
}

/* ❌ WRONG - Runtime generation in mockups */
local!caseNumber: "CASE-" & text(rand(10000), "0000"),  /* Changes on every re-evaluation! */
local!submittedDate: today(),  /* Use specific date instead */

/* ❌ FUNCTIONAL CODE (not a mockup!) */
local!cases: a!queryRecordType(
  recordType: 'recordType!Case',
  fields: {'recordType!Case.fields.id'}
).data
```

## STYLING
### Use this color scheme for generated SAIL UIs
- #F5F6F8: page background color
- #1C2C44: (optional) page header bar background color
- #FFFFFF: content card background color
- `ACCENT`: themed accent color (primary buttons, etc.)
- `STANDARD`: text and heading color

---

# PHASE 3: WRITE THE CODE

## 📚 DOCUMENTATION REQUIREMENT

**ALWAYS read component docs from `/ui-guidelines/` BEFORE writing code.** Never assume you know how a component works—read the documentation first, code second.

**Two-tier documentation structure:**
1. **Schema Reference (SELECTIVE LOADING)** - Category-specific schema files for parameter validation
2. **Detailed Instructions** - Dedicated instruction files for complex components

---

## 🎯 PARAMETER VALIDATION STRATEGY (Use Selective Loading)

**CRITICAL:** Load ONLY the category schema files you need based on your task from `/ui-guidelines/reference/schemas/`.

### Step 1: Detect Interface Type and Components Needed

**For FORMS (create/update interfaces):**
```
ALWAYS load:
  ✅ ui-guidelines/reference/schemas/layouts-schema.json
  ✅ ui-guidelines/reference/schemas/input-components-schema.json
  ✅ ui-guidelines/reference/schemas/button-components-schema.json
```

**For DISPLAYS (dashboards/reports):**
```
ALWAYS load:
  ✅ ui-guidelines/reference/schemas/layouts-schema.json
  ✅ ui-guidelines/reference/schemas/display-components-schema.json

CONDITIONALLY load:
  - Using grids? → schemas/grid-components-schema.json
  - Using charts? → schemas/chart-components-schema.json
  - Has action buttons? → schemas/button-components-schema.json
```

**For GRID-HEAVY INTERFACES:**
```
ALWAYS load:
  ✅ ui-guidelines/reference/schemas/layouts-schema.json
  ✅ ui-guidelines/reference/schemas/grid-components-schema.json

CONDITIONALLY load:
  - Has action buttons? → schemas/button-components-schema.json
  - Has filters? → schemas/input-components-schema.json
  - Complex logic? → schemas/expression-functions-schema.json
```

### Step 2: Load Expression Functions IF Needed

**Only load `schemas/expression-functions-schema.json` if you need:**
- Complex loops (a!forEach)
- Pattern matching (a!match)
- Helper functions (richTextItem, richTextIcon, save, update)
- Array manipulation (wherecontains, index, append)

**DO NOT load if you're only using basic components with simple parameters.**

---

### Schema File Reference

| Category | File | Components | When to Use |
|----------|------|------------|-------------|
| **Layouts** | `schemas/layouts-schema.json` | 18 | Page structure (formLayout, headerContentLayout, wizardLayout, etc.) |
| **Inputs** | `schemas/input-components-schema.json` | 18 | Form fields (textField, dateField, dropdownField, etc.) |
| **Displays** | `schemas/display-components-schema.json` | 14 | Read-only displays (richText, stamps, tags, images) |
| **Grids** | `schemas/grid-components-schema.json` | 12 | Grids and data queries (gridField, recordData, queryFilter) |
| **Charts** | `schemas/chart-components-schema.json` | 12 | Charts (columnChart, pieChart, measure, grouping) |
| **Buttons** | `schemas/button-components-schema.json` | 3 | Buttons and actions (buttonWidget, buttonArrayLayout) |
| **Functions** | `schemas/expression-functions-schema.json` | 39+60 funcs | Expressions, loops, helpers, utilities |

---

### Available Detailed Instruction Files:

**Expression Grammar & Variables:**
- `logic-guidelines/functions-reference.md` - Essential functions reference (arrays, text, dates, queries)

**Layout Components:**
- `ui-guidelines/layouts/header-content-layout-instructions.md` - HeaderContentLayout guidelines
- `ui-guidelines/layouts/columns-layout-instructions.md` - ColumnsLayout guidelines
- `ui-guidelines/layouts/sidebyside-layout-instructions.md` - SideBySideLayout guidelines
- `ui-guidelines/layouts/form-layout-instructions.md` - FormLayout guidelines
- `ui-guidelines/layouts/pane-layout-instructions.md` - PaneLayout guidelines
- `ui-guidelines/layouts/wizard-layout-instructions.md` - WizardLayout guidelines
- `ui-guidelines/layouts/card-layout-instructions.md` - CardLayout guidelines

**Display Components:**
- `ui-guidelines/components/button-instructions.md` - Button and ButtonArrayLayout guidelines
- `ui-guidelines/components/grid-field-instructions.md` - GridField (read-only grid) guidelines
- `ui-guidelines/components/grid-layout-instructions.md` - GridLayout (editable grid) guidelines
- `ui-guidelines/components/rich-text-instructions.md` - Rich Text component guidelines
- `ui-guidelines/components/stamp-field-instructions.md` - Stamp Field guidelines
- `ui-guidelines/components/card-choice-field-instructions.md` - Card Choice Field guidelines
- `ui-guidelines/components/chart-instructions.md` - Chart component guidelines
- `ui-guidelines/components/image-field-instructions.md` - Image Field guidelines
- `ui-guidelines/components/tabular-data-display-pattern.md` - Custom tabular display pattern

**Icons:**
- `ui-guidelines/reference/rich-text-icon-aliases.md` - Valid icon aliases for richTextIcon (**MUST READ before using any icons**)

**All other components** (textField, dropdownField, etc.) are documented in category-specific schema files only.

### Documentation Lookup Process:

1. **Check if a dedicated instruction file exists** for the component (see list above)
   - If YES → Read the dedicated file for templates, patterns, and detailed rules
   - If NO → Use the appropriate category schema file for parameters and values

2. **For unfamiliar components** - Read the component entry in the appropriate schema file first to understand basic parameters
   - Forms → `schemas/input-components-schema.json`
   - Displays → `schemas/display-components-schema.json`
   - Grids → `schemas/grid-components-schema.json`
   - Charts → `schemas/chart-components-schema.json`
   - Buttons → `schemas/button-components-schema.json`

### ❌ NEVER:
- Use parameters that aren't explicitly documented in either the reference or instruction files
- Put components in layouts that don't accept them
- Skip reading documentation because "it seems straightforward"

### ✅ ALWAYS:
- Start with appropriate schema files for parameter validation (see "PARAMETER VALIDATION STRATEGY" above)
- Read dedicated instruction files when available for templates and patterns
- Follow templates exactly from instruction files
- Verify against validation checklists
- **Read `/ui-guidelines/reference/rich-text-icon-aliases.md` in full before using ANY icons**

**THIS IS NOT OPTIONAL. Skipping documentation causes critical errors.**

## 🔄 DYNAMIC SAIL EXPRESSIONS

**When working with dynamic data (arrays, loops, conditionals), read the appropriate topic file FIRST.**

### Topic Files by Need

| Need | Read This File |
|------|----------------|
| **Navigation index** | `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` |
| **Email validation (textField)** | `/logic-guidelines/functions-reference.md#email-validation-pattern` |
| Arrays, loops, forEach | `/logic-guidelines/foreach-patterns.md` |
| Array manipulation, wherecontains | `/logic-guidelines/array-manipulation-patterns.md` |
| Null safety patterns | `/logic-guidelines/null-safety-quick-ref.md` |
| Grid selections | `/logic-guidelines/grid-selection-patterns.md` |
| Checkbox initialization | `/logic-guidelines/choice-field-patterns.md` |
| Pattern matching (a!match) | `/logic-guidelines/pattern-matching.md` |
| Date/time handling | `/logic-guidelines/datetime-handling.md` |
| Chart configuration | `/logic-guidelines/chart-configuration.md` |
| Non-existent constants | `/logic-guidelines/environment-placeholders.md` |

## EXPRESSION STRUCTURE RULES
- All expressions must begin with a!localVariables() as the parent element
- Place the main interface as the last argument of a!localVariables()
   - When the top-level layout is `a!paneLayout`, `a!formLayout`, `a!wizardLayout`, or `a!headerContentLayout`, DON'T put it in an array ({})
- Define any local variables within the a!localVariables() function
- All form inputs should save into a corresponding local variable
- ButtonWidgets can't be on their own, they must be inside a ButtonArrayLayout
- Use cardLayout for content blocks, EXCEPT when the content is already a collection of cards (cardGroupLayout, multiple cardLayouts arranged in a list) - in those cases, place the cards directly on the page background without an outer wrapper card

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
- **Always check for null/empty before comparing values or accessing properties** - See "NULL SAFETY RULES" section below for complete patterns
- **SAIL has NO regex support** - never use `regexmatch()`, `regex()`, or similar functions; for email validation use pattern from `/logic-guidelines/functions-reference.md#email-validation-pattern` ‼️

### Dynamic Form Generation
- **Choose the right pattern** - See "Dynamic Form Field Validation" in the validation checklist:
  - **Array of Maps** (PREFERRED): For multi-instance data entry (work experiences, addresses, line items) → `saveInto: fv!item.propertyName`
  - **Parallel Arrays**: Only when iterating a fixed source list to collect separate data → `index()` + `a!update()` pattern
- Read `/logic-guidelines/foreach-patterns.md` for complete pattern guidance before implementing
- NEVER use `value: null, saveInto: null` in input fields - See "NULL SAFETY RULES" section for details

## ⚠️ NULL SAFETY RULES (CRITICAL)

> **📖 Complete Reference:** `/logic-guidelines/null-safety-quick-ref.md`
> **📖 Why if() vs and():** `/logic-guidelines/short-circuit-evaluation.md`
> **⚠️ saveInto Rules:** `save!value` ONLY valid inside `a!save()` value parameter - see `/logic-guidelines/choice-field-patterns.md`

### Core Problem
SAIL cannot handle null values in most operations - comparisons crash, property access fails, functions reject null.

### saveInto Variable Restrictions
- ✅ `save!value` can ONLY be used inside: `a!save(target, save!value)` or `a!save(target, if(..., save!value, ...))`
- ❌ NEVER use `save!value` in if() conditions, and(), or(), or anywhere outside a!save()
- ❌ NEVER use `save!value` in the target parameter of a!save()
- ✅ To check state transitions, use helper variables (e.g., `local!previousState`) instead of checking save!value

### Universal Pattern: Use if() for Short-Circuit Evaluation

```sail
/* ✅ RIGHT - if() short-circuits (safe) */
showWhen: if(a!isNotNullOrEmpty(local!selectedId),
              local!selectedId = fv!item.id,
              false())

/* ❌ WRONG - and() does NOT short-circuit (crashes) */
showWhen: and(a!isNotNullOrEmpty(local!data),
              local!data.type = "Contract")  /* CRASHES if null! */
```

### Essential Patterns (Quick Reference)

| Scenario | Pattern |
|----------|---------|
| Comparison with nullable | `if(a!isNotNullOrEmpty(var), comparison, false)` |
| Property access | `if(a!isNotNullOrEmpty(obj), obj.prop, default)` |
| Function parameter | `function(a!defaultValue(var, default))` |
| Grid selection | `index(selection, 1, null)` then check |
| Boolean with not() | `not(a!defaultValue(var, false()))` |

**See `/logic-guidelines/null-safety-quick-ref.md` for complete patterns including:**
- Choice field initialization
- Functions that reject null (text, concat, user, not)
- Relationship field access
- Date/DateTime display formatting

## ⚠️ FUNCTION VARIABLES (fv!) - CRITICAL RULES

Function variables (fv!) are context-specific and ONLY available in certain SAIL functions.

**Most common mistake**: Using `fv!index` in grid columns (it doesn't exist - only `fv!row` is available)

**Detailed Topic Files:**
- `/logic-guidelines/foreach-patterns.md` - Complete a!forEach() function variables (fv!item, fv!index, etc.)
- `/logic-guidelines/grid-selection-patterns.md` - Two-variable approach and selection behavior

**Master guidelines:**
- `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` for comprehensive patterns

## TYPE HANDLING FOR DATE/TIME CALCULATIONS

> **📖 Complete Reference:** `/logic-guidelines/datetime-handling.md`

### Essential Rules
- **Cast date arithmetic**: Use `todate(today() + 1)` in sample data (prevents type mismatch)
- **Interval comparisons**: Use `tointeger(now() - timestamp)` before comparing to numbers
- **Type matching**: Date fields use `today()`, DateTime fields use `now()`

```sail
/* ✅ RIGHT - Consistent Date types */
local!data: {
  a!map(dueDate: todate(today())),
  a!map(dueDate: todate(today() + 7))
}

/* ✅ RIGHT - Interval to Integer for comparison */
if(tointeger(now() - fv!row.timestamp) < 1, ...)
```

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

---

# PHASE 4: VALIDATE & DOCUMENT

## CAPTURING USER REQUIREMENTS IN GENERATED CODE

> **📖 Complete Patterns:** `/logic-guidelines/documentation-patterns.md`

When generating mockups, capture user-specified requirements as comments using the three-tier structure:
1. **Interface-level header** - Overall purpose and key requirements
2. **Section-level comments** - Business purpose + field requirements
3. **Inline comments** - Complex logic explanation

**Critical Rules:**
- ✅ ONLY capture requirements explicitly stated by the user
- ❌ DO NOT add requirement comments for standard UI patterns (sorting, formatting, basic display)
- ❌ DO NOT invent business rules or make assumptions about data logic

**See `/logic-guidelines/documentation-patterns.md` for complete examples and comment format guidelines.**

## 🚨 UNIVERSAL SAIL VALIDATION CHECKLIST

### 🛑 STOP - Before Writing ANY Code:

**READ `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` NOW if your code will use ANY of the following:**
- [ ] Arrays or lists (any `{}` or `local!data: {...}`)
- [ ] Index access (`index()`, array element access)
- [ ] Property access on maps (`.fieldName` or `fv!row.fieldName`)
- [ ] Null checking or comparisons with variables that could be null
- [ ] Any looping (`a!forEach`)
- [ ] Data aggregation (showing counts, grouping "by status", "by priority", etc.)
- [ ] Multiple data items (lists of cases, users, products, etc.)

**❌ IF YES TO ANY → STOP AND READ `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` FIRST**
**✅ IF NO TO ALL → Proceed with static UI generation (single values, no data manipulation)**

### Before Writing Dynamic Code:
- [ ] Read `/logic-guidelines/local-variable-patterns.md` for data modeling philosophy (maps for entity data, separate variables for UI state)
- [ ] Read `/logic-guidelines/LOGIC-PRIMARY-REFERENCE.md` if using arrays, loops, null checking in mock data interfaces
- [ ] SAIL doesn't support regex - for email validation, MUST use `/logic-guidelines/functions-reference.md#email-validation-pattern`

### Dynamic Form Field Validation:
- [ ] **Pattern Selection for Multi-Instance Forms** (see `/logic-guidelines/foreach-patterns.md`):
  - [ ] **Array of Maps** (PREFERRED): When collecting multiple instances of related data (work experiences, addresses, contacts, line items) → Use `local!items: {a!map(...)}` with `saveInto: fv!item.propertyName` ‼️
  - [ ] **Parallel Arrays** (ALTERNATIVE): Only when iterating over a FIXED source list to collect SEPARATE data → Use `index()` + `a!update()` pattern
- [ ] Parallel arrays type-initialized based on data type (see logic-guidelines/array-type-initialization-guidelines.md) ‼️
- [ ] NO `value: null, saveInto: null` in input fields (textField, dateField, fileUploadField, etc.) ‼️
- [ ] Multi-select checkbox fields use single array variable, NOT separate boolean variables ‼️ (see `/logic-guidelines/choice-field-patterns.md`)
- [ ] Single checkbox (choiceValues: {true()}) uses `a!isNotNullOrEmpty()` for showWhen, NOT `contains()` ‼️
- [ ] DO NOT use `local!showValidation` flags - SAIL's `validations` parameter evaluates automatically when fields have values ‼️
- [ ] Email fields: MUST use the email validation pattern from `/logic-guidelines/functions-reference.md#email-validation-pattern` - do NOT improvise ‼️
- [ ] Single-field validations: Do NOT wrap in `a!isNotNullOrEmpty()` - SAIL only evaluates validations when field has a value ‼️
- [ ] NO manual language toggles or `local!currentLanguage` variables - Appian handles i18n automatically (see `/logic-guidelines/internationalization.md`) ‼️
- [ ] Control parameters (isUpdate, cancel) use `local!` NOT `ri!` - initialized to false(), converter transforms in Phase 2 ‼️

### Syntax Validation:
- [ ] Starts with a!localVariables()
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes
- [ ] Escape double quotes like "", not like \" ✅ CHECK EVERY STRING VALUE
- [ ] Comments use /* */ not //
- [ ] `or(a,b)` NOT `a or b` ‼️
- [ ] Pattern matching (3+ cases on single value) use `a!match()` NOT `if()` ‼️
  - Exact values (status/category/priority): `a!match(equals:)`
  - Ranges/thresholds (>=100, >=75): `a!match(whenTrue:)`
- [ ] Empty arrays type-initialized: `tointeger({})`, `touniformstring({})`, `toboolean({})`, `todate({})`, `todatetime({})`, `todecimal({})`, `totime({})`, `touser({})`, `togroup({})` ‼️
- [ ] Text arrays use `touniformstring({})` NOT `tostring({})` (tostring merges to single string) ‼️
- [ ] NO untyped `{}` used with contains(), wherecontains(), union(), intersection() ‼️
- [ ] NO mixed-type appends that create List of Variant ‼️
- [ ] All null-unsafe operations protected (see "NULL SAFETY RULES" section) ‼️
  - Comparisons wrapped in if() short-circuit pattern
  - Property access checked before use
  - Function parameters use a!defaultValue() where needed
  - Grid selections use index(..., 1, null) pattern
- [ ] Date arithmetic wrapped in todate() in sample data - use `todate(today() + 1)` ‼️
- [ ] No Interval-to-Number comparisons - use `tointeger()` to convert first ‼️
- [ ] index() wrapped in type converters for arithmetic - use `todate(index(...))`, `tointeger(index(...))`, etc. ‼️
- [ ] **NO inline function definitions or lambdas** - `local!helper: function(x)(...)` is invalid SAIL syntax ‼️
- [ ] Repeated logic: Duplicate inline with TODO comment, don't extract to helper variable ‼️

### Function Variable Validation:
- [ ] ✅ In grid columns: ONLY use `fv!row` (NOT fv!index, NOT fv!item) ‼️
- [ ] ❌ NEVER use `fv!index` in grid columns - use grid's selectionValue instead ‼️
- [ ] ✅ Grid selectionValue is always a LIST - use `index(local!selected, 1, null)` to access
- [ ] ✅ In a!forEach(): Use `fv!index`, `fv!item`, `fv!isFirst`, `fv!isLast`
- [ ] ❌ NEVER use `fv!item` outside of a!forEach() ‼️
- [ ] ✅ `save!value` can ONLY be used inside the `value` parameter of `a!save(target, value)` ‼️
- [ ] ❌ NEVER use `save!value` in conditionals (if/and/or), target parameter, or outside a!save() (see `/logic-guidelines/choice-field-patterns.md`) ‼️

### Parameter Validation:
- [ ] Check to see that every parameter and value is listed in documentation before using!
- [ ] **Grid columns: sortField must match the primary field displayed in value parameter AND be unique across all columns** ‼️
- [ ] **Each field used as sortField only ONCE across all grid columns** ‼️
- [ ] **Computed columns (if/a!match/concat) must NOT have sortField** ‼️

### Layout Validation:
- [ ] One top-level layout (HeaderContent/FormLayout/PaneLayout)
- [ ] No nested sideBySideLayouts
- [ ] No columns or card layouts inside sideBySideItems
- [ ] Only richTextItems or richTextIcons in richTextDisplayField
- [ ] At least one AUTO width column in each columnsLayout
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!

### Unused Variable Check:
- [ ] No unused local variables (declared but never referenced) ‼️
  - Variables with count=1 (declaration only) should be removed
  - If justified for future use, document with `/* UNUSED - [reason] */` comment

## 🛑 MANDATORY DELEGATION CHECKLIST

### 🔄 Generating Functional Interfaces (Two-Step Workflow):

**When user requests a "functional interface" or "dynamic interface" or "live data interface":**

⚠️ **ALWAYS follow this two-step process:**

```
STEP 1: Create static mockup FIRST
        └─► Write to /output/[name].sail
        └─► Use local! variables with a!map() for sample data
        └─► Capture requirements in /* REQUIREMENT: */ comments

STEP 2: THEN invoke sail-dynamic-converter agent
        └─► Agent reads /output/[name].sail
        └─► Transforms to functional code
        └─► Writes to /output/[name]-functional.sail
```

**The sail-dynamic-converter agent REQUIRES an existing mockup file to read.**

---

### 🔄 Converting Existing Mock to Functional Interface:

**REQUIRED ACTION:**
- [ ] **ALWAYS invoke sail-dynamic-converter agent** when user requests:
  - Converting static/mock interfaces to use live record data
  - Making mockups dynamic or connecting to real data
  - Using actual data from record types
- [ ] Use Task tool: `subagent_type: "sail-dynamic-converter"`

**❌ NEVER:**
- Attempt conversion yourself without invoking the agent
- Make up UUIDs or field references
- Invoke sail-dynamic-converter without a mockup file existing first

### ✅ Validating SAIL Expressions:
👉 Always use tools to validate new expressions:
- [ ] *IF* mcp__appian-mcp-server__validate_sail is available, always call it for efficient syntax validation
- [ ] *OTHERWISE*, call these sub-agents (!!!ONLY!!! if mcp__appian-mcp-server__validate_sail is NOT available):
    - [ ] 1. **sail-schema-validator** - Validates function syntax
    - [ ] 2. **sail-icon-validator** - Checks for valid icon names
    - [ ] 3. **sail-code-reviewer** - Validates structure, syntax, and best practices