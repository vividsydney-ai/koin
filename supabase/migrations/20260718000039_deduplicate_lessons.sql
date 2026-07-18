-- Migration 039: Deduplicate lessons and backfill missing question variants
-- Scope:
--   1. Resolve duplicate lesson titles while keeping computeLearningPath targets intact.
--   2. Re-point dependent rows from deprecated duplicates to the canonical row.
--   3. Deactivate safe duplicates (no attached user progress/attempts).
--   4. Re-sequence lesson_number to remove gaps.
--   5. Insert fallback question variants for published lessons with zero questions.
--
-- Safety guard: the Foundation 0 / main-track "What Is Money?" pair contains two
-- computeLearningPath target slugs and an overlapping user-progress record, so it
-- is only title-disambiguated, not deactivated.

BEGIN;

-- =====================================================================
-- 0. Disambiguate the pair that contains two protected target slugs.
-- =====================================================================
UPDATE lessons
SET title = 'What Is Money? (Foundation 0)',
    title_id = 'Apa Itu Uang? (Foundation 0)',
    updated_at = NOW()
WHERE slug = 'fz-what-is-money'
  AND title = 'What Is Money?';

-- =====================================================================
-- 1. Build a temporary map of canonical rows and safe-to-deprecate duplicates.
--    Preference: published > unpublished, row with variants/sources > empty,
--    lower lesson_number > higher lesson_number. Duplicates with attached
--    lesson_progress or lesson_attempts are excluded from deprecation.
-- =====================================================================
CREATE TEMP TABLE dedup_targets (
  dup_id UUID PRIMARY KEY,
  canonical_id UUID NOT NULL,
  dup_slug TEXT NOT NULL,
  dup_title TEXT NOT NULL
) ON COMMIT DROP;

WITH dup_groups AS (
  SELECT title
  FROM lessons
  GROUP BY title
  HAVING count(*) > 1
),
ranked AS (
  SELECT
    l.id,
    l.title,
    l.slug,
    l.is_published,
    l.lesson_number,
    ROW_NUMBER() OVER (
      PARTITION BY l.title
      ORDER BY
        l.is_published DESC,
        (
          (EXISTS (SELECT 1 FROM content_variants cv WHERE cv.lesson_id = l.id AND cv.is_active = TRUE))::int
          +
          (EXISTS (SELECT 1 FROM lesson_sources ls WHERE ls.lesson_id = l.id))::int
        ) DESC,
        l.lesson_number ASC,
        l.id ASC
    ) AS rnk
  FROM lessons l
  JOIN dup_groups d ON l.title = d.title
),
canonical AS (
  SELECT id, title FROM ranked WHERE rnk = 1
),
dup AS (
  SELECT r.id, r.slug, r.title, c.id AS canonical_id
  FROM ranked r
  JOIN canonical c ON r.title = c.title
  WHERE r.rnk > 1
),
safe_dup AS (
  SELECT d.id, d.canonical_id, d.slug, d.title
  FROM dup d
  WHERE NOT EXISTS (SELECT 1 FROM lesson_progress lp WHERE lp.lesson_id = d.id)
    AND NOT EXISTS (SELECT 1 FROM lesson_attempts la WHERE la.lesson_id = d.id)
)
INSERT INTO dedup_targets (dup_id, canonical_id, dup_slug, dup_title)
SELECT id, canonical_id, slug, title FROM safe_dup;

-- =====================================================================
-- 2. Re-point dependent rows from duplicates to the canonical row.
--    Conflict-safe: rows that would violate a unique constraint are skipped.
-- =====================================================================

-- Alternative content pool
UPDATE content_variants cv
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE cv.lesson_id = dt.dup_id;

-- Source citations
UPDATE lesson_sources ls
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE ls.lesson_id = dt.dup_id
  AND NOT EXISTS (
    SELECT 1 FROM lesson_sources ls2
    WHERE ls2.lesson_id = dt.canonical_id AND ls2.source_id = ls.source_id
  );

-- User attempts (no unique constraint; re-point all)
UPDATE lesson_attempts la
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE la.lesson_id = dt.dup_id;

-- User progress (unique per user + lesson; skip conflicts)
UPDATE lesson_progress lp
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE lp.lesson_id = dt.dup_id
  AND NOT EXISTS (
    SELECT 1 FROM lesson_progress lp2
    WHERE lp2.user_id = lp.user_id AND lp2.lesson_id = dt.canonical_id
  );

-- Adaptive recommendations (unique per user + lesson; skip conflicts)
UPDATE user_lesson_recommendations ulr
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE ulr.lesson_id = dt.dup_id
  AND NOT EXISTS (
    SELECT 1 FROM user_lesson_recommendations ulr2
    WHERE ulr2.user_id = ulr.user_id AND ulr2.lesson_id = dt.canonical_id
  );

-- Content flags, media, recommended resources, triggers
UPDATE content_flags cf
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE cf.lesson_id = dt.dup_id;

UPDATE lesson_media lm
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE lm.lesson_id = dt.dup_id;

UPDATE recommended_resources rr
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE rr.lesson_id = dt.dup_id;

UPDATE lesson_triggers lt
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE lt.lesson_id = dt.dup_id;

-- Version history (unique per lesson + version_number; skip conflicts)
UPDATE lesson_versions lv
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE lv.lesson_id = dt.dup_id
  AND NOT EXISTS (
    SELECT 1 FROM lesson_versions lv2
    WHERE lv2.lesson_id = dt.canonical_id AND lv2.version_number = lv.version_number
  );

-- Editorial reviews (unique per lesson; keep canonical review if both exist)
DELETE FROM lesson_reviews lr
USING dedup_targets dt
WHERE lr.lesson_id = dt.dup_id
  AND EXISTS (SELECT 1 FROM lesson_reviews lr2 WHERE lr2.lesson_id = dt.canonical_id);

UPDATE lesson_reviews lr
SET lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE lr.lesson_id = dt.dup_id;

-- Onboarding starting lesson references
UPDATE user_settings us
SET starting_lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE us.starting_lesson_id = dt.dup_id;

-- Lesson prerequisite links
UPDATE lessons l2
SET prerequisite_lesson_id = dt.canonical_id
FROM dedup_targets dt
WHERE l2.prerequisite_lesson_id = dt.dup_id;

-- =====================================================================
-- 3. Deactivate the safe duplicates.
-- =====================================================================
UPDATE lessons l
SET is_published = false,
    title = l.title || ' [duplicate-deprecated]',
    slug = l.slug || '-duplicate-deprecated',
    updated_at = NOW()
FROM dedup_targets dt
WHERE l.id = dt.dup_id;

-- =====================================================================
-- 4. Re-sequence lesson_number to remove gaps. Active lessons keep their
--    existing order; deprecated rows are moved to the end of the sequence.
--    We store the desired new numbers in a temp table, then update in two
--    passes to avoid unique-constraint collisions.
-- =====================================================================
CREATE TEMP TABLE renum_map (
  id UUID PRIMARY KEY,
  new_num INTEGER NOT NULL
) ON COMMIT DROP;

INSERT INTO renum_map (id, new_num)
SELECT
  id,
  ROW_NUMBER() OVER (
    ORDER BY is_published DESC, lesson_number ASC, id ASC
  )::int AS new_num
FROM lessons;

-- First pass: move everything to a temporary negative range.
UPDATE lessons l
SET lesson_number = -(r.new_num),
    updated_at = NOW()
FROM renum_map r
WHERE l.id = r.id;

-- Second pass: set the final positive numbers.
UPDATE lessons l
SET lesson_number = r.new_num,
    updated_at = NOW()
FROM renum_map r
WHERE l.id = r.id;

-- =====================================================================
-- 5. Guard computeLearningPath target slugs: ensure each exists and is unique.
--    If a target is missing, insert a minimal placeholder lesson.
-- =====================================================================
INSERT INTO lessons (
  slug,
  title,
  title_id,
  topic_id,
  lesson_number,
  difficulty,
  xp_reward,
  estimated_minutes,
  summary,
  is_published,
  jurisdiction
)
SELECT
  'fz-what-is-money',
  'What Is Money?',
  'Apa Itu Uang?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'),
  (SELECT COALESCE(MAX(lesson_number), 0) + 1 FROM lessons),
  'beginner',
  50,
  5,
  'Placeholder: money is a medium of exchange, store of value, and unit of account.',
  true,
  'ID'
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'fz-what-is-money');

INSERT INTO lessons (
  slug,
  title,
  title_id,
  topic_id,
  lesson_number,
  difficulty,
  xp_reward,
  estimated_minutes,
  summary,
  is_published,
  jurisdiction
)
SELECT
  'fz-income-vs-wealth',
  'Income vs Wealth',
  'Pendapatan vs Kekayaan',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'),
  (SELECT COALESCE(MAX(lesson_number), 0) + 1 FROM lessons),
  'beginner',
  50,
  5,
  'Placeholder: income is a flow; wealth is a stock.',
  true,
  'ID'
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'fz-income-vs-wealth');

INSERT INTO lessons (
  slug,
  title,
  title_id,
  topic_id,
  lesson_number,
  difficulty,
  xp_reward,
  estimated_minutes,
  summary,
  is_published,
  jurisdiction
)
SELECT
  'money-basics-101',
  'What Is Money?',
  'Apa Itu Uang?',
  (SELECT id FROM topics WHERE slug = 'money_basics'),
  (SELECT COALESCE(MAX(lesson_number), 0) + 1 FROM lessons),
  'beginner',
  50,
  5,
  'Placeholder: main-track introduction to money basics.',
  true,
  'ID'
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'money-basics-101');

-- Ensure uniqueness invariant is upheld (slug already has a UNIQUE constraint).
DO $$
BEGIN
  IF (SELECT count(*) FROM lessons WHERE slug = 'fz-what-is-money') != 1 THEN
    RAISE EXCEPTION 'Invariant violation: fz-what-is-money must exist exactly once';
  END IF;
  IF (SELECT count(*) FROM lessons WHERE slug = 'fz-income-vs-wealth') != 1 THEN
    RAISE EXCEPTION 'Invariant violation: fz-income-vs-wealth must exist exactly once';
  END IF;
  IF (SELECT count(*) FROM lessons WHERE slug = 'money-basics-101') != 1 THEN
    RAISE EXCEPTION 'Invariant violation: money-basics-101 must exist exactly once';
  END IF;
END $$;

-- =====================================================================
-- 6. Backfill fallback question variants for published lessons that have
--    zero active question variants and no legacy quiz_data.
-- =====================================================================
INSERT INTO content_variants (lesson_id, variant_type, difficulty, body)
SELECT
  l.id,
  'question',
  l.difficulty,
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Utang selalu buruk dan harus dihindari sepenuhnya.',
    'answer', false,
    'difficulty', l.difficulty,
    'parameters', jsonb_build_object(),
    'explanation', 'Tidak semua utang buruk. Utang yang membantu meningkatkan penghasilan atau pendidikan bisa bernilai, asalkan bunganya terjangkau. Utang berbahaya adalah utang konsumtif dengan bunga tinggi.'
  )
FROM lessons l
WHERE l.slug = 'fz-debt'
  AND l.is_published = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM content_variants cv
    WHERE cv.lesson_id = l.id AND cv.variant_type = 'question' AND cv.is_active = TRUE
  )
  AND (l.quiz_data IS NULL OR l.quiz_data = 'null'::jsonb);

INSERT INTO content_variants (lesson_id, variant_type, difficulty, body)
SELECT
  l.id,
  'question',
  l.difficulty,
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Investasi yang menjanjikan imbal hasil tinggi, tanpa risiko, dan menekan merekrut teman adalah tanda investasi ilegal yang umum.',
    'answer', true,
    'difficulty', l.difficulty,
    'parameters', jsonb_build_object(),
    'explanation', 'OJK secara rutin memperingatkan investasi ilegal dengan tiga ciri: imbal hasil dijamin, tanpa risiko, dan bonus merekrut. Selalu periksa izin OJK sebelum menanamkan uang.'
  )
FROM lessons l
WHERE l.slug = 'too-good-to-be-true'
  AND l.is_published = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM content_variants cv
    WHERE cv.lesson_id = l.id AND cv.variant_type = 'question' AND cv.is_active = TRUE
  )
  AND (l.quiz_data IS NULL OR l.quiz_data = 'null'::jsonb);

INSERT INTO content_variants (lesson_id, variant_type, difficulty, body)
SELECT
  l.id,
  'question',
  l.difficulty,
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Saat membandingkan dua investasi, angka imbal hasil kotor (sebelum pajak) selalu sama dengan jumlah uang yang benar-benar kita simpan.',
    'answer', false,
    'difficulty', l.difficulty,
    'parameters', jsonb_build_object(),
    'explanation', 'Yang terpenting adalah imbal hasil bersih setelah pajak dan biaya. Membandingkan produk hanya dari angka kotor bisa menyesatkan.'
  )
FROM lessons l
WHERE l.slug = 'taxes-on-returns'
  AND l.is_published = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM content_variants cv
    WHERE cv.lesson_id = l.id AND cv.variant_type = 'question' AND cv.is_active = TRUE
  )
  AND (l.quiz_data IS NULL OR l.quiz_data = 'null'::jsonb);

COMMIT;
