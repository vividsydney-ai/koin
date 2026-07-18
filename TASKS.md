# TASKS.md — Koin Build Tasks (v2)
# Loop reads this every session. Finds first [ ]. Completes it. Marks [x]. Stops.
# Never work outside your current task boundary.
# MVP is rebuilt around paper trading as the core retention mechanic.

## PHASE 1 — Foundation
- [x] Project scaffold: Next.js App Router, TypeScript, Tailwind, Supabase client
- [x] design-tokens.ts: all color/spacing/radius/font variables
- [x] Migration 001: core identity tables (profiles, user_settings) + RLS
- [x] Migration 002: topics, levels, badges tables + seed data
- [x] Migration 003: content tables (lessons, lesson_versions, sources,
      lesson_sources, lesson_media, recommended_resources) + RLS
- [x] Migration 004: lesson_reviews table + RLS
- [x] Migration 005: learning activity tables (lesson_attempts, lesson_progress,
      user_mastery, daily_checkins) + RLS
- [x] Migration 006: streaks + streak_events tables + RLS
- [x] Migration 007: gamification tables (xp_events, user_badges) + RLS
- [x] Migration 008: paper-trading tables (market_data, portfolios, holdings,
      trades, watchlists) + RLS
- [x] Migration 009: Koin Points tables (koin_point_balances,
      koin_point_transactions) + RLS
- [x] Migration 010: graduation tables (certificates, brokerage_recommendations,
      user_risk_profiles) + RLS
- [x] Migration 011: social tables (friendships, friend_invites, cohorts,
      cohort_memberships, weekly_leaderboard_snapshots) + RLS
- [x] Migration 012: adaptive learning tables (lesson_triggers,
      user_lesson_recommendations) + RLS
- [x] Migration 013: notifications_queue + content_flags tables + RLS
- [x] Migration 014: content_variants table + RLS
- [x] Verify: run supabase db reset and confirm zero errors
- [x] Seed 001: topics (5 launch topics matching v2 curriculum)
- [x] Seed 002: levels (10 levels with XP thresholds)
- [x] Seed 003: badges (10 MVP badges including first trade and graduation)
- [x] Seed 004: sources (32 source records — OJK, BI, IDX, Global, Media)
- [x] Seed 005: 5 launch lessons (money basics, inflation, budgeting, risk/return, IDX basics)
- [x] Seed 006: lesson_sources (junction records linking each lesson to ≥1 Tier 1 source)
- [x] Seed 007: lesson_reviews (review records — 5 lessons pre-approved for dev testing)
- [x] Seed 008: market_data (seed prices for 5–10 IDX stocks)
- [x] Seed 009: brokerage_recommendations (Bibit, Ajaib, Stockbit, IPOT, Bareksa)
- [x] Seed 010: dev test data (2 test users, sample progress, streaks, portfolios, trades)
- [x] Seed 011: content_variants (3–5 examples and 10–20 questions per launch lesson)
- [x] Migration 016: content_variants expansion — 10 examples + 11 questions per launch lesson

## PHASE 1b — Capacitor Mobile Shell (PAUSED — native track)
> Do not resume native iOS/Android work unless the human explicitly restarts it. `web-mvp` is the web-first shipping branch.
- [x] Install Capacitor core + iOS + Android packages
- [x] Configure capacitor.config.ts with app ID, name, webDir
- [x] Add cap:sync, cap:open:ios, cap:open:android scripts
- [x] Generate iOS and Android native projects
- [~] Test build on iOS simulator and Android emulator (paused — native app track on hold)
- [x] Add native share sheet plugin stub
- [x] Add push notification plugin architecture (stub delivery)

## PHASE 2 — Auth + Shell
- [x] Supabase Auth: email + Google OAuth
- [x] Onboarding flow: name, age range, financial goal, risk tolerance intro, notification preference
- [x] App shell: bottom nav (Home / Learn / Trade / Friends / Library / Profile)
- [x] Protected route middleware
- [x] Profile page: avatar, streak, XP, level, Koin Points, badges, portfolio snapshot

## PHASE 3A — Core Learning Loop (DONE)
- [x] Learn tab: node-based lesson path with locked/unlocked/complete states
- [x] Lesson player: title → concept card → Indonesian example → quiz → source trust section → completion
- [x] Content variant engine: randomly select example and questions per user/session from content_variants pool
- [x] Per-user random seed for consistent but non-copyable sessions
- [x] Quiz engine supporting multiple types:
  - multiple_choice
  - true_false
  - fill_blank
  - word_bank
  - ordering
  - matching ✅
  - case_study ✅
  - slider (declared, UI pending)
  - swipe_yes_no (declared, UI pending)
- [x] 10+ variants per implemented question type across launch lessons
- [x] 3+ example variants per launch lesson
- [x] Shuffled answer order and parameterized numeric questions
- [x] Question cooldown: deprioritize recently-answered variants for 7 days
- [x] Lesson completion: XP award, mastery update, streak check
- [x] Source trust section: show source cards with tier badge, URL, review status
- [x] Source URL verification test: all cited source URLs reachable (2xx/3xx/403), no dead/made-up links
- [x] AI assist layer: "Explain simpler" / "Indonesian example" / "Quiz me again" — scoped to current lesson only

## PHASE 3B — Paper Trading (DONE)
- [x] Paper trading sandbox: portfolio, holdings, buy/sell, lot-based orders
- [x] Market data seed and daily price update architecture
- [x] First-trade badge and onboarding trade flow
- [x] Risk profile starter quiz

## PHASE 4 — Streaks, Gamification, Koin Points (DONE)
- [x] Streak engine: daily check-in logic, freeze logic, streak lost state
- [x] XP system: award on lesson complete, quiz bonus, streak milestone, first trade
- [x] Level progression: unlock message per level
- [x] Badge award: trigger checks after lesson_complete, streak events, trade events
- [x] Koin Points engine: award on streak milestones and lesson completion
- [x] Koin Points balance visible on Home and Profile
- [x] Home dashboard: streak card, today's lesson/cta, portfolio snapshot, Koin Points, leaderboard snippet, recent badge

## PHASE 5 — Social + Graduation (DONE)
- [x] Friend invite: generate code, share link, accept flow
- [x] Friends list + weekly leaderboard (top 10 by XP and by Koin Points this week)
- [x] Graduation check: detect 3x–5x portfolio value, issue certificate
- [x] Certificate screen with shareable card
- [x] Brokerage recommendation screen (Bibit, Ajaib, Stockbit, IPOT, Bareksa)
- [x] Shareable progress card (canvas-rendered PNG)
- [x] Cohort support: join by invite code (for school/group use later)

## PHASE 6 — MVP Soft-Launch Slices

### Slice 0 — Land KO-CURR-001 Curriculum v2
- [x] Curriculum overhaul: foundation-first 32-lesson free track (KO-CURR-001)
- [x] Content audit and cleanup: remove low-quality, repeated, and duplicate variants (Linear KO-44)
- [~] Commit + push migrations 031 + 032 to `origin/web-koinaku`
- [~] Apply migrations 031 + 032 to production Supabase
- [~] Verify 32 published lessons and all source URLs reachable

### Slice 1 — Foundation 0: Money Dictionary Mini-Track
- [ ] Create Foundation 0 topic and 12 micro-lessons (KO-FOUND-001)
- [ ] Add Tier 1 sources and approved reviews for each Foundation 0 lesson
- [ ] Write 3+ example variants and 5+ question variants per Foundation 0 lesson
- [ ] Use matching + case_study question types for term-heavy lessons
- [ ] Run source URL verification test before publishing

### Slice 2 — Onboarding Assessment Gating (KO-45 continuation)
- [ ] Persist per-question assessment answers
- [ ] Add `foundation_zero_required` and `starting_lesson_id` to `user_settings`
- [ ] Gate Home/Learn tabs based on assessment result
- [ ] Generate remedial micro-lesson recommendations for wrong answers
- [ ] Grandfather existing users: default to Foundation 0 if no gating data
- [ ] Add tests for assessment gating logic

### Slice 3 — Analytics Events + SQL Views (KO-ANALYTICS-001)
- [ ] Create `lib/analytics/events.ts` with typed event helpers
- [ ] Instrument 14 events: signup, onboarding, lesson start/complete, quiz, trade, streak, badge, KP, notification, friend, graduation, broker referral
- [ ] Create SQL views: DAU, activation funnel, D7/D30 retention, lesson completion, first trade, streak milestones
- [ ] Write `docs/ANALYTICS_PLAYBOOK.md`
- [ ] Add tests for event insertion and view correctness

### Slice 4 — Email Notifications + In-App Center (KO-NOTIF-001)
- [ ] Wire `notifications_queue` creation via scheduled Edge Function/cron
- [ ] Send email streak reminders via `hello@koinaku.com` SMTP
- [ ] Build in-app notification center UI (bell icon + list + mark-read)
- [ ] Add notification types: streak reminder, lesson nudge, streak freeze warning, trade onboarding nudge
- [ ] Document bounce/complaint monitoring
- [ ] Add notification delivery tests

### Slice 5 — Final QA (KO-QA-001)
- [ ] `npx tsc --noEmit` clean
- [ ] `npm run lint` 0 errors
- [ ] `npm run test` passes (227+ tests)
- [ ] Lighthouse mobile ≥85, accessibility ≥95
- [ ] WCAG AA: contrast, focus, alt text, ARIA labels
- [ ] Keyboard nav for lesson player, quiz, trade form, profile
- [ ] 375px iPhone SE + 1280px desktop layouts
- [ ] Dark mode contrast check

### Slice 6 — Handoff Docs (KO-DOCS-001)
- [ ] Update `README.md` with setup, env, test commands
- [ ] Ensure `.env.example` lists all required variables
- [ ] Create `docs/ARCHITECTURE.md` / ADL with key decisions
- [ ] Create `docs/KNOWN_GAPS.md`
- [ ] Create `docs/DEPLOYMENT.md` for Vercel + Supabase
- [ ] Create `docs/CONTEXT.md` domain model

### Phase 6 backlog (post-MVP)
- [x] Lesson triggers based on trading behavior:
  - Panic sell → loss aversion lesson
  - Concentrated holdings → diversification lesson
  - No trade for N days → confidence / risk tolerance lesson
  - Portfolio drawdown → volatility / emotional control lesson
- [x] User lesson recommendations table and UI
- [x] Library tab: browse sources by topic/tier/type/language
- [ ] Recommended resources: books, videos per lesson
- [x] All empty states designed (no friends, no lessons started, no holdings, streak lost, graduated, all done)

## Open bugs from bug tracker (next-session decision)
> See `HANDOFF.md` and `docs/BUG_TRACKER.md` for full context. These are synced from the Google Sheet and live in Linear project "Koin Bugs".
- [x] KO-37 P0 — Sign-up confirmation email is not sent after registration
- [x] KO-38 P1 — Home page hero text overlaps on iPhone SE screen
- [x] KO-39 P1 — Bottom navigation does not highlight active page on mobile
- [x] KO-40 P2 — Paper trading page takes 4+ seconds to load on 3G connection
- [x] KO-41 P2 — Profile page is missing 'Edit Profile' button
- [x] KO-ABUSE-001 — RPC abuse hardening: idempotent XP/KP in complete_lesson, 30s min-time, award_koin_points + check_in_streak made internal-only, friend-add daily cap (migration 048, prod smoke-verified)
- [x] KO-CAPTCHA-001 — Turnstile captcha on signup with graceful degradation (client shipped; activation pending Cloudflare site key + Supabase captcha toggle)

## PHASE 7 — Handoff
- [ ] README with local setup steps
- [ ] .env.example with all required variables
- [ ] Architecture decision log (ADL.md)
- [ ] Known gaps document
- [ ] Vercel + Supabase deployment guide
