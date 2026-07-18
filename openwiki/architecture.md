# Architecture and operating model

## Runtime map

Koinaku is a Next.js 16 application written in strict TypeScript, with Tailwind CSS v4. It runs as a Netlify-hosted web application backed by Supabase.

- **UI:** App Router routes in `app/`, shared components in `components/`. Authenticated routes are grouped under `app/(app)/`; lesson pages live under `app/learn/[slug]/`.
- **Domain layer:** `lib/` holds feature clients, validated service boundaries, Zod schemas, Supabase helpers, i18n, and design-token references.
- **Persistence and privileged logic:** Supabase tables, RLS policies, database functions, and seed evolution are in `supabase/migrations/`. Treat the latest relevant migration as implementation truth.
- **Scheduled/server operations:** Netlify functions live in `netlify/functions/`; redirects from `/api/cron/*` are defined in `netlify.toml`.
- **Verification:** Vitest suites live in `tests/`; `package.json` defines type-check, lint, test, build, database, and Loop scripts.

The production target is `https://web.koinaku.com` on the `web-koinaku` branch. `docs/DEPLOYMENT.md` describes the current deployment and rollback process.

## Product boundaries

The core user journey is: authenticate → onboard → learn a reviewed lesson → build streak/XP/Koin Points → practice concepts with a virtual-IDR portfolio. Content and trading are educational; they must not become real-money execution or personalized investment advice.

The highest-risk boundaries are:

1. **Lesson publishing:** source quality and review approval protect the product's trust claim.
2. **Supabase ownership/security:** RLS controls user data, while selected `SECURITY DEFINER` functions enforce server-side reward and completion behavior.
3. **Authentication/session:** Supabase Auth supplies the user identity used by RLS and RPC guards.
4. **Rewarding and replay:** lesson completion changes attempts, progress, XP, points, streaks, mastery, and badges; see [Learning, trust, and account workflows](learning-and-trust.md).

## Data and security conventions

`RULES.md` is the controlling engineering policy. In particular:

- Keep RLS in the same migration that creates a user-sensitive table; ownership policies normally use `auth.uid() = user_id`.
- Public learning catalog data is limited to published lessons and supporting source/topic/badge/level records.
- Use Zod for form and external inputs, then put backend calls behind `lib/services/` where practical.
- Do not add `localStorage` or `sessionStorage`.
- Do not inspect or commit secrets. `.env.example` documents variable names; live `.env*` files are outside documentation scope.

`SCHEMA.md` documents the planned/conceptual model and seed order. It is valuable orientation, but its header claim of exactness is stale for later migrations. When behavior matters, inspect the migration and its associated tests.

## Local development and checks

Follow `README.md` for setup: install dependencies, configure local environment values from `.env.example`, and run `pnpm dev`.

The standard code checks are:

```bash
pnpm type-check
pnpm lint
pnpm test
pnpm build
```

For schema work, use the documented Supabase flow in `docs/DEPLOYMENT.md`; migrations need a deliberate production application step before a Netlify deploy relying on them. Regenerate Supabase types only when the task calls for it (`pnpm supabase:gen-types`). Do not present a test-count baseline as durable: counts have changed across recent runs.

## Design and implementation references

- `DESIGN.md` is the canonical design-system brief for the current UI lift. Live CSS tokens remain in `app/globals.css`; `lib/design-tokens.ts` is the agent-facing reference. Run `pnpm loop:design-drift` after token changes.
- `docs/CONTEXT.md` is the domain vocabulary reference. It still includes planned/partial areas, so cross-check task status in `TASKS.md` and implementation before claiming a workflow is shipped.
- `ADL.md` records architectural decisions, but older deployment references should not supersede the active Netlify config.

## Change guide

| If changing… | Start with | Also inspect / verify |
| --- | --- | --- |
| A route or component | target under `app/` / `components/` | matching tests, accessibility/touch-target rules, i18n wrappers where UI copy changes |
| Domain behavior | relevant `lib/<domain>/` and `lib/services/` | Zod schema, migration/RPC contract, focused tests |
| Database/RLS/RPC | latest related `supabase/migrations/` | one-migration task limit, RLS/auth grants, migration tests, production-application plan |
| Deployment or scheduled function | `netlify.toml`, `netlify/functions/`, `docs/DEPLOYMENT.md` | server-only secret handling and production smoke/rollback requirements |
| UI tokens | `DESIGN.md`, `app/globals.css`, `lib/design-tokens.ts` | `pnpm loop:design-drift` |
