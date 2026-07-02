---
name: 2-create-plan
description: "Create a step-by-step implementation plan from research findings. Respects project architecture layers and pauses at a clarification gate for design decisions."
user-invocable: true
---

# Create Implementation Plan

Create a detailed, step-by-step implementation plan based on research.

## Process

### 1. Load Context

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.workingDirs`, `project.buildCommand` / `project.testCommand`
- `architecture.layers`, `architecture.dependencyFlow`, `architecture.codePatterns`

Read only what this step needs: the work brief's **Acceptance Criteria**
and **Scope Boundaries** sections, and the research document. Do NOT
re-read specs already summarized into the research doc.

If no research exists and the work is non-trivial, suggest `/1-research-codebase`.
For simple changes, research can be skipped.

### 2. Check Git State

Check git state by running
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.ps1` (PowerShell) or
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.sh` (bash) and parsing the JSON
line it prints. Fall back to individual git commands only if the script
fails. Verify we're on the correct feature branch with no unexpected
changes.

### 3. Design the Implementation

**If config has `architecture.layers`**: Organize work into phases matching
the configured layers, respecting `dependsOn` ordering. Each layer becomes
a phase with a build checkpoint after it.

**If no config**: Organize work into logical phases based on the project
structure from research, ordering dependencies before dependents.

For each phase:
- What files to create or modify
- What the change is
- Which existing code to follow as a pattern
- How to verify the phase is correct

### 4. CLARIFICATION GATE (Interview)

All user dialogue follows the shared interview pattern (read
`${CLAUDE_PLUGIN_ROOT}/references/interview-pattern.md` before the first
`AskUserQuestion` call of a session — batch questions, 2–4 concrete
options, never ask what is already in context).

**Before finalizing the plan, conduct a structured interview.** Group
questions into three categories, each a concrete multiple-choice
question — never a free-form list:

- **Design decisions**: which of two (or more) approaches to take; use
  `preview` content (code snippets) so the user can visually compare.
- **Scope questions**: single-select In-scope / Out-of-scope /
  Not-applicable per candidate area.
- **Risk trade-offs**: a concrete choice between consequences (e.g.
  "break callers" vs "add overload"), never an open "what do you think".

**Batch up to 4 related questions per call.** If more than 4 questions
are open, ask them in sequential `AskUserQuestion` calls ordered by
dependency. Incorporate every answer into the plan before step 5.

**Subagent dialogue**: delegated research/comparison steps must include
the subagent dialogue contract from `references/interview-pattern.md`;
consolidate returned `open_questions` into the calls above.

### 5. Write the Plan

For each step, specify:
- **File**: Exact path to create or modify
- **Action**: Create / Modify / Delete
- **What**: Precise description of the change
- **Pattern**: `file:line` reference only — never paste the pattern code into the plan
- **Dependencies**: Which prior steps must complete first
- **Verification**: How to confirm the step is correct

### 6. Save the Plan

Write to `{workingDirs.plans}/{feature-slug}-plan.md`.

Include:
- Link back to the work brief and research document
- Ordered step list with all details above
- Estimated complexity (S/M/L per step)
- Checkpoint markers: where to verify partial progress
- Commit points: which phases get their own commit
- Rollback notes: how to undo each step if needed

## Output

Present the plan summary and ask the user to validate with
`/3-validate-plan` or proceed directly with `/4-implement-plan`.
