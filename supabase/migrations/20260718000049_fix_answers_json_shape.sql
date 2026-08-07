-- Migration 049: Fix object-shaped answers_json rows and prevent recurrence (KO-REPLAY-001)
--
-- Five production lesson_attempts rows stored answers_json = '{}' (object).
-- getRecentAttemptVariantIds iterated rows with `for...of`, which throws on a
-- non-array and left the lesson player stuck on "Loading lesson…" for any user
-- replaying a completed lesson.

BEGIN;

UPDATE lesson_attempts
SET answers_json = '[]'::jsonb
WHERE answers_json IS NOT NULL
  AND jsonb_typeof(answers_json) <> 'array';

ALTER TABLE lesson_attempts
  ADD CONSTRAINT lesson_attempts_answers_json_is_array
  CHECK (answers_json IS NULL OR jsonb_typeof(answers_json) = 'array');

COMMIT;
