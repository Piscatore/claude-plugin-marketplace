#!/bin/bash
# PreToolUse hook: gates PR creation behind a confirmation prompt
# Intercepts Bash tool calls containing "gh pr create" and asks the user
# to confirm that pre-PR checks have been completed.
#
# CUSTOMIZATION: Edit the checklist items in the permissionDecisionReason
# below to match your project's pre-PR workflow.

input=$(cat)
command=$(echo "$input" | grep -o '"command":"[^"]*"' | head -1 | sed 's/"command":"//;s/"$//')

if echo "$command" | grep -q "gh pr create"; then
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "PR creation detected. Have you completed your pre-PR checklist?\n\nIf not done, deny this and complete the checks first."
  }
}
JSON
  exit 0
fi
exit 0
