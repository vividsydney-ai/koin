# Agent Handoff — Koin Web MVP

> Last updated: 2026-07-25
> Read this at the start of a new session before doing anything else.

## Current branch and deploy
- **Integration branch:** `web-koinaku`
- **Production URL:** https://web.koinaku.com on Vercel
- **Last deploy smoke check:** 200 OK

## Last known state
- Phases 1–5 complete. Phase 6 polish shipped to `https://web.koinaku.com` on Vercel.
- **2026-07-25 — recent work:**
  - KO-CURR-004: Learn page now renders 8 numbered chapters (`01 - Money Basics` … `08 - Cryptocurrency 101`).
  - Fixed Vercel production deploy blocker: `app/onboarding/page.tsx` wrapped in `Suspense` so `useSearchParams()` no longer fails static prerender.
  - KO-AUTH-001: email validation, forgot-password flow, password-strength guidance, show/hide password toggles, and profile/account password change all implemented and live.
  - Friend list "unknown" names fixed; streak/XP increment verified; OJK/BI/IDX source-link handling verified.
  - KO-QUIZ-001: post-lesson "Next" button now skips already-completed lessons and lands on the next uncompleted lesson in curriculum order (new migration `20260725000001_KO-QUIZ-001_skip_completed_next_lesson.sql`).
  - Bug-sheet reconciliation: 19-row Google Sheet audited; KO-37→KO-41 verified Done; fixed bugs tracked as KO-136→KO-144; open bugs tracked as KO-145→KO-149. KO-148 (cohort invite) and KO-149 (camera QR scan) were verified working and moved to Done.
- **Remaining open bugs:** KO-145 (BI Rates source 404), KO-146 (IDX education sources 503), KO-147 (Bahasa Indonesia grammar inconsistencies).
- Tests: `npx vitest run` → 453 passed / 5 skipped.
- `npm run type-check` clean.
- `npm run lint` → 0 errors, 22 warnings.

## Next: finish Phase 6 + open bug tracker
- Address remaining open bugs:
  - KO-145 — Bank Indonesia BI Rates source returns 404
  - KO-146 — IDX education sources return 503
  - KO-147 — Bahasa Indonesia grammar inconsistencies
- Remaining Phase 6 items from `TASKS.md`:
  - C1: Recommended resources per lesson
  - C2: Analytics events wrapper + 16 spec events
  - C3: Notification queue stub delivery
  - C5: Final QA: 375px mobile, 1280px desktop, keyboard nav, WCAG AA, Lighthouse mobile ≥85 / accessibility ≥95
- Note: Google Sheet bug tracker is read-only with the current API key; updating the Status column requires OAuth2 or a service-account key.

## Loop v2 + swarm protocol
Use the loop engineering from `docs/agents/LOOP_ENGINEERING.md`:
1. Start every session by reading `loop-state.md`. Resume if state != DONE.
2. Run OpenWiki pre-flight: read `openwiki/quickstart.md` and task-relevant pages if present; always read `openwiki/INSTRUCTIONS.md` if present; initialize/refresh with `openwiki code --update --print` when available and needed.
3. For complex/risky slices, use swarm roles: Planner → Maker → Verifier → Fixer → Lander.
4. Verifier is read-only; Maker works on an isolated worktree; Lander merges only when gates pass.
5. Run `npm run loop:init <ID> "<title>"` to start a task, `npm run loop:gates` to verify.

## Agent entry points
- **Kimi Code:** read `KIMI_HANDOFF.md` first, then `HANDOFF.md` and `loop-state.md`.
- **Claude / Codex:** read `CLAUDE.md` and `HANDOFF.md` first, then `loop-state.md`.

## Essential docs to read
1. `loop-state.md` — current task state (read first)
2. `openwiki/INSTRUCTIONS.md` and `openwiki/quickstart.md` — OpenWiki brief and generated repo memory, if present
3. `docs/agents/LOOP_ENGINEERING.md` — loop engineering v2 + swarm roles
4. `AGENTS.md` — agent roles, gotcha mitigations, hard stops
5. `CLAUDE.md` / `KIMI_HANDOFF.md` — agent-specific routing
6. `TASKS.md` — task list
7. `progress.md` — live state
8. `CONTEXT.md`, `ADL.md`, `SCHEMA.md` — domain and schema context

## Environment notes
- `UpdateGoal` tool is not exposed. Do not wait for it. Track completion in `progress.md`, `TASKS.md`, and Linear.
- Native iOS/Android work (Phase 1b) is **paused**. Do not resume unless the human explicitly asks.
- Google Sheet bug tracker auto-creates Linear issues and writes IDs back to column O.
