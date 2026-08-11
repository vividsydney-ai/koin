-- KO-361: apply consistent semantic wayfinding to every published
-- Investing in Indonesia visual and correct the tax lesson's source boundary.
-- Icons are supplementary cues only; the bilingual visual copy remains the
-- accessible explanation. No market data, forecast, or personal tax outcome
-- is introduced here.

BEGIN;

WITH icon_map(slug, icon) AS (
  VALUES
    ('what-is-a-stock', '🏢'),
    ('idx-basics-101', '🏛️'),
    ('reading-a-stock-page', '📊'),
    ('portfolio-thinking', '🧺'),
    ('taxes-on-returns', '🧾'),
    ('macro-indicators', '🌐'),
    ('etfs-investing-with-one-click', '🧺'),
    ('bonds-sbn-safe-investing-with-the-government', '🏛️'),
    ('tax-basics-npwp-pph-21-and-filing-taxes', '🗂️'),
    ('brokerage-account-setup-opening-your-rdn', '🏦'),
    ('stock-analysis-basics-fundamental-vs-technical', '🔎'),
    ('etfs-investing-with-one-click-part-2', '🧺'),
    ('bonds-sbn-safe-investing-with-the-government-part-2', '🏛️'),
    ('tax-basics-npwp-pph-21-and-filing-taxes-part-2', '🗂️'),
    ('brokerage-account-setup-opening-your-rdn-part-2', '🏦'),
    ('stock-analysis-basics-fundamental-vs-technical-part-2', '🔎')
)
UPDATE public.lesson_visual_blocks AS block
SET content = jsonb_set(
  jsonb_set(block.content, '{en,icon}', to_jsonb(icon_map.icon::text), TRUE),
  '{id,icon}',
  to_jsonb(icon_map.icon::text),
  TRUE
),
updated_at = NOW()
FROM public.lessons AS lesson
JOIN public.topics AS topic ON topic.id = lesson.topic_id
JOIN icon_map ON icon_map.slug = lesson.slug
WHERE block.lesson_id = lesson.id
  AND block.is_published = TRUE
  AND lesson.is_published = TRUE
  AND topic.chapter = 'Investing in Indonesia';

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes, synopsis,
  synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'CH08-DJP-PPH4-2-STOCK-TRANSACTION',
  'DJP PPh Article 4(2) final income-tax explainer',
  'Penjelasan PPh Pasal 4 Ayat (2) DJP',
  1,
  'website',
  'DJP',
  'https://pajak.go.id/index.php/id/pph-pasal-4-ayat-2',
  'id',
  '2026-08-09',
  'verified',
  'Primary DJP explainer for the bounded final-income-tax treatment of listed-share transactions. Tax rules can change and personal circumstances still matter.',
  'Sumber utama berbahasa Indonesia. Pelajaran hanya membedakan angka kotor dan bersih; tidak memberi hasil pajak pribadi atau petunjuk pelaporan.',
  'DJP explains final income-tax treatment under Article 4(2), including the statutory category covering listed-share transactions.',
  'DJP menjelaskan perlakuan pajak penghasilan final Pasal 4 Ayat (2), termasuk kategori ketentuan untuk transaksi saham tercatat.',
  'Supports the lesson boundary that tax treatment can change the amount kept; learners must check the current rule and their instrument before applying an example.',
  'Mendukung batas pelajaran bahwa perlakuan pajak dapat mengubah jumlah yang diterima; pelajar perlu memeriksa aturan dan instrumen terbaru sebelum menerapkan contoh.'
)
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title,
  local_title = EXCLUDED.local_title,
  source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type,
  organization = EXCLUDED.organization,
  url = EXCLUDED.url,
  language = EXCLUDED.language,
  last_checked_at = EXCLUDED.last_checked_at,
  status = EXCLUDED.status,
  trust_notes = EXCLUDED.trust_notes,
  localization_notes = EXCLUDED.localization_notes,
  synopsis = EXCLUDED.synopsis,
  synopsis_id = EXCLUDED.synopsis_id,
  relevance_blurb = EXCLUDED.relevance_blurb,
  relevance_blurb_id = EXCLUDED.relevance_blurb_id;

-- PPh 21 covers employment-income withholding. It is not retained as evidence
-- for this stock-return lesson. The generic OJK link remains supporting only.
DELETE FROM public.lesson_sources AS lesson_source
USING public.lessons AS lesson, public.sources AS source
WHERE lesson_source.lesson_id = lesson.id
  AND lesson_source.source_id = source.id
  AND lesson.slug = 'taxes-on-returns'
  AND source.source_code = 'CH08-DJP-PPH21';

UPDATE public.lesson_sources AS lesson_source
SET is_primary = FALSE,
    relevance_type = 'supporting',
    citation_label = 'OJK capital-market overview',
    display_order = 20
FROM public.lessons AS lesson, public.sources AS source
WHERE lesson_source.lesson_id = lesson.id
  AND lesson_source.source_id = source.id
  AND lesson.slug = 'taxes-on-returns'
  AND source.source_code = 'OJK-004';

INSERT INTO public.lesson_sources (
  lesson_id, source_id, relevance_type, citation_label, is_primary, display_order
)
SELECT lesson.id, source.id, 'primary', 'DJP PPh Article 4(2) explainer', TRUE, 10
FROM public.lessons AS lesson
JOIN public.sources AS source ON source.source_code = 'CH08-DJP-PPH4-2-STOCK-TRANSACTION'
WHERE lesson.slug = 'taxes-on-returns'
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

DELETE FROM public.lesson_visual_block_sources AS visual_source
USING public.lesson_visual_blocks AS block, public.lessons AS lesson, public.sources AS source
WHERE visual_source.visual_block_id = block.id
  AND block.lesson_id = lesson.id
  AND visual_source.source_id = source.id
  AND lesson.slug = 'taxes-on-returns'
  AND source.source_code = 'CH08-DJP-PPH21';

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, 'DJP PPh Article 4(2) explainer'
FROM public.lesson_visual_blocks AS block
JOIN public.lessons AS lesson ON lesson.id = block.lesson_id
JOIN public.sources AS source ON source.source_code = 'CH08-DJP-PPH4-2-STOCK-TRANSACTION'
WHERE lesson.slug = 'taxes-on-returns'
  AND block.is_published = TRUE
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET
  citation_label = EXCLUDED.citation_label;

COMMIT;
