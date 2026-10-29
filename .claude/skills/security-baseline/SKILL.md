---
name: security-baseline
description: This repo's security baseline. Use whenever handling environment variables or secrets, adding an endpoint or anything that returns server data, adding a dependency, rendering user-supplied content, or writing/reviewing a spec, plan or PR that touches any of these.
---

# Security baseline
<!-- Owner: Kaloyan (security policy owner). Source of truth: this file. Changes need the owner's approval in a PR. -->

1. **Secrets** come only from environment variables read on the server. Never prefix a secret with `NEXT_PUBLIC_`, never import server env into a client component, never write a secret to a file (a hook blocks common key formats).
2. **Expose the minimum.** Endpoints return an explicit allow-list of fields — never spread `process.env`, config objects, request headers or error objects into a response. Build metadata that is safe to expose: app version, short commit SHA, environment name.
3. **Errors** return the standard error shape from `api-conventions` with a generic message; details go to server logs only, without secrets or personal data.
4. **State-changing endpoints need authentication.** There is no auth in the app yet — any spec that adds a non-`GET` endpoint must flag this as an area of concern.
5. **User content** is rendered as text. `dangerouslySetInnerHTML` needs a sanitizer and a spec-level justification.
6. **Dependencies.** New runtime dependencies are named and justified in the spec. No high/critical advisories in production dependencies.

Run `scripts/check-security.sh` and include its output in your summary.
