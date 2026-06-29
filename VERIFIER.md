# VERIFIER.md — Automated Gates for Koin
# Run after every task. No self-certification. If any gate fails, halt.

## Universal gates (always run)

### Gate 0: TypeScript compilation
- Command: `npx tsc --noEmit`
- Pass: zero errors
- Fail: halt. Do not proceed to next task. Update progress.md with tsc output.

### Gate 1: Supabase type generation
- Command: `npx supabase gen types typescript --local > src/types/supabase.ts`
- Pass: exits 0
- Fail: halt. Schema mismatch detected. Check migrations.

### Gate 2: No RULES.md violations
- Read RULES.md
- Check: no `localStorage` or `sessionStorage` in diff
- Check: no `is_published = true` without lesson_reviews
- Check: no migrations without RLS in same file
- Pass: all clean
- Fail: halt. Fix violation before proceeding.

## Phase-specific gates

### Phase 1: Schema & Migrations
- Gate 2a: TDD compliance
  - Verify: tests exist for the current vertical slice before or alongside implementation
  - Verify: test files are in /tests/ or co-located with the code they cover
  - Fail: halt. Write tests first.
- Gate 3: `npx supabase db reset` — exits 0
- Gate 4: All user-sensitive tables have RLS enabled
  - Check: `SELECT tablename FROM pg_tables WHERE tablename IN (...)` AND RLS is ON
  - Tables: profiles, user_settings, lesson_attempts, lesson_progress, streaks, streak_events, xp_events, user_badges, portfolios, holdings, trades, watchlists, koin_point_balances, koin_point_transactions, user_risk_profiles, user_lesson_recommendations, friendships, friend_invites, cohort_memberships, weekly_leaderboard_snapshots, notifications_queue, content_flags, analytics_events
- Gate 5: Seed data inserts cleanly
  - `npx supabase db reset --linked` (if available) or check local seed
- Gate 6: Schema matches SCHEMA.md exactly
  - Diff: generated schema vs canonical
  - Pass: all fields present, no extra fields without human approval

### Phase 2: Auth
- Gate 7: Auth middleware test
  - Verify: unauthenticated routes redirect to /login
  - Verify: protected routes return 401 for no-session
- Gate 8: Profile creation on signup
  - Verify: auth trigger creates profiles row
  - Verify: user_settings row created

### Phase 3: Core Learning Loop + Paper Trading
- Gate 9: Lesson completion end-to-end
  - Simulate: authenticated user → /learn → click lesson → complete quiz → XP awarded
  - Verify: lesson_attempts record created
  - Verify: lesson_progress status = 'completed'
  - Verify: xp_events record created
  - Verify: streaks.current_streak_days incremented
- Gate 10: Source trust section renders
  - Verify: every published lesson shows ≥1 source card
  - Verify: source tier badge visible
  - Verify: source URL is clickable and valid
- Gate 10a: Paper trading first trade
  - Simulate: authenticated user → /trade → buy 1 lot of BBCA
  - Verify: portfolios.cash_balance decreased by trade total
  - Verify: holdings record created with correct shares and average_cost
  - Verify: trades record created with lot_count = shares / 100
- Gate 10b: Portfolio value updates
  - Simulate: price update on held stock
  - Verify: holdings.current_price updated
  - Verify: portfolios.total_value = cash_balance + sum(holdings shares × current_price)

### Phase 4: Streaks & Gamification
- Gate 11: Streak unit tests
  - Daily completion: streak preserved
  - Miss day: streak at risk
  - Miss day + freeze: freeze consumed, streak preserved
  - Miss day + no freeze: streak broken
  - Milestone: 7-day streak triggers streak_event
- Gate 12: XP/level progression
  - Verify: xp_events sum matches level requirement
  - Verify: level up message renders
  - Verify: badge trigger works for 3-day streak, 7-day streak, first lesson
- Gate 12a: Koin Points ledger integrity
  - Verify: SUM(koin_point_transactions.amount) per user = koin_point_balances.current_balance
  - Verify: Koin Points awarded on weekly leaderboard rank, streak milestone, and graduation
- Gate 12b: First trade badge
  - Verify: first_trade badge triggers after first trades record

### Phase 5: Social
- Gate 13: Friend invite flow
  - Generate invite code → share → accept → friendship created
  - Verify: duplicate code rejects
  - Verify: self-invite rejected
- Gate 14: Leaderboard
  - Verify: weekly leaderboard renders top 10
  - Verify: user sees own rank
  - Verify: friend leaderboard vs global
- Gate 14a: Graduation detection
  - Simulate: portfolio value reaches 3x–5x starting value
  - Verify: portfolios.graduated_at is set
  - Verify: certificates record created with correct multiplier_achieved
  - Verify: brokerage_recommendations rendered for graduate
- Gate 14b: Certificate compliance
  - Verify: no certificates exist where portfolio graduation_multiplier < 3.00
  - Verify: brokerage recommendation list contains only OJK-registered apps

### Phase 6: Adaptive Lessons + Polish
- Gate 15a: Adaptive lesson triggers
  - Verify: panic sell event creates user_lesson_recommendations for loss aversion lesson
  - Verify: concentrated portfolio (>50% in one stock) creates diversification recommendation
  - Verify: N days of inactivity creates confidence/risk tolerance recommendation
  - Verify: lesson_triggers table maps at least 3 distinct trading behaviors
- Gate 15: Lighthouse mobile
  - Command: `npx lighthouse http://localhost:3000 --preset=mobile --output=json`
  - Pass: Performance ≥ 85, Accessibility ≥ 95, Best Practices ≥ 90
  - Fail: halt. Fix before proceeding.
- Gate 16: Keyboard navigation
  - Verify: all interactive elements reachable via Tab
  - Verify: focus indicator visible
- Gate 17: WCAG AA contrast
  - Verify: primary text on all surfaces meets 4.5:1
  - Verify: large text meets 3:1
  - Tool: browser DevTools or axe-core

### Phase 7: Content ops
- Gate 18: Source compliance
  - Verify: every lesson with is_published=true has ≥1 lesson_sources record linking to Tier 1
  - Verify: every lesson has a lesson_reviews record
  - Verify: approved_to_publish=true

## Verification output format

After running gates, write to `progress.md`:

