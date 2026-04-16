#!/usr/bin/env bash
# github-real-stars - Count your GitHub stars excluding your own
# Requires: gh (GitHub CLI), python3

set -euo pipefail

USER="${1:-$(gh api user --jq .login)}"
total=0
real_total=0

printf "%-40s %-8s %s\n" "Repository" "Total" "Real"
printf "%-40s %-8s %s\n" "----------" "-----" "----"

while IFS=$'\t' read -r repo stars; do
  others=$(gh api "repos/$USER/$repo/stargazers" --paginate | python3 -c "
import sys, json
user = '$USER'
data = json.load(sys.stdin)
print(len([u for u in data if u['login'] not in [user]]))")
  printf "%-40s %-8s %s\n" "$repo" "$stars" "$others"
  total=$((total + stars))
  real_total=$((real_total + others))
done < <(gh repo list "$USER" --limit 200 --json name,stargazerCount --jq '.[] | select(.stargazerCount > 0) | "\(.name)\t\(.stargazerCount)"')

echo ""
echo "Total: $total | Real (excluding self): $real_total"
