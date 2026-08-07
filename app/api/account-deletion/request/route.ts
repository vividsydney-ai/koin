import { NextResponse } from "next/server";
import { z } from "zod";
import { createClient } from "@/lib/supabase/server";
import { scheduleDeletion } from "@/lib/account-deletion/server";

const bodySchema = z.object({ email: z.string().email(), password: z.string().min(1) });

export async function POST(request: Request) {
  const parsed = bodySchema.safeParse(await request.json());
  if (!parsed.success) return NextResponse.json({ error: "Enter your email and password." }, { status: 400 });
  const supabase = await createClient();
  const { data } = await supabase.auth.getUser();
  const user = data.user;
  if (!user?.email || user.email.toLowerCase() !== parsed.data.email.toLowerCase()) return NextResponse.json({ error: "Type the email for this account." }, { status: 403 });
  try {
    return NextResponse.json(await scheduleDeletion(user.id, user.email, parsed.data.password));
  } catch (error) {
    return NextResponse.json({ error: error instanceof Error ? error.message : "Could not schedule deletion." }, { status: 400 });
  }
}
