# Quick Setup Guide

## Install the `/plugin` Command

### Option 1: Global Installation (Recommended)

Install the `/plugin` command globally to use it from any project:

```bash
# Clone the marketplace
git clone https://github.com/Piscatore/claude-plugin-marketplace.git
cd claude-plugin-marketplace

# Copy to global Claude commands directory
mkdir -p ~/.claude/commands
cp .claude/commands/plugin.md ~/.claude/commands/
```

Now you can use `/plugin` from any Claude Code session!

### Option 2: Project-Specific Installation

Install the command for a single project:

```bash
# In your project directory
mkdir -p .claude/commands

# Download the command file
curl -o .claude/commands/plugin.md https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/.claude/commands/plugin.md
```

Or if you've already cloned the marketplace:

```bash
# In your project directory
mkdir -p .claude/commands
cp /path/to/claude-plugin-marketplace/.claude/commands/plugin.md .claude/commands/
```

## Using the Plugin Marketplace

Once installed, the `/plugin` command works from anywhere:

```bash
# List all available plugins
/plugin

# Search for documentation-related plugins
/plugin search documentation

# Show details about a specific plugin
/plugin show doc-maintainer

# Install a plugin to your current project
/plugin install doc-maintainer
```

## How It Works

The `/plugin` command:
1. Fetches the latest plugin registry from GitHub
2. Allows you to browse, search, and view plugin details
3. Downloads and installs plugins to `.claude/context/plugins/` in your project
4. No need to clone the marketplace repository!

## Marketplace URL

Repository: https://github.com/Piscatore/claude-plugin-marketplace

The command automatically fetches data from:
- Registry: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins.json`
- Plugins: `https://raw.githubusercontent.com/Piscatore/claude-plugin-marketplace/main/plugins/<filename>`

## Troubleshooting

**Command not found?**
- Make sure you copied `plugin.md` to either `~/.claude/commands/` or `.claude/commands/`
- Restart your Claude Code session

**Can't fetch plugins?**
- Check your internet connection
- The marketplace repository is public and doesn't require authentication

**Plugin not installing?**
- The command creates `.claude/context/plugins/` automatically
- Check that you have write permissions in your project directory
