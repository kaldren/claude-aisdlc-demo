#!/bin/bash
# PostToolUse (Edit|Write|MultiEdit): auto-fix lint issues in the file that just changed so drift never accumulates.
# Fast and scoped to one file. Never blocks: remaining problems surface in `npm run lint`.

input=$(cat)
file=$(jq -r '.tool_input.file_path // empty' <<<"$input")
[ -z "$file" ] || [ ! -f "$file" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
case "$file" in
  *.js|*.jsx|*.mjs|*.ts|*.tsx)
    [ -x "$root/node_modules/.bin/eslint" ] && (cd "$root" && node_modules/.bin/eslint --fix "$file" >/dev/null 2>&1) ;;
esac
exit 0
