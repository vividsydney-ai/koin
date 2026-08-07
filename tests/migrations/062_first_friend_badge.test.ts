import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";

const migration = readFileSync(
  resolve(
    process.cwd(),
    "supabase/migrations/20260728000000_backfill_first_friend_badges.sql",
  ),
  "utf8",
);

describe("KO-214 First Friend badge backfill", () => {
  it("backfills both participants in every accepted friendship", () => {
    expect(migration).toContain("WHERE status = 'accepted'");
    expect(migration).toContain("SELECT requester_id AS user_id");
    expect(migration).toContain("SELECT addressee_id AS user_id");
    expect(migration).toContain("WHERE b.slug = 'first_friend'");
    expect(migration).toContain("ON CONFLICT (user_id, badge_id) DO NOTHING");
  });

  it("awards future accepted friendships through an idempotent trigger", () => {
    expect(migration).toContain("CREATE TRIGGER friendships_award_first_friend_badge");
    expect(migration).toContain("AFTER INSERT OR UPDATE OF status ON public.friendships");
    expect(migration).toContain("PERFORM public.award_first_friend_badge(NEW.requester_id)");
    expect(migration).toContain("PERFORM public.award_first_friend_badge(NEW.addressee_id)");
  });

  it("keeps the helper functions internal", () => {
    expect(migration).toContain(
      "REVOKE ALL ON FUNCTION public.award_first_friend_badge(UUID) FROM PUBLIC, anon, authenticated",
    );
    expect(migration).toContain(
      "REVOKE ALL ON FUNCTION public.award_first_friend_badges_on_accept() FROM PUBLIC, anon, authenticated",
    );
  });
});
