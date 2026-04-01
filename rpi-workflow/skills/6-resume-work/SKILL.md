---
name: 6-resume-work
description: "Resume a saved implementation session. Checks git branch state, diagnoses issues, restores context, and continues implementation."
user-invocable: true
---

# Resume Work

Resume a previously saved session. Thoroughly checks branch state
before loading context — catches forgotten commits, pushes, and merges.

## Process

### 1. Load Config

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.buildCommand` / `project.testCommand`
- `project.workingDirs`

### 2. Check Git State First

Before loading any context, verify the working environment:

```bash
git branch --show-current
git status -s
git log --oneline -5
git stash list
```

**Diagnose and report**:

| Condition | Action |
|-----------|--------|
| On `main` with no feature branches | No work in progress — suggest `/0-define-work` |
| On `main` with uncommitted changes | Dangerous — ask user what happened |
| On a feature branch, clean | Good — proceed to load session |
| On a feature branch, dirty | Uncommitted work — ask: commit or stash? |
| Stashed changes exist | Alert user — may be forgotten work |

**Do not proceed until the branch state is clean and understood.**

### 3. Find Sessions

List session files in `{workingDirs.sessions}/`.
If multiple exist, show them and ask which to resume.
If only one exists, load it automatically.

If no session files exist, check for briefs and plans — the user may
have gotten partway through the workflow without saving a session.

### 4. Restore Context

From the session file:
1. Read the linked work brief
2. Read the linked plan
3. Read the linked research (if it exists)
4. Identify current step and status
5. Check for noted blockers or decisions

### 5. Verify Code Matches Session

```bash
{buildCommand}
{testCommand}
```

Check:
- Do completed steps match what's in the code?
- Does the project still build?
- Do tests still pass?

### 6. Check Remote Sync

```bash
git fetch origin
git log HEAD..origin/{branch} --oneline
git log origin/{branch}..HEAD --oneline
```

Report commits ahead/behind. If diverged, alert user.

### 7. Resume Execution

Once context is restored and state is verified:
1. Announce the current step and what remains
2. Continue following `/4-implement-plan` process
3. Update the session file as steps complete

## Output

Report:
- Feature name and branch
- Current step (N of total)
- Build/test status
- Any issues found

Then proceed with implementation unless there are blockers.
