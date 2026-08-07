import { NextResponse } from "next/server";
import { purgeDueAccounts } from "@/lib/account-deletion/server";

export async function GET(request: Request) {
  if (request.headers.get("Authorization") !== `Bearer ${process.env.CRON_SECRET}`) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  try { return NextResponse.json(await purgeDueAccounts()); }
  catch (error) { return NextResponse.json({ error: error instanceof Error ? error.message : "Unknown error" }, { status: 500 }); }
}

export const POST = GET;
