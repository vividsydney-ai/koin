import "@testing-library/jest-dom";
import { vi } from "vitest";

if (process.env.VITEST_LIVE !== "1") {
  process.env.NEXT_PUBLIC_SUPABASE_URL = "https://unit-test.supabase.co";
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "unit-test-anon-key";
}

// Default Capacitor to native platform for tests.
// Individual tests can override by re-mocking @capacitor/core.
vi.mock("@capacitor/core", () => ({
  Capacitor: {
    isNativePlatform: vi.fn().mockReturnValue(true),
    getPlatform: vi.fn().mockReturnValue("ios"),
  },
}));
