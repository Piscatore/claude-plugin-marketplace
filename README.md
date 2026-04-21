# Claude Plugin Marketplace

A curated collection of specialized agent plugins for Claude Code that extend capabilities with domain-specific workflows and behaviors.

## What are Claude Plugins?

Claude Plugins are specialized agent specifications that define focused behaviors for specific tasks like documentation maintenance, code review, testing, and more. They work alongside the main Claude Code agent via the Task tool.

## Quick Start

### Add the Marketplace (One Command!)

```bash
/plugin marketplace add Piscatore/claude-plugin-marketplace
```

This connects your Claude Code instance to the marketplace.

### Browse and Install Plugins

```bash
/plugin marketplace list                    # List all marketplaces
/plugin list                                # List all available plugins
/plugin install piscatore-agent-plugins:doc-maintainer  # Install a plugin
```

### Manual Installation

1. Clone this repository
2. Copy desired plugin directories from `plugins/` to your project's `.claude/context/plugins/` directory
3. Restart Claude Code or reload context

## Available Plugins

| Plugin ID | Name | Version | Category | Description |
|-----------|------|---------|----------|-------------|
| doc-maintainer | Documentation Maintainer | 1.14.0 | productivity | Specialized agent for documentation auditing, maintenance, and bootstrapping. Supports software dev docs and wiki content types with audit, active, and bootstrap operations. Persistent config file. |
| doc-pr-reviewer | Documentation PR Reviewer | 1.3.0 | productivity | Reviews Pull Requests for documentation compliance. Config-aware with CI automation. Inherits conventions from doc-maintainer. Supports advisory, strict, auto-fix, and CI modes. |
| product-advisor | Product Advisor | 1.1.0 | productivity | Product strategist agent for use case discovery, value prop analysis, feature prioritization, trade-offs, and risk mapping. Includes /brainstorm, /product-review, /use-cases, and /trade-offs skills. |
| workflow-guard | Workflow Guard | 1.1.0 | devops | Workflow enforcement agent for managing PreToolUse/PostToolUse hook guards. Ships with a PR creation gate template. Use /guard to set up, list, or remove guards. |
| rpi-workflow | RPI Workflow | 1.2.0 | productivity | Research-Plan-Implement workflow framework for structured software development. Provides 8 slash commands (/0-define-work through /7-complete-work) that guide work from definition through PR merge. All user dialogue uses the AskUserQuestion interview pattern; subagents propagate questions up via structured open_questions entries. |
| component-advisor | Component Advisor | 1.1.0 | productivity | External component and library advisor. Discovers, evaluates, and recommends third-party packages that fit your architecture and existing dependency graph. |

Use `/plugin show <id>` for detailed information about each plugin.

### doc-maintainer: How It Works

doc-maintainer operates along two dimensions: **content type** and **operation**.

**Content types:** Software development docs (versioned, temporal rules) or Wiki content (git-synced, no in-document versioning).

**Operations:** Audit (read-only report), Active maintenance (ongoing upkeep), or Bootstrap (scaffold from scratch).

Any operation works with either content type. See [agent.md](doc-maintainer/agents/agent.md) for full details.

**Quick usage:**

```bash
# Audit your software docs
Use doc-maintainer to audit my documentation

# Active maintenance
Use doc-maintainer in active mode to update the API docs

# Bootstrap a new project
Use doc-maintainer to bootstrap documentation for this project

# Audit wiki content (scoped to folder)
Use doc-maintainer to audit the wiki/ folder as wiki content

# Active maintenance on wiki
Use doc-maintainer in active mode on wiki content in docs/knowledge-base/
```

### product-advisor: How It Works

product-advisor shifts Claude from engineer mode to product strategist mode. It helps with use case discovery, value prop analysis, feature prioritization, trade-off analysis, and risk mapping.

**Skills:** Four user-invocable skills for structured product thinking:

- `/brainstorm` — Structured ideation: diverge, cluster, evaluate, converge
- `/product-review` — Holistic product analysis: strengths, gaps, opportunities, risks
- `/use-cases` — Generate structured use case maps with actors, goals, and flows
- `/trade-offs` — Decision analysis: options, pros/cons, decision matrix, recommendation

**Quick usage:**

```bash
# Run a brainstorming session
/brainstorm authentication strategies for our API

# Get a product-level review of the current project
/product-review

# Map out use cases for a feature
/use-cases the plugin installation flow

# Analyze a technical decision
/trade-offs monorepo vs polyrepo for our microservices
```

**Configuration:** Optional. Add a `productAdvisor` section to `.claude/doc-maintainer.json`, or create `.claude/product-advisor.json`. Works with sensible defaults if no config exists. See [product-advisor.md](product-advisor/agents/product-advisor.md) for details.

### workflow-guard: How It Works

workflow-guard packages the hook-based workflow enforcement pattern as a reusable plugin. It helps users create, install, and manage Claude Code hook guards — shell scripts that run automatically when Claude attempts to use a tool.

**Key concept:** Guards are PreToolUse/PostToolUse hooks registered in `.claude/settings.json`. They intercept tool calls and can allow, ask for confirmation, or deny them. Guards run as local bash scripts at zero API cost.

**Skill:** One user-invocable skill for guard management:

- `/guard` — Set up, list, or remove workflow guards

**Templates:** Pre-built guard scripts with documentation:

| Template | Description |
|----------|-------------|
| `pr-gate` | Gates PR creation behind a confirmation prompt. Reminds user to complete pre-PR checks. |

**Quick usage:**

```bash
# List active guards
/guard

# Install a guard from template
/guard setup

# Remove a guard
/guard remove
```

See [workflow-guard.md](workflow-guard/agents/workflow-guard.md) for the full agent spec, including the hook protocol reference and template authoring guide.

### rpi-workflow: How It Works

rpi-workflow provides a structured Research-Plan-Implement development lifecycle. It guides work from initial definition through PR merge using 8 sequential slash commands.

**Skills:** Eight user-invocable skills for the full development lifecycle:

- `/0-define-work` — Clarify requirements through dialogue, save a work brief, create a feature branch
- `/1-research-codebase` — Deep codebase research with parallel agents and a clarification gate
- `/2-create-plan` — Step-by-step implementation plan respecting architecture layers
- `/3-validate-plan` — Validate plan against architecture rules, patterns, and completeness
- `/4-implement-plan` — Execute plan with verification gates and auto-commits at checkpoints
- `/5-save-progress` — Mid-work pause: commit, push, and save session state
- `/6-resume-work` — Resume a saved session: restore context and continue implementation
- `/7-complete-work` — Verify acceptance criteria, create PR, optionally merge

Not every work item needs all steps:
- **Large/unfamiliar**: 0 → 1 → 2 → 3 → 4 → 7
- **Medium/familiar**: 0 → 2 → 4 → 7
- **Small/trivial**: 0 → 4 → 7

**Quick usage:**

```bash
# Start a new work item
/0-define-work

# Research the codebase for context
/1-research-codebase

# Create and validate an implementation plan
/2-create-plan
/3-validate-plan

# Implement the plan
/4-implement-plan

# Save progress or complete
/5-save-progress
/7-complete-work
```

**Configuration:** Optional. Place a `rpi-config.json` in `.claude/` to define project structure, architecture layers, build/test commands, and validation rules. Works with auto-detected defaults if no config exists. See [rpi-workflow.md](rpi-workflow/agents/rpi-workflow.md) for details.

### component-advisor: How It Works

component-advisor operates during the design phase of new software or feature extensions. It identifies when external libraries or packages are the right solution, finds the best candidates, evaluates them against your existing stack, and makes well-reasoned recommendations.

**Key capabilities:**
- Auto-detects project ecosystem (.NET, Node.js, Python, Rust, Go, Java, Ruby)
- Reads existing dependency manifests to check for overlap and conflicts
- Interview-driven — asks clarifying questions before searching
- Evaluates candidates on maintenance health, security, license, API fit, and strategic risk
- Build vs. adopt analysis for borderline cases

**Skills:** Four user-invocable skills:

- `/find-component` — Interview-driven discovery: "I need to do X, what's out there?"
- `/audit-dependencies` — Health scan: security, outdated, overlap, unused packages
- `/compare-components` — Structured side-by-side evaluation with decision matrix
- `/check-compatibility` — Go/no-go check for a specific package against your stack

**Quick usage:**

```bash
# Find a library for a design need
/find-component CSV parsing with streaming support

# Audit your project's dependency health
/audit-dependencies

# Compare two candidates
/compare-components CsvHelper vs Sylvan.Data.Csv

# Check if a package fits before adopting
/check-compatibility Polly v8.2
```

**Configuration:** Optional. Place `component-advisor.json` in `.claude/` to define license policies, maintenance thresholds, and security policy. Works with sensible defaults if no config exists. See [component-advisor.md](component-advisor/agents/component-advisor.md) for details.

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

1. Create plugin directory structure:
   ```
   your-plugin-id/
   ├── plugin.json
   └── agents/
       └── your-agent.md
   ```

2. Create `plugin.json`:
   ```json
   {
     "name": "your-plugin-id",
     "version": "1.0.0",
     "description": "Brief description of your plugin",
     "author": "Your Name",
     "agents": ["./agents/"]
   }
   ```

3. Add plugin to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "your-plugin-id",
     "source": "your-plugin-id",
     "description": "Brief description",
     "version": "1.0.0",
     "author": { "name": "Your Name", "email": "you@example.com" },
     "keywords": ["tag1", "tag2"],
     "strict": false
   }
   ```

4. Commit and push

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

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full repository structure, dependency model, and configuration sharing architecture.

Key directories:

| Directory | Purpose |
|-----------|---------|
| `doc-maintainer/` | Documentation maintenance agent (plugin.json + agent spec) |
| `doc-pr-reviewer/` | PR review agent (plugin.json + agent spec) |
| `product-advisor/` | Product strategist agent (plugin.json + agent spec + skills) |
| `workflow-guard/` | Workflow enforcement agent (plugin.json + agent spec + skill + templates) |
| `rpi-workflow/` | RPI workflow agent (plugin.json + agent spec + 8 skills + config template) |
| `component-advisor/` | Component advisor agent (plugin.json + agent spec + 4 skills) |
| `shared/` | Shared governance principles used by doc-maintainer and doc-pr-reviewer |
| `docs/` | Architecture docs, plugin development guide, ADRs |
| `.claude-plugin/` | Marketplace registry |
| `.claude/` | Agent configuration (doc-maintainer.json) |

## Plugin Development Workflow

When modifying a plugin:

1. **Create branch**: `git checkout -b feature/description`
2. **Edit** the agent spec: `<plugin-id>/agents/<plugin-id>.md`
3. **Update version** in `<plugin-id>/plugin.json`
4. **Run Pre-PR Validation Checklist** (see [CLAUDE.md](CLAUDE.md#pre-pr-validation-checklist))
5. **Commit and push branch**: `git push -u origin feature/description`
6. **Create PR**: `gh pr create`
7. **Review**: Run doc-pr-reviewer on the PR
8. **Merge** after review passes
9. **Update locally**: `/plugin update` or reinstall the plugin

See `CLAUDE.md` for detailed workflow and branch naming conventions.

## Version

Marketplace Version: 1.4.0
Last Updated: 2026-04-01
