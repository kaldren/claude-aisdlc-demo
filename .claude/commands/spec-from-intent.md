---
description: Produce spec.md from an accepted intent.md, applying the repo's policy skills
argument-hint: <path to intent.md>
---

Read the intent at $ARGUMENTS and produce a requirements and design spec for integrating it into our existing codebase. Apply the skills available to you (api-conventions, security-baseline) so the spec conforms to our API conventions and security baseline. Document the spec fully as spec.md in the same folder, using intent/_SPEC_TEMPLATE.md. List the skills you applied with their git short SHA. Describe clearly any areas of concern, especially where you cannot satisfy contradicting policies. Answer every open question from the intent or carry it forward with an owner. Do not write code.
