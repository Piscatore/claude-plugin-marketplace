# Cross-Plugin Registry

This file defines the cross-plugin awareness and delegation rules for all plugins in the piscatore-agent-plugins marketplace. Every plugin references this file to discover companions, check installation status, and delegate work appropriately.

**Used by:**
- `doc-maintainer` - Documentation auditing and maintenance agent
- `doc-pr-reviewer` - PR review agent for documentation compliance
- `product-advisor` - Product strategist for use case discovery and trade-offs
- `component-advisor` - External component and library advisor
- `rpi-workflow` - Research-Plan-Implement structured development workflow
- `workflow-guard` - Workflow enforcement via hook-based guards

## Plugin Inventory

| Plugin | Purpose | Config File | Key Capabilities |
|--------|---------|-------------|------------------|
| **doc-maintainer** | Documentation auditing, maintenance, bootstrap | `.claude/doc-maintainer.json` | audit, active maintenance, bootstrap modes |
| **doc-pr-reviewer** | PR documentation compliance | `.claude/doc-maintainer.json` (`prReviewer` key) | advisory, strict, auto-fix, CI modes |
| **product-advisor** | Product strategy and analysis | `.claude/doc-maintainer.json` (`productAdvisor` key) or `.claude/product-advisor.json` | `/brainstorm`, `/product-review`, `/use-cases`, `/trade-offs` |
| **component-advisor** | Library and package evaluation | `.claude/component-advisor.json` | `/find-component`, `/audit-dependencies`, `/compare-components`, `/check-compatibility` |
| **rpi-workflow** | Structured development lifecycle | `.claude/rpi-config.json` | `/0-define-work` through `/7-complete-work` |
| **workflow-guard** | Hook guard management | `.claude/settings.json` (`hooks` key) | `/guard` (setup, list, remove) |

## Discovery Protocol

Before delegating to another plugin, check whether it is installed using this two-step file check:

1. **Plugin directory**: Look for `[plugin-name]/plugin.json` in the marketplace root
2. **Config file**: Look for the plugin's config file (see table above)

If either file exists, the plugin is available. If neither exists, fall back to self-sufficient behavior.

## Delegation Protocol

Follow the three-part pattern defined in ADR-003:

1. **Discovery** — Run the two-step check above
2. **Draft & Suggest** — When the target plugin is available, draft content to a scratchpad location and suggest the user invoke the specialized plugin. Never write directly to another plugin's governed domain.
3. **Fallback** — When the target plugin is not installed, write directly. The originating plugin is self-sufficient; companion integration is a bonus, not a requirement.

### Language Templates

When delegating:
> "I've drafted [artifact] to [scratchpad path]. If you have [plugin-name] installed, consider running [command] to [action]."

When falling back:
> "[Plugin-name] is not installed, so I'll handle this directly."

## Integration Matrix

| Source | Target | When | What to Delegate |
|--------|--------|------|------------------|
| **doc-maintainer** | product-advisor | Audit finds product strategy gaps | Suggest `/product-review` for analysis |
| **doc-maintainer** | workflow-guard | Setting up doc compliance hooks | Suggest `/guard` for PreToolUse enforcement |
| **product-advisor** | doc-maintainer | ADRs, specs, changelog entries | Draft & suggest for proper filing (existing) |
| **product-advisor** | component-advisor | Analysis identifies tech choices | Suggest `/find-component` or `/compare-components` |
| **product-advisor** | rpi-workflow | Analysis produces actionable work items | Suggest `/0-define-work` for implementation |
| **component-advisor** | doc-maintainer | Audit reports and evaluations produced | Suggest filing reports with doc governance |
| **rpi-workflow** | doc-maintainer | Implementation produces documentation | Suggest filing with proper versioning |
| **rpi-workflow** | component-advisor | Research identifies dependency needs | Suggest `/find-component` for evaluation |
| **rpi-workflow** | product-advisor | Requirements unclear during define-work | Suggest `/use-cases` or `/brainstorm` for analysis |
| **rpi-workflow** | workflow-guard | PR creation without gate hooks | Suggest `/guard setup` for enforcement |
| **workflow-guard** | rpi-workflow | Detecting structured work in progress | Align guards with RPI workflow phases |
| **doc-pr-reviewer** | doc-maintainer | PR review against conventions (existing) | Inherits config and enforces rules |

## Adding a New Plugin

When a new plugin joins the marketplace:

1. Add a row to the **Plugin Inventory** table
2. Add relevant rows to the **Integration Matrix**
3. Add the plugin to the **Used by** list at the top
4. Add a `## Cross-Plugin Awareness` section to the new plugin's agent .md referencing this file
5. Bump the registry version below
6. Bump the patch version of all plugins that reference this file

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-01 | Initial: plugin inventory, discovery/delegation protocols, integration matrix |

## Version

Registry Version: 1.0.0
Last Updated: 2026-04-01
