import { NextResponse } from "next/server";

const RETIRED_RESPONSE = {
  error: "legacy_paper_trading_archived",
  message:
    "The legacy Paper Trading market-data updater is retired. Practice Market seasons use their own authored simulation timeline.",
};

/**
 * Kept as a deliberate 410 instead of deleting the endpoint so an old Vercel
 * schedule or manual request can never restart legacy valuations. [KO-417]
 */
export async function GET() {
  return NextResponse.json(RETIRED_RESPONSE, { status: 410 });
}

export const POST = GET;
