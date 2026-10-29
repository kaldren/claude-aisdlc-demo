#!/bin/bash
# PreToolUse (Edit|Write|MultiEdit): keep credentials out of the diff.
# Scans the text Claude is about to write. Extend the patterns for your providers. Exit 2 blocks.

input=$(cat)
content=$(jq -r '[.tool_input.content, .tool_input.new_string, (.tool_input.edits // [] | .[].new_string)] | map(select(. != null)) | join("\n")' <<<"$input")
[ -z "$content" ] && exit 0

patterns=(
  'AKIA[0-9A-Z]{16}'                                  # AWS access key id
  '-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'             # PEM private keys
  'gh[pousr]_[A-Za-z0-9]{36,}'                        # GitHub tokens
  'github_pat_[A-Za-z0-9_]{40,}'
  'sk-ant-[A-Za-z0-9_-]{20,}'                         # Anthropic keys
  'sk-[A-Za-z0-9]{32,}'                               # generic sk- keys
  'xox[abprs]-[A-Za-z0-9-]{10,}'                      # Slack tokens
  'AIza[0-9A-Za-z_-]{35}'                             # Google API keys
)

for p in "${patterns[@]}"; do
  if grep -Eq -- "$p" <<<"$content"; then
    echo "Blocked: the content looks like it contains a credential (pattern: $p). Read secrets from the environment or the secret manager instead of writing them to files." >&2
    exit 2
  fi
done
exit 0
