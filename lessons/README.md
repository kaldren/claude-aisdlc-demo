# lessons/

One post-mortem per incident: `lessons/YYYY-MM-<slug>.md`. Future investigations read these first.

Each file: **What happened** (timeline, with UTC times) · **Detection** (alert, Slack, control loop) ·
**Cause** (evidence: deploy diff, error signature) · **Response** (who authorized what, rollback y/n) ·
**Back in band** (metric + when) · **Follow-ups** (intent.md links, the eval added in `evals/`).
