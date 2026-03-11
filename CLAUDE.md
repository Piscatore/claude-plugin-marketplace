# Claude Code Instructions for claude-plugin-marketplace

## Development Workflow (PR-Based)

**Do NOT push directly to main.** Use feature branches and PRs:

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes and commit
3. **Run Pre-PR Checklist** (MANDATORY before PR creation):
   a. Run marketplace validation checks (see Pre-PR Validation Checklist below)
   b. Run doc-pr-reviewer: review the branch diff for documentation compliance
4. Push branch: `git push -u origin feature/description`
5. Create PR: `gh pr create`
6. Address any issues
7. Merge PR

Claude MUST complete step 3 before executing `gh pr create`. The PreToolUse hook will prompt for confirmation.

### Using doc-pr-reviewer on this repo

After creating a PR, invoke the reviewer:
```
Review PR #[number] using doc-pr-reviewer
```

Or for the current branch's PR:
```
Review the open PR for this branch using doc-pr-reviewer
```

### Branch Naming

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring

## Pre-PR Validation Checklist

Before creating any PR, verify:

1. **JSON validity**: Read `.claude-plugin/marketplace.json` and all `*/plugin.json` files. Confirm valid JSON.
2. **Required fields**: Each `plugin.json` has: name, version, description, author, agents. Each marketplace entry has: name, source, description, version, author, keywords.
3. **Version consistency**: For each plugin, verify version matches across:
   - `[plugin]/plugin.json`
   - `.claude-plugin/marketplace.json` entry
   - `README.md` Available Plugins table
   - `CLAUDE.md` Current Version Compatibility table
4. **Source paths**: Each `source` in marketplace.json resolves to a directory with a `plugin.json`.
5. **Marketplace version**: `README.md` marketplace version matches `marketplace.json` metadata version.

## Project Overview

This repository contains Claude Code plugins:
- `doc-maintainer` - Documentation auditing and maintenance agent
- `doc-pr-reviewer` - PR review agent for documentation compliance
- `product-advisor` - Product strategist agent for use case discovery, trade-offs, and feature prioritization
- `shared/documentation-principles.md` - Shared principles used by doc-maintainer and doc-pr-reviewer

## Shared Dependencies Architecture

Both plugins depend on `shared/documentation-principles.md` for common logic:
- Handling Uncertainty (three-layer knowledge acquisition)
- Industry Standards Reference
- Documentation Gap Analysis

```
shared/documentation-principles.md
        ↓ (referenced by)
   ┌────┴────┐
   ↓         ↓
doc-maintainer  doc-pr-reviewer
```

## Versioning Rules (IMPORTANT)

### When updating `shared/documentation-principles.md`:
1. Increment the shared file's version (semver)
2. Increment the patch version of BOTH dependent plugins:
   - `doc-maintainer/plugin.json`
   - `doc-maintainer/agents/agent.md`
   - `doc-pr-reviewer/plugin.json`
   - `doc-pr-reviewer/agents/doc-pr-reviewer.md`
3. Update `README.md` plugin version table
4. Update the compatibility table in the shared file

### When adding new features:
- If feature applies to BOTH agents → Add to `shared/documentation-principles.md`
- If feature is agent-specific → Add to that agent's file only

### When updating a single plugin:
- Only increment that plugin's version
- No need to touch the other plugin or shared file

## File Update Checklist

Use this when making changes:

**Shared file update:**
- [ ] `shared/documentation-principles.md` - version + content
- [ ] `doc-maintainer/plugin.json` - version
- [ ] `doc-maintainer/agents/agent.md` - version
- [ ] `doc-pr-reviewer/plugin.json` - version
- [ ] `doc-pr-reviewer/agents/doc-pr-reviewer.md` - version
- [ ] `README.md` - version table

**Single plugin update:**
- [ ] `[plugin]/plugin.json` - version
- [ ] `[plugin]/agents/[agent].md` - version
- [ ] `README.md` - version table

## Current Version Compatibility

| shared/ | doc-maintainer | doc-pr-reviewer | product-advisor |
|---------|----------------|-----------------|-----------------|
| 2.0.0   | 1.13.0         | 1.2.0           | 1.0.0           |

Update this table when versions change.

## Documentation Governance

Documentation is managed by doc-maintainer (active mode).
Configuration: `.claude/doc-maintainer.json`

- After code changes, notify doc-maintainer to assess documentation impact
- Run `doc-maintainer audit` for periodic checks
- See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the shared dependency model
- See [CONTRIBUTING.md](CONTRIBUTING.md) for contributor documentation requirements
