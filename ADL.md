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

### ADL-006: Client-side authentication for Capacitor
**Date:** 2026-06-30
**Decision:** Use client-side Supabase Auth with Capacitor Preferences for session storage, rather than Next.js server actions + middleware.
**Alternatives considered:** Next.js SSR auth with server actions and middleware; custom JWT backend
**Rationale:** The app is built as a static export for Capacitor, which disables Next.js server-side features (server actions, API routes, middleware). Client-side auth fits the Capacitor runtime and avoids localStorage, which is forbidden by project rules.
**Consequences:** Route guards are implemented in client components via `useAuth`. OAuth callbacks are handled by a client-side page. Session tokens are stored in Capacitor Preferences.
**Reversible?** Partial — if we later add a server-rendered web deployment, we can add a parallel SSR auth path without removing the client-side one.
