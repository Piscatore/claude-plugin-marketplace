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

Before loading any context, verify the working environment. Check git
state by running `${CLAUDE_PLUGIN_ROOT}/scripts/git-state.ps1 -Fetch`
(PowerShell) or `${CLAUDE_PLUGIN_ROOT}/scripts/git-state.sh --fetch`
(bash) and parsing the JSON line it prints. Fall back to individual git
commands only if the script fails.

**Diagnose and report** (fields map directly to the script's JSON):

| Condition | Action |
|-----------|--------|
| On `main` with no feature branches | No work in progress — suggest `/0-define-work` |
| On `main` with uncommitted changes (`dirty` > 0) | Dangerous — interview user via `AskUserQuestion` |
| On a feature branch, clean (`dirty` = 0) | Good — proceed to load session |
| On a feature branch, dirty | Uncommitted work — interview: commit, stash, or discard? |
| `stash` > 0 | Alert user via `AskUserQuestion` — may be forgotten work |
| `ahead`/`behind` nonzero | Diverged from remote — alert user |

When a condition requires user input, ask through `AskUserQuestion` per
the shared interview pattern (`${CLAUDE_PLUGIN_ROOT}/references/interview-pattern.md`).

**Do not proceed until the branch state is clean and understood.**

### 3. Find Sessions

List session files in `{workingDirs.sessions}/`. If only one exists,
load it automatically. If multiple exist, ask which to resume via
`AskUserQuestion` (label = feature slug, description = status · updated
· current step).

If no session files exist, check for briefs and plans — the user may
have gotten partway through the workflow without saving a session.

### 4. Restore Context

Lazy-load: read the session file first. Read the linked brief and plan
only if the session file's summary is insufficient to continue; open
the linked research doc only on demand. Identify current step and
status, and check for noted blockers or decisions.

### 5. Verify Code Matches Session

```bash
{buildCommand}
{testCommand}
```

Check:
- Do completed steps match what's in the code?
- Does the project still build?
- Do tests still pass?

### 6. Resume Execution

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
