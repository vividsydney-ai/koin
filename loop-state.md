# loop-state.md — Current Loop State

> AUTO-GENERATED. Do not edit manually unless human intervenes.
> Read this file at the start of every turn. If state != DONE, resume from here.

## Current Task
- ID: KO-45
- Title: Onboarding financial literacy assessment + personalized learning path
- Phase: LANDING
- Iteration: 1 / 6
- Locked by: lander
- Agent: kimi (Conductor)
- Started: 2026-07-14T06:20:00Z
- Branch: web-koinaku
- Worktree: /Users/vividm4/Documents/Projects/Side-Gigs/Koin/koin-ko-45

## Plan Summary
<!-- Planner writes this. Maker follows it. Verifier checks against it. -->

**Goal:** Add a short first-use financial literacy quiz during onboarding (Duolingo-style fluency check) and use the result to personalise the lesson path.

**Conductor hypothesis:**
1. **Schema** — Add `financial_literacy_level` TEXT column to `profiles` with check `('beginner','intermediate','advanced')`, default `NULL`. Also add `onboarding_assessment_completed` BOOLEAN default `FALSE`. This is enough for MVP; topic-level mastery can come later.
2. **Assessment content** — Create a static set of ~5 diagnostic questions in a new file `lib/onboarding/diagnosticQuestions.ts`. Each question has a correct difficulty tag (beginner/intermediate/advanced) and topic. Mix multiple-choice and true/false.
3. **Scoring** — Count correct answers per difficulty. Bucket user into:
   - beginner: ≤1 intermediate/advanced correct
   - intermediate: 2–3 intermediate/advanced correct
   - advanced: ≥4 intermediate/advanced correct
4. **Onboarding UI** — Insert a new step `"assessment"` between `"profile"` and `"goal"` in `app/onboarding/page.tsx`. Show one question at a time, immediate feedback optional, progress indicator.
5. **Personalisation** — In `app/(app)/learn/page.tsx`, if the user is `advanced`, unlock lessons 1–3 immediately (mark `lesson_progress` status `available` for those lesson IDs) and surface a "skip basics" recommendation. If `intermediate`, unlock lesson 1 and 2. Beginner stays default (only lesson 1 available).
6. **Tests** — Add tests for scoring logic and migration structure.
7. **Verify + Land** — Run `npm run loop:gates`, push migration to remote Supabase, deploy.

**Open questions for Planner:**
- Should we store per-topic scores in addition to overall level? (Conductor leans no for MVP.)
- Should the assessment be skippable? (Conductor leans yes, with default beginner.)
- Should we generate `lesson_progress` rows at onboarding completion or lazily in Learn page? (Conductor leans generate at completion for deterministic unlocking.)

## Swarm Assignment
- Planner: kimi-explore
- Maker (Migration): kimi-coder
- Maker (Onboarding UI): kimi-coder
- Maker (Learn Page Personalization): kimi-coder
- Verifier: kimi-explore (distinct instance)
- Fixer: kimi-coder
- Lander: kimi (Conductor)

## Gates Run
- [ ] Gate 0: TypeScript (npx tsc --noEmit)
- [ ] Gate 1: Tests (npx vitest run)
- [ ] Gate 2: Diff scan (no localStorage/sessionStorage)
- [ ] Gate 3: RLS check (if migration touched)
- [ ] Gate 4: Lighthouse mobile >=85 / accessibility >=95
- [ ] Gate 5: Design-token drift check
- [ ] Gate 6: Secret scan

## Blockers
None.

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
