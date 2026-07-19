---
name: loop
description: Run Koinaku Loop Engineering v2 as Conductor with OpenWiki pre-flight and swarm routing. Resumes loop-state.md if active, otherwise takes the goal given as args (or the first eligible TASKS.md item/batch), reads OpenWiki repo memory, chooses linear vs parallel execution, dispatches Planner/Maker/Verifier/Fixer/Lander roles, lands on web-koinaku, and logs. Use when asked to "fwd / loop", "/loop", "loop", "use loop eng", "act as conductor", or to pick up the next task.
---

# /loop — Koinaku Loop Engineering v2 (Conductor mode)

Repo: `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo` — branch `web-koinaku` (shipping branch, no PR flow). Prod: `https://web.koinaku.com` on **Vercel** + Supabase. Netlify is stale historical memory and must not be used for production.

## Task selection

- If `$ARGUMENTS` names a goal or task, that is the task.
- If `$ARGUMENTS` asks for a batch, swarm, parallel work, or multiple tasks, the Conductor may select multiple eligible tasks.
- If empty, take the first unchecked `[ ]` item in `TASKS.md`.
- Before starting, reconcile `loop-state.md`, `HANDOFF.md`, `TASKS.md`, `progress.md`, and any `.loop/programs/<TASK-ID>.md`. Skip tasks that are stale, already shipped, paused, or contradicted by newer progress.

## Swarm routing

The Conductor decides linear vs parallel execution before dispatching agents.

Run **in parallel** only when every selected task is independent:

- no migrations or generated Supabase type changes;
- no auth/session, package/dependency, production deploy, or native `ios/`/`android/` changes;
- disjoint files or clearly disjoint domains;
- each task can use its own worktree `wt/<task-slug>`;
- each task has a separate Maker and a separate read-only Verifier.

Run **linearly** when tasks touch shared files, migrations, lesson publishing/source rules, auth/session, analytics event contracts, dependency/config files, production deployment, or when task order affects data shape. For linear work, finish and verify one task before starting the next.

For a single small task, the session agent may run the full loop solo, but it must still separate Maker work from Checker/Verifier work in the session log. For risky or multi-file work, dispatch Planner → Maker → Verifier → Fixer → Lander roles using `.agents/prompts/{planner,maker,verifier,fixer}.md`.

## Protocol

Full detail in `docs/agents/LOOP_ENGINEERING.md` — read it if anything here is unclear.

1. **Resume first.** Read `loop-state.md`. If it exists and state != DONE, resume from that phase — never start a new task on top of an active loop.
2. **OpenWiki pre-flight.** If `openwiki/quickstart.md` exists, read it first and follow links to task-relevant OpenWiki pages. Always read `openwiki/INSTRUCTIONS.md` if present. If `openwiki/quickstart.md` is missing and the `openwiki` CLI is available, run `openwiki code --update --print` before planning. If credentials or network access are missing, continue and log that OpenWiki could not be refreshed.
3. **Context.** Read `HANDOFF.md`, `KIMI_HANDOFF.md`, `TASKS.md`, `RULES.md` (skim `CONTEXT.md`/`SCHEMA.md` if the task touches domain or DB). OpenWiki is memory/discovery only; authority order is: current human instruction → `RULES.md` → `AGENTS.md`/`CLAUDE.md`/`KIMI_HANDOFF.md` → `docs/agents/LOOP_ENGINEERING.md` → `TASKS.md` → generated OpenWiki pages.
4. **You are the Conductor.** Use the swarm routing rules above to decide parallel vs linear execution. For tasks touching >5 files, any migration, auth/RLS/payments/deploy config, or multiple domains: dispatch swarm roles (Planner → Maker → Verifier → Fixer → Lander) as subagents. Rules: one editor at a time per worktree, Verifier is read-only, no self-verification. Small tasks (≤3 files, no migration): run the loop solo. Role briefs live in `.agents/prompts/{planner,maker,verifier,fixer}.md` — paste them into subagent prompts instead of improvising.
5. **Program doc.** If `.loop/programs/<TASK-ID>.md` exists (template at `.loop/programs/TEMPLATE.md`), its Metric and Stop condition are the task's acceptance criteria — the Verifier checks against them. If the human hasn't written one and "done" is ambiguous, draft it and confirm with the human before implementing.
6. **Initialize.** Archive any stale `loop-state.md`/`loop-budget.md` to `.loop/reflexion/context/`, then `npm run loop:init <ID> "<title>"`.
7. **Build.** TDD where behavior changes. One migration max per task; serialize migration tasks.
8. **Verify (all gates, no self-certification):**
   - `npx tsc --noEmit` — 0 errors
   - `npm run lint` — 0 errors
   - `npx vitest run` — no regressions (baseline ≥333 passed / 5 skipped)
   - diff scan: no `localStorage`/`sessionStorage`; no `is_published=true` without `lesson_reviews` approval; RLS in same migration as any new table
   - the program Metric, if a program doc exists
9. **Metrics log.** After each verification run, append one JSON line to `.loop/metrics/<TASK-ID>.jsonl`: `{"iteration":N,"ts":"...","gates":{"tsc":true,"lint":true,"vitest":true},"verdict":"KEEP|IMPROVE|REVERT|ESCALATE"}`. `KEEP` = all gates pass; `IMPROVE` = red but strictly better than last iteration (keep and fix next); `REVERT` = made things worse; `ESCALATE` = budget end.
10. **Land.** Commit on `web-koinaku`, push, `npx supabase db push --include-all` if a migration was added, rely on Vercel production deployment for `web-koinaku`, smoke-check `https://web.koinaku.com` (200), update `TASKS.md`, `progress.md`, `_sessions/session_YYYYMMDD.md`, create or update the Linear issue in team KO (title prefixed with the loop task ID, e.g. `[KO-REPLAY-002] …`, state Done when landed), archive `loop-state.md` + `loop-budget.md` to `.loop/reflexion/context/`.
11. **Refresh OpenWiki when relevant.** If the task changed architecture, workflows, schema contracts, security posture, or agent runbooks, run `openwiki code --update --print` after landing or log a follow-up if it cannot run. Do not hand-edit generated OpenWiki pages unless the human explicitly asks.
12. **Budget.** Max 6 correction iterations. If still red: STOP, write exact failure + gate output to `progress.md` Blockers, hand back. A documented block beats a fake green.

## Hard stops (from RULES.md)

- No `localStorage`/`sessionStorage` anywhere.
- No `is_published = true` on a lesson unless `lesson_reviews.approved_to_publish = true` exists.
- RLS must be in the same migration that creates the table.
- TypeScript strict; Zod for all external inputs; 44px minimum touch targets.
- Monetary values in IDR with realistic Indonesian ranges.
- Every published lesson cites ≥1 Tier-1 source (OJK / BI / IDX).
- Never modify: `RULES.md`, `.env*`, `/tests/` (read-only), and only one migration per task.

## Escalate to the human when

- A gate fails twice with the same root cause, or budget is exhausted.
- A migration is needed while another migration task is active.
- The task requires changing `RULES.md`, `.env*`, production deploy settings, or financial claims.
- A lesson can't be backed by OJK/BI/IDX or another approved source.
