# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
KO-20 — Capacitor core configuration complete. Capacitor installed, configured, build passes, cap sync passes.

## Current session scope
KO-21 — iOS simulator tracer

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] KO-20 Capacitor core configuration
[ ] KO-21 iOS simulator tracer in progress
[ ] KO-22 Android emulator tracer
[ ] KO-23 Native plugin stubs

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Capacitor config tests pass (4/4)
[x] pnpm build passes
[x] pnpm cap:sync passes

## Gate result
[x] Gate 2a (TDD compliance) — tests exist
[x] Gate 3 (schema applied)
[x] Gate 4 (RLS enabled)
[x] Gate 5 (seed data inserts cleanly)
[x] Gate 6 (schema matches SCHEMA.md)
[x] Gate KO-20 (Capacitor core config) — passed

## Blockers
(none)

## Lessons for RULES.md (agent proposes, human approves)
- Remote Supabase Management API can execute seed SQL when CLI push times out.
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
