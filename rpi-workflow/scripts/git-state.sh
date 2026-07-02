#!/usr/bin/env bash
# Compact git state as one JSON line. Used by RPI skills.
# Usage: git-state.sh [--fetch]
set -u
fetch=false; [ "${1:-}" = "--fetch" ] && fetch=true
branch=$(git branch --show-current)
dirty=$(git status --porcelain | grep -c . || true)
stash=$(git stash list | grep -c . || true)
$fetch && git fetch origin --quiet 2>/dev/null
ahead="n/a"; behind="n/a"
if [ -n "$branch" ] && git rev-parse --verify -q "origin/$branch" >/dev/null 2>&1; then
  ahead=$(git rev-list --count "origin/$branch..HEAD")
  behind=$(git rev-list --count "HEAD..origin/$branch")
fi
last=$(git log -1 --pretty=format:'%h %s' 2>/dev/null | tr '"' "'")
printf '{"branch":"%s","dirty":%s,"stash":%s,"ahead":"%s","behind":"%s","last":"%s"}\n' \
  "$branch" "$dirty" "$stash" "$ahead" "$behind" "$last"
