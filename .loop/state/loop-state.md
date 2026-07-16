# Loop State: Curriculum Overhaul & Lesson Expansion (KO-CURR-001)

**Task ID:** KO-CURR-001  
**Branch:** `web-koinaku`  
**Started:** 2026-07-16  
**Conductor:** Kimi Code  
**Locked by:** conductor  

## Goal

Overhaul the Koinaku curriculum so beginner lessons actually teach terms before applying them, expand to a 32-lesson free MVP track, and ground every lesson in real Indonesian context plus credible sources (OJK/BI/IDX + books). Build only two new quiz types (`matching`, `case_study`) to break multiple-choice fatigue.

## State Machine

```
[PLAN] → [DESIGN/SOURCES] → [WRITE] → [LOCALIZE] → [VERIFY] → [INTEGRATE] → [LAND]
  ✓        ✓                ✓       ✓           ✓          ✓               in_progress
```

- PLAN: Approved.
- DESIGN/SOURCES: Complete.
- WRITE: Complete.
- LOCALIZE: Complete.
- VERIFY/FIX: Complete.
- INTEGRATE: Complete. Migration generated; QuizEngine updated; tests pass.
- LAND: In progress. Push to `web-koinaku` and deploy to `web.koinaku.com`.

## Locked Decisions

1. **MVP v2.0 scope:** 32 free lessons.
2. **Structure:** Foundation (8) → Behavior & Habits (6) → Scam Defense (4) → Wealth Building Basics (6) → Investing Fundamentals (4) → Pro Teaser (4).
3. **Investing content:** Moved to later free stage.
4. **Free/Pro boundary:** 4-lesson Pro teaser at end of free path.
5. **Source rule:** Every published lesson needs ≥1 Tier 1 source + ≥1 supporting book/source note + approved review.
6. **Quiz types:** Add only `matching` and `case_study` UI.
7. **Quality bar:** 18-year-old test; verified URLs/ISBNs; plausible distractors; Indonesian contextualization.

## Outputs Produced

- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/curriculum-v2.md`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/sources-v2.csv`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/lesson-bodies-v2.json`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/lesson-variants-v2.json`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/localization-review-v2.md`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/verification-report-v2.md`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/lesson-sources-v2.csv`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/fixer-summary-v2.md`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/supabase/migrations/20260716000030_curriculum_v2_overhaul.sql`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/tests/migrations/030_curriculum_v2_overhaul.test.ts`

## Gate Results

- `npx tsc --noEmit` ✅ clean
- `npm run lint` ✅ 0 errors, 20 warnings
- `npx vitest run` ✅ 225 passed, 1 skipped
- `pglast` SQL parse ✅

## Budget

- Subagent calls: 7
- Hard stop: 8 subagent calls / 7 days / 20 files
