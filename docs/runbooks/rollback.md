# Runbook: roll back production (Vercel)

The only rollback the agent may run, and only after a human says "go" (the production gate hook asks/blocks).

1. Find the last good production deployment:
   `npx vercel ls claude-aisdlc-demo --prod` — or Vercel MCP `list_deployments` (target production).
2. Roll back (instant alias switch, no rebuild):
   `npx vercel rollback <deployment-url-or-id>` — or Vercel MCP `request_rollback`.
3. Verify: `curl -si https://<production-domain>/api/health` → 200, and `commit` equals the good deployment's SHA.
4. Undo the rollback once fixed: merging the fix to `main` deploys a new production build; if auto-assign is paused after
   the rollback, run `npx vercel promote <new-deployment>` (gated the same way).
5. Record it: post-mortem in `lessons/`, and the rehearsal/incident date in `docs/ai-sdlc/progress.md`.
