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


## Instructors for Contributors (improve this tool)

### Loading Full Project Context Before Making Changes

Before making substantial changes to project instructions or agent workflows, load the complete project context so Claude understands the entire system architecture and cross-references.

**Simple One-Line Request:**

For most changes, this is sufficient:

```
I'm planning to modify [specific file/section]. Please load full project context and check for cross-references.
```

Claude will automatically:
- Read CLAUDE.md (already loaded via Claude Code)
- Identify which guideline files are relevant based on your changes
- Search for cross-references to the section you're modifying
- Check for line number references that might be affected

**When You Need More Control:**

If you want to verify a specific area before making changes:

```
Before I modify [section name], show me:
1. All files that reference this section
2. Any line number references that point here
3. What might break if I add/remove content
```

**Example Workflow:**

```
User: I'm adding a new validation rule to the Universal SAIL Validation Checklist.
      Please load full project context and check for cross-references.

Claude: [Reads CLAUDE.md, searches for references to that section]
        Found 1 cross-reference in sail-dynamic-converter.md line 49.
        Ready to proceed. What validation rule are you adding?
```

**Pro Tip:** If unsure what might be affected, ask:

```
What would be impacted if I change [section/file name]?
```

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