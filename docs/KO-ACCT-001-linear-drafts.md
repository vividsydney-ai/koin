# KO-ACCT-001 Linear issue drafts

> Drafted because `LINEAR_API_KEY` is not available in this environment.
> Create these under Linear team `KO` (https://linear.app/vnsavitri/team/KO/overview).

## KO-ACCT-001-A — Sign-up accepts invalid email addresses

**Description:**
The sign-up form currently allows some malformed email addresses through. We need stricter client- and server-side validation so only valid email addresses are accepted.

**Acceptance criteria:**
- `app/signup/page.tsx` validates the email in real time and shows a clear error.
- Submit is disabled while the email is invalid.
- `lib/auth/schemas.ts` uses a strict email regex and clear error message.
- Backend `signUpWithEmail` rejects invalid emails before calling Supabase.

## KO-ACCT-001-B — Terms/Privacy links appear on every page footer

**Description:**
The app footer currently links to Terms of Service and Privacy Policy on every authenticated page. These links should only appear during sign-up agreement and inside the account section.

**Acceptance criteria:**
- Remove Terms/Privacy nav from `components/Footer.tsx`.
- Keep the legal agreement line on `app/signup/page.tsx`.
- Add `/profile/account/terms` and `/profile/account/privacy` pages for later reference.

## KO-ACCT-001-C — No in-app change/forgot password flow in account section

**Description:**
While `/forgot-password` exists, there is no change-password flow inside the app for logged-in users, and the reset flow is not visible from the account section.

**Acceptance criteria:**
- `/forgot-password` link is visible and works from `/login`.
- Create `/profile/account/password` where logged-in users can change their password.
- `/profile/account` index links to Password, Terms, and Privacy.

## KO-ACCT-001-D — Terms/Privacy acceptance is not enforced or recorded at signup

**Description:**
New users must explicitly agree to the Terms of Service and Privacy Policy when signing up, and that agreement must be persisted.

**Acceptance criteria:**
- Sign-up form has a required checkbox: "I agree to the Terms of Service and Privacy Policy".
- Submission is blocked unless the checkbox is checked.
- Acceptance is stored in `user_settings` (`terms_accepted_at`, `privacy_accepted_at`, `terms_version`, `privacy_version`).
- Existing users are grandfathered (NULL values = accepted before tracking).
