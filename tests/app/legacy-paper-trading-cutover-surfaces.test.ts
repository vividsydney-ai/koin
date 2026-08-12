import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

function source(relativePath: string) {
  return readFileSync(resolve(process.cwd(), relativePath), "utf8");
}

describe("KO-417 learner-facing legacy trading cutover", () => {
  it("removes legacy client calls from Trade, Home, Profile, and certificates", () => {
    const trade = source("app/(app)/trade/page.tsx");
    const home = source("app/(app)/page.tsx");
    const profile = source("app/(app)/profile/page.tsx");
    const certificate = source("app/(app)/certificate/page.tsx");

    expect(trade).not.toContain("@/lib/trading/");
    expect(trade).not.toContain("executeTrade");
    expect(home).not.toContain("getPortfolioSnapshot(user.id)");
    expect(home).not.toContain("portfolioReturnPct:");
    expect(profile).not.toContain("@/lib/portfolio/client");
    expect(certificate).not.toContain("getCertificate");
  });

  it("keeps the retired updater out of the Vercel schedule", () => {
    const vercelConfig = JSON.parse(source("vercel.json")) as { crons: { path: string }[] };

    expect(vercelConfig.crons.map((cron) => cron.path)).not.toContain(
      "/api/cron/market-data-update",
    );
  });
});
