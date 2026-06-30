# progress.md — Live session state (v2)
# Loop reads and writes this. Human can also read to understand where we are.
# v2: MVP reshaped around paper trading. Original v1 loop files archived in /_archived.

## Last completed task
Generated iOS and Android native projects. Both `ios/` and `android/` directories are committed.

## Current session scope
KO-21 — iOS simulator tracer (projects generated, simulator build blocked)

## Maker status
[x] Migration 001 complete
[x] Migrations 002–014 complete
[x] Seed data complete
[x] Content variants seeded (40 variants)
[x] KO-20 Capacitor core configuration
[x] iOS project generated
[x] Android project generated
[ ] KO-21 iOS Simulator build — blocked by environment
[ ] KO-22 Android Emulator build — blocked by environment
[ ] KO-23 Native plugin stubs

## Checker status
[x] All reference tables verified in remote Supabase
[x] content_variants count: 40
[x] Capacitor config tests pass (6/6)
[x] pnpm build passes
[x] pnpm cap:sync passes
[x] iOS/Android project files generated

## Gate result
[x] Gate KO-20 (Capacitor core config) — passed
[ ] Gate KO-21 (iOS Simulator launch) — blocked
[ ] Gate KO-22 (Android Emulator launch) — blocked

## Blockers
**Environment lacks Xcode and Android SDK.**
- `xcodebuild` fails: only CommandLineTools installed, not full Xcode
- `adb` / Android SDK not found
- iOS Simulator and Android Emulator builds cannot run in this session.

Workaround: user must run builds locally with Xcode / Android Studio installed.

## Lessons for RULES.md (agent proposes, human approves)
- CapacitorConfig in v8 does not include `bundledWebRuntime`; remove it to pass TypeScript checks.
- `cap add ios/android` can generate projects without Xcode/Android SDK, but running simulators requires the full IDE.
