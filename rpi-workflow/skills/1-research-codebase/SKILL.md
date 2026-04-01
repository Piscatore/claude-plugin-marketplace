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

**If config has `research.subsystems`**: Use them to scope the research.
Present the list and ask which subsystems are likely affected.

**If no config**: Infer subsystems from the directory structure. Look for
common patterns: `src/`, `lib/`, `app/`, `tests/`, config files, schema files.

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

### 6. CLARIFICATION GATE

**Before saving the research, pause and present to the user:**

1. List all **open questions** — things the research could not answer:
   - Ambiguous requirements from the brief
   - Design decisions with multiple valid approaches
   - External dependencies or unknowns
   - Scope questions ("does this include X?")

2. List all **assumptions** being made and ask the user to confirm or correct.

3. List any **risks** that might change the scope or approach.

**Wait for the user to respond.** Incorporate their answers into the
research document before saving. If answers change the scope, update
the work brief as well.

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
