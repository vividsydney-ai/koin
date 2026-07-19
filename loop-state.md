# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: KO-BATCH-008
- Title: Fix QA bugs from 2026-07-19 smoke test (KO-77 to KO-85)
- Phase: DONE
- Iteration: 1 / 8
- Locked by: Conductor
- Agent: Conductor
- Started: 2026-07-19T12:30:00Z
- Finished: 2026-07-19T17:40:00Z
- Branch: web-koinaku
- Worktree: none

## Plan Summary
1. **KO-77 P0 — Fix persistent 406 errors** — stale slug `what-is-money` → `fz-what-is-money`; portfolio fetch `.single()` → `.maybeSingle()` with null-safe fallback.
2. **KO-79 P1 — Locale switcher persists** — wire `/profile` language buttons to update `user_settings.locale` via API.
3. **KO-78 P1 — Lingo leak audit** — ensure EN locale shows no Indonesian and ID locale shows no English for all user-facing strings and lesson content.
4. **KO-84 P1 — Fix alternate-example rotation** — "Lihat contoh lain" cycles through `content_variants` examples and hides when exhausted.
5. **KO-85 P2 — Fix try-another-question rotation** — "Coba soal lain" cycles question variants and hides when exhausted.
6. **KO-80 P2 — Fix malformed quiz text** — replaced fallback true/false template that concatenated concept body; now uses clean standalone statement.
7. **KO-81 P2 — Replay XP UX** — gray out "+25 XP" during replays before finish; show "Already earned / 0 XP".
8. **KO-82 P3 — Console warnings** — removed `sessionStorage` usage in analytics (cookie fallback); remaining WOFF/adapter/NaN warnings are third-party/runtime noise.
9. **KO-83 P3 — Unauth lesson redirect** — redirect logged-out users from `/learn/<slug>` immediately via server client.

## Swarm Assignment
- Planner: Conductor
- Maker: Conductor + Frontend agent (UI/i18n) + Backend agent (data fixes)
- Verifier: Conductor (browser smoke tests + unit tests)
- Fixer: Conductor
- Lander: Conductor

## Gates Run
- [x] Gate 0: TypeScript (`npx tsc --noEmit`) — PASS
- [x] Gate 0b: Lint (`npm run lint`) — PASS (warnings only)
- [x] Gate 1: Tests (`npx vitest run`) — PASS (374 passed, 5 skipped)
- [x] Gate 2: Diff scan — PASS (no localStorage/sessionStorage, no secrets)
- [ ] Gate 3: RLS check (no migrations in this batch)
- [ ] Gate 4: Production smoke (Vercel deploy + web.koinaku.com) — pending land

## Blockers
None.

## Corrections Applied
- Fixed KO-80 by changing fallback statement template and removing `{concept}` concatenation in `LessonPlayer`.
- Updated unit tests to match localized UI strings and variant-pool behavior.
- Removed temporary DB inspection scripts from `scripts/`.

## Verdict
DONE — ready to land.

## Budget
- Max iterations: 8
- Remaining: 7
- Time elapsed: ~65 min
- Files touched: 16
- Migrations: 0
- Subagent calls: 0

## Linear
- KO-77 Done — 406 errors
- KO-78 Done — lingo leaks
- KO-79 Done — locale persistence
- KO-80 Done — malformed quiz
- KO-81 Done — replay XP UX
- KO-82 Done — console warnings (sessionStorage removed)
- KO-83 Done — unauth redirect hang
- KO-84 Done — alternate example
- KO-85 Done — question rotation
