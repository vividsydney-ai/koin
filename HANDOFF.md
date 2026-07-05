# Agent Handoff — Koin Web MVP

> Last updated: 2026-07-03
> Read this at the start of a new session before doing anything else.

## Current branch and deploy
- **Integration branch:** `web-mvp`
- **Production URL:** https://koin-web-mvp.vercel.app/
- **Last deploy smoke check:** 200 OK

## Last known state
- Phases 1–5 complete.
- Phase 6 adaptive lesson triggers + 4 behavioral lessons + variant expansion are done and deployed.
- Tests: `npx vitest run` → 106 passed, 1 skipped.
- `npm run type-check` clean.

## Two possible next streams

### Stream 1: Fix open bugs (likely higher priority)
All bugs live in Linear project **Koin Bugs** with the `Bug` label:

| Issue | Priority | Title |
|---|---|---|
| KO-37 | P0 | Sign-up confirmation email is not sent after registration |
| KO-38 | P1 | Home page hero text overlaps on iPhone SE screen |
| KO-39 | P1 | Bottom navigation does not highlight active page on mobile |
| KO-40 | P2 | Paper trading page takes 4+ seconds to load on 3G connection |
| KO-41 | P2 | Profile page is missing 'Edit Profile' button |

Start with KO-37 (P0).

### Stream 2: Continue Phase 6 build
Remaining items from `TASKS.md`:
- Expand lessons from 9 → 15
- Library tab (browse sources by topic/tier/type/language)
- Recommended resources per lesson
- All empty states
- Analytics events instrumentation
- Notification queue stub
- Final QA: 375px mobile, 1280px desktop, dark mode, keyboard nav, WCAG AA

## How to decide
- If the human wants stability / user trust first, fix bugs.
- If the human wants feature completeness first, continue Phase 6 (Library tab is a clean next slice).

## Essential docs to read
1. `CLAUDE.md` — workflow and file routing
2. `TASKS.md` — task list
3. `progress.md` — live state
4. `docs/BUG_TRACKER.md` — Google Sheet ↔ Linear sync details
5. `CONTEXT.md`, `ADL.md`, `SCHEMA.md` — domain and schema context

## Environment notes
- `UpdateGoal` tool is not exposed. Do not wait for it. Track completion in `progress.md`, `TASKS.md`, and Linear.
- Native iOS/Android work (Phase 1b) is **paused**. Do not resume unless the human explicitly asks.
- Google Sheet bug tracker auto-creates Linear issues and writes IDs back to column O.
