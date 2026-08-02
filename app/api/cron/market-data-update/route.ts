import { NextResponse } from "next/server";
import { updateMarketData } from "@/lib/market-data/server";

export async function GET(request: Request) {
  const authHeader = request.headers.get("Authorization");
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const result = await updateMarketData(undefined, { refreshPortfolioValues: true });
    return NextResponse.json(result);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    console.error("market-data-update cron error:", message);
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

export const POST = GET;
