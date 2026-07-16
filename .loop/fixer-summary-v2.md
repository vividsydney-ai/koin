# Fixer Summary v2

All five should-fix issues from `verification-report-v2.md` have been addressed.

## Files changed

1. `.loop/curriculum-v2.md`
2. `.loop/lesson-variants-v2.json`
3. `.loop/lesson-sources-v2.csv` (new)
4. `.loop/fixer-summary-v2.md` (this file)

## Issue-by-issue fix

### Issue 1 — curriculum-v2.md §9 handoff note mismatch
- Updated the Variant Writer handoff note so the `matching` list only includes lessons whose per-lesson `quiz_type_recommendation` is actually `matching`.
- Changed `(1, 4, 6, 21, 23, 24, 27, 30)` → `(1, 4, 6, 21, 24, 27, 30)`.
- Lesson 23 (`diversification-101`) remains correctly listed under the `case_study` list because its recommendation is `case_study`.

### Issue 2 — `understanding-risk` weak distractor
- Replaced `Rina terlalu kaya` with `Rina kehilangan kesempatan memakai uang itu`.
- Correct answer remains `Teman tidak membayar kembali`.

### Issue 3 — `emergency-fund-101` weak distractors
- Replaced `Kehilangan semua penumpang` with `Tidak bisa bekerja selama beberapa hari karena hp rusak`.
- Replaced `Tidak bisa menggunakan GoPay` with `Harus meminjam dari keluarga dengan konsekuensi sosial`.
- Correct answer remains `Terpaksa pinjam ke pinjol berbunga tinggi`.

### Issue 4 — `portfolio-thinking` weak distractor
- Replaced `Rina terlalu muda untuk menabung` with `Tabungan sudah cukup untuk tujuan jangka panjang`.
- Correct answer remains `Tabungan tidak mengimbangi inflasi untuk tujuan jangka panjang`.

### Issue 5 — lesson→source mapping
- Created `.loop/lesson-sources-v2.csv` with 32 lessons × 2 rows = 64 rows.
- Each lesson has exactly one Tier 1 primary source (`is_primary = true`, `relevance_type = primary`).
- Each lesson also has one Tier 2 supporting book source (`is_primary = false`, `relevance_type = supporting`) reflecting the `book_hook`.
- All source codes come from `sources-v2.csv` or `supabase/seed.sql`; no invented codes.
- All primary sources are `verified`; no `needs_review` IDX sources were required.

## Validation

- `lesson-variants-v2.json` parses as valid JSON.
- `lesson-bodies-v2.json` parses as valid JSON.
- Ran semantic answer-alignment checks over all 256 variants:
  - multiple_choice / case_study answers exist in their options lists
  - ordering answers are permutations of their options
  - matching answers match declared pairs
  - All question variants passed.
- Ran `pnpm test tests/lessons/question.test.ts` — 11/11 tests passed.
- Validated `lesson-sources-v2.csv`:
  - 32 unique lessons
  - exactly one primary source per lesson
  - every source code exists in `sources-v2.csv` or `supabase/seed.sql`
