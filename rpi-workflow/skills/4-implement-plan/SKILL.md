---
name: 4-implement-plan
description: "Execute an implementation plan step by step with verification gates, automatic commits at phase checkpoints, and progress tracking."
user-invocable: true
---

# Implement Plan

Execute the implementation plan step by step. This is the core execution
step of the RPI workflow.

## Process

### 1. Load Context

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.buildCommand` — verification command (default: auto-detect)
- `project.testCommand` — test command (default: auto-detect)
- `project.workingDirs` — artifact locations
- `architecture.codePatterns` — patterns to follow during implementation

Read only what this step needs:
1. Plan from `{workingDirs.plans}/`
2. Work brief from `{workingDirs.briefs}/` — **Acceptance Criteria section only**
3. Session file from `{workingDirs.sessions}/` — only if resuming

Research doc: open on demand when a plan step's `file:line` pattern
reference needs surrounding context — not read up front.

If no plan exists, tell the user to run `/2-create-plan` first.

### 2. Check Git State

Check git state by running
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.ps1` (PowerShell) or
`${CLAUDE_PLUGIN_ROOT}/scripts/git-state.sh` (bash) and parsing the JSON
line it prints. Fall back to individual git commands only if the script
fails.

**Gate conditions**:
- [ ] On the correct feature branch (not `main`)
- [ ] No unexpected uncommitted changes
- [ ] Branch is up to date

If on `main` or wrong branch, stop and ask the user.

### 3. Execute Steps In Order

For each step in the plan:

1. **Announce**: State which step you're executing and what it does
2. **Read context**: Read any files the step depends on — only the
   files this step touches or references
3. **Implement**: Make the code change following project patterns
   (use `architecture.codePatterns` from config if available)
4. **Verify**: Run the build command
5. **Mark complete**: Update progress tracking

### 4. Verification Gates

Run `{buildCommand}` after each phase, and `{testCommand}` after all
implementation is complete (configure both with quiet flags — see
rpi-config.template.json). On failure, re-run with `{verboseBuildCommand}`
(or raise verbosity) to diagnose. Never carry more than the actual error
lines forward; do not paste restore logs, warnings summaries, or
passing-test output into reports or artifacts.

If a build or test fails:
1. Read the error carefully
2. Identify the root cause (don't guess)
3. Fix the issue following project patterns
4. Re-verify before moving to the next step

### 5. Automatic Commits

**Commit after each completed phase checkpoint.** Do not wait until the
end to commit everything at once.

Commit message format:
```
feat({scope}): {what changed}

Part of {feature-slug}: {brief description}
```

After each commit, push to the remote:
```bash
git push -u origin {branch-name}
```

### 6. Track Progress

Maintain a session file at `{workingDirs.sessions}/{feature-slug}-session.md`.

Track:
- Which steps are complete / in-progress / pending
- Any deviations from the plan (and why)
- Build/test results at each checkpoint
- Commit hashes for each phase

## Output

After all steps complete:
1. Summarize what was implemented and any deviations from the plan
2. Verify acceptance criteria from the work brief are met
3. Suggest running `/7-complete-work` to create the PR
