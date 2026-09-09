---
name: 1-research-codebase
description: "Deep codebase research for a defined work item. Launches parallel agents, synthesizes findings, and pauses at a clarification gate before saving."
user-invocable: true
---

# Research Codebase

Conduct deep research on the codebase to understand how to implement a
requested feature or fix. Uses project config for subsystem awareness.

Delegation: this step may be delegated per `shared/dify-delegation.md`.

## Process

### 1. Load Context

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.workingDirs` — artifact locations
- `research.subsystems` — project subsystems to investigate
- `research.agents` — custom research agent paths (optional)
- `architecture.layers` — project layers and dependency flow

Read the most recent work brief from `{workingDirs.briefs}/`.
If no brief exists, tell the user to run `/0-define-work` first.
Only the brief and config are read here — referenced specs are read once
and summarized into the research doc, not re-read downstream.

Confirm understanding of the description, acceptance criteria, and scope.
If any referenced specs or documents exist, read them now.

### 2. Check Git State

Check git state by running
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.ps1` (PowerShell) or
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.sh` (bash) and parsing the JSON
line it prints. Fall back to individual git commands only if the script
fails.

Verify:
- [ ] On the correct feature branch (not `main`)
- [ ] No unexpected uncommitted changes

### 3. Identify Affected Subsystems

**If config has `research.subsystems`**: ask via `AskUserQuestion`,
`multiSelect: true`, with options built from `config.research.subsystems`
(label = subsystem name, description = subsystem description or path).

**If no config**: infer subsystems from the directory structure (`src/`,
`lib/`, `app/`, `tests/`, schema files) and present the inferred list
through the same pattern so the user can confirm or correct before
research starts.

All user dialogue follows the shared interview pattern. Before the first
`AskUserQuestion` call of a session, read
`${CLAUDE_PLUGIN_ROOT}/references/interview-pattern.md`. Do not restate its
rules here — batch questions, offer 2–4 concrete options, never ask what is
already in context.

### 4. Launch Research (sized to the work)

Estimate the number of affected files from the brief and subsystem
answers.

- **Small (≤ `research.parallelThresholdFiles`, default 6, estimated
  affected files)**: do the research inline in this context — locate
  files, trace the closest analog, note conventions. No subagents.
- **Large / unfamiliar**: launch up to `research.maxParallelAgents`
  (default 3) subagents in parallel using the plugin's dedicated agent
  definitions: `research-file-locator` (Haiku), `research-code-analyzer`
  (Sonnet), `research-pattern-finder` (Sonnet). If config defines
  `research.agents`, those take precedence.

Each subagent prompt contains: the work-brief summary (≤15 lines), the
selected subsystem paths, the specific question that agent answers, and
the subagent dialogue contract:

> No user channel: do not ask the user anything. Return unknowns as entries
> in an `open_questions` list in your final report — each entry: question,
> header (≤12 chars), 2–4 options (label + one-line description), multiSelect
> flag, optional recommended label, one-line rationale. The orchestrator will
> consolidate and ask the user.

Respect each agent's built-in tool and output budget — do not ask for
"comprehensive" reports.

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

Record findings as `file:line` references plus a one-sentence description
of the pattern or behavior. Include a code excerpt only when a reference
alone would be ambiguous, and cap excerpts at 5 lines. Downstream steps
read the actual code on demand — references are more precise than
possibly-stale snippets and cost a fraction of the tokens.

### 6. CLARIFICATION GATE (Interview)

**Before saving the research, consolidate and ask the user.** Merge the
`open_questions` sections returned by every subagent into one ordered
list, deduplicate near-identical questions, and add any assumptions /
risks this skill itself is unsure about.

**Present via `AskUserQuestion`, batched 1–4 per call, ordered by
dependency and impact**, per `references/interview-pattern.md`. Carry
over each subagent's `recommended` hint as the `(Recommended)` option,
and attach `preview` content when options are code/pattern snippets the
user should visually compare. If more than 4 questions come back, issue
additional calls in dependency order (earlier answers may change later
options).

**Incorporate answers** into the research document before saving. If
answers change scope, update the work brief as well.

### 7. Save Research

Write the research document to `{workingDirs.research}/{feature-slug}-research.md`.

Include:
- Link back to the work brief
- Timestamp and feature description
- All file references with line numbers, one-sentence description per
  finding (see step 5's format rule) — no pasted code beyond ambiguous
  5-line excerpts
- Resolved questions (with the user's answers)
- Any remaining unknowns (to be resolved in planning)

## Output

Confirm research is complete and summarize the key findings.
Ask the user to proceed with `/2-create-plan` when ready.
