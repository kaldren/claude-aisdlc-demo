# Review instructions

Owner: Kaloyan (tech lead). Tune monthly: rate findings, cap nits, add exclusions.

## Passes
Run three passes and tag each finding with its pass:
- **Bugs:** logic errors, broken edge cases, subtle regressions — including Next 16 caching surprises (a `GET` that should be per-request but will be prerendered).
- **Security:** `.claude/skills/security-baseline/SKILL.md` — secrets, over-exposed fields, error leakage, unauthenticated state changes, new dependencies.
- **Compliance:** the diff matches its `intent/<change>/spec.md` (acceptance criteria) and `plan.md` (files that change; deviations recorded), and `.claude/skills/api-conventions/SKILL.md`. A change with no intent folder is a finding unless it's docs-only or tooling.

## What Important means here
**Important** = would break behaviour, leak data, breach a policy skill, or makes the diff disagree with plan.md without a recorded deviation. Everything about style or naming is a **Nit**.

## Cap the nits
At most five nits per review; summarize the rest as a count. If there are no Important findings, say so in one line.

## Keep CLAUDE.md honest
- If this PR repeats a mistake already flagged in an earlier review, propose the CLAUDE.md "Things Claude gets wrong" line that would prevent it.
- If the change makes something in CLAUDE.md outdated, say so.

## Do not report
- `package-lock.json`, `next-env.d.ts`, `AGENTS.md` (generated)
- Anything CI already enforces: lint, type errors, the `npm run policy` checks, failing tests
