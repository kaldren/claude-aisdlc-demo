#!/bin/bash
# PreToolUse (Bash + Vercel MCP tools): production changes need the release manager (Kaloyan).
# Interactive sessions: asks the human in the session. CI / headless ($CI set): blocks.
# Override for a pre-authorized release: start Claude with RELEASE_APPROVAL=<PR number or note>.

input=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$input")
reason=""

case "$tool" in
  Bash)
    cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
    if grep -Eiq -- 'vercel( [^|;&]*)? (--prod|promote|rollback)|vercel( [^|;&]*)? deploy [^|;&]*--prod|--target[= ]production' <<<"$cmd"; then
      reason="Production change via Vercel CLI: $cmd"
    fi ;;
  mcp__*Vercel__request_promote|mcp__*Vercel__request_rollback|mcp__*Vercel__start_rolling_release|mcp__*Vercel__approve_rolling_release_stage|mcp__*Vercel__complete_rolling_release)
    reason="Production change via Vercel MCP: ${tool##*__}" ;;
  mcp__*Vercel__create_deployment)
    if jq -e '.tool_input | tostring | test("\"target\":\"production\"")' <<<"$input" >/dev/null; then
      reason="Production deployment via Vercel MCP"
    fi ;;
esac

[ -z "$reason" ] && exit 0
[ -n "$RELEASE_APPROVAL" ] && exit 0

if [ -z "$CI" ]; then
  jq -n --arg r "$reason. Release gate: only the release manager (Kaloyan) may authorize production changes. Approve only if the PR is merged and the preview deploy was verified." \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $r}}'
  exit 0
fi
echo "Blocked: $reason. Production changes need the release manager (Kaloyan). Prepare the release (merged PR, verified preview) and ask for approval; a pre-authorized run sets RELEASE_APPROVAL." >&2
exit 2
