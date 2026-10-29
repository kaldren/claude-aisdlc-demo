#!/bin/bash
# Deterministic check for the api-conventions skill: every route handler has a test,
# and handlers don't log or leak errors. Exit 1 on any violation.
cd "$(dirname "$0")/.." || exit 1
status=0
routes=$(find src/app/api -name 'route.ts' 2>/dev/null | sort)
if [ -z "$routes" ]; then echo "check-api-routes: no API routes yet"; exit 0; fi
for r in $routes; do
  t="${r%.ts}.test.ts"
  if [ ! -f "$t" ]; then echo "FAIL $r: missing $t"; status=1; else echo "ok   $r has $t"; fi
  if grep -nE 'console\.log|\.stack\b' "$r"; then echo "FAIL $r: logs or exposes stack traces"; status=1; fi
done
exit $status
