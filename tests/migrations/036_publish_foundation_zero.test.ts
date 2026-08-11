import { describe, it, expect, beforeAll } from "vitest";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const skipReason =
  !supabaseUrl || !supabaseKey
    ? "NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not set"
    : null;

describe.runIf(!skipReason)("Publish Foundation 0 (KO-FOUND-002)", () => {
  const supabase = skipReason ? null : createClient(supabaseUrl!, supabaseKey!);

  beforeAll(async () => {
    // Tests assume `supabase db reset` has been run or all migrations are applied.
  });

  it("publishes all 12 Foundation 0 lessons", async () => {
    const { data, error } = await supabase!
      .from("lessons")
      .select("slug, is_published")
      .like("slug", "fz-%");

    expect(error).toBeNull();
    expect(data).toHaveLength(12);
    expect(data!.every((l) => l.is_published === true)).toBe(true);
  });
});

describe.skipIf(!skipReason)("Publish Foundation 0", () => {
  it.skip(skipReason ?? "skipped", () => {});
});
