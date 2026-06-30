import "@testing-library/jest-dom";
import { vi } from "vitest";

// Default Capacitor to native platform for tests.
// Individual tests can override by re-mocking @capacitor/core.
vi.mock("@capacitor/core", () => ({
  Capacitor: {
    isNativePlatform: vi.fn().mockReturnValue(true),
    getPlatform: vi.fn().mockReturnValue("ios"),
  },
}));
