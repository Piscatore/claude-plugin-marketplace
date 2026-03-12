---
name: guard
description: Set up, list, or remove workflow guards (PreToolUse/PostToolUse hooks)
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Glob
---

# /guard

Manage workflow guards — hook-based enforcement rules that gate Claude Code tool usage.

## Usage

### `/guard` or `/guard list`

List all active guards in the current project's `.claude/settings.json`. Shows each hook's event type, matchers, script path, and status message.

### `/guard setup`

Interactive setup of a new guard from a template. Walks you through:

1. Selecting a guard template (e.g., `pr-gate`)
2. Reviewing what the guard does
3. Choosing the installation path for the hook script
4. Customizing the guard's confirmation message (optional)
5. Writing the script and merging the hook config into `.claude/settings.json`

### `/guard remove`

Remove an existing guard. Lists active guards, lets you select one, shows the before/after diff, and removes on confirmation.

## Examples

```
/guard                          # List active guards
/guard setup                    # Install a new guard from template
/guard remove                   # Remove an existing guard
```

## Templates

| Template | Description |
|----------|-------------|
| `pr-gate` | Gates PR creation (`gh pr create`) behind a confirmation prompt. Reminds the user to complete a pre-PR checklist before proceeding. |

## How It Works

Guards are Claude Code hooks — shell scripts that run automatically when Claude attempts to use a tool. They intercept the tool call via stdin JSON and can:

- **Allow** it silently (`permissionDecision: "allow"`)
- **Ask** the user for confirmation with a custom message (`permissionDecision: "ask"`)
- **Deny** it with an explanation (`permissionDecision: "deny"`)

Guards are registered in `.claude/settings.json` under the `hooks` key and scoped by event type (`PreToolUse`, `PostToolUse`) and tool matcher patterns.
