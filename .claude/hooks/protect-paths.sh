#!/bin/bash
# PreToolUse (Edit|Write|MultiEdit|NotebookEdit): block edits to protected paths.
#   .claude/protected-paths.txt          globs that are never edited by Claude (generated code, frozen packages)
#   .claude/change-controlled-paths.txt  globs that need CHANGE_TICKET set (migrations, infra)
# One glob per line, relative to the project root; '#' starts a comment. Exit 2 blocks; stderr goes to Claude.

input=$(cat)
file=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input")
[ -z "$file" ] && exit 0

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
rel="${file#"$root"/}"

matches() { # $1 = list file; prints the first matching glob
  [ -f "$1" ] || return 1
  while IFS= read -r glob || [ -n "$glob" ]; do
    glob="${glob%%#*}"; glob="${glob%"${glob##*[![:space:]]}"}"
    [ -z "$glob" ] && continue
    # shellcheck disable=SC2053
    if [[ "$rel" == $glob ]]; then echo "$glob"; return 0; fi
  done < "$1"
  return 1
}

if g=$(matches "$root/.claude/protected-paths.txt"); then
  echo "Blocked: $rel is protected (matches '$g' in .claude/protected-paths.txt). Change the source it is generated from, or ask a code owner to update the protected list." >&2
  exit 2
fi

if g=$(matches "$root/.claude/change-controlled-paths.txt") && [ -z "$CHANGE_TICKET" ]; then
  echo "Blocked: $rel is change-controlled (matches '$g'). Get an approved change ticket, then restart Claude with CHANGE_TICKET=<id>." >&2
  exit 2
fi

exit 0
