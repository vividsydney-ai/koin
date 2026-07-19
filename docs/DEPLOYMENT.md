# Koinaku Deployment Guide

**Branch:** `web-koinaku`  
**Production URL:** `https://web.koinaku.com`  
**Deployment:** Vercel project `koin-web-koinaku`
**Supabase Project:** linked via `supabase/config.toml`

Netlify is stale historical memory for the web app. Do not use Netlify for Koinaku production deploys unless the human explicitly asks to restore the paused fallback.

---

## 1. What this doc covers

How to deploy the Koinaku web MVP to Vercel production, apply Supabase schema changes, verify the deploy, and roll back if something breaks.

---

## 2. Deploy prerequisites

- Node.js 20+ and `pnpm` installed locally.
- Access to the Vercel project `koin-web-koinaku`.
- Access to the linked Supabase project when migrations are involved.
- All required environment variables are set in Vercel.

### Required Vercel environment variables

| Variable | Purpose |
|----------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side admin key |
| `NEXT_PUBLIC_APP_URL` | Canonical production URL, `https://web.koinaku.com` |
| `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM` | Google Workspace SMTP for auth/streak reminder email |
| `CRON_SECRET` | Protects `/api/cron/*` endpoints |
| `NEXT_PUBLIC_TURNSTILE_SITE_KEY` | Optional Cloudflare Turnstile public key |

Secrets must stay server-side. Never commit `.env*`, service-role keys, SMTP passwords, or cron secrets.

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

All three must pass. If they do not, fix before deploying.

### Step 3 — Apply Supabase migrations first

If the deploy includes new migrations under `supabase/migrations/`, apply them before deploying code that depends on them:

```bash
npx supabase db push --linked --yes
npx supabase migration list
```

Use one migration per task. RLS must be included in the same migration that creates any user-sensitive table.

### Step 4 — Push the release branch

```bash
git push origin web-koinaku
```

Pushing `web-koinaku` should trigger the Vercel production deployment for `https://web.koinaku.com`.

### Step 5 — Manual Vercel deploy, if needed

Only use a manual deploy when the Vercel Git integration did not run or the human explicitly asks:

```bash
vercel --prod
```

The package shortcut is:

```bash
npm run deploy:vercel
```

### Step 6 — Verify production

1. Open `https://web.koinaku.com/login` and confirm the page loads.
2. Check Vercel deploy logs for build/runtime errors.
3. Confirm the production commit matches the intended `web-koinaku` commit.
4. Run the smoke checklist below.

---

## 4. Cron jobs

Vercel cron jobs are defined in `vercel.json`:

- `/api/cron/streak-reminders` — daily streak reminder email.
- `/api/cron/market-data-update` — weekday IDX market-data refresh.

The route handlers live in:

- `app/api/cron/streak-reminders/route.ts`
- `app/api/cron/market-data-update/route.ts`

Manual trigger:

```bash
curl -X POST -H "Authorization: Bearer $CRON_SECRET" \
  https://web.koinaku.com/api/cron/streak-reminders
```

The endpoint returns `401 Unauthorized` when `CRON_SECRET` is missing or wrong.

---

## 5. Domain configuration

Production domain: `https://web.koinaku.com`

Current app hosting is Vercel. DNS for `web.koinaku.com` points to Vercel. The apex domain `koinaku.com` may remain elsewhere for lead-gen/email, but that does not make Netlify the app deploy target.

Troubleshooting:

- Check Vercel project domains for `web.koinaku.com`.
- Verify DNS points to Vercel, usually `cname.vercel-dns.com`.
- Check the latest Vercel production deployment for `web-koinaku`.
- Confirm required Vercel env vars are present.

---

## 6. Rollback procedure

If production breaks:

1. Identify the bad deployment/commit before reverting code.
2. In Vercel, promote the last known-good deployment if rollback is urgent.
3. If the bad deploy included a Supabase migration that corrupted data, restore from Supabase backups or contact Supabase support. Do not run ad-hoc destructive SQL without a backup.
4. Create a hotfix on `web-koinaku`, run gates, push, and smoke-test production.

---

## 7. Smoke test checklist

After every production deploy:

- [ ] `https://web.koinaku.com/login` loads on mobile 375px and desktop 1280px.
- [ ] New test email can sign up and receives the Supabase confirmation email.
- [ ] Confirming email redirects to onboarding.
- [ ] Onboarding assessment submits and gates the path.
- [ ] User can start and complete the first lesson without errors.
- [ ] Home shows streak, XP, Koin Points, and today's lesson CTA.
- [ ] Paper trading allows a buy order and shows the holding.
- [ ] Streak-reminder cron endpoint rejects missing/wrong `CRON_SECRET`.
- [ ] In-app notification center shows unread count and can mark notifications read.

---

## 8. Production gotchas

- **Deployment is Vercel.** Netlify references in old notes are historical unless explicitly labeled as fallback.
- **Server runtime required.** Cron routes under `app/api/cron/*` require the Vercel/Next.js server runtime.
- **Email depends on Google Workspace.** If `hello@koinaku.com` hits limits or the app password expires, auth confirmations and streak reminders stop.
- **Cron secret must stay secret.** Never expose `CRON_SECRET` in client-side code.
- **Supabase service role key is server-only.** It must only be used in server route handlers or trusted server code.
