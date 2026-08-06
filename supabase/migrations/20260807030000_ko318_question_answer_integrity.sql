-- KO-318: repair selectable-question payloads whose stored answer is not one
-- of the visible choices. The mapping preserves option order across the
-- English and Indonesian payloads, so learners are never marked wrong for
-- selecting a visible correct choice.

BEGIN;

DO $$
DECLARE
  row_data RECORD;
  mapped_answer jsonb;
BEGIN
  FOR row_data IN
    SELECT id, body, body_id
    FROM public.content_variants
    WHERE variant_type = 'question'
      AND is_active = true
      AND body IS NOT NULL
  LOOP
    -- Multiple-choice payloads must point at a visible option. The affected
    -- release rows all intentionally put the correct option first while
    -- their shorter answer string was left behind.
    IF row_data.body->>'type' IN ('multiple_choice', 'scenario', 'comparison', 'sentence_completion', 'image_interpretation', 'decision_tree')
      AND jsonb_typeof(row_data.body->'options') = 'array'
      AND NOT EXISTS (
        SELECT 1
        FROM jsonb_array_elements_text(row_data.body->'options') AS option(value)
        WHERE trim(regexp_replace(lower(option.value), '[.,!?;:]', '', 'g')) = trim(regexp_replace(lower(row_data.body->>'answer'), '[.,!?;:]', '', 'g'))
      )
    THEN
      row_data.body := jsonb_set(row_data.body, '{answer}', row_data.body->'options'->0, true);
    END IF;

    IF row_data.body_id IS NOT NULL
      AND row_data.body_id->>'type' IN ('multiple_choice', 'scenario', 'comparison', 'sentence_completion', 'image_interpretation', 'decision_tree')
      AND jsonb_typeof(row_data.body_id->'options') = 'array'
      AND NOT EXISTS (
        SELECT 1
        FROM jsonb_array_elements_text(row_data.body_id->'options') AS option(value)
        WHERE trim(regexp_replace(lower(option.value), '[.,!?;:]', '', 'g')) = trim(regexp_replace(lower(row_data.body_id->>'answer'), '[.,!?;:]', '', 'g'))
      )
    THEN
      row_data.body_id := jsonb_set(row_data.body_id, '{answer}', row_data.body_id->'options'->0, true);
    END IF;

    -- Word-bank and ordering answers are translated by option position. Map
    -- each English answer to the Indonesian option at the same position.
    IF row_data.body_id IS NOT NULL
      AND row_data.body->>'type' IN ('word_bank', 'ordering')
      AND jsonb_typeof(row_data.body->'answer') = 'array'
      AND jsonb_typeof(row_data.body->'options') = 'array'
      AND jsonb_typeof(row_data.body_id->'answer') = 'array'
      AND jsonb_typeof(row_data.body_id->'options') = 'array'
      AND EXISTS (
        SELECT 1
        FROM jsonb_array_elements_text(row_data.body_id->'answer') AS answer(value)
        WHERE NOT EXISTS (
          SELECT 1
          FROM jsonb_array_elements_text(row_data.body_id->'options') AS option(value)
          WHERE option.value = answer.value
        )
      )
    THEN
      SELECT jsonb_agg(to_jsonb(COALESCE(mapped.value, english_answer.value)) ORDER BY english_answer.ordinality)
      INTO mapped_answer
      FROM jsonb_array_elements_text(row_data.body->'answer') WITH ORDINALITY AS english_answer(value, ordinality)
      LEFT JOIN LATERAL (
        SELECT translated_option.value
        FROM jsonb_array_elements_text(row_data.body->'options') WITH ORDINALITY AS english_option(value, ordinality)
        JOIN jsonb_array_elements_text(row_data.body_id->'options') WITH ORDINALITY AS translated_option(value, ordinality)
          ON translated_option.ordinality = english_option.ordinality
        WHERE english_option.value = english_answer.value
        LIMIT 1
      ) AS mapped ON true;

      IF mapped_answer IS NOT NULL THEN
        row_data.body_id := jsonb_set(row_data.body_id, '{answer}', mapped_answer, true);
      END IF;
    END IF;

    UPDATE public.content_variants
    SET body = row_data.body,
        body_id = row_data.body_id
    WHERE id = row_data.id;
  END LOOP;
END $$;

COMMIT;
