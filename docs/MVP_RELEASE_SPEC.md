# Koinaku Public Soft-Launch MVP Release Spec

**Version:** 1.0  
**Date:** 2026-07-16  
**Branch:** `web-koinaku`  
**Deploy Target:** `https://web.koinaku.com`  
**Linear Epic:** KO-MVP-001

---

## Goal

Ship a public soft-launch MVP that lets Indonesian Gen Z sign up, prove their financial literacy level, learn from a foundation-first curriculum, and practice trading in a paper sandbox — with streaks, XP, and source-backed lessons. All success metrics must be measurable via self-hosted Supabase analytics, and re-engagement must work via email + in-app notifications.

This spec breaks the work into loop-sized slices. Each slice has its own acceptance criteria, test plan, and Linear task.

---

## Slice 0 — Land In-Progress Curriculum Work

**What:** Commit, push, and apply migrations `031` and `032`; verify production lesson count and source URLs.  
**Why:** The 32-lesson foundation track is already built but not fully landed. Production must be clean before new work starts.  
**Linear:** KO-CURR-001 (continuation)

### Acceptance Criteria
- [ ] `npx vitest run tests/migrations/032_fix_source_urls_and_mappings.test.ts` passes.
- [ ] Full `npm run test` passes (227+ passed / 1 skipped).
- [ ] Migrations 031 + 032 committed and pushed to `origin/web-koinaku`.
- [ ] `npx supabase db push --linked --yes` applies 031 + 032 to production.
- [ ] Production query returns exactly **32** published lessons.
- [ ] `npx vitest run tests/sources/url-verification.test.ts` passes against production.

### Test Plan
```bash
npx vitest run tests/migrations/032_fix_source_urls_and_mappings.test.ts
npm run test
npx supabase db push --linked --yes
npx supabase db query --linked "SELECT COUNT(*) FROM lessons WHERE is_published = true;"
npx vitest run tests/sources/url-verification.test.ts
```

---

## Slice 1 — Foundation 0: Money Dictionary Mini-Track

**What:** Build 10–15 micro-lessons that teach pure financial terms before the main 32-lesson curriculum. Each micro-lesson is 1–2 minutes, uses matching and case-study question types, and cites Tier 1 sources.  
**Why:** User feedback says current lessons are too hard because terms are assumed. Foundation 0 fixes the onboarding ramp.  
**Linear:** KO-FOUND-001

### Proposed Foundation 0 Topics
1. What is money? (fungsi uang)
2. Inflation — why prices go up
3. Interest — what it is, simple vs. compound
4. Income vs. wealth
5. Asset vs. liability
6. Risk — what can go wrong
7. Return — what you can gain
8. Saving vs. investing
9. Emergency fund
10. Needs vs. wants
11. Debt — good vs. bad
12. Scam red flags (intro)

### Acceptance Criteria
- [ ] 12 Foundation 0 lessons exist in `lessons` table with `topic_id` = new Foundation 0 topic.
- [ ] Each lesson has ≥1 Tier 1 source link and approved review.
- [ ] Each lesson has ≥3 content variants for examples and ≥5 question variants.
- [ ] Question types include `matching` and `case_study` plus at least one of `multiple_choice` or `true_false`.
- [ ] All source URLs pass `tests/sources/url-verification.test.ts`.
- [ ] Lessons are unpublished until Slice 2 gating is ready.

### Files to Touch
- `supabase/migrations/20260717_00033_foundation_zero_topics_and_lessons.sql`
- `supabase/migrations/20260717_00034_foundation_zero_variants.sql`
- `tests/migrations/033_foundation_zero.test.ts`
- `.loop/artifacts/foundation-zero-curriculum.md`

### Test Plan
```bash
npx vitest run tests/migrations/033_foundation_zero.test.ts
npx vitest run tests/sources/url-verification.test.ts
```

---

## Slice 2 — Onboarding Assessment Gating

**What:** Wire the financial literacy assessment so it genuinely gates the learning path.  
**Why:** Current assessment records a score but every user sees the same content. Gating makes personalization real.  
**Linear:** KO-45 (continuation)

### Gating Rules
- **Score 0–4 / 12:** Start Foundation 0 from lesson 1.
- **Score 5–8 / 12:** Start Foundation 0 but skip the first 4 lessons; unlock diagnostic review for wrong-answer topics.
- **Score 9–12 / 12:** Skip Foundation 0; start main track at lesson 1.
- **Wrong answers:** Each wrong answer creates a `user_remediation_lessons` entry pointing to the relevant Foundation 0 micro-lesson.

### Acceptance Criteria
- [ ] Assessment answers are persisted with per-question scoring.
- [ ] `user_settings` stores `foundation_zero_required` (boolean) and `starting_lesson_id`.
- [ ] Home/Learn tabs respect gating: Foundation 0 users see mini-track; others see main track.
- [ ] Wrong answers generate remedial lesson recommendations.
- [ ] Existing users (assessment already taken) are grandfathered: if no gating data, default to Foundation 0 to be safe.
- [ ] Migration is idempotent.

### Files to Touch
- `app/onboarding/page.tsx` or assessment completion RPC
- `lib/lessons/path.ts` (new)
- `supabase/migrations/20260717_00035_assessment_gating.sql`
- `tests/onboarding/assessment-gating.test.ts`

### Test Plan
```bash
npx vitest run tests/onboarding/assessment-gating.test.ts
npm run test
```

---

## Slice 3 — Analytics Events + SQL Views

**What:** Instrument all key user actions into `analytics_events`, then create SQL views for the North Star and retention metrics.  
**Why:** We cannot validate the MVP without measurement. Supabase-only, no paid tools.  
**Linear:** KO-ANALYTICS-001

### Event Taxonomy

| Event | Trigger | Properties |
|-------|---------|------------|
| `user_signed_up` | Auth signup | `method: email` |
| `onboarding_completed` | Assessment submit | `score, foundation_zero_required, starting_lesson_id` |
| `lesson_started` | Lesson player mount | `lesson_id, topic_id, lesson_type` |
| `lesson_completed` | Lesson finish | `lesson_id, topic_id, score, xp_earned, duration_seconds` |
| `quiz_answer_submitted` | Each answer | `lesson_id, variant_id, is_correct, question_type` |
| `trade_executed` | Buy/sell RPC | `symbol, type, quantity, price, portfolio_value_after` |
| `streak_checkin` | Daily check-in | `streak_days, source: manual/email/app_open` |
| `badge_earned` | Badge award | `badge_id` |
| `koin_points_earned` | KP transaction | `amount, reason` |
| `notification_sent` | Email/in-app sent | `channel, notification_type` |
| `notification_clicked` | User clicks | `channel, notification_type` |
| `friend_invite_accepted` | Invite flow | `invite_code` |
| `graduation_eligible` | Portfolio ≥3x | `portfolio_value, starting_value` |
| `broker_referral_viewed` | Graduate screen | `broker_id` |

### SQL Views
- `v_daily_active_learning_sessions`
- `v_activation_funnel`
- `v_retention_d7`
- `v_retention_d30`
- `v_lesson_completion_rate`
- `v_first_trade_within_7_days`
- `v_streak_milestones`

### Acceptance Criteria
- [ ] All 14 events above are instrumented in the relevant UI/server actions/RPCs.
- [ ] Events respect RLS: users insert only their own rows.
- [ ] SQL views return correct cohort numbers.
- [ ] A `docs/ANALYTICS_PLAYBOOK.md` explains how to run the views each week.
- [ ] No PII in `properties` JSONB beyond `user_id`.

### Files to Touch
- `lib/analytics/events.ts` (new)
- `app/**/page.tsx` and server actions
- `supabase/migrations/20260717_00036_analytics_views.sql`
- `docs/ANALYTICS_PLAYBOOK.md`
- `tests/analytics/events.test.ts`

### Test Plan
```bash
npx vitest run tests/analytics/events.test.ts
npm run test
```

---

## Slice 4 — Email Notifications + In-App Notification Center

**What:** Wire email-based streak reminders and build an in-app notification center.  
**Why:** Re-engagement is required for the habit loop. Web push is deferred until native mobile restarts.  
**Linear:** KO-NOTIF-001

### Notification Types
- `streak_reminder` — email at 8 PM local time if no daily check-in
- `lesson_nudge` — in-app center if user hasn't started today's lesson
- `streak_freeze_warning` — email + in-app 4 hours before midnight
- `trade_onboarding_nudge` — in-app after user completes 3 lessons but hasn't traded

### Acceptance Criteria
- [ ] `notifications_queue` rows are created by a scheduled Edge Function or cron.
- [ ] Email delivery uses `hello@koinaku.com` SMTP config already in Supabase.
- [ ] In-app notification center accessible from top-right bell icon on Home.
- [ ] Users can mark notifications as read.
- [ ] Bounce/complaint monitoring documented.
- [ ] No notification sent more than once per day per type.

### Files to Touch
- `supabase/functions/send-notifications/index.ts` (new or update)
- `components/notifications/NotificationCenter.tsx` (new)
- `app/api/notifications/route.ts` or RPC
- `supabase/migrations/20260717_00037_notification_delivery.sql`
- `tests/notifications/notification-delivery.test.ts`

### Test Plan
```bash
npx vitest run tests/notifications/notification-delivery.test.ts
npm run test
```

---

## Slice 5 — Final QA & Accessibility

**What:** Run comprehensive QA across viewports, themes, and input methods.  
**Why:** MVP launch quality gate.  
**Linear:** KO-QA-001

### Acceptance Criteria
- [ ] `npx tsc --noEmit` clean.
- [ ] `npm run lint` 0 errors.
- [ ] `npx vitest run` passes (227+ tests).
- [ ] Lighthouse mobile score ≥85, accessibility ≥95.
- [ ] WCAG 2.1 AA: color contrast, focus indicators, alt text, ARIA labels.
- [ ] Keyboard navigation works for lesson player, quiz, trade form, and profile.
- [ ] 375px iPhone SE and 1280px desktop layouts verified.
- [ ] Dark mode has no broken contrast.

### Test Plan
```bash
npx tsc --noEmit
npm run lint
npm run test
npm run lighthouse:mobile
```

---

## Slice 6 — Handoff Docs

**What:** Complete Phase 7 docs so future agents and collaborators can onboard in <30 minutes.  
**Why:** The team is 1 human + AI agents; docs are the bus factor.  
**Linear:** KO-DOCS-001

### Acceptance Criteria
- [ ] `README.md` updated with local setup, env vars, test commands.
- [ ] `.env.example` lists all required variables.
- [ ] `docs/ARCHITECTURE.md` or `docs/ADL.md` created with key decisions.
- [ ] `docs/KNOWN_GAPS.md` lists what is intentionally not built.
- [ ] `docs/DEPLOYMENT.md` explains Vercel + Supabase deploy flow.
- [ ] `docs/CONTEXT.md` domain model created (see separate task).

---

## Release Gates

Before calling the MVP launched, all of the following must be true:

1. **Slice 0 complete:** 32 lessons published, source URLs verified.
2. **Slice 1 + 2 complete:** Foundation 0 built and gated by assessment.
3. **Slice 3 complete:** Analytics events + SQL views live.
4. **Slice 4 complete:** Email + in-app notifications wired.
5. **Slice 5 complete:** All QA gates pass.
6. **Slice 6 complete:** Handoff docs complete.
7. **Production deploy:** `https://web.koinaku.com` reflects the release branch.
8. **Legal:** Terms of Service and Privacy Policy pages live.

## Post-Launch Monitoring (First 2 Weeks)

- Daily: check `v_daily_active_learning_sessions` and sign-up count.
- Daily: monitor email bounce/complaint rates in Supabase Auth logs.
- Weekly: run full analytics playbook and update `progress.md`.
- Weekly: review user feedback and bug tracker.
- Kill-criteria checkpoint at 200 signups: D7 retention < 10% or first-trade rate < 10%.

## Out of Scope for This MVP

- 100-lesson curriculum expansion
- Koin Pro subscription and payments
- Web push notifications
- Native iOS/Android builds
- AI financial coach
- Complex admin portal
- A/B testing framework
- Real broker integrations
