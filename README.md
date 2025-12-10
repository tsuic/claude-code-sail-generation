# Claude Code SAIL Generation

This tool generates Appian SAIL UI expressions from natural language requests.

## Instructions for App Developers (use this tool to generate UIs)
### Getting Started
1. [Clone this repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
2. [Install and set up Claude Code](https://docs.claude.com/en/docs/claude-code/setup)
3. For best performance, connect to the Appian VPN while using this project ([See why](#validation-approaches))
4. Open a terminal window and navigate to the root folder for this repo
5. Launch Claude Code by typing: `claude`
6. Grant any permissions that Claude Code asks for

### (Optional + Recommended) Use with Visual Studio Code
If you want to use an IDE instead of the command line:
1. [Install Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)
2. Launch VS Code
3. [Install Claude Code extension for VS Code](https://docs.claude.com/en/docs/claude-code/vs-code#installation)
4. [Install GitHub extension for VS Code](https://code.visualstudio.com/docs/sourcecontrol/github)
5. Open the root folder for this repo in VS Code Explorer
6. Click the Claude icon on the top bar to open a Claude Code tab

### Additional Tips
1. To stay up-to-date with the latest project enhancements, pull from this repo

### Generating a SAIL Mockup

This project generates SAIL expressions with hard-coded sample data that you can paste into Appian Interface Designer.

#### Making Requests

You can be as vague or as specific as you'd like:

**Vague:**
> "Make a case management dashboard"

**Detailed:**
> "A large insurance provider seeks a case management UI for handling customer claims. The target personas are claims adjusters and supervisors who need to review case files, track progress, and approve settlements. The UI should present a case summary panel, associated documents, and communication history in a structured, easy-to-navigate layout. Search and filtering tools are required for handling large volumes of claims, with inline editing for status updates and role-based access to sensitive data."

**Specific Layout Instructions:**
> "Create an alerts inbox page. Use a pane layout: a MEDIUM-width left pane for the list of alerts and an AUTO-width pane for viewing the selected alert. Use a card layout with a decorative bar to represent each alert in the list..."

#### Testing and Iteration

1. Copy the generated expression from `/output` folder
2. Paste into Appian Interface Designer
3. If errors occur, paste the error message into Claude Code for automatic fixes
4. Request adjustments through chat:
   > "Increase the spacing between the KPI cards"

   > "Change the grid to show 10 rows per page"

   > "Add a filter dropdown for status"


### Converting Mockup to Functional Interface

Once satisfied with your static mockup, convert it to use live Appian record data.

#### Conversion Commands

> "Now, make this functional"

> "Convert the mock data to record queries"

> "Connect this to our Case record type"

Or generate and convert in one request:
> "Create a case dashboard with a grid showing title, description, status, and priority. After mocking it up, hook it up to Case record data."

#### How Conversion Works

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

#### Pre-Requisite: Data Model Context

**Required:** Edit `/context/data-model-context.md` with your data model details:
- Record type names and UUIDs
- Field names and UUIDs
- Relationships between record types
- Field data types (Text, Number, Date, DateTime, etc.)

### Validation Approaches

Claude Code validates generated SAIL expressions using different approaches:

#### With VPN Connection (Recommended)
**Approach:** Calls SAIL validation MCP server on Appian instance

**Benefits:**
- Fast, accurate syntax validation
- Catches all SAIL-specific errors
- Same validation as Appian uses

**Setup:**
1. Connect to Appian VPN
2. Add MCP server permissions to `.claude/settings.local.json` (Optional, suppresses permission prompts each time tool is called):

```json
{
  "permissions": {
    "allow": [
      "Bash",
      "Bash(curl -X POST http://appn-mcp.custom-ai.appian-internal.com:8000/upload -F \"file=@/Users/charles.tsui/Documents/SAIL-Generation/output/*\")"
    ]
  },
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["appian-mcp-server"]
}
```

3. Issue the `/mcp status` command in Claude Code to make sure that the Appian server is connnected (if not, try quitting VSCode/Claude code and restarting after conecting to VPN).

#### Without VPN Connection
**Approach:** Uses specialized validation sub-agents

**Process:**
1. `sail-schema-validator` - Validates function syntax and parameters
2. `sail-icon-validator` - Checks icon names against valid aliases
3. `sail-code-reviewer` - Validates structure and best practices

**Note:** Sub-agent validation is thorough but not as reliable as MCP server validation.

**This project uses named anchors** (`{#anchor-name}`) for cross-references between documentation files. This approach is more maintainable than line numbers because anchors remain stable when content is added or removed.

**Anchor format:**
```markdown
## Section Title {#anchor-name}
```

**Reference format:**
```markdown
See record-type-handling-guidelines.md #anchor-name
```

**Files with anchor-based cross-references:**
- `.claude/agents/sail-dynamic-converter.md` - References guideline files using anchors
- `logic-guidelines/null-safety-quick-ref.md` - References guideline sections
- `dynamic-behavior-guidelines/dynamic-sail-expression-guidelines.md` - Internal cross-references
- `dynamic-behavior-guidelines/record-type-handling-guidelines.md` - Internal cross-references

**Available anchors:**

| File | Anchor | Section |
|------|--------|---------|
| dynamic-sail-expression-guidelines.md | `#nav-index` | Quick Navigation Index |
| dynamic-sail-expression-guidelines.md | `#short-circuit-rules` | Short-Circuit Evaluation Rules |
| dynamic-sail-expression-guidelines.md | `#foreach-local-variables` | Local Variable Scope in Nested Contexts |
| dynamic-sail-expression-guidelines.md | `#null-safety-implementation` | Null Safety Implementation |
| record-type-handling-guidelines.md | `#nav-index` | Quick Navigation Index |
| record-type-handling-guidelines.md | `#rule-input-pattern` | Rule Input Pattern |
| record-type-handling-guidelines.md | `#handling-non-existent-constants` | Handling Non-Existent Constants |
| record-type-handling-guidelines.md | `#unused-variables-decision-tree` | Documenting Unused Variables |
| record-type-handling-guidelines.md | `#short-circuit-rules` | Short-Circuit Evaluation Rules |
| record-type-handling-guidelines.md | `#null-safety-implementation` | Null Safety Implementation |
| record-type-handling-guidelines.md | `#datetime-critical-rules` | Date/Time Critical Rules |

**Extracted Topic Files (smaller, focused documentation):**

| Folder | File | Description |
|--------|------|-------------|
| logic-guidelines/ | `short-circuit-evaluation.md` | Why if() vs and()/or() for null safety |
| logic-guidelines/ | `null-safety-quick-ref.md` | Quick pattern lookup table |
| logic-guidelines/ | `null-safety-patterns.md` | Detailed null safety implementation examples |
| logic-guidelines/ | `functions-reference.md` | Essential functions by category |
| logic-guidelines/ | `datetime-handling.md` | Date/time type matching & operators |
| logic-guidelines/ | `foreach-patterns.md` | fv! variables, parallel array pattern |
| logic-guidelines/ | `grid-selection-patterns.md` | Two-variable approach, naming conventions |
| logic-guidelines/ | `checkbox-patterns.md` | Multi-checkbox, single checkbox initialization |
| logic-guidelines/ | `pattern-matching.md` | a!match() for status/category lookups |
| logic-guidelines/ | `chart-configuration.md` | Chart components, mock data patterns |
| record-query-guidelines/ | `query-result-structures.md` | Property access by query type |
| record-query-guidelines/ | `form-interface-patterns.md` | ri! pattern, testing simulation |
| record-query-guidelines/ | `one-to-many-management.md` | Relationship data in forms |
| record-query-guidelines/ | `user-group-fields.md` | User/Group fields vs relationships |
| record-query-guidelines/ | `query-filters-operators.md` | Filter patterns, nesting rules |
| record-query-guidelines/ | `kpi-aggregation-patterns.md` | Dashboard aggregations |

**Adding new anchors:**
When creating a new section that may be referenced elsewhere, add an anchor:
```markdown
## New Important Section {#new-section-anchor}
```

**Why this matters:** Agents use these anchors to efficiently navigate to specific documentation sections. Named anchors are stable across file edits, unlike line numbers which shift when content changes.