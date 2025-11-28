# Claude Plugin Marketplace

A curated collection of specialized agent plugins for Claude Code that extend capabilities with domain-specific workflows and behaviors.

## What are Claude Plugins?

Claude Plugins are specialized agent specifications that define focused behaviors for specific tasks like documentation maintenance, code review, testing, and more. They work alongside the main Claude Code agent via the Task tool.

## Quick Start

### Using the `/plugin` Command

This repository includes a built-in `/plugin` command for browsing and installing plugins:

```bash
/plugin              # List all available plugins
/plugin list         # List all available plugins
/plugin search <query>   # Search for plugins
/plugin show <id>    # Show detailed plugin information
/plugin install <id> # Install a plugin to your project
```

### Manual Installation

1. Clone this repository
2. Copy desired plugin files from `plugins/` to your project's `.claude/context/plugins/` directory
3. Restart Claude Code or reload context

## Available Plugins

| Plugin ID | Name | Version | Category | Description |
|-----------|------|---------|----------|-------------|
| doc-maintainer | Documentation Maintainer | 1.1.0 | productivity | Specialized agent for documentation indexing, updating, and consistency checking |

Use `/plugin show <id>` for detailed information about each plugin.

## Plugin Structure

Each plugin is a markdown specification file that defines:

- **Core Responsibilities** - What the agent does
- **Operating Modes** - Different modes of operation
- **Workflows** - Step-by-step processes for scenarios
- **Tool Usage Guidelines** - How to use Claude Code tools
- **Anti-Patterns** - What NOT to do
- **Example Interactions** - Reference examples

## Contributing Plugins

To add a new plugin to the marketplace:

1. Create your plugin specification in `plugins/<plugin-id>.md`
2. Add metadata to `plugins.json`:

```json
{
  "id": "your-plugin-id",
  "name": "Your Plugin Name",
  "version": "1.0.0",
  "description": "Brief description of what your plugin does",
  "author": "Your Name",
  "tags": ["tag1", "tag2"],
  "file": "plugins/your-plugin-id.md",
  "category": "productivity",
  "capabilities": [
    "Capability 1",
    "Capability 2"
  ],
  "useCases": [
    "Use case 1",
    "Use case 2"
  ]
}
```

3. Update the README table (or use `/plugin list` to generate it)
4. Submit a pull request

## Plugin Categories

- **productivity** - Tools for improving development workflow and efficiency
- **code-quality** - Tools for code review, testing, and quality assurance
- **documentation** - Tools for managing and maintaining documentation
- **security** - Tools for security analysis and vulnerability detection
- **devops** - Tools for deployment, CI/CD, and infrastructure

## Using Plugins in Claude Code

Once installed, reference plugins in your conversations:

```
User: "Use the doc-maintainer plugin to audit my documentation"
Claude: [Loads and follows the doc-maintainer plugin specification]
```

Or use the Task tool to delegate to specialized agents:

```python
# In Claude Code
Task(
    subagent_type="doc-maintainer",
    prompt="Run a consistency audit on the documentation"
)
```

## Repository Structure

```
claude-plugin-marketplace/
├── plugins/                    # Plugin specification files
│   └── doc-maintainer.md
├── .claude/
│   └── commands/
│       └── plugin.md          # /plugin command implementation
├── plugins.json               # Plugin registry and metadata
└── README.md                  # This file
```

## Version

Marketplace Version: 1.0.0
Last Updated: 2025-11-28

## License

[Your chosen license]
