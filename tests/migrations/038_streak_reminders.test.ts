import { describe, it, expect, beforeAll } from "vitest";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const skipReason =
  !supabaseUrl || !supabaseKey
    ? "NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not set"
    : null;

describe.runIf(!skipReason)("Streak reminder infrastructure (KO-NOTIF-001)", () => {
  const supabase = skipReason ? null : createClient(supabaseUrl!, supabaseKey!);

  beforeAll(async () => {
    // Tests assume `supabase db reset` has been run or all migrations are applied.
  });

  it("exposes get_streak_reminder_candidates RPC", async () => {
    const { data, error } = await supabase!.rpc("get_streak_reminder_candidates", {
      p_current_time: "23:59:00",
    });

    expect(error).toBeNull();
    expect(data).toBeInstanceOf(Array);
  });

});

describe.skipIf(!skipReason)("Streak reminder infrastructure", () => {
  it.skip(skipReason ?? "skipped", () => {});
});
