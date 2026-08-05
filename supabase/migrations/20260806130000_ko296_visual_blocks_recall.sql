-- KO-296: reusable visual lesson blocks and private five-day recall state.
--
-- Published learning visuals are public read-only content. Recall questions and
-- answers remain server-scored: a learner can read only their own prompt state,
-- and the question answer key is never readable through the Data API.

BEGIN;

CREATE TABLE public.lesson_visual_blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  placement TEXT NOT NULL CHECK (placement IN ('concept', 'example')),
  block_type TEXT NOT NULL CHECK (block_type IN ('annotated_data', 'comparison', 'process', 'worked_example')),
  display_order SMALLINT NOT NULL DEFAULT 0 CHECK (display_order >= 0),
  data_status TEXT NOT NULL CHECK (data_status IN ('illustrative', 'source_derived', 'calculated')),
  content JSONB NOT NULL CHECK (jsonb_typeof(content) = 'object'),
  is_published BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (lesson_id, placement, display_order)
);

CREATE INDEX lesson_visual_blocks_published_lesson_idx
  ON public.lesson_visual_blocks (lesson_id, placement, display_order)
  WHERE is_published = TRUE;

CREATE TABLE public.lesson_visual_block_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visual_block_id UUID NOT NULL REFERENCES public.lesson_visual_blocks(id) ON DELETE CASCADE,
  source_id UUID NOT NULL REFERENCES public.sources(id) ON DELETE RESTRICT,
  citation_label TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (visual_block_id, source_id)
);

CREATE INDEX lesson_visual_block_sources_block_idx
  ON public.lesson_visual_block_sources (visual_block_id);

CREATE TABLE public.lesson_recall_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  question_en TEXT NOT NULL CHECK (length(trim(question_en)) > 0),
  question_id TEXT NOT NULL CHECK (length(trim(question_id)) > 0),
  options_en JSONB NOT NULL CHECK (jsonb_typeof(options_en) = 'array'),
  options_id JSONB NOT NULL CHECK (jsonb_typeof(options_id) = 'array'),
  correct_option TEXT NOT NULL CHECK (length(trim(correct_option)) > 0),
  explanation_en TEXT NOT NULL CHECK (length(trim(explanation_en)) > 0),
  explanation_id TEXT NOT NULL CHECK (length(trim(explanation_id)) > 0),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (lesson_id)
);

CREATE TABLE public.lesson_recall_prompts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  recall_question_id UUID NOT NULL REFERENCES public.lesson_recall_questions(id) ON DELETE CASCADE,
  due_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'dismissed', 'completed')),
  attempt_count SMALLINT NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
  first_attempt_correct BOOLEAN,
  last_attempt_correct BOOLEAN,
  dismissed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, lesson_id, recall_question_id)
);

CREATE INDEX lesson_recall_prompts_due_idx
  ON public.lesson_recall_prompts (user_id, due_at)
  WHERE status = 'pending';

ALTER TABLE public.lesson_visual_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_visual_block_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_recall_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_recall_prompts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Published visual blocks are readable"
  ON public.lesson_visual_blocks FOR SELECT
  TO anon, authenticated
  USING (
    is_published = TRUE
    AND EXISTS (
      SELECT 1
      FROM public.lessons
      WHERE lessons.id = lesson_visual_blocks.lesson_id
        AND lessons.is_published = TRUE
    )
  );

CREATE POLICY "Published visual block sources are readable"
  ON public.lesson_visual_block_sources FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.lesson_visual_blocks
      JOIN public.lessons ON lessons.id = lesson_visual_blocks.lesson_id
      WHERE lesson_visual_blocks.id = lesson_visual_block_sources.visual_block_id
        AND lesson_visual_blocks.is_published = TRUE
        AND lessons.is_published = TRUE
    )
  );

CREATE POLICY "Learners can read their own recall state"
  ON public.lesson_recall_prompts FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

GRANT SELECT ON public.lesson_visual_blocks, public.lesson_visual_block_sources TO anon, authenticated;
GRANT SELECT ON public.lesson_recall_prompts TO authenticated;

CREATE OR REPLACE FUNCTION public.schedule_lesson_recall_prompt()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_question_id UUID;
  v_due_at TIMESTAMPTZ;
BEGIN
  IF NEW.completed IS DISTINCT FROM TRUE OR NEW.completed_at IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT id INTO v_question_id
  FROM public.lesson_recall_questions
  WHERE lesson_id = NEW.lesson_id
    AND is_active = TRUE;

  IF v_question_id IS NULL THEN
    RETURN NEW;
  END IF;

  v_due_at := (((NEW.completed_at AT TIME ZONE 'Asia/Jakarta')::date + 5)::timestamp AT TIME ZONE 'Asia/Jakarta');

  INSERT INTO public.lesson_recall_prompts (user_id, lesson_id, recall_question_id, due_at)
  VALUES (NEW.user_id, NEW.lesson_id, v_question_id, v_due_at)
  ON CONFLICT (user_id, lesson_id, recall_question_id) DO NOTHING;

  RETURN NEW;
END;
$$;

CREATE TRIGGER schedule_lesson_recall_after_completion
  AFTER INSERT ON public.lesson_attempts
  FOR EACH ROW EXECUTE FUNCTION public.schedule_lesson_recall_prompt();

REVOKE ALL ON FUNCTION public.schedule_lesson_recall_prompt() FROM PUBLIC;

CREATE OR REPLACE FUNCTION public.get_due_lesson_recall_prompt()
RETURNS TABLE (
  prompt_id UUID,
  lesson_id UUID,
  due_at TIMESTAMPTZ,
  question_en TEXT,
  question_id TEXT,
  options_en JSONB,
  options_id JSONB
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    prompt.id,
    prompt.lesson_id,
    prompt.due_at,
    question.question_en,
    question.question_id,
    question.options_en,
    question.options_id
  FROM public.lesson_recall_prompts AS prompt
  JOIN public.lesson_recall_questions AS question ON question.id = prompt.recall_question_id
  WHERE prompt.user_id = (select auth.uid())
    AND prompt.status = 'pending'
    AND prompt.due_at <= NOW()
    AND question.is_active = TRUE
  ORDER BY prompt.due_at ASC
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.submit_lesson_recall_answer(
  p_prompt_id UUID,
  p_answer TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_prompt RECORD;
  v_question RECORD;
  v_correct BOOLEAN;
  v_first_attempt BOOLEAN;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT * INTO v_prompt
  FROM public.lesson_recall_prompts
  WHERE id = p_prompt_id
    AND user_id = (select auth.uid())
    AND status = 'pending'
    AND due_at <= NOW();

  IF v_prompt IS NULL THEN
    RAISE EXCEPTION 'Recall prompt is unavailable' USING ERRCODE = 'no_data_found';
  END IF;

  SELECT * INTO v_question
  FROM public.lesson_recall_questions
  WHERE id = v_prompt.recall_question_id
    AND is_active = TRUE;

  IF v_question IS NULL THEN
    RAISE EXCEPTION 'Recall question is unavailable' USING ERRCODE = 'no_data_found';
  END IF;

  v_correct := p_answer = v_question.correct_option;
  v_first_attempt := v_prompt.attempt_count = 0;

  UPDATE public.lesson_recall_prompts
  SET
    attempt_count = attempt_count + 1,
    first_attempt_correct = CASE WHEN v_first_attempt THEN v_correct ELSE first_attempt_correct END,
    last_attempt_correct = v_correct,
    status = CASE WHEN v_correct THEN 'completed' ELSE status END,
    completed_at = CASE WHEN v_correct THEN NOW() ELSE completed_at END,
    updated_at = NOW()
  WHERE id = v_prompt.id;

  RETURN jsonb_build_object(
    'correct', v_correct,
    'complete', v_correct,
    'attempt_count', v_prompt.attempt_count + 1,
    'explanation_en', v_question.explanation_en,
    'explanation_id', v_question.explanation_id
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.dismiss_lesson_recall_prompt(p_prompt_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.lesson_recall_prompts
  SET status = 'dismissed', dismissed_at = NOW(), updated_at = NOW()
  WHERE id = p_prompt_id
    AND user_id = (select auth.uid())
    AND status = 'pending';
END;
$$;

REVOKE ALL ON FUNCTION public.get_due_lesson_recall_prompt() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.submit_lesson_recall_answer(UUID, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.dismiss_lesson_recall_prompt(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_due_lesson_recall_prompt() TO authenticated;
GRANT EXECUTE ON FUNCTION public.submit_lesson_recall_answer(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.dismiss_lesson_recall_prompt(UUID) TO authenticated;

COMMIT;
