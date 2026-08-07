-- KO-348: replace Foundation mascot moments with lightweight semantic emoji cues.
-- Existing illustrative charts, comparisons, calculations, and process visuals remain unchanged.

BEGIN;

WITH icons(slug, icon) AS (
  VALUES
    ('fz-what-is-money', '💸'), ('fz-inflation', '🛒'),
    ('fz-interest', '💰'), ('fz-income-vs-wealth', '📊'),
    ('fz-assets-vs-liabilities', '⚖️'), ('fz-risk', '🛟'),
    ('fz-return', '📈'), ('fz-saving-vs-investing', '🏦'),
    ('fz-emergency-fund', '🧰'), ('fz-needs-vs-wants', '🤔'),
    ('fz-debt', '🧾'), ('fz-scam-red-flags', '🚩')
)
UPDATE public.lesson_visual_blocks AS block
SET content = jsonb_set(
  jsonb_set(
    (block.content #- ARRAY['en', 'mascot'] #- ARRAY['id', 'mascot']),
    ARRAY['en', 'icon'], to_jsonb(icons.icon), TRUE
  ),
  ARRAY['id', 'icon'], to_jsonb(icons.icon), TRUE
)
FROM public.lessons AS lesson
JOIN icons ON icons.slug = lesson.slug
WHERE block.lesson_id = lesson.id
  AND block.display_order = 10
  AND lesson.is_published = TRUE;

COMMIT;
