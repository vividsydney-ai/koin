# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
KO-26 — App shell with bottom navigation complete.

## Last completed task
KO-27 — Profile page complete.

## Current session scope
Pivot to web-first MVP on branch `web-mvp`. Native iOS/Android track paused.

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] Phase 1b Capacitor shell complete (preserved on `web-mvp`)
[x] KO-24 Auth foundation
[x] KO-25 Onboarding flow
[x] KO-26 App shell with bottom navigation
[x] KO-27 Profile page
[x] Pivot: create `web-mvp` branch and push to remote
[x] Pivot: platform-aware auth storage (Preferences native / cookies web)
[x] Pivot: add PWA manifest and icons
[x] Pivot: archive native-only tests on web-mvp branch
[x] Pivot: verify build/tests on web-mvp branch
[x] Deploy web-mvp to Vercel: https://koin-web-mvp.vercel.app

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Test suite: 27 passing
[x] pnpm build passes
[x] `web-mvp` branch pushed to origin

## Gate result
[x] Gate KO-26 — passed
[x] Gate KO-27 — passed
[x] Gate web pivot — passed

## Blockers
(none)

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios` can change `xcode-select` to Xcode.app path, requiring license agreement before git works again.
- Client-side auth can stay platform-aware: Capacitor Preferences on native, cookies on web, both respecting the no-localStorage rule.
- Pivoting to web-first preserves native code on the same branch while adding PWA metadata and web-safe storage.
