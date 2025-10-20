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

## 📚 DOCUMENTATION-FIRST WORKFLOW (MANDATORY)

**BEFORE writing ANY SAIL code, you MUST:**

1. **Read the component documentation** from `/ui-guidelines/` folder
   - Find the relevant file: Use Glob to search for `*-<component-name>-instructions.md`
   - Read the ENTIRE file before using the component
   - DO NOT assume you know how a component works from memory

2. **Follow the templates exactly** as shown in the documentation
   - Use the "Standard Template" or "Common Patterns" sections
   - Do NOT improvise or "improve" the structure
   - Parameters and their values are explicitly documented - use only those

3. **Check the validation checklist** at the end of each documentation file
   - Every component documentation file has a validation checklist
   - Verify your code against ALL checklist items before finalizing

4. **Reference while writing**
   - Keep the documentation open while writing code
   - Cross-reference parameter names and allowed values
   - When in doubt, re-read the documentation

### Key Files Available:
- `0-sail-component-reference.md` - Overview of all UI components and parameters
- `1-expression-grammar-instructions.md` - Explains expression grammar for calculation, logic, etc. functions
- `3-header-content-layout-instructions.md` - HeaderContentLayout guidelines
- `3-columns-layout-instructions.md` - ColumnsLayout guidelines
- `3-sidebyside-layout-instructions.md` - SideBySideLayout guidelines
- `4-card-layout-instructions.md` - CardLayout guidelines
- `4-grid-field-instructions.md` - GridField guidelines
- `4-rich-text-instructions.md` - Rich Text component guidelines
- `4-stamp-field-instructions.md` - Stamp Field guidelines
- And many more...

### ❌ NEVER:
- Assume you know how a component works without reading the docs
- Use parameters that aren't explicitly documented
- Put components in parameters that don't accept them
- Skip reading documentation because "it seems straightforward"

### ✅ ALWAYS:
- Read first, code second
- Follow templates exactly
- Verify against validation checklists
- Reference documentation while writing

**THIS IS NOT OPTIONAL. Skipping documentation causes critical errors.**

## INITIAL REQUEST CATEGORIZATION
Is the user request...
1. For a full page
   - Example: "Create a dashboard that..."
   - Example: "Generate a form for..."
-OR-
2. For a single component
   - Example: "Make a grid that..."
   - Example: "Create a card group that..."

## PAGE UI DESIGN PLANNING STEPS
When designing a full page, follow these planning steps (not necessary if user requests a single component):

1. Decide which top-level layout to use:
  [ ] Pane layout - if the page features full-height (100vh) panes that might scroll independently, or,
  [ ] Form layout - for single-step forms, or,
  [ ] Wizard layout - for multi-step forms, or,
  [ ] Header-content layout - for everything else
2. Plan the main page content layout using columnsLayout
3. Use sideBySideLayout as needed to arrange groupings of content items, e.g. a stamp next to a rich text title next to a button
  - sideBysideItems CANNOT contain other sideBySideLayouts/items, cardLayouts, or columnLayouts
  - A sideBysideItem can only contain one component, not an array of components
4. If your plan requires an invalid sideBySideLayout, RECONSIDER THE DESIGN:
  - Break components up into separate sideBySideItems, OR,
  - Use a columnsLayout instead

## LAYOUT SELECTION GUIDE

### Layout Hierarchy (Top to Bottom):
1. **Page Structure**: HeaderContentLayout/FormLayout/PaneLayout
2. **Content Sections**: ColumnsLayout → CardLayout/SectionLayout
3. **Component Arrangement**: SideBySideLayout (components only!)

### When to Use Each Layout:
#### ColumnsLayout vs SideBySideLayout
- **ColumnsLayout**: Page structure, content sections, different widths
- **SideBySideLayout**: Icon + text, label + value, small UI elements

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
Browse the `/ui-guidelines/patterns` folder for examples of how to compose common UI elements:
- `list_items.md` for list items (users, tasks, messages, etc.) as cards
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

## EXPRESSION STRUCTURE RULES
- All expressions must begin with a!localVariables() as the parent element
- Place the main interface as the last argument of a!localVariables()
- Define any local variables within the a!localVariables() function
- All form inputs should save into a corresponding local variable
- ButtonWidgets can't be on their own, they must be inside a ButtonArrayLayout
- Use cardLayout for content blocks (but not inside sideBySideLayout)

## PARAMETER RESTRICTIONS
- Only use parameters explicitly defined in the documentation
- For parameters with listed valid values, only use those specific values
- Color values must use 6-character hex codes (#RRGGBB) or documented enumeration values (like "ACCENT"). 
  - Allowed color enumeration values vary across components. Only use values specified in the documentation for that component.
  - HTML color names like "RED" are invalid
- ButtonWidgets only take "ACCENT" or hex codes as color values
- Icons must reference valid Font Awesome v4.7 icon aliases (but brand name or trademarked icons like "google" and "windows" are not supported)
- RichTextItem align parameter allowed values are "LEFT", "CENTER", or "RIGHT", do not use "START" or "END"!
- Checkbox and radio button labels can only accept plain text, not rich text
- choiceValues CANNOT be null or empty strings (“”)

## 🛑 MANDATORY VALIDATION CHECKLIST

### Syntax Validation:
- [ ] Call the sail-syntax-validator sub-agent as needed
- [ ] Starts with a!localVariables()
- [ ] All braces/parentheses matched
- [ ] All strings in double quotes
- [ ] Escape double quotes like "", not like \" ✅ CHECK EVERY STRING VALUE
- [ ] Comments use /* */ not //
- [ ] `or(a,b)` NOT `a or b` ‼️
- [ ] Null checks before comparisons - use `and(not(isnull(variable)), variable = value)` ‼️ 

### Parameter Validation:
- [ ] Check to see that every parameter and value is listed in documentation before using!

### Layout Validation:
- [ ] One top-level layout (HeaderContent/FormLayout/PaneLayout)
- [ ] No nested sideBySideLayouts
- [ ] No columns or card layouts inside sideBySideItems
- [ ] Only richTextItems or richTextIcons in richTextDisplayField
- [ ] At least one AUTO width column in columnsLayout
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField

‼️DO NOT nest sideBySideLayouts inside sideBySideLayouts
‼️DO NOT put columnsLayouts inside sideBySideLayouts
‼️DO NOT put cardLayouts inside sideBySideLayouts
‼️ONLY richTextItems and richTextIcons can go inside richTextDisplayField