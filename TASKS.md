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

## PHASE 1b — Capacitor Mobile Shell (paused on web-mvp branch)
- [x] Install Capacitor core + iOS + Android packages
- [x] Configure capacitor.config.ts with app ID, name, webDir
- [x] Add cap:sync, cap:open:ios, cap:open:android scripts
- [x] Generate iOS and Android native projects
- [ ] Test build on iOS simulator and Android emulator
- [x] Add native share sheet plugin stub
- [x] Add push notification plugin architecture (stub delivery)

## PHASE 2 — Auth + Shell
- [x] Supabase Auth: email + Google OAuth
- [x] Onboarding flow: name, age range, financial goal, risk tolerance intro, notification preference
- [x] App shell: bottom nav (Home / Learn / Trade / Friends / Library / Profile)
- [x] Protected route middleware
- [x] Profile page: avatar, streak, XP, level, Koin Points, badges, portfolio snapshot

## PHASE 3 — Core Learning Loop + Paper Trading
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
  - matching (declared, UI pending)
  - slider (declared, UI pending)
  - swipe_yes_no (declared, UI pending)
  - case_study (declared, UI pending)
- [x] Shuffled answer order and parameterized numeric questions
- [x] Question cooldown: deprioritize recently-answered variants for 7 days
- [ ] Lesson completion: XP award, mastery update, streak check
- [ ] Source trust section: show source cards with tier badge, URL, review status
- [ ] AI assist layer: "Explain simpler" / "Indonesian example" / "Quiz me again" — scoped to current lesson only
- [ ] Paper trading sandbox: portfolio, holdings, buy/sell, lot-based orders
- [ ] Market data seed and daily price update architecture
- [ ] First-trade badge and onboarding trade flow
- [ ] Risk profile starter quiz

## PHASE 4 — Streaks, Gamification, Koin Points
- [ ] Streak engine: daily check-in logic, freeze logic, streak lost state
- [ ] XP system: award on lesson complete, quiz bonus, streak milestone, first trade
- [ ] Level progression: unlock message per level
- [ ] Badge award: trigger checks after lesson_complete, streak events, trade events, social actions
- [ ] Koin Points engine: award on weekly leaderboard rank, streak milestones, graduation, lesson completion
- [ ] Koin Points balance visible on Home and Profile
- [ ] Home dashboard: streak card, today's lesson/cta, portfolio snapshot, Koin Points, leaderboard snippet, recent badge

## PHASE 5 — Social + Graduation
- [ ] Friend invite: generate code, share link, accept flow
- [ ] Friends list + weekly leaderboard (top 10 by XP and by Koin Points this week)
- [ ] Graduation check: detect 3x–5x portfolio value, issue certificate
- [ ] Certificate screen with shareable card
- [ ] Brokerage recommendation screen (Bibit, Ajaib, Stockbit, IPOT, Bareksa)
- [ ] Shareable progress card (OG image or canvas-rendered PNG)
- [ ] Cohort support: join by invite code (for school/group use later)

## PHASE 6 — Adaptive Lessons + Library
- [ ] Lesson triggers based on trading behavior:
  - Panic sell → loss aversion lesson
  - Concentrated holdings → diversification lesson
  - No trade for N days → confidence / risk tolerance lesson
  - Portfolio drawdown → volatility / emotional control lesson
- [ ] User lesson recommendations table and UI
- [ ] Expand from 5 to 15 lessons
- [ ] Library tab: browse sources by topic/tier/type/language
- [ ] Recommended resources: books, videos per lesson
- [ ] All empty states designed (no friends, no lessons started, no holdings, streak lost, graduated, all done)
- [ ] Analytics events: instrument all 16 events from spec plus trade and graduation events
- [ ] Notification queue: stub delivery, architecture ready
- [ ] Final QA: 375px mobile, 1280px desktop, dark mode, keyboard nav, WCAG AA

## PHASE 7 — Handoff
- [ ] README with local setup steps
- [ ] .env.example with all required variables
- [ ] Architecture decision log (ADL.md)
- [ ] Known gaps document
- [ ] Vercel + Supabase deployment guide
