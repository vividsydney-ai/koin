# KO-SEC-002 Kimi Handoff — Security Must-Haves

## Why This Exists

The audit in `../GH-comparison/koinaku-security-check-2026-07-21.md` found that Koinaku had good foundations, but production/browser session posture did not match what a public MVP should have:

- No CSP or baseline browser security headers on live pages.
- Docs claimed `HttpOnly` auth cookies, while the web client writes Supabase session cookies via `document.cookie`.
- Supabase middleware helper existed but was not registered at the Next.js root.
- Private app routes rendered static `200` shells to anonymous users before client-side auth kicked in.
- `/.well-known/security.txt` and `/robots.txt` were missing.

## What Changed

- `next.config.ts`
  - Added global security headers:
    - `Content-Security-Policy`
    - `Referrer-Policy: strict-origin-when-cross-origin`
    - `X-Content-Type-Options: nosniff`
    - `X-Frame-Options: DENY`
    - `Permissions-Policy`
    - `Strict-Transport-Security: max-age=63072000; includeSubDomains`
  - CSP allows the app itself, Supabase REST/realtime, Fontshare fonts/styles, HTTPS images, blob/data images, web workers, and Cloudflare Turnstile.

- `proxy.ts`
  - Added root Next.js proxy for auth refresh and route gating.
  - Protected routes: `/`, `/learn`, `/trade`, `/friends`, `/library`, `/profile`, `/certificate`, `/brokerage`, `/onboarding`.
  - Public routes stay public: `/login`, `/signup`, `/forgot-password`, `/reset-password`, `/auth/callback`, `/privacy`, `/terms`, `/api`, `/native-test`.
  - Anonymous private-route requests redirect to `/login?next=<original path>`.
  - API routes are intentionally not redirected, so cron endpoints can keep returning `401` JSON.
  - Redirect responses copy refreshed Supabase cookies and response headers, so refresh no-store headers are preserved even when redirecting anonymous users.

- `lib/supabase/middleware.ts`
  - `updateSession()` now returns `{ response, user }`.
  - The proxy uses Supabase `auth.getUser()` result for server-side redirect decisions.
  - Refreshed cookies are still copied onto the response.
  - Important verifier fix: `cookieEncoding: "raw"` is set to match the existing browser cookie storage format, and Supabase SSR refresh headers are copied to the response so session-cookie responses are not cacheable.

- `lib/auth/storage.ts`
  - Browser-written auth cookies now append `Secure` when the app runs over HTTPS.
  - Local HTTP dev stays usable because `Secure` is omitted on `http://localhost`.
  - These cookies are still not `HttpOnly`; JavaScript-written cookies cannot be `HttpOnly`.

- `SECURITY.md`, `docs/security.md`, `app/privacy/page.tsx`, `app/privacy/id/page.tsx`
  - Removed stale `HttpOnly` claims.
  - Documented the actual posture: Supabase session cookies are `Secure` on HTTPS and `SameSite=Lax`, but browser-managed until web auth moves behind server-managed cookies.

- `public/.well-known/security.txt`
  - Published vulnerability contact metadata for `web.koinaku.com`.

- `public/robots.txt`
  - Published a minimal crawler policy.

## What Was Verified

- `npx tsc --noEmit` — pass
- `npm run lint` — pass, 0 errors / 20 warnings
- `npx vitest run` — pass, 63 files; 388 passed / 5 skipped
- `npm run build` — pass
- `npm run loop:gates` — pass; Lighthouse skipped because it is not installed in this environment
- Read-only verifier initially failed the middleware because Supabase SSR defaulted to `base64url` cookies and passed no-store headers that were not copied. That was fixed with `cookieEncoding: "raw"` and header forwarding. A later verifier also caught the redirect path copying cookies without headers; `proxy.ts` now forwards those headers onto redirects too.
- Diff scans:
  - No `localStorage` or `sessionStorage` added in source diffs.
  - No `is_published = true` changes.
  - No `supabase/migrations/` changes.
  - No secret-looking literals in the diff.
- Local HTTP smoke at `http://localhost:3000`:
  - `/learn` returns `307` to `/login?next=%2Flearn`.
  - `/login` returns `200` with the new security headers.
  - `/.well-known/security.txt` returns `200`.
  - `/robots.txt` returns `200`.
  - `/api/cron/market-data-update` returns `401` without cron secret and is not redirected to login.

## What This Does Not Solve Yet

These audit items still require Supabase/Vercel/admin access or new infrastructure:

- Live two-user RLS audit across all tenant tables and `SECURITY DEFINER` RPCs.
- Supabase Storage bucket listing/object-path/signed-URL policy audit.
- Supabase Auth dashboard confirmation for CAPTCHA enforcement, email caps, and abuse settings.
- Managed edge rate limits for auth, password reset, cron, friend/cohort, lesson completion, and trade routes.
- Alerting for auth failures, 401/429/5xx spikes, cron failures, and Supabase/RLS anomalies.
- Full server-managed `HttpOnly` web sessions. Current code truthfully documents JS-readable Supabase browser cookies and reduces blast radius with CSP plus `Secure`.

## Guidance For Kimi

Do not reintroduce `middleware.ts`; Next.js 16 warned that convention is deprecated, so this repo now uses `proxy.ts`.

If auth behavior changes, preserve these invariants:

- `/api/*` must not be redirected to `/login`; APIs should return API-shaped status codes.
- Public legal/auth routes must stay public.
- Private app-shell routes should redirect before rendering for anonymous users.
- Do not use `localStorage` or `sessionStorage`.
- Do not claim `HttpOnly` sessions until the auth flow is actually moved behind server-managed cookies.

Next best security task: implement a real live RLS/Storage verification suite using admin-approved Supabase credentials, then add hosted rate limits/alerts at the Vercel/Supabase layer.
