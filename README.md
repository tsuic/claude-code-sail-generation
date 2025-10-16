# Claude Code SAIL Generation

## Getting Started
1. Clone this repo
2. [Install and set up Claude Code](https://docs.claude.com/en/docs/claude-code/setup)
3. Open Terminal and navigate to the root folder for this repo
4. Launch Claude Code by typing: `claude`
5. Grant any permissions that Claude Code asks for

## Generating a SAIL Mockup
This project's primary goal is to generate a SAIL expression representing a UI mockup with hard-coded sample data.

You can be as vague or as specific as you'd like in your request:

> "Make a case management dashboard"

> "A large insurance provider seeks a case management UI for handling customer claims. The target personas are claims adjusters and supervisors who need to review case files, track progress, and approve settlements. The UI should present a case summary panel, associated documents, and communication history in a structured, easy-to-navigate layout. Search and filtering tools are required for handling large volumes of claims, with inline editing for status updates and role-based access to sensitive data."

> "Create an alerts inbox page. Use a pane layout: a MEDIUM-width left pane for the list of alerts and an AUTO-width pane for viewing the selected alert. Use a card layout with a decorative bar to represent each alert in the list..."

Claude Code will think about your request, plan its approach, write the expression, and then pass it through a code reviewer sub-agent (called `sail-syntax-validator`). The final expression will be saved in the `/outputs` folder. Copy and paste the expression into Interface Designer to test.

If you encounter an error, paste the error message into Claude Code and it will attempt to fix.

If you want to make an adjustment, just chat your request:

> "Increase the spacing between the KPI cards"

## Generating a Functional SAIL UI
This project includes a sub-agent (`sail-dynamic-converter`) designed to convert hard-coded sample data into record queries.

When you are satisfied with the static mockup, you can ask Claude Code to turn it into a functional UI:

> "Now, make this functional"

> "Convert the mock data to record queries"

You can also make a single request ask Claude to make a mockup and then make it functional:
> "Create a case dashboard containing a grid with columns for title, description, status, and priority. After mocking it up, hook it up to record data."

### Pre-Requisite: Data Model Context
In order to successfully inject record queries into the expression, Claude must know enough about the data model: record types, fields, UUIDs.

Because this project isn't running in Appian and we don't yet have a tool call for fetching the data model, this context must be specified in a markdown file. Edit `/context/data-model-context.md`, making sure to preserve the structure of the example, to include details of your data model.
