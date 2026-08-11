import { execFileSync } from "node:child_process";

const changes = execFileSync(
  "git",
  ["status", "--porcelain", "--untracked-files=no"],
  { encoding: "utf8" }
).trim();

if (changes) {
  console.error("[clean-worktree] tracked files changed during verification:");
  console.error(changes);
  process.exit(1);
}

console.log("[clean-worktree] pass: no tracked-file changes.");
