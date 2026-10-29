#!/bin/bash
# Usage: evals/check.sh <eval.json> <result.json>
# Passes (exit 0) when the Claude run did not error and every command in .checks succeeds.
set -u
eval_file="$1"; result_file="$2"
id=$(jq -r '.id' "$eval_file")

if [ "$(jq -r '.is_error // false' "$result_file" 2>/dev/null)" = "true" ]; then
  echo "FAIL $id: claude run errored"; exit 1
fi

status=0
while IFS= read -r check; do
  if bash -c "$check" >/dev/null 2>&1; then
    echo "  ok   $check"
  else
    echo "  FAIL $check"; status=1
  fi
done < <(jq -r '.checks[]' "$eval_file")

[ $status -eq 0 ] && echo "PASS $id" || echo "FAIL $id"
exit $status
