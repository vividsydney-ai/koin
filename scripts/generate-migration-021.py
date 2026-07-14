#!/usr/bin/env python3
"""Generate Migration 021: import advanced lessons v2 content from content-lessons/."""

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONTENT_DIR = Path("/Users/vividm4/Documents/Projects/Side-Gigs/Koin/content-lessons")
MIGRATIONS_DIR = ROOT / "supabase" / "migrations"

# Map the fixed beginner-lesson IDs used in the generated variants to canonical slugs.
BEGINNER_ID_TO_SLUG = {
    "0fa42c9f-66b9-42c1-b622-9f194a505a06": "money-basics-101",
    "ef1869f8-82e4-4ced-9b9e-e79fcb79972": "inflation-101",  # typo in generated CSV
    "ef1869f8-82e4-4ced-9b9e-e79fcb799b72": "inflation-101",  # correct remote ID
    "fb9f7f07-c324-4054-8fb7-e38bec2f847c": "budgeting-101",
    "e81a8f71-77ab-44ca-b48f-a0e985313e33": "risk-return-101",
    "b4a1a53f-efd6-4e2a-b3a4-58bb7afd9311": "idx-basics-101",
}

PREREQ_SLUG_BY_ADVANCED_SLUG = {
    "money_basics-advanced": "money-basics-101",
    "inflation-advanced": "inflation-101",
    "budgeting-advanced": "budgeting-101",
    "risk_return-advanced": "risk-return-101",
    "idx_basics-advanced": "idx-basics-101",
    "behavioral_finance-advanced": "volatility-101",
}


def pg_literal(value: str) -> str:
    """Escape a string for PostgreSQL single-quoted literal."""
    return value.replace("'", "''")


def generate_lessons() -> str:
    rows = []
    with open(CONTENT_DIR / "koin_advanced_lessons_v2.csv", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            slug = row["slug"]
            topic_slug = slug.replace("-advanced", "").replace("_", "_")  # e.g. money_basics
            # Normalize topic slugs to match DB
            topic_slug = topic_slug.replace("risk_return", "risk_return").replace("idx_basics", "idx_basics").replace("behavioral_finance", "behavioral_finance")
            prereq_slug = PREREQ_SLUG_BY_ADVANCED_SLUG[slug]
            rows.append(
                f"  ('{row['id']}', '{pg_literal(slug)}', '{pg_literal(row['title'])}', "
                f"'{pg_literal(row['title_id'])}', "
                f"(SELECT id FROM topics WHERE slug = '{topic_slug}'), "
                f"{row['lesson_number']}, '{row['difficulty']}', {row['xp_reward']}, {row['estimated_minutes']}, "
                f"'{pg_literal(row['summary'])}', '{pg_literal(row['concept_body'])}', "
                f"'{pg_literal(row['indonesian_example'])}', '{pg_literal(row['why_this_matters'])}', "
                f"'{pg_literal(row['common_mistake'])}', "
                f"{('NULL' if not row['quiz_data'] else f"'{pg_literal(row['quiz_data'])}'::jsonb")}, "
                f"'{pg_literal(row['ai_assist_context'])}', '{row['review_status']}', "
                f"{('NULL' if not row['reviewed_by'] else f"'{pg_literal(row['reviewed_by'])}'")}, "
                f"{('NULL' if not row['reviewed_at'] else f"'{row['reviewed_at']}'::timestamptz")}, "
                f"{row['is_published'].lower()}, '{row['jurisdiction']}', "
                f"(SELECT id FROM lessons WHERE slug = '{prereq_slug}'), "
                f"'{row['created_at']}'::timestamptz, '{row['updated_at']}'::timestamptz)"
            )
    values = ",\n".join(rows)
    return f"""-- Advanced lessons 10-15
INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction,
  prerequisite_lesson_id, created_at, updated_at
) VALUES
{values}
ON CONFLICT (id) DO NOTHING;
"""


def generate_variants() -> str:
    values = []
    with open(CONTENT_DIR / "koin_content_variants_v2.csv", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            lesson_slug = BEGINNER_ID_TO_SLUG.get(row["lesson_id"])
            if not lesson_slug:
                # Skip variants whose lesson_id cannot be mapped.
                continue
            body = row["body_json"]
            diff = row["difficulty"] or "beginner"
            topic_tag = row["topic"] or ""
            is_active = "true" if row["is_active"].lower() == "true" else "false"
            created_at = row["created_at"]
            values.append(
                f"  ('{pg_literal(lesson_slug)}', '{row['variant_type']}', '{pg_literal(body)}'::jsonb, "
                f"'{diff}', '{pg_literal(topic_tag)}', {is_active}, '{created_at}'::timestamptz)"
            )
    chunks = [values[i : i + 500] for i in range(0, len(values), 500)]
    parts = []
    for idx, chunk in enumerate(chunks):
        cte_values = ",\n".join(chunk)
        parts.append(
            f"""-- Content variants chunk {idx + 1}
WITH v(lesson_slug, variant_type, body, difficulty, topic_tag, is_active, created_at) AS (VALUES
{cte_values}
)
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active, created_at)
SELECT gen_random_uuid(), l.id, v.variant_type, v.body, v.difficulty, v.topic_tag, v.is_active, v.created_at
FROM v
JOIN lessons l ON l.slug = v.lesson_slug;
"""
        )
    return "\n".join(parts)


def generate_resources() -> str:
    values = []
    with open(CONTENT_DIR / "koin_recommended_resources_v2.csv", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Map advanced lesson id to slug so the insert works on any DB.
            advanced_id = row["lesson_id"]
            # We will build a temp lookup in SQL below instead of hardcoding all ids here.
            values.append(
                f"  ('{advanced_id}', '{pg_literal(row['title'])}', '{pg_literal(row['title_id'])}', "
                f"'{row['resource_type']}', '{pg_literal(row['url'])}', '{pg_literal(row['description'])}', "
                f"'{pg_literal(row['description_id'])}', {row['display_order']})"
            )
    cte_values = ",\n".join(values)
    return f"""-- Recommended resources (kept inactive until real URLs are verified)
WITH r(lesson_id, title, title_id, resource_type, url, description, description_id, display_order) AS (VALUES
{cte_values}
)
INSERT INTO recommended_resources (id, lesson_id, title, title_id, resource_type, url, description, description_id, display_order, is_active)
SELECT gen_random_uuid(), l.id, r.title, r.title_id, r.resource_type, r.url, r.description, r.description_id, r.display_order, FALSE
FROM r
JOIN lessons l ON l.id = r.lesson_id::uuid;
"""


def generate_media() -> str:
    values = []
    with open(CONTENT_DIR / "koin_lesson_media_v2.csv", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            values.append(
                f"  ('{row['lesson_id']}', '{row['media_type']}', '{pg_literal(row['url'])}', "
                f"'{pg_literal(row['alt_text'])}', {row['display_order']})"
            )
    cte_values = ",\n".join(values)
    return f"""-- Lesson media (kept inactive until CDN assets are uploaded)
WITH m(lesson_id, media_type, url, alt_text, display_order) AS (VALUES
{cte_values}
)
INSERT INTO lesson_media (id, lesson_id, media_type, url, alt_text, display_order, is_active)
SELECT gen_random_uuid(), l.id, m.media_type, m.url, m.alt_text, m.display_order, FALSE
FROM m
JOIN lessons l ON l.id = m.lesson_id::uuid;
"""


def main() -> None:
    MIGRATIONS_DIR.mkdir(parents=True, exist_ok=True)
    migration_path = MIGRATIONS_DIR / "20260714000021_import_advanced_lessons_v2.sql"
    sql = f"""-- Migration 021: Import advanced lessons v2 content
-- Source: /Users/vividm4/Documents/Projects/Side-Gigs/Koin/content-lessons/
-- Notes:
--   - Maps topic and prerequisite IDs by slug so this works on local and remote DBs.
--   - Fixes the inflation-advanced prerequisite typo from the generated SQL.
--   - Keeps recommended_resources and lesson_media inactive until URLs/assets are verified.
--   - All new lessons are inserted as draft / unpublished pending content review.

{generate_lessons()}

{generate_variants()}

{generate_resources()}

{generate_media()}
"""
    migration_path.write_text(sql, encoding="utf-8")
    print(f"Wrote {migration_path}")


if __name__ == "__main__":
    main()
