# Program: <TASK-ID>

> Human-owned strategy doc. The Conductor and Verifier treat Metric and Stop
> condition as the task's acceptance criteria. Copy this file to
> `.loop/programs/<TASK-ID>.md` and fill it in.

## Objective
One sentence: what outcome, for which user.

## Metric
The checkable definition of done beyond the standard gates (tsc/lint/vitest/diff scan).
Examples: "production smoke script X prints 12/12 PASS", "lesson replay completes
without error for a user with prior attempts", "Lighthouse performance ≥ 85".
If left blank, the standard gates are the whole metric.

## Scope
Files/areas the Maker may touch. One migration max.

## Off-limits
Anything the Maker must not change (beyond the standing RULES.md list:
`.env*`, `/tests/` existing files, `supabase/migrations/` history).

## Escalation triggers
Task-specific stop conditions (default loop triggers still apply:
same gate fails twice, budget exhausted, RULES.md conflict).

## Stop condition
When to halt even if the metric isn't met — and what "good enough to land" looks like.
