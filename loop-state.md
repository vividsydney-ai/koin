# loop-state.md — Current Loop State
> AUTO-GENERATED. Do not edit manually unless human intervenes.

## Current Task
- ID: KO-MVP-DEPLOY-001
- Title: Migrate production hosting from Vercel to Netlify
- Phase: PLANNING
- Iteration: 1 / 6
- Agent: kimi-code (Conductor)
- Started: 2026-07-17T00:50:00+10:00

## Plan Summary
Move the Koinaku web MVP from Vercel to Netlify so `https://web.koinaku.com` can be served cleanly without Vercel apex-domain verification conflicts. The apex `koinaku.com` must remain on Netlify for the lead-gen site and Google Workspace email.

Steps:
1. Configure Netlify site for `web-koinaku` branch with Next.js build settings.
2. Copy all required environment variables from Vercel to Netlify.
3. Convert `/api/cron/streak-reminders` from Vercel cron to a Netlify scheduled function.
4. Update DNS: point `web.koinaku.com` CNAME to the Netlify site.
5. Deploy to Netlify production and run smoke tests.
6. Update docs (`README.md`, `PRD.md`, `docs/DEPLOYMENT.md`) with the new production URL.

## Gates Run
- [ ] Gate 0: npx tsc --noEmit (0 errors)
- [ ] Gate 1: npm run lint (0 errors)
- [ ] Gate 2: npm run test (227+ tests pass)
- [ ] Gate 3: Netlify build succeeds
- [ ] Gate 4: Production URL loads (200)
- [ ] Gate 5: Signup-to-lesson smoke test passes
- [ ] Gate 6: Streak-reminder email received

## Blockers
- Vercel apex-domain verification blocks `web.koinaku.com` while `koinaku.com` apex stays on Netlify.
- Vercel deployment URLs are front-domain protected and return SSO redirects.
- Need user to provide secret env var values for Netlify.

## Corrections Applied
- Removed Vercel custom domain registration to resolve front-domain protection.
- Created Netlify site `koinaku-web-mvp` linked to `web-koinaku` branch.
- Set non-secret Netlify env vars (NEXT_PUBLIC_APP_URL, SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_FROM).

## Budget
- Max iterations: 6
- Remaining: 5
- Time elapsed: ~2h total (including Vercel troubleshooting)
