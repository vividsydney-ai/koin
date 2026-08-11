#!/usr/bin/env bash

# Deterministic local counterpart to the CI quality gate. Keep credentialed
# Supabase smoke tests in `pnpm test:live`; this command must be safe to run
# from an isolated Loop worktree without production credentials.
set -euo pipefail

run() {
  printf '\n[loop:gates] %s\n' "$*"
  "$@"
}

run pnpm run type-check
run pnpm run lint
run pnpm run test
printf '\n[loop:gates] pnpm run test:migration-history (base: %s)\n' "${MIGRATION_BASE_REF:-origin/web-koinaku}"
MIGRATION_BASE_REF="${MIGRATION_BASE_REF:-origin/web-koinaku}" pnpm run test:migration-history

printf '\n[loop:gates] pnpm run build (CI-safe Supabase placeholders)\n'
NEXT_PUBLIC_SUPABASE_URL="https://ci-build.supabase.co" \
NEXT_PUBLIC_SUPABASE_ANON_KEY="ci-build-anon-key" \
  pnpm run build

run pnpm run test:clean-worktree

printf '\n[loop:gates] pass\n'
