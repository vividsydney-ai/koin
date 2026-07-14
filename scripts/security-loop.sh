#!/usr/bin/env bash
# Monthly security audit loop.
# Usage: scripts/security-loop.sh

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

REPORT="security-audit-$(date +%Y-%m).md"
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

FAIL=0
{
  echo "# Security Audit — $DATE"
  echo ""

  echo "## 1. Dependency audit"
  if npm audit --audit-level=moderate; then
    echo "PASS: no moderate+ advisories"
  else
    echo "FAIL: dependency audit found issues"
    FAIL=1
  fi
  echo ""

  echo "## 2. Secret scan"
  if git log --all --source --remotes --pickaxe-regex -S 'sk_live_[a-zA-Z0-9]{24,}' 2>/dev/null | grep -q .; then
    echo "FAIL: possible live secret in git history"
    FAIL=1
  else
    echo "PASS: no obvious live secrets in history"
  fi
  echo ""

  echo "## 3. RLS policy review"
  RLS_COUNT=$(grep -l "ENABLE ROW LEVEL SECURITY" supabase/migrations/*.sql 2>/dev/null | wc -l | tr -d ' ')
  echo "Migrations with RLS enabled: $RLS_COUNT"
  echo ""

  echo "## 4. Raw HTML / XSS audit"
  if grep -rn "dangerouslySetInnerHTML" app/ components/ lib/ 2>/dev/null; then
    echo "WARNING: dangerouslySetInnerHTML found; review manually"
  else
    echo "PASS: no dangerouslySetInnerHTML usage"
  fi
  echo ""

  if [[ "$FAIL" -eq 0 ]]; then
    echo "## Result: PASSED"
  else
    echo "## Result: FAILED — create Linear issue with label security and escalate"
  fi
} > "$REPORT"

echo "Wrote $REPORT"
exit "$FAIL"
