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

Read these documents:
1. Plan from `{workingDirs.plans}/`
2. Work brief from `{workingDirs.briefs}/` — for acceptance criteria
3. Session file from `{workingDirs.sessions}/` — if resuming

If no plan exists, tell the user to run `/2-create-plan` first.

### 2. Check Git State

```bash
git branch --show-current
git status -s
git log --oneline -3
```

**Gate conditions**:
- [ ] On the correct feature branch (not `main`)
- [ ] No unexpected uncommitted changes
- [ ] Branch is up to date

If on `main` or wrong branch, stop and ask the user.

### 3. Execute Steps In Order

For each step in the plan:

1. **Announce**: State which step you're executing and what it does
2. **Read context**: Read any files the step depends on
3. **Implement**: Make the code change following project patterns
   (use `architecture.codePatterns` from config if available)
4. **Verify**: Run the build command
5. **Mark complete**: Update progress tracking

### 4. Verification Gates

After each phase, run the build command:
```bash
{buildCommand}
```

After all implementation is complete, run tests:
```bash
{testCommand}
```

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
