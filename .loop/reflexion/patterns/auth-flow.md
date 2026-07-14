# Pattern: Platform-aware auth storage

**Context:** Web build forbids `localStorage`/`sessionStorage`; native build uses Capacitor Preferences.
**Solution:** Use `Capacitor.isNativePlatform()` to select `Preferences` on native and cookie-based storage on web. Both paths go through the same `authStorage` interface.
**Files:** `lib/auth/client.ts`, `lib/auth/storage.ts`
**Tags:** auth, storage, capacitor, cookies, hard-stop
