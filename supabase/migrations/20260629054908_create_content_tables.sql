-- Migration 003: Content tables
-- Creates lessons, lesson versioning, sources, media, and recommended resources.
-- Lessons are public only when is_published = true; all other content tables are public read.

CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  topic_id UUID REFERENCES topics(id),
  lesson_number INTEGER UNIQUE NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner','intermediate','advanced')),
  xp_reward INTEGER NOT NULL DEFAULT 50,
  estimated_minutes INTEGER DEFAULT 5,
  summary TEXT,
  concept_body TEXT,
  indonesian_example TEXT,
  why_this_matters TEXT,
  common_mistake TEXT,
  quiz_data JSONB,
  ai_assist_context TEXT,
  review_status TEXT DEFAULT 'not_started'
    CHECK (review_status IN ('not_started','draft','needs_review','approved','live')),
  reviewed_by TEXT,
  reviewed_at TIMESTAMPTZ,
  is_published BOOLEAN DEFAULT FALSE,
  jurisdiction TEXT DEFAULT 'ID',
  prerequisite_lesson_id UUID REFERENCES lessons(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lessons IS 'Core lesson content. Public read only where is_published = true.';

CREATE TABLE lesson_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  summary TEXT,
  concept_body TEXT,
  indonesian_example TEXT,
  why_this_matters TEXT,
  common_mistake TEXT,
  quiz_data JSONB,
  ai_assist_context TEXT,
  review_status TEXT DEFAULT 'not_started'
    CHECK (review_status IN ('not_started','draft','needs_review','approved','live')),
  reviewed_by TEXT,
  reviewed_at TIMESTAMPTZ,
  is_published BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lesson_id, version_number)
);

COMMENT ON TABLE lesson_versions IS 'Historical versions of lesson content for audit and rollback. Admin write; public read where published.';

CREATE TABLE sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_code TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  local_title TEXT,
  source_tier INTEGER NOT NULL CHECK (source_tier IN (1,2,3)),
  source_type TEXT NOT NULL,
  organization TEXT NOT NULL,
  url TEXT,
  isbn TEXT,
  language TEXT DEFAULT 'id',
  publication_year INTEGER,
  trust_notes TEXT,
  localization_notes TEXT,
  last_checked_at TIMESTAMPTZ,
  status TEXT DEFAULT 'needs_review' CHECK (status IN ('verified','needs_review','use_carefully','deprecated')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE sources IS 'External reference sources with tier and verification status. Public read.';

CREATE TABLE lesson_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  source_id UUID NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  relevance_type TEXT DEFAULT 'primary' CHECK (relevance_type IN ('primary','supporting','further_reading')),
  citation_label TEXT,
  is_primary BOOLEAN DEFAULT FALSE,
  display_order INTEGER DEFAULT 0,
  UNIQUE(lesson_id, source_id)
);

COMMENT ON TABLE lesson_sources IS 'Junction linking lessons to trusted sources. Public read.';

CREATE TABLE lesson_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  media_type TEXT NOT NULL CHECK (media_type IN ('image','video','audio','diagram')),
  url TEXT NOT NULL,
  alt_text TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_media IS 'Media attachments for lessons. Public read where is_active = true.';

CREATE TABLE recommended_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  resource_type TEXT NOT NULL CHECK (resource_type IN ('article','video','book','podcast','tool','website')),
  url TEXT,
  description TEXT,
  description_id TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE recommended_resources IS 'Curated further-reading resources per lesson. Public read where is_active = true.';

-- RLS: lessons are readable by anyone when published; only service/admin can write.
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read published lessons"
  ON lessons FOR SELECT
  USING (is_published = TRUE);

COMMENT ON POLICY "Public read published lessons" ON lessons IS 'Any user can read lessons that have been published.';

-- RLS: lesson_versions readable by anyone when published; admin/service writes.
ALTER TABLE lesson_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read published lesson versions"
  ON lesson_versions FOR SELECT
  USING (is_published = TRUE);

COMMENT ON POLICY "Public read published lesson versions" ON lesson_versions IS 'Any user can read published lesson versions.';
