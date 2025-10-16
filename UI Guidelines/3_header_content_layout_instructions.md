# SAIL HeaderContentLayout Usage Instructions

## Overview
HeaderContentLayout creates full-width (edge-to-edge) page layouts with an optional header section and main content area. It's one of the three top-level layout options in SAIL and is ideal for modern, full-bleed designs.

## When to Use HeaderContentLayout

### Use HeaderContentLayout for:
- Pages that need full-width headers (hero sections, banners)
- Modern designs with edge-to-edge content
- Pages with prominent visual headers (images, videos, graphics)
- Landing pages or marketing-style interfaces
- Any page where you want content to extend to screen edges
- Can be used for pages without headers (just leave header parameter empty)

### Use FormLayout instead for:
- Simple forms

### Use PaneLayout instead for:
- Multi-pane interfaces with independent scrolling
- Full-height layouts where panes fill the entire screen
- Applications requiring sidebar navigation

## Structure and Parameters

### Basic Structure
```sail
a!headerContentLayout(
  header: /* Billboard or card layouts or completely omit header */,
  contents: {
    /* Main page content - any layouts/components */
  }
)
```

### Key Parameters
- `header`: Billboard, card, or list of billboards/cards (can be empty)
- `contents`: Array of components and layouts for main content
- `backgroundColor`: Page background color
- `contentsPadding`: Space around the contents area
- `isHeaderFixed`: Whether header stays at top when scrolling

## backgroundColor Options
- `"WHITE"` (default): Standard white background
- `"TRANSPARENT"`: Light gray background
- Any valid hex color: `"#F5F5F5"`
- Recommended: `"#F5F6F8"`

## Contents Padding Options
- `"NONE"`: No padding around contents
- `"EVEN_LESS"`: Minimal padding
- `"LESS"`: Reduced padding
- `"STANDARD"` (default): Normal padding
- `"MORE"`: Increased padding
- `"EVEN_MORE"`: Maximum padding

## ⚠️ CRITICAL DECISION POINT: Header Contents

**Header is not needed for design:**
- Just exclude the `header` parameter

**Header must show an image or video as its background:**
- Use `billboardLayout` in `header`

**Default:**
- Use `cardLayout` in `header`

## Standard Template

Use this as a baseline for a standard page with title bar header:

```sail
a!headerContentLayout(
  header: {
    a!cardLayout(
      contents: {
        a!richTextDisplayField( /* Page Title */
          labelPosition: "COLLAPSED",
          value: {
            a!richTextItem(
              text: { "Page Title" },
              size: "LARGE",
              style: { "STRONG" }
            )
          }
        )
      },
      height: "AUTO",
      style: "#1C2C44", /* Dark blue header background */
      padding: "MORE", /* Simple headers look better with more padding */
      marginBelow: "NONE",
      showBorder: false
    )
  },
  contents: {
    a!cardLayout( /* Card wrapping main page contents */
      contents: {},
      style: "NONE",
      shape: "ROUNDED",
      padding: "STANDARD",
      showBorder: true,
      showShadow: false
    )
  },
  contentsPadding: "MORE",
  backgroundColor: "#F5F6F8" /* Set a page background color for greater contrast against white cards */
)
```


## Common Patterns

### 1. Hero Section with Colored Background (No Image)
```sail
a!headerContentLayout(
  header: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: {
          a!richTextItem(
            text: "Get Started Today",
            size: "LARGE",
            style: "STRONG",
            color: "#FFFFFF"
          ),
          char(10),
          a!richTextItem(
            text: "Join thousands of users who trust our platform",
            size: "MEDIUM",
            color: "#FFFFFF"
          )
        },
        align: "LEFT",
        labelPosition: "COLLAPSED"
      )
    },
    style: "#2563EB",
    showBorder: false,
    showShadow: false,
    height: "AUTO",
    padding: "MORE"
  ),
  contents: {
    /* Main content */
  }
)
```

### 2. No Header (Content Only - use to set custom page background color)
```sail
a!headerContentLayout(
  contents: {
    a!columnsLayout(
      columns: {
        a!columnLayout(width: "AUTO"),
        a!columnLayout(
          width: "WIDE_PLUS",
          contents: {
            /* Centered content */
          }
        ),
        a!columnLayout(width: "AUTO")
      }
    )
  },
  backgroundColor: "#F8F9FA",
  contentsPadding: "MORE"
)
```

### 3. Lightweight header

If a boxy card header isn't needed, exclude the `header` parameter and put header contents (like the page title) directly in page `contents`:

```sail
a!headerContentLayout(
  contents: {
    a!richTextDisplayField( /* Page title included in page contents, not header */
      labelPosition: "COLLAPSED",
      value: {
        a!richTextItem(
          text: { "Page Title" },
          size: "LARGE",
          style: { "STRONG" }
        )
      },
      marginBelow: "MORE" /* Add space between title and page contents */
    ),
    a!cardLayout( /* Card wrapping main page contents */
      contents: {
        /* Page contents */
      },
      style: "NONE",
      shape: "ROUNDED",
      padding: "STANDARD",
      showBorder: true,
      showShadow: false
    )
  },
  contentsPadding: "MORE",
  backgroundColor: "#F5F6F8" /* Set a page background color for greater contrast against white cards */
)
```

## Multiple Headers Example
```sail
a!headerContentLayout(
  header: {
    a!billboardLayout(
      backgroundMedia: a!webImage(source: "hero-bg.jpg"),
      /* Hero section with background image */
    ),
    a!cardLayout(
      /* Action bar - no background image */
    )
  },
  contents: {
    /* Main content */
  }
)
```

## Best Practices

### ✅ DO:
- Use billboardLayout ONLY when you have a background image/video
- Use cardLayout for hero sections without background images
- Use cardLayout for toolbars, action bars, and simple headers
- (Optional) Combine with columnsLayout in contents for proper content margins
- Use appropriate contentsPadding for your design

### ❌ DON'T:
- Use billboardLayout without a background image (use cardLayout instead)
- Nest headerContentLayout inside other layouts
- Use when formLayout or paneLayout would be more appropriate
- Forget to add margins around content using columnsLayout (if necessary)

## MANDATORY VALIDATION CHECKLIST
- [ ] `header` is omitted OR contains ONLY `cardLayout` or `billboardLayout` at the top level
- [ ] `contentsPadding` has appropriate value for padding around page contents
- [ ] `cardLayout` in `header` has appropriate padding set
