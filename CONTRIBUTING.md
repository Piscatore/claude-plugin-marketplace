# Contributing to Claude Plugin Marketplace

Thank you for your interest in contributing. This guide covers how to add new plugins, improve existing ones, and work with the shared architecture.

## Development Workflow

This project uses a PR-based workflow. **Do not push directly to main.**

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes and commit
3. Push branch: `git push -u origin feature/description`
4. Create PR: `gh pr create`
5. Address review feedback
6. Merge PR

### Branch Naming

| Prefix | Use |
|--------|-----|
| `feature/` | New features or plugins |
| `fix/` | Bug fixes |
| `docs/` | Documentation updates |
| `refactor/` | Code refactoring |

## Adding a New Plugin

### 1. Create plugin directory structure

```
your-plugin-id/
├── plugin.json
└── agents/
    └── your-agent.md
```

### 2. Write plugin.json

```json
{
  "name": "your-plugin-id",
  "version": "1.0.0",
  "description": "Brief description of your plugin",
  "author": {
    "name": "Your Name"
  },
  "agents": ["./agents/"]
}
```

### 3. Write the agent specification

Your `agents/your-agent.md` file is the core of the plugin. It defines the agent's behavior, responsibilities, workflows, and constraints. See existing agent specs for reference:

- [doc-maintainer/agents/agent.md](doc-maintainer/agents/agent.md) -- comprehensive example with multiple modes
- [doc-pr-reviewer/agents/doc-pr-reviewer.md](doc-pr-reviewer/agents/doc-pr-reviewer.md) -- simpler example focused on a single workflow

### 4. Register in the marketplace

Add your plugin to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin-id",
  "source": "./your-plugin-id",
  "description": "Brief description",
  "version": "1.0.0",
  "author": { "name": "Your Name", "email": "you@example.com" },
  "keywords": ["tag1", "tag2"],
  "strict": false
}
```

### 5. Update README.md

Add your plugin to the "Available Plugins" table in [README.md](README.md).

## Modifying Existing Plugins

### Versioning Rules

This project follows strict semver. The rules differ depending on what you change:

**Updating a single plugin:**
- Increment that plugin's version in `plugin.json` and its agent spec
- Update the version in `.claude-plugin/marketplace.json`
- Update the `README.md` plugin table
- Update the compatibility table in `CLAUDE.md`

**Updating `shared/documentation-principles.md`:**
- Increment the shared file's version
- Increment the **patch version of BOTH** dependent plugins
- Update all version references (see checklist below)

See [CLAUDE.md](CLAUDE.md) for the full versioning rules and file update checklist.

### File Update Checklist

When changing shared principles:
- [ ] `shared/documentation-principles.md` -- version + content
- [ ] `doc-maintainer/plugin.json` -- version
- [ ] `doc-maintainer/agents/agent.md` -- version
- [ ] `doc-pr-reviewer/plugin.json` -- version
- [ ] `doc-pr-reviewer/agents/doc-pr-reviewer.md` -- version
- [ ] `.claude-plugin/marketplace.json` -- versions
- [ ] `README.md` -- version table
- [ ] `CLAUDE.md` -- compatibility table

When changing a single plugin:
- [ ] `[plugin]/plugin.json` -- version
- [ ] `[plugin]/agents/[agent].md` -- version
- [ ] `.claude-plugin/marketplace.json` -- version
- [ ] `README.md` -- version table
- [ ] `CLAUDE.md` -- compatibility table

## Agent Specification Guidelines

When writing or modifying agent specs:

- **Be explicit about constraints.** State what the agent should NOT do as clearly as what it should do.
- **Define operating modes.** If the agent has different behaviors, enumerate them.
- **Include tool usage guidance.** Specify which Claude Code tools the agent should use and when.
- **Add anti-patterns.** List common mistakes to avoid.
- **Include a version footer.** All agent specs use a footer block with version, date, and compatibility info.
- **Reference shared principles.** If your agent does documentation work, reference `shared/documentation-principles.md` rather than duplicating its content.

## Shared Architecture

Both `doc-maintainer` and `doc-pr-reviewer` depend on `shared/documentation-principles.md` for common governance logic. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for a full explanation of this dependency model.

## PR Reviewer Configuration

`doc-pr-reviewer` can read project conventions from the doc-maintainer config file. If you want to customize review behavior:

**If doc-maintainer is configured** (`.claude/doc-maintainer.json` exists): add an optional `prReviewer` section to the existing config to set mode, severity overrides, and ignored paths. The reviewer inherits style, versioning, forbidden paths, and other conventions automatically.

**If doc-maintainer is not configured**: create `.claude/doc-pr-reviewer.json` with both project conventions and reviewer settings in a single file. See [doc-pr-reviewer.md](doc-pr-reviewer/agents/doc-pr-reviewer.md) for the full schema.

For CI mode (automated, non-interactive reviews), a config file is mandatory. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the config resolution chain.

## CI/CD

Two GitHub Actions workflows exist (currently set to manual trigger via `workflow_dispatch`):

- **doc-review.yml** -- Runs doc-pr-reviewer on PR diffs
- **code-review.yml** -- Runs general code review on PR diffs

Both use the shared composite action at `.github/actions/claude-review/`.

## Questions?

Open an issue on GitHub or check existing discussions for answers.
