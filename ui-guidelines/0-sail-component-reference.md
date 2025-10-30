# SAIL Component Reference

## Quick Component Finder

### Layout Components
- **Top-Level**: `a!formLayout`, `a!headerContentLayout`, `a!paneLayout`, `a!wizardLayout`
- **Content Structure/Layout Grid**: `a!columnsLayout`, `a!sideBySideLayout`
- **Containers**: `a!cardLayout`, `a!cardGroupLayout`, `a!sectionLayout`, `a!boxLayout`
- **Decorative**: `a!billboardLayout`

### Input Components
- **Text Input**: `a!textField`, `a!paragraphField`, `a!encryptedTextField`, `a!styledTextEditorField`
- **Numbers**: `a!integerField`, `a!floatingPointField`
- **Dates & Time**: `a!dateField`, `a!dateTimeField`, `a!timeField`
- **Selections**: `a!dropdownField`, `a!radioButtonField`, `a!checkboxField`, `a!cardChoiceField`, `a!checkboxFieldBoolean`
- **Files**: `a!fileUploadField`, `a!signatureField`, `a!barcodeField`
- **Picker Components**: `a!pickerFieldUsers`, `a!pickerFieldGroups`, `a!pickerFieldUsersAndGroups`

### Display Components
- **Text**: `a!richTextDisplayField`, `a!headingField`, `a!timeDisplay`
- **Media**: `a!imageField`, `a!documentViewerField`, `a!webContentField`
- **Visual Indicators**: `a!progressBarField`, `a!gaugeField`, `a!milestoneField`, `a!stampField`
- **Lists & Links**: `a!tagField`, `a!linkField`
- **Record Actions**: `a!recordActionField`
- **Separators**: `a!horizontalLine`

### Helper Components (Used within other components)
- **Media Sources**: `a!webImage()`, `a!documentImage()`, `a!userImage()`, `a!webVideo()`
- **Links**: `a!safeLink()`, `a!recordLink()`, `a!dynamicLink()`
- **Rich Text Lists**: `a!richTextBulletedList()`, `a!richTextNumberedList()`
- **Grid Helpers**: `a!sortInfo()`

### Data Visualization Components
- **Grids**: `a!gridField`, `a!gridLayout`
- **Charts**: `a!areaChartField`, `a!barChartField`, `a!columnChartField`, `a!lineChartField`, `a!pieChartField`, `a!scatterChartField`

### Interactive Components
- **Buttons**: `a!buttonWidget`, `a!buttonArrayLayout`, `a!buttonLayout`

---

## Common Parameters

### Visibility
- **`showWhen`**: Boolean - Determines component visibility. Default: `true`

### Vertical Margins
- **`marginAbove`**: Text - Space above. Values: `NONE`(default), `EVEN_LESS`, `LESS`, `STANDARD`, `MORE`, `EVEN_MORE`
- **`marginBelow`**: Text - Space below. Values: `NONE`, `EVEN_LESS`, `LESS`, `STANDARD`(default), `MORE`, `EVEN_MORE`

### Labeling
- **`label`**: Text - Field label
- **`instructions`**: Text - Supplemental text
- **`labelPosition`**: Text - Label placement. Values: `ABOVE`(default), `ADJACENT`, `JUSTIFIED`, `COLLAPSED` (hidden). *ALWAYS* explicitly set to `COLLAPSED` if not showing a label.
- **`helpTooltip`**: Text - Help icon tooltip (500 char max). Hidden when `labelPosition=COLLAPSED`

### Validation
- **`required`**: Boolean - Required for form submission. Default: `false`
- **`requiredMessage`**: Text - Custom required message
- **`validations`**: List of Text - Validation errors when value not null
- **`validationGroup`**: Text - Button group for validation (no spaces)

### Interaction
- **`disabled`**: Boolean - Grayed out state. Default: `false`
- **`readOnly`**: Boolean - Non-editable state. Default: `false`
- **`saveInto`**: List of Save - Variables updated on change. Use `a!save()`

### Accessibility
- **`accessibilityText`**: Text - Screen reader announcement (no visible change)

### Text Input Common
- **`value`**: Text - Display value
- **`placeholder`**: Text - Empty field text (not shown on readOnly)
- **`refreshAfter`**: Text - `KEYPRESS`|`UNFOCUS`(default) - When interface refreshes
- **`align`**: Text - `LEFT`|`CENTER`|`RIGHT` (Grid Layout only)

---

## Layout Components

### a!formLayout
**Purpose**: Top-level form layout with optional header, contents, and buttons

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `titleBar` | Text\|CardLayout\|HeaderTemplate | - | Text, cardLayout, or header templates (`a!headerTemplateFull`, `a!headerTemplateSimple`, `a!sidebarTemplate`) |
| `contentsWidth` | Text | varies | `FULL`\|`WIDE`\|`MEDIUM`\|`NARROW`\|`EXTRA_NARROW` Use **`FULL`** for forms in dialogs! |
| `contents` | Any Type Array | - | Form body components |
| `buttons` | Button Layout | - | Use `a!buttonLayout()` |
| `backgroundColor` | Text | `WHITE` | `WHITE`\|`TRANSPARENT` or hex |
| `validations` | Text/Validation Message | - | Form-level errors |

---

### a!headerContentLayout  
**Purpose**: Page layout with header (optional) and content sections

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `header` | Any Type | - | Billboard/card layouts |
| `contents` | Any Type Array | - | Body components |
| `backgroundColor` | Text | `WHITE` | `WHITE`\|`TRANSPARENT` or hex |
| `contentsPadding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |
| `isHeaderFixed` | Boolean | `false` | Fixed header on scroll |

---

### a!paneLayout
**Purpose**: 2-3 full-height vertical panes with independent scrolling

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `panes` | a!pane | List of 2-3 panes |

---

### a!pane
**Purpose**: Individual pane within paneLayout

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `contents` | Any Type | - | Pane content components |
| `width` | Text | `AUTO` | `AUTO`\|`EXTRA_NARROW`\|`NARROW`\|`NARROW_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`WIDE`\|`WIDE_PLUS` |
| `backgroundColor` | Text | - | Pane background color (hex) |
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |

**⚠️ Critical Rule**: At least one pane must have `width: "AUTO"` for fluid layout

---

### a!wizardLayout
**Purpose**: Multi-step form layout with automatic navigation and progress indicators

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `titleBar` | Text\|CardLayout\|HeaderTemplate | - | Text, cardLayout, or header templates |
| `steps` | List of a!wizardStep | - | Step definitions (required) |
| `style` | Text | `DOT_VERTICAL` | `DOT_VERTICAL`\|`DOT_HORIZONTAL`\|`CHEVRON_VERTICAL`\|`CHEVRON_HORIZONTAL`\|`LINE_VERTICAL`\|`LINE_HORIZONTAL`\|`MINIMAL` |
| `contentsWidth` | Text | varies by context | `FULL`\|`WIDE`\|`MEDIUM`\|`NARROW`\|`EXTRA_NARROW` |
| `primaryButtons` | List of ButtonWidget | - | Additional primary buttons (Next is automatic) |
| `secondaryButtons` | List of ButtonWidget | - | Additional secondary buttons (Back is automatic) |
| `showStepHeadings` | Boolean | `true` | Show step labels above content |
| `focusOnFirstInput` | Boolean | `true` | Auto-focus first input on step change |
| `isTitleBarFixed` | Boolean | `false` | Fixed title bar on scroll |
| `showButtonDivider` | Boolean | `false` | Divider above buttons |
| `showTitleBarDivider` | Boolean | `true` | Divider below title bar |

**Available Function Variables**:
- `fv!activeStepIndex` - Current step number (1-based)
- `fv!isFirstStep` - Boolean, true only on first step
- `fv!isLastStep` - Boolean, true only on last visible step

---

### a!wizardStep
**Purpose**: Individual step within wizardLayout

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | Text | - | Step name (required, shows in indicator) |
| `instructions` | Text | - | Helper text shown above content |
| `contents` | Any Type | - | Step content components (required) |
| `showWhen` | Boolean | `true` | Conditional step display |
| `disableNextButton` | Boolean | `false` | Disable Next button based on validation |
| `validations` | List of Text | - | Step-level validation messages |

---

### a!boxLayout
**Purpose**: Content within a styled box. Often used for grouping related fields.

**Inherits**: Visibility, Vertical Margins

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `label` | Text | - | Optional title for the box |
| `contents` | Any Type Array | - | Box body components |
| `style` | Text | `STANDARD` | `STANDARD`\|`ACCENT`\|`SUCCESS`\|`INFO`\|`WARN`\|`ERROR` or hex | Box title bar background color
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |
| `showBorder` | Boolean | `true` | Outer border |

---
### a!columnsLayout
**Purpose**: Horizontal column arrangement

**Inherits**: Visibility, Vertical Margins

**⚠️ Critical Rule**: At least one column must have `width: "AUTO"`

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `columns` | List of columnLayout | - | Use `a!columnLayout()` |
| `alignVertical` | Text | `TOP` | `TOP`\|`MIDDLE`\|`BOTTOM` |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`NONE`\|`DENSE`\|`SPARSE` |
| `showDividers` | Boolean | `false` | Column separator lines |
| `stackWhen` | List of Text | - | Screen widths when columns stack vertically. Values: `PHONE`\|`TABLET_PORTRAIT`\|`TABLET_LANDSCAPE`\|`DESKTOP`\|`DESKTOP_WIDE` |

---

### a!columnLayout
**Purpose**: Single column within columns layout

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `contents` | Any Type | - | Column content |
| `width` | Text | `AUTO` | `AUTO`\|`EXTRA_NARROW`\|`NARROW`\|`NARROW_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`WIDE`\|`WIDE_PLUS`\|`1X`\|`2X`\|`3X`\|`4X`\|`5X`\|`6X`\|`7X`\|`8X`\|`9X`\|`10X` |

---

### a!sideBySideLayout
**Purpose**: Side-by-side component arrangement

**Inherits**: Visibility, Vertical Margins

**⚠️ Critical Rules**:
- ❌ **NEVER** nest sideBySideLayouts inside sideBySideItems
- ❌ **NEVER** put arrays of components in sideBySideItems
- ❌ **NEVER** put layouts in sideBySideItems

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | List of sideBySideItem | - | Use `a!sideBySideItem()` |
| `alignVertical` | Text | `TOP` | `TOP`\|`MIDDLE`\|`BOTTOM` |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`NONE`\|`DENSE`\|`SPARSE` |

---

### a!sideBySideItem
**Purpose**: Item within side-by-side layout

**Inherits**: Visibility

**⚠️ Critical Rule**: Can only contain **single components**, not arrays or layouts

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `item` | Single component | - | No arrays or layouts allowed |
| `width` | Text | `AUTO` | `AUTO`\|`MINIMIZE`\|`1X`\|`2X`\|`3X`\|`4X`\|`5X`\|`6X`\|`7X`\|`8X`\|`9X`\|`10X` |

---

### a!cardLayout
**Purpose**: Content within a styled card

**Inherits**: Visibility, Vertical Margins, Accessibility, Layout

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `contents` | Any Type | - | Card content |
| `style` | Text | `NONE` | `NONE`\|`TRANSPARENT`\|`STANDARD`\|`ACCENT`\|`SUCCESS`\|`INFO`\|`WARN`\|`ERROR`\|`CHARCOAL_SCHEME`\|`NAVY_SCHEME`\|`PLUM_SCHEME` or hex |
| `shape` | Text | `SQUARED` | `SQUARED`\|`SEMI_ROUNDED`\|`ROUNDED` |
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |
| `showBorder` | Boolean | `true` | Outer border |
| `showShadow` | Boolean | `false` | Drop shadow |
| `height` | Text | `AUTO` | `EXTRA_SHORT`\|`SHORT`\|`SHORT_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`TALL`\|`TALL_PLUS`\|`EXTRA_TALL`\|`AUTO` |
| `link` | a!dynamicLink | - | Makes card clickable |
| `decorativeBarPosition` | Text | `NONE` | `NONE`\|`TOP`\|`BOTTOM`\|`START`\|`END` |
| `decorativeBarColor` | Text | - | Color for decorative bar |
| `borderColor` | Text | - | Border color override |

---

### a!cardGroupLayout
**Purpose**: Group of cards with automatic flow

**Inherits**: Labeling, Visibility, Vertical Margins

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cards` | Any Type | - | Use `a!cardLayout()` |
| `cardWidth` | Text | `MEDIUM` | `EXTRA_NARROW`\|`NARROW`\|`NARROW_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`WIDE`\|`WIDE_PLUS`\|`EXTRA_WIDE` |
| `cardHeight` | Text | `AUTO` | `AUTO`\|`EXTRA_SHORT`\|`SHORT`\|`SHORT_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`TALL`\|`TALL_PLUS`\|`EXTRA_TALL` |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`NONE`\|`DENSE`\|`SPARSE` |
| `fillContainer` | Boolean | `true` | Expand to fill container width |

---

### a!sectionLayout
**Purpose**: Section with title and optionally collapsible content

**Inherits**: Visibility, Vertical Margins, Accessibility, Layout

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | Text | - | Section title |
| `contents` | Any Type | - | Section body components |
| `isCollapsible` | Boolean | `false` | Expand/collapse control |
| `labelColor` | Text | `ACCENT` | `ACCENT`\|`STANDARD`\|`POSITIVE`\|`NEGATIVE`\|`SECONDARY` or hex |
| `labelSize` | Text | `MEDIUM` | `LARGE_PLUS`\|`LARGE`\|`MEDIUM_PLUS`\|`MEDIUM`\|`SMALL`\|`EXTRA_SMALL` |
| `divider` | Text | `NONE` | `NONE`\|`ABOVE`\|`BELOW` |

---

### a!billboardLayout
**Purpose**: Background image or video with optional overlay content

**Inherits**: Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `backgroundMedia` | Any Type | - | Use `a!documentImage()`, `a!webImage()`, `a!webVideo()` |
| `backgroundColor` | Text | `#f0f0f0` | Background color (hex required) |
| `height` | Text | `MEDIUM` | `EXTRA_SHORT`\|`SHORT`\|`SHORT_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`TALL`\|`TALL_PLUS`\|`EXTRA_TALL`\|`AUTO` |
| `overlay` | Any Type | - | Use `a!columnOverlay()`, `a!barOverlay()`, `a!fullOverlay()` |

---

### a!fullOverlay
**Purpose**: Full overlay completely covering entire billboard

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `alignVertical` | Text | `TOP` | `TOP`\|`MIDDLE`\|`BOTTOM` |
| `contents` | Any Type | - |  |
| `style` | Text | `DARK` | `DARK`\|`SEMI_DARK`\|`NONE`\|`SEMI_LIGHT`\|`LIGHT` |
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |

**Overlay style**
- `DARK` and `SEMI_DARK` produce a semi-transparent black background
- `LIGHT` and `SEMI_LIGHT` produce a semi-transparent white background

---

### a!barOverlay
**Purpose**: Horizontal bar overlay positioned at top, middle, or bottom of billboard

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `position` | Text | `BOTTOM` | `TOP`\|`MIDDLE`\|`BOTTOM` |
| `contents` | Any Type | - |  |
| `style` | Text | `DARK` | `DARK`\|`SEMI_DARK`\|`NONE`\|`SEMI_LIGHT`\|`LIGHT` |
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |

---

### a!columnOverlay
**Purpose**: Vertical column overlay positioned at left, middle, or right of billboard

**Inherits**: Visibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `alignVertical` | Text | `TOP` | `TOP`\|`MIDDLE`\|`BOTTOM` |
| `position` | Text | `START` | `START`\|`CENTER`\|`END` |
| `width` | Text | `MEDIUM` | `NARROW`\|`MEDIUM`\|`WIDE` |
| `contents` | Any Type | - |  |
| `style` | Text | `DARK` | `DARK`\|`SEMI_DARK`\|`NONE`\|`SEMI_LIGHT`\|`LIGHT` |
| `padding` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |

---

## Input Components

### a!textField
**Purpose**: Single line text input

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility, Text Input Common

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `masked` | Boolean | `false` | Obscure value |
| `inputPurpose` | Text | - | `NAME`\|`EMAIL`\|`PHONE_NUMBER`\|`STREET_ADDRESS`\|`POSTAL_CODE`\|`CREDIT_CARD_NUMBER`\|`OFF` |
| `characterLimit` | Integer | - | Max characters |
| `showCharacterCount` | Boolean | `true` | Show count if limit set |

---

### a!paragraphField
**Purpose**: Multi-line text input

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Text | - | Display value |
| `height` | Text | `MEDIUM` | `SHORT`\|`MEDIUM`\|`TALL` |
| `characterLimit` | Integer | - | Max characters |
| `showCharacterCount` | Boolean | `true` | Show count if limit set |

---

### a!integerField
**Purpose**: Integer number input

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Integer | - | Display value |
| `masked` | Boolean | `false` | Obscure value |

---

### a!floatingPointField  
**Purpose**: Decimal number input

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Decimal | - | Display value |

---

### a!dateField
**Purpose**: Date input (year, month, day)

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Date | - | Display value |

---

### a!dropdownField
**Purpose**: Single selection dropdown

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

**⚠️ Critical Rule**: `choiceValues` cannot be null or empty strings

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `choiceLabels` | List of Text | - | Displayed user options |
| `choiceValues` | List of Variant | - | Saved values (cannot be null/empty) |
| `value` | Any Type | - | Selected choice value |
| `placeholder` | Text | - | Empty selection text |
| `searchDisplay` | Text | `AUTO` | `AUTO`\|`ON`\|`OFF` |

---

### a!radioButtonField
**Purpose**: Single selection radio buttons

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

**⚠️ Critical Rule**: `choiceValues` cannot be null or empty strings

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `choiceLabels` | List of Text | - | User options |
| `choiceValues` | List of Variant | - | Saved values (cannot be null/empty) |
| `value` | Any Type | - | Selected choice value |
| `choiceLayout` | Text | `STACKED` | `STACKED`\|`COMPACT` | Use COMPACT to try to fit all radio buttons on one row
| `choiceStyle` | Text | `STANDARD` | `STANDARD`\|`CARDS` | Use CARDS to show each radio button as a clickable card

---

### a!checkboxField
**Purpose**: Multiple selection checkboxes

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

**⚠️ Critical Rule**: `choiceValues` cannot be null or empty strings

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `choiceLabels` | List of Text | - | User options |
| `choiceValues` | List of Variant | - | Saved values (cannot be null/empty) |
| `value` | List of Variant | - | Selected choice values |
| `choiceLayout` | Text | `STACKED` | `STACKED`\|`COMPACT` | Use COMPACT to try to fit all checkboxes on one row
| `choiceStyle` | Text | `STANDARD` | `STANDARD`\|`CARDS` | Use CARDS to show each checkbox as a clickable card

---

### a!cardChoiceField
**Purpose**: Selection displayed as styled cards

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | List of Variant | - | Options data |
| `cardTemplate` | Any Type | - | Use `a!cardTemplateBarTextStacked()`, etc. |
| `value` | List of Variant | - | Selected values |
| `maxSelections` | Integer | - | Max selectable cards |
| `showShadow` | Boolean | `false` | Card shadows |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`NONE`\|`DENSE`\|`SPARSE` |
| `align` | Text | `START` | `START`\|`CENTER`\|`END` |

---

### a!fileUploadField
**Purpose**: File upload with document management

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `target` | Document/Folder | - | Upload destination |
| `value` | List of Document | - | Associated files |
| `maxSelections` | Integer | - | Max files allowed |
| `buttonStyle` | Text | `SECONDARY` | `NORMAL`\|`PRIMARY`\|`SECONDARY`\|`LINK` |
| `buttoDisplay` | Text | `LABEL` | `LABEL`\|`ICON`\|`LABEL_AND_ICON` |
| `buttonSize` | Text | `SMALL` | `SMALL`\|`STANDARD`\|`LARGE` |

---
---

## Input Components

### a!dateTimeField
**Purpose**: Date and time input (year, month, day, hour, minute, second)

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `value` | Date and Time | - | Display value |

### a!timeField
**Purpose**: Time input (hour, minute, second)

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `value` | Time | - | Display value |

### a!checkboxFieldBoolean
**Purpose**: Single selection checkbox for boolean values

**Inherits**: Labeling, Validation, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `label` | Text | - | Label for the checkbox |
| `value` | Boolean | - | Selected value |

### a!barcodeField
**Purpose**: Displays and allows entry of a barcode value

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility, Text Input Common

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `value` | Text | - | Display value |

### Picker Components

#### a!pickerFieldUsers
**Purpose**: Selects one or more users

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `maxSelections` | Integer | - | Max number of users allowed |
| `groupFilter` | Group | - | Only suggest users who are members of this group |
| `value` | List of Username | - | Array of currently selected users |

#### a!pickerFieldGroups
**Purpose**: Selects one or more groups

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `maxSelections` | Integer | - | Max number of groups allowed |
| `groupFilter` | Group | - | Only suggest groups who are members of this group |
| `value` | List of Group | - | Array of currently selected groups |

#### a!pickerFieldUsersAndGroups
**Purpose**: Selects one or more users or groups

**Inherits**: Labeling, Validation, Interaction, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `maxSelections` | Integer | - | Max number of users/groups allowed |
| `groupFilter` | Group | - | Only suggest users or groups who are members of this group |
| `value` | List of User or Group | - | Array of currently selected users or groups |

---

## Display Components

### a!richTextDisplayField
**Purpose**: Formatted text display with styles, links, lists

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**⚠️ Critical Rule**: Can **ONLY** contain `a!richTextItem`, `a!richTextIcon`, `a!richTextBulletedList`, `a!richTextNumberedList`, or plain text

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | Any Type | - | One or a list of `a!richTextItem`, `a!richTextIcon`, `a!richTextBulletedList`, `a!richTextNumberedList`, or plain text |
| `align` | Text | `LEFT` | `LEFT`\|`CENTER`\|`RIGHT` |
| `preventWrapping` | Boolean | `false` | Single line truncation |
| `tooltip` | Text | - | Mouseover tooltip text |

---

### a!stampField  
**Purpose**: Icon and/or text on colored background

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `icon` | Text | - | Icon to display |
| `text` | Text | - | Text to display |
| `backgroundColor` | Text | `ACCENT` | `ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`SECONDARY`\|`TRANSPARENT` or hex |
| `contentColor` | Text | `STANDARD` | `STANDARD`\|`ACCENT`\|`POSITIVE`\|`NEGATIVE` or hex |
| `size` | Text | `MEDIUM` | `TINY`\|`SMALL`\|`MEDIUM`\|`LARGE` |
| `shape` | Text | `ROUNDED` | `ROUNDED`\|`SEMI_ROUNDED`\|`SQUARED` |

---

### a!tagField
**Purpose**: Colored text labels for highlighting attributes

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tags` | List of Variant | - | Use `a!tagItem()` |
| `size` | Text | `STANDARD` | `SMALL`\|`STANDARD` |
| `align` | Text | `START` | `START`\|`CENTER`\|`END` |

---

### a!linkField
**Purpose**: Displays a list of clickable links

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `links` | Any Type | - | Array of link components created with `a!authorizationLink()`, `a!documentDownloadLink()`, `a!dynamicLink()`, `a!processTaskLink()`, `a!recordLink()`, `a!safeLink()`, `a!startProcessLink()`, `a!submitLink()`, `a!userRecordLink()`, etc. |
| `align` | Text | - | `LEFT`\|`CENTER`\|`RIGHT` (recommended for Grid Layout only) |

**Note**: Commonly used in grids to display action links for each row.

---

### a!recordActionField
**Purpose**: Displays record actions in various configurable styles

**Inherits**: Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `actions` | Any Type | - | List of record action items configured with `a!recordActionItem()` |
| `style` | Text | `TOOLBAR` | `TOOLBAR`\|`LINKS`\|`CARDS`\|`SIDEBAR`\|`CALL_TO_ACTION`\|`MENU`\|`MENU_ICON`\|`TOOLBAR_PRIMARY`\|`SIDEBAR_PRIMARY` |
| `display` | Text | - | Controls how actions are displayed |
| `openActionsIn` | Text | - | Where to open action dialogs |
| `align` | Text | - | Alignment for action display |
| `securityOnDemand` | Boolean | - | Load security only when needed (performance) |

**Note**: Use `"MENU"` or `"MENU_ICON"` styles for better performance with multiple record actions.

---

### a!progressBarField
**Purpose**: Progress bar showing completion percentage

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `percentage` | Integer | - | Value 0-100 |
| `color` | Text | `ACCENT` | `ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`WARN` or hex |
| `style` | Text | `THIN` | `THIN`\|`THICK` |
| `showPercentage` | Boolean | `true` | Display percentage text |

---

### a!headingField
**Purpose**: Styled heading text with accessibility support

**Inherits**: Visibility, Vertical Margins

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | Text | - | Heading text |
| `size` | Text | `MEDIUM_PLUS` | `LARGE_PLUS`\|`LARGE`\|`MEDIUM_PLUS`\|`MEDIUM`\|`SMALL`\|`EXTRA_SMALL` |
| `headingTag` | Text | - | `H1`\|`H2`\|`H3`\|`H4`\|`H5`\|`H6` (accessibility) |
| `color` | Text | `STANDARD` | `ACCENT`\|`STANDARD`\|`SECONDARY` or hex |
| `fontWeight` | Text | `BOLD` | `LIGHT`\|`NORMAL`\|`SEMI_BOLD`\|`BOLD`\|`EXTRA_BOLD` |

---

### a!imageField
**Purpose**: Image display from documents or web

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `images` | Any Type | - | Use `a!webImage()`, `a!userImage()`, `a!documentImage()` |
| `size` | Text | `MEDIUM` | `ICON`\|`ICON_PLUS`\|`TINY`\|`EXTRA_SMALL`\|`SMALL`\|`SMALL_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`LARGE`\|`LARGE_PLUS`\|`EXTRA_LARGE`\|`FIT`\|`GALLERY` |
| `style` | Text | `STANDARD` | `STANDARD`\|`AVATAR` |

---

### a!gaugeField
**Purpose**: Circular progress indicator

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `percentage` | Decimal | - | Value 0-100 |
| `primaryText` | Text | - | First line |
| `secondaryText` | Text | - | Second line |
| `color` | Text | `ACCENT` | `ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`WARN` or hex |
| `size` | Text | `MEDIUM` | `SMALL`\|`MEDIUM`\|`LARGE` |

---

### a!milestoneField
**Purpose**: Process step indicator

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `steps` | List of Text | - | Step labels |
| `active` | Integer | - | Current step index |
| `orientation` | Text | `HORIZONTAL` | `HORIZONTAL`\|`VERTICAL` |
| `stepStyle` | Text | `LINE` | `LINE`\|`CHEVRON`\|`DOT` |
| `color` | Text | `ACCENT` | `ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`WARN` or hex |

---

### a!horizontalLine
**Purpose**: Horizontal divider line

**Inherits**: Visibility, Vertical Margins

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `color` | Text | `SECONDARY` | `SECONDARY`\|`STANDARD`\|`ACCENT` or hex |
| `weight` | Text | `THIN` | `THIN`\|`MEDIUM`\|`THICK` |
| `style` | Text | `SOLID` | `SOLID`\|`DOT`\|`DASH` |

---
### a!documentViewerField
**Purpose**: Displays a document using the web browser's built-in document viewer (PDF support is most common)

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `document` | Document | - | Document to display |
| `showName` | Boolean | `true` | Display document file name above viewer |
| `showDescription` | Boolean | `false` | Display document description below file name |
| `height` | Text | `MEDIUM` | `SHORT`\|`MEDIUM`\|`TALL` |

**Notes**:
- Rendering depends on browser capabilities; PDFs are commonly supported
- Other file types may prompt download instead of inline display

### a!timeDisplay
**Purpose**: Displays a single time (hour, minute, second) in read-only format

**Inherits**: Labeling, Visibility, Vertical Margins, Accessibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `value` | Time | - | Time value to display |
| `format` | Text | `SHORT` | `SHORT`\|`MEDIUM`\|`LONG` |

---
## Data Components

### a!gridField
**Purpose**: Read-only data grid with sorting, paging, selection, search, and record actions

**Inherits**: Labeling, Validation, Interaction, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Core Grid Parameters** | | | |
| `data` | RecordType/List/DataSubset | - | Use record type or `a!recordData()` |
| `columns` | List of a!gridColumn | - | Column definitions |
| `emptyGridMessage` | Text | "No items available" | Message shown when no data |
| `pageSize` | Integer | `10` | Rows per page |
| **Paging** | | | |
| `pagingSaveInto` | Save Array | - | Variables updated when paging (use `fv!pagingInfo`) |
| **Sorting** | | | |
| `initialSorts` | List of SortInfo | - | Default sort configuration |
| `secondarySorts` | List of SortInfo | - | Secondary sort when initial sorts are equal |
| **Selection** | | | |
| `selectable` | Boolean | `false` | Enable row selection |
| `selectionStyle` | Text | `CHECKBOX` | `CHECKBOX`\|`ROW_HIGHLIGHT` |
| `selectionValue` | List of Variant | - | Currently selected rows |
| `selectionSaveInto` | Save Array | - | Variables updated on selection (use `fv!selectedRows`, `fv!deselectedRows`) |
| `selectionRequired` | Boolean | `false` | Require at least one selection |
| `selectionRequiredMessage` | Text | - | Custom required selection message |
| `maxSelections` | Integer | - | Maximum allowed selections |
| `showSelectionCount` | Text | `AUTO` | `AUTO`\|`ON`\|`OFF` - Display selection counter |
| `disableRowSelectionWhen` | Boolean | `false` | Per-row selection disabling (use `fv!row`, `fv!identifier`) |
| **Record-Specific Features** (only when data is a record type) | | | |
| `recordActions` | List of Variant | - | Record action items via `a!recordActionItem()` |
| `actionsStyle` | Text | `TOOLBAR` | `TOOLBAR`\|`TOOLBAR_PRIMARY` - Action toolbar style |
| `actionsDisplay` | Text | `LABEL_AND_ICON` | `LABEL_AND_ICON`\|`LABEL`\|`ICON` - Action button content |
| `openActionsIn` | Text | `DIALOG` | `DIALOG`\|`NEW_TAB`\|`SAME_TAB` - Where actions open |
| `userFilters` | List of Variant | - | User filter references (e.g., `recordType!Case.filters.status`) |
| `showSearchBox` | Boolean | `true` | Display record search box |
| `showRefreshButton` | Boolean | `true` | Display manual refresh button |
| `showExportButton` | Boolean | `false` | Display export to Excel button |
| `similarityScoreThreshold` | Decimal | `1` | Smart search relevance threshold (0.0-1.0) |
| `loadDataAsync` | Boolean | `false` | Load grid data in background |
| **Refresh Behavior** | | | |
| `refreshAlways` | Boolean | `false` | Refresh after each user interaction |
| `refreshAfter` | List of Text | - | Refresh after events (e.g., `"RECORD_ACTION"`) |
| `refreshInterval` | Decimal | - | Auto-refresh interval in minutes (0.5, 1, 2, 3, 4, 5, 10, 30, 60) |
| `refreshOnReferencedVarChange` | Boolean | `true` | Refresh when referenced variables change |
| `refreshOnVarChange` | Any Type | - | Refresh when specific variables change |
| **Visual Styling** | | | |
| `height` | Text | `AUTO` | `SHORT`\|`SHORT_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`TALL`\|`TALL_PLUS`\|`EXTRA_TALL`\|`AUTO` |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`DENSE` |
| `borderStyle` | Text | `LIGHT` | `STANDARD`\|`LIGHT` |
| `shadeAlternateRows` | Boolean | `false` | Alternate row coloring |
| `rowHeader` | Integer | - | Column index for row headers (accessibility) |

---

### a!gridColumn
**Purpose**: Column definition for read-only grid with advanced display and export options

**Inherits**: Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Core Column Parameters** | | | |
| `label` | Text | - | Column header text |
| `value` | Any Type | - | Cell content ( The value can be text, `a!imageField`, `a!linkField`, `a!richTextDisplayField`, `a!tagField`, `a!buttonArrayLayout`, `a!recordActionField`, or `a!progressBarField`) |
| `helpTooltip` | Text | - | Column header help tooltip |
| **Sorting Parameters** | | | |
| `sortField` | Any Type | - | Field for sorting (enables sort for column) |
| **Display Parameters** | | | |
| `width` | Text | `AUTO` | `AUTO`\|`ICON`\|`ICON_PLUS`\|`NARROW`\|`NARROW_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`WIDE`\|`1X`\|`2X`\|`3X`\|`4X`\|`5X`\|`6X`\|`7X`\|`8X`\|`9X`\|`10X` |
| `align` | Text | `START` | `START`\|`CENTER`\|`END` |
| `backgroundColor` | Text | `NONE` | `NONE`\|`ACCENT`\|`SUCCESS`\|`INFO`\|`WARN`\|`ERROR` or hex |

**Grid Column Width Guidelines:**
- `AUTO` for grids with a few columns; width adjusts automatically based on content, OR, 
- Fixed widths (`MEDIUM`, etc.) to make the grid behave like a spreadsheet (columns wized based on contents)
- ❌ `WIDE_PLUS` is NOT a valid column width!

---

### a!gridLayout
**Purpose**: Editable grid with inline editing

**Inherits**: Labeling, Validation, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `headerCells` | List of Variant | - | Use `a!gridLayoutHeaderCell()` |
| `rows` | List of Variant | - | Use `a!gridRowLayout()` |
| `selectable` | Boolean | `false` | Enable selection |
| `height` | Text | `AUTO` | `SHORT`\|`SHORT_PLUS`\|`MEDIUM`\|`MEDIUM_PLUS`\|`TALL`\|`TALL_PLUS`\|`EXTRA_TALL`\|`AUTO` |
| `spacing` | Text | `STANDARD` | `STANDARD`\|`DENSE` |

---

## Chart Components

### a!columnChartField
**Purpose**: Vertical bars for data changes over time

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | Any Type | - | Record type or query |
| `categories` | List of Variant | - | X-axis labels |
| `series` | List of ChartSeries | - | Data via `a!chartSeries()` |
| `height` | Text | `MEDIUM` | `MICRO`\|`SHORT`\|`MEDIUM`\|`TALL` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |
| `stacking` | Text | `NONE` | `NONE`\|`NORMAL`\|`PERCENT_TO_TOTAL` |
| `showLegend` | Boolean | `true` | Color legend display |
| `showDataLabels` | Boolean | `false` | Values on data points |
| `xAxisTitle` | Text | - | Horizontal axis title |
| `yAxisTitle` | Text | - | Vertical axis title |
| `referenceLines` | List of ReferenceLine | - | Chart reference lines |

---

### a!pieChartField
**Purpose**: Circular slices for parts of a whole

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `series` | List of PieChartSeries | - | Use `a!chartSeries()` |
| `height` | Text | `MEDIUM` | `SHORT`\|`MEDIUM`\|`TALL` |
| `showAsPercentage` | Boolean | `false` | Show as percentage |
| `style` | Text | `PIE` | `PIE`\|`DONUT` |
| `seriesLabelStyle` | Text | `ON_CHART` | `ON_CHART`\|`LEGEND`\|`NONE` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |

---

### a!lineChartField
**Purpose**: Connected points for trends over time

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | Any Type | - | Record type or query |
| `categories` | List of Variant | - | X-axis labels |
| `series` | List of ChartSeries | - | Data via `a!chartSeries()` |
| `height` | Text | `MEDIUM` | `MICRO`\|`SHORT`\|`MEDIUM`\|`TALL` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |
| `connectNulls` | Boolean | `false` | Connect across null points |
| `xAxisTitle` | Text | - | Horizontal axis title |
| `yAxisTitle` | Text | - | Vertical axis title |
| `referenceLines` | List of ReferenceLine | - | Chart reference lines |

---

### a!barChartField
**Purpose**: Horizontal bars for values at same time point

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | Any Type | - | Record type or query |
| `categories` | List of Variant | - | Y-axis labels |
| `series` | List of ChartSeries | - | Data via `a!chartSeries()` |
| `height` | Text | `AUTO` | `MICRO`\|`SHORT`\|`MEDIUM`\|`TALL`\|`AUTO` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |
| `stacking` | Text | `NONE` | `NONE`\|`NORMAL`\|`PERCENT_TO_TOTAL` |
| `showLegend` | Boolean | `true` | Color legend display |
| `showDataLabels` | Boolean | `false` | Values on data points |
| `xAxisTitle` | Text | - | Horizontal axis title |
| `yAxisTitle` | Text | - | Vertical axis title |
| `referenceLines` | List of ReferenceLine | - | Chart reference lines |

---

### a!areaChartField
**Purpose**: Area chart with shaded regions

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | Any Type | - | Record type or query |
| `categories` | List of Variant | - | X-axis labels |
| `series` | List of ChartSeries | - | Data via `a!chartSeries()` |
| `height` | Text | `MEDIUM` | `MICRO`\|`SHORT`\|`MEDIUM`\|`TALL` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |
| `stacking` | Text | `NORMAL` | `NORMAL`\|`PERCENT_TO_TOTAL`\|`NONE` |
| `connectNulls` | Boolean | `false` | Connect across null points |
| `showLegend` | Boolean | `true` | Color legend display |
| `showDataLabels` | Boolean | `false` | Values on data points |
| `xAxisTitle` | Text | - | Horizontal axis title |
| `yAxisTitle` | Text | - | Vertical axis title |
| `referenceLines` | List of ReferenceLine | - | Chart reference lines |

---

### a!scatterChartField
**Purpose**: Points showing relationship between values

**Inherits**: Labeling, Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | Any Type | - | Record type reference |
| `height` | Text | `MEDIUM` | `MICRO`\|`SHORT`\|`MEDIUM`\|`TALL` |
| `colorScheme` | Text | `RAINFOREST` | `CLASSIC`\|`MIDNIGHT`\|`OCEAN`\|`MOSS`\|`BERRY`\|`PARACHUTE`\|`RAINFOREST`\|`SUNSET` |
| `xAxisTitle` | Text | - | Horizontal axis title |
| `yAxisTitle` | Text | - | Vertical axis title |

---

## Interactive Components

### a!buttonWidget
**Purpose**: Interactive button with conditional form submission

**Inherits**: Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | Text | - | Button text |
| `icon` | Text | - | Button icon displayed ahead of text label, same aliases as rich text icons (Font Awesome 4.7) |
| `style` | Text | `OUTLINE` | `OUTLINE`\|`GHOST`\|`LINK`\|`SOLID` |
| `size` | Text | `STANDARD` | `SMALL`\|`STANDARD`\|`LARGE` |
| `submit` | Boolean | - | Submit form after saving |
| `color` | Text | `ACCENT` | `ACCENT`\|`NEGATIVE`\|`SECONDARY` or hex |
| `disabled` | Boolean | `false` | Prevent clicking |
| `confirmMessage` | Text | - | Text to display in an optional confirmation dialog where a null argument disables the confirmation dialog and a text argument enables it with the text entered as the confirmation message. |
| `confirmHeader` | Text | - | Text to display in header of confirmation dialog. |
| `width` | Text | - | `MINIMIZE`\|`FILL` |
| `loadingIndicator` | Boolean | `false` | Show spinner on submit |
| `validate` | Boolean | `true` | Run validations before submit |

---

### a!buttonArrayLayout
**Purpose**: Button list for interfaces (not form submission)

**Inherits**: Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `buttons` | List of ButtonWidget | - | Use `a!buttonWidget()` |
| `align` | Text | `START` | `START`\|`CENTER`\|`END` |
| `marginBelow` | Text | `STANDARD` | `NONE`\|`EVEN_LESS`\|`LESS`\|`STANDARD`\|`MORE`\|`EVEN_MORE` |

**⚠️ Critical Recommendation**: set `marginBelow` to `NONE` explicitly to improve vertical alignment of buttons by removing extra space below
---

### a!buttonLayout
**Purpose**: Grouped buttons by prominence

**Inherits**: Visibility, Accessibility

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `primaryButtons` | List of ButtonWidget | - | Prominent buttons |
| `secondaryButtons` | List of ButtonWidget | - | Less prominent buttons |

---

## Helper Functions

### a!richTextItem
**Purpose**: Styled text for rich text display

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | Text | Text content |
| `style` | Text Array | `PLAIN`\|`EMPHASIS`\|`STRONG`\|`UNDERLINE`\|`STRIKETHROUGH` |
| `size` | Text | `SMALL`\|`STANDARD`\|`MEDIUM`\|`MEDIUM_PLUS`\|`LARGE`\|`LARGE_PLUS`\|`EXTRA_LARGE` |
| `color` | Text | `STANDARD`\|`ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`SECONDARY` or hex |
| `link` | Link | Text link |
| `linkStyle` | Text | `INLINE`|`STANDALONE` |

---

### a!richTextIcon
**Purpose**: Icon for rich text display

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | Text | Font Awesome 4.7 icon name |
| `color` | Text | Icon color |
| `size` | Text | `SMALL`\|`STANDARD`\|`MEDIUM`\|`MEDIUM_PLUS`\|`LARGE`\|`LARGE_PLUS`\|`EXTRA_LARGE` |
| `altText` | Text | Accessibility text |

---

### a!chartSeries
**Purpose**: Data series for charts

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | Text | Series name for legend |
| `data` | Decimal Array | Values for series |
| `color` | Text | `ACCENT`\|`BLUEGRAY`\|`GREEN`\|`GOLD`\|`ORANGE`\|`PURPLE`\|`RED`\|`SKYBLUE`\|`LIMEGREEN`\|`YELLOW`\|`AMBER`\|`PINK`\|`VIOLETRED` or hex |
| `showWhen` | Boolean | Series visibility |

---

### a!tagItem
**Purpose**: Individual tag for tag field

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | Text | Tag text (40 char max) |
| `backgroundColor` | Text | `ACCENT`\|`POSITIVE`\|`NEGATIVE`\|`SECONDARY` or hex |
| `textColor` | Text | `STANDARD` or hex |
| `link` | Any Type | Tag link |

---

### a!save
**Purpose**: Save operation for updating variables

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `target` | Variable | Variable to update |
| `value` | Any Type | Value to save |

---

### a!dynamicLink
**Purpose**: Link that updates variables

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | Text | Link text |
| `value` | Any Type | Value to save |
| `saveInto` | Save Array | Variables to update |
| `showWhen` | Boolean | Link visibility |

---

### a!headerTemplateFull
**Purpose**: Full-width header template for formLayout with background color

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | Text | Main heading text |
| `secondaryText` | Text | Subtitle or description |
| `backgroundColor` | Text | Full-width background color (hex or enumeration) |
| `titleColor` | Text | Color for main title (hex or enumeration) |
| `secondaryTextColor` | Text | Color for subtitle (hex or enumeration) |
| `stampIcon` | Text | Optional decorative icon |
| `stampColor` | Text | Color for stamp icon (hex or enumeration) |

---

### a!headerTemplateSimple
**Purpose**: Simple header template for formLayout aligned with content width

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | Text | Main heading text |
| `secondaryText` | Text | Subtitle or description |
| `titleColor` | Text | Color for main title (hex or enumeration) |
| `secondaryTextColor` | Text | Color for subtitle (hex or enumeration) |
| `stampIcon` | Text | Optional decorative icon |
| `stampColor` | Text | Color for stamp icon |

---

### a!sidebarTemplate
**Purpose**: Sidebar header template (desktop) that becomes header on mobile

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | Text | Main heading text |
| `secondaryText` | Text | Subtitle or description |
| `image` | Any Type | Optional decorative image (use `a!webImage()` or `a!documentImage()`) |
| `additionalContents` | Any Type | Extra components below text |

---

## Utility Components

### a!validationMessage
**Purpose**: Configures a standalone validation message for layouts or custom error handling

**Inherits**: Visibility

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `message` | Text | - | The validation message to display |
| `color` | Text | `ERROR` | `ERROR`\|`WARN`\|`INFO`\|`SUCCESS` |

---

## Media Source Components

### a!webImage
**Purpose**: References an image from a web URL for use in imageField or billboardLayout

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `source` | Text | URL of the image (must be accessible) |
| `altText` | Text | Alternative text for accessibility |

**Usage Example**:
```sail
a!imageField(
  images: a!webImage(
    source: "https://example.com/image.jpg",
    altText: "Product photo"
  )
)
```

---

### a!documentImage
**Purpose**: References an Appian document as an image source

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `document` | Document | Document identifier |
| `altText` | Text | Alternative text for accessibility |

**Usage Example**:
```sail
a!billboardLayout(
  backgroundMedia: a!documentImage(
    document: cons!HERO_IMAGE_DOC,
    altText: "Company headquarters"
  )
)
```

---

### a!userImage
**Purpose**: References a user's profile image

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `user` | User | User identifier |
| `altText` | Text | Alternative text for accessibility |

---

### a!webVideo
**Purpose**: References a video from a web URL for use in billboardLayout

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `source` | Text | URL of the video file |

---

## Link Components

### a!safeLink
**Purpose**: Creates a link to an external URL that opens in a new tab/window

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `uri` | Text | The external URL to link to |
| `label` | Text | Accessible label for the link |

**Usage Example**:
```sail
a!richTextItem(
  text: "Read our policies",
  link: a!safeLink(
    uri: "https://example.com/policies",
    label: "Company policies"
  ),
  linkStyle: "INLINE"
)
```

**Note**: Opens links in a new window/tab for security

---

### a!recordLink
**Purpose**: Creates a link to an Appian record

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `record` | Record | Record identifier |
| `label` | Text | Optional accessible label |

**Usage Example**:
```sail
a!richTextItem(
  text: fv!row.caseId,
  link: a!recordLink(record: fv!row),
  linkStyle: "STANDALONE"
)
```

**Note**: Used for navigation to record views within Appian

---

## Rich Text List Components

### a!richTextBulletedList
**Purpose**: Creates a bulleted list within rich text display

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | List of Text/RichTextItem | List items (can be plain text or styled richTextItems) |

**Usage Example**:
```sail
a!richTextDisplayField(
  value: a!richTextBulletedList(
    items: {
      "First item",
      "Second item",
      a!richTextItem(text: "Bold item", style: "STRONG")
    }
  )
)
```

---

### a!richTextNumberedList
**Purpose**: Creates a numbered list within rich text display

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | List of Text/RichTextItem | List items (can be plain text or styled richTextItems) |

**Usage Example**:
```sail
a!richTextDisplayField(
  value: a!richTextNumberedList(
    items: {
      "Step one",
      "Step two",
      "Step three"
    }
  )
)
```

---

## Grid Helper Components

### a!sortInfo
**Purpose**: Defines initial or secondary sorting for grid fields

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `field` | Text | Field name to sort by (must match a column's sortField) |
| `ascending` | Boolean | Sort direction (true = ascending, false = descending) |

**Usage Example**:
```sail
a!gridField(
  data: local!data,
  columns: {/* columns */},
  initialSorts: {
    a!sortInfo(field: "dateFiled", ascending: false)
  },
  secondarySorts: {
    a!sortInfo(field: "amount", ascending: false)
  }
)
```

---