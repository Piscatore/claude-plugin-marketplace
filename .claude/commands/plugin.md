You are managing the Claude Plugin Marketplace. The user has invoked the `/plugin` command.

## Available Commands

Parse the user's command to determine the action:

- `/plugin list` or `/plugin` - List all available plugins
- `/plugin search <query>` - Search plugins by name, description, or tags
- `/plugin show <plugin-id>` - Show detailed information about a specific plugin
- `/plugin install <plugin-id>` - Install a plugin

## Plugin Registry

The plugin registry can be accessed in two ways:

1. **Local** (if in the marketplace repo): Read `plugins.json`
2. **Remote** (from any project): Fetch from GitHub
   - Registry URL: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins.json`
   - Plugin files: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins/<filename>`

**Always try the remote URL first** using the WebFetch tool. Only fall back to local file if WebFetch fails.

## Command Actions

### List Plugins (`/plugin list` or `/plugin`)

1. Fetch the plugin registry (remote first, then local fallback)
2. Display a formatted table of all available plugins:
   ```
   Available Claude Plugins:

   ID                | Name                      | Version | Category     | Description
   ------------------|---------------------------|---------|--------------|------------------------------------------
   doc-maintainer    | Documentation Maintainer  | 1.1.0   | productivity | Specialized agent for documentation...
   ```
3. Show usage hint: "Use `/plugin show <id>` for details or `/plugin install <id>` to install"

### Search Plugins (`/plugin search <query>`)

1. Fetch the plugin registry (remote first, then local fallback)
2. Search through plugin name, description, tags, and capabilities
3. Display matching plugins in the same table format
4. If no matches: "No plugins found matching '<query>'"

### Show Plugin Details (`/plugin show <plugin-id>`)

1. Fetch the plugin registry (remote first, then local fallback)
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

1. Fetch the plugin registry (remote first, then local fallback)
2. Find the plugin by ID
3. Fetch the plugin file:
   - **Remote**: Use WebFetch with `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins/<filename>`
   - **Local fallback**: Read from the `file` path specified in the registry
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

- If registry fetch fails (both remote and local): "Unable to access plugin marketplace. Check your internet connection or ensure you're in the marketplace repository."
- If no command or invalid command: Show help message with available commands
- For all file operations, handle errors gracefully with clear messages

## Important Notes

- **Always fetch from GitHub first** using WebFetch for the registry and plugin files
- Only fall back to local files if WebFetch fails
- Registry URL: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins.json`
- Plugin URL pattern: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins/<filename>`
- Installation creates the `.claude/context/plugins/` directory if needed
- Use WebFetch for remote access, Read/Write for local operations
- Keep output concise and well-formatted using markdown tables
