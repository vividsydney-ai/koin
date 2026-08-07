import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { deletionStatus } from "@/lib/account-deletion/server";

export async function GET() {
  const supabase = await createClient();
  const { data } = await supabase.auth.getUser();
  if (!data.user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  return NextResponse.json({ scheduledFor: await deletionStatus(data.user.id) });
}
