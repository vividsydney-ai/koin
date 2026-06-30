# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
KO-26 — App shell with bottom navigation complete.

## Current session scope
Pivot to web-first MVP on branch `web-mvp`. Native iOS/Android track paused.

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] Phase 1b Capacitor shell complete (archived on `main`)
[x] KO-24 Auth foundation
[x] KO-25 Onboarding flow
[x] KO-26 App shell with bottom navigation
[ ] KO-27 Profile page in progress
[ ] Pivot: remove native targets
[ ] Pivot: replace Capacitor Preferences with cookie storage
[ ] Pivot: add PWA manifest
[ ] Pivot: verify build/tests on web-mvp branch

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Test suite: 27 passing (pre-pivot)
[x] pnpm build passes (pre-pivot)
[x] pnpm cap:sync passes (pre-pivot; now removed)

## Gate result
[x] Gate KO-26 — passed
[ ] Gate KO-27 — not started
[ ] Gate web pivot — pending build + test verification

## Blockers
(none)

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
- Client-side auth in Capacitor requires Capacitor Preferences (or similar) to avoid localStorage.
- For web-only delivery, cookie storage replaces Capacitor Preferences and respects the no-localStorage rule.
