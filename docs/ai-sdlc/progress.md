# AI-SDLC progress — claude-aisdlc-demo

Coach: `/ai-sdlc` (status: `/ai-sdlc status`, continue: `/ai-sdlc next`)
Started: 2026-10-29

## Profile
- Detected (at kickoff): empty folder, not a git repo; node 26.10, npm 11, pnpm 12, jq, git, gh (logged in as `kaldren`) available
- Project state: new → Phase 0 includes git init, GitHub repo, Next.js scaffold, one passing test, minimal CI
- Team: solo → every role is you; gates = "review the artifact before you commit it"; PR review kept (author ≠ reviewer); skip MDM managed settings, policy-owner routing, plugin marketplaces
- Ambition: Full closed loop → roadmap runs through Phase 7
- Tracker / source of truth: none → repo-as-truth (`intent/` folder in this repo)
- Roles: product owner, tech lead, release manager, policy owners = Kaloyan (solo)
- Policies to encode: API/architecture, security; first skill: API/architecture conventions (the pilot is an API route), security second
- Data sensitivity: none → standard secrets hook, no regulated controls
- CI: GitHub Actions; model access: Anthropic API key (`ANTHROPIC_API_KEY` Actions secret)
- UI: web → visual feedback loop via browser MCP (Claude in Chrome / Playwright) in Stage 4
- Stack: Next.js + TypeScript, Vitest (unit), Playwright (e2e)
- Environments: Vercel preview (per PR, stands in for staging) + production (main)
- Metrics store / chat: CI + git data only (first control band: CI failure rate or PR cycle time) / Slack → Claude Tag kept
- Protected paths: `.github/workflows/**`; change-controlled paths: none yet
- Pilot change: `GET /api/health` returning status + version

## Roadmap
Legend: ✅ done · 🟡 in progress/blocked · ⬜ not started · ➖ skipped (reason)

### Phase 0 — Prerequisites
- ✅ Git repo + GitHub remote — https://github.com/kaldren/claude-aisdlc-demo (private)
- ✅ jq installed
- ✅ Next.js 16 + TS scaffold; `npm run lint` / `typecheck` / `test` / `build`, all-in-one `npm run check`; smoke test `src/app/page.test.tsx`
- ✅ GitHub Actions CI (`.github/workflows/ci.yml`) runs `npm run check` on PRs + main; Node from `.nvmrc`

### Phase 1 — Foundations
- ✅ P4 CLAUDE.md — 42 lines, imports Next's `AGENTS.md`; commands verified 2026-10-29
- 🟡 P8 Feedback loop — verification block in CLAUDE.md, lint now `--max-warnings 0`; left: fresh-session test, browser MCP for UI loop
- ⬜ P1 Intent home (`intent/`) + template

### Phase 2 — Artifact chain (pilot: /api/health)
- ⬜ P1 Pilot intent.md
- ⬜ P5 First policy skill (API/architecture conventions)
- ⬜ P2 spec.md
- ⬜ P3 plan.md + implementation
- ⬜ Checkpoint: walk the chain in `git log`

### Phase 3 — Guardrails
- ⬜ P6 Build hooks: protect `.github/workflows/**`, block secrets, format-on-edit, test protection; permissions allowlist
- ⬜ P5 Second policy skill (security)
- ⬜ P3 Auto mode for routine work

### Phase 4 — Scale and review
- ⬜ P7 Verifier subagent, then 2–3 parallel worktree sessions
- ⬜ P10 REVIEW.md + automated PR review (claude-code-action), `@claude` fix loop

### Phase 5 — Gates and pipeline
- ⬜ P11 Approval-gate hooks (Vercel production deploy/promote); branch protection on main
- ⬜ P12 Claude in CI: triage → write via PR → Vercel deploy tools → per-env tiers (preview free, prod gated) → rehearsed rollback
- ⬜ Automate triggers: merged intent → spec job; approved spec → plan session

### Phase 6 — Test the agent itself
- ⬜ P9 Continuous evals (start at ~10 tasks, nightly + on changes to CLAUDE.md / `.claude/**`)

### Phase 7 — Close the loop
- ⬜ P13 Control band on CI failure rate / PR cycle time → agent writes `intent.md`
- ⬜ P14 Claude Tag in a Slack incident channel

## Decisions log
- 2026-10-29 — repo-as-truth, intents in `intent/` — solo, no tracker
- 2026-10-29 — Next.js + TS on Vercel, preview deploys stand in for staging — fastest path to a real dev/prod split
- 2026-10-29 — first skill = API/architecture — pilot is an API route
- 2026-10-29 — `typecheck` runs `next typegen` first — Next 16 global types (`LayoutProps`) only exist after typegen
- 2026-10-29 — lint fails on warnings (`--max-warnings 0`) — CLAUDE.md says zero warnings, tooling should enforce it
- 2026-10-29 — kept Next's `AGENTS.md` (auto-maintained by `next dev`); CLAUDE.md will reference it

## Blockers / "You do" items outstanding
- [ ] (Phase 4) Add `ANTHROPIC_API_KEY` Actions secret / run `/install-github-app` — Kaloyan
- [ ] (Phase 5) Connect repo to a Vercel project — Kaloyan
- [ ] (Phase 7) Slack workspace + `/install-slack-app` — Kaloyan

## Metrics baselines
<!-- metric — baseline value — date — source -->
- CLAUDE.md corrections ("Things Claude gets wrong" entries added after mistakes) — 0 — 2026-10-29 — `git log -p CLAUDE.md`
- CI duration — 42s — 2026-10-29 — gh run 40844077617
- CI failure rate — 0/1 runs — 2026-10-29 — `gh run list`

## Recurring
- Monthly: tune REVIEW.md (rate findings, cap nits) — next: after P10
- Rollback rehearsal on Vercel (promote previous deployment) — last: never
