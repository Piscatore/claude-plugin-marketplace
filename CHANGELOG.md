# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Version numbers follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

For per-component version history, see the Version section in each agent spec:
- [doc-maintainer](doc-maintainer/agents/agent.md)
- [doc-pr-reviewer](doc-pr-reviewer/agents/doc-pr-reviewer.md)
- [product-advisor](product-advisor/agents/product-advisor.md)
- [workflow-guard](workflow-guard/agents/workflow-guard.md)
- [shared principles](shared/documentation-principles.md)

---

## [Unreleased]

## 2026-03-12

### workflow-guard v1.0.0 (New Plugin)
- Workflow enforcement agent for hook-based guard management
- PR creation gate template (bash-only, zero API cost)
- `/guard` skill with setup, list, and remove actions
- Safe settings.json merge workflow
- Hook Patterns section added to plugin development guide

## 2026-03-11 (4)

### Infrastructure
- Fixed marketplace version inconsistency (README 1.0.0 → 1.1.0)
- Added PreToolUse hook for pre-PR review enforcement (.claude/hooks/ + settings.json)
- Added Pre-PR Validation Checklist to CLAUDE.md
- Strengthened PR workflow to require validation before PR creation

### Documentation
- Added ADR-003: Cross-Plugin Delegation pattern
- Saved initial product review to docs/product/scratch/

## 2026-03-11 (3)

### product-advisor v1.0.0 (New Plugin)
- Product strategist agent for use case discovery, value prop analysis, feature prioritization, trade-offs, and risk mapping
- Four user-invocable skills: `/brainstorm`, `/product-review`, `/use-cases`, `/trade-offs`
- Flexible project context discovery (no fixed spec file required)
- Challenge mode: configurable intensity dial (low/medium/high) with always-on light questioning and explicit intense mode
- Two-tier output: scratchpad (writes freely) and true artifacts (asks user, remembers paths)
- Optional integration with doc-maintainer for documentation delegation
- Configuration via `productAdvisor` section in `.claude/doc-maintainer.json` or standalone `.claude/product-advisor.json`

## 2026-03-11 (2)

### doc-pr-reviewer v1.2.0
- Added CI mode (Mode 4) for fully unattended, config-driven PR reviews
- Added config resolution chain: `.claude/doc-maintainer.json` > `.claude/doc-pr-reviewer.json` > CLAUDE.md governance > defaults
- Convention inheritance from doc-maintainer config (style, versioning, forbidden paths, authoritative sources, update triggers)
- Added `prReviewer` section schema for embedding reviewer settings in doc-maintainer config
- Added standalone `doc-pr-reviewer.json` schema for projects without doc-maintainer
- Added config validation with clear error messages for invalid values
- Added idempotent review comments (updates existing comment on re-runs)
- Added CI error handling table (missing config, validation failures, no doc impact, missing `gh` CLI)

### Project Documentation Bootstrap
- Added MIT LICENSE
- Added CHANGELOG.md (project-wide changelog)
- Added CONTRIBUTING.md (contributor guide with versioning rules and checklists)
- Added SECURITY.md (security policy)
- Added docs/ARCHITECTURE.md (shared dependency model, CI/CD architecture, plugin discovery)
- Added docs/plugin-development-guide.md (extended guide for plugin authors)
- Added docs/adr/ with template and two ADRs (shared principles, interview onboarding)
- Added `.claude/doc-maintainer.json` (persistent doc-maintainer config)

## 2026-03-11

### doc-maintainer v1.13.0
- Fixed five real-world usage issues discovered during live onboarding sessions
- Improved config file handling and session resume behavior

### doc-maintainer v1.12.0
- Added persistent configuration file (`.claude/doc-maintainer.json`)
- Session resume without re-interviewing
- Re-onboarding workflow with "keep current" defaults

### doc-maintainer v1.11.0
- Enhanced UX with structured interaction formatting (radio buttons, checkboxes, confirmations)
- Added progress and transparency reporting during long operations
- Added tiered template suggestions for bootstrap mode
- Added delegated interview mode for subagent invocation

## 2026-03-10

### doc-maintainer v1.10.0
- Restructured architecture into content type x operation matrix
- "Wiki" changed from independent mode to content type modifier
- Added interview-mode onboarding dialogue (Phase 1-5 structured interview)
- Added configuration change interview workflow
- Added Mermaid flowcharts to README for onboarding and mode matrix

### Infrastructure
- Disabled automatic CI PR reviews (switched to `workflow_dispatch`)
- Refactored workflow duplication into shared composite action (`.github/actions/claude-review/`)
- Added HTTP status code checking to API calls
- Increased max_tokens to 24K for extended thinking headroom
- Added anthropic-beta header for extended thinking support
- Optimized plugins for Opus/Sonnet 4.6 model support
- Addressed PR review feedback: shell safety, DRY, and robustness

## 2025-12-07

### doc-maintainer v1.8.0
- Updated for Version Log Compliance

### Infrastructure
- Added fallback when GitHub Actions cannot approve PRs
- Fixed PR review logic and addressed security feedback
- Added proper GitHub PR reviews for code and documentation

## 2025-12-01

### Infrastructure
- Made Claude model configurable in doc-review workflow
- Added GitHub Action for automated doc-pr-reviewer

## 2025-11-30

### shared/documentation-principles v2.0.0
- Added Handling Uncertainty with three-layer knowledge acquisition
- Added Industry Standards Reference tables
- Added Documentation Gap Analysis workflow
- Consolidated shared logic from both agent specs

### doc-maintainer v1.7.0
- Unified three-layer knowledge acquisition into Handling Uncertainty

### doc-maintainer v1.6.0
- Added Bootstrap Mode for undocumented projects

### doc-maintainer v1.5.0
- Added tiered uncertainty handling to reduce unnecessary user questions

### doc-pr-reviewer v1.1.0 + shared/documentation-principles v1.0.0
- Added doc-pr-reviewer plugin (PR documentation compliance reviewer)
- Extracted shared documentation principles into `shared/documentation-principles.md`

### doc-maintainer v1.3.1
- Added Claude Code permission compatibility section

### doc-maintainer v1.3.0
- Added CLAUDE.md governance management

### doc-maintainer v1.2.1
- Improved clarity and added Musts section

### Infrastructure
- Added CLAUDE.md with versioning governance for shared dependencies
- Added PR-based development workflow
- Fixed README.md to align with PR-based workflow

## 2025-11-29

### doc-maintainer v1.2.0
- Replaced index-only mode with audit mode

### Infrastructure
- Renamed marketplace to piscatore-agent-plugins
- Fixed plugin.json manifest validation errors
- Fixed plugin path structure for Claude Code compatibility
- Consolidated to single source of truth for plugins

## 2025-11-28

### Initial Release
- doc-maintainer v1.0.0 -- Documentation auditing and maintenance agent
- Marketplace infrastructure (marketplace.json, plugin.json)
- README with installation instructions
- Native Claude Code marketplace format
