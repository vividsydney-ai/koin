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
  - **KO-145 + KO-146: Dead BI/IDX source URLs fixed.** Created migration `20260725100000_KO145_146_fix_dead_source_urls.sql` to replace unreachable `bi.go.id` and `idx.co.id` URLs with verified Wikipedia equivalents. Updated `seed.sql` and `migration 030` to match. Added 13 tests (all passing). All 13 broken sources now point to topic-equivalent Wikipedia articles (ID or EN) with `needs_review` status and `trust_notes` explaining the substitution. Working sources preserved: BI-006 (Instagram), IDX-004/008 (YouTube), IDX-006 (App Store). **Deployed to production Supabase** (commit 767ad2d, Vercel auto-deploy at https://web.koinaku.com). Verified in production: BI-001/002, IDX-001/002 and 9 others all show Wikipedia URLs.
  - **KO-147: Bahasa Indonesia grammar inconsistencies fixed.** 8 fixes across `lib/i18n/dictionaries.ts` and legal docs: "side quest" → "misi tambahan", "Kepercayaan sumber" → "Keandalan sumber", pronoun shift fix in `learn.foundationPath`, removed English gloss "(streak)", translated "endorsement" → "dukungan", "watchlist" → "daftar pantau", "opt-in" → "keikutsertaan", "stempel waktu" → "cap waktu".
  - **Tracker reconciliation completed:** `TASKS.md` now maps genuine remaining work to Linear. Foundation 0 was already implemented and is now represented by Done parent KO-150 with Done children KO-151–KO-155; onboarding assessment gating and analytics are verified complete. Targeted verification: 39 passed / 3 skipped across Foundation 0, assessment, profile, Home, and analytics tests; source URL verification also passed.
  - **KO-156: Portfolio visibility follows paper-trading unlock.** Home hides the portfolio balance until the user has completed the existing unlock flow; completing that flow creates the default paper portfolio. New users should not see an IDR portfolio balance before unlocking trading.
  - **KO-157: Reversible account deletion shipped.** Danger Zone requires typed email plus current password, schedules permanent deletion after seven days, emails a recovery link, routes pending users to reactivation on sign-in, and runs a protected daily purge cron.
  - **In-app notification settings shipped.** Profile → Account → Notification settings provides a master toggle plus streak, friend, and cohort preferences; keep product alerts in-app and reserve email for account/security events.
- **Remaining open bugs:** None from the bug-tracker sheet. All KO-136→KO-149 are Done.
- Tests: `npx vitest run` → 466 passed / 5 skipped (13 new tests for KO-145/146 migration).
- `npm run type-check` clean.
- `npm run lint` → 0 errors, 22 warnings.

## Next: finish Phase 6
- Analytics is complete; do not duplicate it.
- Remaining work mapped to active Linear backlog:
  - **KO-112→KO-115:** lesson nudge, streak-freeze, and trade-onboarding notifications; delivery retry tests; bounce/complaint runbook.
  - **KO-111:** final mobile/desktop, keyboard, WCAG, and Lighthouse QA.
  - **KO-116:** verified recommended books and videos per lesson.
  - **KO-117:** document runtime versus internal-agent credentials in `.env.example`, then create `docs/ARCHITECTURE.md`.
  - **KO-95:** passkey (WebAuthn) sign-in and registration.
  - **KO-98:** reconcile live bug reports against deployed behaviour.
  - **KO-68:** screenshot QA and gradient K-tile follow-up.
- KO-11 and KO-12 remain the Phase 6 and handoff umbrella issues; use the child issues above for implementation work.
- Note: Google Sheet bug tracker is read-only with the current API key; updating the Status column requires OAuth2 or a service-account key.

## Tracker contract — Claude, Codex, and Kimi
- **Linear is canonical:** choose an active KO issue before work; update its state when work is actually complete.
- **`TASKS.md` is a local checklist:** it is intentionally gitignored, but every active item must carry its exact Linear ID. It mirrors implementation scope and must not silently introduce work absent from Linear.
- **`progress.md` is append-only evidence:** record goal, changes, verification, deploy state, and Linear outcome. Read its newest entry first; historical entries are not a live backlog.
- **Current active issues:** KO-11, KO-12, KO-68, KO-95, KO-98, KO-111, KO-112, KO-113, KO-114, KO-115, KO-116, and KO-117. Foundation 0 (KO-150→KO-155), assessment gating, and analytics are complete—do not re-implement them without new evidence.

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
