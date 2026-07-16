# Koinaku — Product Requirements Document

**Version:** 1.1 (MVP Reality Check)  
**Date:** 2026-07-16  
**Status:** Web MVP Live at `https://web.koinaku.com`, Pre-Revenue, Seeking Validation  
**Product:** Koinaku — Financial Literacy App for Indonesian Gen Z  
**Tagline:** *Learn · Simulate · Grow — from zero to confident investor*

> **Reality note:** This PRD was written retroactively after the prototype was built. This version corrects over-claims, adds missing operational detail, and scopes Phase 1 to what is actually shippable today.

---

## 1. Problem Statement

### The Hard Data

| Metric | Value | Source |
|--------|-------|--------|
| Financial literacy index | **66.46%** — lowest in Southeast Asia | OJK SNLIK 2025 |
| Population | **270M+**, median age 29 | BPS Indonesia 2024 |
| Personal finance in schools | **0 hours** in Indonesian high school curriculum | Kemendikbud 2023 |
| Financial inclusion vs. literacy gap | **80.51%** have access to products, only **66.46%** understand them | OJK SNLIK 2025 |
| New retail investors on IDX since 2020 | **13M+**, 60% under age 30 | IDX data |

> **"People are investing before they understand how money works."**

13 million new retail investors entered the Indonesian stock market since 2020. The majority are under 30, smartphone-native, and have zero formal financial education. They learn from TikTok influencers, WhatsApp groups, and Instagram fin-fluencers — sources with no accountability, no sourcing, and no structured curriculum.

The result: young Indonesians are losing money to scams, panic-selling during dips, concentrating portfolios in a single stock because a friend recommended it, and developing risk profiles they don't understand.

### Why Existing Solutions Fail

- **ChatGPT / Google:** Has all the content, zero structure, zero accountability, zero habit formation.
- **OJK PDFs / Bank Blogs:** Credible but unreadable. Nobody reads a 40-page PDF twice.
- **Online Courses:** < 10% completion rate. No forcing function. No stakes.
- **Bibit / Ajaib / Stockbit:** Trading apps, not education platforms. You must already know what you're doing.
- **School Apps:** Don't touch personal finance, investing, or real-world money skills.

The literacy-first category in Indonesia is **completely uncontested.**

---

## 2. Product Overview

Koinaku is a mobile-first financial literacy app that makes learning about money a **daily habit** — not a one-time course. It combines Duolingo-style micro-lessons with a **paper trading sandbox** where users practice with virtual Rupiah before risking real money.

### Positioning Statement

> For **Indonesian Gen Z (18–30)** who **want to invest but don't understand the basics**, Koinaku is a **financial literacy app** that **turns learning into a daily habit through bite-sized lessons and simulated trading**. Unlike **Bibit or Ajaib** (trading apps that assume you already know), or **ChatGPT** (unstructured information with no accountability), Koinaku **builds real financial behaviour through streaks, XP, and a paper trading sandbox that creates stakes without real risk**.

### The Four Pillars

| Pillar                       | What It Does                                                                                                                                                       | Why It Matters                                                                                     |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| **Bite-Sized Lessons**       | 5-minute structured lessons from "Apa itu uang?" to IDX investing. Each lesson cites a Tier 1 Indonesian source (OJK, BI, IDX) before the quiz.                    | Trust is the product. Every claim is verifiable.                                                   |
| **Paper Trading Playground** | Simulated IDX stock trading with Rp 10.000.000 virtual capital. Live-moving prices, lot-based orders (100 shares), full portfolio tracker.                         | Creates stakes without real risk. The forcing function that brings users back on day 4.            |
| **XP & Streak System**       | Gamified daily habit: lessons earn XP, streaks unlock badges, weekly friend leaderboards create social accountability.                                             | Duolingo-proven mechanics. Breaking a streak hurts — and that's the point.                         |
| **Graduate to Real**         | When a user grows their portfolio 3x–5x, they receive a certificate and curated hand-off to OJK-registered investing apps (Bibit, Ajaib, Stockbit, IPOT, Bareksa). | Koinaku is the pre-onboarding funnel. We don't compete with brokers — we feed them educated users. |

### User Journey

```
Sign Up → Onboarding Assessment → Learn (5-min lesson) → Quiz → Earn XP
     ↓                                          ↓
  Streak Begins ←←←←←←←←←←←←←←←←← Paper Trading Sandbox
     ↓                                          ↓
  Leaderboard ←←←←←←←←←←←←←←←←←←← Level Up / Badge Earned
     ↓                                          ↓
  Koin Pro Unlock ←←←←←←←←←←←←←←←← Graduate (Certificate + Broker Referral)
```

**The Habit Loop:** Learn → Quiz → Trade → Earn XP → Streak maintained → Social accountability → Repeat tomorrow.

---

## 3. Target Users

### Primary ICP: Indonesian Gen Z — "The Curious But Clueless"

**Demographics:**
- Age: 18–25 (stretch: 16–30)
- Location: Urban Indonesia (Jakarta, Surabaya, Bandung, Yogyakarta, Medan)
- Education: High school or university student, or early-career worker
- Device: Android or iPhone, used throughout the day in short bursts
- Income: Rp 1–5 juta/month (student allowance or entry-level salary)

**Psychographics:**
- Skeptical of financial advice from social media but curious because friends/family talk about investing
- Has tried Instagram/TikTok finance content but doesn't trust it
- Wants to learn without feeling talked down to
- Anxious about "looking stupid" for not knowing basic money concepts
- Motivated by social proof and competition with peers
- Prefer Bahasa Indonesia; English is a barrier, not a feature

**Jobs-to-be-Done:**
1. *When I hear friends talk about stocks, I want to understand what they're saying so I don't feel left out.*
2. *When I see an investment ad on Instagram, I want to know if it's a scam so I don't lose my savings.*
3. *When I get my monthly allowance, I want to know how to budget so I don't run out by week 3.*
4. *When I hear about "Reksa Dana," I want to understand what it is so I can decide if it's right for me.*

### Secondary ICP: Parents & Educators (B2B Future)

- Schools looking for OJK-aligned financial literacy curriculum (CSR mandate)
- Banks wanting customer education programs (BRI, BNI, Bank Jago)
- Corporates offering employee financial wellness programs

---

## 4. Requirements

### 4.1 Must Have (MVP — Built & Shipped)

| # | Requirement | Status | Notes |
|---|-------------|--------|-------|
| R1 | **User Authentication:** Email + password signup with Supabase Auth. Profile creation with username, display name, age range, financial goals. | ✅ Built | Google OAuth removed; email-only for now. |
| R2 | **Onboarding Flow:** 5-step onboarding (name → age → goals → risk tolerance intro → notification preference) + financial literacy assessment that personalizes lesson unlocks. | ✅ Built | Assessment added July 2026 (KO-45). |
| R3 | **Lesson Player:** Title → concept card → Indonesian example → quiz → source trust section → completion. One concept per screen, no scroll walls. | ✅ Built | Content variant engine: random examples/questions per session. |
| R4 | **Quiz Engine:** Multiple choice, true/false, fill blank, word bank, ordering. Shuffled answers, parameterized numeric questions, 7-day variant cooldown. | ✅ Built | Matching, slider, swipe_yes_no, case_study declared but UI pending. |
| R5 | **Paper Trading Sandbox:** Portfolio with Rp 10.000.000 virtual capital. Buy/sell lot-based orders (100 shares) on curated IDX stocks. Holdings + trade history. | ✅ Built | Market data seeded; daily price update architecture in place. |
| R6 | **Streak Engine:** Daily check-in, freeze logic, streak lost state. | ✅ Built | |
| R7 | **XP & Level System:** XP awarded on lesson completion, quiz bonus, streak milestones, first trade. 10 levels with thresholds. | ✅ Built | |
| R8 | **Badge System:** 10+ MVP badges (first trade, streak milestones, graduation). Trigger-based award engine. | ✅ Built | |
| R9 | **Koin Points:** Awarded on streak milestones and lesson completion. Balance visible on Home and Profile. In-app currency only — no real-world redemption. | ✅ Built | |
| R10 | **Source Trust:** Every lesson shows source card with tier badge, URL, review status before quiz. Tier 1 = OJK/BI/IDX required for publish. | ✅ Built | 32 source records seeded. |
| R11 | **Content Pipeline:** Lessons stored in Supabase. Review workflow: not_started → draft → needs_review → approved → live. No lesson publishes without ≥1 Tier 1 source + approved review. | ✅ Built | **12 lessons (6 beginner live, 6 advanced draft). ~805 active content variants.** 1,783 variants generated; 284 deactivated for quality. |
| R12 | **Home Dashboard:** Streak card, today's lesson CTA, portfolio snapshot, Koin Points, leaderboard snippet, recent badge. | ✅ Built | |
| R13 | **App Shell:** Bottom nav (Home / Learn / Trade / Friends / Library / Profile). Protected routes. Mobile-first (375px baseline, 44px touch targets). | ✅ Built | |
| R14 | **Adaptive Learning:** Lessons adapt to trading behavior (panic-selling → loss aversion content, concentration → diversification, inactivity → confidence content). | ✅ Partial | Trigger engine exists with rule stubs; thresholds not validated against real user behaviour. |
| R15 | **Graduation System:** Portfolio growth to 3x–5x starting value triggers certificate + brokerage recommendations (Bibit, Ajaib, Stockbit, IPOT, Bareksa). | ✅ Built | |

### 4.2 Should Have (Phase 2 — In Planning)

| # | Requirement | Status | Notes |
|---|-------------|--------|-------|
| R16 | **Koin Pro Subscription:** Rp 49.000/month. Advanced lessons (tax, macroeconomics, portfolio theory), AI-powered financial coaching, certified completion certificates, exclusive cohort access. | 🔄 Not Built | Paywall architecture ready. Stripe/Xendit integration needed. |
| R17 | **Social Features:** Friend system, invite flow, weekly leaderboards, cohorts. | ✅ Partial | Friendships + leaderboards built. Full social feed NOT built. |
| R18 | **Money Dictionary:** Plain-language glossary of 50+ financial terms with Indonesian examples. | 🔄 Not Built | Content planned, UI not implemented. |
| R19 | **Push Notifications:** Streak reminders, lesson nudges, price alerts. | 🔄 Not Built | Architecture stubbed; not wired to delivery. |
| R20 | **Analytics & Dashboard:** Admin view of DAU, activation, retention, lesson completion rates, trading activity. | 🔄 Not Built | Raw data exists in DB; no admin UI. |
| R21 | **Content Expansion:** 50+ lessons across beginner → intermediate → advanced. | 🔄 In Progress | **12 lessons seeded** (6 beginner live, 6 advanced draft). Target 50 by end of Phase 2. |
| R22 | **A/B Testing Framework:** Variant testing for onboarding, lesson order, pricing page. | 🔄 Not Built | |

### 4.3 Could Have (Phase 3 — Future)

| # | Requirement | Status |
|---|-------------|--------|
| R23 | **B2B Licensing:** OJK-aligned curriculum sold to schools, banks, corporates. | 🔄 Not Built |
| R24 | **AI Financial Coach:** Personalized coaching based on trading behaviour and lesson performance. | 🔄 Not Built |
| R25 | **Community Features:** Discussion forums, mentor matching, user-generated content. | ❌ Explicitly Out of Scope (VISION.md) |
| R26 | **Real Broker API Integrations:** Direct connect to Bibit/Ajaib for graduated users. | ❌ Explicitly Out of Scope |
| R27 | **Crypto / Forex Education:** | ❌ Explicitly Out of Scope |

### 4.4 Will Not Have (Explicitly Out of Scope)

- Real-money trading or brokerage integrations
- Real-money deposits, withdrawals, or off-platform value for Koin Points
- Crypto-anything
- Open community feed or DMs between users
- Freeform financial chatbot
- Complex admin portal (keep it simple)
- Stock recommendations or personalized investment advice (regulated activity)

---

## 5. Success Metrics

### North Star Metric
**Daily Active Learning Sessions** — a lesson completion OR a paper trade per day per user.

> Not signups. Not page views. If a user opens the app, learns or trades, and comes back tomorrow, we win.

### Input Metrics (Weekly)

> **Prerequisite:** These metrics require analytics instrumentation (R20). Until built, all targets are aspirational and cannot be validated.

| Metric | Current Baseline | Phase 1 Target | Phase 2 Target |
|--------|-----------------|----------------|----------------|
| Sign-up → Lesson Start (Activation) | Not instrumented | > 60% | > 70% |
| Day-7 Retention | Not instrumented | > 25% | > 35% |
| Day-30 Retention | Not instrumented | > 15% | > 25% |
| Lesson Completion Rate | Not instrumented | > 40% | > 50% |
| First Trade within 7 Days | Not instrumented | > 20% | > 30% |
| Streak ≥ 7 Days | Not instrumented | > 15% | > 25% |
| Average Session Length | Not instrumented | 4–6 min | 4–6 min |

### Revenue Metrics (Phase 2+)

| Metric | Target |
|--------|--------|
| Free-to-Paid Conversion | > 3% |
| Koin Pro MRR | Rp 50 juta by Month 6 of Phase 2 |
| B2B Pilot Customers | 3 schools / 1 bank by Month 9 |

### Guardrail Metrics (Should Not Worsen)

- Source trust score: % of published lessons with ≥1 Tier 1 source = 100%
- Content review backlog: avg days from draft to approved < 7
- Support ticket volume: < 5% of MAU

---

## 6. Business Model

### Phase 1: Free to Habit (Now — MVP)
- Core lessons and paper trading: **free forever**
- Goal: Build MAU through organic discovery, school partnerships, social virality
- Product earns trust before it earns money

### Phase 2: Koin Pro (Next)
- **Price:** Rp 49.000 / month
- **Includes:** Advanced lessons (tax, macroeconomics, portfolio theory), AI-powered financial coaching, certified completion certificates, exclusive cohort access
- **Target:** Power users who complete beginner track and want to go deeper

### Phase 3: B2B Institutional Licensing (Future)
- **Customers:** Schools (CSR mandates), banks (BRI, BNI, Bank Jago), corporates (employee wellness)
- **Product:** OJK-aligned curriculum, white-label deployment, progress dashboards
- **Why it works:** Institutions buy proof, not promises. The consumer habit loop makes B2B sales easy.

### Unit Economics (Modelled)

| Metric | Assumption |
|--------|-----------|
| ARPU (Koin Pro) | Rp 49.000 / month ≈ $3.10 (placeholder until pricing smoke test) |
| Gross Margin | 85% (digital product, low COGS) |
| Monthly Churn (estimated) | 8% (industry benchmark; actual unknown) |
| LTV | Rp 49.000 × 0.85 × 12.5 months ≈ **Rp 520.000** (~$32) — **speculative** |
| CAC (organic + school partnerships) | Rp 50.000–100.000 (~$3–6) — **speculative; assumes scalable organic** |
| LTV/CAC | **5–10x** — **unvalidated** |

---

## 7. Competitive Landscape

| Competitor | Category | Their Strength | Their Weakness | Koin's Edge |
|------------|----------|---------------|----------------|-------------|
| **Bibit** | Robo-advisor / Trading | Beautiful UI, trusted brand, real investing | Assumes you already know what a "Reksa Dana" is | We teach before they trade |
| **Ajaib** | Stock trading | Low fees, IDX access, popular with youth | No education layer; users learn by losing money | Simulated risk before real risk |
| **Stockbit** | Social trading | Community, real-time data | Overwhelming for beginners; no structured learning | Structured curriculum, one concept at a time |
| **ChatGPT** | General AI | Infinite content, free | No structure, no accountability, no habit formation, no Indonesian context | Habit loop, source-backed, local examples |
| **OJK PDFs** | Regulatory education | Credible, comprehensive | Unreadable, no mobile experience, no engagement | Same credibility, 100x the engagement |
| **Online Courses (Coursera, etc.)** | Long-form education | Certificates, university partnerships | < 10% completion, no Indonesian context, no practice | 5-minute lessons, paper trading, daily habit |

**Key Insight:** No one competes in the "literacy-first" category. Bibit/Ajaib are trading apps. School apps don't teach personal finance. Koin owns the space between "I know nothing" and "I'm ready to invest."

---

## 8. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| **Users don't form the habit** — low D7/D30 retention | Medium | High | Paper trading is the forcing function. If users don't trade, adaptive triggers re-engage. A/B test notification timing. |
| **Content creation bottleneck** — can't produce 50+ lessons fast enough | High | High | Structured content pipeline with templates. Community contributor model. AI-assisted drafting with human review. |
| **B2B sales cycle is long** — schools/banks move slowly | Medium | Medium | Start with consumer traction as proof. Pilot with 2–3 schools for case studies. Partner with CSR-focused banks. |
| **Competitor clones the idea** — well-funded team copies mechanics | Medium | Medium | Moat is behavioural data + OJK relationships + localisation depth. 6-month head start + data flywheel. |
| **OJK regulation changes** — financial education requirements shift | Low | High | Stay aligned with OJK SNLIK updates. Position as partner, not competitor, to regulatory goals. |
| **Payment friction** — Indonesian users reluctant to subscribe | Medium | Medium | Start with school/institutional licenses (B2B pays). Offer annual discount. Consider carrier billing or e-wallet (OVO, GoPay, DANA). |
| **Analytics & notifications not built** — cannot measure retention or remind users | High | High | Block Phase 1 launch until `analytics_events` table and push delivery are wired. |
| **Regulatory blur on brokerage referrals** — "Graduate to Real" may be seen as advice/promotion | Medium | High | Legal review before soft launch. Use neutral language: "OJK-registered brokers" not recommendations. |

---

## 9. Rollout Plan

### Phase 1: Validate the Habit (Now — Month 1–3)
- **Goal:** 100 daily active learning sessions (lesson + trade)
- **Shippable today:** Web MVP with 6 beginner lessons + paper trading + streaks + XP.
- **Blockers before launch:** Analytics instrumentation (R20) and notification delivery (R19) must be wired so retention is measurable and streak reminders actually fire.
- **Tactics:** Soft launch to personal networks, university groups, TikTok organic content
- **Kill Criteria:** D7 retention < 15% after 200 signups, or < 10% of users complete first trade
- **Success Signals:** > 20% of users start a streak, > 30% complete first lesson

### Phase 2: Find the Wedge (Month 4–6)
- **Goal:** 1,000 DAUs, identify the ICP segment with highest retention
- **Tactics:** Double down on highest-retention channel, launch Koin Pro, test pricing
- **Kill Criteria:** Free-to-paid < 1% after 500 qualified users, or CAC > Rp 200.000 with no organic loop
- **Success Signals:** One channel with repeatable acquisition, > 3% free-to-paid conversion

### Phase 3: Scale the Loop (Month 7–12)
- **Goal:** 10,000 DAUs, Rp 50 juta MRR, 3 B2B pilots
- **Tactics:** Content marketing SEO, school partnerships, paid social (TikTok/Instagram), influencer collabs
- **Kill Criteria:** Monthly churn > 10% after 3 months, or LTV/CAC < 3x
- **Success Signals:** Net revenue retention > 100%, organic referrals > 20% of new signups

### Rollback Criteria
- **Immediate rollback:** Data breach, source link fraud (fake citations), OJK compliance issue
- **Feature rollback:** Any feature that drops D7 retention by > 5 percentage points
- **Product rollback:** If Phase 1 kill criteria are met, pivot to B2B-first or education-consulting model

---

## 10. Design & Tech Constraints

### Design Principles
1. **Source before opinion:** Every lesson shows its source card before the quiz.
2. **Bite-sized or nothing:** One concept per screen; no scrolling through walls of text.
3. **Local examples first:** Abstract concepts land through Indonesian daily life (mie ayam, GoPay, warung).
4. **Motion with meaning:** Animations explain, not decorate.
5. **Trust through restraint:** No dark patterns, no fake urgency, no hidden risk.

### Tech Stack
- **Frontend:** Next.js App Router + TypeScript + Tailwind CSS
- **Backend:** Supabase (Postgres + Auth + Storage + RLS)
- **Mobile:** Capacitor wrapper for iOS/Android (web-first, native track paused)
- **Deployment:** Vercel (web), Xcode + Android Studio (mobile builds)
- **Validation:** Zod + React Hook Form

### Accessibility
- WCAG 2.1 AA target
- Reduced-motion fallback for all animations
- Minimum 44px touch targets
- Clear contrast on all text

---

## 11. Blind Spots Addressed in v1.1

The retroactive PRD over-stated shipped scope and under-stated operational gaps. This section records the reality check.

### Product / Traction
1. **No evidence paper trading is the habit driver.** The PRD claimed trading is the "forcing function on day 4." We now treat this as a hypothesis to test, not fact.
2. **North Star cannot be measured yet.** "Daily Active Learning Sessions" requires analytics instrumentation (R20), which is not built.
3. **Graduation target may be unrealistic.** 3x–5x portfolio growth in a low-volatility simulated market could take months. We will model feasibility before declaring it the core loop.
4. **Koin Points have no spend path.** Points are earned but cannot be spent. MVP launch is acceptable, but a utility must be designed before Phase 2.

### Technical / Implementation
5. **Lesson count was overstated.** PRD claimed 15 lessons; actual shippable count is **12 lessons** (6 beginner live, 6 advanced draft) and **~805 active content variants**.
6. **Adaptive triggers are structural, not validated.** Trigger rules exist but thresholds are not tied to observed behaviour.
7. **Analytics and notifications are blockers, not nice-to-haves.** Without them, Phase 1 success metrics and retention loops are unproven.
8. **Native mobile is paused.** The PRD calls Koin "mobile-first" but only the web PWA is live. Push notifications and home-screen retention are degraded.
9. **No data retention / deletion policy.** Account closure and data export are not specified.

### Legal / Compliance
10. **Brokerage referral may cross regulatory lines.** Listing specific brokers after "graduation" could be read as investment advice or promotion under OJK rules. Legal review required before soft launch.

### Business Model
11. **LTV/CAC assumptions are speculative.** Organic + school-partnership CAC of Rp 50k–100k assumes scalable organic acquisition, which is unproven.
12. **Pricing is untested.** Rp 49k/month Koin Pro price is a placeholder until a smoke test validates willingness to pay.

---

## 12. Open Questions & Next Steps

### Open Questions
1. **What is the actual aha moment?** Is it first lesson completion, first trade, or first streak milestone? (Requires cohort analysis on real user data.)
2. **Which channel works?** Organic TikTok, school partnerships, or paid social? (Requires Phase 1 launch data.)
3. **Will users pay Rp 49k/month?** What features justify the price? (Requires pricing smoke test or Koin Pro beta.)
4. **Can we produce content at scale?** 50 lessons is the minimum for retention. Can the content pipeline sustain 2 lessons/week? (Requires content team capacity test.)

### Immediate Next Steps (This Week)
- [x] Audit actual shipped lesson/variant counts and align PRD claims with reality.
- [ ] **Build analytics event pipeline in Supabase** (team of 1 — use `analytics_events` table, not paid third-party tool).
- [ ] **Wire push notification delivery** so streak reminders reach users.
- [ ] Soft launch to 50 real users (not dev accounts) and observe Day-1 behaviour.
- [ ] Define "active learning session" event and start measuring North Star.
- [ ] Model graduation feasibility: simulate time-to-3x portfolio under current market data volatility.
- [ ] Legal review: clarify whether "Graduate to Real" broker list is investment advice/promotion under OJK rules.
- [ ] Create a Koin Pro pricing smoke test landing page to validate willingness to pay.

---

## Appendix A: Content Trust Rules

**Rule 1:** No lesson reaches `is_published = true` without:
1. At least one `lesson_sources` record linking a Tier 1 source (OJK, BI, IDX)
2. A `lesson_reviews` record with `approved_to_publish = true`

**Rule 2:** No certificate is issued without verified portfolio graduation (3x–5x starting value).

**Source Tier Hierarchy:**
- Tier 1 (required): OJK, Bank Indonesia, IDX
- Tier 2 (enrichment): OECD, World Bank, books
- Tier 3 (engagement): curated social media, YouTube creators

---

## Appendix B: Glossary

| Term | Definition |
|------|-----------|
| **OJK** | Otoritas Jasa Keuangan — Indonesian Financial Services Authority |
| **BI** | Bank Indonesia — Indonesian central bank |
| **IDX** | Indonesia Stock Exchange |
| **SNLIK** | Survei Nasional Literasi dan Inklusi Keuangan — National Financial Literacy & Inclusion Survey |
| **Reksa Dana** | Mutual fund |
| **SBN** | Surat Berharga Negara — government bonds |
| **Paper Trading** | Simulated trading with virtual money, no real financial risk |
| **Koin Points** | In-app currency earned through streaks and lessons; no real-world value |
