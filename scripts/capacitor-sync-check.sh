#!/usr/bin/env bash
# Verify native platforms are synced after web changes.
# Usage: scripts/capacitor-sync-check.sh

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

if [[ ! -d "ios" && ! -d "android" ]]; then
  echo "SKIP: no native platforms present"
  exit 0
fi

BEFORE=$(git status --short ios/ android/ 2>/dev/null | md5 || true)

npx cap sync

AFTER=$(git status --short ios/ android/ 2>/dev/null | md5 || true)

if [[ "$BEFORE" != "$AFTER" ]]; then
  echo "FAIL: cap sync produced uncommitted changes in ios/ or android/"
  git status --short ios/ android/
  exit 1
fi

echo "PASS: native platforms are in sync"
exit 0
