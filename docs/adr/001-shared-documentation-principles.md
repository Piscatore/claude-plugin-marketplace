# ADR-001: Shared Documentation Principles

## Status

Accepted

## Date

2025-11-30

## Context

The marketplace contains two documentation-focused plugins: `doc-maintainer` (audits and maintains documentation) and `doc-pr-reviewer` (reviews PRs for documentation compliance). Both plugins need to agree on what constitutes "good documentation" -- core principles, compliance checklists, document classification, and gap analysis workflows.

Initially, each agent spec contained its own copy of these rules. This created a maintenance burden: changes to governance rules had to be made in two places, and the specs could drift apart, causing one plugin to enforce rules the other didn't recognize.

## Decision

Extract shared documentation governance logic into a single file (`shared/documentation-principles.md`) that both agent specs reference. Each agent spec includes a "Shared Principles" section that points to the shared file and instructs Claude to read and internalize it.

Agent-specific logic (operating modes, initialization, PR review workflow) stays in each agent's own spec.

When the shared file is updated, both dependent plugins bump their patch version to signal that the underlying rules have changed.

## Consequences

### Positive

- Single source of truth for governance rules -- no drift between agents
- Changes propagate to both agents automatically (after version bump)
- Agent specs are shorter and focused on agent-specific behavior
- New plugins can reference the same shared principles

### Negative

- Version cascade: updating one file requires touching five+ files (shared file + both plugin.json + both agent specs + README + CLAUDE.md)
- Claude must read an additional file at startup, using context window budget
- Contributors must understand the dependency model before making changes

### Neutral

- The shared file is a Markdown document, same as agent specs -- no new tooling or format to learn
