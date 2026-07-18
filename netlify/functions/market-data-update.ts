import type { Config } from "@netlify/functions";
import { updateMarketData } from "../../lib/market-data/server";

export default async function handler(request: Request) {
  const cronSecret = process.env.CRON_SECRET;
  const authHeader = request.headers.get("Authorization");

  if (!cronSecret || authHeader !== `Bearer ${cronSecret}`) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), {
      status: 401,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const result = await updateMarketData();
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    console.error("market-data-update scheduled function error:", message);
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
}

export const config: Config = {
  schedule: "0 14 * * *",
};
