import { describe, it, expect, beforeAll } from "vitest";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const skipReason =
  !supabaseUrl || !supabaseKey
    ? "NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not set"
    : null;

describe.runIf(!skipReason)("Foundation 0 mini-track (KO-FOUND-001)", () => {
  const supabase = createClient(supabaseUrl!, supabaseKey!);

  beforeAll(async () => {
    // Ensure the schema is current by re-running migrations locally.
    // Tests assume `supabase db reset` has been run or migrations are applied.
  });

  it("has a foundation_zero topic", async () => {
    const { data, error } = await supabase
      .from("topics")
      .select("id, slug, display_order")
      .eq("slug", "foundation_zero")
      .single();

    expect(error).toBeNull();
    expect(data).not.toBeNull();
    expect(data!.display_order).toBe(1);
  });

  it("has 12 Foundation 0 lessons with lesson_number 1-12", async () => {
    const { data, error } = await supabase
      .from("lessons")
      .select("slug, lesson_number, topic_id")
      .like("slug", "fz-%")
      .order("lesson_number");

    expect(error).toBeNull();
    expect(data).toHaveLength(12);

    const numbers = data!.map((l) => l.lesson_number);
    expect(numbers).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
  });

  it("every Foundation 0 lesson has a primary Tier 1 source", async () => {
    const { data: lessons, error: lessonsError } = await supabase
      .from("lessons")
      .select("id, slug")
      .like("slug", "fz-%");

    expect(lessonsError).toBeNull();
    expect(lessons).toHaveLength(12);

    for (const lesson of lessons!) {
      const { data, error } = await supabase
        .from("lesson_sources")
        .select("id, source_id, is_primary")
        .eq("lesson_id", lesson.id)
        .eq("is_primary", true)
        .single();

      expect(error, `lesson ${lesson.slug} missing primary source`).toBeNull();
      expect(data).not.toBeNull();
      expect(data?.is_primary).toBe(true);
    }
  });

  it("every Foundation 0 lesson has an approved review", async () => {
    const { data: lessons, error: lessonsError } = await supabase
      .from("lessons")
      .select("id, slug")
      .like("slug", "fz-%");

    expect(lessonsError).toBeNull();
    expect(lessons).toHaveLength(12);

    for (const lesson of lessons!) {
      const { data, error } = await supabase
        .from("lesson_reviews")
        .select("approved_to_publish")
        .eq("lesson_id", lesson.id)
        .eq("approved_to_publish", true)
        .single();

      expect(error, `lesson ${lesson.slug} missing approved review`).toBeNull();
      expect(data?.approved_to_publish).toBe(true);
    }
  });

  it("renumbered main track lessons to 14-45 to make room for Foundation 0", async () => {
    const { data, error } = await supabase
      .from("lessons")
      .select("lesson_number, slug")
      .not("slug", "like", "fz-%")
      .gte("lesson_number", 14)
      .lte("lesson_number", 45)
      .order("lesson_number");

    expect(error).toBeNull();
    expect(data).toHaveLength(32);

    const numbers = data!.map((l) => l.lesson_number);
    expect(numbers).toEqual(Array.from({ length: 32 }, (_, i) => i + 14));
  });

  it("Foundation 0 lessons are unpublished by default", async () => {
    const { data, error } = await supabase
      .from("lessons")
      .select("is_published")
      .like("slug", "fz-%");

    expect(error).toBeNull();
    expect(data).toHaveLength(12);
    expect(data!.every((l) => l.is_published === false)).toBe(true);
  });
});

describe.skipIf(!skipReason)("Foundation 0 mini-track", () => {
  it.skip(skipReason ?? "skipped", () => {});
});
