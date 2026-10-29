# intent/

One folder per change: `intent/<YYYY-MM-DD>-<slug>/` holding `intent.md` → `spec.md` → `plan.md`.
The git history of these files is the audit trail: who asked, what was decided, who accepted it.

- **Propose:** copy `_TEMPLATE.md` to `intent/<date>-<slug>/intent.md` on a branch `intent/<slug>`, status `draft`, open a PR.
  Commit message: `intent: <slug> — <one-line problem>`.
- **Statuses:** `draft` → `accepted` | `rejected`. Spec and plan use the same statuses.
- **Who accepts:** the product owner (Kaloyan) — by merging the PR. Rejecting = closing it.
  Solo rule: re-read the artifact after a break before merging it.
- **Agents may write intents** (e.g. the control loop in `.github/workflows/control-loop.yml`) but never accept them.
- Merging an accepted intent triggers `.github/workflows/spec-from-intent.yml`, which drafts `spec.md` as a PR.
