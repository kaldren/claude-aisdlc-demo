#!/bin/bash
# Deterministic check for the security-baseline skill. Exit 1 on any violation.
cd "$(dirname "$0")/.." || exit 1
status=0
if grep -rnE 'NEXT_PUBLIC_[A-Z_]*(SECRET|TOKEN|KEY|PASSWORD)' src --include='*.ts' --include='*.tsx'; then
  echo "FAIL secret-looking NEXT_PUBLIC_ variable"; status=1
else echo "ok   no secret-looking NEXT_PUBLIC_ variables"; fi
if grep -rnE '\.\.\.process\.env|Response\.json\(process\.env' src --include='*.ts' --include='*.tsx'; then
  echo "FAIL process.env spread into a value"; status=1
else echo "ok   process.env never spread"; fi
if npm audit --omit=dev --audit-level=high >/dev/null 2>&1; then echo "ok   no high/critical advisories in production deps"
else echo "FAIL npm audit --omit=dev --audit-level=high"; status=1; fi
exit $status
