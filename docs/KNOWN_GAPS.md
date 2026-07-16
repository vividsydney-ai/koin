# Koinaku MVP — Known Gaps & Deferred Work

**Branch:** `web-koinaku`  
**Last updated:** 2026-07-16

This file lists what is intentionally **not** built in the public soft-launch MVP, what is partially built, and what future agents should know before expanding scope.

---

## 1. Intentionally out of scope (MVP)

These features are explicitly deferred to Phase 2 or later. Do not build them during the MVP unless the PRD changes.

| Feature | Why deferred | Target phase |
|---------|--------------|--------------|
| **Koin Pro / payments** | No validated willingness to pay yet. Stripe/Xendit integration needed. | Phase 2 |
| **Web push notifications** | Native mobile track is paused; web push has low opt-in on mobile web. | Phase 2+ |
| **Native iOS/Android builds** | Web-first/PWA validates demand faster than App Store review. | Phase 2+ |
| **A/B testing framework** | Not enough traffic to reach significance; manual cohort analysis first. | Phase 2+ |
| **Admin analytics dashboard** | SQL views + playbook are enough for 1-person ops. Dashboard after playbook proves value. | Phase 2 |
| **Real broker integrations** | Regulated activity; graduates get neutral OJK-registered broker pointers only. | Phase 3+ |
| **Community feed / DMs** | Out of scope per `VISION.md`; social accountability is via leaderboards only. | Never |
| **Crypto / Forex education** | Out of scope per `VISION.md`. | Never |
| **AI financial coach** | Expensive, unproven; defer until Koin Pro demand is validated. | Phase 2+ |
| **100+ lesson curriculum** | 32 main-track lessons + Foundation 0 is the MVP floor. | Phase 2 |

---

## 2. Partially built / needs maturation

These exist in the codebase but are not fully productized. They work for the MVP but will need refinement.

| Feature | Current state | Gap | Next step |
|---------|---------------|-----|-----------|
| **Content variants** | Pool exists for 32 main-track lessons + Foundation 0. | Variant cooldown is basic; same user may still see repeats in short sessions. | Tune cooldown and per-user random seed after usage data. |
| **Question types** | multiple_choice, true_false, fill_blank, word_bank, ordering, matching, case_study built. | slider and swipe_yes_no types declared but UI not implemented. | Implement only if lesson design requires them. |
| **Social features** | Friendships and weekly leaderboards exist. | No invite-deep-link flow, no friend search by username, no social feed. | Add if social becomes a retention driver. |
| **Market data** | Daily price updates seeded for curated IDX stocks. | Price feed is manual/seeded; no live IDX API integration. | Evaluate live data cost vs. fidelity for paper trading. |
| **Streak reminders** | Email cron fires hourly; in-app center exists. | No timezone-aware local send time; all users get email at the same UTC hour. | Add user timezone preference if open rates are low. |
| **Notification center** | Bell icon + unread count + mark-as-read works. | No real-time updates; page refresh required. | Add Supabase realtime or polling if engagement is low. |
| **Graduation** | 3x–5x portfolio growth triggers certificate + broker list. | Certificate is basic; no shareable image/PDF. | Polish certificate design if graduation rate justifies it. |
| **Koin Points** | Earned on lessons/streaks; balance shown. | No spend path or store. | Design utility before promoting points heavily. |

---

## 3. Known technical limitations

| Area | Limitation | Risk | Mitigation |
|------|------------|------|------------|
| **Email delivery** | Single Google Workspace SMTP account (`hello@koinaku.com`). | Hitting daily send limits or app password expiry stops auth + reminders. | Monitor bounce/complaint rates; consider a transactional email provider (Resend/Postmark) if volume grows. |
| **Cron reliability** | One Vercel cron job for streak reminders. | Missed fires if cron schedule drifts or endpoint errors. | Add cron health check via Vercel logs; consider a backup scheduler. |
| **Analytics** | Supabase-only event table + SQL views. | No real-time dashboards; ad-hoc queries required. | Documented in `docs/ANALYTICS_PLAYBOOK.md`; build dashboard after Phase 1. |
| **Static-ish web** | Moved from static export to serverless for cron support, but most pages are still client-rendered. | SEO is minimal; social sharing cards are limited. | Acceptable for MVP; add SSR/OG tags if organic sharing becomes important. |
| **Content review** | Human/agent review workflow exists but is lightweight. | Low-quality or unsourced lessons could slip through. | Enforce `tests/sources/url-verification.test.ts` in CI; require Tier 1 source + approved review for publish. |
| **Multi-tenancy** | RLS isolates users, but there is no formal tenant/org model. | Future B2B cohorts will need scoping beyond `user_id`. | Design tenant schema in Phase 2 if B2B pilots land. |

---

## 4. Open product questions

These cannot be answered without real user data. Do not pretend they are solved in the MVP.

1. **What is the real aha moment?** First lesson completion, first trade, or first streak milestone?
2. **Which acquisition channel works?** Organic TikTok, school partnerships, or paid social?
3. **Will users pay Rp 49k/month for Koin Pro?** Requires a pricing smoke test.
4. **Is Foundation 0 the right length?** 12 micro-lessons may be too long or too short.
5. **Does paper trading create retention or false confidence?** Needs behavioral cohort analysis.

---

## 5. Legal / compliance gaps

- [ ] **Terms of Service page** must be live before public soft launch.
- [ ] **Privacy Policy page** must be live before public soft launch.
- [ ] **Brokerage referral language** must remain neutral: "OJK-registered brokers," not "recommended."
- [ ] **Age gating / parental consent** for users under 18 should be reviewed with local counsel.

---

## 6. When to promote a gap to "build now"

A gap should only move from this file into active development if one of these is true:

1. It blocks the public soft-launch checklist in `docs/DEPLOYMENT.md`.
2. A kill-criteria metric is at risk (e.g., D7 retention < 10%).
3. User feedback repeatedly flags it in the bug tracker.
4. It is required for legal/compliance before launch.

Otherwise, keep it here and revisit in Phase 2 planning.
