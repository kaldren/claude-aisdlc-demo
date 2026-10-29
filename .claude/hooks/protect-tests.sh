#!/bin/bash
# PreToolUse (Edit|Write|MultiEdit): during a fix task, the agent must not weaken the check on the code it fixes.
# Active only when Claude was started with AI_SDLC_FIX_MODE=1, e.g.  AI_SDLC_FIX_MODE=1 claude
# Test globs come from .claude/test-paths.txt (one per line), or the defaults below. Exit 2 blocks.

[ "$AI_SDLC_FIX_MODE" = "1" ] || exit 0

input=$(cat)
file=$(jq -r '.tool_input.file_path // empty' <<<"$input")
[ -z "$file" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
rel="${file#"$root"/}"

globs=()
if [ -f "$root/.claude/test-paths.txt" ]; then
  # while-read instead of mapfile: macOS ships bash 3.2
  while IFS= read -r g || [ -n "$g" ]; do
    g="${g%%#*}"; g="${g//[[:space:]]/}"
    [ -n "$g" ] && globs+=("$g")
  done < "$root/.claude/test-paths.txt"
else
  globs=('test/*' 'tests/*' '*/test/*' '*/tests/*' '__tests__/*' '*/__tests__/*' '*_test.*' '*.test.*' '*.spec.*' 'test_*' '*/test_*' 'src/itest/*')
fi

for g in "${globs[@]}"; do
  # shellcheck disable=SC2053
  if [[ "$rel" == $g ]]; then
    echo "Blocked: $rel is a test file and this is a fix task (AI_SDLC_FIX_MODE=1). Make the existing test pass by changing the code, not the test. If the test itself is wrong, stop and explain why to the engineer." >&2
    exit 2
  fi
done
exit 0
