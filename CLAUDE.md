# claude-aisdlc-demo

A Next.js web app used to practise the AI-native SDLC end to end. Solo project; deploys to Vercel (preview per PR, production from `main`).

@AGENTS.md

## Commands
- All checks: `npm run check` — lint → typecheck → test → build; exits non-zero on the first failure. This is what CI runs.
- Lint: `npm run lint` (healthy: no output; warnings fail too)
- Typecheck: `npm run typecheck` (runs `next typegen` first; healthy: no `error TS` lines)
- Test: `npm test` (Vitest; healthy: `Tests  N passed`, 0 failed)
- Build: `npm run build` (healthy: ends with the route table, e.g. `○ (Static) prerendered as static content`)
- Run locally: `npm run dev` → http://localhost:3000

## Conventions
- Next.js 16 App Router, React 19, TypeScript strict, Tailwind 4. Don't add a second styling or state library without a spec saying so.
- Node version is pinned in `.nvmrc`; use npm (not pnpm/yarn) so `package-lock.json` stays the only lockfile.
- Tests live next to the code as `*.test.ts(x)`; logic worth testing goes in `src/lib/` as plain functions, not inside route handlers or components.
- Every API route under `src/app/api/` gets a Vitest test that calls the handler directly.
- Import via the `@/` alias, not long relative paths.

## Architecture
- `src/app/` — routes (pages, layouts, `api/*/route.ts` handlers). Keep handlers thin.
- `src/lib/` — framework-free logic and helpers.
- `intent/` — the artifact chain per change. `docs/ai-sdlc/progress.md` — rollout status.
- `.github/workflows/` — CI. Don't edit without being asked; it is the gate on your own work.

## How we work (AI-SDLC)
- Every change has `intent/<YYYY-MM-DD>-<slug>/{intent,spec,plan}.md`. Read them before working on the change.
- Start non-trivial work in plan mode. If implementation departs from `plan.md`, update it in the same commit.
- Small commits on a branch, PR into `main`; never push to `main` directly once branch protection is on.

## Verifying your work
Before reporting any task complete, run `npm run check` and paste the tail of its output (test summary + build route table).
If a test fails, fix the code, not the test. Never skip, delete or `.only` a test to get green.
For UI changes, also open the page in a browser and check it renders as intended.

## Things Claude gets wrong
<!-- When Claude makes the same mistake twice, add the correction here. Keep this file under a page. -->
- This is Next.js 16: APIs differ from older versions. Check `node_modules/next/dist/docs/` before using a Next API you're unsure of.
- Cache Components are enabled: a `GET` route handler or page that reads no runtime data (request, headers, uncached fetch) is prerendered at build time, so values like `Date.now()` freeze. See `node_modules/next/dist/docs/01-app/01-getting-started/15-route-handlers.md` when output must be fresh per request.
- `tsc` alone fails on `LayoutProps`/`PageProps` — always typecheck via `npm run typecheck`.
