---
name: 7-complete-work
description: "Finalize a work item: verify acceptance criteria, create a pull request, and optionally merge to main. Closing step of the RPI workflow."
user-invocable: true
---

# Complete Work

Finalize a work item: verify everything is clean, create a pull request,
and optionally merge to main.

## Process

### 1. Load Config

Read `.claude/rpi-config.json` if it exists. Extract:
- `project.buildCommand` / `project.testCommand`
- `project.workingDirs`

### 2. Pre-flight Checks

```bash
git branch --show-current
git status -s
{buildCommand}
{testCommand}
```

**Gate conditions** (all must pass before creating the PR):
- [ ] On the feature branch (not `main`)
- [ ] No uncommitted changes
- [ ] Build succeeds with 0 errors
- [ ] Tests pass (all green)
- [ ] All changes are pushed to the remote

If any check fails, fix it before proceeding.

### 3. Verify Acceptance Criteria

Read the work brief from `{workingDirs.briefs}/{feature-slug}-brief.md`.

Walk through each acceptance criterion:
```markdown
- [x] Criterion 1: {how it was satisfied}
- [x] Criterion 2: {how it was satisfied}
- [ ] Criterion 3: {NOT MET — explain}
```

If any are not met, ask the user:
- Defer to a follow-up? (acceptable for the PR)
- Implement now before completing?

### 4. Review the Diff

```bash
git log main..HEAD --oneline
git diff main..HEAD --stat
```

Summarize changes for the PR description.

### 5. Create Pull Request

```bash
gh pr create --title "{short title}" --body "$(cat <<'EOF'
## Summary
{2-3 bullet points}

## Acceptance Criteria
- [x] {criterion 1}
- [x] {criterion 2}

## Changes
{diff stat summary}

## Testing
- {test results}
- {how to manually verify}

## Notes
- {deviations from plan}
- {follow-up work identified}
EOF
)"
```

### 6. Merge Decision

Ask the user: **Merge now or wait for review?**

**If merge now:**
```bash
gh pr merge --squash --delete-branch
```

**If wait**: Report the PR URL and stop.

### 7. Post-merge Cleanup

After merge:
```bash
git checkout main
git pull origin main
{buildCommand}
```

### 8. Update Session

Update the session file status to `Complete` with:
- PR URL and merge commit hash
- Final acceptance criteria status
- Follow-up work identified

## Output

Report:
- PR URL (and merge commit if merged)
- Acceptance criteria status
- Summary of what was delivered
- Follow-up work for future units
