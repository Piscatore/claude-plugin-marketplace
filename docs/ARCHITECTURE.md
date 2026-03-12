# Architecture

This document describes the architectural design of the Claude Plugin Marketplace, focusing on the shared dependency model and how components relate to each other.

## Overview

The marketplace is a collection of Claude Code agent plugins -- Markdown specifications that define specialized behaviors for Claude Code's AI agent. There is no runtime code; the "architecture" is the relationship between specification files and how they reference each other.

## Repository Structure

```
claude-plugin-marketplace/
├── .claude/
│   ├── doc-maintainer.json       # Persistent config (shared with doc-pr-reviewer)
│   ├── settings.json             # Project-scope settings (hooks config)
│   └── hooks/
│       └── pre-pr-check.sh       # PreToolUse hook for PR creation gate
├── .claude-plugin/
│   └── marketplace.json          # Marketplace registry (plugin catalog)
├── .github/
│   ├── actions/
│   │   └── claude-review/
│   │       └── action.yml        # Shared composite action for PR reviews
│   └── workflows/
│       ├── code-review.yml       # General code review workflow
│       └── doc-review.yml        # Documentation compliance review workflow
├── doc-maintainer/
│   ├── plugin.json               # Plugin metadata and version
│   └── agents/
│       └── agent.md              # Agent specification
├── doc-pr-reviewer/
│   ├── plugin.json               # Plugin metadata and version
│   └── agents/
│       └── doc-pr-reviewer.md    # Agent specification
├── product-advisor/
│   ├── plugin.json               # Plugin metadata and version
│   ├── agents/
│   │   └── product-advisor.md    # Agent specification
│   └── skills/
│       ├── brainstorm/
│       │   └── SKILL.md          # /brainstorm skill
│       ├── product-review/
│       │   └── SKILL.md          # /product-review skill
│       ├── use-cases/
│       │   └── SKILL.md          # /use-cases skill
│       └── trade-offs/
│           └── SKILL.md          # /trade-offs skill
├── workflow-guard/
│   ├── plugin.json               # Plugin metadata and version
│   ├── agents/
│   │   └── workflow-guard.md     # Agent specification
│   ├── skills/
│   │   └── guard/
│   │       └── SKILL.md          # /guard skill
│   └── templates/
│       └── pr-gate/
│           ├── guard.sh          # PR creation gate hook script
│           └── README.md         # Template documentation
├── shared/
│   └── documentation-principles.md  # Shared governance principles
├── docs/
│   ├── ARCHITECTURE.md           # This file
│   ├── plugin-development-guide.md  # Extended guide for plugin authors
│   ├── adr/                      # Architecture Decision Records
│   └── product/
│       └── scratch/              # Product review artifacts and working notes
├── CLAUDE.md                     # Development instructions and versioning rules
├── CHANGELOG.md                  # Project-wide changelog
├── CONTRIBUTING.md               # Contributor guide
├── LICENSE                       # MIT license
├── README.md                     # Project overview and quick start
└── SECURITY.md                   # Security policy
```

## Shared Dependency Model

The core architectural decision in this project is the extraction of common documentation governance principles into a shared file that both plugins reference.

```
shared/documentation-principles.md (v2.0.0)
        │
        │  referenced by (not duplicated)
        │
   ┌────┴────────────┐
   │                  │
   ▼                  ▼
doc-maintainer     doc-pr-reviewer
  (v1.13.0)          (v1.2.0)
```

### product-advisor (independent)

`product-advisor` does not depend on `shared/documentation-principles.md`. It is a product strategy agent, not a documentation governance agent. It optionally reads `doc-maintainer.json` for configuration and can delegate documentation tasks to doc-maintainer when installed, but has no required dependencies.

```
product-advisor (v1.0.0)
    │
    ├── optionally reads .claude/doc-maintainer.json (productAdvisor section)
    ├── optionally delegates doc tasks to doc-maintainer
    └── no dependency on shared/documentation-principles.md
```

### workflow-guard (independent)

`workflow-guard` does not depend on `shared/documentation-principles.md`. It is a workflow enforcement agent that manages Claude Code hook guards. It ships with pre-built guard templates and a `/guard` skill for interactive setup. No dependencies on other plugins.

```
workflow-guard (v1.0.0)
    │
    ├── templates/pr-gate/    (ships with PR creation gate)
    ├── /guard skill          (setup, list, remove guards)
    └── no dependency on shared/ or other plugins
```

### Why shared principles?

Both `doc-maintainer` and `doc-pr-reviewer` need to agree on what "good documentation" means. If each agent defined its own rules, they could drift apart -- doc-maintainer might enforce one standard while doc-pr-reviewer checks for a different one.

By extracting shared logic into `shared/documentation-principles.md`, both agents reference the same source of truth. Changes to governance rules propagate to both agents simultaneously.

### What lives in shared vs. agent-specific

| Location | Content |
|----------|---------|
| `shared/documentation-principles.md` | Core principles, document classification, compliance checklist, handling uncertainty, industry standards, gap analysis workflow |
| `doc-maintainer/agents/agent.md` | Initialization interview, operating modes, versioning logic, wiki content rules, configuration persistence, interaction formatting |
| `doc-pr-reviewer/agents/doc-pr-reviewer.md` | PR review workflow, issue severity, GitHub integration, advisory/strict/auto-fix/CI modes, config resolution chain, convention inheritance |
| `product-advisor/agents/product-advisor.md` | Product strategy, use case discovery, trade-off analysis, brainstorming facilitation, challenge mode, scratchpad/artifact output handling |
| `workflow-guard/agents/workflow-guard.md` | Hook guard management, template-based setup, settings.json merging, guard listing and removal |

### Configuration sharing

The two plugins share project conventions through a config file, avoiding the need to configure rules in two places.

```
.claude/doc-maintainer.json
        │
        │  doc-maintainer writes during onboarding
        │  doc-pr-reviewer reads at review time
        │
        ├── style, versioning, forbiddenPaths, ...  (shared conventions)
        │
        ├── prReviewer: { mode, ciEnabled, ... }     (reviewer-specific settings)
        │
        └── productAdvisor: { outputDir, ... }        (product-advisor settings, optional)
```

**Resolution chain** (doc-pr-reviewer checks in order):

1. `.claude/doc-maintainer.json` -- inherits all project conventions; looks for optional `prReviewer` key for reviewer-specific settings
2. `.claude/doc-pr-reviewer.json` -- standalone fallback with both conventions and reviewer settings in one file
3. CLAUDE.md `## Documentation Governance` section -- parsed for mode hints
4. Defaults -- advisory mode, generic checks only

In CI mode, a config file (option 1 or 2) is mandatory. See [doc-pr-reviewer.md](../doc-pr-reviewer/agents/doc-pr-reviewer.md) for full schema details.

### Versioning cascade

When `shared/documentation-principles.md` is updated, both dependent plugins must bump their patch version. This ensures consumers know the underlying rules have changed even if the agent-specific logic hasn't.

The full versioning protocol is documented in [CLAUDE.md](../CLAUDE.md).

## CI/CD Architecture

Two GitHub Actions workflows handle automated PR reviews. Both use a shared composite action to avoid duplicating the Claude API call and review posting logic.

```
.github/workflows/doc-review.yml ──┐
                                    ├──▶ .github/actions/claude-review/action.yml
.github/workflows/code-review.yml ─┘         │
                                              ├── Calls Claude API (configurable model)
                                              ├── Detects issues via configurable patterns
                                              ├── Posts PR review (approve/request changes)
                                              └── Dismisses previous reviews from same reviewer
```

The composite action supports:
- Configurable prompt templates with placeholder replacement
- Configurable issue detection patterns (primary + optional secondary)
- Optional risk level checking
- Extended thinking via anthropic-beta header

Both workflows are currently set to `workflow_dispatch` (manual trigger) rather than automatic PR triggers.

## Hook-Based Automation

A PreToolUse hook in `.claude/settings.json` gates PR creation. When Claude attempts to run `gh pr create` via the Bash tool, the hook script (`.claude/hooks/pre-pr-check.sh`) intercepts the call and prompts the user to confirm that the Pre-PR Validation Checklist has been completed. This enforces the validation workflow defined in `CLAUDE.md` at the tooling level.

The `workflow-guard` plugin generalizes this pattern into a reusable tool. It ships a PR creation gate as a template and provides the `/guard` skill for installing, listing, and removing guards in any project. See the [plugin development guide](plugin-development-guide.md#hook-patterns) for authoring guidance.

## Plugin Discovery

Claude Code discovers plugins through the marketplace registry at `.claude-plugin/marketplace.json`. Each entry points to a plugin directory containing `plugin.json` (metadata) and an `agents/` directory (specifications).

```
User runs: /plugin install piscatore-agent-plugins:doc-maintainer
                │
                ▼
.claude-plugin/marketplace.json
                │
                ▼  (resolves source: "./doc-maintainer")
doc-maintainer/plugin.json
                │
                ▼  (resolves agents: ["./agents/"])
doc-maintainer/agents/agent.md  ──▶  Loaded into Claude's context
```

## Design Principles

1. **Specification-first**: Plugins are Markdown specifications, not executable code. The "runtime" is Claude's language model following instructions.
2. **DRY across agents**: Shared logic lives in one place (`shared/documentation-principles.md`), not duplicated in each agent spec.
3. **Versioned contracts**: Each component has an explicit version. Compatibility between components is tracked in `CLAUDE.md`.
4. **Progressive disclosure**: Agent specs are only loaded into context when invoked. The marketplace registry provides lightweight metadata for discovery.
