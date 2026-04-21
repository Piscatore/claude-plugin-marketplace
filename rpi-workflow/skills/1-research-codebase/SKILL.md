---
name: 1-research-codebase
description: "Deep codebase research for a defined work item. Launches parallel agents, synthesizes findings, and pauses at a clarification gate before saving."
user-invocable: true
---

# Research Codebase

Conduct deep research on the codebase to understand how to implement a
requested feature or fix. Uses project config for subsystem awareness.

## Process

### 1. Load Context

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.workingDirs` — artifact locations
- `research.subsystems` — project subsystems to investigate
- `research.agents` — custom research agent paths (optional)
- `architecture.layers` — project layers and dependency flow

Read the most recent work brief from `{workingDirs.briefs}/`.
If no brief exists, tell the user to run `/0-define-work` first.

Confirm understanding of the description, acceptance criteria, and scope.
If any referenced specs or documents exist, read them now.

### 2. Check Git State

```bash
git branch --show-current
git status -s
```

Verify:
- [ ] On the correct feature branch (not `main`)
- [ ] No unexpected uncommitted changes

### 3. Identify Affected Subsystems

**If config has `research.subsystems`**: Ask the user which subsystems
are likely affected via `AskUserQuestion` with `multiSelect: true`:

```
AskUserQuestion({
  questions: [{
    question: "Which subsystems are likely affected by this work?",
    header: "Subsystems",
    multiSelect: true,
    options: config.research.subsystems.map(s => ({
      label: s.name,
      description: s.description || s.path
    }))
  }]
})
```

**If no config**: Infer subsystems from the directory structure (`src/`,
`lib/`, `app/`, `tests/`, schema files) and present the inferred list
through the same `AskUserQuestion` pattern so the user can confirm or
correct before research starts.

### 4. Launch Parallel Research Agents

**If config has `research.agents`**: Launch the configured agents in parallel.

**If no custom agents**: Launch three generic research agents concurrently:

**Agent 1 — File Locator**:
Find all files related to the feature area. Map which files exist, which
need modification, and where new files should be placed.

**Agent 2 — Code Analyzer**:
Trace the data flow for similar existing features. Understand how the
current code handles analogous operations end-to-end.

**Agent 3 — Pattern Finder**:
Find established patterns for the type of code being added. Collect
templates and conventions that the new code must follow.

**Subagent dialogue rule — propagate to every subagent prompt.**
Every `Agent` call issued from this skill MUST include the propagation
block defined in `agents/rpi-workflow.md` → "Subagent propagation rule".
In short: subagents never call `AskUserQuestion` themselves — they
return structured `open_questions` entries. This orchestrating skill
consolidates questions from all three agents and presents them to the
user in step 6.

Concretely, each `Agent({ prompt })` call must include, near the top of
the prompt:

> You do not have a direct channel to the user. Do NOT attempt to ask
> the user questions yourself. When you encounter an unknown, ambiguity,
> or decision that requires user input, append a structured entry to an
> `open_questions` section of your final report. See the rpi-workflow
> agent spec for the exact shape (question, header, options with
> label+description, multiSelect, recommended, rationale). The
> orchestrating rpi-workflow agent will consolidate entries from all
> subagents and ask the user via AskUserQuestion.

### 5. Synthesize Research

Combine findings into a research document covering:
- **Affected files**: Every file that needs creation or modification
- **Dependency chain**: How changes flow through the project layers
- **Existing patterns**: Code templates to follow (with file:line references)
- **Schema/config impact**: Database, config, or infrastructure changes
- **DI/wiring**: Services to register and where
- **Test coverage**: What tests exist for similar features
- **Risks**: Breaking changes, migration concerns, performance implications
- **Open questions**: Anything not resolved by reading code

### 6. CLARIFICATION GATE (Interview)

**Before saving the research, consolidate and ask the user.** Merge the
`open_questions` sections returned by every subagent into one ordered
list, deduplicate near-identical questions, and add any assumptions /
risks this skill itself is unsure about.

**Present via `AskUserQuestion`, batched 1–4 per call, ordered by
dependency and impact.** Each consolidated question must include:

- a concrete question text,
- a ≤12-char `header`,
- 2–4 mutually exclusive `options` (or `multiSelect: true` when genuinely
  non-exclusive — e.g. "which of these files are in scope?"),
- one option marked `(Recommended)` if the research points clearly to a
  preferred answer, based on the `recommended` hint from the subagent,
- `preview` content when options are code snippets / pattern examples
  that the user should visually compare.

**Pseudo-example** of consolidating three subagent returns into one call:

```
// subagent returns (open_questions):
//   file-locator  → "Is legacy adapter X in scope?"
//   code-analyzer → "Which existing handler's pattern should we follow?"
//   pattern-finder→ "DI via factory or constructor?"
AskUserQuestion({
  questions: [
    {
      question: "Is legacy adapter X in scope for this change?",
      header: "Scope: X",
      multiSelect: false,
      options: [
        { label: "In scope",               description: "Update X as part of this work item" },
        { label: "Out of scope (follow-up)",description: "Defer X to a later work item" }
      ]
    },
    {
      question: "Which existing handler's pattern should we follow?",
      header: "Pattern",
      multiSelect: false,
      options: [
        { label: "HandlerA (Recommended)", description: "Closest analog — used for similar events", preview: "// HandlerA.cs excerpt…" },
        { label: "HandlerB",               description: "Newer style but different lifecycle",       preview: "// HandlerB.cs excerpt…" }
      ]
    },
    {
      question: "How should the new service be wired?",
      header: "DI style",
      multiSelect: false,
      options: [
        { label: "Constructor injection (Recommended)", description: "Matches current DI pattern" },
        { label: "Factory",                             description: "Only if lifetime is per-request" }
      ]
    }
  ]
})
```

If more than 4 questions come back, issue additional `AskUserQuestion`
calls in dependency order (earlier answers may change later options).

**Incorporate answers** into the research document before saving. If
answers change scope, update the work brief as well.

### 7. Save Research

Write the research document to `{workingDirs.research}/{feature-slug}-research.md`.

Include:
- Link back to the work brief
- Timestamp and feature description
- All file references with line numbers
- Code snippets showing existing patterns to follow
- Resolved questions (with the user's answers)
- Any remaining unknowns (to be resolved in planning)

## Output

Confirm research is complete and summarize the key findings.
Ask the user to proceed with `/2-create-plan` when ready.
