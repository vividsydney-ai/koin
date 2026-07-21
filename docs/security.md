# Koinaku Security Architecture

## Threat model scope

Koinaku handles user profiles, financial learning progress, simulated trading data, and gamification state. The primary risks are:

1. **Horizontal privilege escalation**: User A reading or mutating User B's data.
2. **Authentication bypass**: Session hijacking, weak password flows, or missing email verification.
3. **Input abuse**: Malformed lesson answers, trading payloads, or onboarding data corrupting state.
4. **Dependency supply-chain**: Vulnerable npm packages reaching production.
5. **Observability gaps**: Inability to detect abuse or investigate incidents.

## Tenancy and data isolation

Each authenticated user gets exactly one row in `profiles` and one row in `user_settings`, created by the `handle_new_user()` trigger on `auth.users`. All tenant tables have RLS enabled and policies keyed to `auth.uid()`.

### Key RLS policies

| Table | Operation | Policy |
| ----- | --------- | ------ |
| `profiles` | SELECT/UPDATE | `auth.uid() = id` |
| `user_settings` | SELECT/UPDATE | `auth.uid() = user_id` |
| `lesson_progress` | SELECT/INSERT/UPDATE | `auth.uid() = user_id` |
| `paper_trades` | SELECT/INSERT/UPDATE | `auth.uid() = user_id` |
| `content_variants` | SELECT | public read (no auth required) |

> All new tenant tables must enable RLS and add a policy before being considered "shipped".

## Authentication

- Supabase Auth manages identity, password hashing, and session tokens.
- The web client uses cookie storage for Supabase sessions; `localStorage` and `sessionStorage` are not used for auth sessions.
- Browser-written web auth cookies are marked `Secure` on HTTPS and `SameSite=Lax`, but are not `HttpOnly` until the web auth flow is moved fully behind server-managed session cookies.
- Root Next.js middleware refreshes Supabase sessions and redirects unauthenticated requests away from protected app routes before the app shell renders.
- Email confirmation is required before a user can sign in.
- Auth errors are normalized into a typed `AuthError` union so the UI never exposes raw Supabase internals.

## Input validation

All user-facing inputs pass through Zod schemas:

- `auth`: email, password, display name
- `onboarding`: age range, financial goals, risk profile
- `profile`: display name, avatar URL
- `trading`: trade type, symbol, amount

Server-side mutations (Server Actions or Supabase RPCs) re-validate inputs before persisting.

## Secrets and environment

Required environment variables:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` (server-side only, never exposed to client)
- `NEXT_PUBLIC_APP_URL`
- `SMTP_*` or Supabase-managed email provider credentials

Never commit `.env.local` or service-role keys.

## Browser and disclosure hardening

Production responses set a baseline browser security header policy:

- `Content-Security-Policy` with `frame-ancestors 'none'`
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` disabling unused browser capabilities
- `Strict-Transport-Security: max-age=63072000; includeSubDomains`

The live site publishes `/.well-known/security.txt` so vulnerability reporters can find the supported contact path.

## Remaining operational checks

Some security checks require Supabase or hosting-platform admin access and must be verified during release operations:

- Live two-user RLS checks across all tenant tables and `SECURITY DEFINER` RPCs.
- Supabase Storage bucket listing, object-path, and signed URL policies.
- Supabase Auth CAPTCHA enforcement, email caps, and abuse protection.
- Managed edge rate limits and alerts for login, signup, password reset, resend verification, cron, friend/cohort, lesson completion, and trade execution paths.

## CI security checks

The GitHub Actions workflow runs:

- `pnpm audit --prod --audit-level=high`
- `pnpm run type-check`
- `pnpm run lint`
- `pnpm run test`
- Supabase migration tests
- RLS smoke tests against a local Supabase instance

## Dependency policy

- Pin major versions in `package.json`.
- Use `pnpm install --frozen-lockfile` in CI.
- Review `pnpm audit` output before merging.

## Incident response checklist

1. Rotate any exposed secret immediately.
2. Inspect `auth.audit_log_entries` and application audit tables.
3. Re-run `supabase db reset` in a local copy and confirm RLS policies still block cross-user access.
4. Patch, test, and deploy via the normal PR flow.
