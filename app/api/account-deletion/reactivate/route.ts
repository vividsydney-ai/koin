import { NextResponse } from "next/server";
import { z } from "zod";
import { createClient } from "@/lib/supabase/server";
import { reactivateByToken, reactivateByUser } from "@/lib/account-deletion/server";

const bodySchema = z.object({ token: z.string().min(32).optional() });

export async function POST(request: Request) {
  const parsed = bodySchema.safeParse(await request.json());
  if (!parsed.success) return NextResponse.json({ error: "Invalid recovery request." }, { status: 400 });
  try {
    if (parsed.data.token) await reactivateByToken(parsed.data.token);
    else {
      const supabase = await createClient();
      const { data } = await supabase.auth.getUser();
      if (!data.user) return NextResponse.json({ error: "Sign in to reactivate your account." }, { status: 401 });
      await reactivateByUser(data.user.id);
    }
    return NextResponse.json({ ok: true });
  } catch (error) {
    return NextResponse.json({ error: error instanceof Error ? error.message : "Could not reactivate account." }, { status: 400 });
  }
}
