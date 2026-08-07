-- Migration: KO-CURR-001 follow-up — fix broken new OJK URLs and remap lesson sources.
-- The Source Researcher incorrectly verified OJK-009..024 URLs. They return 404/fetch-failed
-- from production. We replace them with existing verified sources so every published lesson
-- still has a reachable Tier 1 source.

-- 1. Remove broken source-lesson links.
DELETE FROM lesson_sources
WHERE source_id IN (
  SELECT id FROM sources WHERE source_code BETWEEN 'OJK-009' AND 'OJK-024'
);

-- 2. Remove the broken source rows entirely.
DELETE FROM sources
WHERE source_code BETWEEN 'OJK-009' AND 'OJK-024';

-- 3. Ensure every published v2.0 lesson has at least one reachable Tier 1 source.
-- First, remove any stale primary flags on lessons that were linked to deleted sources.
-- (The DELETE above already removed those rows; this is defensive.)

-- 4. Insert new primary source links using existing verified sources.
-- Foundation / Behavior / Scam Defense → OJK-003 (personal financial management)
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary, display_order)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  TRUE,
  0
FROM lessons l, sources s
WHERE l.slug IN (
  'money-basics-101',
  'value-and-purchasing-power',
  'inflation-101',
  'income-vs-wealth',
  'needs-vs-wants-101',
  'assets-vs-liabilities',
  'understanding-risk',
  'time-value-of-money',
  'budgeting-101',
  'emergency-fund-101',
  'pay-yourself-first',
  'spending-traps',
  'debt-traps',
  'goal-setting-101',
  'too-good-to-be-true',
  'check-ojk-license',
  'phishing-social-engineering',
  'mlm-pyramid-red-flags'
)
AND s.source_code = 'OJK-003'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- Wealth Building / Investing Fundamentals → OJK-006 (investment products)
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary, display_order)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  TRUE,
  0
FROM lessons l, sources s
WHERE l.slug IN (
  'interest-101',
  'compound-interest-101',
  'bank-vs-investment',
  'risk-return-101',
  'diversification-101',
  'reksa-dana-basics',
  'what-is-a-stock',
  'idx-basics-101',
  'reading-a-stock-page',
  'portfolio-thinking'
)
AND s.source_code = 'OJK-006'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- Pro Teaser → OJK-001 (SNLKI national strategy)
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary, display_order)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  TRUE,
  0
FROM lessons l, sources s
WHERE l.slug IN (
  'taxes-on-returns',
  'macro-indicators',
  'behavioral-bias-intro',
  'building-financial-plan'
)
AND s.source_code = 'OJK-001'
ON CONFLICT (lesson_id, source_id) DO NOTHING;
