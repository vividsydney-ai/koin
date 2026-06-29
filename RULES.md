# RULES.md — Koin Engineering Rules
# This file is the loop's memory. It grows as we learn.
# Agents read this every session. Humans approve permanent entries.

## HARD STOPS — agent must halt and notify human

- STOP: Never set is_published = true without a lesson_reviews record
- STOP: Never write a migration that skips RLS on a user-sensitive table
- STOP: Never add localStorage or sessionStorage (sandbox iframe restriction — crashes silently)
- STOP: Never seed lessons before sources (foreign key violation)
- STOP: Never mock or hallucinate source URLs — all source.url values must be real verified links
- STOP: Never use US-only financial examples without an explicit localization_note field value
- STOP: Never write an open-loop task — every agent task must have a done condition
- STOP: Never allow real-money deposits, withdrawals, or brokerage integration in paper trading
- STOP: Never value Koin Points as real currency or allow off-platform transfer, resale, or redemption
- STOP: Never recommend a specific stock to buy or sell; only teach frameworks and risk concepts
- STOP: Never issue a certificate without verified portfolio graduation (3x–5x starting value)

## ARCHITECTURE RULES

- RLS policy must be written in the same migration file as the table it protects
- Every RLS policy must have a comment explaining who can access what and why
- All user-sensitive tables: profiles, lesson_attempts, lesson_progress, streaks,
  user_badges, xp_events, friendships, friend_invites, cohort_memberships
- Public-readable tables: lessons (where is_published = true), sources, topics, badges, levels
- Foreign keys must have ON DELETE CASCADE or ON DELETE SET NULL — never leave orphans
- Seed order: topics → levels → badges → sources → lessons → lesson_sources → lesson_reviews

## CODE RULES

- TypeScript strict mode. No `any` unless annotated with a comment explaining why.
- Zod schema for every form and API input
- Server actions over API routes where possible
- No hardcoded color values in components — use CSS variables from design-tokens.ts
- Every <img> tag needs alt, width, height, loading="lazy"
- Every interactive element needs aria-label if icon-only
- Minimum touch target 44x44px — use padding, not size alone
- All monetary values in Indonesian Rupiah (IDR) unless explicitly labeled otherwise
- All lesson example amounts in realistic Indonesian salary/spending ranges

## CONTENT RULES

- Indonesian examples must use IDR, local products, local brands, local institutions
- Acceptable brands to reference: BCA, BRI, Mandiri, BNI, GoPay, OVO, DANA, Bibit, Bareksa, Ajaib, Stockbit, IPOT
- Do not reference Vanguard, 401k, S&P 500, Roth IRA, or USD without a localization note
- Compound interest lesson must show Rp 500.000/month starting at 18 vs 30 as core example
- Scam lesson must reference investasi bodong, binary options, robot trading — not generic phishing
- Brokerage recommendations must include only OJK-registered platforms (Bibit, Ajaib, Stockbit, IPOT, Bareksa)
- Adaptive lesson triggers for panic sell, concentration, inactivity, or drawdown must reference IDX/OJK source material
- Paper trading examples must explain that virtual gains/losses do not equal real-market outcomes

## LESSONS LEARNED IN PREVIOUS SESSIONS
# (Agent may draft, human must approve before committing here)

- [2026-06-04] seed.sql must run after all migrations — migration 004 creates lesson_sources FK
- [2026-06-04] Tailwind purge misses dynamic class strings — use complete class names in code
