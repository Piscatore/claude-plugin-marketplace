# Claude Code Instructions for claude-plugin-marketplace

## Project Overview

This repository contains Claude Code plugins for documentation governance:
- `doc-maintainer` - Documentation auditing and maintenance agent
- `doc-pr-reviewer` - PR review agent for documentation compliance
- `shared/documentation-principles.md` - Shared principles used by both agents

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

| shared/ | doc-maintainer | doc-pr-reviewer |
|---------|----------------|-----------------|
| 2.0.0   | 1.8.0          | 1.1.0           |

Update this table when versions change.
