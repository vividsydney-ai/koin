# Verification Report v2

## Summary
- **Status:** PASS_WITH_NOTES
- **Total lessons:** 32
- **Total variants:** 256
- **Question variants:** 128 (4 per lesson)
- **Must-fix issues:** 0
- **Should-fix issues:** 5
- **Notes:** 4

All "must pass" criteria were met. The items below are non-blocking improvements that should be addressed before migration to keep distractor quality high and the curriculum map internally consistent.

## Verification method
- Parsed `curriculum-v2.md` for the 32-lesson map, prerequisites, topic slugs, quiz-type recommendations, and source themes.
- Loaded `lesson-bodies-v2.json` and `lesson-variants-v2.json`.
- Validated every question variant against the Zod schemas exported from `lib/lessons/question.ts`.
- Ran semantic answer checks (MC answer in options, ordering answer is a permutation of options, matching answer aligns with pairs, case-study follow-up answer in options).
- Scanned bodies/variants for IDR currency, Western brands/places/names, hype/guaranteed-return language, and investing-product placement by stage.
- Cross-checked `sources-v2.csv` against existing source codes in `supabase/seed.sql` and validated ISBN/URL formatting.

## Must-fix issues (block migration)
_None._

## Should-fix issues (non-blocking)
1. **[curriculum-v2.md §9]** The handoff note lists `value-and-purchasing-power` and `diversification-101` under recommended `matching` lessons, but their per-lesson `quiz_type_recommendation` fields are `multiple_choice` and `case_study` respectively.  
   → **Suggested fix:** Align §9 with the per-lesson recommendations, or update the per-lesson fields if the handoff note is the intended source of truth.

2. **[understanding-risk]** The `case_study` follow-up includes the distractor *“Rina terlalu kaya”*, which is not a plausible misconception.  
   → **Suggested fix:** Replace it with a believable wrong answer such as *“Rina kehilangan reputasi sebagai teman”* or *“Rina kehilangan kesempatan memakai uang itu”*.

3. **[emergency-fund-101]** The `case_study` follow-up includes weak/nonsense distractors: *“Tidak bisa menggunakan GoPay”* and *“Kehilangan semua penumpang”*.  
   → **Suggested fix:** Replace with realistic risks, e.g. *“Harus meminjam dari keluarga dengan konsekuensi sosial”* and *“Tidak bisa bekerja selama beberapa hari karena hp rusak”*.

4. **[portfolio-thinking]** The `case_study` follow-up includes the distractor *“Rina terlalu muda untuk menabung”*, which is obviously absurd.  
   → **Suggested fix:** Replace with a realistic misconception such as *“Tabungan sudah cukup untuk tujuan jangka panjang”*.

5. **[integration]** `curriculum-v2.md` provides narrative `source_theme` strings, but no machine-readable lesson→source mapping file exists. Additionally, IDX-009..012 in `sources-v2.csv` are marked `needs_review` and should be verified before any published lesson links to them.  
   → **Suggested fix:** Build an explicit `lesson_sources` mapping in the Supabase migration (one Tier-1 source per lesson minimum), and manually verify or substitute the four `needs_review` IDX URLs before publish.

## Notes
1. **Stage and investing-content check:** No foundation (1–8) lesson teaches investing products. `emergency-fund-101` (behavior stage) mentions stocks only as an unsuitable place for emergency savings; this is appropriate but introduces a product reference before Stage 4. Consider softening to *“high-risk investments”* if the team wants to keep Stage 2 strictly product-free.
2. **Localization:** The only remaining non-IDR currency reference is in `macro-indicators`, which intentionally uses *“US dollar (dolar AS)”* to explain import/gadget pricing. This is contextually appropriate for Indonesian teens but should be confirmed as the desired framing.
3. **Hype/guaranteed-return language:** Phrases like *“keuntungan pasti”*, *“dijamin untung”*, and *“guaranteed return”* appear only inside scam warnings or as false distractors whose correct answer explains why the claim is invalid. No lesson promises returns.
4. **Variant validation:** All 128 question variants passed the `lib/lessons/question.ts` Zod schemas and the semantic answer-alignment checks. No schema errors, no missing question variants, and no duplicate lesson slugs or lesson numbers were found.
