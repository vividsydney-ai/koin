#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
PUBLISH_SCAN_FILE="$(mktemp -t koin-loop-publish-scan.XXXXXX)"
trap 'rm -f "$PUBLISH_SCAN_FILE"' EXIT

echo "== loop verifier =="
echo "root: $ROOT"
echo "branch: $(git branch --show-current 2>/dev/null || echo unknown)"

if git diff --cached --quiet -- . && git diff --quiet -- .; then
  echo "diff: clean"
else
  echo "diff: present"
fi

echo "== forbidden browser storage scan =="
changed_files="$(
  {
    git diff --name-only --cached
    git diff --name-only
    git ls-files --others --exclude-standard
  } | sed '/^$/d' | sort -u | grep -E '\.(ts|tsx|js|jsx|mjs|cjs|json|sql)$' || true
)"

if [ -n "$changed_files" ]; then
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    case "$file" in
      package-lock.json|pnpm-lock.yaml)
        continue
        ;;
    esac
    if grep -nE 'localStorage|sessionStorage' "$file"; then
      echo "ERROR: forbidden localStorage/sessionStorage found in changed file: $file"
      exit 1
    fi
  done <<< "$changed_files"
fi
echo "storage scan: clean"

echo "== migration RLS scan =="
changed_migrations="$(
  {
    git diff --name-only --cached -- supabase/migrations
    git diff --name-only -- supabase/migrations
    git ls-files --others --exclude-standard -- supabase/migrations
  } | sed '/^$/d' | sort -u
)"
if [ -n "$changed_migrations" ]; then
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    if grep -qiE 'create table|create policy|alter table' "$file" && ! grep -qiE 'enable row level security|rls' "$file"; then
      echo "ERROR: migration may be missing RLS language: $file"
      exit 1
    fi
  done <<< "$changed_migrations"
  echo "migration scan: checked"
else
  echo "migration scan: no changed migrations"
fi

echo "== publish compliance scan =="
if [ -n "$changed_files" ]; then
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    if grep -niE 'is_published[[:space:]]*[:=][[:space:]]*true' "$file" >"$PUBLISH_SCAN_FILE"; then
      if ! grep -niE 'approved_to_publish|lesson_reviews' "$file" >/dev/null; then
        cat "$PUBLISH_SCAN_FILE"
        echo "ERROR: publish flag appears without review approval context in changed file: $file"
        exit 1
      fi
    fi
  done <<< "$changed_files"
fi
echo "publish scan: clean"

echo "loop verifier: passed"
