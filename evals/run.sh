#!/bin/bash
# Run the agent eval suite: each evals/*.json starts from a clean checkout, optional setup
# commands break/prepare the tree, `claude -p` does the task, evals/check.sh judges it.
# Usage: evals/run.sh [eval.json ...]   Env: MIN_PASS_RATE (default 0.9)
set -u
cd "$(dirname "$0")/.." || exit 1
files=("$@"); [ ${#files[@]} -eq 0 ] && files=(evals/*.json)
pass=0; total=0; skipped=0
for e in "${files[@]}"; do
  id=$(jq -r .id "$e")
  missing=$(jq -r '.requires // [] | .[]' "$e" | while read -r f; do [ -e "$f" ] || echo "$f"; done)
  if [ -n "$missing" ]; then echo "SKIP $id (needs: $missing)"; skipped=$((skipped+1)); continue; fi
  total=$((total+1))
  git reset --hard -q && git clean -fdq -e evals/
  jq -r '.setup // [] | .[]' "$e" | while read -r cmd; do bash -c "$cmd"; done
  envs=$(jq -r '.env // {} | to_entries | map("\(.key)=\(.value)") | join(" ")' "$e")
  echo "RUN  $id"
  env $envs claude -p "$(jq -r .prompt "$e")" \
    --allowedTools "$(jq -r '.allowedTools // "Read,Edit,Write,Grep,Glob,Bash(npm run check),Bash(npm test),Bash(npm run lint),Bash(npm run typecheck),Bash(npm run policy),Bash(git diff *),Bash(git status)"' "$e")" \
    --output-format json > "/tmp/eval-$id.json" 2>/dev/null || true
  if evals/check.sh "$e" "/tmp/eval-$id.json"; then pass=$((pass+1)); fi
done
git reset --hard -q && git clean -fdq -e evals/
echo "Eval pass rate: $pass/$total (skipped $skipped)"
awk -v p="$pass" -v t="$total" -v m="${MIN_PASS_RATE:-0.9}" 'BEGIN { exit (t == 0 || p/t < m) }'
