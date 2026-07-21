# Security Policy

## Supported versions

Only the latest deployed version of the Koinaku web app is actively supported with security updates.

| Branch     | Supported          |
| ---------- | ------------------ |
| web-koinaku | :white_check_mark: |
| main       | :white_check_mark: |
| web-mvp    | :x:                |

## Reporting a vulnerability

If you discover a security issue, please email **hello@koinaku.com** with:

- A description of the vulnerability
- Steps to reproduce
- The impact you believe it has
- Any suggested remediation

We aim to acknowledge reports within 48 hours and will keep you informed as we investigate.

## Security architecture at a glance

- **Authentication**: Supabase Auth with email/password. Web sessions use cookie storage with `Secure` on HTTPS and `SameSite=Lax`; a server middleware refreshes sessions and redirects unauthenticated protected routes. These browser-managed auth cookies are not `HttpOnly` yet, so CSP and XSS prevention remain critical until web auth moves fully behind server-managed session cookies.
- **Authorization**: Row Level Security (RLS) policies on all tenant tables enforce that users can only access their own data.
- **Transport**: All production traffic is served over HTTPS. Cookies use `Secure` and `SameSite=Lax`.
- **Input validation**: User-facing inputs are validated with Zod before reaching Supabase or business logic.
- **Secrets**: Application secrets are never committed. They are injected via environment variables at build/runtime time.

See [docs/security.md](docs/security.md) for the full model.
