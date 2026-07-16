# Koinaku Analytics Playbook

**Stack:** Supabase-only. No Mixpanel, Amplitude, or paid analytics tools in the MVP.  
**Goal:** Measure the habit loop, catch drop-offs, and make launch decisions with data.

---

## 1. Philosophy

We instrument user actions into the `analytics_events` table and compute metrics with SQL views. This keeps costs at zero, respects RLS, and makes every query inspectable and reproducible.

**Rule:** Every event is insert-only. Never update or delete analytics rows.

---

## 2. Event taxonomy

| Event | Trigger | Properties |
|-------|---------|------------|
| `user_signed_up` | Auth signup | `method: email` |
| `onboarding_completed` | Assessment submit | `score`, `foundation_zero_required`, `starting_lesson_id` |
| `lesson_started` | Lesson player mount | `lesson_id`, `topic_id`, `lesson_type` |
| `lesson_completed` | Lesson finish | `lesson_id`, `topic_id`, `score`, `xp_earned`, `duration_seconds` |
| `quiz_answer_submitted` | Each answer | `lesson_id`, `variant_id`, `is_correct`, `question_type` |
| `trade_executed` | Buy/sell RPC | `symbol`, `type`, `quantity`, `price`, `portfolio_value_after` |
| `streak_checkin` | Daily check-in | `streak_days`, `source: manual/email/app_open` |
| `badge_earned` | Badge award | `badge_id` |
| `koin_points_earned` | KP transaction | `amount`, `reason` |
| `notification_sent` | Email/in-app sent | `channel`, `notification_type` |
| `notification_clicked` | User clicks | `channel`, `notification_type` |
| `friend_invite_accepted` | Invite flow | `invite_code` |
| `graduation_eligible` | Portfolio ≥3x | `portfolio_value`, `starting_value` |
| `broker_referral_viewed` | Graduate screen | `broker_id` |

---

## 3. SQL views

These views live in the Supabase database (migration `20260717_00036_analytics_views.sql`). Run them in the Supabase SQL Editor or via `psql`.

### 3.1 Daily Active Learning Sessions

```sql
SELECT * FROM v_daily_active_learning_sessions
WHERE date >= CURRENT_DATE - INTERVAL '30 days';
```

A session = one lesson completion OR one paper trade per user per day.

### 3.2 Activation funnel

```sql
SELECT * FROM v_activation_funnel
WHERE cohort_date >= CURRENT_DATE - INTERVAL '30 days';
```

Tracks: signed up → completed onboarding → started first lesson → completed first lesson.

### 3.3 Day-7 retention

```sql
SELECT * FROM v_retention_d7
WHERE cohort_date >= CURRENT_DATE - INTERVAL '30 days';
```

### 3.4 Day-30 retention

```sql
SELECT * FROM v_retention_d30
WHERE cohort_date >= CURRENT_DATE - INTERVAL '60 days';
```

### 3.5 Lesson completion rate

```sql
SELECT * FROM v_lesson_completion_rate
WHERE date >= CURRENT_DATE - INTERVAL '30 days';
```

### 3.6 First trade within 7 days

```sql
SELECT * FROM v_first_trade_within_7_days
WHERE signup_date >= CURRENT_DATE - INTERVAL '30 days';
```

### 3.7 Streak milestones

```sql
SELECT * FROM v_streak_milestones
WHERE date >= CURRENT_DATE - INTERVAL '30 days';
```

---

## 4. Weekly analytics routine

Every Monday, run this routine and record the numbers in `progress.md` or your tracking sheet.

### Step 1 — Pull last week's signups

```sql
SELECT DATE(created_at) AS day, COUNT(*) AS signups
FROM auth.users
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY day
ORDER BY day;
```

### Step 2 — Pull last week's DALS

```sql
SELECT date, sessions
FROM v_daily_active_learning_sessions
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY date;
```

### Step 3 — Pull last week's activation funnel

```sql
SELECT *
FROM v_activation_funnel
WHERE cohort_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY cohort_date;
```

### Step 4 — Retention for cohorts from 7 and 30 days ago

```sql
SELECT *
FROM v_retention_d7
WHERE cohort_date = CURRENT_DATE - INTERVAL '7 days';

SELECT *
FROM v_retention_d30
WHERE cohort_date = CURRENT_DATE - INTERVAL '30 days';
```

### Step 5 — Lesson completion and first trade

```sql
SELECT *
FROM v_lesson_completion_rate
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY date;

SELECT *
FROM v_first_trade_within_7_days
WHERE signup_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY signup_date;
```

---

## 5. Key formulas

| Metric | Formula |
|--------|---------|
| Activation rate | `% of signups who complete a lesson within 24h` |
| D7 retention | `% of day-0 signups with ≥1 session on day 7` |
| D30 retention | `% of day-0 signups with ≥1 session on day 30` |
| Lesson completion rate | `completed lessons / started lessons` |
| First-trade rate | `% of users who trade within 7 days of signup` |
| Streak ≥ 7 rate | `% of users with current streak ≥ 7` |

---

## 6. Kill criteria checkpoint

At **200 signups**, evaluate:

- If **D7 retention < 10%** → stop and diagnose onboarding/lesson flow.
- If **first-trade rate < 10%** → stop and diagnose paper-trading discoverability.

Record the decision and the next experiment in `progress.md`.

---

## 7. Privacy rules

- `analytics_events.properties` must contain **no PII** beyond `user_id`.
- Do not log emails, names, usernames, or free-text input.
- If a property might contain PII, hash or exclude it.

---

## 8. Extending analytics

To add a new event:

1. Add the event name and properties to this playbook.
2. Instrument the trigger in `lib/analytics/events.ts` or the relevant server action/RPC.
3. Add a test in `tests/analytics/events.test.ts`.
4. If it becomes a key metric, add a SQL view in a new migration.

To add a new view:

1. Write the view in a new migration under `supabase/migrations/`.
2. Test it locally with real-shaped data.
3. Apply with `npx supabase db push --linked --yes`.
4. Document it in this playbook.
