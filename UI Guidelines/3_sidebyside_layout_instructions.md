# SAIL SideBySideLayout Usage Instructions

## Overview
SideBySideLayout is used for arranging components (not other layouts) horizontally within a content area. It's designed for grouping related content elements together, **NOT** for main page structure.

## MOST IMPORTANT VALIDATION RULE: *NEVER* nest SideBySideLayouts in other SideBySideLayouts
- If you encounter this situation, STOP. Reconsider how to achieve the layout with individual sideBySideItems inside one sideBySideLayout, or use a columnsLayout instead.

## When to Use SideBySideLayout vs ColumnsLayout

### Use SideBySideLayout for:
- Arranging components within a content block
- Putting an icon next to text
- Aligning a stamp with a description
- Grouping small related UI elements like a tag and rich text
- Content that should flow together naturally

### Use ColumnsLayout for:
- Main page structure and layout
- Creating content sections with margins
- Dashboard layouts with multiple content areas
- Any complex nested layouts

## Critical Restrictions

### ❌ NEVER DO:
```sail
a!sideBySideItem(
  item: a!sideBySideLayout(...)  // NO NESTED sideBySideLayouts
)

a!sideBySideItem(
  item: a!cardLayout(...)  // NO LAYOUTS IN sideBySideItems
)

a!sideBySideItem(
  item: {a!textField(...), a!button(...)}  // NO ARRAYS IN sideBySideItems  
)

a!gridField(
  columns: {
    a!gridColumn( // NO SIDE BY SIDE LAYOUTS IN GRID COLUMNS
      value: a!sideBySideLayout(...)
    )
  }
)
```

### ✅ ALWAYS DO:
```sail
a!sideBySideItem(
  item: a!richTextDisplayField(...)  // SINGLE COMPONENT ONLY
)
```

## Width Types

### Width Options
- `MINIMIZE`: Shrink to fit content width (like flex: 0)
- `AUTO`: Fill remaining horizontal space (default)
- `1X` through `10X`: Proportional widths

### Width Selection Guide
- **Icons/stamps**: `MINIMIZE`
- **Labels/short text**: `MINIMIZE` 
- **Main content**: `AUTO`
- **Equal columns**: `1X`, `2X`, etc.

## Vertical Alignment Options
- `TOP`: Align to top (default)
- `MIDDLE`: Center vertically  
- `BOTTOM`: Align to bottom

## Common Patterns

### 1. Icon with Text
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: a!richTextDisplayField(
        value: a!richTextIcon(icon: "check", color: "POSITIVE")
      ),
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: a!richTextDisplayField(
        value: "Task completed successfully"
      ),
      width: "AUTO"
    )
  },
  alignVertical: "MIDDLE"
)
```

### 2. Stamp with Description
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: a!stampField(
        icon: "user",
        backgroundColor: "ACCENT",
        size: "SMALL"
      ),
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: a!richTextDisplayField(
        value: {
          a!richTextItem(text: "John Doe", style: "STRONG"),
          char(10),
          "Software Engineer"
        }
      ),
      width: "AUTO"
    )
  },
  alignVertical: "MIDDLE"
)
```

### 3. Label and Value Pairs
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: a!richTextDisplayField(
        value: a!richTextItem(text: "Status:", style: "STRONG")
      ),
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: a!tagField(
        tags: a!tagItem(text: "Active", backgroundColor: "POSITIVE")
      ),
      width: "AUTO"
    )
  },
  alignVertical: "MIDDLE",
  spacing: "STANDARD"
)
```

### 4. Proportional Field Widths
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: a!textField(label: "First Name", value: local!firstName),
      width: "3X"
    ),
    a!sideBySideItem(
      item: a!textField(label: "M.I.", value: local!middleInitial),
      width: "1X"
    ),
    a!sideBySideItem(
      item: a!textField(label: "Last Name", value: local!lastName),
      width: "3X"
    )
  }
)
```

### 5. Title and Tag Pair
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: a!richTextDisplayField(
        labelPosition: "COLLAPSED",
        value: {
          a!richTextItem(
            text: {
              "Review Expense Report"
            },
            size: "MEDIUM",
            style: {
              "STRONG"
            }
          )
        }
      )
    ),
    a!sideBySideItem(
      item: a!tagField(
        labelPosition: "COLLAPSED",
        tags: {
          a!tagItem(
            text: "OVERDUE",
            backgroundColor: "NEGATIVE"
          )
        }
      ),
      width: "MINIMIZE"
    )
  },
  alignVertical: "MIDDLE"
)
```

## Converting from Tailwind CSS to SAIL SideBySide

### Tailwind Flex with Items
```css
/* Tailwind CSS */
.flex .items-center .space-x-2
```

**Converts to SAIL:**
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: /* first component */,
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: /* second component */,
      width: "AUTO"
    )
  },
  alignVertical: "MIDDLE",
  spacing: "STANDARD"
)
```

### Tailwind Flex with Grow
```css
/* Tailwind CSS */
.flex .flex-none .flex-grow
```

**Converts to SAIL:**
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: /* fixed width component */,
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: /* growing component */,
      width: "AUTO"
    )
  }
)
```

### Tailwind Equal Width Flex
```css
/* Tailwind CSS */
.flex .flex-1 .flex-1
```

**Converts to SAIL:**
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: /* first component */,
      width: "1X"
    ),
    a!sideBySideItem(
      item: /* second component */,
      width: "1X"
    )
  }
)
```

### Tailwind Flex with Justify Between
```css
/* Tailwind CSS */
.flex .justify-between .items-center
```

**Converts to SAIL:**
```sail
a!sideBySideLayout(
  items: {
    a!sideBySideItem(
      item: /* left component */,
      width: "MINIMIZE"
    ),
    a!sideBySideItem(
      item: /* spacer - omit item */,
      width: "AUTO"
    ),
    a!sideBySideItem(
      item: /* right component */,
      width: "MINIMIZE"
    )
  },
  alignVertical: "MIDDLE"
)
```

## Complex Example: Converting a Tailwind Card Header

**Tailwind CSS:**
```html
<div class="flex items-center justify-between p-4">
  <div class="flex items-center space-x-3">
    <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
      <svg class="w-5 h-5 text-white">...</svg>
    </div>
    <div>
      <h3 class="font-semibold">John Doe</h3>
      <p class="text-sm text-gray-500">Online</p>
    </div>
  </div>
  <button class="text-gray-400 hover:text-gray-600">
    <svg class="w-5 h-5">...</svg>
  </button>
</div>
```

**SAIL Equivalent:**
```sail
a!sideBySideLayout(
items: {
    a!sideBySideItem(
    item: a!stampField(
        icon: "user",
        backgroundColor: "#3B82F6",
        contentColor: "STANDARD",
        size: "TINY"
    ),
    width: "MINIMIZE"
    ),
    a!sideBySideItem(
    item: a!richTextDisplayField(
        value: {
        a!richTextItem(text: "John Doe", style: "STRONG"),
        char(10),
        a!richTextItem(
            text: "Online",
            color: "SECONDARY",
            size: "SMALL"
        )
        }
    ),
    width: "AUTO"
    ),
    a!sideBySideItem(
    item: a!buttonArrayLayout(
        buttons: {
        a!buttonWidget(
            icon: "ellipsis-h",
            style: "LINK",
            color: "SECONDARY"
        )
        }
    ),
    width: "MINIMIZE"
    )
},
alignVertical: "MIDDLE",
spacing: "STANDARD"
)
```

## Best Practices

### ✅ DO:
- Use for component-level arrangements
- Keep it simple - avoid nesting
- Use appropriate vertical alignment
- Choose width types based on content needs
- Use spacing parameter for consistent gaps

### ❌ DON'T:
- Put layouts inside sideBySideItems
- Use for main page structure
- Nest sideBySideLayouts
- Put multiple components in one sideBySideItem
- Use when columnsLayout would be more appropriate

## When to Choose Alternative Approaches

### Use ColumnsLayout instead when:
- Creating main page structure
- Need margins around content
- Need fixed-width columns
- Need nesting of columnar layouts


## MANDATORY VALIDATION CHECKLIST
- [ ] ⚠️⚠️⚠️ `spacing` is `STANDARD`, `NONE`, `SPARSE`, or `DENSE`
- [ ] ❌ DON'T USE `less` or `more` for `spacing`!
- [ ] Only one component in each `sideBySideItem` (no lists)
- [ ] No layouts in `sideBySideItem`
- [ ] No nested sideBySideLayouts