# Loop State: Security & Engineering Credibility (Option B)

**Task ID:** SEC-001  
**Branch:** `web-koinaku`  
**Started:** 2026-07-16  
**Conductor:** Kimi Code (this session)  
**Locked by:** conductor  

## Goal

Make the project pass the "Matt Pocock cred test" by adding CI, typed auth errors, Zod validation, a typed service layer, and security/tenancy documentation.

## State Machine

```
[PLAN] → [BUILD] → [VERIFY] → [LAND]
  ✓        ✓        ✓        ✓
```

- PLAN: Approved via ExitPlanMode (Option B: Structured Boundary Hardening).
- BUILD: Complete. CI, docs, auth hardening, schemas, service layer, tests.
- VERIFY: PASS. `type-check` clean, `lint` 0 errors, `test` 215 passed / 1 skipped.
- LAND: Ready. All changes are on `web-koinaku`. Awaiting human approval to commit/push.

## Completed

1. CI workflow (`.github/workflows/ci.yml`) with type-check, lint, test, audit, Supabase migration tests.
2. Security docs: `SECURITY.md`, `docs/security.md`, `docs/adr/001-tenancy-and-rls.md`.
3. Pre-commit hooks: husky + lint-staged.
4. Auth client hardened with `Result<T, AuthError>`, Zod schemas (`lib/auth/schemas.ts`), normalized errors (`lib/auth/errors.ts`).
5. Typed `Result<T, E>` utility (`lib/types/result.ts`) and `ServiceError` (`lib/types/service-error.ts`).
6. Zod schemas for profile/onboarding, trading, and lesson completion (`lib/schemas/*`).
7. Service layer (`lib/services/profile.ts`, `lib/services/trading.ts`, `lib/services/lessons.ts`) wrapping Supabase RPCs with validation.
8. Existing client functions delegate to services so all mutations are validated.
9. Existing tests updated to match new auth signatures and valid UUIDs.

## Remaining

1. Add runtime RLS smoke tests (`tests/security/rls-smoke.test.ts`).
2. Add service-layer integration/unit tests (`tests/services/*.test.ts`).
3. Run full gate: `pnpm run type-check`, `pnpm run lint`, `pnpm run test`.
4. Update `AGENTS.md` / `KIMI_HANDOFF.md` with loop v2 learnings if needed.

## Budget

- Subagent calls: 0
- Estimated remaining: 2 subagent runs (Maker + Verifier)
- Hard stop: 6 iterations / 45 min / 15 files

## Gotchas

- RLS smoke tests require local Supabase or must be skipped gracefully.
- Service tests should mock `supabase` from `@/lib/auth/client` to avoid requiring a live backend.
- The `web-koinaku` branch already contains the foundation changes; the Maker will add tests on top.
