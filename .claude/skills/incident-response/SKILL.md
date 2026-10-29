---
name: incident-response
description: How to respond to a production incident or alert in this repo. Use whenever someone reports the site or an API is down, slow or erroring, a control-loop PR or alert arrives, someone tags Claude about an incident in Slack, or a rollback is being considered.
---

# Incident response
<!-- Owner: Kaloyan (on call). Changes need the owner's approval. -->

1. **Read first:** `lessons/` for the same signature, and the last production deploys (Vercel MCP `list_deployments`, `get_runtime_errors`, `get_runtime_logs`).
2. **Diagnose** by comparing the error signature with the diff of the most recent production deploy (`git log` / `gh pr view`). Check `/api/health` on production.
3. **Propose, don't act:** if a deploy in the window plausibly caused it, propose the rehearsed rollback in `docs/runbooks/rollback.md` and wait for an explicit human "go". Never improvise another production change.
4. **Small bounded fix** → branch + PR through review. **Anything bigger** → write `intent/<date>-<slug>/intent.md` (Source: alert/incident).
5. **Confirm recovery:** the metric or `/api/health` is back at baseline; paste the evidence.
6. **Write the post-mortem** `lessons/YYYY-MM-<slug>.md` (format in `lessons/README.md`) and propose an eval in `evals/` that would have caught it.
