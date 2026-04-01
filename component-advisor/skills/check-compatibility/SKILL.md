---
name: check-compatibility
description: "Verify whether a specific package or library is compatible with the current project's stack, framework version, existing dependencies, architecture patterns, and license policy. Produces a go/no-go assessment with specific concerns if any."
user-invocable: true
---

# Check Compatibility

Verify that a specific package fits the current project before adoption.

## Process

### 1. Identify the Package

Parse the user's request for the package name. Accept formats like:
- `/check-compatibility Polly`
- `/check-compatibility MassTransit v8.2`
- `/check-compatibility` (then ask what to check)

If no package specified:
```markdown
What package would you like to check compatibility for?

Provide the package name (and optionally version).
```

### 2. Load Project Context

This skill requires thorough project context:

- **Ecosystem**: Detect from project files
- **Framework version**: Read from project files (e.g., `<TargetFramework>` in .csproj, `engines` in package.json)
- **Existing dependencies**: Full inventory from manifest files
- **Architecture**: Read CLAUDE.md and project structure for patterns (DI, async, layering)
- **Config**: Load `.claude/component-advisor.json` for license policy and constraints

### 3. Research the Package

Gather detailed information about the target package:

- **Target frameworks**: What does it support? (e.g., .NET 8+, .NET Standard 2.0)
- **Dependencies**: Full transitive dependency tree (as visible from registry)
- **License**: Exact license identifier
- **Latest version**: Current stable release
- **API style**: Does it use DI? Async? Static methods? Fluent API?
- **Known issues**: Any critical bugs or breaking changes in the target version

### 4. Run Compatibility Checks

Check each dimension and produce a pass/warn/fail status:

#### Framework Compatibility
```markdown
[PASS] Framework: Package targets .NET 8+, project is .NET 9
```
or
```markdown
[FAIL] Framework: Package requires .NET 10, project is on .NET 8
```

#### Dependency Conflicts
Check every transitive dependency of the candidate against the project's existing packages:

```markdown
[PASS] No dependency conflicts found

Transitive dependencies (4):
- Microsoft.Extensions.DependencyInjection.Abstractions (already in project)
- Microsoft.Extensions.Logging.Abstractions (already in project)
- System.Threading.Channels (framework-included)
- Polly.Core (new — no conflict)
```

or

```markdown
[WARN] Potential conflict: Package depends on Newtonsoft.Json >= 13.0.
Your project uses System.Text.Json exclusively. Adding Newtonsoft.Json
increases bundle size and creates two JSON serialization paths.
```

#### License Compliance
```markdown
[PASS] License: Apache-2.0 (in allowlist)
```
or
```markdown
[FAIL] License: GPL-3.0 (in denylist). This license requires derivative
works to also be GPL-licensed, which conflicts with your MIT project.
```

#### Maintenance Health
```markdown
[PASS] Maintenance: Last release 3 weeks ago, monthly cadence, 45 contributors
```
or
```markdown
[WARN] Maintenance: Last release 9 months ago. Single maintainer.
Consider bus factor risk for production use.
```

#### Security
```markdown
[PASS] Security: No known CVEs for v8.2.0
```
or
```markdown
[FAIL] Security: CVE-2024-XXXXX affects versions < 8.1.2.
Ensure you install v8.1.2 or later.
```

#### Architectural Fit
Assess whether the package's API style matches the project's patterns:

```markdown
[PASS] Architecture: DI-friendly (registers via AddPolly()), async-first,
matches project's service registration pattern.
```
or
```markdown
[WARN] Architecture: Package uses static factory methods rather than DI.
Your project uses constructor injection exclusively. You'll need a wrapper
or adapter to maintain consistency.
```

#### Overlap with Existing Dependencies
```markdown
[PASS] No functional overlap with existing packages.
```
or
```markdown
[WARN] Overlap: Your project already has Microsoft.Extensions.Http.Resilience
which provides retry and circuit breaker via Polly internally. Adding Polly
directly may be redundant unless you need it outside of HTTP calls.
```

### 5. Produce Compatibility Report

```markdown
## Compatibility Report: [Package] v[version]

**Project:** [name] ([ecosystem] [version])
**Date:** [date]

### Results

| Check | Status | Details |
|-------|--------|---------|
| Framework | PASS | Targets .NET 8+, project is .NET 9 |
| Dependencies | PASS | 4 transitive deps, 2 already in project |
| License | PASS | Apache-2.0 (in allowlist) |
| Maintenance | PASS | Active, monthly releases, 45 contributors |
| Security | PASS | No known CVEs |
| Architecture | PASS | DI-friendly, async-first |
| Overlap | WARN | Partial overlap with existing resilience setup |

### Overall: COMPATIBLE (with notes)

**Go ahead with adoption**, but note:
- Review overlap with Microsoft.Extensions.Http.Resilience to avoid
  configuring retry policies in two places.

### Installation

`dotnet add package Polly --version 8.2.0`
```

### Summary Verdicts

Use one of these:

- **COMPATIBLE** — No issues found. Safe to adopt.
- **COMPATIBLE (with notes)** — Minor concerns that don't block adoption but should be addressed.
- **CAUTION** — Significant concerns. Review carefully before adopting.
- **INCOMPATIBLE** — Blocking issues found. Do not adopt without resolving.

### 6. Offer to Save

Offer to save the compatibility report to `outputDir`.

## Output

- Per-dimension pass/warn/fail assessment
- Overall compatibility verdict
- Specific concerns with actionable guidance
- Installation command if compatible
- Optional saved report
