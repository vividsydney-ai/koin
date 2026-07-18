# Learning, trust, and account workflows

## Publishing is a trust boundary

A lesson is a short learning unit with a concept, Indonesian-context example, quiz, and source-trust section. The product requirement is stronger than a UI flag: a published lesson needs a reviewed Tier 1 Indonesian source—prefer OJK, BI, or IDX—and an approved `lesson_reviews` record. Source URLs must be real and verified. `RULES.md` is authoritative; see `docs/CONTEXT.md` for vocabulary and `SCHEMA.md` for the broader model.

Do not write financial claims or lesson content without a cited, reviewed source. Paper-trading examples must clearly remain simulated and use realistic IDR context.

## Lesson completion and replay contract

The player orchestrator is `app/learn/[slug]/LessonPlayer.tsx`; quiz rendering is `components/lesson/QuizEngine.tsx`. The client gathers lesson status, active variants, recent attempt IDs, source cards, and user context before rendering a playable lesson.

### First completion

The final submission reaches `complete_lesson` through `lib/services/lessons.ts`. The authoritative implementation is migration `supabase/migrations/20260718000051_min_time_first_completion_only.sql`:

- The RPC is `SECURITY DEFINER`, fixes `search_path` to `public`, and requires `auth.uid()` to equal the supplied user ID.
- Only a published lesson can complete.
- A first completion requires at least 30 seconds of client-reported elapsed time.
- It writes a `lesson_attempts` row and creates/updates `lesson_progress`.
- Lesson XP is ledger-checked once per user and lesson; the quiz bonus is awarded once on the first correct attempt.
- Lesson Koin Points and topic mastery are first-completion only; streak milestones are at most daily; badge writes are conflict-safe.

The client sends answer records as an array, for example `[{ "variant_id": "…", "correct": true }]`. Migration `20260718000049_fix_answers_json_shape.sql` normalized old object-shaped rows and constrains stored `answers_json` to `NULL` or an array. The service preserves arrays and turns any other shape into `[]`; `lib/lessons/client.ts` also tolerates legacy malformed reads so a stale record cannot block player loading.

### Replay

Completed lessons remain playable for practice. Replays create attempts and refresh progress metadata, but rewards remain idempotent: the player shows that no new XP is earned. The 30-second minimum applies **only to a first completion**, so a legitimate fast replay is accepted. Recent question variants are avoided when possible and per-load entropy prevents a same-day replay from deterministically choosing the same question; exhausted pools fall back to available active variants.

Wrong quiz responses reveal the correct answer across the implemented flows. A quiz must complete before the player advances.

### Tests and change risks

Relevant coverage includes:

- `tests/lessons/completion.test.ts` and `tests/services/lessons.test.ts` — completion payload/result mapping and answer-array normalization.
- `tests/lessons/recent-attempts.test.ts` — malformed historical answer shapes.
- `tests/lessons/quiz-reveal.test.tsx` and `tests/lessons/QuizEngine.test.tsx` — answer feedback and quiz behavior.
- `tests/migrations/048_abuse_hardening.test.ts` — static checks for the original reward/RPC hardening.
- `scripts/smoke/replay-ux.mjs` — production-oriented replay smoke coverage.

When changing this workflow, inspect migrations 048, 049, and 051 together. The database currently relies on existence checks rather than an explicit unique ledger constraint for every XP source; concurrent completion requests are a risk worth evaluating before broadening reward behavior. Score, quiz correctness, answer contents, and elapsed time originate at the client, so server-side validation needs explicit product/security design rather than an accidental assumption.

## UI locale preference

The active UI locale lives in `user_settings.locale`, introduced by migration `20260718000050_add_locale_to_user_settings.sql`. Supported values are only `en` and `id`, with an English default and a database check constraint.

`lib/i18n/LocaleProvider.tsx` wraps the authenticated application shell and the standalone lesson route. It:

1. defaults to English;
2. reads the authenticated user's `user_settings.locale` when available;
3. updates UI state immediately and upserts the preference by `user_id`;
4. falls back to English for anonymous users, missing/bad rows, reads that fail, or components outside the provider.

Dictionaries live in `lib/i18n/dictionaries.ts`; the profile settings control is in `app/(app)/profile/page.tsx`. The legacy `profiles.preferred_language` field is not the active UI-preference contract and is not synchronized by this provider. Translation coverage is intentionally partial: navigation and lesson-player chrome are localized, while much authored lesson content and some labels remain source-record or literal copy. Missing keys render their key rather than failing.

Check `tests/i18n/locale.test.tsx` after changing dictionary parity, defaults, loading, fallback, or persistence.

## Signup CAPTCHA and sessions

Signup in `app/signup/page.tsx` supports Cloudflare Turnstile when `NEXT_PUBLIC_TURNSTILE_SITE_KEY` is configured. With a key, the form requires a challenge token and passes it to `signUpWithEmail` in `lib/auth/client.ts`; tokens are reset after failed signup because they are single-use. Without the public site key, the widget is omitted and signup preserves its pre-CAPTCHA behavior.

The client widget alone does not enforce protection. Production activation also requires the matching secret and CAPTCHA enablement in Supabase Auth configuration. Keep the secret server-side and never place it in client configuration or documentation. The signup page currently remains English-only.

`tests/signup/turnstile.test.tsx` covers widget omission/rendering, submit gating, token forwarding, and the no-key fallback. Authentication uses Supabase identity for the RLS/RPC paths above; follow the repository's no-browser-storage rule when changing sessions.
