# Koin Lesson Template

Use this template to add a new financial literacy lesson to the Koin web app.

## File structure

Create a new folder under `app/learn/{lesson-slug}/` with a single `page.tsx` file:

```
app/learn/
  inflation-101/
    page.tsx
  your-lesson-slug/
    page.tsx
```

Then add the lesson to the list in `app/(app)/learn/page.tsx`.

## Required lesson shape

Every lesson has exactly 5 steps:

1. **Intro** — hook, title, one-sentence value prop, duration, XP
2. **Concept** — the core idea with a custom SVG/CSS animation
3. **Example** — an Indonesian character story with local numbers and context
4. **Quiz** — 1 multiple-choice question with immediate feedback
5. **Source** — a verified Tier 1 source (BI, OJK, IDX, BPK, Ministry of Finance)

## Copy rules

- One concept per screen.
- Headlines: max 8 words.
- Body text: max 2 short paragraphs per screen.
- Use Indonesian examples (Jakarta rent, mie ayam, GoPay, warung).
- No emojis. Use custom SVG icons.
- Numbers must be realistic. Do not fake precision.

## Source rule

**Every source URL must be verified before shipping.**

- Open the URL in a browser.
- Confirm the page exists and supports the claim.
- If the exact page is unavailable, link to the institution's main education/literacy page and add a note.

Verified sources used so far:

| Topic | Source | URL |
|---|---|---|
| Inflation | Bank Indonesia — Inflation | https://www.bi.go.id/en/fungsi-utama/moneter/inflasi/default.aspx |
| Money basics, budgeting, risk-return | Bank Indonesia — Education | https://www.bi.go.id/id/edukasi/default.aspx |

For capital-market topics, verify the latest URL from:

- IDX Investor Education: https://www.idx.co.id
- OJK Literacy: https://www.ojk.go.id

## Animation guidelines

- Use CSS `@keyframes` or SVG animation.
- Keep animations under 1 second.
- Provide `prefers-reduced-motion` fallback.
- Motion must explain the concept, not decorate.

## Technical checklist

- [ ] Lesson page compiles (`pnpm build` passes)
- [ ] Lesson is listed in `app/(app)/learn/page.tsx`
- [ ] Source URL is verified
- [ ] Quiz has 1 correct answer and clear explanation
- [ ] No nested quotes inside JSX string props (use `{\`...\`}` if needed)

## Example minimal lesson

See `app/learn/inflation-101/page.tsx` for the full reference implementation.
