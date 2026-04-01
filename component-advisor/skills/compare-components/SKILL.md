---
name: compare-components
description: "Structured side-by-side comparison of two or more candidate packages or libraries. Evaluates each on maintenance, compatibility, quality, and strategic fit using the component-advisor scorecard. Produces a decision matrix with a clear recommendation."
user-invocable: true
---

# Compare Components

Perform a structured, side-by-side comparison of candidate packages for a specific need.

## Process

### 1. Identify Candidates

Parse the user's request for candidate names. Accept formats like:
- `/compare-components CsvHelper vs Sylvan.Data.Csv`
- `/compare-components Serilog, NLog, Microsoft.Extensions.Logging`
- `/compare-components` (then ask what to compare)

If no candidates are specified, ask:

```markdown
What packages would you like to compare?

Provide 2-4 package names, or describe a need and I'll find candidates for you.
```

### 2. Load Project Context

- Detect ecosystem
- Read dependency manifest
- Load config if it exists
- Note which candidates (if any) are already installed

### 3. Clarify the Use Case

If not already clear from context, ask:

```markdown
What will you use this for?

This helps me evaluate fit, not just features. A brief description is fine.
```

### 4. Research Each Candidate

For each candidate, gather via web search:

**Registry data:**
- Latest version and release date
- Total downloads / weekly downloads
- License
- Target framework(s)
- Dependency count

**Repository data:**
- GitHub stars and recent activity
- Open issues and PR count
- Contributors count
- Last commit date

**Quality signals:**
- Documentation quality (quick assessment)
- Known issues or breaking changes in recent versions
- Community sentiment (blog posts, Stack Overflow, Reddit discussions)

### 5. Build Comparison Matrix

Present the raw data side by side:

```markdown
## Comparison: [Need]

| Dimension | CsvHelper | Sylvan.Data.Csv | TinyCsvParser |
|-----------|-----------|-----------------|---------------|
| Version | 33.0.1 | 1.3.9 | 2.7.0 |
| License | MS-PL / Apache 2.0 | MIT | MIT |
| Downloads | 380M | 4.2M | 850K |
| GitHub stars | 4.8k | 320 | 180 |
| Last release | 2 weeks ago | 3 months ago | 14 months ago |
| Contributors | 290+ | 1 | 3 |
| Transitive deps | 0 | 0 | 1 |
| .NET 9 support | Yes | Yes | Yes |
| Async support | Yes | Yes | No |
| Streaming | Yes | Yes (fastest) | No |
```

### 6. Evaluate Each Candidate

Score each using the agent spec evaluation criteria. Use the scorecard format for each:

```markdown
### CsvHelper

| Dimension | Rating | Notes |
|-----------|--------|-------|
| Maintenance | Excellent | Active, regular releases, large contributor base |
| Compatibility | Excellent | .NET 8+, async, DI-friendly |
| Quality | Strong | Extensive docs, huge community |
| Strategic fit | Good | Widely adopted, low lock-in risk |

### Sylvan.Data.Csv

| Dimension | Rating | Notes |
|-----------|--------|-------|
| Maintenance | Good | Regular releases, but single maintainer |
| Compatibility | Excellent | .NET 8+, fastest benchmarks |
| Quality | Good | Focused scope, good docs |
| Strategic fit | Caution | Bus factor risk (single maintainer) |
```

### 7. Conflict & Overlap Check

For each candidate, check:
- Transitive dependency conflicts with the project's existing packages
- Whether the project already has a package that overlaps
- License compatibility with the project

### 8. Decision Matrix

Produce a weighted decision matrix:

```markdown
## Decision Matrix

| Criteria (weight) | CsvHelper | Sylvan.Data.Csv | TinyCsvParser |
|--------------------|-----------|-----------------|---------------|
| Maintenance (25%) | 5 | 4 | 2 |
| Performance (20%) | 4 | 5 | 3 |
| API quality (20%) | 5 | 4 | 3 |
| Community (15%) | 5 | 3 | 2 |
| Compatibility (10%) | 5 | 5 | 4 |
| Minimal deps (10%) | 5 | 5 | 4 |
| **Weighted total** | **4.75** | **4.25** | **2.75** |
```

If the user has specific priorities, adjust weights accordingly. Ask if defaults feel wrong.

### 9. Recommendation

```markdown
## Recommendation

**CsvHelper** is the strongest overall choice.

**Why:**
- Best-maintained with the largest community and contributor base
- Excellent documentation and ecosystem of examples
- Zero transitive dependencies
- Proven at scale (380M+ downloads)

**When to pick Sylvan instead:**
- If raw parsing performance is the top priority (benchmarks show 2-3x faster)
- If you accept the single-maintainer risk for the performance gain

**Avoid TinyCsvParser:**
- Stale (14 months since last release)
- No async support
- Smallest community
```

### 10. Offer to Save

Offer to save the comparison to `outputDir`.

## Output

- Raw data comparison table
- Per-candidate scorecard
- Weighted decision matrix
- Clear recommendation with reasoning and when to pick alternatives
- Optional saved report
