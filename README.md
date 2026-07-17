# Koinaku — Financial Literacy for Indonesian Gen Z

**Branch:** `web-koinaku`  
**Production:** `https://web.koinaku.com`  
**Netlify site:** `koinaku-web-mvp` (`3e15f6a6-179d-4034-8fea-3e77dc176d24`)  
**Stack:** Next.js 16 + TypeScript + Tailwind CSS v4 + Supabase

Koinaku is a mobile-first financial literacy app that turns learning about money into a daily habit. It combines Duolingo-style micro-lessons with a paper-trading sandbox so users can practice with virtual Rupiah before risking real money.

---

## Quick start

1. Clone the repo and switch to the active branch:
   ```bash
   git checkout web-koinaku
   pnpm install
   ```

2. Copy environment variables and fill in the real values:
   ```bash
   cp .env.example .env.local
   ```

3. Run the local dev server:
   ```bash
   pnpm dev
   ```

4. Run tests:
   ```bash
   npx tsc --noEmit
   npm run lint
   npm run test
   ```

---

## Required environment variables

See `.env.example` for the full list. The app will not build or send email without:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_APP_URL`
- `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM`
- `CRON_SECRET`

---

## Key commands

| Command | Purpose |
|---------|---------|
| `pnpm dev` | Local Next.js dev server |
| `pnpm build` | Production build |
| `pnpm start` | Start production server |
| `npm run test` | Run full Vitest suite |
| `npm run lint` | Run ESLint |
| `npx tsc --noEmit` | Type check |
| `npx supabase db push` | Push pending migrations to the linked Supabase project |
| `npx supabase gen types ...` | Regenerate `types/supabase.ts` after schema changes |

---

## Branch & deploy notes

- Active development happens on `web-koinaku`.
- Production is deployed to Netlify and served at `https://web.koinaku.com`.
- Supabase migrations are applied with `npx supabase db push` before Netlify builds when the schema changed.
- The streak-reminder job is a Netlify scheduled function (`netlify/functions/streak-reminders.ts`) that runs daily at 13:00 UTC.

---

## Docs

- [`docs/CONTEXT.md`](docs/CONTEXT.md) — domain model and ubiquitous language
- [`ADL.md`](ADL.md) — architecture decision log
- [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) — Netlify + Supabase deploy flow
- [`docs/KNOWN_GAPS.md`](docs/KNOWN_GAPS.md) — what is intentionally out of scope
- [`docs/QA_REPORT.md`](docs/QA_REPORT.md) — QA gate results
- [`docs/ANALYTICS_PLAYBOOK.md`](docs/ANALYTICS_PLAYBOOK.md) — how to run MVP metrics
- [`PRD.md`](PRD.md) — public soft-launch MVP requirements
