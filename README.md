# Claude Code SAIL Generation

This tool generates Appian SAIL UI expressions from natural language requests.

## Getting Started
1. [Clone this repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
2. [Install and set up Claude Code](https://docs.claude.com/en/docs/claude-code/setup)
3. Open a terminal window and navigate to the root folder for this repo
4. Launch Claude Code by typing: `claude`
5. Grant any permissions that Claude Code asks for

## (Optional + Recommended) Use with Visual Studio Code
If you want to use an IDE instead of the command line:
1. [Install Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)
2. Launch VS Code
3. [Install Claude Code extension for VS Code](https://docs.claude.com/en/docs/claude-code/vs-code#installation)
4. [Install GitHub extension for VS Code](https://code.visualstudio.com/docs/sourcecontrol/github)
5. Open the root folder for this repo in VS Code Explorer
6. Click the Claude icon on the top bar to open a Claude Code tab

## Additional Tips
1. To stay up-to-date with the latest project enhancements, pull from this repo
2. For best performance, connect to the Appian VPN while using this project ([See why](#validation-approaches))

## Documentation Structure

This project uses a hierarchical documentation approach:

### Quick Reference
- **`claude.md`** - High-level syntax rules, quick patterns, and pointers to detailed guides
  - Use this for: Quick syntax checks, understanding what's available
  - Core topics: Syntax requirements, component selection, layout patterns

### Comprehensive Guides
- **`/dynamic-behavior-guidelines/dynamic-sail-expression-guidelines.md`** - Complete guide for foundational SAIL expression patterns
  - Use this for: Arrays, loops, null safety, grid selection, dynamic forms, conditional logic
  - **This is the authoritative source** for all dynamic SAIL patterns (both mock and functional interfaces)

- **`/dynamic-behavior-guidelines/record-type-handling-guidelines.md`** - Complete guide for SAIL with record types
  - Use this for: Record queries, relationships, form patterns with ri!, data management

### Component Documentation
- **`/ui-guidelines/`** - Component-specific instructions and patterns
  - `0-sail-component-reference.md` - Parameter reference for all components
  - `3-*-layout-instructions.md` - Layout component guides
  - `4-*-instructions.md` - Display component guides
  - `/patterns/` - Ready-to-use UI patterns (KPIs, cards, tabs, messages)

### Key Concepts
- **Single Source of Truth**: dynamic-sail-expression-guidelines.md is the authoritative guide; claude.md points to it
- **Read Before Writing**: Always check component docs before using unfamiliar components
- **Pattern Matching**: Use `a!match()` for status/category lookups (see dynamic-sail-expression-guidelines.md section "Using a!match() for Status-Based Lookups")
- **Null Safety**: SAIL's `and()`/`or()` don't short-circuit; use `if()` for null checks (see dynamic-sail-expression-guidelines.md section "Short-Circuit Evaluation Rules")

## Generating a SAIL Mockup

This project generates SAIL expressions with hard-coded sample data that you can paste into Appian Interface Designer.

### Making Requests

You can be as vague or as specific as you'd like:

**Vague:**
> "Make a case management dashboard"

**Detailed:**
> "A large insurance provider seeks a case management UI for handling customer claims. The target personas are claims adjusters and supervisors who need to review case files, track progress, and approve settlements. The UI should present a case summary panel, associated documents, and communication history in a structured, easy-to-navigate layout. Search and filtering tools are required for handling large volumes of claims, with inline editing for status updates and role-based access to sensitive data."

**Specific Layout Instructions:**
> "Create an alerts inbox page. Use a pane layout: a MEDIUM-width left pane for the list of alerts and an AUTO-width pane for viewing the selected alert. Use a card layout with a decorative bar to represent each alert in the list..."

### Generation Process

Claude Code will:
1. **Plan** the UI structure and components
2. **Read documentation** from `/ui-guidelines/` and `/dynamic-behavior-guidelines/` as needed
3. **Generate** the SAIL expression following all syntax rules
4. **Validate** using MCP server (if on VPN) or sub-agents
5. **Save** to `/output` folder

### Testing and Iteration

1. Copy the generated expression from `/output` folder
2. Paste into Appian Interface Designer
3. If errors occur, paste the error message into Claude Code for automatic fixes
4. Request adjustments through chat:
   > "Increase the spacing between the KPI cards"

   > "Change the grid to show 10 rows per page"

   > "Add a filter dropdown for status"

### Common Patterns Generated

Claude Code has built-in knowledge of common UI patterns:
- **KPIs and Metrics** - Card-based layouts with icons and trend indicators
- **Data Tables** - Grids with sorting, filtering, and selection
- **Card Lists** - User lists, task lists, message lists with stamps and tags
- **Forms** - Multi-column layouts with proper field grouping
- **Dashboards** - Header-content layouts with KPIs and grids
- **Status Indicators** - Uses `a!match()` for dynamic colors/icons based on status

## Converting Mockup to Functional Interface

Once satisfied with your static mockup, convert it to use live Appian record data.

### Conversion Commands

> "Now, make this functional"

> "Convert the mock data to record queries"

> "Connect this to our Case record type"

Or generate and convert in one request:
> "Create a case dashboard with a grid showing title, description, status, and priority. After mocking it up, hook it up to Case record data."

### How Conversion Works

The `sail-dynamic-converter` agent:
1. **Reads** your static SAIL mockup
2. **Consults** `/context/data-model-context.md` for record type UUIDs and field references
3. **Applies** patterns from `record-type-handling-guidelines.md`:
   - Replaces `local!` arrays with `a!queryRecordType()` or `a!recordData()`
   - Converts form fields to use `ri!` rule input pattern
   - Adds null-safe field access patterns
   - Implements relationship navigation syntax
4. **Validates** the converted expression
5. **Ensures completeness** - ALL steps, sections, and fields are converted (no partial conversions)

### Pre-Requisite: Data Model Context

**Required:** Edit `/context/data-model-context.md` with your data model details:
- Record type names and UUIDs
- Field names and UUIDs
- Relationships between record types
- Field data types (Text, Number, Date, DateTime, etc.)

**Example:**
```markdown
## Record Types

### Case
- UUID: `{abc-123-def}`
- Fields:
  - title (Text): `{field-uuid-1}`
  - status (Text): `{field-uuid-2}`
  - priority (Text): `{field-uuid-3}`
- Relationships:
  - assignee → User (many-to-one)
```

**Critical:** The converter NEVER invents UUIDs or field names - it only uses what's documented in `data-model-context.md`.

## Understanding Generated Code

### Code Organization

All generated SAIL expressions follow this structure:

```sail
a!localVariables(
  /* 1. Local variable declarations */
  local!data: {...},
  local!selectedItems,

  /* 2. Main interface (last parameter) */
  a!headerContentLayout(
    /* UI components */
  )
)
```

### Key Patterns to Recognize

**Pattern Matching with `a!match()`:**
```sail
/* Status-based styling */
backgroundColor: a!match(
  value: fv!row.status,
  equals: "Active", then: "#10B981",
  equals: "Pending", then: "#F59E0B",
  equals: "Closed", then: "#6B7280",
  default: "TRANSPARENT"
)
```

**Null-Safe Property Access:**
```sail
/* Use if(), NOT and() - and() doesn't short-circuit! */
showWhen: if(
  a!isNotNullOrEmpty(local!selectedItem),
  local!selectedItem.type = "Contract",
  false
)
```

**Grid Selection (Two-Variable Pattern):**
```sail
/* Store both IDs and full data */
local!selectedTaskIds,          /* Just the IDs */
local!selectedTasks: a!forEach(  /* Full task data */
  items: local!selectedTaskIds,
  expression: index(local!allTasks, wherecontains(...), null)
)
```

### Common Syntax Rules

- ✅ `and(condition1, condition2)` NOT `condition1 and condition2`
- ✅ `or(condition1, condition2)` NOT `condition1 or condition2`
- ✅ Use `if()` for null-safe comparisons, NOT `and()`
- ✅ Comments: `/* comment */` NOT `// comment`
- ✅ Escape quotes: `""` NOT `\"`
- ✅ Grid columns: Only `fv!row` available, NOT `fv!index`

### When You See Errors

**"Variable not defined"**
→ Check that all variables are declared in `a!localVariables()`

**"Invalid index: Cannot index property of Null"**
→ Add null checking with `if()` before property access

**"Function does not exist"**
→ Verify function exists in `/validation/sail-api-schema.json`

**Type mismatch errors**
→ Check Date vs DateTime types, wrap date arithmetic in `todate()`

For detailed troubleshooting, see:
- Mock interfaces: `/dynamic-behavior-guidelines/dynamic-sail-expression-guidelines.md` section "Quick Troubleshooting" and "Syntax Validation Checklist"
- Functional interfaces: `/dynamic-behavior-guidelines/record-type-handling-guidelines.md` section "Quick Troubleshooting" and "Syntax Validation Checklist"

## Validation Approaches

Claude Code validates generated SAIL expressions using different approaches:

### With VPN Connection (Recommended)
**Approach:** Calls SAIL validation MCP server on Appian instance

**Benefits:**
- Fast, accurate syntax validation
- Catches all SAIL-specific errors
- Same validation as Appian uses

**Setup:**
1. Connect to Appian VPN
2. Add MCP server permissions to `.claude/settings.local.json`

```json
{
  "permissions": {
    "allow": [
      "Bash(curl -X POST http://10.34.49.30:8000/upload -F \"file=@/path/to/your/repo/output/*\")"
    ]
  },
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["appian-mcp-server"]
}
```

### Without VPN Connection
**Approach:** Uses specialized validation sub-agents

**Process:**
1. `sail-schema-validator` - Validates function syntax and parameters
2. `sail-icon-validator` - Checks icon names against valid aliases
3. `sail-code-reviewer` - Validates structure and best practices

**Note:** Sub-agent validation is thorough but not as comprehensive as MCP server validation.

### Validation Coverage

Both approaches check:
- ✅ Function names and parameter counts
- ✅ Parameter value enumerations (e.g., button styles, colors)
- ✅ Component nesting rules (no sideBySide inside sideBySide)
- ✅ Icon alias validity
- ✅ Syntax structure (parentheses, quotes, commas)
- ✅ Record type reference format (when using functional interfaces)

The MCP server additionally validates:
- ✅ SAIL expression evaluation
- ✅ Runtime type checking
- ✅ More nuanced syntax errors

## 📌 Important Notes for Contributors

### Line Number Cross-References

**This project is under active development** and documentation changes are expected and encouraged. However, several files contain cross-references to specific line numbers in other files to help agents navigate efficiently.

**Files with line number cross-references:**
- `.claude/agents/sail-dynamic-converter.md` - References CLAUDE.md, dynamic-sail-expression-guidelines.md, record-type-handling-guidelines.md, and ui-guidelines files
- `CLAUDE.md` - References dynamic-sail-expression-guidelines.md and record-type-handling-guidelines.md navigation indexes
- `dynamic-behavior-guidelines/dynamic-sail-expression-guidelines.md` - Internal cross-references to its own sections
- `dynamic-behavior-guidelines/record-type-handling-guidelines.md` - Internal cross-references to its own sections

**⚠️ After editing these files:**

If you make substantial changes (adding/removing sections, restructuring content) to any of the files listed above, **ask Claude to update all line number references** before committing:

> "I just updated [filename]. Can you check and update any line number references in the project that might have changed?"

Claude will search for references like `lines 190-370` or `line 1748` across the project and verify they still point to the correct sections.

**Why this matters:** Agents use these line references to efficiently read specific documentation sections. Outdated references can cause agents to read wrong sections, leading to code generation errors.