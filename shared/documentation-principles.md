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

## Handling Uncertainty

When encountering uncertainty during documentation tasks, follow this tiered approach:

### 1. Factual Uncertainty → Investigate First

For questions that can be answered through investigation, use the **Three-Layer Knowledge Acquisition** approach:

#### Layer 1: Self-Investigation (Codebase)

- **Read files**: Check imports, examine package.json/manifest files, search for patterns
- **Analyze structure**: Directory layout, entry points, configuration files
- **Extract from code**: Comments, docstrings, type definitions, README fragments

**Examples:**
- "What external libraries does this project use?" → Check package.json, imports
- "Is this feature fully implemented?" → Examine the code, check for TODOs
- "How many tests exist?" → Run test discovery or count test files
- "What's the correct terminology?" → Check existing docs for established patterns

#### Layer 2: Delegation (Complex Analysis)

For complex questions requiring deeper investigation:

- **Delegate to main agent**: Ask Claude Code to research complex architectural questions
- **Request code analysis**: Have main agent trace execution paths, identify APIs, etc.

**Example delegation:**
```
Analyze this codebase for documentation purposes:
1. What type of project is this? (library, app, CLI, API, etc.)
2. What are the main entry points and public APIs?
3. What configuration/environment variables are required?
4. Are there existing code comments worth extracting?
```

#### Layer 3: Web Search (Best Practices & Standards)

For questions about what SHOULD be documented or HOW to document it:

- **Search for standards**: "[tech stack] documentation best practices"
- **Find official guidelines**: Language/framework documentation standards
- **Look for examples**: "awesome [technology] documentation"

**When to use web search:**
- Unsure what documentation a project type needs
- Unfamiliar tech stack or framework
- Checking if standards have evolved
- Finding official guidelines (e.g., Python PEP 257, JSDoc conventions)
- Looking for good examples to reference

**Search patterns:**
- "[framework/language] documentation best practices 2024"
- "[framework] README template"
- "[project type] what to document"
- "awesome [technology] documentation examples"

#### Layer Application by Gap Size

| Gap Size | Layer 1 | Layer 2 | Layer 3 |
|----------|---------|---------|---------|
| **Minor** (missing detail) | ✓ Check code | - | - |
| **Medium** (missing section) | ✓ Check code | ✓ If complex | ✓ Check standards |
| **Major** (no docs/bootstrap) | ✓ Full scan | ✓ Full analysis | ✓ Full research |

**Only ask user if all applicable layers are inconclusive.**

### 2. Preference/Decision Uncertainty → Ask User

For questions that involve choices, opinions, or project direction:

- These cannot be resolved by investigation
- Ask the user (or main agent if delegated) directly
- Present options with trade-offs when possible

**Examples:**
- "Should changes be committed automatically or reviewed first?"
- "Should we standardize on name A or name B?"
- "What level of detail is appropriate for this documentation?"
- "Which external sources should be treated as authoritative?"

### 3. Trivial Corrections → Proceed with Notification

For minor, obvious fixes with no ambiguity:

- Make the correction
- Notify the user what was changed
- No need to ask permission for clearly correct fixes

**Examples:**
- Fixing a typo in documentation
- Updating an outdated count (e.g., "39 tests" → "42 tests" after verification)
- Fixing a broken internal link where the correct target is obvious
- Correcting obvious formatting issues

### Decision Matrix

| Uncertainty Type | Action | Example |
|------------------|--------|---------|
| Factual (minor) | Layer 1 → resolve | "What version?" → check package.json |
| Factual (medium) | Layer 1+2 → resolve | "Is feature complete?" → analyze code |
| Factual (standards) | Layer 1+3 → resolve | "What should API docs include?" → web search |
| Factual (complex) | All layers → resolve | "What docs does this project need?" → full investigation |
| Factual (inconclusive) | Ask user after investigation | "I checked but couldn't determine..." |
| Preference/Decision | Ask user directly | "Which naming convention do you prefer?" |
| Trivial correction | Fix and notify | "Updated test count from 39 to 42" |

### When Delegated by Main Agent

If an agent was invoked via Task tool by the main Claude Code agent:
- Return factual questions to the main agent for investigation (Layer 2)
- Return preference questions to the main agent to escalate to user
- Include context about what was already investigated

---

## Industry Standards Reference

### Universal Documentation (All Projects)

- **README.md** - Project overview, quick start, installation
- **LICENSE** - Required if distributing
- **CONTRIBUTING.md** - For open source projects

### By Project Type

| Type | Essential Docs | Recommended |
|------|----------------|-------------|
| **Node.js package** | README, package.json docs | API reference, CHANGELOG, examples/ |
| **Python library** | README, docstrings | Sphinx docs, readthedocs, type hints |
| **Web application** | README, setup guide | Architecture, deployment, env vars |
| **CLI tool** | README with usage | Man page, examples, --help text |
| **REST API** | Endpoint reference | OpenAPI/Swagger, authentication guide |
| **Monorepo** | Root README | Per-package READMEs, workspace guide |
| **Browser extension** | README, permissions explanation | Store listing content, privacy policy |
| **Mobile app** | README, setup guide | Store listing, screenshots, privacy policy |

### Standard README Sections

1. Project name and description (what it does)
2. Installation/Setup
3. Quick start / Usage examples
4. Configuration
5. API reference (or link to it)
6. Contributing
7. License

### Code Changes That Typically Need Documentation

| Change Type | Documentation Needed |
|-------------|---------------------|
| New public API | API reference docs |
| New feature | User guide update, README mention |
| Breaking change | Migration guide, CHANGELOG entry |
| New dependency | Setup docs, requirements |
| New config options | Configuration docs |
| Architecture change | Architecture docs, ADR |
| Security change | Security docs, CHANGELOG |

---

## Documentation Gap Analysis

Use this workflow when encountering sparse or missing documentation (during audit, bootstrap, or PR review):

### Step 1: Detect Documentation Gaps

Signs of sparse documentation:
- Few or no .md files found
- README missing or minimal
- No docs/ directory
- Code changes without corresponding doc updates

### Step 2: Identify Project Type

- Check package manifest files (package.json, pyproject.toml, Cargo.toml, etc.)
- Analyze directory structure
- Look for framework indicators
- Delegate to main agent if unclear

### Step 3: Research Standards (Layer 3)

- Web search for "[detected tech stack] documentation best practices"
- Find official guidelines if they exist
- Check for framework-specific documentation conventions

### Step 4: Analyze Codebase (Layers 1+2)

- Identify public APIs and exports
- Find configuration requirements
- Extract existing code comments
- Detect features that need documentation

### Step 5: Propose Documentation Structure

Based on industry standards + code analysis:
- List required documentation files
- List recommended additions
- Note what can be auto-generated vs needs human input
- Get user approval before creating anything

### Example Gap Analysis Output

```
Documentation Gap Analysis

Project Type: Node.js REST API (detected from package.json + Express routes)

Current State:
- README.md: Exists but minimal (setup only)
- API docs: Missing
- Architecture: Missing

Recommended Structure:
├── README.md (enhance: add API overview, examples)
├── docs/
│   ├── API.md (new: 12 endpoints detected)
│   ├── AUTHENTICATION.md (new: JWT auth in code)
│   └── DEPLOYMENT.md (new: Docker detected)
└── CHANGELOG.md (new: for version tracking)

Can auto-generate:
- API endpoint list from route analysis
- Environment variables from .env.example
- Dependencies from package.json

Needs human input:
- API usage examples
- Architecture decisions rationale
- Deployment specifics
```

---

## Maintenance & Versioning

**See `CLAUDE.md` in the repository root for versioning rules.**

This shared file is used by both `doc-maintainer` and `doc-pr-reviewer`. When this file is updated, both plugins must also be updated per the rules in CLAUDE.md.

### Change Log

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2025-11-30 | Added: Handling Uncertainty, Industry Standards, Gap Analysis |
| 1.0.0 | 2025-11-30 | Initial: Core Principles, Document Classification, Compliance Checklist |

---

## Version

Principles Version: 2.0.0
Last Updated: 2025-11-30
