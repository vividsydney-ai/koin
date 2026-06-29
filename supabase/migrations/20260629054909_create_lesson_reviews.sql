-- Migration 004: Lesson reviews
-- Editorial review workflow for lesson fact-checking and approval.
-- Admin only: normal users cannot read or write these rows.

CREATE TABLE lesson_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID UNIQUE NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  reviewer_name TEXT,
  reviewer_role TEXT,
  review_date DATE,
  factual_accuracy_status TEXT CHECK (factual_accuracy_status IN ('pass','issues','fail')),
  source_verification_status TEXT CHECK (source_verification_status IN ('pass','issues','fail')),
  indonesia_context_status TEXT CHECK (indonesia_context_status IN ('pass','issues','fail')),
  compliance_status TEXT CHECK (compliance_status IN ('pass','issues','fail')),
  notes TEXT,
  approved_to_publish BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_reviews IS 'Editorial review records for lessons. Admin only; no public read.';

-- RLS enabled with no policies: only service role / admin can access.
ALTER TABLE lesson_reviews ENABLE ROW LEVEL SECURITY;
