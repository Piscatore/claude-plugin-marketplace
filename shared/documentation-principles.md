# Documentation Principles

This file defines shared documentation governance principles used across multiple plugins in the piscatore-agent-plugins marketplace.

**Used by:**
- `doc-maintainer` - Documentation auditing and maintenance agent
- `doc-pr-reviewer` - PR review agent for documentation compliance

---

## Core Principles

### Living Documentation
- Documentation evolves with the codebase
- Update existing docs rather than creating new ones
- Single source of truth for each concept
- Reference authoritative sources rather than duplicating

### Reference, Don't Duplicate (DRY)
- If information exists elsewhere (internal or external), reference it
- Use links and citations liberally
- Keep each piece of information in exactly one place
- Cross-reference related concepts

### Temporal Awareness
- Some documents are temporal (e.g., decision logs, changelogs, ADRs)
- NEVER modify past entries in temporal documents
- ADD new entries with timestamps
- Preserve the "why" and "when" of decisions

---

## Documentation Integrity Rules

### Reference & Index Maintenance
- If any documentation change, deletion, or addition implies that references, table of contents, or indexes should be updated, this MUST also be done
- Never leave broken links or outdated references
- Update all affected cross-references when moving or renaming content

### Search Before Create
- Before creating a new document file, search for existing documents that should be updated instead
- Avoid document proliferation - consolidate related information
- New files require explicit justification

### Consistency
- Maintain DRY principles across all documentation
- Search for possible contradictions when making changes
- If contradictions are found, alert the user or resolve them
- Use consistent terminology, formatting, and structure

### Scope Boundaries
- Documentation agents should not modify code
- Code agents should delegate documentation changes to documentation agents
- Each agent stays in its lane

---

## Document Classification

### Living Documents
- Can be updated, edited, reorganized
- Examples: README, API docs, architecture docs, guides
- Subject to consistency checks and updates

### Temporal Documents (Append-Only)
- Historical record - never modify past entries
- Only append new entries with timestamps
- Examples: CHANGELOG, ADRs, decision logs, meeting notes
- Preserve chronological ordering

---

## CLAUDE.md Governance Section

When documentation governance is active, the project's CLAUDE.md should contain a `## Documentation Governance` section that instructs Claude Code on how to handle documentation changes.

### Active Maintenance Mode
```markdown
## Documentation Governance

Documentation is managed by the doc-maintainer plugin (active mode).

- **All documentation changes** must go through doc-maintainer (delegate via Task tool)
- **Never edit .md files directly** - always delegate to doc-maintainer
- **After code changes**, notify doc-maintainer to assess documentation impact
- **Exceptions**: CLAUDE.md itself (managed by doc-maintainer for this section only)

To run a documentation audit: "Run doc-maintainer in audit mode"
To update docs: "Use doc-maintainer to update [description]"
```

### Audit Mode
```markdown
## Documentation Governance

Documentation is monitored by the doc-maintainer plugin (audit mode - read-only).

- **Documentation changes are allowed** but will be flagged in the next audit
- **Run periodic audits** to check documentation consistency
- **Audit reports** are saved to: [configured report path]

To run an audit: "Run doc-maintainer audit"
To switch to active mode: "Initialize doc-maintainer in active maintenance mode"
```

### When Disabled
The entire `## Documentation Governance` section should be removed from CLAUDE.md.

---

## Compliance Checklist

Use this checklist when reviewing documentation changes:

- [ ] No existing docs duplicated (DRY principle followed)
- [ ] Existing docs updated rather than new ones created (when appropriate)
- [ ] All affected references, TOCs, and indexes updated
- [ ] No broken links introduced
- [ ] Temporal documents only appended to (not modified)
- [ ] Consistent terminology and formatting
- [ ] No contradictions with existing documentation
- [ ] CLAUDE.md governance section intact (if applicable)

---

## Version

Principles Version: 1.0.0
Last Updated: 2025-11-30
