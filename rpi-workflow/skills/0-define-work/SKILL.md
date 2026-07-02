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

Check git state by running
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.ps1` (PowerShell) or
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.sh` (bash) and parsing the JSON
line it prints. Fall back to individual git commands only if the script
fails.

**Gate conditions**:
- [ ] No uncommitted changes on the current branch
- [ ] Not on `main` — if on main, that's expected (we'll create a branch)
- [ ] If on a feature branch, confirm: resume existing work or start fresh?

If any gate condition is unresolved, ask the user via `AskUserQuestion`
(see step 3 for the interview reference).

### 3. Gather the Work Brief (Interview)

All user dialogue follows the shared interview pattern. Before the first
`AskUserQuestion` call of a session, read
`${CLAUDE_PLUGIN_ROOT}/references/interview-pattern.md`. Do not restate its
rules here — batch questions, offer 2–4 concrete options, never ask what is
already in context.

First read any spec/issue/document the user has already pointed at, and
pre-populate options from it. Then conduct the interview in **at most two
AskUserQuestion calls**:

- **Call 1 (always, ≤4 questions)**: change type (Feature/Fix/Refactor/
  Chore) · source document (yes-will-share / define-here) · how "done"
  is verifiable (multiSelect: test/build/manual/endpoint) · plus the
  branch-state question if git state was unresolved.
- **Call 2 (only if needed, ≤4 questions)**: scope boundaries per
  candidate area (In scope / Out of scope / N/A) and confirmation of
  drafted acceptance criteria (each option = one draft criterion).

Do not proceed to step 4 until every brief section has at least one
concrete answer; follow up with another call only for genuinely thin
answers.

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
