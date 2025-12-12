# DYNAMIC SAIL UI EXPRESSION GUIDELINES - MOCK DATA INTERFACES

This guide covers dynamic SAIL expressions using **local variables with hardcoded/mock data** - no record types required. For record type integration patterns, see the record-interface.md guide.

## 📑 Quick Navigation Index {#nav-index}

**How to use this index:**
1. Find the topic you need below
2. For extracted files, read the file directly
3. For inline sections, use Grep tool or Ctrl+F to find the section in this file

### 📁 Extracted Topic Files (Read These for Detailed Patterns):

**Shared Foundations (used by both mockup and functional interfaces):**
- `/logic-guidelines/local-variable-patterns.md` - Data modeling, mockup vs functional differences
- `/logic-guidelines/short-circuit-evaluation.md` - Why if() vs and()/or() for null safety
- `/logic-guidelines/null-safety-quick-ref.md` - Quick pattern lookup table
- `/logic-guidelines/functions-reference.md` - Essential functions by category
- `/logic-guidelines/datetime-handling.md` - Date/time type matching & operators

**Mockup Patterns (mock data interfaces):**
- `/logic-guidelines/foreach-patterns.md` - fv! variables, Pattern A (array of maps) vs Pattern B (parallel arrays)
- `/logic-guidelines/grid-selection-patterns.md` - Two-variable approach, naming conventions
- `/logic-guidelines/checkbox-patterns.md` - Multi-checkbox, single checkbox initialization
- `/logic-guidelines/pattern-matching.md` - a!match() for status/category lookups
- `/logic-guidelines/chart-configuration.md` - Chart components, mock data patterns
- `/logic-guidelines/array-type-initialization-guidelines.md` - Type-casting empty arrays

### 🚨 Critical Sections in This File (Read These First):
- **Mandatory Foundation Rules** → `"## 🚨 MANDATORY FOUNDATION RULES"`
- **Rule Inputs in Mockups** → `"## ❌ Rule Inputs in Mockups - Common Mistake"`
- **Essential SAIL Structure** → `"## Essential SAIL Structure"`
- **Unused Variables in Mockups** → `"## 📝 Unused Variables in Mockups"`
- **Requirement-Driven Documentation** → `"## 📋 Requirement-Driven Documentation Pattern"`

### By Task Type:
- **Structuring local variables (maps vs separate)** → `/logic-guidelines/local-variable-patterns.md`
- **Documenting requirements in code** → `"## 📋 Requirement-Driven Documentation Pattern"`
- **Handling unused variables** → `"## 📝 Unused Variables in Mockups"`
- **Handling non-existent constants** → `"## ⚠️ IMPORTANT: Handling Non-Existent Constants"`
- **Internationalization** → `"## ⚠️ INTERNATIONALIZATION IN APPIAN INTERFACES"`
- **Initializing empty arrays** → `/logic-guidelines/array-type-initialization-guidelines.md`
- **Working with arrays/loops** → `/logic-guidelines/foreach-patterns.md`
- **forEach generating input fields** → `/logic-guidelines/foreach-patterns.md` (Parallel Array Pattern)
- **Direct property saving in forEach** → `/logic-guidelines/foreach-patterns.md`
- **Dot notation and derived data** → `"### Dot Notation & Derived Data Patterns"`
- **Using wherecontains() correctly** → `"### Using wherecontains() Correctly"`
- **Pattern matching (status, categories)** → `/logic-guidelines/pattern-matching.md`
- **Managing grid selections** → `/logic-guidelines/grid-selection-patterns.md`
- **Building charts with mock data** → `/logic-guidelines/chart-configuration.md`
- **Working with dates and times** → `/logic-guidelines/datetime-handling.md`
- **Single checkbox initialization** → `/logic-guidelines/checkbox-patterns.md`
- **Multiple checkbox selections** → `/logic-guidelines/checkbox-patterns.md`

### By Error Type:
- **"Variable not defined"** → `"## 🚨 MANDATORY FOUNDATION RULES"`
- **"Rule input not defined (ri!)"** → `"## ❌ Rule Inputs in Mockups - Common Mistake"`
- **"Constant not found"** → `"## ⚠️ IMPORTANT: Handling Non-Existent Constants"`
- **"Type mismatch" with contains/wherecontains** → `/logic-guidelines/array-type-initialization-guidelines.md`
- **"List of Variant" errors** → `/logic-guidelines/array-type-initialization-guidelines.md`
- **"tostring() returned single string"** → Use `touniformstring()` - see `/logic-guidelines/array-type-initialization-guidelines.md`
- **Null reference errors** → `/logic-guidelines/null-safety-quick-ref.md`
- **Short-circuit evaluation errors** → `/logic-guidelines/short-circuit-evaluation.md`
- **Syntax errors (and/or, if)** → `"## ⚠️ Language-Specific Syntax Patterns"`
- **Grid selection not working** → `/logic-guidelines/grid-selection-patterns.md`
- **Type mismatch: Cannot index property** → `/logic-guidelines/grid-selection-patterns.md` (Anti-Patterns)
- **DateTime vs Date mismatch** → `/logic-guidelines/datetime-handling.md`
- **Checkbox initialization errors** → `/logic-guidelines/checkbox-patterns.md`

### Validation & Troubleshooting:
- **Quick troubleshooting guide** → `"## 🔧 Quick Troubleshooting"`
- **Final validation checklist** → `"## Syntax Validation Checklist"`
- **Essential functions reference** → `/logic-guidelines/functions-reference.md`

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
8. **MOCKUPS NEVER use rule inputs (ri!)** - See `/logic-guidelines/local-variable-patterns.md` for mockup vs functional differences
9. **Local variables serve different purposes in mockup vs functional** - See `/logic-guidelines/local-variable-patterns.md`
10. **Always try to use record types for read-only grids and charts** instead of mock data when possible
11. **Empty arrays MUST be type-initialized for primitive types** - Use type-casting functions to avoid Variant list errors
    - `tointeger({})` for ID arrays, counts, numeric selections
    - `touniformstring({})` for name arrays, labels, text selections ⚠️ NOT tostring()!
    - `toboolean({})` for flag arrays, boolean selections
    - `todate({})` for date arrays, date range filters
    - `todatetime({})` for timestamp arrays
    - `todecimal({})` for currency, percentages, precise numeric arrays
    - `totime({})` for time-only values
    - `touser({})` for user reference arrays
    - `togroup({})` for group reference arrays
    - **CRITICAL:** `tostring()` merges arrays to single string; use `touniformstring()` to preserve array structure
    - See `/logic-guidelines/array-type-initialization-guidelines.md` for complete reference

## ❌ Rule Inputs in Mockups - Common Mistake

**MOCKUPS = local variables ONLY**

See `/logic-guidelines/local-variable-patterns.md` for:
- Complete rules on mockup vs functional variable usage
- When to use `local!` vs `ri!`
- Data modeling patterns (entity data, reference data, UI state)

## Essential SAIL Structure

See `/logic-guidelines/local-variable-patterns.md` for complete local variable patterns including:
- Declaration syntax (with/without initial values)
- Initialization rules by scenario
- Scope rules for nested contexts
- Data modeling philosophy (maps vs separate variables)

**Quick reference:**
- **With initial values**: `local!variable: value`
- **Without initial values**: `local!variable` (no null/empty placeholders)
- **For dropdowns**: Initialize to valid `choiceValue` OR use `placeholder`
- **For booleans**: Always explicit: `true()` or `false()`

## 📝 Unused Variables in Mockups

❌ **Mockups should not have unused variables.** They should be lean and self-contained. If you have unused variables:
- **Remove them** (they add confusion), or
- **Use them** to demonstrate a pattern

For production interfaces with justified unused variables, see the "Documenting Unused Local Variables" section in `record-query-guidelines/RECORD-QUERY-PRIMARY-REFERENCE.md`.

## 📋 Requirement-Driven Documentation Pattern

When generating SAIL interfaces from requirements, add structured comments that capture business logic, validation rules, and design decisions. This creates self-documenting code that helps developers understand the "why" behind implementation choices.

### Three-Tier Comment Structure

**1. Interface-level header** - Overall purpose and key requirements
**2. Section-level comments** - Business purpose + field requirements
**3. Inline comments** - Complex logic explanation (validations, calculations, conditionals)

### ✅ CORRECT Pattern - Documented Interface

```sail
a!localVariables(
  /*
   * BOARD/COMMITTEE SUBMISSION FORM
   *
   * Purpose: Capture partner memberships on external boards/committees
   *
   * Key Requirements:
   * - Auto-populate partner info from logged-in user (read-only)
   * - Validate end date > start date
   * - Support create/edit modes with same interface
   * - Position types sourced from reference data lookup
   */

  local!organizationName,
  local!organizationType,
  local!positionType,
  local!startDate,
  local!endDate,
  local!partnerName: user(loggedinuser(), "displayName"),

  a!formLayout(
    contents: {
      /*
       * ORGANIZATION INFORMATION
       * Requirement: Capture organization details where partner serves
       * Fields:
       * - Organization Name (required, manual entry)
       * - Organization Type (optional, manual entry, examples: Non-Profit, For-Profit, Government)
       * - Organization Description (optional, free text)
       */
      a!cardLayout(
        contents: {
          a!sectionLayout(
            label: "Organization Information",
            labelColor: "STANDARD",
            contents: {
              a!textField(
                label: "Organization Name",
                value: local!organizationName,
                saveInto: local!organizationName,
                required: true(),
                placeholder: "Enter the organization name"
              ),
              a!textField(
                label: "Organization Type",
                value: local!organizationType,
                saveInto: local!organizationType,
                placeholder: "e.g., Non-Profit, For-Profit, Government, etc."
              )
            }
          )
        },
        style: "#FFFFFF",
        shape: "ROUNDED",
        showBorder: true,
        showShadow: false,
        marginBelow: "STANDARD"
      ),

      /*
       * MEMBERSHIP DETAILS
       * Requirement: Track membership dates and validate date logic
       * Fields:
       * - Position/Role (required, dropdown from reference data)
       * - Start Date (required, manual entry)
       * - End Date (optional, must be after start date if provided)
       * Validation: End date > start date
       */
      a!cardLayout(
        contents: {
          a!sectionLayout(
            label: "Membership Details",
            labelColor: "STANDARD",
            contents: {
              a!dropdownField(
                label: "Position/Role on Board or Committee",
                choiceLabels: {"Board Member", "Committee Chair", "Advisor"},
                choiceValues: {"MEMBER", "CHAIR", "ADVISOR"},
                value: local!positionType,
                saveInto: local!positionType,
                required: true(),
                placeholder: "Select a position/role"
              ),
              a!dateField(
                label: "Membership Start Date",
                value: local!startDate,
                saveInto: local!startDate,
                required: true()
              ),
              a!dateField(
                label: "Membership End Date",
                value: local!endDate,
                saveInto: local!endDate,
                helpTooltip: "Leave blank if membership is still active",
                /* Requirement: Validate end date > start date when both are provided */
                validations: if(
                  and(
                    a!isNotNullOrEmpty(local!startDate),
                    a!isNotNullOrEmpty(local!endDate),
                    local!endDate <= local!startDate
                  ),
                  "Membership End Date must be after Membership Start Date",
                  {}
                )
              )
            }
          )
        },
        style: "#FFFFFF",
        shape: "ROUNDED",
        showBorder: true,
        showShadow: false,
        marginBelow: "STANDARD"
      ),

      /*
       * PARTNER INFORMATION
       * Requirement: Auto-populate from logged-in user profile (all read-only)
       * Fields:
       * - Partner Name (displayName from user profile)
       * - Partner ID (username from user profile)
       * - Business Unit (from HR/Workday integration - placeholder for now)
       */
      a!cardLayout(
        contents: {
          a!sectionLayout(
            label: "Partner Information",
            labelColor: "STANDARD",
            contents: {
              a!textField(
                label: "Partner Name",
                /* Requirement: Auto-populate displayName from logged-in user */
                value: user(loggedinuser(), "displayName"),
                saveInto: {},
                readOnly: true(),
                helpTooltip: "Auto-populated from user profile"
              ),
              a!textField(
                label: "Partner ID",
                /* Requirement: Auto-populate username from logged-in user */
                value: user(loggedinuser(), "username"),
                saveInto: {},
                readOnly: true(),
                helpTooltip: "Auto-populated from user profile"
              ),
              a!textField(
                label: "Group/Business Unit",
                /* Requirement: Would be auto-populated from HR feed/Workday integration */
                value: "Business Unit TBD",
                saveInto: {},
                readOnly: true(),
                helpTooltip: "Auto-populated from HR system integration"
              )
            }
          )
        },
        style: "#FFFFFF",
        shape: "ROUNDED",
        showBorder: true,
        showShadow: false
      )
    },
    buttons: a!buttonLayout(
      primaryButtons: {
        a!buttonWidget(
          label: "Submit",
          style: "SOLID",
          color: "ACCENT",
          submit: true()
        )
      },
      secondaryButtons: {
        a!buttonWidget(
          label: "Cancel",
          style: "LINK"
        )
      }
    )
  )
)
```

### Benefits of Requirement Comments

**1. Traceability**
- Links implementation directly back to requirements
- Easy to verify code matches business intent
- Audit trail for compliance and review

**2. Maintainability**
- Future developers understand "why" decisions were made
- Read-only fields documented with business justification
- Validation logic tied to specific requirements

**3. Onboarding**
- New team members can understand interfaces quickly
- Self-documenting code reduces questions
- Clear examples of common patterns

**4. Quality Assurance**
- QA can verify implementation against documented requirements
- Easier to catch scope drift or missing features
- Validation rules documented inline for testing

### Comment Format Guidelines

**Interface-level header:**
```sail
/*
 * [INTERFACE NAME/PURPOSE]
 *
 * Purpose: [Brief description of business purpose]
 *
 * Key Requirements:
 * - [Requirement 1]
 * - [Requirement 2]
 * - [Requirement 3]
 */
```

**Section-level comments:**
```sail
/*
 * [SECTION NAME]
 * Requirement: [Business purpose of this section]
 * Fields:
 * - Field 1 (attributes): Description
 * - Field 2 (attributes): Description
 * [Optional] Validation: [Validation rule description]
 */
```

**Inline comments:**
```sail
/* Requirement: [Specific requirement this line/block implements] */
value: someComplexLogic()
```

### Examples for Other Interface Types

**Dashboard/Grid Example:**
```sail
a!localVariables(
  /*
   * SALES DASHBOARD - REGIONAL PERFORMANCE
   *
   * Purpose: Display real-time sales metrics by region with drill-down capability
   *
   * Key Requirements:
   * - Show top 5 regions by revenue (query sorted descending)
   * - Color-code performance: Green >$1M, Yellow $500K-$1M, Red <$500K
   * - Filter by date range (default: current quarter)
   * - Click region to drill into rep-level details
   */

  /* Requirement: Default to current quarter for date filter */
  local!startDate: eomonth(today(), -3),
  local!endDate: today(),

  a!headerContentLayout(
    header: {
      /* KPI CARDS - Top-level metrics */
      a!cardLayout(
        contents: {
          /* Requirement: Color-code based on performance thresholds */
          a!gaugeField(
            percentage: if(
              local!revenue > 1000000,
              /* Green: Above $1M */,
              if(
                local!revenue > 500000,
                /* Yellow: $500K-$1M */,
                /* Red: Below $500K */
              )
            )
          )
        }
      )
    }
  )
)
```

**Chart Example:**
```sail
/*
 * REVENUE TREND CHART
 * Requirement: Show monthly revenue trend for last 12 months
 * Data Source: Sales record type aggregation by month
 * Interaction: Clicking a month filters detail grid below
 */
a!columnChartField(
  categories: local!monthLabels,
  series: {
    a!chartSeries(
      label: "Revenue",
      data: local!monthlyRevenue,
      /* Requirement: Highlight months below target in red */
      color: a!forEach(
        items: local!monthlyRevenue,
        expression: if(fv!item < 100000, "NEGATIVE", "ACCENT")
      )
    )
  }
)
```

### ❌ WRONG - No Documentation

```sail
a!localVariables(
  local!organizationName,
  local!startDate,
  local!endDate,

  a!formLayout(
    contents: {
      /* No context about why fields exist or their business purpose */
      a!cardLayout(
        contents: {
          a!sectionLayout(
            label: "Organization Information",
            contents: {
              a!textField(
                label: "Organization Name",
                value: local!organizationName,
                saveInto: local!organizationName,
                required: true()  /* Why required? No explanation */
              )
            }
          )
        }
      ),
      a!cardLayout(
        contents: {
          a!sectionLayout(
            label: "Partner Information",
            contents: {
              a!textField(
                label: "Partner Name",
                value: user(loggedinuser(), "displayName"),
                readOnly: true()  /* Why read-only? No explanation */
              )
            }
          )
        }
      )
    }
  )
)
```

**Problems with undocumented code:**
- ❌ No explanation for read-only fields
- ❌ Validation logic appears arbitrary
- ❌ Cannot verify implementation matches requirements
- ❌ Hard to onboard new developers
- ❌ Difficult to maintain over time

### When to Add Requirement Comments

**Always add comments for:**
- ✅ Read-only or disabled fields (explain why)
- ✅ Complex validation logic (reference requirement)
- ✅ Auto-populated fields (explain data source)
- ✅ Conditional visibility (explain business rule)
- ✅ Calculations and derived values (explain formula)
- ✅ Non-obvious placeholder values (explain future integration)

**Optional for:**
- Simple, self-explanatory fields (name, email, etc.)
- Standard UI patterns with no special logic
- Obvious relationships (save button submits form)

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

## ⚠️ INTERNATIONALIZATION IN APPIAN INTERFACES

### Appian's Built-In Internationalization

Appian handles internationalization automatically through:
- **Locale detection** from user preferences (no manual detection needed)
- **Translation sets** containing strings in multiple languages
- **Automatic language switching** based on user's configured locale

### ❌ WRONG - Manual Language Toggle in Mockups

**DO NOT implement manual language selection in mockups:**

```sail
/* ❌ DON'T DO THIS - Manual language switching */
local!currentLanguage: "en",  /* Appian handles this automatically */

a!buttonArrayLayout(
  buttons: {
    a!buttonWidget(
      label: "English",
      saveInto: a!save(local!currentLanguage, "en")  /* NOT NEEDED */
    ),
    a!buttonWidget(
      label: "Español",
      saveInto: a!save(local!currentLanguage, "es")  /* NOT NEEDED */
    )
  }
)

/* ❌ DON'T: Inline conditional translations */
a!textField(
  label: if(
    local!currentLanguage = "es",
    "Nombre",
    "First Name"
  ),  /* Creates code bloat and maintenance burden */
  value: local!firstName,
  saveInto: local!firstName
)
```

**Problems with manual approach:**
1. Code bloat - Every text label requires conditional logic
2. Maintenance burden - Adding a language means updating every conditional
3. No centralized translation management
4. Inconsistent translations across the application
5. Doesn't follow Appian best practices

### ✅ CORRECT - Use English Text in Mockups

**Write all UI text in English - production will use translation sets:**

```sail
/* ✅ DO THIS - English text only */
a!textField(
  label: "First Name",  /* TODO: Replace with translation set reference in production */
  value: local!firstName,
  saveInto: local!firstName
)

a!buttonWidget(
  label: "Submit Application",  /* TODO: Use translation set in production */
  style: "SOLID",
  saveInto: {}
)

a!richTextDisplayField(
  labelPosition: "COLLAPSED",
  value: a!richTextItem(
    text: "Welcome to the Dashboard",  /* TODO: Translation set reference needed */
    size: "LARGE",
    style: "STRONG"
  )
)
```

### Best Practices for Production-Ready Code

In production implementations:
1. **Reference translation sets** instead of hardcoded strings
2. **Use the user's locale** (automatic - no code needed)
3. **No language toggle buttons** required
4. **Centralize translations** in translation set objects

### Comment Pattern for Mockups

```sail
/* All user-facing text should include TODO comments */
label: "Application Status",  /* TODO: Replace with translation set in production */
```

## 🚨 CRITICAL: a!forEach() Function Variables Reference

> **📖 Complete Guide:** `/logic-guidelines/foreach-patterns.md`

### Available Function Variables (Quick Reference)

| Variable | Description | Use For |
|----------|-------------|---------|
| `fv!item` | Current item value | Accessing properties (`.title`), scalar values |
| `fv!index` | Position (1-based) | Array manipulation, numbering, remove buttons |
| `fv!isFirst` | `true` on first iteration | Conditional headers, skip first divider |
| `fv!isLast` | `true` on last iteration | Conditional footers, "Add" buttons after last item |
| `fv!itemCount` | Total items in array | Progress indicators, conditional logic |

**⚠️ CRITICAL:** These variables are **ONLY** available inside `a!forEach()` expressions. They do NOT exist in grid columns or chart configurations.

**Common pattern examples:**
```sail
/* Remove button using fv!index */
saveInto: a!save(local!items, remove(local!items, fv!index))

/* Progress indicator using fv!index and fv!itemCount */
text: "Processing " & fv!index & " of " & fv!itemCount
```

**See `/logic-guidelines/foreach-patterns.md` for:**
- Pattern A: Array of Maps (multi-instance data entry)
- Pattern B: Parallel Arrays (fixed source lists)
- Complete examples for all 5 function variables
- Direct property saving patterns
- Best practices and common mistakes


## ⚠️ CRITICAL: Direct Property Saving and Parallel Arrays

> **📖 Complete Guide:** `/logic-guidelines/foreach-patterns.md`

**Two patterns for forEach with input fields:**

### Pattern A: Direct Property Save (Array of Maps - PREFERRED)
Use for multi-instance data entry (contacts, work history, line items):

```sail
/* ✅ CORRECT - Save directly to property */
saveInto: fv!item.employerName  /* Updates just this property in the map */

/* ❌ WRONG - Don't reconstruct entire map */
saveInto: a!save(local!array, a!update(local!array, fv!index, a!map(...all fields...)))
```

### Pattern B: Parallel Arrays (Fixed Source Lists)
Use when iterating a fixed source list to collect separate data (document checklist):

```sail
/* ✅ CORRECT - Index-based save */
value: index(local!uploadedFiles, fv!index, null)
saveInto: a!save(local!uploadedFiles, a!update(local!uploadedFiles, fv!index, save!value))

/* ⚠️ Type Safety: Wrap index() in type converters for arithmetic */
todate(index(local!dates, fv!index, today()))  /* For date arithmetic */
```

**See `/logic-guidelines/foreach-patterns.md` for:**
- Complete decision tree: When to use Pattern A vs Pattern B
- Multi-save pattern for dependent calculations
- Type safety rules for index() in arithmetic operations
- Complete examples and anti-patterns


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

### Using a!match() for Status-Based Lookups {#amatch-status-lookups}

> **📖 Complete Guide:** `/logic-guidelines/pattern-matching.md` (includes `whenTrue` for ranges/thresholds)
> **This section:** Covers `equals` pattern only

**When to use `a!match()` instead of parallel arrays:**
- Single value compared against multiple options (status, category, priority, etc.)
- Cleaner and more maintainable than nested `if()` statements
- Short-circuits like `if()` - safe for conditional logic

**Pattern: Status to Icon/Color Mapping**
```sail
/* ❌ OLD PATTERN - Parallel arrays with wherecontains */
local!statuses: {"Open", "In Progress", "Completed", "Cancelled"},
local!icons: {"folder-open", "clock", "check-circle", "times-circle"},
local!colors: {"#3B82F6", "#F59E0B", "#10B981", "#EF4444"},

local!icon: index(
  local!icons,
  wherecontains(fv!item.status, local!statuses),
  "file"
)

/* ✅ NEW PATTERN - a!match() (cleaner, more readable) */
local!icon: a!match(
  value: fv!item.status,
  equals: "Open",
  then: "folder-open",
  equals: "In Progress",
  then: "clock",
  equals: "Completed",
  then: "check-circle",
  equals: "Cancelled",
  then: "times-circle",
  default: "file"
)
```

**Pattern: Dynamic Styling with a!match()**
```sail
/* Stamp field with status-based colors */
a!stampField(
  icon: a!match(
    value: fv!item.priority,
    equals: "Critical",
    then: "exclamation-triangle",
    equals: "High",
    then: "arrow-up",
    equals: "Medium",
    then: "minus",
    equals: "Low",
    then: "arrow-down",
    default: "info-circle"
  ),
  backgroundColor: a!match(
    value: fv!item.priority,
    equals: "Critical",
    then: "#DC2626",
    equals: "High",
    then: "#F59E0B",
    equals: "Medium",
    then: "#3B82F6",
    equals: "Low",
    then: "#6B7280",
    default: "#9CA3AF"
  ),
  contentColor: "#FFFFFF",
  size: "TINY",
  shape: "ROUNDED",
  labelPosition: "COLLAPSED"
)
```

**Pattern: Grid Column Conditional Background Colors**
```sail
a!gridField(
  data: local!tasks,
  columns: {
    a!gridColumn(
      label: "Status",
      value: fv!row.status,
      backgroundColor: a!match(
        value: fv!row.status,
        equals: "Completed",
        then: "#D1FAE5",
        equals: "In Progress",
        then: "#FEF3C7",
        equals: "Blocked",
        then: "#FEE2E2",
        default: "TRANSPARENT"
      )
    )
  }
)
```

**When to Keep Parallel Arrays:**
- Need to iterate over all statuses/options (e.g., generate filter options)
- Building dropdown choices programmatically
- Multiple lookups from the same set of values
- Need the arrays themselves for other logic

### ✅ Best Practice: PREFER a!match() Over Nested if()

**When you have a single value to compare against 3+ options, ALWAYS use `a!match()` instead of nested `if()` statements.**

#### Comparison: Nested if() vs a!match()

**❌ AVOID - Nested if() (Hard to Read, Error-Prone):**
```sail
backgroundColor: if(
  statusCode = "INTEGRATED",
  "POSITIVE",
  if(
    or(statusCode = "SUBMITTED", statusCode = "VALIDATED"),
    "ACCENT",
    if(
      statusCode = "DRAFT",
      "#F59E0B",
      "SECONDARY"
    )
  )
)
```

**Problems:**
- Deeply nested parentheses (easy to mismatch)
- Hard to scan visually
- Difficult to add/remove cases
- More error-prone during edits

**✅ PREFER - a!match() (Clean, Maintainable):**
```sail
backgroundColor: a!match(
  value: statusCode,
  equals: "INTEGRATED", then: "POSITIVE",
  equals: "SUBMITTED", then: "ACCENT",
  equals: "VALIDATED", then: "ACCENT",
  equals: "DRAFT", then: "#F59E0B",
  default: "SECONDARY"
)
```

**Benefits:**
- Flat structure - no nesting hell
- Clear value→result mapping
- Easy to add/remove cases
- Self-documenting code
- Less error-prone

#### When to Use a!match():
- ✅ **Single variable** compared against 3+ possible values
- ✅ **Enumerated values**: status codes, categories, priority levels, types
- ✅ **Display logic**: colors, icons, labels based on a single field
- ✅ **Anywhere nested if() would have 3+ levels**

#### When Nested if() is Still Needed:
- Multiple different variables in the condition
- Complex boolean expressions (not just equality checks)
- Computed logic that can't be reduced to pattern matching

**Example - Multiple Variables (Use if()):**
```sail
showWhen: if(
  and(local!userRole = "Manager", local!department = "Sales"),
  local!salesAmount > 10000,
  false
)
```
This checks TWO variables with AND logic - can't use `a!match()`.

#### MANDATORY: Use a!match() for These Common Cases:
1. **Status-based colors/icons** (Open, Closed, Pending, etc.)
2. **Priority levels** (Low, Medium, High, Critical)
3. **Category mappings** (Type A→Icon 1, Type B→Icon 2, etc.)
4. **Approval states** (Draft, Submitted, Approved, Rejected)
5. **Any enumerated field with 3+ possible values**

**⚠️ For numeric ranges and thresholds:** See `/logic-guidelines/pattern-matching.md` for `whenTrue` pattern (e.g., performance >= 110, scores >= 90, date ranges)

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

### 🚨 CRITICAL: Short-Circuit Evaluation Rules {#short-circuit-rules}

> **📖 Complete Guide:** `/logic-guidelines/short-circuit-evaluation.md`
> **🔗 Quick Reference:** `/logic-guidelines/null-safety-quick-ref.md`

**Core Rule:** SAIL's `and()` and `or()` functions DO NOT short-circuit - they evaluate ALL arguments. Use nested `if()` for null-safe property access.

```sail
/* ❌ WRONG - and() evaluates both conditions even if first is false */
and(a!isNotNullOrEmpty(local!data), local!data.type = "Contract")  /* CRASHES if empty! */

/* ✅ CORRECT - if() short-circuits, only evaluates matched branch */
if(if(a!isNotNullOrEmpty(local!data), local!data.type = "Contract", false), ...)
```

**See `/logic-guidelines/short-circuit-evaluation.md` for:**
- Complete explanation of why and() doesn't short-circuit
- When to use nested if() vs and()
- Common scenarios requiring nested if() (grid selections, array access, filtered arrays)
- Quick reference table of all short-circuit behaviors

## 🚨 MANDATORY: Null Safety Implementation {#null-safety-implementation}

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
- **Logical operators**: `not()` - Cannot accept null value

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

#### Special Case: not() with Variables and Rule Inputs

**The `not()` function cannot accept null. When using `not()` with variables or rule inputs that might be null, use `a!defaultValue()` to provide a fallback:**

```sail
/* ❌ WRONG - Direct use of not() with potentially null value */
readOnly: not(ri!isEditable)  /* Fails if ri!isEditable is null */
disabled: not(local!allowEdits)  /* Fails if local!allowEdits is null */

/* ✅ CORRECT - Use a!defaultValue() to provide fallback */
readOnly: not(a!defaultValue(ri!isEditable, false()))  /* Returns true if null */
disabled: not(a!defaultValue(local!allowEdits, false()))  /* Returns true if null */

/* ✅ ALTERNATIVE - Use if() to check for null first */
readOnly: if(
  a!isNullOrEmpty(ri!isEditable),
  true(),  /* Default to read-only if null */
  not(ri!isEditable)
)
```

**Common scenarios requiring null protection:**
- `readOnly: not(ri!isEditable)` → Use `not(a!defaultValue(ri!isEditable, false()))`
- `disabled: not(local!allowEdits)` → Use `not(a!defaultValue(local!allowEdits, false()))`
- `showWhen: not(local!isHidden)` → Use `not(a!defaultValue(local!isHidden, false()))`

**Best Practice**: Always wrap rule inputs and variables in `a!defaultValue()` before passing to `not()`. Choose the default value (`true()` or `false()`) based on the desired behavior when the value is null.

### 🚨 CRITICAL: Null Safety for Computed Variables

**Computed variables that derive from empty arrays require special null checking with nested if() statements.**

**⚠️ IMPORTANT:** SAIL's `and()` and `or()` functions **DO NOT short-circuit**. For detailed explanation and examples of short-circuit evaluation, see the **"🚨 CRITICAL: Short-Circuit Evaluation Rules"** section (#short-circuit-rules).

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

## ⚠️ CRITICAL: Checkbox Field Patterns

> **📖 Complete Guide:** `/logic-guidelines/checkbox-patterns.md`

**Core Rules:**
- ✅ Multi-select → Single array variable (NOT separate booleans)
- ✅ Single checkbox → Initialize to `null` (NOT `false`)
- ✅ Use `contains()` to check specific selections
- ❌ NEVER use `a!flatten()` to reconstruct arrays from booleans

```sail
/* Multi-select pattern */
local!selectedPriorities: {},  /* Single array */
value: local!selectedPriorities, saveInto: local!selectedPriorities

/* Single checkbox initialization */
local!agreeToTerms,  /* null by default, NOT false */
choiceValues: {true}
```

**See `/logic-guidelines/checkbox-patterns.md` for:**
- Complete multi-select vs single checkbox patterns
- Why separate boolean variables fail
- Null initialization requirements
- save!value usage rules
- Common mistakes and fixes

## 🚨 MANDATORY: Grid Selection Patterns

> **📖 Complete Guide:** `/logic-guidelines/grid-selection-patterns.md`

**Critical Understanding:** Grid `selectionValue` stores **ONLY identifiers** (Integer/Text Array), NOT full row objects.

### MANDATORY: Two-Variable Approach

**Pattern:**
```sail
/* Variable 1: ID array with clear naming */
local!selectedCaseIds: {},  /* Suffix: Ids, Keys, or Indexes */

/* Variable 2: Computed - derives full data from IDs */
local!selectedCases: a!forEach(
  items: local!selectedCaseIds,
  expression: index(local!allCases, wherecontains(fv!item, local!allCases.id), null)
)

/* Grid uses ID variable */
selectionValue: local!selectedCaseIds,
selectionSaveInto: local!selectedCaseIds

/* Property access uses computed variable ONLY */
showWhen: if(
  a!isNotNullOrEmpty(local!selectedCases),
  contains(local!selectedCases.type, "Contract"),
  false
)
```

**Key Rules:**
1. ✅ **TWO variables**: ID array (with suffix) + computed variable (full data)
2. ✅ **Naming**: Use `Ids`/`Keys`/`Indexes` suffix for ID arrays
3. ✅ **Grid config**: Use ID variable in `selectionValue`/`selectionSaveInto`
4. ✅ **Property access**: ONLY on computed variable, NEVER on ID array
5. ✅ **Null safety**: Use nested if() before property access on computed variable

**See `/logic-guidelines/grid-selection-patterns.md` for:**
- Complete two-variable implementation steps
- Naming convention enforcement checklist
- Common anti-patterns and fixes
- Complete working examples

## Date/Time Critical Rules

> **📖 Complete Guide:** `/logic-guidelines/datetime-handling.md`

**Core Rules:**
- ✅ Use `dateTime()` for specific date/time creation (NOT `a!dateTimeValue()`)
- ✅ Cast date arithmetic with `todate()` in sample data
- ✅ Date/DateTime arithmetic returns Intervals → use `tointeger()` for comparisons
- ✅ Match field type to filter function (`today()` for Date, `now()` for DateTime)

```sail
/* Date field */
todate(today() + 1)  /* Cast arithmetic */

/* DateTime field */
a!subtractDateTime(startDateTime: now(), days: 30)

/* Interval to Integer */
tointeger(now() - timestamp) < 1
```

**See `/logic-guidelines/datetime-handling.md` for:**
- Complete type-specific functions (Date, DateTime, Time)
- Query filter type matching rules
- min()/max() return type casting
- Null-safe text() formatting

## Chart Data Configuration

> **📖 Complete Guide:** `/logic-guidelines/chart-configuration.md`

**Core Rules:**
- ✅ Use `categories` + `series` for mock data charts (column, line, bar, area, pie)
- ✅ `stacking` property exists ONLY on: area, bar, column charts (NOT pie/line)
- ❌ Charts are display-only - cannot extract data from them
- ❌ NEVER use scatter charts with static mockup data

```sail
/* Mock data pattern */
a!columnChartField(
  categories: {"Q1", "Q2", "Q3"},
  series: {a!chartSeries(label: "Sales", data: {100, 120, 115})},
  stacking: "NORMAL"  /* Only on area/bar/column */
)
```

**See `/logic-guidelines/chart-configuration.md` for:**
- All chart types and their parameters
- Multi-series patterns
- Height values by chart type
- Complete examples

---

## Validation Checklist

### Grid Selection Pattern (Mock Data)
- [ ] **Two-variable approach implemented** (see Grid Selection Patterns)
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
