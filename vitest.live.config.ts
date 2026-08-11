import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import path from "path";
import dotenv from "dotenv";

dotenv.config({ path: ".env.local" });

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "."),
    },
  },
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: ["./tests/setup.ts"],
    testTimeout: 300000,
    include: [
      "tests/migrations/033_foundation_zero.test.ts",
      "tests/migrations/036_publish_foundation_zero.test.ts",
      "tests/migrations/037_analytics_views.test.ts",
      "tests/migrations/038_streak_reminders.test.ts",
      "tests/sources/url-verification.test.ts",
    ],
  },
});
