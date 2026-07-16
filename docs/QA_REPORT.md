# Koinaku MVP QA Report

**Branch:** `web-koinaku`  
**Report date:** 2026-07-16  
**Commit:** `fe62088` (Slice 4: email streak reminders + in-app notification center)

---

## 1. Summary

| Gate | Result | Notes |
|------|--------|-------|
| Type check (`npx tsc --noEmit`) | ✅ Pass | Clean, no errors. |
| Lint (`npm run lint`) | ✅ Pass | 0 errors. |
| Unit tests (`npm run test`) | ✅ Pass | 261 passed, 5 skipped (last run). |
| Lighthouse mobile /login | ✅ Pass | Performance 86, Accessibility 100 |
| Lighthouse mobile /signup | ✅ Pass | Performance 86, Accessibility 100 |
| Lighthouse desktop /login | ✅ Pass | Performance 99, Accessibility 100 |
| WCAG 2.1 AA | ⚠️ Partial | Automated checks pass; manual screen-reader pass not completed. |
| Keyboard navigation | ⚠️ Partial | Core flows tested; full tab-order audit not completed. |
| 375px / 1280px layouts | ✅ Pass | Smoke tested on iPhone SE and desktop viewports. |
| Dark mode | ⚠️ Partial | No broken contrast observed; not exhaustively audited. |

**Overall:** MVP meets the documented quality gates. The partial items are acceptable for soft launch but should be closed before scaling traffic.

---

## 2. Test details

### 2.1 Type checking

```bash
npx tsc --noEmit
```

**Result:** No errors.

### 2.2 Linting

```bash
npm run lint
```

**Result:** 0 errors.

### 2.3 Unit / integration tests

```bash
npm run test
```

**Result:** 261 passed, 5 skipped.

The 5 skipped tests are documented in their respective files (typically tests that require external API calls or are awaiting a future schema change).

### 2.4 Lighthouse

Run with Playwright Chromium at:

```bash
CHROME_PATH=/Users/vividm4/Library/Caches/ms-playwright/chromium-1187/chrome-mac/Chromium.app/Contents/MacOS/Chromium
```

| Page | Device | Performance | Accessibility | Best Practices | SEO |
|------|--------|-------------|---------------|----------------|-----|
| /login | Mobile | 86 | 100 | 100 | 92 |
| /signup | Mobile | 86 | 100 | 100 | 92 |
| /login | Desktop | 99 | 100 | 100 | 92 |

> **Note:** Lighthouse was run against a local dev server (`pnpm dev`). Production scores may differ slightly due to CDN, compression, and real network conditions.

---

## 3. Manual QA smoke tests

### 3.1 Authentication

| Test | Result |
|------|--------|
| Email signup creates user in Supabase Auth | ✅ |
| Confirmation email sent via `hello@koinaku.com` SMTP | ✅ |
| Confirmed user can log in | ✅ |
| Google OAuth removed from UI | ✅ |

### 3.2 Onboarding

| Test | Result |
|------|--------|
| Onboarding collects full name, password, confirm password | ✅ |
| Show/hide password toggle works | ✅ |
| Financial literacy assessment submits | ✅ |
| Assessment gates path to Foundation 0 or main track | ✅ |
| Wrong answers generate remediation lessons | ✅ |

### 3.3 Learning

| Test | Result |
|------|--------|
| Foundation 0 lessons load for low-score users | ✅ |
| Main track lessons load for high-score users | ✅ |
| Lesson player shows concept → example → quiz → source | ✅ |
| Quiz answer submitted logs `analytics_events` | ✅ |
| Lesson completion updates XP, streak, Koin Points | ✅ |

### 3.4 Paper trading

| Test | Result |
|------|--------|
| Portfolio starts with Rp 10.000.000 | ✅ |
| Buy order executes at latest market price | ✅ |
| Holdings and trade history update | ✅ |
| Sell order updates cash and holdings | ✅ |

### 3.5 Notifications

| Test | Result |
|------|--------|
| In-app notification center shows unread count | ✅ |
| Notifications can be marked as read | ✅ |
| Cron endpoint returns 200 with valid `CRON_SECRET` | ✅ |
| Streak reminder email received (manual trigger) | ⚠️ Verified endpoint only; end-to-end email receipt depends on Google Workspace app password. |

---

## 4. Issues found and fixed during QA

| Issue | Severity | Status | Notes |
|-------|----------|--------|-------|
| Signup did not create Supabase Auth record | 🔴 High | Fixed | Root cause: auth config mismatch; Supabase Auth now creates users and sends confirmation emails. |
| Google OAuth non-functional | 🟡 Medium | Mitigated | Removed from login/signup UI until OAuth is reconfigured. |
| Paper trading onboarding RLS error | 🔴 High | Fixed | `user_settings` insert policy allowed the onboarding completion RPC to create the row. |
| Cofounder could not log in | 🟡 Medium | Fixed | Account conflict between two emails resolved; clean signup path restored. |
| Lesson "not found" flash on finish | 🟡 Medium | Fixed | Race condition between completion mutation and lesson refetch resolved. |
| Custom domain 404 | 🟡 Medium | Fixed | `web.koinaku.com` configured and pointed at the `web-koinaku` Vercel project. |

---

## 5. Outstanding risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Lighthouse mobile performance may drop on production with real data. | Medium | Re-run Lighthouse after production deploy; optimize if < 85. |
| Email deliverability depends on one Google Workspace account. | High | Monitor bounce/complaint rates; migrate to transactional provider if needed. |
| Accessibility manual audit not completed. | Medium | Run a screen-reader pass before paid acquisition begins. |
| Streak reminder end-to-end not tested on production. | Medium | Trigger manually after deploy and verify receipt. |

---

## 6. Re-running QA

Before each production deploy, run:

```bash
npx tsc --noEmit
npm run lint
npm run test
```

For Lighthouse:

```bash
pnpm dev
# In another terminal:
npm run lighthouse:mobile
```

Update this file with new results whenever the numbers change.
