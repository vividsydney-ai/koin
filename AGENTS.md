# AGENTS.md — Koin Agent Configuration v2

> **Last updated:** 2026-07-18

Every agent starts by reading `loop-state.md`. If it exists and state is not `DONE`, resume from that state. Otherwise run the OpenWiki pre-flight below, then read `identity.md`, `HANDOFF.md`, `KIMI_HANDOFF.md`, `TASKS.md`, and `docs/agents/LOOP_ENGINEERING.md`.

## Default operating mode (auto-loop)

Every task request in this repo runs Loop Engineering v2 with the session agent as **Conductor** — no special invocation needed. If the user gives no task, pick the first `[ ]` in `TASKS.md` and start the loop. The `/loop` skill (`.agents/skills/loop/SKILL.md`, also installed at `~/.agents/skills/loop/`) is a shortcut to the same protocol; invoke it whenever the user says "loop", "use loop eng", or "act as conductor".

## OpenWiki pre-flight (mandatory for Loop Engineering v2)

OpenWiki is part of the Koin loop for Kimi Code, Codex, Claude Code, and any other AI agent. Treat it as repo memory and codebase discovery, not as an authority above human-owned rules.

1. If `openwiki/quickstart.md` exists, read it before planning, then follow links to task-relevant OpenWiki pages.
2. Always read `openwiki/INSTRUCTIONS.md` if present; it is the human-authored OpenWiki brief.
3. If `openwiki/quickstart.md` is missing and the `openwiki` CLI is available, initialize repository docs with `openwiki code --update --print` before planning. If credentials or network access are missing, continue the loop and log that OpenWiki could not be refreshed.
4. If the task changes architecture, workflows, schema contracts, security posture, or agent runbooks, refresh OpenWiki with `openwiki code --update --print` after the change is landed or log a follow-up if the CLI cannot run.
5. Do not hand-edit generated OpenWiki pages unless the human explicitly asks. Prefer changing source docs/code, then regenerating OpenWiki.

Authority order when sources conflict: current human instruction → `RULES.md` → `AGENTS.md`/`CLAUDE.md`/`KIMI_HANDOFF.md` → `docs/agents/LOOP_ENGINEERING.md` → `TASKS.md` → generated OpenWiki pages.

## Single-agent sessions (simple fixes)
For one-file UI fixes or trivial tweaks: one agent runs the full loop alone.

## Multi-agent / swarm sessions (complex or risky slices)
Use separate agents for Plan / Make / Verify / Fix / Land so the verifier never approves its own work.

### Roles
| Role | Responsibility | Writes? |
|------|----------------|---------|
| **Planner** | Decompose task into a vertical slice; identify files, migrations, risks. | `loop-state.md` plan |
| **Maker** | Implement code, tests, and (if needed) one migration on an isolated worktree branch. | Code + tests |
| **Verifier** | Read-only review: run `npm run loop:gates`, diff scans, security/design checks. | `loop-verdict.md` |
| **Fixer** | Receive Verifier findings and fix root cause; may be the same agent as Maker with reset context. | Code |
| **Lander** | Merge, push, update `TASKS.md`/`progress.md`/Linear, archive `loop-state.md`. | Metadata only |

### Conductor rules (gotcha mitigation)
1. **One editor at a time.** Set `loop-state.md > locked_by = <role>` before dispatching an editing agent.
2. **Verifier is read-only.** It must not edit code or `loop-state.md`.
3. **Shared context.** Every agent receives identical base context: task ID, plan, relevant `RULES.md`/`SCHEMA.md` excerpts, target branch, budget remaining. Role briefs live in `.agents/prompts/{planner,maker,verifier,fixer}.md` — paste them instead of improvising.
4. **Verdict format.** Verifier returns `status: PASS | FAIL | NEEDS_INFO`, gate, evidence, files_changed, recommendation.
5. **Budget accounting.** Each subagent call increments `loop-budget.md > subagent_calls`.
6. **Worktree isolation.** Maker works on `wt/<task-slug>` branched from `web-koinaku`. Verifier checks out the same worktree read-only. Lander merges only after all gates pass.
7. **No self-verification.** Maker may run tests for feedback, but official gate run is by a distinct Verifier.
8. **Conflict resolution.** On any Maker-vs-Verifier disagreement, the Verifier's gate evidence always wins. The Conductor may not override a FAIL without logging written justification in `loop-state.md`. Program docs (`.loop/programs/<TASK-ID>.md`) outrank both — their Metric is the acceptance criteria.

## Pre-flight checklist
1. Read `loop-state.md` first. Resume if state != DONE.
2. Run the OpenWiki pre-flight above.
3. Read `identity.md`, `HANDOFF.md`, `KIMI_HANDOFF.md`, `TASKS.md`, `RULES.md`, `CONTEXT.md`, `ADL.md`, `SCHEMA.md`.
4. Identify the vertical slice: smallest end-to-end piece that can be built and verified independently.
5. Initialize `loop-state.md` with `npm run loop:init <ID> "<title>"` if starting fresh.
6. Search reflexion: `npm run loop:reflexion <tag>` before planning.
7. Write or update tests before implementation code (TDD).

## Stop tokens / escalation
- `ESCALATED` — budget exhausted or human said STOP/HOLD. Halt immediately.
- `BLOCKED` — external dependency missing. Log blocker and stop.
- `DONE` — all gates passed, landed, metadata updated.

## Gate protocol
Run `npm run loop:gates` in verification. Phase-specific thresholds:
- Phase 1 (migrations): `npx supabase db reset` exits 0, RLS in same migration file.
- Phase 2 (auth): auth tests pass, no localStorage/sessionStorage.
- Phase 3A (core learning): lesson completion, variants, sources, quiz randomization pass.
- Phase 3B (paper trading): first trade end-to-end, market data, risk profile.
- Phase 4 (streaks + points): streak engine, Koin Points awards pass.
- Phase 5 (social + graduation): friends, leaderboard, graduation certificate pass.
- Phase 6 (adaptive + polish): triggers fire, Lighthouse mobile ≥85, accessibility ≥95, WCAG AA.

## What agents may NOT modify
- `RULES.md` (human controls)
- `.env*` files
- `/tests/` files (read only)
- `supabase/migrations/` — one migration per task, only Maker

<!-- OPENWIKI:START -->

## OpenWiki

This repository uses OpenWiki for recurring code documentation. Start with `openwiki/quickstart.md`, then follow its links to architecture, workflows, domain concepts, operations, integrations, testing guidance, and source maps.

The scheduled OpenWiki GitHub Actions workflow refreshes the repository wiki. Do not hand-edit generated OpenWiki pages unless explicitly asked; prefer updating source code/docs and letting OpenWiki regenerate.

<!-- OPENWIKI:END -->
