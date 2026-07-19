# DESIGN.md — Koinaku Design System (canonical)

> Distilled 2026-07-18 from `ui-lift.md` + the v4 design bundle. This is the
> in-repo source of truth the Verifier gates design work against.
> Pattern reference (not a component library):
> `/Users/vividm4/Documents/All Designs System Bundle/Koinaku Design System v4/`
> — plain React + CSS custom properties. Re-implement patterns in Tailwind
> against `app/globals.css`; never copy its CSS/JSX verbatim.

## Token source of truth

- `app/globals.css` (live Tailwind v4 CSS-first config) and `lib/design-tokens.ts` (agent reference).
- Drift gate: `bash scripts/design-drift-check.sh` must pass after any token change.

## Color roles

- **Orbit Purple `#6f4af0` (primary):** actions, selection, focus — ~10% of visual weight. Never decoration.
- **Red:** danger/destructive only.
- **Green:** success.
- **Blue:** info / XP.
- **Gold:** reward surfaces (streak, badges, Koin Points). *Decided 2026-07-18 (human): streak moved from red to gold.*

## Gradient rule

`--gradient-brand` is allowed on nav icons and achievement/badge surfaces only. Hard bans:

- gradient text
- side-stripe borders on cards
- glassmorphism as default
- identical repeated card grids

## Tinted surfaces (dark-mode rule)

Never use a raw `-50` background token directly. Always:
`color-mix(in srgb, var(--color-X) 8%, var(--surface))`.
(The repo has no dark theme yet; this rule applies now to light-mode tinted surfaces too — a past bug produced ~1:1 contrast by skipping it.)

## Component conventions

- Card radius `--radius-card` (18px); pill-shaped primary buttons.
- Focus ring `--shadow-focus-ring` on interactive elements.
- 44px minimum touch targets.
- Mobile design baseline is iPhone 15 Pro logical width: 393px. Do not optimize the primary mobile layout below 393px unless explicitly handling an edge case.
- The wide product breakpoint starts at 1200px or higher. Do not treat 1080px/1180px as the widest layout target.
- Blur tokens (`--blur-sm`, `--blur-md`, `--blur-lg`) are blur-only effects. Do not add borders to blur token demos or blur-only panels; use shadow/elevation if they need separation.
- Bottom nav: 6 tabs (Home, Learn, Trade, Friends, Library, Profile) — keep 6; v4's 4-tab example is styling reference only.
- Bottom nav icons: SVG with gradient active state (pattern: v4 `GradientIcon`), not emoji.
