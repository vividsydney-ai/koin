# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: KO-46
- Title: Fix signup confirmation emails and improve signup form UX
- Phase: LANDING
- Iteration: 1 / 6
- Locked by: lander
- Agent: kimi (Conductor)
- Started: 2026-07-14T07:00:00Z
- Branch: web-koinaku
- Worktree: /Users/vividm4/Documents/Projects/Side-Gigs/Koin/koin-ko-46

## Plan Summary
<!-- Planner writes this. Maker follows it. Verifier checks against it. -->

**Goal:** Re-enable reliable signup confirmation emails and modernize the signup form UX.

**Validated plan:**

1. **Google OAuth — remove dead code; buttons stay removed.**
   - `app/signup/page.tsx` and `app/login/page.tsx` already have no Google OAuth buttons (removed in session 2026-07-06).
   - `lib/auth/client.ts` still exports unused `signInWithGoogle()` and `tests/auth/client.test.ts` still tests it.
   - **Decision:** Remove the dead `signInWithGoogle` function and its test. Do not add Google OAuth UI back. No `supabase/config.toml` OAuth provider changes are required because `[auth.external.google]` is not enabled.

2. **Supabase Auth SMTP / confirmations — enable with Google Workspace.**
   - In `supabase/config.toml`:
     - Set `[auth.email] enable_confirmations = true`.
     - Uncomment and configure `[auth.email.smtp]` exactly as:
       ```toml
       [auth.email.smtp]
       enabled = true
       host = "smtp.gmail.com"
       port = 587
       user = "hello@koinaku.com"
       pass = "env(SUPABASE_AUTH_EMAIL_SMTP_PASS)"
       admin_email = "hello@koinaku.com"
       sender_name = "Koinaku"
       ```
   - **Local dev caveat:** The Supabase CLI ignores `[auth.email.smtp]` locally and routes auth emails to Mailpit at `http://localhost:54324`. The SMTP block only takes effect on the remote project after `supabase config push`.
   - **Remote credential handling:** The password referenced by `env(SUPABASE_AUTH_EMAIL_SMTP_PASS)` must be available when running `npx supabase config push --yes` because the CLI resolves `env()` locally and uploads the resolved config to the linked project. Set the actual value in a gitignored local `.env` or `.env.local` file before pushing. Alternatively, set the password via Supabase Dashboard → Authentication → Emails → SMTP Settings, but ensure the local env var is populated before any `config push` so it is not overwritten with an empty value.
   - **Google Workspace requirements:** The account must have 2FA enabled, and the SMTP password must be a Google app password (not the account password). `smtp.gmail.com` port 587 is supported; port 465 also works. See [Supabase Google SMTP troubleshooting](https://supabase.com/docs/guides/troubleshooting/using-google-smtp-with-supabase-custom-smtp-ZZzU4Y).

3. **Signup form UX — `app/signup/page.tsx`.**
   - Add `fullName` text field (required).
   - Add `confirmPassword` field.
   - Add show/hide password toggle for both password fields using accessible buttons with `aria-label`.
   - Validate that `password === confirmPassword` and show an inline error if not.
   - Keep `minLength={6}` validation.
   - Pass `{ display_name: fullName }` as `metadata` to `signUpWithEmail`.

4. **Auth client — `lib/auth/client.ts`.**
   - `signUpWithEmail` already accepts `metadata?: object` and forwards it in `options.data`. No signature change needed.
   - Remove `signInWithGoogle` (dead code).

5. **Profile trigger — `handle_new_user`.**
   - Confirmed in `supabase/migrations/20260629053446_create_core_identity_tables.sql:66`:
     ```sql
     INSERT INTO public.profiles (id, display_name, preferred_language)
     VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email), 'id');
     ```
   - Passing `display_name` in `raw_user_meta_data` populates `profiles.display_name`. No migration needed.

6. **Tests.**
   - `tests/auth/client.test.ts`:
     - Remove the `signInWithGoogle` test.
     - Update the `signUpWithEmail` metadata test to pass `{ display_name: "Budi" }` and assert it appears in `options.data`.
   - `tests/app/signup/page.test.tsx` (new):
     - Render the signup page.
     - Test that password mismatch shows an error and prevents `signUpWithEmail` from being called.
     - Test that the show/hide toggle changes the password input `type`.
     - Test that a valid submission calls `signUpWithEmail` with `display_name` metadata.

7. **Verify + Land.**
   - Run `npm run loop:gates`.
   - Ensure `SUPABASE_AUTH_EMAIL_SMTP_PASS` is set locally with the Google Workspace app password.
   - Run `npx supabase config push --yes` to apply config to the linked project.
   - Deploy to Vercel and smoke-test signup on `https://web.koinaku.com`.

**Open questions resolved:**
- Google OAuth: remove dead client code/test; buttons stay removed.
- Email template: use Supabase default for MVP (customization out of scope).

**Environment variables to add to `.env.example`:**
```bash
# Google Workspace SMTP app password for Supabase Auth emails
# Generate at https://myaccount.google.com/apppasswords after enabling 2FA
SUPABASE_AUTH_EMAIL_SMTP_PASS=
```

**Swarm plan:**
- **Planner** (explore): validate SMTP approach, confirm Google Workspace settings, check remote Supabase auth config. ✅
- **Maker (Auth config)** (coder): update `supabase/config.toml`, `.env.example`, remove `signInWithGoogle` dead code/test.
- **Maker (Signup UI)** (coder): update `app/signup/page.tsx`, add `tests/app/signup/page.test.tsx`, update `tests/auth/client.test.ts`.
- **Verifier** (explore): read-only review, run gates, write `loop-verdict.md`.
- **Lander** (conductor): merge, deploy, update metadata.

## Swarm Assignment
- Planner: kimi-explore
- Maker (Auth config): kimi-coder
- Maker (Signup UI): kimi-coder
- Verifier: kimi-explore (distinct instance)
- Fixer: kimi-coder
- Lander: kimi (Conductor)

## Gates Run
- [ ] Gate 0: TypeScript (npx tsc --noEmit)
- [ ] Gate 1: Tests (npx vitest run)
- [ ] Gate 2: Diff scan (no localStorage/sessionStorage)
- [ ] Gate 3: RLS check (if migration touched)
- [ ] Gate 4: Lighthouse mobile >=85 / accessibility >=95
- [ ] Gate 5: Design-token drift check
- [ ] Gate 6: Secret scan

## Blockers
- SMTP password missing: `SUPABASE_AUTH_EMAIL_SMTP_PASS` is not set in `.env.local`. Remote `supabase config push` cannot be completed without it. The user must provide the Google Workspace app password for `hello@koinaku.com` or set SMTP directly in the Supabase dashboard. Code changes will land; remote auth config push is pending.

## Corrections Applied
<!-- Each failed iteration: what failed, root cause, fix. -->

## Verdict
<!-- Verifier appends PASS/FAIL/NEEDS_INFO here. -->

## Budget
- Max iterations: 6
- Remaining: 6
- Time elapsed: 0 min
- Files touched: 0 / 15
- Migrations: 0 / 0
- Subagent calls: 0
