#!/usr/bin/env bash
# github-real-stars - Count your GitHub stars excluding your own
# Requires: gh (GitHub CLI), python3

set -euo pipefail

USER="${1:-$(gh api user --jq .login)}"
LIMIT="${2:-50}"  # default: top 50 repos by stars
total=0
real_total=0

printf "%-40s %-10s %s\n" "Repository" "Total" "Real"
printf "%-40s %-10s %s\n" "----------" "-----" "----"

while IFS=$'\t' read -r repo stars; do
  if [ "$stars" -gt 1000 ]; then
    # Huge repos: skip detailed check (too slow), mark with ~
    others="${stars}~"
    real_num="${stars}"
  else
    others=$(gh api "repos/$USER/$repo/stargazers" --paginate 2>/dev/null | python3 -c "
import sys, json
user = '$USER'
try:
    data = json.load(sys.stdin)
    print(len([u for u in data if u['login'] not in [user]]))
except:
    print('$stars')" || echo "$stars")
    real_num="${others}"
  fi
  printf "%-40s %-10s %s\n" "$repo" "$stars" "$others"
  total=$((total + stars))
  real_total=$((real_total + real_num))
done < <(gh repo list "$USER" --limit "$LIMIT" --json name,stargazerCount --jq '[.[] | select(.stargazerCount > 0)] | sort_by(.stargazerCount) | reverse | .[] | "\(.name)\t\(.stargazerCount)"')

echo ""
echo "Total: $total | Real (excluding self): $real_total"
