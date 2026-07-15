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
- Auth sign-up confirmations re-enabled with custom Google Workspace SMTP (hello@koinaku.com app password) via Supabase config push (KO-46).
- Signup form UX modernized: full name, password confirmation, show/hide toggles, inline validation.
- Production browse test verified signup creates user and sends verification email.
- Cofounder duplicate auth account removed (KO-47); he can now sign up cleanly with arjuna@koinaku.com or arjuna.dhananjaya08@gmail.com.
- Signup placeholder updated to Alfa Satria (KO-48).
- Onboarding supports up to 3 financial goals via multi-select; profiles.financial_goal migrated to TEXT[] (KO-49).
- Production browse verified onboarding end-to-end with 3 goals saved correctly.
- Lesson numbering audit complete (KO-50): fixed LessonPlayer to show live total lesson count; content personalization verified via user-seeded variant selection.
- New users now see personalized lesson variants filtered by financial literacy level and goal-based recommendations on /learn (KO-51).
- Removed "Lesson not found" flash when loading/finishing lessons (KO-52).
- Replaced floating AI assist button with inline variant links inside each lesson step (KO-53).
- Published lesson 10 (emergency-fund-101); 10 lessons visible at launch (KO-54).
- Production domain migrated to `https://web.koinaku.com`.
- Tests: `npx vitest run` → 194 passed / 1 skipped.
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

## Agent entry points
- **Kimi Code:** read `KIMI_HANDOFF.md` first, then `HANDOFF.md` and `loop-state.md`.
- **Claude / Codex:** read `CLAUDE.md` and `HANDOFF.md` first, then `loop-state.md`.

## Essential docs to read
1. `loop-state.md` — current task state (read first)
2. `docs/agents/LOOP_ENGINEERING.md` — loop engineering v2 + swarm roles
3. `AGENTS.md` — agent roles, gotcha mitigations, hard stops
4. `CLAUDE.md` / `KIMI_HANDOFF.md` — agent-specific routing
5. `TASKS.md` — task list
6. `progress.md` — live state
7. `CONTEXT.md`, `ADL.md`, `SCHEMA.md` — domain and schema context

## Environment notes
- `UpdateGoal` tool is not exposed. Do not wait for it. Track completion in `progress.md`, `TASKS.md`, and Linear.
- Native iOS/Android work (Phase 1b) is **paused**. Do not resume unless the human explicitly asks.
- Google Sheet bug tracker auto-creates Linear issues and writes IDs back to column O.
