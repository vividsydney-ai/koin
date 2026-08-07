import { describe, it, expect, beforeAll } from "vitest";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const skipReason =
  !supabaseUrl || !supabaseKey
    ? "NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not set"
    : null;

describe.runIf(!skipReason)("Analytics views (KO-ANALYTICS-001)", () => {
  const supabase = createClient(supabaseUrl!, supabaseKey!);

  beforeAll(async () => {
    // Tests assume `supabase db reset` has been run or all migrations are applied.
  });

  it("exposes analytics_dau view", async () => {
    const { data, error } = await supabase
      .from("analytics_dau")
      .select("day, active_users")
      .limit(1);

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });

  it("exposes analytics_activation view", async () => {
    const { data, error } = await supabase
      .from("analytics_activation")
      .select("user_id, signup_date, activated_24h, activated_7d")
      .limit(1);

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });

  it("exposes analytics_retention view", async () => {
    const { data, error } = await supabase
      .from("analytics_retention")
      .select("cohort_week, cohort_size, d7_retention_pct, d30_retention_pct")
      .limit(1);

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });

  it("exposes analytics_lesson_completion view", async () => {
    const { data, error } = await supabase
      .from("analytics_lesson_completion")
      .select("day, lessons_started, lessons_completed, unique_users_completed")
      .limit(1);

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });

  it("exposes analytics_first_trade view", async () => {
    const { data, error } = await supabase
      .from("analytics_first_trade")
      .select("user_id, signup_date, first_trade_at, hours_to_first_trade")
      .limit(1);

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });
});

describe.skipIf(!skipReason)("Analytics views", () => {
  it.skip(skipReason ?? "skipped", () => {});
});
