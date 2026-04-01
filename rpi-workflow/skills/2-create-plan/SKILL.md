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
- `project.workingDirs` — artifact locations
- `project.buildCommand` / `project.testCommand` — verification commands
- `architecture.layers` — project layers and dependency order
- `architecture.dependencyFlow` — how changes must be ordered
- `architecture.codePatterns` — patterns new code must follow

Read these documents in order:
1. Work brief from `{workingDirs.briefs}/` — for scope and acceptance criteria
2. Research document from `{workingDirs.research}/` — for technical findings

If no research exists and the work is non-trivial, suggest `/1-research-codebase`.
For simple changes, research can be skipped.

### 2. Check Git State

```bash
git branch --show-current
git status -s
```

Verify we're on the correct feature branch with no unexpected changes.

### 3. Design the Implementation

**If config has `architecture.layers`**: Organize work into phases matching
the configured layers, respecting `dependsOn` ordering. Each layer becomes
a phase with a build checkpoint after it.

**If no config**: Organize work into logical phases based on the project
structure discovered during research. Order changes so that dependencies
are satisfied before dependents.

For each phase:
- What files to create or modify
- What the change is
- Which existing code to follow as a pattern
- How to verify the phase is correct

### 4. CLARIFICATION GATE

**Before finalizing the plan, pause and present to the user:**

1. **Design decisions** with multiple valid approaches:
   - "Should X use pattern A or pattern B?"
   - "The spec says Y but the codebase does Z — which do we follow?"

2. **Scope questions** from research or emerging from the plan:
   - "The research found X is also affected — is that in scope?"
   - "Should we use library X or build this by hand?"

3. **Risk trade-offs** the user should weigh in on:
   - "This approach is simpler but less flexible later"
   - "This changes an existing interface — acceptable?"

**Wait for the user to respond.** Incorporate their decisions into the plan.

### 5. Write the Plan

For each step, specify:
- **File**: Exact path to create or modify
- **Action**: Create / Modify / Delete
- **What**: Precise description of the change
- **Pattern**: Reference to existing code that demonstrates the pattern
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
