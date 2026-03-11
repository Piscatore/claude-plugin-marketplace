# ADR-002: Interview-Based Onboarding for doc-maintainer

## Status

Accepted

## Date

2026-03-10

## Context

doc-maintainer needs project-specific context to operate effectively: content type, operating mode, versioning preferences, forbidden paths, update triggers, and more. Early versions required all configuration to be provided upfront or hard-coded in CLAUDE.md, which was error-prone and unfriendly.

Users often don't know what configuration options exist or what the implications of each choice are. A dump of all questions at once was overwhelming.

## Decision

Implement a structured interview dialogue that asks questions one at a time, adapts follow-up questions based on previous answers, explains trade-offs, offers sensible defaults, and confirms choices before proceeding.

The interview covers: content type selection, operation selection, scope discovery, style conventions, versioning preferences, authoritative sources, update triggers, forbidden actions, and cross-reference rules.

Interview responses are persisted to `.claude/doc-maintainer.json` so subsequent sessions can resume without re-interviewing.

## Consequences

### Positive

- Lower barrier to entry -- users don't need to know the configuration schema upfront
- Better choices -- trade-offs are explained at decision time
- Persistent config -- no re-interviewing on session restart
- Adaptable -- questions are skipped or added based on context

### Negative

- Longer initial setup compared to a config file drop-in
- Multiple conversation turns required before the agent can start working
- Subagent invocation (via Task tool) cannot do interactive Q&A -- required a delegated interview mode as a workaround

### Neutral

- The config file (`.claude/doc-maintainer.json`) can also be edited manually by users who prefer that approach
