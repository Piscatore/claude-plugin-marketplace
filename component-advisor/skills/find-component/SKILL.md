---
name: find-component
description: "Interview-driven discovery of external components and libraries for a design need. Detects the project ecosystem, interviews for requirements, searches package registries, evaluates candidates, checks for overlap with existing dependencies, and produces a scored recommendation."
user-invocable: true
---

# Find Component

Discover and recommend external components or libraries that solve a specific design need.

## Process

### 1. Understand the Context

**Load project context:**
- Detect ecosystem from project files (see agent spec Ecosystem Detection)
- Read dependency manifest to inventory what's already installed
- Read `.claude/component-advisor.json` if it exists for config overrides
- Read `CLAUDE.md` for architectural preferences or component policies

**Report what you found:**
```markdown
Detected: .NET 9 project (src/MyApp.Api.csproj)
Existing packages: 24 NuGet references
Config: .claude/component-advisor.json found (license allowlist: MIT, Apache-2.0)
```

### 2. Interview for Requirements

If the user's request is not fully specific, ask clarifying questions. One at a time, with defaults:

**Essential questions (ask if unclear):**
1. What specific problem or design task does this component need to solve?
2. Are there performance, size, or API style constraints?
3. Any license restrictions? (suggest config defaults if set)
4. How critical is this component? (core infrastructure vs. utility)

**Skip the interview when:**
- The user's request is specific enough (e.g., "find a .NET CSV parser that handles streaming")
- You can infer everything from context
- The user says "just search" or similar

### 3. Check for Existing Coverage

Before searching externally, check if the need is already covered:

1. **Framework built-in**: Does the framework itself provide this? (e.g., `System.Text.Json` for JSON in .NET, `crypto` module in Node.js)
2. **Existing dependency**: Does any installed package already handle this? Check both direct and well-known transitive dependencies.
3. **Partial coverage**: Can an existing dependency be used differently to cover this need?

If coverage exists, report it:
```markdown
### Existing Coverage Check

Your project already has **Serilog** installed, which includes structured logging with
JSON formatting. This may already cover your need for structured log output.

( ) **Use Serilog** — it already does what you need
( ) **Search anyway** — I need something Serilog doesn't cover (explain what)
```

### 4. Search for Candidates

If no existing coverage, search for candidates:

1. **Registry search**: Search the appropriate package registry via WebSearch
2. **Community search**: Search for "[need] best library [ecosystem] [current year]" for community recommendations
3. **Official docs**: Check if the framework has recommended packages or built-in alternatives
4. **Collect 3-5 candidates** minimum before narrowing down

For each candidate, gather:
- Package name and latest version
- Description and primary use case
- License
- Last release date
- Download count / GitHub stars
- Transitive dependency count
- Any known issues or CVEs

### 5. Evaluate Top Candidates

Narrow to the top 2-3 candidates and evaluate each using the agent spec Evaluation Criteria scorecard format.

Check each against:
- Config `licenseAllowlist` / `licenseDenylist`
- Config `maxTransitiveDeps`
- Config `minimumMaintenanceMonths`
- Config `securityPolicy`

### 6. Check for Conflicts

For the top candidate(s):
- Check transitive dependency conflicts with existing packages
- Check framework version compatibility
- Check for known incompatibilities

### 7. Present Recommendation

Present the evaluation with a clear recommendation:

```markdown
## Recommendation

**Use [Package] (v[version])** for [need].

| Dimension | Rating | Notes |
|-----------|--------|-------|
| ... | ... | ... |

**Why this one:**
- [Key differentiator 1]
- [Key differentiator 2]

**Runner-up:** [Alternative] — [why it's second choice]

**To install:** `[install command]`
```

### 8. Offer to Save

If `outputDir` is configured, offer to save the evaluation:

```markdown
Save this evaluation to `docs/component-evaluations/csv-parser-evaluation.md`?

( ) Yes, save it
( ) No, the conversation is enough
```

## Output

- A scored evaluation of 2-3 candidates
- A clear recommendation with justification
- Install command for the recommended package
- Optional saved evaluation report
