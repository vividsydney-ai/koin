#!/usr/bin/env bash
# Design system drift detection.
# Usage: scripts/design-drift-check.sh
# Canonical source: koinaku-design-system-v4 (theme.css :root). Checks both
# lib/design-tokens.ts (reference doc for agents) and app/globals.css (the
# live Tailwind v4 config) so the two can't silently diverge from each other
# or from canonical.

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

CANONICAL_PRIMARY="#6f4af0"   # Orbit Purple 500
CANONICAL_SECONDARY="#0a6f90" # 50K blue
CANONICAL_DANGER="#c41f26"    # 100K red — semantic danger only, never primary

FAIL=0

check_lib() {
  local field="$1" canonical="$2" label="$3"
  local value
  value=$(grep -oE "${field}:[[:space:]]*\"#[a-fA-F0-9]{6}\"" lib/design-tokens.ts 2>/dev/null | grep -oE '#[a-fA-F0-9]{6}' | head -1 || echo "")
  if [[ "$value" != "$canonical" ]]; then
    echo "DRIFT: lib/design-tokens.ts ${label} (${value:-missing}) != canonical (${canonical})"
    FAIL=1
  else
    echo "OK: lib/design-tokens.ts ${label} matches canonical"
  fi
}

check_globals() {
  local css_var="$1" canonical="$2" label="$3"
  # Resolve --color-X -> var(--rup-Y-500) -> literal hex, both from app/globals.css
  local ramp_ref value=""
  ramp_ref=$(grep -oE -- "--${css_var}:[[:space:]]*var\(--rup-[a-z]+-[0-9]+\)" app/globals.css 2>/dev/null | grep -oE -- '--rup-[a-z]+-[0-9]+' | head -1 || echo "")
  if [[ -n "$ramp_ref" ]]; then
    value=$(grep -oE -- "${ramp_ref}:[[:space:]]*#[a-fA-F0-9]{6}" app/globals.css 2>/dev/null | grep -oE '#[a-fA-F0-9]{6}' | head -1 || echo "")
  fi
  if [[ "$value" != "$canonical" ]]; then
    echo "DRIFT: app/globals.css --${css_var} (${value:-missing} via ${ramp_ref:-none}) != canonical (${canonical})"
    FAIL=1
  else
    echo "OK: app/globals.css --${css_var} matches canonical"
  fi
}

check_lib "primary" "$CANONICAL_PRIMARY" "primary"
check_lib "secondary" "$CANONICAL_SECONDARY" "secondary"
check_lib "danger" "$CANONICAL_DANGER" "danger"

check_globals "color-primary" "$CANONICAL_PRIMARY" "color-primary"
check_globals "color-secondary" "$CANONICAL_SECONDARY" "color-secondary"
check_globals "color-danger" "$CANONICAL_DANGER" "color-danger"

exit "$FAIL"
