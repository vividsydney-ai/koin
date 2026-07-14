#!/usr/bin/env bash
# Check iteration/time/file/migration/subagent budgets from loop-state.md and loop-budget.md.
# Usage: scripts/budget-check.sh
# Exits 1 if any budget is exhausted.

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

MAX_ITERATIONS=6
MAX_MINUTES=45
MAX_FILES=15
MAX_MIGRATIONS=1

if [[ ! -f "loop-state.md" ]]; then
  echo "WARNING: loop-state.md not found"
  exit 0
fi

ITERATION=$(grep -E "^[-*] Iteration:" loop-state.md | sed -E 's/.*Iteration:[[:space:]]*([0-9]+).*/\1/' || echo 0)
REMAINING=$(grep -E "^[-*] Remaining:" loop-state.md | sed -E 's/.*Remaining:[[:space:]]*([0-9]+).*/\1/' || echo "$MAX_ITERATIONS")
FILES=$(grep -E "^[-*] Files touched:" loop-state.md | sed -E 's/.*Files touched:[[:space:]]*([0-9]+).*/\1/' || echo 0)
MIGRATIONS=$(grep -E "^[-*] Migrations:" loop-state.md | sed -E 's/.*Migrations:[[:space:]]*([0-9]+).*/\1/' || echo 0)
SUBAGENTS=$(grep -E "^[-*] Subagent calls:" loop-state.md | sed -E 's/.*Subagent calls:[[:space:]]*([0-9]+).*/\1/' || echo 0)

OVER=0

if [[ "$REMAINING" -le 0 ]]; then
  echo "BUDGET EXHAUSTED: iterations ($ITERATION / $MAX_ITERATIONS)"
  OVER=1
fi

if [[ "$FILES" -gt "$MAX_FILES" ]]; then
  echo "BUDGET EXHAUSTED: files touched ($FILES / $MAX_FILES)"
  OVER=1
fi

if [[ "$MIGRATIONS" -gt "$MAX_MIGRATIONS" ]]; then
  echo "BUDGET EXHAUSTED: migrations ($MIGRATIONS / $MAX_MIGRATIONS)"
  OVER=1
fi

if [[ "$SUBAGENTS" -gt 20 ]]; then
  echo "BUDGET WARNING: subagent calls ($SUBAGENTS) unusually high"
  # Do not fail automatically; warn.
fi

if [[ "$OVER" -eq 1 ]]; then
  echo "Set loop-state.md Phase = ESCALATED and stop."
  exit 1
fi

echo "Budget OK: iteration $ITERATION, files $FILES, migrations $MIGRATIONS, subagents $SUBAGENTS"
exit 0
