#!/usr/bin/env bash
set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$ROOT"

if [ ! -f ".loop/require-stop-gate" ]; then
  exit 0
fi

bash scripts/verify-loop.sh

