# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: KO-LESSON-003
- Title: Fix replay XP UI, completion save error, and ENG/ID lingo mixing
- Phase: IMPLEMENTING
- Iteration: 0 / 6
- Locked by: Conductor
- Agent: kimi-code
- Started: 2026-07-19T08:30:00+10:00
- Branch: web-koinaku
- Worktree: none

## Plan Summary
<!-- Planner writes this. Maker follows it. Verifier checks against it. -->

1. **Replay XP UI bug (KO-LESSON-003A):**
   - In `app/learn/[slug]/LessonPlayer.tsx` `CompletionStep`, when `isReplay` is true, the base XP StatCard is still rendered with green XP tone and `lesson.xpReward` value.
   - Change replay completion UI so XP stats are grayed out / muted and show "Already earned" / "0 XP" instead of the original reward value.

2. **Completion save error (KO-LESSON-003B):**
   - Users see "We couldn't save your progress" on first-time lesson completion, yet XP/Koin Points are awarded.
   - Root cause likely transient client response handling or the `complete_lesson` RPC returning a shape the client fails to parse.
   - Add explicit retry logic (1 retry) in `lib/lessons/completion.ts`.
   - Improve error logging and surface the actual RPC error message in the UI temporarily.
   - Defensively check lesson status after a failed completion and if the lesson is already completed, treat it as success.

3. **ENG/ID lingo mixing (KO-LESSON-003C):**
   - `Lesson` type only has `titleId` and `indonesianExample` for Indonesian; `summary`, `conceptBody`, `whyThisMatters`, `commonMistake`, `quizData` are English-only.
   - Content variants may also be English-only.
   - Add Indonesian fields to the `Lesson` type and `getLessonBySlug` query if they exist in Supabase; if not, scope a migration to add them.
   - Audit all UI strings not yet in `lib/i18n/dictionaries.ts` and add Indonesian translations.
   - Ensure `useLocale` is used everywhere; no hardcoded English strings in lesson player.

## Swarm Assignment
- Planner: Conductor (kimi-code)
- Maker: kimi-code
- Verifier: to be delegated
- Fixer: to be delegated if gates fail
- Lander: kimi-code

## Gates Run
- [ ] Gate 0: TypeScript (npx tsc --noEmit)
- [ ] Gate 1: Tests (npx vitest run)
- [ ] Gate 2: Diff scan (no localStorage/sessionStorage)
- [ ] Gate 3: RLS check (if migration touched)
- [ ] Gate 4: Lighthouse mobile >=85 / accessibility >=95
- [ ] Gate 5: Design-token drift check
- [ ] Gate 6: Secret scan
- [ ] Gate 7: Build succeeds
- [ ] Gate 8: web.koinaku.com smoke test

## Blockers
- Need to verify whether `lessons` table has Indonesian columns for summary/concept/why_this_matters/common_mistake/quiz_data.

## Corrections Applied
<!-- Each failed iteration: what failed, root cause, fix. -->

## Verdict
<!-- Verifier appends PASS/FAIL/NEEDS_INFO here. -->

## Budget
- Max iterations: 6
- Remaining: 6
- Time elapsed: 0 min
- Files touched: 0 / 15
- Migrations: 0 / 1
- Subagent calls: 0
