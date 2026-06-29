-- Migration 014: Content variants
-- Pools of alternative examples, questions, and explanations used by the lesson player.
-- Public read where is_active = true and parent lesson is published.

CREATE TABLE content_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  variant_type TEXT NOT NULL CHECK (variant_type IN ('example','question','explanation')),
  body JSONB NOT NULL,
  difficulty TEXT CHECK (difficulty IN ('beginner','intermediate','advanced')),
  topic_tag TEXT,
  usage_count INTEGER DEFAULT 0,
  last_used_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE content_variants IS 'Alternative lesson content (examples, questions, explanations). Public read where is_active = true and parent lesson is_published = true.';

CREATE INDEX idx_content_variants_lesson_active ON content_variants(lesson_id, variant_type, is_active);
CREATE INDEX idx_content_variants_difficulty ON content_variants(difficulty, is_active);

-- RLS: public read only when active and parent lesson is published
ALTER TABLE content_variants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read active content_variants for published lessons"
  ON content_variants FOR SELECT
  USING (
    is_active = TRUE
    AND EXISTS (
      SELECT 1 FROM lessons
      WHERE lessons.id = content_variants.lesson_id
        AND lessons.is_published = TRUE
    )
  );

COMMENT ON POLICY "Public read active content_variants for published lessons" ON content_variants IS 'Anyone can read active content variants whose parent lesson is published.';
