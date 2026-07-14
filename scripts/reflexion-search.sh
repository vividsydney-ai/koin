#!/usr/bin/env bash
# Search the reflexion DB by tag or keyword.
# Usage: scripts/reflexion-search.sh <tag|keyword>

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT"

QUERY="${1:-}"
if [[ -z "$QUERY" ]]; then
  echo "Usage: $0 <tag|keyword>"
  exit 1
fi

echo "Searching .loop/reflexion for: $QUERY"
echo ""

# Search tags and titles in markdown files
find .loop/reflexion -type f -name "*.md" | while read -r f; do
  if grep -qi "$QUERY" "$f"; then
    echo "--- $f ---"
    grep -ni "$QUERY" "$f" | head -5
  fi
done

# Also search the JSON index if it has entries
if [[ -f ".loop/reflexion/index.json" ]]; then
  echo ""
  echo "Index entries matching '$QUERY':"
  grep -i "$QUERY" .loop/reflexion/index.json || true
fi
