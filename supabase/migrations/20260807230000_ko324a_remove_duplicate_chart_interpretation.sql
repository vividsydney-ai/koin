-- KO-324-A follow-up: remove the generic chart_interpretation question that was
-- inserted identically for every Chapter 10 lesson. It caused the exact same
-- quiz to appear across lessons, which looked like a repeat to learners.
--
-- Each lesson still keeps its three legacy conceptual questions and three
-- visual_applied variants, leaving a pool of 6 distinct questions per lesson.

BEGIN;

DELETE FROM public.content_variants
WHERE variant_type = 'question'
  AND topic_tag = 'Reading Trading Charts'
  AND body->>'type' = 'chart_interpretation'
  AND body->>'question' = 'Which practice option closes above its open?';

COMMIT;
