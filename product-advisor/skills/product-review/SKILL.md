---
name: product-review
description: Holistic product analysis covering strengths, gaps, opportunities, risks, and next steps
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebSearch
---

# /product-review

Conduct a comprehensive product-level review of the current project. This skill discovers project context flexibly, then produces a structured analysis.

## Usage

```
/product-review
/product-review [specific aspect to focus on]
```

**Examples:**

- `/product-review` — full product review
- `/product-review developer experience` — focused review of DX
- `/product-review competitive positioning` — how this compares to alternatives

## Workflow

### Step 1: Discover Project Context

Scan the project to understand what it is. Check for (in order):

1. **README.md** — project description, features, purpose
2. **CLAUDE.md** — development conventions, architecture notes
3. **Package manifests** — `package.json`, `Cargo.toml`, `pyproject.toml`, `*.csproj`, `plugin.json`
4. **docs/ directory** — architecture docs, specs, guides, ADRs
5. **Source structure** — `Glob` for top-level directories and key files
6. **Config files** — `.claude/doc-maintainer.json`, `.claude/product-advisor.json`

Don't read every file — scan filenames and headers to build a picture, then read deeply only where needed.

**Report what you found:**

```markdown
## Project Context

**Project**: [name] — [one-line description]
**Type**: [library / API / web app / CLI tool / plugin / etc.]
**Tech stack**: [languages, frameworks, key dependencies]
**Maturity signals**: [commit history depth, version number, docs coverage]
**Target audience**: [who this is for, based on README/docs]
```

### Step 2: Analyze

Produce a structured analysis covering six dimensions. If the user specified a focus area, weight that dimension more heavily but still cover the others briefly.

#### Product Summary

2-3 sentences capturing what this product is, who it's for, and what problem it solves. Written as if explaining to someone who has never seen the project.

#### Strengths

What the project does well. Look for:

- Clear value proposition
- Well-defined scope
- Good developer/user experience signals
- Strong documentation
- Thoughtful architecture decisions (check ADRs if they exist)
- Active maintenance signals

Be specific — reference actual files, features, or design choices. Don't just say "good documentation" — say "the plugin-development-guide.md provides clear step-by-step instructions with examples."

#### Gaps

What's missing or underdeveloped. Look for:

- Features mentioned but not implemented
- Missing documentation for key workflows
- Unclear onboarding path
- Missing error handling or edge case coverage
- No testing strategy visible
- Configuration or deployment gaps

Frame gaps constructively — not "this is bad" but "adding X would strengthen Y."

#### Opportunities

What the project could do next for maximum impact. Consider:

- Unserved use cases visible from the codebase
- Natural extensions of existing features
- Integration possibilities
- Developer experience improvements
- Market positioning moves

Prioritize opportunities by expected impact.

#### Risks

What could go wrong or what threatens the project's success. Categories:

- **Technical risk**: Architecture decisions that may not scale, dependencies that could break
- **Market risk**: Competition, changing user needs, timing
- **Operational risk**: Bus factor, maintenance burden, deployment complexity
- **Adoption risk**: Barriers to getting started, learning curve, unclear value prop

For each risk, note likelihood (low/medium/high) and impact (low/medium/high).

#### Next Steps

Concrete, prioritized recommendations. Format as a numbered list with rationale:

```markdown
## Next Steps

1. **[Action]** — [Why this matters and what it unlocks]
2. **[Action]** — [Why this matters and what it unlocks]
3. **[Action]** — [Why this matters and what it unlocks]
```

Limit to 3-5 next steps. If everything is a priority, nothing is.

### Step 3: Challenge Pass

Apply challenge questioning appropriate to the configured intensity:

- **Low**: Add a "Considerations" section with gentle questions
- **Medium**: Weave challenges into each section (e.g., "The clear scope is a strength, but it also means [limitation]")
- **High**: Add a dedicated "Devil's Advocate" section that stress-tests the analysis itself

### Step 4: Offer to Save

```markdown
Want me to save this product review?

(x) Save to scratchpad (`docs/product/scratch/product-review-[date].md`)
( ) Save to a specific location
( ) Don't save — this was just for discussion
```

## Output Format

The complete review should be a single, well-structured markdown document:

```markdown
# Product Review: [Project Name]

*Reviewed: [date]*

## Product Summary
...

## Strengths
...

## Gaps
...

## Opportunities
...

## Risks
| Risk | Category | Likelihood | Impact | Notes |
|------|----------|------------|--------|-------|
| ... | ... | ... | ... | ... |

## Next Steps
1. ...
2. ...
3. ...

---
*Generated by product-advisor v1.0.0*
```

## Behavioral Notes

- **Don't be sycophantic**: A review that says everything is great is useless. Find real gaps and risks, even if the project is well-built.
- **Be specific**: Reference actual files, features, and design choices. Generic observations like "good code quality" add no value.
- **Calibrate to maturity**: An early-stage project needs different advice than a mature one. Don't criticize a v0.1 for not having what a v3.0 should have.
- **Web research**: Search for competing projects or industry standards when it would add genuine insight to the analysis. Don't search just to pad the review.
