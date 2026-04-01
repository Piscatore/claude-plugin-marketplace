---
name: 0-define-work
description: "Define a work item: clarify requirements through dialogue, save a work brief, and create a feature branch. Entry point of the RPI workflow."
user-invocable: true
---

# Define Work

Define the work item before starting implementation. This is the entry
point of the RPI workflow — a structured dialogue that clarifies what
needs to be done before any code is touched.

## Process

### 1. Load Config

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.name` — for context
- `project.workingDirs` — where to save artifacts (default: `thoughts/shared/`)
- `project.branchPrefix` — prefix for branch names (default: none)

### 2. Check Git State

```bash
git status
git branch --show-current
```

**Gate conditions** (ask the user to resolve before continuing):
- [ ] No uncommitted changes on the current branch
- [ ] Not on `main` — if on main, that's expected (we'll create a branch)
- [ ] If on a feature branch, confirm: resume existing work or start fresh?

### 3. Gather the Work Brief

Conduct a **dialogue** with the user to establish four things. Ask about
each one, wait for answers, and ask follow-up questions until each point
is clear. Do not proceed until all four are resolved.

**A. Description** — What needs to be done?
- What is the feature, fix, or change?
- What problem does it solve or what value does it add?
- Is there a spec, issue, or document that describes it?
  - If yes: read it and confirm understanding with the user
  - If no: write one together through the dialogue

**B. Acceptance Criteria** — What does "done" look like?
- What specific behaviors or outcomes must be true when finished?
- Are there observable results (endpoints, UI, CLI output, test passing)?
- What should be verifiable by running the code?

**C. Scope Boundaries** — What is explicitly NOT included?
- Are there related features or improvements to defer?
- Any "nice to have" items that should wait for a follow-up?
- Which phases of a larger spec are in scope vs. out of scope?

**D. References** — What existing material informs this work?
- Spec documents or external resources
- Related issues or PRs
- Prior conversations or decisions
- Existing code that's similar to what's needed

### 4. Save the Work Brief

Write the brief to `{workingDirs.briefs}/{feature-slug}-brief.md`:

```markdown
# Work Brief: {Feature Name}

**Date**: {date}
**Slug**: {feature-slug}
**Status**: Defined

## Description
{What and why — 2-5 sentences}

## Acceptance Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Scope Boundaries
**In scope**:
- {item}

**Out of scope**:
- {item}

## References
- {spec, issue, or document links}

## Open Questions
- {Anything still unresolved — to be addressed in research/planning}
```

### 5. Create the Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b {branchPrefix}{feature-slug}
```

Confirm the branch was created and is clean.

### 6. Create Working Directories

Ensure the working directories exist:
```bash
mkdir -p {workingDirs.briefs}
mkdir -p {workingDirs.research}
mkdir -p {workingDirs.plans}
mkdir -p {workingDirs.sessions}
```

## Output

Confirm:
- Work brief saved
- Feature branch created from `main`
- Summary of what was agreed

Then suggest the next step based on complexity:
- **Large/unfamiliar**: proceed with `/1-research-codebase`
- **Medium/familiar**: proceed with `/2-create-plan`
- **Small/trivial**: proceed directly with `/4-implement-plan`
