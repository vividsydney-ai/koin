# Koin — Product Vision (v2)

## What we are building
A mobile-first financial literacy app for Indonesian Gen Z (16–24), shipped as a Next.js web app wrapped with Capacitor for iOS and Android. It combines bite-sized lessons with a paper-trading sandbox. Think **Duolingo meets paper trading for money**: users learn concepts, practice them with virtual IDR, build a risk profile, and "graduate" to real investing only when they have proven judgment.

## The single metric that matters in MVP
Daily active learning sessions — a lesson completion **or** a paper trade. Not signups. Not page views.
If a user opens the app, learns or trades, and comes back tomorrow, we win.

## What we are NOT building
- Real-money trading or brokerage integrations
- Real-money deposits, withdrawals, or off-platform value for Koin Points
- Crypto-anything
- Open community feed
- DMs or chat between users
- A freeform financial chatbot
- A complex admin portal
- Stock recommendations or personalized investment advice

## Stack
- Next.js App Router + TypeScript
- Tailwind CSS
- Supabase (Postgres + Auth + Storage + RLS)
- Capacitor to wrap the Next.js app for iOS and Android
- Vercel deployment for web; Xcode + Android Studio builds for mobile
- Zod validation
- React Hook Form

## Design language
- Primary: #01696f (Hydra Teal)
- Background: #f7f6f2 (warm neutral)
- Border radius default: 0.5rem
- Font body: Satoshi (Fontshare)
- Font display: Cabinet Grotesk (Fontshare)
- Mobile-first. 375px baseline. 44px touch targets minimum.
- Warm, trustworthy, approachable. NOT neon. NOT crypto dashboard.

## Source trust hierarchy
- Tier 1 (required for publish): OJK, Bank Indonesia, IDX
- Tier 2 (enrichment only): OECD, World Bank, books
- Tier 3 (engagement): curated social media, YouTube creators

## Paper-trading principles
- Every user starts with **Rp 10.000.000** in virtual capital.
- Trades are lot-based (**100 shares**) on a curated set of IDX stocks.
- Portfolio value updates from seeded market data.
- **Koin Points** are earned from leaderboard rank, streak milestones, lesson completion, and graduation. They have value only inside Koin — no real-world redemption.
- **Graduation** is triggered when a user grows their portfolio to **3x–5x** the starting value.
- Graduates receive a **certificate of achievement** and curated recommendations to OJK-registered investing apps (Bibit, Ajaib, Stockbit, IPOT, Bareksa).
- Lessons adapt to trading behavior: panic-selling unlocks loss-aversion content, concentration unlocks diversification, inactivity unlocks confidence-building content.

## The rule we never break
No lesson reaches `is_published = true` without:
1. At least one `lesson_sources` record linking a Tier 1 source
2. A `lesson_reviews` record with `approved_to_publish = true`

## The second rule we never break
No certificate is issued without verified portfolio graduation (3x–5x starting value).
