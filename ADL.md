# Koin — Architecture Decision Log (ADL)

Use this file to record significant technical and product decisions. Each entry should explain the decision, the alternatives considered, and the consequences.

## Template

```markdown
### ADL-XXX: Title
**Date:** YYYY-MM-DD
**Decision:** What we decided
**Alternatives considered:** Option A, Option B, Option C
**Rationale:** Why this decision was made
**Consequences:** What this means for the project
**Reversible?** Yes / No / Partial
```

## Decisions

### ADL-001: Mobile target is Capacitor-wrapped Next.js
**Date:** 2026-06-29
**Decision:** Ship iOS and Android by wrapping the existing Next.js app with Capacitor, rather than rewriting in React Native or Flutter.
**Alternatives considered:** React Native (Expo), Flutter, PWA-only
**Rationale:** Reuses the existing web codebase and Supabase integration; fastest path to App Store / Play Store. A native rewrite can happen later if retention proves strong.
**Consequences:** UI is web-rendered; App Store review may scrutinize the wrapper; native gestures/animations may need extra care.
**Reversible?** Yes — can migrate to React Native in Phase 2 if justified by metrics.

### ADL-002: Paper trading is core to the MVP, not v2
**Date:** 2026-06-29
**Decision:** Pull paper trading into v1 as the primary retention mechanic, alongside a reduced launch lesson set (5 lessons).
**Alternatives considered:** 20 lessons + streaks only; delay paper trading to v2
**Rationale:** A lesson-only MVP is an infoproduct, not a habit product. Paper trading creates simulated stakes, emotional engagement, and behavioral data that lessons alone cannot.
**Consequences:** Increases Phase 3 scope; requires market data, portfolio logic, and trade execution; risk of false confidence must be mitigated in content design.
**Reversible?** Partial — can reduce stock universe or simplify portfolio mechanics, but removing paper trading would break the MVP thesis.

### ADL-003: Koin Points have no real-world value
**Date:** 2026-06-29
**Decision:** Koin Points are virtual currency earned in-app and usable only inside Koin. No off-platform transfer, redemption, or real-money value.
**Alternatives considered:** Redeemable rewards; real-money prizes; tokenized points
**Rationale:** Avoids regulatory complexity and keeps the product focused on learning. Points act as a leaderboard/social signal, not a financial instrument.
**Consequences:** Limits monetization levers; requires clear messaging in UI and terms.
**Reversible?** No — changing this would require legal/regulatory review.

### ADL-004: Content factory with variants for anti-copying
**Date:** 2026-06-29
**Decision:** Store lesson examples and questions as content variants and randomly draw per user/session, rather than static content.
**Alternatives considered:** Static lessons; AI-generated questions on the fly
**Rationale:** A variant pool provides enough variety to prevent answer copying while keeping content source-backed and human-reviewed. AI generation on the fly risks hallucinations and weak source anchoring.
**Consequences:** Requires more authoring effort upfront; schema includes content_variants table; needs per-user random seed and exposure tracking.
**Reversible?** Yes — can fall back to static lessons if pool is too small.

### ADL-005: Supabase RLS is the authorization layer
**Date:** 2026-06-29
**Decision:** Use Row Level Security on every user-sensitive table. Never rely on frontend filtering alone.
**Alternatives considered:** Custom API layer with auth middleware; client-side filtering
**Rationale:** Database-level enforcement is harder to bypass and aligns with Supabase best practices. Fits the small-team, fast-shipping model.
**Consequences:** Every migration must include RLS policies; complex cross-user queries need secure RPCs or views.
**Reversible?** Partial — moving to a custom API would require rewriting auth logic.

### ADL-006: Client-side authentication with platform-aware storage
**Date:** 2026-06-30
**Decision:** Use client-side Supabase Auth with platform-aware session storage: Capacitor Preferences on native iOS/Android, cookies on the web.
**Alternatives considered:** Capacitor Preferences everywhere (violates no-localStorage rule on web); Next.js SSR auth with server actions and middleware; custom JWT backend
**Rationale:** The app is built as a static export for Capacitor, which disables Next.js server-side features (server actions, API routes, middleware). Client-side auth fits the Capacitor runtime. Cookies keep the web deployment compliant with the no-localStorage rule.
**Consequences:** Route guards are implemented in client components via `useAuth`. OAuth callbacks are handled by a client-side page. Session tokens are stored in Capacitor Preferences on native and in cookies on web.
**Reversible?** Partial — if we later add a server-rendered web deployment, we can add a parallel SSR auth path without removing the client-side one.

### ADL-008: Split Phase 3 into 3A (Core Learning Loop) and 3B (Paper Trading)
**Date:** 2026-07-02
**Decision:** Treat the learning loop and paper trading as two separate phases in planning, tracking, and gating.
**Alternatives considered:** Keep one combined Phase 3; split only after both were done
**Rationale:** The two tracks have different success criteria (content/variant quality vs. trade execution/risk onboarding) and were built in distinct sprints. Separating them makes it clearer which gates apply and avoids a single overloaded phase definition.
**Consequences:** TASKS.md and Linear now list Phase 3A and Phase 3B independently. Existing Phase 3 issues were renamed/split into KO-8 (Phase 3A) and KO-34 (Phase 3B).
**Reversible?** Yes — can be collapsed back into one phase label if reporting overhead is not worth it.

### ADL-010: Adaptive lesson triggers run inside the database
**Date:** 2026-07-06
**Decision:** Implement adaptive lesson recommendations as PostgreSQL functions and triggers, evaluated after each trade and on Home page load, rather than in the frontend or a separate job service.
**Alternatives considered:** Client-side evaluation after every trade; scheduled edge function; application server cron job
**Rationale:** Database-side evaluation guarantees consistency, works even if the client connection is flaky, and reacts immediately to trading events. It also keeps recommendation logic close to the data it inspects (trades, holdings, portfolios) and avoids exposing raw behavioral SQL to the client.
**Consequences:** Adds `evaluate_adaptive_triggers`, `check_adaptive_triggers` RPC, and an after-insert trigger on `trades`. Logic for panic sell, concentration, inactivity, and drawdown lives in SQL and must be versioned via migrations.
**Reversible?** Partial — can replace with an external scheduler later, but the trigger would need to be removed and client calls redirected.

### ADL-009: Content variant expansion to 10 examples + 11 questions per launch lesson
**Date:** 2026-07-06
**Decision:** Increase the `content_variants` pool so every launch lesson has at least 10 example variants and 11 question variants spanning multiple quiz types.
**Alternatives considered:** Keep 3–5 examples / 10–20 questions; generate variants with AI on demand
**Rationale:** A larger, author-reviewed pool gives each new user/session a meaningfully different lesson, reducing answer copying and keeping content fresh. Static, pre-verified variants preserve source credibility; AI-on-the-fly risks hallucinated URLs and unsourced claims.
**Consequences:** Migration 016 adds 50 examples and 55 questions. The existing variant-selection engine and cooldown logic automatically benefit from the larger pool. Authors must maintain the pool as lessons expand.
**Reversible?** Partial — variants can be removed, but the migration has already been applied to production.

### ADL-007: Pivot to web-first delivery, pause native apps
**Date:** 2026-06-30
**Decision:** Ship the MVP as a browser-based web app (PWA) and pause the Capacitor iOS/Android native track.
**Alternatives considered:** Continue native-only Capacitor build; build both web and native in parallel; full SSR rewrite
**Rationale:** A web app can be distributed instantly via a link, requires no app store review, and lets us validate product demand with Indonesian users faster. Native apps can be re-enabled from the archived mobile branch once retention/engagement justifies the App Store / Play Store overhead.
**Consequences:** Removes `ios/`, `android/`, `capacitor.config.ts`, and native plugin wrappers from the active branch. Session storage moves from Capacitor Preferences to cookies to respect the no-localStorage rule. Static-export deployment remains compatible with Vercel/Netlify static hosting.
**Reversible?** Yes — the mobile work remains in `main`/`mobile-paused` and can be merged back later.

### ADL-011: Foundation 0 "Money Dictionary" mini-track
**Date:** 2026-07-16
**Decision:** Add a 12-lesson Foundation 0 micro-track that teaches pure financial terms before the 32-lesson main curriculum.
**Alternatives considered:** Jump straight to main track with tooltips; inline definitions; longer main-track lessons
**Rationale:** User feedback consistently said main-track lessons were too hard because terms were assumed. A short, term-focused ramp improves activation and reduces early drop-off without diluting the main curriculum.
**Consequences:** New `topics` row for Foundation 0, 12 new `lessons`, content variants, and assessment gating logic. Adds one extra step before main track for low-scoring users.
**Reversible?** Partial — lessons can be unpublished, but the schema and gating logic would need to be unwound.

### ADL-012: Analytics = Supabase-only, no paid tools
**Date:** 2026-07-16
**Decision:** Use the Supabase `analytics_events` table and SQL views for all MVP metrics. No Mixpanel, Amplitude, or similar paid tools.
**Alternatives considered:** Mixpanel free tier; PostHog; Amplitude; Google Analytics 4
**Rationale:** The team is 1 person plus AI agents. Keeping analytics in Supabase avoids new bills, new privacy policies, and new integration maintenance. SQL views are inspectable and sufficient for the MVP metric set.
**Consequences:** No real-time dashboard; weekly metrics require running SQL queries. Admin dashboard is deferred until the playbook proves value.
**Reversible?** Yes — events can be exported or dual-written to a paid tool later.

### ADL-013: Google Workspace SMTP for auth and streak reminders
**Date:** 2026-07-16
**Decision:** Send Supabase Auth confirmation emails and streak-reminder emails through `hello@koinaku.com` via Google Workspace SMTP with an app password.
**Alternatives considered:** Supabase default email provider; Resend; Postmark; AWS SES; SendGrid
**Rationale:** The domain and workspace already exist, setup is immediate, and deliverability is acceptable for MVP volume. No new vendor contract or DNS changes required.
**Consequences:** Tied to one Google account; app password must be rotated if exposed; daily send limits may become a bottleneck at scale. Bounce/complaint monitoring is limited compared to a transactional email provider.
**Reversible?** Yes — can migrate to Resend/Postmark/SES by updating env vars and the mail transport config.

### ADL-014: Serverless Next.js for cron support
**Date:** 2026-07-16
**Decision:** Switch Next.js from static export (`output: "export"`) to serverless (`output: "standalone"`) so `/api/cron/streak-reminders` can run on Vercel.
**Alternatives considered:** Keep static export and move cron to a Supabase Edge Function; use an external scheduler; manual trigger only
**Rationale:** The existing notification stack was already Node/Next-based. Moving cron to an Edge Function would require reimplementing nodemailer logic in Deno and managing two runtimes. Serverless keeps the codebase uniform.
**Consequences:** Vercel build is no longer a static export; hosting must support Node.js runtime. `vercel.json` now defines a cron schedule. SSR pages can be added later if needed.
**Reversible?** Partial — reverting to static export would require moving the cron job out of the Next.js app.
