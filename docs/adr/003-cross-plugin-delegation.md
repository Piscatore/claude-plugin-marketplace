# ADR-003: Cross-Plugin Delegation

## Status

Accepted

## Date

2026-03-11

## Context

As the marketplace grows, plugins increasingly need to interact. product-advisor generates artifacts (ADRs, specs, product reviews) that overlap with doc-maintainer's domain. Without a clear delegation pattern, plugins risk duplicating logic or creating conflicting outputs — for example, both plugins might try to write or update the same documentation files with different conventions.

## Decision

Adopt a three-part delegation protocol for cross-plugin interactions:

1. **Discovery** — Before delegating, check whether the target plugin is installed by looking for its `plugin.json` or config file (e.g., `.claude/doc-maintainer.json`).

2. **Draft & Suggest** — When the target plugin is available, draft content to a scratchpad location and suggest the user invoke the specialized plugin. Never write directly to another plugin's governed domain (e.g., product-advisor should not directly update versioned docs that doc-maintainer manages).

3. **Fallback** — When the target plugin is not installed, write directly. The originating plugin acts as best-effort fallback rather than silently skipping the work.

Reference implementation: `product-advisor/agents/product-advisor.md` (artifact output handling and doc-maintainer delegation sections).

## Consequences

### Positive

- No domain conflicts between plugins — each plugin's governed files remain under its control
- Graceful degradation — functionality works whether or not the target plugin is installed
- Clear user control — delegation is visible and user-initiated, not automatic

### Negative

- Requires extra user action (manually invoking the target plugin after receiving the suggestion)
- Slightly more complex plugin authoring — plugin authors must implement the discovery/fallback pattern

### Neutral

- Establishes a convention that future plugins should follow for inter-plugin communication
