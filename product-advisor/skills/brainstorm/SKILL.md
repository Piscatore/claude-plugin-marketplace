---
name: brainstorm
description: Structured ideation session that diverges, clusters, evaluates, and converges on actionable recommendations
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - WebSearch
---

# /brainstorm

Run a structured brainstorming session on a given topic. This skill guides ideation through four phases, pausing between each for user input.

## Usage

```
/brainstorm [topic or question]
```

**Examples:**

- `/brainstorm authentication strategies for our API`
- `/brainstorm how could we monetize this open-source tool`
- `/brainstorm new features for the dashboard`

If no topic is provided, ask the user what they'd like to brainstorm about.

## Workflow

### Phase 1: Diverge (Generate Ideas)

**Goal**: Quantity over quality. Generate as many ideas as possible.

1. **Scan project context** (if not already done this session) — read README, CLAUDE.md, package manifests, docs/ to understand what exists
2. **Optional web research** — if the topic benefits from market context or industry trends, do a quick search
3. **Generate ideas** — produce 10-20 ideas, ranging from obvious to unconventional. Include:
   - Safe, incremental ideas
   - Ambitious but feasible ideas
   - Wild, high-risk/high-reward ideas
   - Ideas that challenge the premise of the question
4. **Present as numbered list** with one-line descriptions

```markdown
## Phase 1: Diverge — Raw Ideas

1. **[Idea name]** — brief description
2. **[Idea name]** — brief description
...

> These are raw ideas — no filtering yet. What stands out? Want me to add more in any direction, or move to clustering?
```

**Pause here.** Wait for user feedback before proceeding.

### Phase 2: Cluster (Group Themes)

**Goal**: Organize ideas into coherent themes.

1. **Group ideas** into 3-6 clusters based on shared themes, approaches, or target audiences
2. **Name each cluster** with a descriptive theme label
3. **Note outliers** — ideas that don't fit any cluster (these are often the most interesting)

```markdown
## Phase 2: Cluster — Themes

### Theme A: [Name]
- Idea 1, Idea 5, Idea 12
- Common thread: [why these belong together]

### Theme B: [Name]
- Idea 3, Idea 7, Idea 8
- Common thread: [why these belong together]

### Outliers
- Idea 14: [why it's interesting despite not fitting]

> Do these groupings make sense? Want to merge, split, or re-assign any?
```

**Pause here.** Wait for user input.

### Phase 3: Evaluate (Assess Feasibility)

**Goal**: Assess each cluster's viability.

1. **For each cluster**, evaluate:
   - **Impact**: How much value would this deliver?
   - **Effort**: How hard is this to build/implement?
   - **Risk**: What could go wrong?
   - **Fit**: How well does this align with the project's current direction?
2. **Use a simple scoring table** (High/Medium/Low)

```markdown
## Phase 3: Evaluate

| Theme | Impact | Effort | Risk | Fit | Notes |
|-------|--------|--------|------|-----|-------|
| Theme A | High | Medium | Low | Strong | [brief note] |
| Theme B | Medium | Low | Medium | Moderate | [brief note] |
| ... | ... | ... | ... | ... | ... |

> Based on this, Themes A and C look most promising. Do you agree, or should we weight the criteria differently?
```

**Pause here.** Wait for user input.

### Phase 4: Converge (Recommend)

**Goal**: Produce actionable recommendations.

1. **Rank the top 3-5 ideas** based on the evaluation (incorporating user feedback from Phase 3)
2. **For each recommended idea**, provide:
   - **What**: Clear description
   - **Why**: Value proposition
   - **How** (high-level): First steps to explore or implement
   - **Watch out for**: Key risks or unknowns
3. **Suggest next steps** — what should happen after this brainstorm?

```markdown
## Phase 4: Converge — Recommendations

### 1. [Top Recommendation]
- **What**: ...
- **Why**: ...
- **How to start**: ...
- **Watch out for**: ...

### 2. [Second Recommendation]
...

## Next Steps
- [ ] [Actionable item]
- [ ] [Actionable item]
- [ ] [Actionable item]
```

## Saving Output

After Phase 4, offer to save the brainstorm output:

```markdown
Want me to save this brainstorm?

(x) Save to scratchpad (`docs/product/scratch/brainstorm-[topic]-[date].md`)
( ) Save to a specific location
( ) Don't save
```

If saving, write the complete brainstorm (all 4 phases) as a single markdown document.

## Behavioral Notes

- **Challenge intensity applies**: Weave in challenging questions appropriate to the configured intensity level. In Phase 1, keep it light (don't kill ideas early). In Phase 3-4, increase the challenge.
- **Respect user's pace**: Some users want to blow through all phases quickly. Others want to discuss each phase deeply. Follow the user's lead.
- **Don't skip phases**: Even if the user seems eager to jump to conclusions, the diverge-then-converge structure produces better outcomes than jumping straight to recommendations.
- **Web research is optional**: Only search when the topic genuinely benefits from external context (market trends, competitor analysis, industry standards). Don't search for every brainstorm.
