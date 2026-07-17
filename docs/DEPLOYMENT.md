# Koinaku Deployment Guide

**Branch:** `web-koinaku`  
**Production URL:** `https://koin-web-koinaku-vividsydney.vercel.app`  
**Target custom domain:** `https://web.koinaku.com` (blocked by Vercel apex-domain verification; see Section 5)  
**Vercel Project:** `web-koinaku`  
**Supabase Project:** linked via `supabase/config.toml`

---

## 1. What this doc covers

How to deploy the Koinaku web MVP to Vercel production, apply Supabase schema changes, verify the deploy, and roll back if something breaks.

---

## 2. Deploy prerequisites

- Node.js 20+ and `pnpm` installed locally.
- Access to the Vercel dashboard for the `web-koinaku` project.
- Access to the linked Supabase project (service role key).
- All required environment variables are set in Vercel (see `.env.example`).

### Required Vercel environment variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | `https://xxxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public anon key | `eyJ...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side admin key | `eyJ...` |
| `NEXT_PUBLIC_APP_URL` | Canonical production URL | `https://koin-web-koinaku-vividsydney.vercel.app` |
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

If the deploy includes new migrations under `supabase/migrations/`, apply them **before** the Vercel build:

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

### Step 5 — Deploy to Vercel

Option A — Vercel Git integration (default):

Pushing `web-koinaku` triggers a production build automatically if the project is configured to deploy that branch to production.

Option B — Manual CLI deploy:

```bash
pnpm build
vercel --prod
```

Only use manual deploy if the Git integration is disabled.

### Step 6 — Verify the production deploy

1. Open `https://web.koinaku.com/login` and confirm the page loads.
2. Check the Vercel deploy logs for build errors.
3. Confirm the production commit hash matches `git rev-parse HEAD`.

---

## 4. Cron jobs

The `web-koinaku` branch uses a serverless Next.js build (`output: "standalone"`, not static export) so `/api/cron/streak-reminders` can run.

### Vercel cron config

`vercel.json` defines the streak-reminder schedule:

```json
{
  "crons": [
    {
      "path": "/api/cron/streak-reminders",
      "schedule": "0 * * * *"
    }
  ]
}
```

This fires at **13:00 UTC** (20:00 WIB / 21:00 WITA / 22:00 WIT) every day. This is the maximum frequency allowed on the Vercel Hobby plan; upgrade to Pro if you want hourly reminders.

### Manual trigger

To test the cron endpoint locally or in production:

```bash
curl -H "Authorization: Bearer $CRON_SECRET" \
  https://koin-web-koinaku-vividsydney.vercel.app/api/cron/streak-reminders
```

The endpoint returns:

- `200 OK` with `{ sent: N, skipped: M }` if successful.
- `401 Unauthorized` if the `CRON_SECRET` header is missing or wrong.

---

## 5. Domain configuration

Production domain: `https://web.koinaku.com`

### How it is wired

1. The apex domain `koinaku.com` and subdomain `web.koinaku.com` are managed in your DNS provider.
2. In Vercel, add `web.koinaku.com` as a domain under the `web-koinaku` project.
3. Vercel provides DNS records (A + CNAME). Add those to your DNS provider.
4. Wait for DNS propagation, then confirm SSL is issued in the Vercel dashboard.

### Troubleshooting 404

If `https://web.koinaku.com` returns 404 but the Vercel deployment URL works:

- Check that the domain is attached to the **correct Vercel project** (`web-koinaku`).
- Verify DNS records match what Vercel requested. With external nameservers, Vercel requires an apex record to verify domain ownership even if you only use a subdomain.
- Recommended external-DNS setup:
  - `A koinaku.com 76.76.21.21`
  - `A web.koinaku.com 76.76.21.21`
- If you prefer a CNAME for the subdomain, use the target shown in the Vercel dashboard (often `cname.vercel-dns.com` or a project-specific target). Do not mix an apex CNAME with other records.
- Confirm the deploy succeeded for the production branch.
- Note: Vercel may front-domain-protect the raw `.vercel.app` deployment URL when a custom domain is configured, causing SSO redirects. Test via the custom domain once DNS is correct.

---

## 6. Rollback procedure

If a production deploy breaks something critical (login broken, data error, major UI crash):

1. **Do not panic-revert code.** Identify the bad commit first.
2. In Vercel dashboard, find the last known-good production deployment.
3. Click **Promote to Production** on that deployment. This is the fastest rollback and does not touch Supabase.
4. If the bad deploy included a Supabase migration that corrupted data, restore from Supabase backups or contact Supabase support. Do **not** run ad-hoc `DELETE` or `UPDATE` statements on production without a backup.
5. After rollback, create a hotfix branch from the last good commit, fix, and redeploy.

---

## 7. Smoke test checklist

After every production deploy, run this checklist before announcing the release:

- [ ] `https://koin-web-koinaku-vividsydney.vercel.app/login` loads on mobile (375px) and desktop (1280px).
- [ ] New test email can sign up and receives the Supabase confirmation email.
- [ ] Confirming email redirects to onboarding.
- [ ] Onboarding assessment submits and gates the path (Foundation 0 or main track).
- [ ] User can start the first lesson and complete it without errors.
- [ ] Home shows streak card, XP, Koin Points, and today's lesson CTA.
- [ ] Paper trading: user can place a buy order and see the holding.
- [ ] Trigger `/api/cron/streak-reminders` manually and verify an email is received.
- [ ] In-app notification center shows unread count and can be marked read.

---

## 8. Production gotchas

- **Static export is disabled.** The app now requires a Node.js runtime for `/api/cron/streak-reminders`. Do not re-enable `output: "export"` unless you also move the cron job to an Edge Function.
- **Email depends on Google Workspace.** If `hello@koinaku.com` hits a sending limit or the app password expires, all auth confirmations and streak reminders stop. Monitor bounce rates in Supabase Auth logs.
- **Cron secret must stay secret.** Never commit `CRON_SECRET` to the repo or expose it in client-side code.
- **Supabase service role key is server-only.** It must only be used in API routes or server actions, never in the browser.
