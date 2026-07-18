# Task: Lift web.koinaku.com onto the new Koinaku design system

You are the ORCHESTRATOR for this task. Follow docs/agents/LOOP_ENGINEERING.md.
This is swarm-eligible (touches many files across the whole app, visual/brand-sensitive) —
use the 5-role swarm: Planner → Maker → Verifier → Fixer → Lander, per §12.7 / the
Swarm Role Protocol. Do not do this as a single-agent task.

## Context — what's already done, don't redo it

The primary brand color has already been flipped from red to Orbit Purple (#6f4af0) in:
- app/globals.css (the live Tailwind v4 CSS-first config)
- lib/design-tokens.ts (the reference doc for agents)
- scripts/design-drift-check.sh (updated to check both files against canonical values)

Run `bash scripts/design-drift-check.sh` first — it should pass. If it doesn't, STOP and
report before doing anything else; that means the token files have drifted since this
prompt was written.

Read DESIGN.md in full before touching any UI. It is canonical for:
- Color strategy (which color does which job, dosage — Orbit is ~10% of visual weight,
  reserved for actions/selection/focus, never decoration)
- The dark-mode rule: never a literal `-50` background token directly, always
  `color-mix(in srgb, var(--color-X) 8%, var(--surface))` — a real bug this session,
  confirmed via computed contrast (~1:1, unreadable) before being fixed
- Gradient icon technique and where gradient is/isn't allowed (nav + achievements only)
- Hard bans: gradient text, side-stripe borders, glassmorphism-as-default, identical
  repeated card grids

## Reference, not a component library

/Users/vividm4/Documents/All Designs System Bundle/Koinaku Design System v4/ is a living
pattern showcase — plain React + CSS custom properties, NOT Tailwind. Treat it as a design
reference: read the patterns, re-implement them in Tailwind against this repo's actual
tokens in app/globals.css. Do not copy its CSS or JSX verbatim; the stacks don't match.

Patterns available there (React source in src/app/App.tsx, styles in src/styles/theme.css):
lesson cards (portrait/landscape flip), quiz variants (multiple-choice, yes/no, true/false),
source/article cards, video/animated-stat media cards, profile card, badge grid, hero banner,
feature cards, testimonials, pricing cards, leaderboard, candlestick price chart, stat card,
progress bar, numbered pillar card, itemized comparison list, process/journey flow, phase
flow, full-screen offline/404 states, search + filter chips, bottom tab bar, gradient icon
tiles.

## Step 1 — Audit, don't build yet

Before writing any component code:
1. Inventory every live page in app/ against the pattern list above. For each page, note:
   what it currently looks like, whether a new pattern applies, and whether adopting it is
   actually worth it right now (a page with no equivalent live content yet — e.g. nothing
   pricing- or testimonial-shaped exists in the product — is NOT worth porting a pattern for).
2. Write the result as new TASKS.md entries (small vertical slices, same convention as
   existing entries). Do not silently decide scope — if a judgment call is close, flag it
   in progress.md for the human rather than guessing.
3. Strong candidates worth checking first (confirm against the actual pages, don't assume):
   - Bottom tab bar + gradient nav icons — the app has no bottom tab bar today; this is the
     single highest-value gap per the last design audit.
   - Candlestick price chart — check app/(app)/trade/page.tsx; if it lacks a real price
     chart, this is a direct fit.
   - Leaderboard pattern — app/(app)/friends/page.tsx already exists; check if it needs
     this treatment or already has an equivalent.
   - Stat card + progress bar — wherever streak/XP/portfolio numbers render as bare text
     today.
4. Stop and report the proposed task list before implementing anything. This is a real
   gate, not a formality — the human should see the plan before 3-6 days of work starts.

## Step 2 — Execute per task, swarm mode

For each approved task:
- Planner writes the vertical slice to loop-state.md.
- Maker implements on worktree `wt/<task-slug>` (per KIMI_HANDOFF.md §2), Tailwind against
  the existing tokens — no new hex values, no bypassing app/globals.css.
- Verifier runs the full gate list from VERIFIER.md / KIMI_HANDOFF.md §3 (tsc, lint, vitest,
  the RULES.md grep scan) PLUS: computed contrast check on any new tinted surface
  (reuse the color-mix rule from DESIGN.md), and a visual check in both light and dark mode.
- Serialize any task touching a migration; parallelize UI-only tasks across worktrees per
  the parallel-safety rules in docs/agents/LOOP_ENGINEERING.md.
- Lander merges to web-koinaku only after all gates pass, updates TASKS.md/progress.md,
  archives loop-state.md.

## Known open items to fold in or explicitly flag as skipped

- `colors.streak` is still red in lib/design-tokens.ts / app/globals.css, but the new
  badge/streak pattern in v4 treats streak as gold. Decide and note the decision in
  progress.md — don't silently pick one.
- Onboarding, login, signup, and trade pages were never re-screenshotted against the
  purple flip after the token change landed. Do that as part of Step 1's audit, not as an
  afterthought.

## Budget

Same as always: max 6 correction iterations per task, escalate to human on repeat gate
failure. This whole migration is not one task — don't try to run it as a single 6-iteration
loop. Expect 3-6 separate tasks from Step 1's audit.
