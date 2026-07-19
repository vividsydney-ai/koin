# KIMI HANDOFF — Koin Web MVP (Worktree + Loop + Agent pattern)

> You are Kimi, acting as the coding agent. This document is self-contained.
> Read it top to bottom before touching anything. Do not skip the "Rules you
> must not break" section.
> **Last updated:** 2026-07-19

---

## 0. Where you are

- **Repo:** `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo`
- **Shipping branch:** `web-koinaku` (this is the integration + deploy branch — there is NO `main` PR flow for this MVP)
- **Stack:** Next.js + TypeScript (strict) + Supabase (Postgres, RLS) + Vitest + Tailwind
- **Prod:** https://web.koinaku.com (Vercel project `koin-web-koinaku`)
- **Deploy target:** Vercel only. Netlify is a paused fallback; do not rely on it for production deploys.
- **Current state:** Responsive /learn grid (1/2/3-column), LessonPlayer content polish with icons/subheaders, and quiz variety fix landed on `web-koinaku` and deployed to `https://web.koinaku.com`. Root cause was `seededIndex` returning a floating-point index; fixed and regression-tested. Friends/cohort UI polished (primary-brand create button, bottom-nav clearance, responsive 2-column layout). Production smoke verified at 375/768/1280/1440: lesson completion works, quizzes cycle through MCQ/T/F/fill_blank, library/friends responsive. Previous work: KO-DEDUP-001 deactivated duplicate Foundation 0 variants; SEC-001 added CI, Zod validation, typed service layer, RLS smoke tests, security docs, pre-commit hooks. `npx vitest run` → 376 passed / 5 skipped; `npm run type-check` clean; `npm run lint` 0 errors.

**First actions (in this order, no exceptions):**
1. Read `loop-state.md`. If it exists and state is not `DONE`, resume from there.
2. Run OpenWiki pre-flight for Loop Engineering v2:
   - If `openwiki/quickstart.md` exists, read it and follow links to pages relevant to the selected task.
   - Always read `openwiki/INSTRUCTIONS.md` if present.
   - If `openwiki/quickstart.md` is missing and the `openwiki` CLI is available, run `openwiki code --update --print` before planning.
   - If credentials or network access are missing, continue and log that OpenWiki could not be refreshed.
3. Read `HANDOFF.md`, `TASKS.md`, `RULES.md`, `CONTEXT.md`, `ADL.md`, `SCHEMA.md`, `AGENTS.md`, `VERIFIER.md`, `docs/agents/LOOP_ENGINEERING.md`.
4. Confirm you understand the domain language in `CONTEXT.md` (Koin Points, lessons, paper trading, graduation, streaks).
5. Then follow the loop in section 3.

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
- **OpenWiki** = repo memory and architecture discovery. Read it during loop pre-flight. It helps you find context, but it never overrides current human instructions, `RULES.md`, `AGENTS.md`, `CLAUDE.md`, this handoff, or `docs/agents/LOOP_ENGINEERING.md`.

### ⚠️ Concurrency warning — read this before creating worktrees
Worktrees isolate the **files on disk**. They do **NOT** isolate:
- the **local Supabase instance** (one Postgres for the whole repo), or
- the **`supabase/migrations/` directory** (shared history).

**Therefore:**
- **Parallelize ONLY tasks that need no new migration** (UI, content, empty states, most bug fixes).
- **Serialize any task that adds a migration.** Do those one at a time, on `web-koinaku` directly.
- Two worktrees must never edit the same files. Check the task groupings in section 5 before starting.
- In a swarm, only one agent holds the edit lock (`loop-state.md > locked_by`). The Verifier agent is read-only.

### Landing model (respects the "no PR" protocol)
`web-koinaku` is the shipping branch. Worktree branches are **scratch space that lands back onto `web-koinaku`**:
work in the worktree → pass all gates → rebase onto latest `web-koinaku` → fast-forward/squash-merge → delete the worktree. The branches are disposable.

> If the human prefers to stay strictly single-branch, skip worktrees entirely and just run the loop in section 3 sequentially on `web-koinaku`, one task at a time. Ask if unsure.

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

# Gate 0b — Lint
npm run lint                          # must be zero errors

# Gate 1 — Supabase types (only if you touched schema)
npx supabase gen types typescript --linked > types/supabase.ts   # must exit 0

# Gate — Tests
npx vitest run                        # must be ≥215 passed / 1 skipped, no regressions

# Gate 2 — RULES.md scan (grep source diff only)
git diff -- "*.ts" "*.tsx" "*.js" "*.jsx" | grep -nE "localStorage|sessionStorage" && echo "VIOLATION" || echo "clean"
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
git worktree add ../wt-empty-states -b wt/empty-states web-koinaku
git worktree add ../wt-analytics    -b wt/analytics    web-koinaku

# ...work + loop inside each worktree directory...
# In a swarm: Maker edits; Verifier checks out the same worktree read-only.

# when a worktree's gates are ALL green, land it onto web-koinaku:
cd /Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo
git checkout web-koinaku && git pull
git merge --squash wt/empty-states          # or rebase the worktree branch first
git commit -m "Phase 6: empty states for all screens"
# re-run gates ON web-koinaku after merge, then:
git worktree remove ../wt-empty-states
git branch -D wt/empty-states
```

Commit every logical sub-step with a clear message (project convention). Deploy is automatic from `web-koinaku` via Vercel to https://web.koinaku.com.

---

## 5. Your assignment — open Phase 6 tasks (from TASKS.md)

Take the **first `[ ]`** in `TASKS.md`, complete it, mark it `[x]`, stop — or batch by the groups below.
Initialize each task with `npm run loop:init <ID> "<title>"`.

### Group A — parallel-safe (no new migrations, mostly UI; separate worktrees OK)
- [ ] **Analytics events** — instrument all 16 spec events + trade + graduation events. `TASKS.md` analytics slice.
- [ ] **Final QA** — 375px mobile, 1280px desktop, keyboard nav, WCAG AA (run last). `TASKS.md` QA slice.

### Group B — content, touches lessons/sources (SERIALIZE — overlapping files)
- [x] **Curriculum overhaul** — 32-lesson foundation-first free track (KO-CURR-001). Done.
- [ ] **Recommended resources** — books/videos per lesson.

### Group C — needs schema/architecture (SERIALIZE — one migration each, on web-koinaku directly)
- [ ] **Notification queue** — stub delivery, architecture ready.

### Done since last handoff
- [x] Library tab
- [x] Empty states
- [x] KO-37..KO-41 bug fixes
- [x] KO-46 — re-enabled signup confirmation emails (Google Workspace SMTP) + modernized signup form UX
- [x] KO-47 — removed cofounder's duplicate auth user so he can sign up cleanly
- [x] KO-48 — signup placeholder updated to Alfa Satria
- [x] KO-49 — onboarding supports up to 3 financial goals (multi-select)
- [x] KO-50 — lesson numbering audit; fixed LessonPlayer to show live total count; content personalization verified via seeded variants
- [x] KO-51 — lesson variants now filtered by user's financial_literacy_level; goal-based recommendations on /learn
- [x] KO-52 — removed "Lesson not found" flash during lesson loading/navigation
- [x] KO-53 — replaced floating AI assist button with inline "Penjelasan lebih sederhana / Lihat contoh lain / Coba soal lain" links
- [x] KO-54 — published lesson 10 (emergency-fund-101); 10 lessons visible at launch
- [x] Production signup + onboarding browse-verified end-to-end
- [x] Domain migration to `web.koinaku.com`
- [x] SEC-001 — Security & engineering credibility pass: CI, typed auth errors, Zod validation, service layer, RLS smoke tests, security docs, lint-staged
- [x] KO-CURR-001 — Curriculum v2.0 overhaul: 32 foundation-first lessons, verified sources, matching + case_study quiz UI, full test + lint + type-check green
- [x] 6-slice MVP polish — content deduplication, lesson player fixes, personalisation verification, chapter UI, paper trading IDX/simulated data, Friends QR-code overhaul deployed to `https://web.koinaku.com`
- [x] KO-DEDUP-001 — Deactivated 24 duplicate content variants (9 examples + 15 questions) across first 3 Foundation 0 lessons; "Lihat contoh lain" now cycles unique examples and hides when exhausted
- [x] KO-DESIGN-001 — Koinaku Design System v4 polish pass: lesson player step cards, quiz cards, source cards, app chrome, home/friends cards; fixed repo-wide `rounded-radius-*` tokens; gates green; deployed to `https://web.koinaku.com`
- [x] KO-RESP-001 — Responsive desktop/iPad pass: widened app shell and LessonPlayer, library 1/2/3-column grid, light-theme source cards, friends 2-column layout, lesson content structure with icons, quiz type rotation (MCQ/T-F/Yes-No), cohort friend invites, Pro cohort limit = 10; Supabase migration pushed; deployed to `https://web.koinaku.com`

**Suggested first move:** C1 — Recommended resources per lesson on `web-koinaku`.

---

## 6. Definition of done + logging

A task is done ONLY when:
1. All applicable gates in section 3 pass (no self-certification).
2. The change is landed on `web-koinaku` and gates still pass post-merge.
3. `TASKS.md` item flipped `[ ]` → `[x]`.
4. `progress.md` updated with: what you did, gate results (paste the counts), and any follow-ups.
5. A session log entry appended to `_sessions/session_YYYYMMDD.md`.
6. If you changed architecture, workflows, schema contracts, security posture, or agent runbooks, run `openwiki code --update --print` after landing or log a follow-up if OpenWiki cannot run.

If a gate fails and you can't fix it within budget: STOP, log the exact failure + command output to `progress.md`, hand back. A blocked-but-documented task beats a green-but-fake one.

---

## 7. Quick reference

| Command | Purpose |
|---|---|
| `npm run dev` | Start Next.js dev server (localhost:3000) |
| `npx tsc --noEmit` | TypeScript gate |
| `npm run lint` | ESLint gate (0 errors) |
| `npx vitest run` | Test gate (baseline: 225 pass / 1 skip) |
| `npm run loop:init <ID> "<title>"` | Initialize loop-state.md for a task |
| `npm run loop:gates` | Run all applicable gates |
| `npm run loop:budget` | Check iteration/file/migration budgets |
| `npm run loop:reflexion <tag>` | Search reflexion DB |
| `npx supabase db reset` | Rebuild local DB from migrations + seed |
| `npx supabase gen types typescript --linked > types/supabase.ts` | Regenerate DB types |
| `npx lighthouse http://localhost:3000 --preset=mobile --output=json` | Perf/a11y gate |
| `git worktree add ../wt-<slug> -b wt/<slug> web-koinaku` | New isolated workspace |

Issues are tracked in Linear team **KO**. Human owns `RULES.md`, `.env*`, `/tests/`.
