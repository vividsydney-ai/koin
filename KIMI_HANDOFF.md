# KIMI HANDOFF — Koin Web MVP (Worktree + Loop + Agent pattern)

> You are Kimi, acting as the coding agent. This document is self-contained.
> Read it top to bottom before touching anything. Do not skip the "Rules you
> must not break" section.

---

## 0. Where you are

- **Repo:** `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo`
- **Shipping branch:** `web-mvp` (this is the integration + deploy branch — there is NO `main` PR flow for this MVP)
- **Stack:** Next.js + TypeScript (strict) + Supabase (Postgres, RLS) + Vitest + Tailwind
- **Prod:** https://koin-web-mvp.vercel.app/
- **Current state:** Phases 1–5 done; Phase 6 in progress. `npx vitest run` → 106 passed / 1 skipped; `npm run type-check` clean.

**First actions (in this order, no exceptions):**
1. Read `HANDOFF.md`, `TASKS.md`, `RULES.md`, `CONTEXT.md`, `ADL.md`, `SCHEMA.md`, `AGENTS.md`, `VERIFIER.md`.
2. Confirm you understand the domain language in `CONTEXT.md` (Koin Points, lessons, paper trading, graduation, streaks).
3. Then follow the loop in section 3.

---

## 1. Rules you MUST NOT break (hard stops — from RULES.md / CLAUDE.md)

- **No `localStorage` / `sessionStorage`** anywhere (crashes the iframe). Use Supabase or cookies.
- **No `is_published = true`** on a lesson unless `lesson_reviews.approved_to_publish = true` exists for it.
- **RLS must be in the same migration** that creates the table. Every user-sensitive table has RLS ON.
- TypeScript **strict mode**; **Zod** for all external inputs; **44px minimum** touch targets.
- All monetary values in **IDR** with realistic Indonesian ranges.
- Every published lesson cites **≥1 Tier-1 source** (OJK / BI / IDX). Trust is the product.

**Files you may NOT modify** (human-owned):
- `RULES.md`, `.env*`, anything in `/tests/` (you may READ tests; you do not rewrite them to make them pass).
- `supabase/migrations/` — **one migration per task, ever.** See the concurrency warning in section 2.

---

## 2. The pattern: worktree + loop + you-as-agent

Three ideas, composed:

- **Worktree** = an isolated working directory on its own branch, backed by the same repo. Lets you work on one task without half-finished edits from another task polluting it. Cheap, no re-clone.
- **Loop** = you do not aim for one-shot correctness. You run `build → verify → correct` until the verifier gates pass or you hit the budget, then stop.
- **Agent** = you. You own the loop, run the gates, and only land work that passed.

### ⚠️ Concurrency warning — read this before creating worktrees
Worktrees isolate the **files on disk**. They do **NOT** isolate:
- the **local Supabase instance** (one Postgres for the whole repo), or
- the **`supabase/migrations/` directory** (shared history).

**Therefore:**
- **Parallelize ONLY tasks that need no new migration** (UI, content, empty states, most bug fixes).
- **Serialize any task that adds a migration.** Do those one at a time, on `web-mvp` directly, with `npx supabase db reset` between them.
- Two worktrees must never edit the same files. Check the task groupings in section 5 before starting.

### Landing model (respects the "no PR" protocol)
`web-mvp` is the shipping branch. Worktree branches are **scratch space that lands back onto `web-mvp`**:
work in the worktree → pass all gates → rebase onto latest `web-mvp` → fast-forward/squash-merge → delete the worktree. You are not introducing a permanent branch-per-feature model; the branches are disposable.

> If the human prefers to stay strictly single-branch (current recorded protocol), skip worktrees entirely and just run the loop in section 3 sequentially on `web-mvp`, one task at a time. Ask if unsure.

---

## 3. The loop (run this per task)

```
PLAN → WRITE/UPDATE TEST → IMPLEMENT → VERIFY (all gates) → CORRECT → repeat until green → LAND → LOG
```

**Budget:** max ~6 correction iterations per task. If still red, STOP, write the failure + last gate output to `progress.md`, and hand back to the human. Do not thrash.

### The verifier gates (from VERIFIER.md — this is what "done" means, not your opinion)

Run **all** of these. If any fails, halt and fix before proceeding:

```bash
# Gate 0 — TypeScript
npx tsc --noEmit                      # must be zero errors

# Gate 1 — Supabase types (only if you touched schema)
npx supabase gen types typescript --local > src/types/supabase.ts   # must exit 0

# Gate — Tests
npx vitest run                        # must be ≥106 passed / 1 skipped, no regressions

# Gate 2 — RULES.md scan (grep your own diff)
git diff | grep -nE "localStorage|sessionStorage" && echo "VIOLATION" || echo "clean"
# also: no is_published=true without lesson_reviews; no migration without RLS in same file
```

**Phase 6 extra gates** (run when the task is in scope):
- **Gate 15a — Adaptive lesson triggers:** panic-sell creates a loss-aversion recommendation; >50% concentration creates a diversification recommendation; N days inactivity creates a confidence recommendation; `lesson_triggers` maps ≥3 behaviors.
- **Gate 15 — Lighthouse mobile:** `npx lighthouse http://localhost:3000 --preset=mobile --output=json` → Performance ≥85, Accessibility ≥95, Best Practices ≥90.
- **Gate 16 — Keyboard nav:** every interactive element reachable via Tab, focus indicator visible.
- **Gate 17 — WCAG AA contrast:** primary text ≥4.5:1, large text ≥3:1.

---

## 4. Worktree commands (copy-paste)

```bash
cd /Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo

# create an isolated worktree for a task (branch name = task slug)
git worktree add ../wt-empty-states -b wt/empty-states web-mvp
git worktree add ../wt-analytics    -b wt/analytics    web-mvp

# ...work + loop inside each worktree directory...

# when a worktree's gates are ALL green, land it onto web-mvp:
cd /Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo
git checkout web-mvp && git pull
git merge --squash wt/empty-states          # or rebase the worktree branch first
git commit -m "Phase 6: empty states for all screens"
# re-run gates ON web-mvp after merge, then:
git worktree remove ../wt-empty-states
git branch -D wt/empty-states
```

Commit every logical sub-step with a clear message (project convention). Deploy is automatic from `web-mvp` via Vercel.

---

## 5. Your assignment — open Phase 6 tasks (from TASKS.md)

Take the **first `[ ]`** in `TASKS.md`, complete it, mark it `[x]`, stop — or batch by the groups below.

### Group A — parallel-safe (no new migrations, mostly UI; separate worktrees OK)
- [ ] **Empty states** — all screens: no friends, no lessons started, no holdings, streak lost, graduated, all done. `TASKS.md:119`
- [ ] **Analytics events** — instrument all 16 spec events + trade + graduation events. `TASKS.md:120`
- [ ] **Final QA** — 375px mobile, 1280px desktop, dark mode, keyboard nav, WCAG AA (this is a verify pass; run last). `TASKS.md:122`

### Group B — content, touches lessons/sources (SERIALIZE — overlapping files)
- [ ] **Expand 5 → 15 lessons** (each needs a Tier-1 source + review row before publish). `TASKS.md:116`
- [ ] **Library tab** — browse sources by topic/tier/type/language. `TASKS.md:117`
- [ ] **Recommended resources** — books/videos per lesson. `TASKS.md:118`

### Group C — needs schema/architecture (SERIALIZE — one migration each, on web-mvp directly)
- [ ] **Notification queue** — stub delivery, architecture ready. `TASKS.md:121`

### Open bugs (independent — good parallel candidates, start P0 first)
- [ ] **KO-37 P0** — sign-up confirmation email not sent after registration
- [ ] **KO-38 P1** — home hero text overlaps on iPhone SE
- [ ] **KO-39 P1** — bottom nav doesn't highlight active page on mobile
- [ ] **KO-40 P2** — paper trading page 4+ s load on 3G
- [ ] **KO-41 P2** — profile page missing 'Edit Profile' button

**Suggested first move:** KO-37 (P0) sequentially on `web-mvp`, then fan out Group A (empty states + analytics) into two worktrees.

---

## 6. Definition of done + logging

A task is done ONLY when:
1. All applicable gates in section 3 pass (no self-certification).
2. The change is landed on `web-mvp` and gates still pass post-merge.
3. `TASKS.md` item flipped `[ ]` → `[x]`.
4. `progress.md` updated with: what you did, gate results (paste the counts), and any follow-ups.
5. A session log entry appended to `_sessions/session_YYYYMMDD.md`.

If a gate fails and you can't fix it within budget: STOP, log the exact failure + command output to `progress.md`, hand back. A blocked-but-documented task beats a green-but-fake one.

---

## 7. Quick reference

| Command | Purpose |
|---|---|
| `npm run dev` | Start Next.js dev server (localhost:3000) |
| `npx tsc --noEmit` | TypeScript gate |
| `npx vitest run` | Test gate (baseline: 106 pass / 1 skip) |
| `npx supabase db reset` | Rebuild local DB from migrations + seed |
| `npx supabase gen types typescript --local > src/types/supabase.ts` | Regenerate DB types |
| `npx lighthouse http://localhost:3000 --preset=mobile --output=json` | Perf/a11y gate |
| `git worktree add ../wt-<slug> -b wt/<slug> web-mvp` | New isolated workspace |

Issues are tracked in Linear team **KO**. Human owns `RULES.md`, `.env*`, `/tests/`.
