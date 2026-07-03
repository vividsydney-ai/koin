# RECURRING.md — Periodic Maintenance for Koin
# Not tied to a TASKS.md phase or triggered by a task. Run on the cadence below,
# manually or via an agent session, since there is no scheduler/cron in this repo.
# If a check fails, log it under progress.md > Blockers, and add a RULES.md
# lesson if the same failure recurs.

## Monthly

### Source URL health check
Why: every lesson's credibility depends on live Tier 1 (OJK/BI/IDX) links. Gov/media
sites restructure without notice, and this only otherwise runs incidentally when the
full suite runs.
Run: `npm run test -- tests/sources/url-verification.test.ts`
On failure: update the `sources` row's `url` (find the current canonical page) or
`status` in a migration. Do not remove a source silently — a lesson may cite it.

### Dependency audit
Why: catch security advisories in a repo that isn't touched daily.
Run: `npm audit --audit-level=high`
On failure: patch or pin the affected package; note any accepted risk in RULES.md.

## Quarterly

### Stale queue review
Why: `progress.md > Blockers` and `RULES.md > Lessons learned` accumulate entries
that may already be resolved or superseded.
Do: re-read both sections; close/remove anything no longer true; promote durable
lessons into the permanent sections of RULES.md/ADL.md.

### Content variant coverage audit
Why: RULES/VERIFIER require 10+ examples and 11+ questions per launch lesson (see
ADL-009). New lessons added since (Phase 6 expansion to 15 lessons) may launch under
that bar.
Do: query `content_variants` grouped by `lesson_id`; any lesson under threshold goes
back into TASKS.md as a content task before it's marked published.

### Lighthouse re-run
Why: Gate 15 (VERIFIER.md) is normally checked once per phase; regressions from
dependency bumps or new UI can slip in between phases.
Run: `npx lighthouse http://localhost:3000 --preset=mobile --output=json`
Pass bar: same as Gate 15 (Performance ≥ 85, Accessibility ≥ 95, Best Practices ≥ 90).
