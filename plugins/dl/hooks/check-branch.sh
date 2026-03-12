#!/usr/bin/env bash
# Blocks git commit on main/master — enforces feature-branch workflow.
set -uo pipefail

# Guard: jq required
command -v jq &>/dev/null || exit 0

# Guard: must be in a git repo
git rev-parse --git-dir &>/dev/null 2>&1 || exit 0

# Read hook input
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')

# Only check git commit commands
[[ "$cmd" =~ git[[:space:]]+commit ]] || exit 0

# Check current branch
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
case "$branch" in
main | master)
  echo "Blocked: cannot commit directly to $branch. Create a feature/<slug> branch first." >&2
  exit 2
  ;;
esac

exit 0
