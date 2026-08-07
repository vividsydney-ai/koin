import { createHash, randomBytes } from "crypto";
import { createClient } from "@supabase/supabase-js";
import { sendEmail } from "@/lib/email/server";

const DAYS_TO_RECOVER = 7;

function admin() {
  return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!);
}

function hash(token: string) {
  return createHash("sha256").update(token).digest("hex");
}

export async function scheduleDeletion(userId: string, email: string, password: string) {
  const verifier = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!);
  const { data, error } = await verifier.auth.signInWithPassword({ email, password });
  if (error || data.user?.id !== userId) throw new Error("Your password could not be verified.");

  const token = randomBytes(32).toString("hex");
  const scheduledFor = new Date(Date.now() + DAYS_TO_RECOVER * 24 * 60 * 60 * 1000);
  const { error: insertError } = await admin().from("account_deletion_requests").upsert({
    user_id: userId,
    token_hash: hash(token),
    requested_at: new Date().toISOString(),
    scheduled_for: scheduledFor.toISOString(),
    cancelled_at: null,
  });
  if (insertError) throw new Error(insertError.message);

  const url = `${process.env.NEXT_PUBLIC_APP_URL}/reactivate?token=${token}`;
  await sendEmail({
    to: email,
    subject: "Your Koinaku account is scheduled for deletion",
    text: `Your account is scheduled for permanent deletion on ${scheduledFor.toLocaleDateString("en-AU")}. Keep it by opening: ${url}`,
    html: `<p>Your Koinaku account is scheduled for permanent deletion on <strong>${scheduledFor.toLocaleDateString("en-AU")}</strong>.</p><p>If you changed your mind, <a href="${url}">keep my account</a> within seven days.</p>`,
  });
  return { scheduledFor: scheduledFor.toISOString() };
}

export async function reactivateByToken(token: string) {
  const { data, error } = await admin().from("account_deletion_requests").select("user_id, scheduled_for").eq("token_hash", hash(token)).is("cancelled_at", null).maybeSingle();
  if (error || !data || new Date(data.scheduled_for) <= new Date()) throw new Error("This recovery link is invalid or has expired.");
  const { error: updateError } = await admin().from("account_deletion_requests").update({ cancelled_at: new Date().toISOString() }).eq("user_id", data.user_id);
  if (updateError) throw new Error(updateError.message);
}

export async function reactivateByUser(userId: string) {
  const { error } = await admin().from("account_deletion_requests").update({ cancelled_at: new Date().toISOString() }).eq("user_id", userId).is("cancelled_at", null);
  if (error) throw new Error(error.message);
}

export async function deletionStatus(userId: string) {
  const { data, error } = await admin().from("account_deletion_requests").select("scheduled_for").eq("user_id", userId).is("cancelled_at", null).maybeSingle();
  if (error) throw new Error(error.message);
  return data?.scheduled_for ?? null;
}

export async function purgeDueAccounts() {
  const { data, error } = await admin().from("account_deletion_requests").select("user_id").is("cancelled_at", null).lte("scheduled_for", new Date().toISOString());
  if (error) throw new Error(error.message);
  let deleted = 0;
  for (const row of data ?? []) {
    const { error: deleteError } = await admin().auth.admin.deleteUser(row.user_id);
    if (deleteError) throw new Error(deleteError.message);
    deleted++;
  }
  return { deleted };
}
