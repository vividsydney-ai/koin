# Koin Loop Engineering v2

> **Last updated:** 2026-07-14
> An end-to-end autonomous development loop for Koin: web MVP → PWA → native iOS/Android Beta.
> Designed for Claude Code, Codex, and Kimi Code. All three agents run the same closed loop, read the same memory files, and pass the same mechanical gates.

This repo follows the loop in this file. For the full expanded version see `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/LOOP_ENGINEERING.md`.

## Source Article Takeaways

The referenced Substack argues for designing loops rather than one-off prompts: discover, plan, execute, verify, reflect, and repeat until the goal or stop condition is met. The useful pieces for Koin are:

- Closed loops before open exploration.
- Maker/checker role separation.
- Worktrees for isolated parallel work.
- Persistent repo memory through `AGENTS.md`, `CLAUDE.md`, `TASKS.md`, `progress.md`, and skill/runbook files.
- Evaluation gates that decide "done" instead of agent confidence.

## Blind Spots In The Article

- Tool-command claims age quickly. Treat any mention of agent-specific slash commands as non-authoritative unless current local help or official docs confirm it.
- It under-specifies product management. A loop needs product acceptance criteria, not only code/test criteria.
- It under-specifies data and compliance. Koin's financial education content must cite OJK/BI/IDX sources and must not publish unreviewed lessons.
- It under-specifies mobile release gates. Native/hybrid beta needs app-store, device, permission, push, deep-link, offline, privacy, crash, and analytics checks.
- It under-specifies cost and stop budgets. Every loop needs max iterations, timeout, and escalation rules.
- It treats sub-agents as automatically useful. For this repo, parallelism is only safe for non-migration work; schema changes must be serialized.
- It does not define human review boundaries. Humans own `RULES.md`, app-store decisions, financial claims, source approval, production credentials, and final release sign-off.
- It does not define failure memory quality. The loop must write specific gate failures and follow-ups, not vague "failed tests" notes.

## Operating Model

Koin uses a closed delivery loop:

```text
SELECT TASK
  -> PLAN VERTICAL SLICE
  -> WRITE OR UPDATE TESTS
  -> IMPLEMENT
  -> VERIFY
  -> FIX
  -> VERIFY AGAIN
  -> LOG MEMORY
  -> STOP OR TAKE NEXT TASK
```

Default budget:

- One task per loop run.
- Maximum 6 correction iterations inside the agent.
- Maximum 2 hours unattended before human status.
- Stop immediately on product ambiguity, rule violation, credential need, or failing gate that repeats twice.

## Canonical Memory Files

Read in this order:

1. `HANDOFF.md`
2. `TASKS.md`
3. `RULES.md`
4. `CONTEXT.md`
5. `ADL.md`
6. `VISION.md`
7. `SCHEMA.md`
8. `AGENTS.md`
9. `VERIFIER.md`
10. `.loop/state.md`

Write after every loop:

- `progress.md`
- `_sessions/session_YYYYMMDD.md`
- `TASKS.md` only when the task is truly complete
- `.loop/state.md` when a reusable lesson or risk emerges

## Workstream Sequence

### MVP Web App

Complete remaining `TASKS.md` items in order unless the human overrides:

1. Expand from 5 to 15 lessons.
2. Recommended resources per lesson.
3. Analytics events.
4. Notification queue stub.
5. Final QA.
6. Phase 7 handoff docs.

Web MVP gate:

```bash
npm run type-check
npm run test
npm run build
bash scripts/verify-loop.sh
```

Run Lighthouse and browser QA for final QA tasks.

### Native/Hybrid Beta

Do not resume native work until web MVP gates pass and the human explicitly restarts the native track.

When resumed:

1. Freeze web MVP scope.
2. Sync Capacitor shell from the verified web build.
3. Verify auth storage uses cookies on web and Capacitor Preferences on native.
4. Test iOS simulator and Android emulator.
5. Add push notification real delivery behind env-gated configuration.
6. Add native share/deep-link smoke tests.
7. Run privacy, permission, crash, offline, and app-store metadata gates.

Native beta gate:

```bash
npm run type-check
npm run test
npm run build
npm run cap:sync
npm run cap:open:ios
npm run cap:open:android
```

The simulator/emulator result must be logged in `progress.md`.

## Parallelism Rules

Use worktrees only for tasks that do not touch migrations or the same files.

Parallel-safe examples:

- UI empty states.
- Copy-only docs.
- Isolated page polish.
- Non-schema analytics client wiring.

Serialize these:

- `supabase/migrations/`
- generated Supabase types
- auth/session storage
- source/lesson publishing logic
- package upgrades
- native project files under `ios/` or `android/`

## Agent Roles

### Orchestrator

Owns task selection, scope, stop conditions, and memory. Does not mark done without verifier output.

### Maker

Implements the smallest vertical slice. Writes/updates tests before implementation when behavior changes.

### Checker

Reviews the diff, runs gates, checks `RULES.md`, verifies source compliance, and writes exact failures.

For single-agent sessions, the agent must perform all three roles in sequence and explicitly separate maker work from checker work in the session log.

## Commands

Print the next loop prompt:

```bash
npm run loop:prompt
```

Run one bounded loop:

```bash
npm run loop:codex
npm run loop:claude
npm run loop:kimi
```

Run an explicit task:

```bash
LOOP_TASK="Recommended resources: books, videos per lesson" npm run loop:codex
```

Run the local verifier:

```bash
npm run verify:loop
```

## Swarm Role Protocol

For complex or risky slices, split the loop across multiple agents so the verifier is independent from the implementer. The parent agent is the conductor and the only writer of `loop-state.md`.

| Role | Responsibility | Writes? |
|------|----------------|---------|
| **Planner** | Decompose task into a vertical slice; identify files, migrations, risks. | `loop-state.md` plan |
| **Maker** | Implement code, tests, and (if needed) one migration on an isolated worktree branch. | Code + tests |
| **Verifier** | Read-only review: run `scripts/gate-runner.sh`, diff scans, security/design checks. | `loop-verdict.md` |
| **Fixer** | Receive Verifier findings and fix root cause; may be the same agent as Maker with reset context. | Code |
| **Lander** | Merge, push, update `TASKS.md`/`progress.md`/Linear, archive `loop-state.md`. | Metadata only |

### Conductor rules (gotcha mitigation)

1. **One editor at a time.** Set `loop-state.md > locked_by = <role>` before dispatching an editing agent.
2. **Verifier is read-only.** It must not edit code or `loop-state.md`.
3. **Shared context.** Every agent receives identical base context: task ID, plan, relevant RULES.md/SCHEMA.md excerpts, target branch, budget remaining.
4. **Verdict format.** Verifier returns:
   ```markdown
   ## Verdict
   - status: PASS | FAIL | NEEDS_INFO
   - gate: <name>
   - evidence: <command output or file/line>
   - files_changed: <list>
   - recommendation: <next action>
   ```
5. **Budget accounting.** Each subagent call counts toward `loop-budget.md > subagent_calls`.
6. **Worktree isolation.** Maker works on `wt/<task-slug>` branched from `web-koinaku`. Verifier checks out the same worktree read-only. Lander merges only after all gates pass.
7. **No self-verification.** Maker may run tests for feedback, but official gate run is by a distinct Verifier.

Use the swarm for tasks touching >5 files, >1 migration, auth/RLS/payments, or native bridge changes. For trivial one-file fixes, a single agent may run the full loop.

## Human Escalation

Stop and ask the human when:

- The next task conflicts with `HANDOFF.md` or `progress.md`.
- A lesson cannot be backed by OJK, BI, IDX, or another approved source.
- Native beta work would require app-store, signing, push, or production credential decisions.
- A migration is needed while another migration branch/worktree is active.
- A gate fails twice with the same root cause.
- The task requires changing `RULES.md`, `.env*`, production deploy settings, or financial claims.

