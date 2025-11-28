You are managing the Claude Plugin Marketplace. The user has invoked the `/plugin` command.

## Available Commands

Parse the user's command to determine the action:

- `/plugin list` or `/plugin` - List all available plugins
- `/plugin search <query>` - Search plugins by name, description, or tags
- `/plugin show <plugin-id>` - Show detailed information about a specific plugin
- `/plugin install <plugin-id>` - Install a plugin

## Plugin Registry

The plugin registry is located at: `plugins.json`

Read this file to get the list of available plugins and their metadata.

## Command Actions

### List Plugins (`/plugin list` or `/plugin`)

1. Read `plugins.json`
2. Display a formatted table of all available plugins:
   ```
   Available Claude Plugins:

   ID                | Name                      | Version | Category     | Description
   ------------------|---------------------------|---------|--------------|------------------------------------------
   doc-maintainer    | Documentation Maintainer  | 1.1.0   | productivity | Specialized agent for documentation...
   ```
3. Show usage hint: "Use `/plugin show <id>` for details or `/plugin install <id>` to install"

### Search Plugins (`/plugin search <query>`)

1. Read `plugins.json`
2. Search through plugin name, description, tags, and capabilities
3. Display matching plugins in the same table format
4. If no matches: "No plugins found matching '<query>'"

### Show Plugin Details (`/plugin show <plugin-id>`)

1. Read `plugins.json`
2. Find the plugin by ID
3. Display detailed information:
   ```
   Plugin: Documentation Maintainer
   ID: doc-maintainer
   Version: 1.1.0
   Category: productivity
   Author: AgentPlugins

   Description:
   [Full description]

   Capabilities:
   - [List capabilities]

   Operating Modes:
   - [List operating modes]

   Use Cases:
   - [List use cases]

   Tags: documentation, maintenance, indexing, consistency

   To install: /plugin install doc-maintainer
   ```
4. If plugin not found: "Plugin '<plugin-id>' not found. Use `/plugin list` to see available plugins."

### Install Plugin (`/plugin install <plugin-id>`)

1. Read `plugins.json`
2. Find the plugin by ID
3. Read the plugin file from the `file` path specified in the registry
4. Determine installation location:
   - Check if `.claude/context/` directory exists in current working directory
   - If yes: Install to `.claude/context/plugins/<plugin-id>.md`
   - If no: Create `.claude/context/plugins/` directory first
5. Write the plugin file to the installation location
6. Display success message:
   ```
   ✓ Installed plugin: <name> (v<version>)
   Location: .claude/context/plugins/<plugin-id>.md

   This plugin is now available in your Claude Code context.
   Restart Claude Code or reload the context to activate.
   ```
7. If plugin not found: "Plugin '<plugin-id>' not found. Use `/plugin list` to see available plugins."

## Error Handling

- If `plugins.json` is not found: "Plugin marketplace not initialized. Clone the repository first."
- If no command or invalid command: Show help message with available commands
- For all file operations, handle errors gracefully with clear messages

## Important Notes

- Always read from `plugins.json` for the latest plugin information
- The registry file path is relative to the current working directory
- Plugin files are stored in the `plugins/` directory
- Installation creates the `.claude/context/plugins/` directory if needed
- Use the Read and Write tools for file operations
- Keep output concise and well-formatted using markdown tables
