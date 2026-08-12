import { describe, expect, it } from "vitest";
import { GET, POST } from "@/app/api/cron/market-data-update/route";

describe("legacy market-data cron cutover", () => {
  it("rejects both methods without running the retired paper-trading updater", async () => {
    for (const handler of [GET, POST]) {
      const response = await handler();
      expect(response.status).toBe(410);
      await expect(response.json()).resolves.toMatchObject({
        error: "legacy_paper_trading_archived",
      });
    }
  });
});
