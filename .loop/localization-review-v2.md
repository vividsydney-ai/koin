# Localization Review Report — Koinaku MVP v2.0 Curriculum

**Reviewer:** Indonesian Contextualizer subagent  
**Date:** 2026-07-16  
**Inputs reviewed:**
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/lesson-bodies-v2.json`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/lesson-variants-v2.json`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/.loop/curriculum-v2.md`
- `/Users/vividm4/Documents/Projects/Side-Gigs/Koin/Github-repo/PRD.md`

## Scope

Reviewed all **32 lesson bodies** and **256 content variants** for Indonesian teen authenticity, language level, currency realism, brand/institution relevance, trust/restraint tone, and name localization.

## Summary of changes

| File | What changed |
|------|--------------|
| `lesson-bodies-v2.json` | 10 targeted edits across 8 slugs |
| `lesson-variants-v2.json` | 1 edit in `macro-indicators` variant |

No slugs, lesson numbers, source mappings, or correct answers were changed. JSON structure and schema remain intact.

## Top categories of issues found

1. **Western financial concepts transplanted into Indonesian bodies**
   - `mortgage` → `KPR bank loan`
   - `student debt` → `education debt`
   - `retirement money` / `retirement savings` → `pension fund (dana pensiun)` or `long-term money`
   - `Tax-advantaged accounts` → `tax incentives under Indonesian rules`

2. **Western brand mentions in Indonesian-language variants**
   - `iPhone` in a macro-indicators example replaced with generic `smartphone`.

3. **Implicit Western framing of protection/tax institutions**
   - `health insurance` reframed to include `BPJS Kesehatan or private health insurance`.
   - `tax office` clarified to `tax office (Direktorat Jenderal Pajak)`.

4. **Currency labeling in macro context**
   - `US dollar` instances paired with `(dolar AS)` to keep the Indonesian translation clear.

## Slugs with notable changes

- **`assets-vs-liabilities`** — Removed `mortgage` and `student debt`; replaced with `KPR bank loan` and `education debt` so the examples feel like Indonesian credit products.
- **`goal-setting-101`** — Replaced `retirement savings` with `building a pension fund (dana pensiun)`.
- **`bank-vs-investment`** — Replaced `retirement money` with `long-term money such as pension savings`.
- **`portfolio-thinking`** — Replaced `retirement in 30 years` with `building a pension fund or starting a business in 20–30 years`.
- **`macro-indicators`** — Added `(dolar AS)` to `US dollar` references; kept exchange-rate framing because USD is the relevant import-pricing benchmark for Indonesian teens.
- **`taxes-on-returns`** — Removed `Tax-advantaged accounts` phrasing and added `Direktorat Jenderal Pajak`.
- **`building-financial-plan`** — Added `BPJS Kesehatan` as the primary health-coverage reference.
- **`macro-indicators` (variant)** — Replaced `iPhone` with `smartphone` and `dolar` with `dolar AS`.

## What was already strong

- Examples already use Indonesian names (Bayu, Rina, Doni, Ani, Budi, Sari, Dodi, Eko, Fani, Raka, Dina, Citra).
- Currency amounts are realistic for students and young workers (Rp 100k–Rp 10M range).
- Daily contexts are authentic: mie ayam, warung, GoPay/OVO/DANA, pulsa, Shopee flash sales, PayLater, pinjol, ojek online, BCA, kos.
- Scam-defense lessons maintain an OJK-aligned cautious tone and do not glamorize scams.
- IDX-specific content uses real Indonesian tickers (BBCA, TLKM, GOTO).

## Validation

```text
lesson-bodies-v2.json:    parsed OK, 32 lessons
lesson-variants-v2.json:  parsed OK, 256 variants
Lessons with variants:    32 / 32
Orphan variant slugs:     0
```

## Questions / blockers for the Conductor

1. **Retirement/pension framing:** I kept "pension fund (dana pensiun)" as the long-term goal because it is the closest Indonesian equivalent, but an 18-year-old may not yet relate to it. Should we instead use "starting a business" or "buying a first home" as the primary long-term example?
2. **KPR mention in beginner lesson:** `assets-vs-liabilities` now references `KPR bank loan`. Is the term `KPR` assumed known at beginner level, or should we spell it out parenthetically on first use?
3. **BPJS Kesehatan:** Added as the default health-coverage reference. Confirm this aligns with the project's compliance stance on government programs.
4. **Dolar AS in macro lesson:** Kept explicit USD references because Indonesian import prices (gadgets, fuel) are commonly quoted against USD. Confirm this is acceptable or prefer a neutral "foreign currency" framing.

No blockers prevent moving to the VERIFY stage.
