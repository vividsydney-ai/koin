# Agent Handoff — Koin Web MVP

> Last updated: 2026-07-14
> Read this at the start of a new session before doing anything else.

## Current branch and deploy
- **Integration branch:** `web-koinaku`
- **Production URL:** https://web.koinaku.com
- **Last deploy smoke check:** 200 OK

## Last known state
- Phases 1–5 complete.
- Phase 6 slices completed and deployed: Library tab, empty states, KO-37..KO-41 bug fixes.
- Auth sign-up timeout fixed by disabling Supabase email confirmations (custom SMTP can be added later).
- Production domain migrated to `https://web.koinaku.com`.
- Tests: `npx vitest run` → 121 passed / 1 skipped.
- `npm run type-check` clean.

## Next: finish Phase 6
Remaining items from `TASKS.md`:
- C1: Recommended resources per lesson
- C2: Analytics events wrapper + 16 spec events
- C3: Notification queue stub delivery
- C4: Lesson expansion 9 → 15
- C5: Final QA: 375px mobile, 1280px desktop, keyboard nav, WCAG AA

## Loop v2 + swarm protocol
Use the loop engineering from `docs/agents/LOOP_ENGINEERING.md`:
1. Start every session by reading `loop-state.md`. Resume if state != DONE.
2. For complex/risky slices, use swarm roles: Planner → Maker → Verifier → Fixer → Lander.
3. Verifier is read-only; Maker works on an isolated worktree; Lander merges only when gates pass.
4. Run `npm run loop:init <ID> "<title>"` to start a task, `npm run loop:gates` to verify.

## Essential docs to read
1. `loop-state.md` — current task state (read first)
2. `docs/agents/LOOP_ENGINEERING.md` — loop engineering v2 + swarm roles
3. `AGENTS.md` — agent roles, gotcha mitigations, hard stops
4. `CLAUDE.md` — workflow and file routing
5. `TASKS.md` — task list
6. `progress.md` — live state
7. `CONTEXT.md`, `ADL.md`, `SCHEMA.md` — domain and schema context

## Environment notes
- `UpdateGoal` tool is not exposed. Do not wait for it. Track completion in `progress.md`, `TASKS.md`, and Linear.
- Native iOS/Android work (Phase 1b) is **paused**. Do not resume unless the human explicitly asks.
- Google Sheet bug tracker auto-creates Linear issues and writes IDs back to column O.
