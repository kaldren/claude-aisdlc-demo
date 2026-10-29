---
description: Drive one of Claude's PRs to green — address review comments and failing checks until only code-owner approval remains
argument-hint: <PR number>
---

Babysit PR #$ARGUMENTS until it is green and waiting only on code-owner approval.

Loop:
1. `gh pr view $ARGUMENTS --comments` and `gh pr checks $ARGUMENTS` — list unresolved review comments and failing checks.
2. For each unresolved comment: address it in code, or reply explaining why not. Read the change's spec.md and plan.md first; if a fix departs from plan.md, update plan.md in the same commit.
3. For each failing check: read its log (`gh run view --log-failed`), fix the cause, and run `npm run check` locally before pushing. Fix code, not tests.
4. Push, wait for checks, repeat.

Stop and report when: all checks pass and no comments are unresolved; or a comment needs a human decision (intent, scope, risk); or the same check fails three times for the same reason. Never approve or merge the PR yourself.
