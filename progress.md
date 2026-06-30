# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
KO-25 — Onboarding flow complete. /onboarding page saves profile and settings, useAuth redirects appropriately.

## Current session scope
KO-26 — App shell with bottom navigation

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] Phase 1b Capacitor shell complete
[x] KO-24 Auth foundation
[x] KO-25 Onboarding flow
[ ] KO-26 App shell with bottom navigation in progress

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Test suite: 25 passing
[x] pnpm build passes
[x] pnpm cap:sync passes

## Gate result
[x] Gate KO-25 — passed
[ ] Gate KO-26 — not started

## Blockers
(none)

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
- Client-side auth in Capacitor requires Capacitor Preferences (or similar) to avoid localStorage.
