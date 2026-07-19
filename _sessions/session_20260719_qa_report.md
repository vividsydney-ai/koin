# Koinaku QA Report — Browser Smoke Test

**Date:** 2026-07-19  
**URL tested:** https://web.koinaku.com  
**Branch:** web-koinaku  
**Test user:** `qa_smoke_1784427127389@koinaku.test` (created via Supabase admin, auto-confirmed)  
**Browser:** gstack headless Chromium  

---

## Executive Summary

Smoke-tested the full authenticated and unauthenticated flow. Core onboarding, lesson completion, XP awarding, chapter-based learn path, friends invite/accept, cohort creation, and library sources are functional. However, several user-reported issues are still live: persistent Supabase 406 errors from stale lesson slugs, mixed English/Indonesian copy across the app, the locale switcher not persisting, and the "Lihat contoh lain" / alternate-example button not working.

---

## Test Environment

- **App:** Koinaku web app on Vercel (`web-koinaku` → `web.koinaku.com`)
- **Auth method:** Service-role created test user + session cookie injection
- **Starting locale:** `en` (`user_settings.locale = 'en`)
- **Indonesian locale test:** Manually updated `user_settings.locale = 'id'`

---

## What Passed

| Flow | Result | Evidence |
|------|--------|----------|
| Public `/login` loads | ✅ | Form + Turnstile render |
| Public `/signup` loads | ✅ | Full name, email, password, confirm password, show/hide toggles, disabled submit until valid |
| Onboarding (new user) | ✅ | Welcome → name/age → 5-question literacy check → up to 3 goals → reminder opt-in → ready screen |
| Lesson completion (first time) | ✅ | XP awarded (+35 incl. +10 quiz bonus), streak 1d, "First Lesson" badge earned, `complete_lesson` RPC 200 |
| Chapter-based learn path | ✅ | Money Basics / Protect Yourself / Grow Your Money / Investing in Indonesia / Money Life Skills |
| Replay lesson (no XP) | ✅ | Info banner shown; final screen shows "Practice complete / No new XP" |
| Friends invite card | ✅ | QR code, share, scan QR, copy invite link, deep link `/friends/accept?user=<id>` |
| Cohort creation | ✅ | Free user created "QA Test Cohort", invite code `D80D276F`, creator auto-joined |
| Library sources | ✅ | 42 sources listed; "Read more" expands to show "What this source covers" + "Why it matters to you" blurbs |
| Paper trading gate | ✅ | Locked until 3 lessons completed (0/3) |

---

## Known Bugs and Errors

### P0 — Persistent 406 errors on every authenticated page

**Symptom:** Console repeatedly logs:
```
Failed to load resource: the server responded with a status of 406 ()
getLessonBySlug error: Cannot coerce the result to a single JSON object
```

**Root cause:** Two stale/misconfigured Supabase queries return 406:
1. `GET /rest/v1/lessons?select=...&slug=eq.what-is-money` — the slug in the DB is `fz-what-is-money`; something is still querying the old slug (likely the home-page "Start today's lesson" card or a recommendation component).
2. `GET /rest/v1/portfolios?select=cash_balance,total_value,starting_cash&user_id=eq.<id>` — returns 406 because the user has no portfolio and the client calls `.single()` (or equivalent) on an empty result.

**Impact:** Clutters console, triggers error telemetry, and indicates a component is failing to load expected data on every page.

**Fix:** Update the stale slug reference to `fz-what-is-money`, and change portfolio fetch to `.maybeSingle()` with a null-safe fallback.

---

### P1 — Mixed English/Indonesian copy (lingo leaks)

**Symptom:** Content does not fully switch when locale changes.

With `locale = 'en'`:
- `/learn` shows Indonesian copy: "Kamu perlu memperkuat dasar", "Berdasarkan hasil asesmen..."
- `/friends` shows "No friends yet" (English) but also "Kamu" instead of "You" in leaderboard.

With `locale = 'id'`:
- Home page still in English: "Good to see you", "Streak", "Start today's lesson", "What Is Inflation?", "Just getting started with money basics", etc.
- `/learn` chapter titles in English: "Money Basics", "Protect Yourself", "Grow Your Money", etc.
- Lesson header: "Chapter 1 · Lesson 1 of 16" (English).
- Lesson titles include "(Foundation 0)" (English).
- Lesson concept body sometimes renders English even in `id` locale (e.g. "Money is a tool that makes trade, saving, and planning possible." appeared inside the Indonesian example card).

**Fix:** Audit all dictionary usage. Ensure every user-facing string is fetched from `lib/i18n/dictionaries.ts` and that lesson content selects `title_id`, `summary_id`, `concept_body_id`, etc. when locale is `id`. Remove hardcoded Indonesian strings from English flows.

---

### P1 — Locale switcher in `/profile` does not persist

**Symptom:** Tapping "Bahasa Indonesia" updates the UI immediately, but after reload the page is back to English and `user_settings.locale` is still `'en'`.

**Fix:** The switcher is only updating React context/local state; it needs to call the profile update API and write `locale` to `user_settings`.

---

### P1 — "Lihat contoh lain" / alternate example button does not work

**Symptom:** In an Indonesian lesson, clicking "Lihat contoh lain" skips past the alternate example and jumps straight to the quiz ("Cek cepat").

**Fix:** The example-rotation state is likely advancing past the available examples or directly to the quiz step. Bound the rotation to the count of `example` variants.

---

### P2 — "Coba soal lain" / try another question shows the same question

**Symptom:** After answering a quiz question, clicking "Coba soal lain" renders the identical question again.

**Fix:** Question rotation is not advancing the variant index or the pool only contains one active question variant.

---

### P2 — Quiz question text is malformed

**Symptom:** True/false question reads:
> "...Third, it is a unit of account: it gives everything a price tag so you can compare values quickly is important for managing money well."

Two independent clauses are concatenated.

**Fix:** Review the question generator/template for this lesson; separate the concept recap from the actual true/false statement.

---

### P2 — Replay intermediate completion screen still shows green "+25 XP"

**Symptom:** Before tapping "Finish lesson" on a replay, the card shows "Lesson complete +25 XP" in green. The final screen correctly says "No new XP — you already earned the XP for this lesson.", but the intermediate state is misleading.

**Fix:** Gray out the XP pill and label it "Already earned" or "0 XP" during replays.

---

### P3 — Console warnings on every page load

```
[warning] No available adapters.
[warning] OTS parsing error: Size of decompressed WOFF 2.0 is less than compressed size
[error] %c%d font-size:0;color:transparent NaN
```

**Fix:**
- "No available adapters" usually comes from `@supabase/ssr` when no storage adapter is provided in the current environment; verify middleware/client setup.
- WOFF error suggests a corrupted/malformed font file in `fontshare` or local assets.
- `font-size:0;color:transparent NaN` indicates a CSS-in-JS value is being computed as `NaN`.

---

### P3 — Unauthenticated `/learn/<slug>` hangs before redirect

**Symptom:** Visiting `/learn/fz-what-is-money` while logged out shows "Loading lesson…" for a few seconds before finally redirecting to `/login`.

**Fix:** Redirect unauthenticated users immediately instead of waiting for the lesson data fetch to fail.

---

## Screenshots Captured

| File | Description |
|------|-------------|
| `/tmp/koin_home.png` | Login page (root redirects unauthenticated users) |
| `/tmp/koin_signup.png` | Signup form |
| `/tmp/koin_onboarding_1.png` | Onboarding welcome (Indonesian) |
| `/tmp/koin_onboarding_2_filled.png` | Name + age range step |
| `/tmp/koin_onboarding_3.png` | Literacy assessment question |
| `/tmp/koin_onboarding_final.png` | Onboarding complete, goals summary |
| `/tmp/koin_home_auth2.png` | Authenticated home |
| `/tmp/koin_lesson_1b.png` | Lesson 1 loaded (English) |
| `/tmp/koin_lesson_quiz2.png` | Quiz question (malformed text) |
| `/tmp/koin_lesson_complete2.png` | First completion (+35 XP, badge) |
| `/tmp/koin_lesson_replay.png` | Replay info banner |
| `/tmp/koin_lesson_replay_done.png` | Replay final screen (no new XP) |
| `/tmp/koin_learn.png` | Learn path with chapters |
| `/tmp/koin_profile.png` | Profile + locale switcher (English) |
| `/tmp/koin_profile_id.png` | Profile in Indonesian (temporary) |
| `/tmp/koin_friends.png` | Friends invite + cohorts (English) |
| `/tmp/koin_cohort_result.png` | Cohort created successfully |
| `/tmp/koin_accept_invite.png` | Accept friend invite page |
| `/tmp/koin_library.png` | Library source list |
| `/tmp/koin_source_detail.png` | Source synopsis expanded |
| `/tmp/koin_trade.png` | Trade locked until 3 lessons |
| `/tmp/koin_learn_id_real2.png` | Learn path in `id` locale (still English leaks) |
| `/tmp/koin_lesson_id.png` | Lesson in `id` locale (content Indonesian, header English) |
| `/tmp/koin_lesson_id_concept.png` | Concept card with English body leak |
| `/tmp/koin_home_id.png` | Home in `id` locale (mostly English) |
| `/tmp/koin_friends_id.png` | Friends in `id` locale (mixed) |

---

## Recommendations

1. **Fix the 406s first** — they are noisy, affect every page, and hide the real health of the app.
2. **Run a full i18n audit** — every hardcoded string must come from the dictionary; lesson content must use `*_id` columns when locale is `id`.
3. **Persist locale** — wire the profile language switcher to the `user_settings` update endpoint.
4. **Fix variant rotation** — both alternate examples and alternate questions should cycle through available `content_variants` and stop/hide the button when exhausted.
5. **Clean up console warnings** — fix the Supabase adapter warning, investigate the WOFF font, and trace the `NaN` CSS value.
6. **Add QA assertions** — add tests that verify: no English strings in `id` locale, no Indonesian strings in `en` locale, locale persistence, and variant rotation.
