# Koinaku OpenWiki

Koinaku is a mobile-first, web-first financial-literacy product for Indonesian Gen Z. It pairs short, source-backed lessons with a **paper-trading** sandbox using virtual IDR; it does not support real-money trading or stock recommendations.

This wiki is generated repository memory. It helps agents orient themselves, but it does not override the human-authored [instruction brief](INSTRUCTIONS.md) or repository policy. Resolve conflicts in this order: current human instruction → `RULES.md` → `AGENTS.md` / `CLAUDE.md` / `KIMI_HANDOFF.md` → `docs/agents/LOOP_ENGINEERING.md` → `TASKS.md` → this wiki.

## Start here

- [Architecture and operating model](architecture.md) — runtime boundaries, source-of-truth hierarchy, data/security model, and local checks.
- [Learning, trust, and account workflows](learning-and-trust.md) — publishing guardrails, lesson completion/replay contract, locale preference, and optional signup CAPTCHA.
- [Delivery workflow](delivery-workflow.md) — Loop Engineering v2, verification, change boundaries, and current delivery priorities.

## Repository shape

| Area | Purpose |
| --- | --- |
| `app/`, `components/` | Next.js App Router pages and user interface. The authenticated shell exposes Home, Learn, Trade, Friends, Library, and Profile. |
| `lib/` | Domain clients, services, schemas, Supabase access, and design/i18n support. |
| `supabase/migrations/` | Applied database/RPC changes; use these for exact current implementation contracts. |
| `tests/` | Vitest coverage organized by domain, service, migration, and UI behavior. |
| `docs/`, `SCHEMA.md`, `ADL.md` | Human-maintained product, domain, deployment, schema, and decision context. |
| `.agents/`, `.loop/`, `TASKS.md`, `progress.md` | Loop Engineering workflow, active work tracking, role prompts, and delivery history. |

## Non-negotiable product constraints

- Published lessons require reviewed Tier 1 Indonesian sources—prefer OJK, BI, or IDX—and verified source URLs.
- Paper trading is simulated: no deposits, withdrawals, brokerage integration, or treatment of Koin Points as real money.
- Do not give specific investment recommendations; teach frameworks and risk concepts instead.
- User-sensitive data needs RLS; do not add browser `localStorage` or `sessionStorage`.
- The native iOS/Android assets are retained but paused. Keep work web-first until a human explicitly restarts native development.

## Current documentation caveats

- `SCHEMA.md` is the intended conceptual schema but does not yet describe every later migration (for example, `user_settings.locale` and replay hardening). Check the relevant migration for exact behavior.
- Deployment references should use the current Netlify configuration (`netlify.toml`, `docs/DEPLOYMENT.md`); older Vercel references are historical.
- Generated pages were initialized from the repository state at `81243cedb44043f69593b66321f27014aef0549c`. Inspect the working tree and recent commits before relying on this wiki for an in-progress task.

## Backlog

- **Paper-trading execution and market-data operations** — `lib/trading/`, `lib/market-data/`, `netlify/functions/market-data-update.ts`; deferred to keep this first pass focused on the recent lesson/security/account changes.
- **Notifications, analytics, social, and graduation workflows** — `lib/notifications/`, `lib/analytics/`, `lib/friends/`, `lib/graduation/`; substantial domains not changed by the recent commits and not yet documented here.
