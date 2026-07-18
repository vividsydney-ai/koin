# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: KO-VERCEL-001
- Title: Migrate Koinaku web app from Netlify back to Vercel with web.koinaku.com
- Phase: LANDING
- Iteration: 1 / 6
- Locked by: Conductor
- Agent: kimi-code
- Started: 2026-07-19T08:00:00+10:00
- Branch: web-koinaku
- Worktree: none

## Plan Summary
<!-- Planner writes this. Maker follows it. Verifier checks against it. -->

1. Audit current state:
   - Vercel project `koin-web-koinaku` exists (prj_oqFaxQqs7Pp22j8PiXJ5NzzGUn4f) but Framework Preset = Other and Output Directory = public/.
   - Repo `vercel.json` has `"framework": null` and no cron config.
   - Netlify DNS controls koinaku.com apex; web.koinaku.com currently points to Netlify (404 due to credit block / stale out/).
   - Next.js app is serverless (no output: export) with API routes at app/api/cron/*.

2. Update repo config for Vercel:
   - Rewrite `vercel.json` to use Next.js framework preset and add cron schedules.
   - Remove `netlify.toml` static-export directives or archive if marketing site no longer uses this repo.
   - Ensure `next.config.ts` remains serverless.

3. Configure Vercel project:
   - Set framework preset to Next.js via CLI (`vercel project inspect` then update if CLI supports it, otherwise use dashboard).
   - Add/update env vars from `.env.local`.
   - Add custom domain `web.koinaku.com` to project.

4. Update Netlify DNS:
   - Add CNAME record for `web` host pointing to Vercel project domain (`cname.vercel-dns.com` or project-specific target).
   - Remove any conflicting A/CNAME records for `web.koinaku.com`.
   - Keep apex `koinaku.com` and Google Workspace MX/SPF/DKIM records untouched.

5. Deploy and verify:
   - Push `web-koinaku` branch; trigger Vercel deploy.
   - Confirm web.koinaku.com/login loads.
   - Confirm login with captcha works.
   - Confirm cron endpoints return 401 without CRON_SECRET (smoke test).

## Swarm Assignment
- Planner: Conductor (kimi-code)
- Maker: kimi-code
- Verifier: to be delegated
- Fixer: to be delegated if gates fail
- Lander: kimi-code

## Gates Run
- [x] Gate 0: TypeScript (npx tsc --noEmit) — PASS
- [x] Gate 1: Tests (npx vitest run) — PASS (370 passed, 5 skipped)
- [x] Gate 2: Diff scan (no localStorage/sessionStorage) — PASS
- [ ] Gate 3: RLS check (if migration touched) — N/A (no migration)
- [ ] Gate 4: Lighthouse mobile >=85 / accessibility >=95 — deferred until deploy
- [ ] Gate 5: Design-token drift check — N/A (no token changes)
- [x] Gate 6: Secret scan — PASS
- [x] Gate 7: Build (pnpm build) — PASS
- [ ] Gate 8: web.koinaku.com smoke test — pending deploy

## Blockers
- Vercel project currently misconfigured (Framework Preset = Other, Output Directory = public).
- Netlify DNS may have stale/conflicting records for web.koinaku.com.
- Need to ensure env vars are synced to Vercel.

## Corrections Applied
<!-- Each failed iteration: what failed, root cause, fix. -->

## Verdict
<!-- Verifier appends PASS/FAIL/NEEDS_INFO here. -->

## Budget
- Max iterations: 6
- Remaining: 6
- Time elapsed: 0 min
- Files touched: 0 / 15
- Migrations: 0 / 1
- Subagent calls: 0
