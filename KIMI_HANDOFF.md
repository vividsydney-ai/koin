# KIMI HANDOFF — Koin Web MVP (Worktree + Loop + Agent pattern)

> You are Kimi, acting as the coding agent. This document is self-contained.
> Read it top to bottom before touching anything. Do not skip the "Rules you
> must not break" section.
> **Last updated:** 2026-07-25

---

## 0. Where you are

- **Repo:** `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo`
- **Shipping branch:** `web-koinaku` (this is the integration + deploy branch — there is NO `main` PR flow for this MVP)
- **Stack:** Next.js + TypeScript (strict) + Supabase (Postgres, RLS) + Vitest + Tailwind
- **Prod:** https://web.koinaku.com (Vercel project `koin-web-koinaku`)
- **Deploy target:** Vercel only. Netlify is a paused fallback; do not rely on it for production deploys.
- **Current state:**
  - KO-CURR-004 shipped and deployed: Learn page shows 8 chapters as `01 - Money Basics` … `08 - Cryptocurrency 101`.
  - Fixed the Vercel deploy blocker: wrapped `app/onboarding/page.tsx` in a React `Suspense` boundary so `useSearchParams()` no longer breaks the Next.js static build.
  - KO-AUTH-001 verified complete: signup validates email with Zod, enforces password rules (≥8 chars, number, special char), shows/hides password toggles on login/signup/reset, forgot-password flow exists, and `/profile/account/password` lets users change passwords.
  - Friend list "unknown" names verified fixed (`getFriends` joins `profiles.display_name`).
  - Streak/XP verified working (`complete_lesson` awards XP and calls `check_in_streak` once per WIB day; no hard cap).
  - OJK/BI/IDX source links verified fixed: `ReachableLink` bypasses browser CORS checks for Tier-1 sources and falls back to Wikipedia for truly dead links.
  - KO-QUIZ-001 shipped: `complete_lesson` now returns the next **uncompleted** lesson in curriculum order, so the post-lesson "Next" button no longer jumps over completed lessons.
  - Bug-sheet reconciliation: read the 19-row tracker, verified KO-37→KO-41 Done, created/closed KO-136→KO-144 for fixed bugs, and created KO-145→KO-149 for still-open items. KO-148 (cohort invite) and KO-149 (camera QR scan) were then verified working and moved to Done.
  - **KO-145 + KO-146 (Done, Deployed):** Dead BI/IDX source URLs replaced with verified Wikipedia equivalents via migration `20260725100000_KO145_146_fix_dead_source_urls.sql`. 13 broken sources updated (bi.go.id → Wikipedia ID/EN, idx.co.id → Wikipedia ID/EN). All marked `needs_review` with `trust_notes`. Updated `seed.sql` and `migration 030` to match. 13 tests added (all passing). **Migration applied to production Supabase** (commit 767ad2d). Verified live: BI-001/002, IDX-001/002 and 9 others confirmed showing Wikipedia URLs. Vercel auto-deployed to https://web.koinaku.com.
  - **KO-147 (Done):** Bahasa Indonesia grammar inconsistencies fixed. 8 changes across `lib/i18n/dictionaries.ts` and legal docs (TermsOfService.tsx, PrivacyPolicy.tsx): translated "side quest" → "misi tambahan", fixed "Kepercayaan sumber" → "Keandalan sumber", fixed pronoun shift, removed English glosses, translated English loanwords to proper Indonesian.
  - **Tracker reconciliation (2026-07-25):** Foundation 0 is confirmed shipped and now has Linear Done parent KO-150 plus Done children KO-151→KO-155. Onboarding assessment gating and analytics are verified complete; do not re-implement them. Targeted regression run: 39 passed / 3 skipped, plus source URL verification passed.
  - **KO-156 (Done):** Home hides the portfolio balance until paper trading is unlocked (`canTrade`); completing the unlock flow creates the default paper portfolio. Do not show a pre-unlock IDR portfolio balance for new users.
  - **KO-157 (Done):** Account deletion is a seven-day reversible flow: typed email + current password, recovery email link, explicit reactivation, and protected daily purge. Do not replace it with client-only deletion.
  - **Notification settings (Done):** In-app preferences live at `/profile/settings` for master, streak, friend, and cohort alerts. Do not add routine email notifications without human approval.
  - **Shared tracker contract:** Linear is canonical; ignored `TASKS.md` is the local checklist and must use exact Linear IDs; `progress.md` is append-only evidence, so read its newest entry first and never treat older snapshots as current. Active work is only KO-11, KO-12, KO-68, KO-95, KO-98, KO-111→KO-117.
  - **Remaining open bugs:** None from the bug-tracker sheet. All KO-136→KO-149 are Done.
  - Latest gates: `npx tsc --noEmit` clean; `npm run lint` 0 errors / 22 warnings; `npx vitest run` 466 passed / 5 skipped; latest `web-koinaku` pushed and deployed to `https://web.koinaku.com`.

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

# Gate 7 — Linear tracking gate
npm run loop:gates                    # includes Linear parent check + unticketed follow-up scan
```

**Linear tracking:** every task must have a Linear parent before coding starts. Multi-outcome tasks must provide `--children <path>` to `loop:init` so they are atomized into linked child issues. No unticketed `TODO`/`FIXME`/`HACK`/`FOLLOW-UP` may land.

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

## 5. Your assignment — active backlog (from Linear + `TASKS.md`)

Take one active child issue, complete it, update its matching local checklist item, append verification evidence to `progress.md`, then stop — or batch only within the groups below. Do not treat the ignored local `TASKS.md` as a replacement for Linear; Linear is the shared issue tracker.
Initialize each task with `npm run loop:init <ID> "<title>"`.

### Group A — parallel-safe (no new migrations, mostly UI; separate worktrees OK)
- [ ] **KO-68 UI screenshot QA** — onboarding/login/signup/trade post-purple-flip + gradient K-tile swap.
- [ ] **KO-111 Final QA** — 375px mobile, 1280px desktop, keyboard nav, WCAG AA, Lighthouse (run last).

### Group B — content, touches lessons/sources (SERIALIZE — overlapping files)
- [x] **Curriculum overhaul** — 32-lesson foundation-first free track (KO-CURR-001). Done.
- [ ] **KO-116 Recommended resources** — verified books/videos per lesson.

### Group C — needs schema/architecture (SERIALIZE — one migration each, on web-koinaku directly)
- [ ] **KO-112→KO-115 Notifications** — implement the three remaining notification types, retry/failure coverage, and bounce/complaint runbook. Serialize any migration.

### Group D — remaining product and documentation work
- [ ] **KO-95 Passkeys** — WebAuthn sign-in and registration.
- [ ] **KO-98 Live bug audit** — reconcile current user reports against deployed behaviour.
- [ ] **KO-117 Handoff docs** — classify runtime versus internal-agent environment variables in `.env.example`; create `docs/ARCHITECTURE.md`.

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
- [x] KO-SEC-002 — Security audit must-haves implemented in code: headers, auth redirect proxy, Secure cookie attribute, security.txt, robots.txt, and corrected session docs. Detailed handoff: `docs/KO-SEC-002-kimi-security-handoff-20260721.md` (local session copy also exists in `_sessions/`). Still needs admin/platform follow-up for live two-user RLS audit, Supabase Storage policies, Supabase Auth dashboard checks, edge rate limits, and alerting.

**Suggested first move:** C1 — Recommended resources per lesson on `web-koinaku`.

---

## 6. Definition of done + logging

A task is done ONLY when:
1. All applicable gates in section 3 pass (no self-certification).
2. The change is landed on `web-koinaku` and gates still pass post-merge.
3. `TASKS.md` item flipped `[ ]` → `[x]`.
4. `progress.md` updated with: what you did, gate results (paste the counts), and any follow-ups.
5. A session log entry appended to `_sessions/session_YYYYMMDD.md`.
6. Linear parent/child issues moved to Done, or follow-ups ticketed with `[KO-###]` references.
7. If you changed architecture, workflows, schema contracts, security posture, or agent runbooks, run `openwiki code --update --print` after landing or log a follow-up if OpenWiki cannot run.

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
