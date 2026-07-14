#!/usr/bin/env bash
# Initialize loop-state.md for a new task.
# Usage: scripts/loop-init.sh <TASK_ID> "<Task title>" [branch]

set -euo pipefail

TASK_ID="${1:-}"
TITLE="${2:-}"
BRANCH="${3:-web-koinaku}"

if [[ -z "$TASK_ID" || -z "$TITLE" ]]; then
  echo "Usage: $0 <TASK_ID> \"<Task title>\" [branch]"
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

echo "Initialized loop-state.md and loop-budget.md for $TASK_ID"
