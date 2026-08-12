# KO-438 — Chapter 11 visual-learning audit

Date: 2026-08-12
Chapter: Decision Analysis Lab
Environment: linked production Supabase project `sjmkfywvwizfpwwkijhe`

## Baseline and result

The chapter contains eight published lessons. KO-440 added one bilingual visual block and three bilingual `visual_applied` checks per lesson. A replay initially left six active rows per lesson; the forward-only KO-441 deduplication repair retains the earliest three unique rows. KO-441 also repaired the recall payloads after the first live audit found that they were stored as single-option string arrays rather than the selectable `{ id, label }` contract used by the application.

| Requirement | Result |
| --- | ---: |
| Published lessons | 8 / 8 |
| Published visual blocks | 8 / 8 |
| Active applied checks | 24 rows / 3 bilingual checks per lesson |
| Active recalls | 8 / 8 |
| Recall options | 4 bilingual selectable options per lesson |
| Primary Tier-1 verified sources | 8 / 8 |
| Invalid applied answer rows | 0 |

## Visual treatment map

| Lessons | Treatment |
| --- | --- |
| Multi-candle context; zones and false breakouts | Annotated data |
| Volume confirmation; timeframe comparison | Comparison |
| Risk/reward; position sizing | Worked example |
| Bias and narratives; thesis invalidation | Process |

All blocks are explicitly illustrative or calculated and include bilingual title, alt text, disclosure, and explanatory content. No block is presented as a forecast or personal trading instruction.

## Sources

Each lesson has one primary, verified Tier-1 source and its visual block is source-linked. The source URLs returned HTTP 200 during the audit:

- OJK capital-market channel: `https://ojk.go.id/id/kanal/pasar-modal`
- IDX trading hours and mechanism: `https://www.idx.id/en/products-services/trading-hours-and-mechanism/`
- OJK 2025 capital-market handbook: `https://ojk.go.id/id/berita-dan-kegiatan/info-terkini/Pages/Buku-Saku-Pasar-Modal-2025.aspx`
- OJK publications: `https://ojk.go.id/id/berita-dan-kegiatan/publikasi`

## Verification evidence

- `pnpm run type-check` — passed.
- `pnpm run lint` — passed with 19 pre-existing warnings and 0 errors.
- `pnpm test` — 89 files, 528 tests passed.
- `node scripts/smoke/audit-question-answer-integrity.mjs` — 2,000 payloads audited, 0 failures.
- `pnpm run build` with the linked private environment — production build passed and generated 176 static pages.
- `printf 'y\\n' | npx supabase db push --linked --include-all` — KO-440 and the forward-only KO-441 repairs applied successfully. Supabase emitted only its existing pg-delta certificate-cache warning after applying the migrations.

## Follow-up

Independent QA and verifier artifacts must be recorded under `.loop/qa/` and `.loop/verification/` before the issue is marked complete. Deployment status must be stated explicitly as Vercel production.
