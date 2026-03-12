# PR Gate Guard

A PreToolUse hook that intercepts PR creation and prompts for confirmation before proceeding.

## What It Does

When Claude attempts to run `gh pr create` via the Bash tool, this guard intercepts the call and displays a confirmation prompt. The user can approve (allow the PR to be created) or deny (block it and complete outstanding checks first).

This enforces a "pause and confirm" workflow at zero API cost — the hook runs as a local bash script, not an LLM call.

## Why Use This

- Prevents accidental PR creation before validation steps are complete
- Gives the user a chance to review what's about to be pushed
- Works as a lightweight process gate without CI overhead
- Zero cost: no API calls, no external services

## Installation

Use the `/guard setup` skill to install this template interactively, or install manually:

1. Copy `guard.sh` to `.claude/hooks/pre-pr-check.sh` (or any path you prefer)
2. Make it executable: `chmod +x .claude/hooks/pre-pr-check.sh`
3. Add the hook to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-pr-check.sh"
          }
        ]
      }
    ]
  }
}
```

## Customization

Edit the `permissionDecisionReason` string in `guard.sh` to include your project-specific checklist items. For example:

```bash
"permissionDecisionReason": "PR creation detected. Have you completed:\n\n1. Run tests\n2. Run linter\n3. Update CHANGELOG\n\nDeny to complete these first."
```

## How It Works

1. Claude calls the Bash tool with a command containing `gh pr create`
2. The hook script reads the tool input JSON from stdin
3. It extracts the `command` field using `grep` and `sed` (no `jq` dependency)
4. If the command contains `gh pr create`, it outputs a JSON response with `permissionDecision: "ask"`
5. Claude Code shows the confirmation message to the user
6. The user approves or denies

## Limitations

- Only intercepts PR creation through Claude's Bash tool. Direct terminal usage of `gh pr create` is not intercepted.
- The hook matches on string containment (`grep -q "gh pr create"`). Commands using different syntax (e.g., `gh api`) are not caught.
- The confirmation message is static text. For dynamic checks, you would need to extend the script.
