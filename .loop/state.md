# Loop State

This file is durable memory for loop engineering. Keep it short and operational.

## Current Mode

- Mode: web MVP first.
- Native/hybrid beta: paused until web MVP gates pass and the human explicitly resumes it.
- Active branch is discovered at runtime; do not hardcode `web-mvp` or `web-koinaku` without checking `git branch --show-current`.

## Quality Bar

- Trust is the product: every published financial lesson needs a reviewed source, preferably OJK, BI, or IDX.
- No `localStorage` or `sessionStorage`.
- No lesson publish state without review approval.
- RLS must ship with table creation.
- Web MVP must pass type-check, tests, build, and final mobile QA before native beta resumes.

## Loop Stop Tokens

Agents should end non-interactive loop runs with exactly one of:

- `LOOP_DONE` when the task is complete and gates are logged.
- `LOOP_BLOCKED` when progress stopped and the blocker is logged.
- `LOOP_CONTINUE` when more iterations are useful within the configured budget.

## Reusable Lessons

- Worktrees isolate files, not the local Supabase database. Serialize migrations.
- The repo has had stale branch names in handoff docs. Always verify current branch before landing.
- Existing native shell is present but intentionally paused; do not treat Capacitor files as the immediate next track unless requested.

