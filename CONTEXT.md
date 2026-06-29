# Koin — Domain Language & Context

This document is the shared vocabulary for the Koin project. Agents and humans should use these terms consistently in code, tickets, and conversations.

## Core product terms

### Koin
The mobile-first financial literacy app for Indonesian Gen Z. Pronounced like "coin." Not a cryptocurrency product.

### User
An Indonesian young adult (target 16–24) using Koin to learn about money and practice investing via paper trading.

### Daily active learning session
The single metric that matters. A session is counted when a user completes a lesson or makes a paper trade on a given day.

## Learning domain

### Lesson
A structured micro-learning unit. Contains a concept card, an Indonesian example, and 3–5 quiz items. Each lesson is source-backed and human-reviewed before publish.

### Concept card
The canonical explanation of one financial concept. Source-backed, plain language, jurisdiction-specific.

### Example pool
A collection of localized Indonesian examples for a lesson. One example is randomly selected per session to keep content fresh.

### Question bank
A collection of quiz items for a lesson. Items are randomly drawn and shuffled per session to reduce copying.

### Content variant
An interchangeable piece of lesson content stored in `content_variants`: an example, a question, or an explanation. Variants enable per-session variety and anti-copying.

### Source tier
The trust hierarchy for content:
- **Tier 1** — OJK, Bank Indonesia, IDX (required for publish)
- **Tier 2** — OECD, World Bank, canonical books (enrichment only)
- **Tier 3** — Curated social media / creators (engagement layer)

### Source trust section
UI area in the lesson player that shows which sources back the current lesson and why they are credible.

## Gamification domain

### Streak
Consecutive days with at least one daily active learning session. Can be preserved by a streak freeze once if missed.

### Streak freeze
An inventory item that auto-applies to preserve a streak when a user misses one day.

### XP
Experience points earned for learning actions: lesson completion, quiz bonus, streak milestones, first trade, graduation.

### Level
A user progression tier unlocked by cumulative XP.

### Badge
An achievement earned for specific actions (e.g., First Step, 7-Day Streak, Scam Spotter, First Trade, Graduate).

### Koin Points
Virtual currency earned from leaderboard rank, streak milestones, lesson completion, and graduation. Has value only inside Koin. Not redeemable, transferable, or convertible to real money.

## Paper trading domain

### Paper trading
Simulated investing with virtual Indonesian Rupiah. No real money is at stake.

### Portfolio
A user's virtual holdings. Starts with Rp 10.000.000 cash. Contains cash balance + holdings.

### Holding
A position in a specific stock symbol within a portfolio: number of shares and average cost.

### Trade
A buy or sell action in the paper trading sandbox. Lot-based: 100 shares per lot.

### Market data
Daily OHLCV price data for IDX stocks used to update portfolio values.

### Watchlist
A list of stocks a user is tracking but does not own.

### Graduation
The milestone when a user's portfolio value reaches 3x–5x the starting value. Triggers a certificate and brokerage recommendations.

### Certificate
A shareable achievement issued only upon verified graduation.

### Brokerage recommendation
A curated pointer to an OJK-registered investing app (Bibit, Ajaib, Stockbit, IPOT, Bareksa). Not a stock recommendation.

## User profile domain

### Risk profile
A user's inferred risk tolerance based on a starter quiz and trading behavior. Maps to labels: conservative, moderate, growth, aggressive.

### Adaptive lesson trigger
A rule that recommends a lesson based on user behavior (e.g., panic sell → loss aversion lesson).

### Cohort
A group of users who joined via the same invite code, typically a school or friend group.

## Technical terms

### Maker agent
The agent role that writes code, migrations, and seed data. Must not self-verify or modify RULES.md.

### Checker agent
The agent role that verifies maker output against VERIFIER.md gates.

### Gate
A hard, automated check that must pass before a task is considered done.

### Vertical slice
A small, end-to-end deliverable that can be built and tested independently (e.g., "migration 001 + seed + tests").

## Terms we avoid

- "Investing advice" — Koin teaches frameworks, not what to buy
- "Real money" — paper trading uses virtual IDR only
- "Crypto" — not part of the product
- "Chatbot" — AI is assistive, not the primary interface
