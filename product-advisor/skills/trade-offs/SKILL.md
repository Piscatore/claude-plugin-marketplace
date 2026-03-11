---
name: trade-offs
description: Analyze decisions with structured options, pros/cons, risk assessment, and decision matrix
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebSearch
---

# /trade-offs

Analyze a product or technical decision by generating structured options with pros, cons, risks, costs, and reversibility. Produces a decision matrix and narrative recommendation.

## Usage

```
/trade-offs [decision or question to analyze]
```

**Examples:**

- `/trade-offs should we build a REST API or GraphQL API`
- `/trade-offs monorepo vs polyrepo for our microservices`
- `/trade-offs how should we handle user authentication`
- `/trade-offs pricing model for our SaaS product`

If no decision is provided, ask the user what they're deciding.

## Workflow

### Step 1: Clarify the Decision

Before analyzing, make sure the decision is well-framed:

1. **Restate the decision** in your own words to confirm understanding
2. **Identify constraints** — what's fixed? (budget, timeline, team size, existing tech stack, etc.)
3. **Identify decision criteria** — what matters most? Ask if not obvious:

```markdown
Before I analyze this, let me confirm:

**Decision**: [restated]
**Key constraints**: [what I inferred from context]

What matters most in this decision?

[ ] Cost / resource efficiency
[ ] Speed to implement
[ ] Long-term maintainability
[ ] User experience
[ ] Technical risk / safety
[ ] Flexibility / reversibility
[ ] Other: ___

> Pick your top 2-3, or tell me if I'm framing this wrong.
```

If the user wants to skip this step, proceed with reasonable defaults.

### Step 2: Generate Options

Produce a minimum of 3 options, always including:

1. **Option A: Do Nothing / Status Quo** — what happens if we don't decide? This is always a valid option and often undervalued.
2. **Option B: [Most obvious approach]** — the conventional or popular choice
3. **Option C: [Alternative approach]** — a meaningfully different approach
4. **Option D+ (if applicable)**: Additional options when the decision space warrants it

For each option:

```markdown
### Option [X]: [Name]

**Description**: [2-3 sentences explaining the approach]

**Pros**:
- [Specific advantage, tied to the project's context]
- [Another advantage]

**Cons**:
- [Specific disadvantage]
- [Another disadvantage]

**Risks**:
- [What could go wrong] — Likelihood: [Low/Medium/High], Impact: [Low/Medium/High]

**Estimated Cost**: [Relative: Low/Medium/High — in terms of time, effort, money, or complexity]

**Reversibility**: [Easy/Moderate/Difficult/Irreversible] — [brief explanation of what it takes to undo]
```

### Step 3: Decision Matrix

Produce a comparison table using the criteria from Step 1:

```markdown
## Decision Matrix

| Criteria | Weight | Option A: Do Nothing | Option B: [Name] | Option C: [Name] |
|----------|--------|---------------------|-------------------|-------------------|
| Cost | [H/M/L] | [score] | [score] | [score] |
| Speed | [H/M/L] | [score] | [score] | [score] |
| Maintainability | [H/M/L] | [score] | [score] | [score] |
| Risk | [H/M/L] | [score] | [score] | [score] |
| Reversibility | [H/M/L] | [score] | [score] | [score] |
| **Weighted Total** | | **[total]** | **[total]** | **[total]** |
```

Use a simple 1-5 scale. Weight reflects the user's stated priorities.

### Step 4: Narrative Recommendation

Don't just point to the highest score. Provide reasoning:

```markdown
## Recommendation

**I'd lean toward Option [X]: [Name].**

[2-3 sentences explaining why, referencing the specific context of this project and decision.]

**Key factor**: [The single most important consideration that tips the balance]

**What would change my mind**: [What conditions would make a different option better — this is important for honest analysis]

**If you choose this, watch out for**: [The biggest risk of the recommended option and how to mitigate it]
```

### Step 5: Challenge Pass

Apply challenge intensity to the recommendation:

- **Low**: "One thing to consider before committing: [gentle pushback]"
- **Medium**: Weave counter-arguments into the recommendation section
- **High**: Add a dedicated "Case Against the Recommendation" section that argues for the second-best option

### Step 6: Save Output

The trade-off analysis follows the two-tier save model:

1. **Draft to scratchpad first** — write the complete analysis to `scratchDir`
2. **Offer to document as ADR**:

```markdown
This analysis could be documented as an Architecture Decision Record.

( ) **Save as ADR** — I'll draft it in ADR format
(x) **Keep as scratchpad note** — already saved to `docs/product/scratch/`
( ) **Don't save anything**
```

If saving as ADR:
- Check if doc-maintainer is installed
  - **If yes**: Draft the ADR content and suggest the user invoke doc-maintainer to file it properly (temporal integrity, proper numbering, etc.)
  - **If no**: Write directly to `decisionLogPath` from config. Use standard ADR format: Title, Status (Proposed), Context, Decision, Consequences.
- Check `rememberedPaths.adr` in config for the save location
- If no remembered path, suggest `decisionLogPath` from config (default: `docs/adr/`)
- Confirm path with user, then save and update `rememberedPaths`

## Output Format

The complete analysis as a single markdown document:

```markdown
# Trade-Off Analysis: [Decision]

*Analyzed: [date]*

## Decision Context
**Decision**: ...
**Constraints**: ...
**Criteria**: ...

## Options

### Option A: Do Nothing
...

### Option B: [Name]
...

### Option C: [Name]
...

## Decision Matrix
[table]

## Recommendation
...

## What Would Change My Mind
...

---
*Generated by product-advisor v1.0.0*
```

## Behavioral Notes

- **"Do Nothing" is always an option**: Never skip it. It forces honest evaluation of whether the decision is even necessary right now.
- **Be specific to the project**: Generic pros/cons lists are useless. "GraphQL is more flexible" means nothing without context. "GraphQL would let your mobile app fetch only the 3 fields it needs from the user profile, reducing payload size" is useful.
- **Web research adds value here**: For technical decisions, search for real-world experience reports, not just marketing pages. "Companies that migrated from X to Y" is more valuable than "X vs Y comparison."
- **Reversibility matters more than people think**: Highlight it. An irreversible decision with a slightly higher score should give pause compared to an easily reversible one.
- **Don't manufacture false balance**: If one option is clearly superior, say so. Not every decision is a close call. But explain why clearly enough that the user can verify your reasoning.
