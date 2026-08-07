-- KO-LESSON-004: Deduplicate sources that were seeded twice with different codes.
-- Keeps the canonical code for each URL and merges duplicate rows so the Library
-- does not show identical cards and downstream synopses only need one update.
--
-- Canonical -> duplicate pairs:
--   OJK-004 -> OJK-006
--   IDX-001 -> IDX-009
--   IDX-002 -> IDX-011
--   IDX-005 -> IDX-012
--   IDX-007 -> IDX-010

DO $$
DECLARE
  v_ojk004 UUID := '47189cc8-8e51-4890-ace4-3f30b913f5ee';
  v_ojk006 UUID := 'f7003b72-8158-4a9e-a853-1c3bf914ea4a';
  v_idx001 UUID := 'c7c57d03-733f-4fe8-bd15-ce3a1cd4a760';
  v_idx009 UUID := 'a91d7e96-838d-4544-a9b7-b55f138690c0';
  v_idx002 UUID := '58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38';
  v_idx011 UUID := 'e26823e2-166c-4a51-9554-cbe1d6909f8d';
  v_idx005 UUID := '52aff5b9-0d1c-42d8-8dba-a1a97a3f3b3f';
  v_idx012 UUID := 'fa8f64e4-33eb-46fb-bd73-87ed31050b41';
  v_idx007 UUID := '5fa2799e-2b92-46e8-b68a-c9d64847410c';
  v_idx010 UUID := '39580cb7-5138-4371-a9c7-92b611b3815b';
BEGIN
  -- Point lesson_sources references to the canonical source rows.
  UPDATE lesson_sources SET source_id = v_ojk004 WHERE source_id = v_ojk006;

  -- Rewrite source_ids arrays inside content_variants so they reference canonical IDs.
  UPDATE content_variants
  SET body = jsonb_set(
    body,
    '{source_ids}',
    (
      SELECT COALESCE(jsonb_agg(DISTINCT
        CASE elem::text
          WHEN v_ojk006::text THEN v_ojk004::text
          WHEN v_idx009::text THEN v_idx001::text
          WHEN v_idx011::text THEN v_idx002::text
          WHEN v_idx012::text THEN v_idx005::text
          WHEN v_idx010::text THEN v_idx007::text
          ELSE elem::text
        END
      ), '[]'::jsonb)
      FROM jsonb_array_elements_text(body->'source_ids') elem
    )
  )
  WHERE body ? 'source_ids';

  -- Remove the duplicate source rows.
  DELETE FROM sources WHERE id IN (v_ojk006, v_idx009, v_idx010, v_idx011, v_idx012);
END $$;
