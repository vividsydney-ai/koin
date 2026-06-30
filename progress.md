# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
Phase 1b — Capacitor Mobile Shell complete. KO-7 (Phase 2) sliced into KO-24–KO-27.

## Current session scope
KO-24 — Auth foundation: login, signup, and protected routes

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] Phase 1b Capacitor shell complete
[x] KO-7 Phase 2 sliced
[ ] KO-24 Auth foundation in progress

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Test suite: 17 passing
[x] pnpm build passes
[x] pnpm cap:sync passes

## Gate result
[x] Gate KO-20, KO-23 — passed
[ ] Gate KO-24 — not started

## Blockers
(none)

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
