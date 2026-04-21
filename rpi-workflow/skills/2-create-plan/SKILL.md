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

### 4. CLARIFICATION GATE (Interview)

**Before finalizing the plan, conduct a structured interview via
`AskUserQuestion`.** Group questions into three categories — design,
scope, and risk trade-offs — and ask each as a concrete multiple-choice
question. Do NOT present these as a free-form list.

For **design decisions**, prefer `preview` content so the user can
visually compare the two approaches:

```
AskUserQuestion({
  questions: [{
    question: "Should X be implemented with pattern A or pattern B?",
    header: "Pattern",
    multiSelect: false,
    options: [
      {
        label: "Pattern A (Recommended)",
        description: "Matches existing code in HandlerA; simpler to review",
        preview: "// Pattern A — example\nclass Thing : IThing {\n  public Thing(IDep dep) { … }\n}"
      },
      {
        label: "Pattern B",
        description: "Newer style; more flexible but diverges from codebase",
        preview: "// Pattern B — example\nclass Thing : IThing {\n  public static Thing Create(IDep dep) => …\n}"
      }
    ]
  }]
})
```

For **scope questions**, use single-select In-scope / Out-of-scope /
Not-applicable options (same shape as `/0-define-work` batch 3).

For **risk trade-offs**, phrase the question as a concrete choice, not
an open "what do you think":

```
AskUserQuestion({
  questions: [{
    question: "This approach changes the signature of IFoo.Bar(). Which trade-off do you accept?",
    header: "Breaking?",
    multiSelect: false,
    options: [
      { label: "Break and update callers", description: "Cleaner end state; requires touching {N} callers" },
      { label: "Add overload, keep old",   description: "Backward compatible; leaves dead code until cleanup" }
    ]
  }]
})
```

**Batch up to 4 related questions per call.** If more than 4 questions
are open, ask them in sequential `AskUserQuestion` calls ordered by
dependency. Incorporate every answer into the plan before step 5.

**Subagent propagation**: if this skill delegates any research or
comparison step to a subagent, include the propagation block from
`agents/rpi-workflow.md` in the subagent prompt. Subagents return
structured `open_questions`; this skill consolidates them into the
`AskUserQuestion` calls above.

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
