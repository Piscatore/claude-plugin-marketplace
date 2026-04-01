---
name: audit-dependencies
description: "Health scan of existing project dependencies. Checks for outdated packages, security vulnerabilities, abandoned projects, license issues, overlap between packages, and unused dependencies. Produces a structured audit report."
user-invocable: true
---

# Audit Dependencies

Scan the project's existing dependency graph for health, security, overlap, and maintenance issues.

## Process

### 1. Detect and Load

- Detect ecosystem from project files
- Read all dependency manifests (handle monorepos — scan for multiple manifests)
- Read `.claude/component-advisor.json` if it exists
- Build a complete inventory of direct dependencies

**Report scope:**
```markdown
Scanning dependencies...

Found 3 dependency manifests:
- src/MyApp.Api/MyApp.Api.csproj (18 packages)
- src/MyApp.Core/MyApp.Core.csproj (4 packages)
- src/MyApp.Tests/MyApp.Tests.csproj (8 packages)

Total unique packages: 24 (6 shared across projects)
```

### 2. Categorize Dependencies

Group each dependency by function:

| Category | Examples |
|----------|---------|
| Framework / Runtime | Microsoft.AspNetCore.*, Microsoft.Extensions.* |
| Data Access | EF Core, Dapper, Npgsql |
| Serialization | System.Text.Json, Newtonsoft.Json, MessagePack |
| Logging / Observability | Serilog, OpenTelemetry |
| Testing | xUnit, Moq, FluentAssertions |
| Security / Auth | Identity, JWT libraries |
| Utilities | AutoMapper, FluentValidation, Polly |
| Build / Tooling | analyzers, source generators |

This categorization helps spot overlap.

### 3. Health Checks

For each direct dependency, check via web search:

**Maintenance health:**
- When was the latest version released?
- Is there a newer major/minor version available?
- Is the project actively maintained (commits in last 6 months)?
- Single maintainer or community-backed?

**Security:**
- Any known CVEs or security advisories?
- Any deprecated packages?
- For .NET: check if `dotnet list package --vulnerable` equivalent data exists

**License:**
- Is the license compatible with the project?
- Check against `licenseAllowlist` / `licenseDenylist` from config

### 4. Overlap Detection

Look for functional overlap between installed packages:

- Multiple logging frameworks (Serilog + NLog)
- Multiple JSON serializers (Newtonsoft.Json + System.Text.Json without clear separation)
- Multiple HTTP client wrappers
- Multiple validation libraries
- Multiple mapping libraries

For each overlap found:
```markdown
### Overlap: JSON Serialization

- **System.Text.Json** — Used in API controllers (built-in)
- **Newtonsoft.Json** — Referenced in MyApp.Core, used by 1 file

**Recommendation:** Evaluate if Newtonsoft.Json usage can be migrated to System.Text.Json
to reduce dependency count. Check if any features require Newtonsoft specifically
(e.g., polymorphic deserialization in older patterns).
```

### 5. Staleness Check

Flag packages that appear unused or rarely referenced:

- Search the codebase (via Grep) for import/using statements referencing each package
- Packages with zero or very few references may be unused
- Flag but don't recommend removal without confirmation — they may be used transitively or via reflection

### 6. Produce Audit Report

```markdown
# Dependency Audit Report

**Project:** [name]
**Date:** [date]
**Total direct dependencies:** [count]

## Summary

| Category | Count | Issues |
|----------|-------|--------|
| Outdated | 3 | Minor updates available |
| Security | 1 | Known CVE (medium severity) |
| Maintenance concern | 2 | No release in 12+ months |
| License issue | 0 | All compliant |
| Overlap | 1 | JSON serialization (2 libraries) |
| Possibly unused | 2 | Low reference count |

## Critical Issues

### [CVE-XXXX-XXXX] PackageName v1.2.3
- **Severity:** Medium
- **Description:** [brief]
- **Fix:** Upgrade to v1.2.5+
- **Reference:** [link]

## Outdated Packages

| Package | Current | Latest | Gap |
|---------|---------|--------|-----|
| ... | ... | ... | ... |

## Maintenance Concerns

| Package | Last Release | Status |
|---------|-------------|--------|
| ... | ... | ... |

## Overlap Analysis

[Details per overlap found]

## Possibly Unused

| Package | References Found | Recommendation |
|---------|-----------------|----------------|
| ... | ... | Investigate |

## Recommendations

1. **Immediate:** [security fixes]
2. **Short-term:** [outdated updates]
3. **Consider:** [overlap resolution, unused removal]
```

### 7. Offer to Save

Offer to save the audit report to `outputDir`:

```markdown
Save this audit report to `docs/component-evaluations/dependency-audit-2026-04-01.md`?
```

## Output

- Categorized dependency inventory
- Structured audit report with severity-ranked findings
- Actionable recommendations prioritized by urgency
- Optional saved report file
