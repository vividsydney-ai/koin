# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
Adaptive lesson content variant expansion — Migration 019 brought all 4 behavioral adaptive lessons up to 10 example variants and 11 question variants each (loss-aversion-101, diversification-101, confidence-101, volatility-101). Combined with Migrations 016 and 017, the full launch + adaptive curriculum now has 10 examples and 11+ questions per topic, all stored in `content_variants` and sourced from real Tier 1 URLs. Tests: 106 passed, 1 skipped. Deployed to https://koin-web-mvp.vercel.app/.

## Current session scope
Web-first MVP on branch `web-mvp`. Phases 1–5 complete. Phase 6 in progress: adaptive triggers + content done, remaining Phase 6 items are Library tab, lesson expansion from 9 to 15, recommended resources, empty states, analytics events, notification queue, and final QA. Native iOS/Android track remains paused.

## Important scope change
Phase 3 was split into Phase 3A (Core Learning Loop) and Phase 3B (Paper Trading). TASKS.md and this file reflect the split.

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
[x] Deploy web-mvp to Vercel: https://koin-web-mvp.vercel.app
[x] Content prototype: /learn/inflation-101 with animated visual + quiz
[x] Learn tab lesson list with 5 topics
[x] Added money-basics-101, budgeting-101, risk-return-101
[x] Lesson content template in docs/LESSON_TEMPLATE.md
[x] Verified BI inflation source URL

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 183 (40 original + 55 launch expansion + 88 adaptive expansion)
[x] Test suite: 106 passing, 1 skipped
[x] Source URL verification test: all source URLs return 2xx/3xx (no dead links)
[x] Adaptive trigger engine migrated and deployed
[x] npm run build passes
[x] `web-mvp` branch pushed to origin
[x] Migrations 016–029 applied to remote Supabase
[x] Vercel deployment smoke check: 200 OK

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
- `UpdateGoal` tool is not exposed in this agent environment. The system expects me to call it to mark goals active/complete/blocked, but it is missing from the available tool list. I report completion in text and continue work, but the goal state stays active/paused until the human closes it or the environment exposes the tool.

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
- Client-side auth can stay platform-aware: Capacitor Preferences on native, cookies on web, both respecting the no-localStorage rule.
- Pivoting to web-first preserves native code on the same branch while adding PWA metadata and web-safe storage.
- Reference tables (sources, lesson_sources) need explicit SELECT policies when RLS is enabled; "public read" intent must be enforced in code.
- Static export on Vercel means public share links for runtime-generated IDs (e.g., certificate share_public_id) cannot be pre-rendered; share via native share API instead.
