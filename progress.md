# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## 2026-07-14 — KO-44: Content audit and cleanup landed

- Created Linear KO-44 and initialized loop state with swarm roles (Planner / Maker / Verifier / Fixer / Lander).
- Planner audited remote `content_variants`: 1,089 active variants across 9 lessons; ~284 flagged for deactivation.
- Maker built `supabase/migrations/20260714000022_deactivate_low_quality_variants.sql` on isolated worktree `wt/ko-44`:
  - Scoped to 5 beginner launch lessons.
  - Deactivated templated examples/explanations, garbage answers, lottery-ticket distractors, generic true/false explanations, and exact duplicate question text.
  - Behavioral lessons left untouched.
- Added `tests/migrations/022_deactivate_low_quality_variants.test.ts` (13 structural assertions).
- Verifier returned **PASS**; all gates passed on worktree and main branch.
- Migration pushed to remote Supabase; verified active/inactive split: **805 active / 284 inactive**.
- Merged `wt/ko-44` into `web-koinaku`, ran gates again (142 passed, 1 skipped), updated `TASKS.md`.
- Archived `loop-state.md` / `loop-budget.md` to `.loop/reflexion/context/`.
- Deployed updated `web-koinaku` to Vercel: `https://koin-web-koinaku-hxunhqr3d-vividsydney.vercel.app` (aliased `https://web.koinaku.com`).
- KO-45 (onboarding financial literacy assessment) is now unblocked.

## 2026-07-14 — KO-43: Advanced lessons v2 imported

- Generated `scripts/generate-migration-021.py` to build migration 021 from `content-lessons/` CSVs.
- Created `supabase/migrations/20260714000021_import_advanced_lessons_v2.sql`:
  - 6 advanced lessons (10–15) inserted as draft/unpublished.
  - ~825 content variants added to the 5 beginner launch lessons.
  - 12 recommended resources and 6 lesson media placeholders kept inactive.
- Added `tests/migrations/021_import_advanced_lessons_v2.test.ts` with structural assertions.
- Updated `TASKS.md`: Phase 6 "Expand from 5 to 15 lessons" is now complete.
- Verification:
  - `npx tsc --noEmit` ✅
  - `npx vitest run` ✅ 129 passed, 1 skipped
  - `npm run loop:gates -- web` ✅ all gates passed
  - `npx supabase db push --include-all` ✅ migration applied to remote `koin` project
  - Remote DB row counts confirmed: 6 advanced lessons, 1,089 content_variants, 12 recommended_resources, 18 lesson_media.
- Deployed `web-koinaku` to Vercel production:
  - `https://koin-web-koinaku-jdtmw02dm-vividsydney.vercel.app`
  - Aliased `https://web.koinaku.com` ✅ 200
  - Aliased `https://koin-web-koinaku.vercel.app` ✅ 200
- Risks flagged: some generated variant answers are low-quality; resources/media use placeholder URLs. Both are kept inactive/draft pending content review.

## 2026-07-08 — Loop engineering scaffold added

- Added canonical loop engineering runbook: `docs/agents/LOOP_ENGINEERING.md`.
- Added durable loop memory and prompts under `.loop/`:
  - `.loop/state.md`
  - `.loop/prompts/orchestrator.md`
  - `.loop/prompts/maker.md`
  - `.loop/prompts/checker.md`
- Added executable loop scripts:
  - `scripts/agent-loop.sh`
  - `scripts/verify-loop.sh`
- Added package scripts:
  - `npm run loop:prompt`
  - `npm run loop:codex`
  - `npm run loop:claude`
  - `npm run loop:kimi`
  - `npm run verify:loop`
- Added optional Claude Stop hook gated by `.loop/require-stop-gate`, so normal Claude sessions are not forced to run heavy checks.
- Added `.worktreeinclude` for env-file copying into Claude worktrees and ignored `.loop/runs/` / `.claude/worktrees/`.
- Verification:
  - `bash -n scripts/agent-loop.sh && bash -n scripts/verify-loop.sh && bash -n .claude/hooks/loop-stop-gate.sh` ✅
  - `npm run loop:prompt` ✅ generated the bounded next-task prompt
  - `npm run verify:loop` ✅ passed

## 2026-07-06 — Koinaku rebrand branch created

- Created `web-koinaku` branch from `web-mvp`.
- Applied Koinaku v2 design system (`koinaku-site-v2/design-system.html`):
  - Rupiah-inspired color tokens: primary red `#c41f26`, secondary blue `#0a6f90`, etc.
  - Fonts: Cabinet Grotesk (display) + Satoshi (body) via Fontshare.
  - Updated `app/globals.css`, `lib/design-tokens.ts`, `app/layout.tsx`.
- Rebuilt onboarding flow (`app/onboarding/page.tsx`) as a 5-step Koinaku-branded experience:
  1. Welcome
  2. Profile (name + age range chips)
  3. Financial goal selector
  4. Notification toggle
  5. Ready summary
- Styled login and signup pages with Koinaku tokens and Indonesian copy.
- Bottom navigation labels set to English (Home, Learn, Trade, Friends, Library, Profile) per human direction.
- Shell test matches English labels.
- Verification:
  - `npx tsc --noEmit` ✅
  - `npm run test` ✅ 106 passed, 1 skipped
  - `npm run build` ✅ static export succeeds
  - Browse screenshots of login/signup pages at 375px ✅
- Open bugs (KO-37..KO-41) remain intentionally deferred on this branch.

## Last completed task
Implemented Loop Engineering v2 scaffolding and swarm protocol.
- Added Swarm Roles section to root `LOOP_ENGINEERING.md` and `docs/agents/LOOP_ENGINEERING.md` (dated 2026-07-14).
- Created `.loop/reflexion/` taxonomy, `loop-state.md`, `loop-budget.md`, `loop-verdict.md` templates.
- Added scripts: `loop-init.sh`, `gate-runner.sh`, `budget-check.sh`, `reflexion-search.sh`, `security-loop.sh`, `design-drift-check.sh`, `capacitor-sync-check.sh`.
- Updated `AGENTS.md`, `HANDOFF.md`, `KIMI_HANDOFF.md` to read `loop-state.md` first and use swarm roles.
- Added npm scripts: `loop:init`, `loop:gates`, `loop:budget`, `loop:security`, `loop:design-drift`, `loop:cap-sync`, `loop:reflexion`.
- Fixed stale `web-mvp` references in `KIMI_HANDOFF.md`; documented Kimi-specific entry point in `HANDOFF.md`.
- Gate-runner passes: TypeScript, tests (121/1), diff scan, design-token drift, secret scan.

## Blockers / external follow-ups
- Email confirmations are currently disabled on the remote Supabase project because the default mailer was timing out and blocking all sign-ups. New users now get an active session immediately.
- To re-enable confirmations later, configure a custom SMTP provider in Supabase Auth (Google Workspace: `smtp.gmail.com`, port `587`, user `hello@koinaku.com`, app password) and set `auth.email.enable_confirmations = true` in `supabase/config.toml`.

## Current session scope
Web-first MVP on branch `web-mvp`. Phases 1–5 complete. Phase 6 adaptive triggers + content done. Next session decision:
- Fix open bugs (KO-37..KO-41), or
- Continue Phase 6: Library tab, lesson expansion 9→15, recommended resources, empty states, analytics events, notification queue, final QA. Native iOS/Android track remains paused.

## Important scope change
Phase 3 was split into Phase 3A (Core Learning Loop) and Phase 3B (Paper Trading). TASKS.md and this file reflect the split.

## Note for next agent
Read `HANDOFF.md` first — it contains the latest session state and the two possible
next streams (fix open bugs KO-37..KO-41 vs. continue Phase 6). Also read
`RECURRING.md` if you're doing maintenance rather than a TASKS.md item.

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Migration 016: public read RLS for sources and lesson_sources
[x] Migration 017: public read RLS for badges
[x] Migration 018: public read RLS for levels and topics
[x] Migration 019: execute_trade RPC and paper trading fixes
[x] Migrations 020–021: content_variants and source URL fixes
[x] Migration 022: market_data daily update architecture
[x] Migration 023: trade onboarding settings
[x] Migration 024: streak check-in RPC with freeze/break logic
[x] Migration 025: Koin Points award engine
[x] Migration 026: friend invite RPCs
[x] Migration 027: weekly leaderboard RPC
[x] Migration 028: graduation check RPC
[x] Migration 029: cohort join-by-code RPC
[x] Migration 019: adaptive content variant expansion (10 examples + 11 questions per behavioral lesson)
[x] Bug tracker: Linear project "Koin Bugs" + Bug label + Google Sheets Apps Script sync documented in docs/BUG_TRACKER.md
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] Content variants expanded via Migration 016 (50 examples + 55 questions; 10 examples + 11 questions per launch lesson)
[x] Behavioral adaptive lessons added via Migrations 017–018 (4 lessons, trigger engine, recommendation UI)
[x] Phase 1b Capacitor shell complete (preserved on `web-mvp`)
[x] KO-24 Auth foundation
[x] KO-25 Onboarding flow
[x] KO-26 App shell with bottom navigation
[x] KO-27 Profile page
[x] KO-28 Dynamic lesson player from Supabase
[x] KO-29 Multi-type quiz engine with parameters and cooldown
[x] KO-30 Lesson completion gamification loop (XP, streak, mastery, badges, next-lesson CTA)
[x] Fix: robust completion error handling + secondary "Back to Learn" CTA in summary
[x] Source trust section: primary/supporting/further-reading source cards with tier, URL, review status
[x] AI assist layer: Explain simpler / Indonesian example / Quiz me again (current-lesson scoped)
[x] Phase 3A — Core Learning Loop: content variants, source verification, per-session randomization
[x] Phase 3B — Paper Trading: market data, gated trade onboarding, risk profile quiz, first-trade flow
[x] Phase 4 — Streaks, Gamification, Koin Points: streak engine, XP awards, badge triggers, Koin Points, Home dashboard
[x] Phase 5 — Social + Graduation: friend invites, leaderboards, graduation certificate, brokerage recs, progress card, cohorts
[x] Pivot: create `web-mvp` branch and push to remote
[x] Pivot: platform-aware auth storage (Preferences native / cookies web)
[x] Pivot: add PWA manifest and icons
[x] Pivot: archive native-only tests on web-mvp branch
[x] Pivot: verify build/tests on web-mvp branch
[x] Deploy web-koinaku to Vercel: https://web.koinaku.com
[x] Content prototype: /learn/inflation-101 with animated visual + quiz
[x] Learn tab lesson list with 5 topics
[x] Added money-basics-101, budgeting-101, risk-return-101
[x] Lesson content template in docs/LESSON_TEMPLATE.md
[x] Verified BI inflation source URL

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 183 (40 original + 55 launch expansion + 88 adaptive expansion)
[x] Test suite: 107 passing, 1 skipped (KO-37 auth client tests added)
[x] Source URL verification test: all source URLs return 2xx/3xx (no dead links)
[x] Adaptive trigger engine migrated and deployed
[x] npm run build passes
[x] `web-mvp` branch pushed to origin
[x] Migrations 016–029 applied to remote Supabase
[x] Vercel deployment smoke check: 200 OK
[x] KO-37 gate: `npx tsc --noEmit` clean; `npx vitest run` 107 passed / 1 skipped; diff scan clean (no localStorage/sessionStorage)
[x] KO-38 + KO-39 gate: `npx tsc --noEmit` clean; `npx vitest run` 109 passed / 1 skipped; diff scan clean
[x] KO-40 gate: `npx tsc --noEmit` clean; `npx vitest run` 112 passed / 1 skipped; diff scan clean
[x] KO-41 gate: `npx tsc --noEmit` clean; `npx vitest run` 114 passed / 1 skipped; diff scan clean
[x] Phase 6 Library tab gate: `npx tsc --noEmit` clean; `npx vitest run` 115 passed / 1 skipped; diff scan clean
[x] Phase 6 Empty states gate: `npx tsc --noEmit` clean; `npx vitest run` 118 passed / 1 skipped; diff scan clean
[x] Linear sync: KO-37..KO-41 and KO-42 moved to Done

## Gate result
[x] Gate KO-26 — passed
[x] Gate KO-27 — passed
[x] Gate web pivot — passed
[x] Gate KO-30 — passed
[x] Gate source trust section — passed
[x] Gate AI assist layer — passed
[x] Gate Home dashboard — passed
[x] Gate Phase 3A — passed
[x] Gate Phase 3B — passed
[x] Gate Phase 4 — passed
[x] Gate Phase 5 — passed
[x] Gate content variant expansion — passed
[x] Gate Phase 6 adaptive triggers — passed

## Blockers
None active.

## Environment notes
- `UpdateGoal` tool is not exposed in this agent environment. This is a known/stale limitation, not a blocker. Completion is tracked in `progress.md`, `TASKS.md`, and Linear instead.

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
- Client-side auth can stay platform-aware: Capacitor Preferences on native, cookies on web, both respecting the no-localStorage rule.
- Pivoting to web-first preserves native code on the same branch while adding PWA metadata and web-safe storage.
- Reference tables (sources, lesson_sources) need explicit SELECT policies when RLS is enabled; "public read" intent must be enforced in code.
- Static export on Vercel means public share links for runtime-generated IDs (e.g., certificate share_public_id) cannot be pre-rendered; share via native share API instead.
