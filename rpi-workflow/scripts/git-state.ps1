#!/usr/bin/env pwsh
# Compact git state as one JSON line. Used by RPI skills.
# Usage: git-state.ps1 [-Fetch]   (-Fetch updates remote refs first)
param([switch]$Fetch)
$ErrorActionPreference = 'SilentlyContinue'
$branch = git branch --show-current
$dirty  = @(git status --porcelain).Count
$stash  = @(git stash list).Count
if ($Fetch) { git fetch origin --quiet 2>$null | Out-Null }
$ahead = 'n/a'; $behind = 'n/a'
if ($branch -and (git rev-parse --verify -q "origin/$branch" 2>$null)) {
    $ahead  = git rev-list --count "origin/$branch..HEAD"
    $behind = git rev-list --count "HEAD..origin/$branch"
}
$last = git log -1 --pretty=format:'%h %s' 2>$null
[PSCustomObject]@{
    branch = $branch; dirty = $dirty; stash = $stash
    ahead = "$ahead"; behind = "$behind"; last = "$last"
} | ConvertTo-Json -Compress
