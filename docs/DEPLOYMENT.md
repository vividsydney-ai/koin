# Koinaku Deployment Guide

**Branch:** `web-koinaku`  
**Production URL:** `https://web.koinaku.com`  
**Netlify site:** `koinaku-web-mvp` (`3e15f6a6-179d-4034-8fea-3e77dc176d24`)  
**Supabase Project:** linked via `supabase/config.toml`

---

## 1. What this doc covers

How to deploy the Koinaku web MVP to Netlify production, apply Supabase schema changes, verify the deploy, and roll back if something breaks.

---

## 2. Deploy prerequisites

- Node.js 20+ and `pnpm` installed locally.
- Access to the Netlify dashboard for the `koinaku-web-mvp` site.
- Access to the linked Supabase project (service role key).
- All required environment variables are set in Netlify (see `.env.example`).

### Required Netlify environment variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | `https://xxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public anon key | `eyJ...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side admin key | `eyJ...` |
| `NEXT_PUBLIC_APP_URL` | Canonical production URL | `https://web.koinaku.com` |
| `SMTP_HOST` | Outgoing email host | `smtp.gmail.com` |
| `SMTP_PORT` | Outgoing email port | `587` |
| `SMTP_USER` | SMTP login | `hello@koinaku.com` |
| `SMTP_PASS` | Google Workspace app password | `xxxx xxxx xxxx xxxx` |
| `SMTP_FROM` | From address | `hello@koinaku.com` |
| `CRON_SECRET` | Protects `/api/cron/*` endpoints | random 32+ char string |

> **Note:** `SMTP_PASS` must be a Google Workspace **app password**, not the account password. Generate it at `https://myaccount.google.com/apppasswords` after enabling 2FA on `hello@koinaku.com`.

---

## 3. Deploy flow

### Step 1 — Pull latest

```bash
git checkout web-koinaku
git pull origin web-koinaku
```

### Step 2 — Local quality gates

Run these locally before pushing anything that touches code:

```bash
npx tsc --noEmit
npm run lint
npm run test
```

All three must pass. If they don't, fix before deploying.

### Step 3 — Apply Supabase migrations (schema changes only)

If the deploy includes new migrations under `supabase/migrations/`, apply them **before** the Netlify build:

```bash
npx supabase db push --linked --yes
```

Then verify the migration list:

```bash
npx supabase migration list
```

### Step 4 — Push the release branch

```bash
git push origin web-koinaku
```

### Step 5 — Deploy to Netlify

Option A — Netlify Git integration (default):

Pushing `web-koinaku` triggers a production build automatically if the site is configured to deploy that branch to production.

Option B — Manual CLI deploy:

```bash
npx netlify-cli@latest deploy --site 3e15f6a6-179d-4034-8fea-3e77dc176d24 --prod --build
```

Only use manual deploy if the Git integration is disabled.

### Step 6 — Verify the production deploy

1. Open `https://web.koinaku.com/login` and confirm the page loads.
2. Check the Netlify deploy logs for build errors.
3. Confirm the production commit hash matches `git rev-parse HEAD`.

---

## 4. Cron jobs

The `web-koinaku` branch uses a serverless Next.js build (`output: "standalone"`, not static export) so the Netlify scheduled function can run.

### Netlify scheduled function config

`netlify/functions/streak-reminders.ts` defines the streak-reminder schedule (`0 13 * * *`):

```ts
export const config: Config = {
  schedule: "0 13 * * *",
};
```

This fires at **13:00 UTC** (20:00 WIB / 21:00 WITA / 22:00 WIT) every day.

### Manual trigger

To test the scheduled function in production:

```bash
curl -X POST -H "Authorization: Bearer $CRON_SECRET" \
  https://web.koinaku.com/api/cron/streak-reminders
```

The endpoint returns:

- `200 OK` with `{ sent: N, skipped: M }` if successful.
- `401 Unauthorized` if the `CRON_SECRET` header is missing or wrong.

---

## 5. Domain configuration

Production domain: `https://web.koinaku.com`

### How it is wired

1. The apex domain `koinaku.com` remains on Netlify for the lead-gen site and Google Workspace email.
2. The `web.koinaku.com` subdomain is a CNAME pointing to `koinaku-web-mvp.netlify.app`.
3. Netlify issues and renews SSL for `web.koinaku.com` automatically.

### Troubleshooting 404

If `https://web.koinaku.com` returns 404 but the Netlify deploy URL works:

- Check that the custom domain is attached to the **correct Netlify site** (`koinaku-web-mvp`).
- Verify the DNS CNAME for `web.koinaku.com` points to `koinaku-web-mvp.netlify.app`.
- Confirm the deploy succeeded for the production branch.
- Use `dig web.koinaku.com CNAME +short` to verify propagation.

---

## 6. Rollback procedure

If a production deploy breaks something critical (login broken, data error, major UI crash):

1. **Do not panic-revert code.** Identify the bad commit first.
2. In the Netlify dashboard, find the last known-good production deployment.
3. Click **Publish deploy** on that deployment. This is the fastest rollback and does not touch Supabase.
4. If the bad deploy included a Supabase migration that corrupted data, restore from Supabase backups or contact Supabase support. Do **not** run ad-hoc `DELETE` or `UPDATE` statements on production without a backup.
5. After rollback, create a hotfix branch from the last good commit, fix, and redeploy.

---

## 7. Smoke test checklist

After every production deploy, run this checklist before announcing the release:

- [ ] `https://web.koinaku.com/login` loads on mobile (375px) and desktop (1280px).
- [ ] New test email can sign up and receives the Supabase confirmation email.
- [ ] Confirming email redirects to onboarding.
- [ ] Onboarding assessment submits and gates the path (Foundation 0 or main track).
- [ ] User can start the first lesson and complete it without errors.
- [ ] Home shows streak card, XP, Koin Points, and today's lesson CTA.
- [ ] Paper trading: user can place a buy order and see the holding.
- [ ] Trigger `https://web.koinaku.com/api/cron/streak-reminders` manually and verify an email is received.
- [ ] In-app notification center shows unread count and can be marked read.

---

## 8. Production gotchas

- **Static export is disabled.** The app now requires a Node.js runtime for `/api/cron/streak-reminders`. Do not re-enable `output: "export"` unless you also move the cron job to an Edge Function.
- **Email depends on Google Workspace.** If `hello@koinaku.com` hits a sending limit or the app password expires, all auth confirmations and streak reminders stop. Monitor bounce rates in Supabase Auth logs.
- **Cron secret must stay secret.** Never commit `CRON_SECRET` to the repo or expose it in client-side code.
- **Supabase service role key is server-only.** It must only be used in API routes or server actions, never in the browser.
