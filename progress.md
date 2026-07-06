# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

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
Updated auth pages on `web-koinaku`. Removed Google sign-in/sign-up buttons from `app/login/page.tsx` and `app/signup/page.tsx` per human direction. Converted auth copy to English and improved the email-verification UX with a spam-folder reminder and clearer resend messaging. The email confirmation flow code (KO-37) was already in place; if emails are still not arriving, the fix is in Supabase Auth settings (see blockers note).

Gate output:
- `npx tsc --noEmit`: clean
- `npx vitest run`: 118 passed / 1 skipped
- Diff scan: clean

Gate output:
- `npx tsc --noEmit`: clean
- `npx vitest run`: 118 passed / 1 skipped
- Diff scan: clean
- Vercel production deploy: Ready

## Blockers / external follow-ups
- Confirmation email deliverability is controlled by Supabase Auth, not app code. Ensure:
  1. Supabase Auth → URL Configuration → Redirect URLs includes `https://koin-web-koinaku.vercel.app/auth/callback`.
  2. Supabase Auth → Email Templates → "Confirm signup" is enabled and the template uses `{{ .ConfirmationURL }}`.
  3. For reliable delivery, configure a custom SMTP provider (SendGrid/Resend/etc.) in Supabase Auth → Providers → SMTP instead of using Supabase's default mailer.

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
[x] Deploy web-mvp to Vercel: https://koin-web-mvp.vercel.app
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
