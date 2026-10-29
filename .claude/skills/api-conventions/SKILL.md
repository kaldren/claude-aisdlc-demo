---
name: api-conventions
description: This repo's API and architecture conventions for Next.js route handlers. Use whenever creating, changing or reviewing anything under src/app/api/, writing a spec or plan that adds or changes an endpoint, or deciding where server-side logic should live — even for a "tiny" endpoint like a health check.
---

# API conventions
<!-- Owner: Kaloyan (tech lead). Source of truth: this file. Changes need the owner's approval in a PR. -->

When you create or change an API endpoint:

1. **Layout.** Handler at `src/app/api/<name>/route.ts`; it parses input, calls a function, shapes the response — nothing else. Logic lives in `src/lib/<name>.ts` as plain functions with explicit inputs (pass env values, clocks, IDs in as arguments so they're testable).
2. **Methods.** Export only the HTTP methods the endpoint supports. `GET` never changes state.
3. **Responses.** Use `Response.json(...)`. Success bodies are the resource itself (no `{ data: … }` wrapper). Errors are `{ "error": { "code": "<snake_case>", "message": "<human text>" } }` with the matching status (400 invalid input, 404, 500). Never return stack traces or raw exception messages.
4. **Freshness is a decision, not an accident.** Cache Components are on: a `GET` that reads no runtime data is prerendered at build time. If the response must be computed per request, call `await connection()` from `next/server` first, add `Cache-Control: no-store`, and say why in one comment. If it may be static, say so in the spec.
5. **Input validation** happens in the handler before calling `src/lib`; invalid input → 400 `invalid_request`. Adding a validation library is a spec-level decision.
6. **Tests.** `src/lib/<name>.test.ts` covers the logic; `src/app/api/<name>/route.test.ts` calls the exported handler directly and asserts status, headers and body. Mock `next/server`'s `connection` with `vi.mock` when the handler awaits it.
7. **Contract in the spec.** Every new endpoint's spec lists method, path, status codes and an example body.

Run `scripts/check-api-routes.sh` and include its output in your summary.
<!-- Advisory. REVIEW.md's Compliance pass and the check in CI back it up. -->
