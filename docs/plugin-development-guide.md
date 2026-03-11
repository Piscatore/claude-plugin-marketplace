# Plugin Development Guide

This guide covers everything you need to know to create a new plugin for the Claude Plugin Marketplace. For a quick overview, see the "Contributing Plugins" section in [README.md](../README.md). For the full contributor workflow, see [CONTRIBUTING.md](../CONTRIBUTING.md).

## What is a Claude Code Plugin?

A Claude Code plugin is a specialized agent specification written in Markdown. When a user installs and invokes your plugin, Claude Code loads your agent spec into its context and follows the instructions you defined. Your spec shapes Claude's behavior for a specific domain or task.

Plugins are not executable code. They are structured instructions -- think of them as a detailed briefing document that tells an expert exactly how to approach a category of work.

## Plugin Structure

Every plugin needs at minimum two files:

```
your-plugin-id/
├── plugin.json          # Metadata: name, version, description, author
└── agents/
    └── your-agent.md    # The agent specification (the actual plugin logic)
```

### plugin.json

```json
{
  "name": "your-plugin-id",
  "version": "1.0.0",
  "description": "One-line description of what your plugin does",
  "author": {
    "name": "Your Name"
  },
  "agents": ["./agents/"]
}
```

- `name`: Lowercase, hyphenated. Must match your directory name.
- `version`: Semver. Increment on every change.
- `description`: Shown in plugin listings. Be specific about what the plugin does and when to use it.
- `agents`: Array of paths to agent directories. Usually `["./agents/"]`.

### Agent Specification (agents/your-agent.md)

This is the core of your plugin. It tells Claude how to behave when your plugin is active.

## Writing an Effective Agent Spec

### Essential Sections

Every agent spec should include:

**1. Identity and purpose** (top of file)

```markdown
# Your Agent Name

You are a specialized agent that [does what]. Your role is to [purpose].
```

**2. Core responsibilities**

What the agent is responsible for, as a numbered list. Be specific.

**3. Operating modes** (if applicable)

If your agent behaves differently in different contexts, define explicit modes. Each mode should have: a name, when to use it, what it does, and what constraints apply.

**4. Workflows**

Step-by-step processes for the agent's key tasks. Number each step. Include decision points and branching logic.

**5. Tool usage**

Which Claude Code tools (Read, Write, Edit, Glob, Grep, Bash, WebSearch, etc.) the agent should use and when. Be explicit about which tools are allowed in which modes.

**6. Anti-patterns**

What the agent should NOT do. These are as important as the positive instructions. Common anti-patterns:
- Making changes without user approval
- Overstepping scope boundaries
- Making assumptions instead of investigating
- Creating new files when existing ones should be updated

**7. Version footer**

```markdown
## Version

Agent Version: 1.0.0
Last Updated: YYYY-MM-DD
Compatible with: Claude Code (any version)
```

### Writing Tips

- **Be explicit over implicit.** Claude follows instructions literally. If you mean "never modify files in the `src/` directory", say exactly that -- don't assume Claude will infer scope boundaries.
- **Use tables for structured information.** Decision matrices, severity levels, and feature comparisons are clearer as tables than prose.
- **Define terms.** If your agent uses domain-specific terminology, define it. Claude will use your definitions consistently.
- **Include constraints with every capability.** For each thing the agent can do, state when it should NOT do it.
- **Test with real scenarios.** Invoke your plugin in Claude Code and try edge cases. Refine the spec based on how Claude actually behaves.

### Context Window Considerations

Agent specs are loaded into Claude's context window. Keep the main spec concise (under 5,000 words recommended). If your plugin needs detailed reference material, consider:

- Referencing external files that Claude can read on demand
- Using progressive disclosure (summary in spec, details in referenced files)
- Splitting complex agents into focused sub-agents

## Using Shared Principles

If your plugin involves documentation work, reference `shared/documentation-principles.md` instead of duplicating governance rules:

```markdown
## Shared Principles

This agent follows the **Documentation Principles** defined in:
`shared/documentation-principles.md`

Read and internalize that file before proceeding.
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for how the shared dependency model works.

## Registering Your Plugin

After creating your plugin files, register it in `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin-id",
  "source": "./your-plugin-id",
  "description": "Brief description",
  "version": "1.0.0",
  "author": { "name": "Your Name", "email": "you@example.com" },
  "keywords": ["relevant", "search", "terms"],
  "strict": false
}
```

The `keywords` array helps users discover your plugin. Choose terms that describe the plugin's domain and capabilities.

Set `strict` to `true` only if your plugin must be invoked explicitly by name (not auto-discovered based on context).

## Testing Your Plugin

1. Install the marketplace locally: `/plugin marketplace add /path/to/claude-plugin-marketplace`
2. Install your plugin: `/plugin install piscatore-agent-plugins:your-plugin-id`
3. Invoke it naturally: "Use your-plugin-id to [task]"
4. Test each operating mode and edge case
5. Verify the agent stays within its defined scope and constraints

## Versioning

Follow semver for your plugin version:

| Change | Version Bump | Example |
|--------|-------------|---------|
| Bug fix, clarification | Patch (x.y.Z) | 1.0.0 -> 1.0.1 |
| New capability, new mode | Minor (x.Y.0) | 1.0.0 -> 1.1.0 |
| Breaking behavior change | Major (X.0.0) | 1.0.0 -> 2.0.0 |

Update the version in **both** `plugin.json` and the agent spec's version footer. Also update `.claude-plugin/marketplace.json` and the `README.md` plugin table.

## Examples

Study the existing plugins for patterns:

- **doc-maintainer** ([agent.md](../doc-maintainer/agents/agent.md)): Complex agent with multiple operating modes, initialization interview, configuration persistence, content type variations. Good example of a full-featured plugin.
- **doc-pr-reviewer** ([doc-pr-reviewer.md](../doc-pr-reviewer/agents/doc-pr-reviewer.md)): Focused agent with four operating modes (advisory, strict, auto-fix, CI), config-aware convention inheritance, and structured review output. Good example of a single-purpose plugin with configuration loading.
- **product-advisor** ([product-advisor.md](../product-advisor/agents/product-advisor.md)): Skills-based plugin with four user-invocable skills (`/brainstorm`, `/product-review`, `/use-cases`, `/trade-offs`). Good example of a plugin that uses the `skills/` directory pattern, flexible project discovery (no fixed spec file), and a two-tier output model (scratchpad vs. true artifacts).
