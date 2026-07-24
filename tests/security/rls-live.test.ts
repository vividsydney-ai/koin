import { describe, it, expect } from "vitest";
import { readFileSync, readdirSync } from "fs";
import { resolve } from "path";

const MIGRATIONS_DIR = resolve(__dirname, "../../supabase/migrations");

const USER_SENSITIVE_TABLES = [
  "profiles",
  "user_settings",
  "lesson_attempts",
  "lesson_progress",
  "streaks",
  "streak_events",
  "user_badges",
  "xp_events",
  "koin_point_balances",
  "koin_point_transactions",
  "friendships",
  "friend_invites",
  "cohort_memberships",
  "portfolios",
  "holdings",
  "trades",
  "watchlists",
  "user_risk_profiles",
  "analytics_events",
  "notifications_queue",
];

function loadAllMigrations(): string {
  const files = readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith(".sql"))
    .sort();
  return files.map((f) => readFileSync(resolve(MIGRATIONS_DIR, f), "utf-8")).join("\n");
}

describe("comprehensive RLS migration audit", () => {
  const allSql = loadAllMigrations();

  it.each(USER_SENSITIVE_TABLES)("%s has RLS enabled in migrations", (table) => {
    expect(allSql.toLowerCase()).toContain(`alter table ${table} enable row level security`);
  });

  it.each(USER_SENSITIVE_TABLES)("%s has at least one policy scoped to auth.uid()", (table) => {
    // Find policy blocks for this table and ensure at least one references auth.uid().
    const policyRegex = new RegExp(
      `create policy[^;]*on\\s+${table}[^;]*auth\\.uid\\(\\)`,
      "is"
    );
    expect(allSql).toMatch(policyRegex);
  });
});
