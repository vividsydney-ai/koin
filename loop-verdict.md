## Verdict

status: PASS

## Summary

KO-447 meets its acceptance criteria. The prior FAIL was caused solely by the Fidelity Tier-2 fallback returning 403 in the verification environment. The follow-up migration `20260813020000_ko447_replace_blocked_fallback.sql` removes every Fidelity link from Chapter 11 and substitutes a Schwab stock-basics source that I independently confirmed returns HTTP 200. I re-verified all eight lessons against live Supabase: 5 active `visual_applied` chart-backed variants each in both locales, all candles carrying numeric volume, bilingual Case A/Case B examples with IDX context and disclaimers, one Tier-1 verified primary per lesson, and exactly two verified reachable Tier-2 supporting sources per lesson. Local type-check, tests, and production build all pass.

I am explicit about one boundary: authenticated production UI proof is unavailable, since `https://web.koinaku.com/learn/decision-volume-confirmation` redirects to login. I verified the render contract at the source and data level, not by observing the deployed authenticated page. I judge this sufficient because the render order and volume geometry are deterministic in the component, and the live data satisfies every precondition the component needs. That distinction is recorded below rather than hidden inside the pass.

## Evidence

### Source reachability, the prior blocker

| Source | URL status |
| --- | --- |
| `KO447-SCHWAB-STOCK-BASICS` (new fallback) | **200** |
| `KO447-SCHWAB-CHART-PATTERNS` | 200 |
| `KO447-SCHWAB-VOLUME-CONFIRMATION` | 200 |
| `KO447-BRIDGEWATER-RISK-PRINCIPLES` | 200 |
| `KO447-FIDELITY-TA-OVERVIEW` | 403 (no longer linked) |

Fidelity link count attached to Chapter 11 published lessons: **0**. Fidelity link count anywhere in `lesson_sources`: **0**. The `sources` row itself still exists but is orphaned and learner-unreachable, which satisfies "no Fidelity links attached to Chapter 11."

### Live Supabase verification (project `sjmkfywvwizfpwwkijhe`)

- 8/8 published Decision Analysis Lab lessons.
- 40 active `visual_applied` question variants, exactly 5 per lesson across all eight.
- Chart coverage: 40/40 EN (`body.chart.candles`) and 40/40 ID (`body_id.chart.candles`); every candle in all 80 payloads has a numeric `volume`.
- 8/8 examples pass all five content checks: `Case A`+`Case B` in EN, `Kasus A`+`Kasus B` in ID, IDX/BEI context in both locales, and disclaimers in both locales. Lengths 497-618 EN and 522-649 ID.
- Sources per lesson: `tier1primary=1` and `tier2sup=2` for all eight, drawn only from the four verified reachable Tier-2 codes above.

### Render contract, volume before answers

- `components/lesson/QuizCard.tsx`: `<CandlestickChart>` renders at line 92; answer `options.map()` and `<button>` at lines 106/115. Chart precedes answers.
- `CandlestickChart.tsx` reserves `volumeArea = 42` and subtracts it from `plotHeight`, so volume bars occupy dedicated space. Computed geometry at full size: candles span y 24-154, volume bars y 166-196, labels y 218. **No overlap** between candle plot and volume bars, so bars are genuinely visible rather than drawn under the candles.
- `hasVolume` is gated on `!compact`, matching the intended full-size-only behavior.
- `lib/lessons/question.ts` adds `volume: z.number().nonnegative().optional()`, so the migration payloads validate rather than being silently dropped.

### Local automated evidence (re-run during this verification)

- `pnpm run type-check` → **PASS**, clean.
- `pnpm vitest run tests/lessons/` → **PASS**, 11 files, 84 tests.
- `pnpm run build` → **PASS**, full route manifest emitted.
- `pnpm run lint` → 3 errors, 21 warnings. **All 3 errors are `no-require-imports` in `.loop/qa/validate_examples.js` and `.loop/qa/validate_ko447.js`**, which are QA scratch scripts, not product code. No lint error touches any changed product file. I do not treat this as a KO-447 defect, though it will keep failing the lint gate for anyone else until those scratch files are removed or ignored.

### Not proven

- **Authenticated production UI.** `https://web.koinaku.com/learn/decision-volume-confirmation` 302s to `/login?next=...`. No credentials or QA screenshot artifact exists, so no observation of the deployed authenticated page was made. This is a gap in acceptance-level evidence, not a contradicted expectation.

### Cosmetic nit, non-blocking

In `CandlestickChart.tsx` the accessible `textualSummary` template ends with `(${direction}),${volumeText}.` — when a candle has no volume this yields a dangling `"(up),."`. Chapter 11 payloads all carry volume so screen-reader output is correct here, but other charts without volume will read the stray comma. Worth a one-character fix; it does not affect this ticket's criteria.

## Files reviewed

- `components/charts/CandlestickChart.tsx` (diff)
- `lib/lessons/question.ts` (diff)
- `components/lesson/QuizCard.tsx`
- `supabase/migrations/20260813010000_ko447_ch11_chart_led_use_cases.sql`
- `supabase/migrations/20260813020000_ko447_replace_blocked_fallback.sql`
- `tests/lessons/chart-led-question.test.ts`
- `tests/lessons/question.test.ts`, `tests/lessons/LessonPlayer.test.tsx`
- `.loop/qa/KO-447.json`
- live `topics`, `lessons`, `content_variants`, `sources`, `lesson_sources` rows

Note on the QA artifact: `.loop/qa/KO-447.json` cites table `lesson_variants` and a `payload` column, neither of which exists; the real schema is `content_variants` with `body`/`body_id`. Its conclusions are nonetheless correct — I re-derived every count independently against the actual schema rather than trusting it.

## Recommendation

Accept KO-447 as verified. The blocking issue from the previous round is genuinely resolved, not worked around: the unreachable source is unlinked and replaced with a reachable, bilingual, verified equivalent, and every count is confirmed against live data rather than only against migration assertions.

Before or shortly after merge, three cheap follow-ups, none blocking:
1. Capture one authenticated screenshot of a Chapter 11 advanced quiz showing volume bars above the answer buttons, to close the only unobserved link in the chain.
2. Remove or lint-ignore `.loop/qa/*.js` so the lint gate returns to green.
3. Fix the `,${volumeText}.` dangling comma in the chart's accessible summary.

Per instruction, I made no edits beyond this file, did not touch Linear, and did not deploy.
