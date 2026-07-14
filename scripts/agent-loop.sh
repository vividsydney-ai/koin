#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

AGENT="${LOOP_AGENT:-}"
PRINT_ONLY=0
ITERATIONS="${LOOP_ITERATIONS:-1}"
TASK="${LOOP_TASK:-}"

usage() {
  printf '%s\n' "Usage: scripts/agent-loop.sh [--agent codex|claude|kimi] [--print] [--iterations N]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agent)
      AGENT="${2:-}"
      shift 2
      ;;
    --print|--print-prompt)
      PRINT_ONLY=1
      shift
      ;;
    --iterations)
      ITERATIONS="${2:-1}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$TASK" ]; then
  TASK="$(awk '/^- \[ \]/ { sub(/^- \[ \] /, ""); print; exit }' TASKS.md || true)"
fi

if [ -z "$TASK" ]; then
  echo "No unchecked TASKS.md task found. Set LOOP_TASK to run an explicit task." >&2
  exit 1
fi

BRANCH="$(git branch --show-current 2>/dev/null || echo unknown)"
RUN_ID="$(date +%Y%m%d-%H%M%S)"
RUN_LOG=".loop/runs/${RUN_ID}-${AGENT:-prompt}.log"
ORCHESTRATOR="$(sed -n '1,240p' .loop/prompts/orchestrator.md)"

PROMPT="$ORCHESTRATOR

## Runtime Context

- Repo root: $ROOT
- Current branch: $BRANCH
- Selected task: $TASK
- Max outer invocations from script: $ITERATIONS
- Run log path: $RUN_LOG

Use the repo's current files as source of truth. Do not assume branch names from older handoff docs are current."

if [ "$PRINT_ONLY" -eq 1 ] || [ -z "$AGENT" ]; then
  printf '%s\n' "$PROMPT"
  exit 0
fi

mkdir -p .loop/runs

run_agent_once() {
  case "$AGENT" in
    codex)
      command -v codex >/dev/null || { echo "codex CLI not found" >&2; return 127; }
      printf '%s\n' "$PROMPT" | codex -a never exec -C "$ROOT" -s workspace-write -
      ;;
    claude)
      command -v claude >/dev/null || { echo "claude CLI not found" >&2; return 127; }
      claude -p "$PROMPT"
      ;;
    kimi)
      command -v kimi >/dev/null || { echo "kimi CLI not found" >&2; return 127; }
      kimi -p "$PROMPT"
      ;;
    *)
      echo "Unsupported agent: $AGENT" >&2
      return 2
      ;;
  esac
}

for i in $(seq 1 "$ITERATIONS"); do
  {
    echo "== loop invocation $i/$ITERATIONS =="
    echo "agent: $AGENT"
    echo "task: $TASK"
    run_agent_once
  } 2>&1 | tee -a "$RUN_LOG"

  if grep -qE "LOOP_DONE|LOOP_BLOCKED" "$RUN_LOG"; then
    break
  fi
done

echo "loop log: $RUN_LOG"
