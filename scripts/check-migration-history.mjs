import { execFileSync } from "node:child_process";

const baseRef = process.env.MIGRATION_BASE_REF;

if (!baseRef) {
  console.log("[migration-history] skipped: MIGRATION_BASE_REF is not set.");
  process.exit(0);
}

function git(...args) {
  return execFileSync("git", args, { encoding: "utf8" }).trim();
}

try {
  git("rev-parse", "--verify", `${baseRef}^{commit}`);
} catch {
  console.error(`[migration-history] base commit is unavailable: ${baseRef}`);
  process.exit(1);
}

const changes = git(
  "diff",
  "--name-status",
  "--find-renames",
  baseRef,
  "HEAD",
  "--",
  "supabase/migrations"
).split("\n").filter(Boolean);

const immutableHistoryViolations = changes.filter((change) => /^(D|R\d*\t)/.test(change));

if (immutableHistoryViolations.length > 0) {
  console.error("[migration-history] migrations are immutable; add a forward migration instead:");
  for (const violation of immutableHistoryViolations) console.error(`  ${violation}`);
  process.exit(1);
}

console.log(`[migration-history] pass: ${changes.length} migration change(s), no deletion or rename.`);
