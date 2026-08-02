# STATE.md — Read this first. Overwrite after every session.
# Single source of truth for current project state. All agents read this before anything else.

## Deploy
- Branch: `web-koinaku`
- Production: https://web.koinaku.com (Vercel project `koin-web-koinaku`)
- Last deploy: `dpl_FMotzv8hZK9u38JeVvpdJgJ1yR1y` (2026-07-29, Ready)
- Rule: Vercel only. Netlify is retired. Never deploy to Netlify.

## Tests
- Baseline: **504 passed / 1 failed / 5 skipped** (510 total)
- Known failure: KO-161 — `tests/migrations/033_foundation_zero.test.ts` expects `display_order = 1`, deployed Chapter 00 contract is `0`
- Type-check: clean
- Lint: 0 errors, 26 warnings

## Last completed (newest first, 3 max)
- KO-247: Daily Focus guided mechanics (7 question types) + 12 fresh bilingual rows. Done.
- KO-246: Matching quiz `undefined` fix + 1,000-variant content audit. Done.
- KO-243–245: Source TL;DR summaries, fill-blank guided choices, route loading UX. Done.

## Active blockers
- **KO-161 test failure**: Foundation display-order regression test stale (`tests/migrations/033_foundation_zero.test.ts` expects `display_order = 1`, deployed contract is `0`). Low priority, test-only.

## Resolved blockers
- **Migration 055 APPLIED (2026-08-02)**: The `lesson_order` statements were stripped from the file before it was committed. The remaining 5 `UPDATE lessons SET is_published = false` statements were applied to production — all 5 Foundation 0 duplicates (#1, #4, #5, #6, #25) are now unpublished.

## Active work (from Linear, by priority)
- **KO-111** (High): Final QA — Lighthouse ≥85, WCAG AA, keyboard nav, 375px + 1280px responsive
- **KO-116** (Medium): Recommended resources (books, videos) per lesson
- **KO-117** (Medium): Classify runtime vs agent credentials in `.env.example`; create `docs/ARCHITECTURE.md`
- **KO-179/KO-181** (Medium): Learning measurement design — read `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/docs/KO-181-analytics-and-learning-measurement.md` before implementing. Proposal only, not authorization.
- **KO-112–115** (Low): Notification types (lesson nudge, streak-freeze, trade-onboarding) + delivery tests
- **KO-68** (Low): Screenshot QA + gradient K-tile swap
- **KO-95** (Low): Passkey (WebAuthn) sign-in

## Backlog (discovery only — do NOT implement without product approval)
- KO-215/216: Community chat / forum
- KO-217/218: Avatar rewards + progression
- KO-219–221: Library expansion (Wiki, books, videos)
- KO-222: Koin Lab (paid Decision Practice Coach) — plan at `docs/KO-222-koin-lab-decision-practice-coach-plan.md`
- KO-223: In-app feature voting (curated, upvote-only)
- KO-224: Koin Guide (AI explanation layer) — report at `docs/KO-224-ai-explanation-layer-discovery.md`
- KO-226: Admin Paper Trading test mode
- KO-227: Cohort value brief
- KO-229: Lesson formatting (34 missing explanations, 16 missing examples, 102 long fields)

## Hard rules (never violate)
- No `localStorage`/`sessionStorage` (crashes iframe)
- No `is_published = true` without `lesson_reviews.approved_to_publish = true`
- RLS in same migration as table creation
- TypeScript strict, Zod for all inputs, 44px touch targets
- All monetary values in IDR with realistic Indonesian ranges
- Never retry migration 055 without fixing the missing column
- Never add apex `koinaku.com` Cloudflare token to `app/layout.tsx` (separate Netlify site)
- Never bulk-delete or rewrite KO-225 remaining rows (238 duplicated ID variants + 84 missing `body_id`)
- Never re-implement Foundation 0, assessment gating, or analytics from scratch
- FAQ content lives in Supabase tables (`faq_pages`, `faq_sections`, `faq_entries`) — never hard-code in React
- Public legal pages identify only **Koinaku** — never the founder's name or address
- Paper trading stays gated behind Chapter 08 completion — do not weaken this gate
- Mission RPC `complete_chapter_mission(smallint, jsonb)` must remain server-scored — never restore client-supplied score

## Tracker contract
- **Linear is canonical.** Choose an active KO issue before work. Update its state when done.
- **TASKS.md is a local index.** One line per task. Linear holds the details.
- **progress.md is append-only evidence.** Read the newest entry first. Historical entries are not a live backlog.
- **STATE.md is this file.** Overwrite it at the end of every session. Keep it under 80 lines.

## Documentation routing
- Non-build artifacts (reports, audits, handoffs, research, curriculum exports, agent notes) go in `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/docs`
- `Github-repo` holds only code and directly build-relevant source docs

## Rollback reference
- **STATE.md history:** `git log -- STATE.md` — every version is in git. Restore with `git checkout <commit> -- STATE.md`.
- **Bad migration:** write a corrective migration (prod) or `supabase db reset` (local). Never edit an applied migration.
- **Code regression:** `git revert <commit>` or `git checkout <commit> -- <file>`.
- **Task status error:** Linear is canonical. Revert the TASKS.md checkbox and update this file.
- **Data loss in Supabase:** migrations + seed reconstruct schema. Row-level data needs backup restore.

## Change Log (last 15 sessions, newest first — prune older entries to progress.md)
- 2026-08-02 (pm): Migration 055 applied to production — 5 Foundation 0 duplicates (#1, #4, #5, #6, #25) unpublished. STATE.md blocker resolved. TASKS.md updated to [x].
- 2026-08-02 (am): Tracker restructure. STATE.md created as single source of truth. HANDOFF.md retired. KIMI_HANDOFF.md stripped to rules-only (365→171 lines). Loop docs deduplicated (~35% token savings). Test baseline: 504 passed / 1 failed (KO-161) / 5 skipped. Agent review prompts created at docs/agent-review-prompt.md.
- 2026-07-29: KO-247 Daily Focus guided mechanics shipped (7 question types, 12 new bilingual rows, 255 active total). dpl_FMotzv8hZK9u38JeVvpdJgJ1yR1y.
- 2026-07-29: KO-246 matching quiz undefined fix + 1,000-variant content audit (0 duplicates, 0 corrupted). dpl_12pyCKEKPrDakWQHzGKjQ85oB4at.
- 2026-07-29: KO-243–245 source TL;DR summaries, fill-blank guided choices, route loading UX. dpl_3jyVjsEttnYdMzWCUg2rhtX8Sw2w.
- 2026-07-29: Chapters 12–16 published (40 lessons). KO-240/241/242 Done. dpl_4mRJL7GEEN5QJ6T284bRCKK5uPv9.
- 2026-07-29: KO-228 English pronoun corrections. KO-229 lesson formatting audit (34 missing explanations, 16 missing examples).
- 2026-07-29: Chapters 10–11 chart literacy + decision analysis shipped (16 lessons). dpl_CPYZqSrTGwgG9DJatwLkEdoysKqX.
- 2026-07-28: KO-210 correct-check progression. KO-214 First Friend badge backfill. KO-168/169 Daily Focus bilingual.
- 2026-07-27: KO-211 Koinaku bull branding. KO-212 route loading. KO-213 badge catalogue. KO-203 Vercel Web Analytics.
- 2026-07-27: KO-199/202 Cloudflare Web Analytics (cookieless, single beacon for web.koinaku.com).
- 2026-07-27: KO-191 CAPTCHA repair. KO-192 localized signup confirmation. KO-195 legal identity scrub.
- 2026-07-26: KO-164 Daily Focus retention loop. KO-176 chapter unlocks + celebrations. KO-180 progressive mastery.
- 2026-07-26: Curriculum chapter reset — Foundation 0 split into Chapter 00. 22 users reset to fz-what-is-money.
- 2026-07-25: 13 new lessons (#53-65) published. Migration 055 FAILED (missing lesson_order column — not applied).
- 2026-07-25: KO-145/146 dead BI/IDX URLs replaced with Wikipedia. KO-147 Indonesian grammar fixes.
