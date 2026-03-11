#!/bin/bash
# PreToolUse hook: prompts for confirmation before gh pr create
# Reads hook input from stdin, checks if Bash command contains "gh pr create"
input=$(cat)
command=$(echo "$input" | grep -o '"command":"[^"]*"' | head -1 | sed 's/"command":"//;s/"$//')

if echo "$command" | grep -q "gh pr create"; then
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "PR creation detected. Have you completed the Pre-PR Checklist?\n\n1. Run marketplace validation (version consistency, JSON validity, source paths)\n2. Run doc-pr-reviewer on the branch diff\n\nIf not done, deny this and complete them first."
  }
}
JSON
  exit 0
fi
exit 0
