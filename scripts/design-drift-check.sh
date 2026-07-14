#!/usr/bin/env bash
# Design system drift detection.
# Usage: scripts/design-drift-check.sh

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

CANONICAL_RED="#c41f26"
CANONICAL_BLUE="#0a6f90"

APP_RED=$(grep -oE 'primary:[[:space:]]*"(#[a-fA-F0-9]{6})"' lib/design-tokens.ts 2>/dev/null | grep -oE '#[a-fA-F0-9]{6}' | head -1 || echo "")
APP_BLUE=$(grep -oE 'secondary:[[:space:]]*"(#[a-fA-F0-9]{6})"' lib/design-tokens.ts 2>/dev/null | grep -oE '#[a-fA-F0-9]{6}' | head -1 || echo "")

FAIL=0

if [[ "$APP_RED" != "$CANONICAL_RED" ]]; then
  echo "DRIFT: App primary red ($APP_RED) != canonical ($CANONICAL_RED)"
  FAIL=1
else
  echo "OK: primary red matches canonical"
fi

if [[ "$APP_BLUE" != "$CANONICAL_BLUE" ]]; then
  echo "DRIFT: App secondary blue ($APP_BLUE) != canonical ($CANONICAL_BLUE)"
  FAIL=1
else
  echo "OK: secondary blue matches canonical"
fi

exit "$FAIL"
