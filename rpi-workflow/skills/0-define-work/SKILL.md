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

**Gate conditions**:
- [ ] No uncommitted changes on the current branch
- [ ] Not on `main` — if on main, that's expected (we'll create a branch)
- [ ] If on a feature branch, confirm: resume existing work or start fresh?

If any gate condition is unresolved, ask the user via `AskUserQuestion`.
Example for the "on a feature branch" case:

```
AskUserQuestion({
  questions: [{
    question: "You're on feature branch '{branch}' with {N} uncommitted changes. How do you want to proceed?",
    header: "Branch state",
    multiSelect: false,
    options: [
      { label: "Resume this work (Recommended)", description: "Keep this branch and changes, skip the new brief" },
      { label: "Stash and start fresh",          description: "git stash, then create a new feature branch from main" },
      { label: "Commit, then start fresh",       description: "Commit the current work, then branch off main for new work" }
    ]
  }]
})
```

### 3. Gather the Work Brief (Interview)

Collect the four pieces of the brief — **Description**, **Acceptance
Criteria**, **Scope Boundaries**, **References** — through one or more
`AskUserQuestion` calls. Do NOT write a free-form "please answer these
questions" block; the tool is the interview channel.

**First pass** — read any linked spec or document the user has already
pointed at (brief request, GitHub issue URL, etc.) before asking
anything, so options can be pre-populated with concrete, recommended
choices instead of open-ended prompts.

**Interview batch 1 — Description & source of truth** (one call):

```
AskUserQuestion({
  questions: [
    {
      question: "What kind of change is this?",
      header: "Change type",
      multiSelect: false,
      options: [
        { label: "Feature",  description: "New user-facing capability or behavior" },
        { label: "Fix",      description: "Bug fix, incorrect behavior, or regression" },
        { label: "Refactor", description: "Internal restructuring with no behavior change" },
        { label: "Chore",    description: "Tooling, deps, build, or docs only" }
      ]
    },
    {
      question: "Is there an existing spec, issue, or document that describes the work?",
      header: "Source doc",
      multiSelect: false,
      options: [
        { label: "Yes — I'll share the path/URL",        description: "You'll paste a path or URL; I'll read it before continuing" },
        { label: "No — we'll define it in this session", description: "We'll build the description together through this interview" }
      ]
    }
  ]
})
```

If the user answered "Yes", follow up with a free-text "Other" answer
(the user supplies the path/URL) via a second `AskUserQuestion` call, or
— if the path/URL is already in the conversation — read it now and skip
ahead.

**Interview batch 2 — Acceptance criteria shape**:

```
AskUserQuestion({
  questions: [{
    question: "How should 'done' be verifiable?",
    header: "Verifiable by",
    multiSelect: true,
    options: [
      { label: "Automated test passes",  description: "A new or existing test exercises the behavior" },
      { label: "Build succeeds",         description: "Static/type/build checks confirm the change" },
      { label: "Manual UI/CLI check",    description: "Human verification of observable output" },
      { label: "External endpoint call", description: "API/endpoint returns the expected response" }
    ]
  }]
})
```

Use the selected categories to structure concrete criteria. For each
selected category, draft 1–3 specific criteria and confirm them with a
single follow-up `AskUserQuestion` where each option is a draft
criterion (user edits via "Other" if wrong).

**Interview batch 3 — Scope boundaries** (up to 4 related questions in
one call):

```
AskUserQuestion({
  questions: [
    {
      question: "Is related area X in scope?",
      header: "Scope: X",
      multiSelect: false,
      options: [
        { label: "In scope",                description: "Covered by this work item" },
        { label: "Out of scope (follow-up)",description: "Defer to a later work item" },
        { label: "Not applicable",          description: "Unrelated — ignore" }
      ]
    }
    // Repeat per candidate scope area identified from the spec/issue.
  ]
})
```

**Interview batch 4 — References** — only ask if not already collected
in batch 1. Use `AskUserQuestion` with a single `multiSelect: true`
question listing candidate reference types (spec doc, related issue,
prior PR, similar code path, external API doc) and let the user tick
each applicable one via "Other" free-text.

**Do not proceed to step 4 until every brief section has at least one
concrete answer.** If a follow-up is needed because an answer was too
thin, issue another `AskUserQuestion` call — never revert to free-form
prose prompts.

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
