---
name: loop-graph
description: Run a Loop Engineering v2 task as a graph of parallel subagents. Use when the task is wide, verifiable, and can be split into independent sub-tasks (audits, sweeps, multi-angle reviews, Wayfinder map execution).
disable-model-invocation: false
---

# Loop + Graph Engineering

This skill combines Loop Engineering v2 with Graph Engineering: instead of one agent walking a linear plan, the orchestrator spawns parallel subagents, verifies their outputs, and synthesizes one result.

Use it when three or more of these are true:

- The task touches many files or concepts that can be checked independently.
- You want adversarial verification (find → refute → confirm).
- The same shape of work repeats (diff review, content audit, security sweep).
- A Wayfinder map has multiple unblocked decision tickets that can be resolved in parallel.

Do **not** use it for:

- Single-file fixes or one-bug patches.
- Tasks where every step genuinely depends on the previous step.
- Work that requires human approval at every micro-step.

## Authority order

Current human instruction → `RULES.md` → `STATE.md` → `AGENTS.md`/`CLAUDE.md`/`KIMI_HANDOFF.md` → `docs/agents/LOOP_ENGINEERING.md` → this skill → `TASKS.md`.

## Graph shape

Every `/loop-graph` run follows this shape:

```text
PLAN → CLAIM → FAN-OUT → VERIFY → SYNTHESIZE → LAND
```

### 1. Plan

Decompose the current task into 2–20 independent sub-tasks. Each sub-task must have:

- A clear input (files, ticket, question).
- A clear output (findings, decision, patch, test result).
- No hidden dependency on another sub-task in the same fan-out.

Write the plan to `loop-state.md` under `## Graph Plan`.

### 2. Claim

The orchestrator claims the parent Linear issue:

```bash
node scripts/linear-claim.mjs claim --issue KO-XXX --agent <orchestrator-name>
```

If the task spawned from a Wayfinder map, each sub-agent claims its child ticket before resolving it.

### 3. Fan-out

Spawn one subagent per sub-task **in parallel**, using the host CLI's native subagent tool:

- **Claude Code**: Agent tool (or `ultracode` dynamic workflow if available).
- **Codex**: `spawn_agent` tool.
- **Qwen Code**: Agent tool (`maxConcurrentSubagents` defaults to 5).
- **Kimi Code**: Agent tool / Agent Swarm.

Each subagent receives:

- Its sub-task description.
- The relevant slice of `CONTEXT.md`, `ADL.md`, `SCHEMA.md`, or `RULES.md`.
- A strict output schema (see below).
- The rule: *claim before editing, release when done*.

Cap concurrency to the host's limit (Claude ~16, Qwen default 5, Kimi/Codex vary). If there are more sub-tasks than slots, queue them.

### 4. Verify

Run a second wave of verifier subagents on the outputs. A verifier must:

- Have a **fresh context** (not the same conversation as the producer).
- Check evidence, not vibes (tests pass, file exists, rule actually applies).
- Return a verdict schema.

Typical verification passes:

- **Refutation pass**: "Try to prove this finding is a false positive."
- **Evidence pass**: "Does the cited file/line actually support this conclusion?"
- **Standards pass**: "Does this patch follow RULES.md and the project style?"

### 5. Synthesize

One final agent merges verified outputs into:

- A human-readable report grouped by theme/severity.
- A list of confirmed action items with `[KO-###]` references.
- A go/no-go verdict for landing.

### 6. Land

- Update `loop-state.md` with results.
- Post summary comments to Linear tickets.
- Release claims:
  ```bash
  node scripts/linear-claim.mjs release --issue KO-XXX --agent <orchestrator-name>
  ```
- If the verdict is GO and gates pass, the Lander merges the work.

## Subagent output schema

Every subagent must return JSON matching this schema:

```json
{
  "status": "PASS | FAIL | NEEDS_INFO",
  "summary": "one-line result",
  "evidence": [
    { "file": "path", "line": 42, "note": "why this matters" }
  ],
  "findings": [
    { "severity": "low|medium|high|critical", "title": "...", "description": "..." }
  ],
  "changedFiles": ["path/to/file.ts"],
  "followUps": [
    { "ticket": "KO-YYY", "description": "..." }
  ]
}
```

Use `schema` validation if the host supports it; otherwise validate manually and retry once.

## Built-in graph recipes

### Recipe A: Diff review (read-only)

Input: git range (`origin/web-koinaku..HEAD`).
Fan-out dimensions:
- architecture
- security
- koin-rules
- tests-verification

Verify: refute each finding.
Synthesize: grouped report + verdict.

Prefer the dedicated `.claude/workflows/diff-review.js` when running inside Claude Code; this recipe is the fallback for other agents.

### Recipe B: Security / RLS sweep

Input: target directory (e.g., `app/`, `lib/`, `supabase/`).
Fan-out: one subagent per top-level module or route group.
Verify: independent security verifier checks each finding against real code.
Synthesize: ranked findings with fixes.

### Recipe C: Wayfinder map execution

Input: `wayfinder:map` Linear issue.
Plan: load the map, identify the frontier (open, unblocked, unclaimed child tickets).
Fan-out: assign each ticket to a subagent by type (`research`, `prototype`, `grilling`, `task`).
Verify: map steward checks each resolution against the destination and scope.
Synthesize: update the map's Decisions-so-far and graduate fog into new tickets.

## Concurrency and cost guards

- Never exceed the host's subagent concurrency limit.
- Guard open-ended loops with a budget or a dry-round counter.
- If a subagent fails, retry once; on second failure, escalate to human rather than silently dropping.
- For write-heavy subagents, use isolated worktrees or distinct file ownership to avoid races.

## Cross-agent note

Each host CLI implements subagents differently. Do not assume another agent's context is shared. Pass all needed state explicitly in the subagent prompt and enforce the output schema.
