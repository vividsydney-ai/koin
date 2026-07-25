#!/usr/bin/env bash
# Initialize loop-state.md for a new task and enforce Linear tracking.
# Usage: scripts/loop-init.sh <TASK_ID> "<Task title>" [branch] [--children <path>]
#
# Enforces Koinaku rule: every implementation task must have a Linear issue
# before coding starts. Multi-outcome tasks must provide a --children spec
# so the sync utility can atomize them into linked child issues.

set -euo pipefail

TASK_ID=""
TITLE=""
BRANCH="web-koinaku"
CHILDREN_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --children)
      CHILDREN_PATH="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1"
      echo "Usage: $0 <TASK_ID> \"<Task title>\" [branch] [--children <path>]"
      exit 1
      ;;
    *)
      if [[ -z "$TASK_ID" ]]; then
        TASK_ID="$1"
      elif [[ -z "$TITLE" ]]; then
        TITLE="$1"
      elif [[ "$BRANCH" == "web-koinaku" ]]; then
        BRANCH="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$TASK_ID" || -z "$TITLE" ]]; then
  echo "Usage: $0 <TASK_ID> \"<Task title>\" [branch] [--children <path>]"
  exit 1
fi

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if [[ -f "loop-state.md" ]]; then
  echo "loop-state.md already exists. Archive or delete it before starting a new task."
  exit 1
fi

cat > loop-state.md <<EOF
# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: $TASK_ID
- Title: $TITLE
- Phase: PLANNING
- Iteration: 0 / 6
- Locked by: none
- Agent:
- Started: $DATE
- Branch: $BRANCH
- Worktree: none

## Plan Summary
<!-- Planner writes this. Maker follows it. Verifier checks against it. -->

## Swarm Assignment
- Planner:
- Maker:
- Verifier:
- Fixer:
- Lander:

## Gates Run
- [ ] Gate 0: TypeScript (npx tsc --noEmit)
- [ ] Gate 1: Tests (npx vitest run)
- [ ] Gate 2: Diff scan (no localStorage/sessionStorage)
- [ ] Gate 3: RLS check (if migration touched)
- [ ] Gate 4: Lighthouse mobile >=85 / accessibility >=95
- [ ] Gate 5: Design-token drift check
- [ ] Gate 6: Secret scan
- [ ] Gate 7: Linear tracking gate

## Blockers
None

## Corrections Applied
<!-- Each failed iteration: what failed, root cause, fix. -->

## Verdict
<!-- Verifier appends PASS/FAIL/NEEDS_INFO here. -->

## Budget
- Max iterations: 6
- Remaining: 6
- Time elapsed: 0 min
- Files touched: 0 / 15
- Migrations: 0 / 1
- Subagent calls: 0
EOF

cat > loop-budget.md <<EOF
# loop-budget.md

## $DATE — $TASK_ID: $TITLE
- Iterations used: 0 / 6
- Time: 0 min / 45 min
- Files touched: 0 / 15
- Migrations: 0 / 1
- Subagent calls: 0
- Status: PLANNING
- Estimated tokens: ~0

## Subagent call log
| # | Role | Started | Duration | Outcome |
|---|------|---------|----------|---------|
EOF

# --- Linear tracking enforcement ---
if [[ -n "$CHILDREN_PATH" && ! -f "$CHILDREN_PATH" ]]; then
  echo "[loop-init] Children spec not found: $CHILDREN_PATH"
  rm -f loop-state.md loop-budget.md
  exit 1
fi

if command -v node &>/dev/null && [[ -f "scripts/linear-task-sync.mjs" ]]; then
  if [[ -n "$CHILDREN_PATH" ]]; then
    node scripts/linear-task-sync.mjs --task-id "$TASK_ID" --title "$TITLE" --children "$CHILDREN_PATH" || {
      echo "[loop-init] Linear sync failed. Fix the issue or run with a manually created Linear parent."
      rm -f loop-state.md loop-budget.md
      exit 1
    }
  else
    node scripts/linear-task-sync.mjs --task-id "$TASK_ID" --title "$TITLE" || {
      echo "[loop-init] Linear sync failed. Every task needs a Linear parent before implementation."
      echo "[loop-init] Create one manually or provide --children <path> to atomize the task."
      rm -f loop-state.md loop-budget.md
      exit 1
    }
  fi
else
  echo "[loop-init] WARNING: linear-task-sync.mjs not available; Linear tracking could not be enforced."
fi

echo "Initialized loop-state.md and loop-budget.md for $TASK_ID"
