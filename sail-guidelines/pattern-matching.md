# Pattern Matching with a!match() {#pattern-matching}

> **Parent guide:** `dynamic-sail-expression-guidelines.md`
>
> **Related:**
> - `sail-guidelines/short-circuit-evaluation.md` (short-circuit rules)
> - `sail-guidelines/functions-reference.md` (function reference)

---

## Using a!match() for Status-Based Lookups {#amatch-status-lookups}

**When to use `a!match()` instead of parallel arrays:**
- Single value compared against multiple options (status, category, priority, etc.)
- Cleaner and more maintainable than nested `if()` statements
- Short-circuits like `if()` - safe for conditional logic

---

## Pattern: Status to Icon/Color Mapping

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

---

## Pattern: Dynamic Styling with a!match()

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

---

## Pattern: Grid Column Conditional Background Colors

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

---

## When to Keep Parallel Arrays

- Need to iterate over all statuses/options (e.g., generate filter options)
- Building dropdown choices programmatically
- Multiple lookups from the same set of values
- Need the arrays themselves for other logic

---

## ✅ Best Practice: PREFER a!match() Over Nested if()

**When you have a single value to compare against 3+ options, ALWAYS use `a!match()` instead of nested `if()` statements.**

### Comparison: Nested if() vs a!match()

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

---

## When to Use a!match()

- ✅ **Single variable** compared against 3+ possible values
- ✅ **Enumerated values**: status codes, categories, priority levels, types
- ✅ **Display logic**: colors, icons, labels based on a single field
- ✅ **Anywhere nested if() would have 3+ levels**

---

## When Nested if() is Still Needed

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

---

## MANDATORY: Use a!match() for These Common Cases

1. **Status-based colors/icons** (Open, Closed, Pending, etc.)
2. **Priority levels** (Low, Medium, High, Critical)
3. **Category mappings** (Type A→Icon 1, Type B→Icon 2, etc.)
4. **Approval states** (Draft, Submitted, Approved, Rejected)
5. **Any enumerated field with 3+ possible values**

---

## Short-Circuit Behavior

`a!match()` short-circuits like `if()` - it only evaluates the matched branch:

| Function | Short-Circuits? | Use For |
|----------|----------------|---------|
| `if()` | ✅ Yes - Only evaluates returned branch | Null-safe property access, conditional logic, binary conditions |
| `and()` | ❌ No - Evaluates all arguments | Independent boolean conditions only (never for null safety) |
| `or()` | ❌ No - Evaluates all arguments | Independent boolean conditions only (never for null safety) |
| `a!match()` | ✅ Yes - Only evaluates matched branch | Pattern matching - single value against 3+ options (status, category, priority) |

This makes `a!match()` safe for conditional logic where you need to avoid evaluating certain expressions.

---

## Best Practices Summary

### ✅ DO:
- **Use a!match()** for single value against 3+ options
- **Use for enumerated values** (status, category, priority, type)
- **Use for display logic** (colors, icons, labels)
- **Keep equals/then pairs on same line** for readability
- **Always provide a default** value

### ❌ DON'T:
- **Don't use nested if()** for simple pattern matching
- **Don't use for complex boolean logic** with multiple variables
- **Don't use for null-safe property access** (use nested if() instead)
- **Don't forget the default** value
