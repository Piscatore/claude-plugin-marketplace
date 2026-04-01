---
name: 5-save-progress
description: "Save current session state: commit uncommitted work, push to remote, update session file. Use when pausing mid-implementation."
user-invocable: true
---

# Save Progress

Save the current session state so work can be resumed later.
Use when stopping mid-implementation or pausing for the day.

## Process

### 1. Load Config

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.buildCommand` / `project.testCommand`
- `project.workingDirs`

### 2. Assess Current State

```bash
git branch --show-current
git status -s
git log --oneline -5
{buildCommand}
{testCommand}
```

Determine:
- Which plan is being executed
- Which steps are complete, in-progress, or pending
- Current build and test status
- Any uncommitted changes

### 3. Commit Uncommitted Work

If there are uncommitted changes:
```bash
git add {relevant files}
git commit -m "wip: {feature-slug} — {current step description}"
git push -u origin {branch-name}
```

**Do not leave uncommitted changes** when saving progress. If the code
doesn't build, commit anyway with a `wip:` prefix and note the issue.

### 4. Save Session File

Write or update the session file at `{workingDirs.sessions}/{feature-slug}-session.md`:

```markdown
# Session: {Feature Name}

**Plan**: {path to plan}
**Brief**: {path to brief}
**Branch**: {branch-name}
**Started**: {timestamp}
**Last Updated**: {timestamp}
**Status**: In Progress / Complete / Blocked

## Completed Steps
- [x] Step 1: {description} — commit {hash}

## Current Step
- [ ] Step N: {description}
  - Progress: {what's been done}
  - Blockers: {any issues}

## Remaining Steps
- [ ] Step N+1: {description}

## Build/Test Status
- Build: PASS / FAIL
- Tests: X/Y passing

## Decisions & Deviations
- {changes from the plan}

## Notes for Resumption
- {context for picking up later}
```

### 5. Verify Push State

```bash
git log origin/{branch}..HEAD --oneline
```

If unpushed commits exist, push them.

## Output

Confirm session saved and all changes pushed.
Tell the user to resume with `/6-resume-work`.
