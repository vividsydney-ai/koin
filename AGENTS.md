# AGENTS.md — Koin Agent Configuration v2

> **Last updated:** 2026-07-14

Every agent starts by reading `loop-state.md`. If it exists and state is not `DONE`, resume from that state. Otherwise read `HANDOFF.md`, `KIMI_HANDOFF.md`, `TASKS.md`, then `docs/agents/LOOP_ENGINEERING.md`.

## Single-agent sessions (simple fixes)
For one-file UI fixes or trivial tweaks: one agent runs the full loop alone.

## Multi-agent / swarm sessions (complex or risky slices)
Use separate agents for Plan / Make / Verify / Fix / Land so the verifier never approves its own work.

### Roles
| Role | Responsibility | Writes? |
|------|----------------|---------|
| **Planner** | Decompose task into a vertical slice; identify files, migrations, risks. | `loop-state.md` plan |
| **Maker** | Implement code, tests, and (if needed) one migration on an isolated worktree branch. | Code + tests |
| **Verifier** | Read-only review: run `npm run loop:gates`, diff scans, security/design checks. | `loop-verdict.md` |
| **Fixer** | Receive Verifier findings and fix root cause; may be the same agent as Maker with reset context. | Code |
| **Lander** | Merge, push, update `TASKS.md`/`progress.md`/Linear, archive `loop-state.md`. | Metadata only |

### Conductor rules (gotcha mitigation)
1. **One editor at a time.** Set `loop-state.md > locked_by = <role>` before dispatching an editing agent.
2. **Verifier is read-only.** It must not edit code or `loop-state.md`.
3. **Shared context.** Every agent receives identical base context: task ID, plan, relevant `RULES.md`/`SCHEMA.md` excerpts, target branch, budget remaining.
4. **Verdict format.** Verifier returns `status: PASS | FAIL | NEEDS_INFO`, gate, evidence, files_changed, recommendation.
5. **Budget accounting.** Each subagent call increments `loop-budget.md > subagent_calls`.
6. **Worktree isolation.** Maker works on `wt/<task-slug>` branched from `web-koinaku`. Verifier checks out the same worktree read-only. Lander merges only after all gates pass.
7. **No self-verification.** Maker may run tests for feedback, but official gate run is by a distinct Verifier.

## Pre-flight checklist
1. Read `loop-state.md` first. Resume if state != DONE.
2. Read `HANDOFF.md`, `KIMI_HANDOFF.md`, `TASKS.md`, `RULES.md`, `CONTEXT.md`, `ADL.md`, `SCHEMA.md`.
3. Identify the vertical slice: smallest end-to-end piece that can be built and verified independently.
4. Initialize `loop-state.md` with `npm run loop:init <ID> "<title>"` if starting fresh.
5. Search reflexion: `npm run loop:reflexion <tag>` before planning.
6. Write or update tests before implementation code (TDD).

## Stop tokens / escalation
- `ESCALATED` — budget exhausted or human said STOP/HOLD. Halt immediately.
- `BLOCKED` — external dependency missing. Log blocker and stop.
- `DONE` — all gates passed, landed, metadata updated.

## Gate protocol
Run `npm run loop:gates` in verification. Phase-specific thresholds:
- Phase 1 (migrations): `npx supabase db reset` exits 0, RLS in same migration file.
- Phase 2 (auth): auth tests pass, no localStorage/sessionStorage.
- Phase 3A (core learning): lesson completion, variants, sources, quiz randomization pass.
- Phase 3B (paper trading): first trade end-to-end, market data, risk profile.
- Phase 4 (streaks + points): streak engine, Koin Points awards pass.
- Phase 5 (social + graduation): friends, leaderboard, graduation certificate pass.
- Phase 6 (adaptive + polish): triggers fire, Lighthouse mobile ≥85, accessibility ≥95, WCAG AA.

## What agents may NOT modify
- `RULES.md` (human controls)
- `.env*` files
- `/tests/` files (read only)
- `supabase/migrations/` — one migration per task, only Maker
