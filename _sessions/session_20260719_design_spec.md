# Design-system polish spec — Koinaku v4 card gallery

Source of truth: `DESIGN.md` and `/Users/vividm4/Documents/All Designs System Bundle/Koinaku Design System v4/`. Re-implement patterns in Tailwind against `app/globals.css` tokens. Do **not** copy CSS/JSX verbatim from the bundle.

## Tokens to use

- Radius: `rounded-card` (18px), `rounded-md` (8px), `rounded-lg` (12px), `rounded-full`.
- Surfaces: `bg-surface`, `bg-background`, `bg-muted`, `bg-surface-raised`, `bg-surface-inset`.
- Text: `text-foreground`, `text-muted-foreground`, `text-primary`, `text-success`, `text-danger`, `text-warning`, `text-info`, `text-xp`, `text-streak`.
- Borders: `border-muted`, `border-border`, `border-primary/30`, `border-success/30`, `border-danger/30`.
- Shadows: `shadow-sm`, `shadow-md`.
- Color-mix for tinted surfaces is preferred when a token class is not enough (e.g. `bg-primary/5` is fine; for subtle tints use inline `style={{ background: 'color-mix(in srgb, var(--color-primary) 8%, var(--color-surface))' }}`).

## Card kicker

```jsx
<span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
  <Icon size={13} />
  {label}
</span>
```

Use kickers to label sections: lesson step name, quiz type, source tier, etc.

## Choice / option buttons

Base:

```jsx
<button className="flex w-full items-center gap-3 rounded-md border px-4 py-3.5 text-left text-sm font-semibold transition-all active:scale-[0.98] disabled:cursor-default">
```

States:

- Neutral: `border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5`
- Correct: `border-success bg-success/10 text-success`
- Wrong: `border-danger bg-danger/5 text-danger`
- Disabled: already handled by `disabled:cursor-default`; keep existing answer state.

Optional leading status circle (for multiple choice):

```jsx
<span className="flex h-5 w-5 shrink-0 items-center justify-center rounded-full border text-xs ...">
  {status === "correct" ? "✓" : status === "wrong" ? "✕" : ""}
</span>
```

## Binary choice grid

For true/false and yes/no:

```jsx
<div className="grid grid-cols-2 gap-3">
  <button className="... choice-binary ...">{icon} {label}</button>
</div>
```

Use `justify-center` and an icon (`ThumbsUp/ThumbsDown` or `Check/X`).

## Quiz feedback

```jsx
<div className="rounded-md bg-muted p-3 text-sm font-medium text-foreground">
  {explanation}
</div>
```

## Source cards

### Dark source card (primary / verified source)

```jsx
<article className="rounded-card border border-primary/30 bg-gradient-to-br from-[var(--rup-orbit-900)] to-[#0b0916] p-5 text-white">
  <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
    <FileText size={14} /> {t("lesson.primarySource")}
  </span>
  <h4 className="mt-3 font-display text-lg font-bold text-white">{title}</h4>
  <p className="mt-1 text-sm text-white/70">{organization}</p>
  <p className="mt-3 text-sm leading-relaxed text-white/80">{synopsis || relevanceBlurb}</p>
  {url && <a className="mt-3 inline-flex items-center gap-1 text-sm font-bold text-primary-200 hover:text-white">{t("lesson.readSource")} <ArrowRight size={14} /></a>}
</article>
```

### Article / compact source card

```jsx
<article className="grid grid-cols-[96px_minmax(0,1fr)] gap-4 rounded-card border border-muted bg-surface p-4">
  <div className="flex h-24 items-center justify-center rounded-md bg-gradient-to-br from-red-50 to-surface-2 text-red-700">
    <Newspaper size={26} />
  </div>
  <div className="grid min-w-0 content-start gap-1.5">
    <span className="card-kicker ...">{type}</span>
    <h4 className="font-display text-base font-bold text-foreground">{title}</h4>
    <p className="text-sm text-muted-foreground line-clamp-2">{synopsis}</p>
  </div>
</article>
```

## Hero banner card (lesson intro)

```jsx
<article className="relative overflow-hidden rounded-card bg-gradient-to-br from-primary to-[var(--rup-orbit-700)] p-6 text-white">
  {/* decorative shapes */}
  <span className="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-white/10" />
  <span className="absolute -bottom-10 -left-10 h-24 w-24 rounded-full border-[10px] border-white/10" />
  <div className="relative">
    <span className="card-kicker-on-brand">{kicker}</span>
    <h3 className="mt-3 font-display text-2xl font-bold">{title}</h3>
    <p className="mt-2 text-white/80">{body}</p>
  </div>
</article>
```

## Feature / concept card

```jsx
<article className="rounded-card border border-muted bg-surface p-5 shadow-sm">
  <span className="card-kicker">{kicker}</span>
  <h4 className="mt-2 font-display text-lg font-bold text-foreground">{title}</h4>
  <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{body}</p>
</article>
```

## Bottom navigation

- Active tab: label `font-bold text-primary`; icon uses gradient stroke via `GradientIcon` active state. Wrap icon in a subtle `bg-primary/10 rounded-md` container if it improves tap target.
- Inactive tab: `text-muted-foreground`.
- Keep 6 tabs.
- Tap target minimum 44px.

## Buttons / CTAs

- Primary CTA: `rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98]`.
- Secondary/ghost: `rounded-md border border-muted bg-surface px-5 py-3.5 text-sm font-semibold text-foreground hover:bg-muted/20`.
- Mini link: `inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline`.

## What to preserve

- All existing data flow, hooks, event handlers, i18n keys, and accessibility attributes.
- No new runtime dependencies.
- Do not change the underlying logic of quizzes, completion, gating, or navigation.

## Verification

After changes run:

```bash
npm run type-check
npm run lint
npm run test
npm run build
```

Fix any new errors/warnings introduced by the refactor.
