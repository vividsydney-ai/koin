import { createClient } from "@supabase/supabase-js";
import { sendEmail } from "@/lib/email/server";
import { trackServerEvent } from "@/lib/analytics/server";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error("Missing Supabase service role credentials for notifications");
}

const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey);

export interface StreakReminderCandidate {
  userId: string;
  email: string;
  displayName: string;
  currentStreakDays: number;
  streakStatus: "active" | "at_risk" | "frozen" | "broken";
}

function getReminderBody(candidate: StreakReminderCandidate): { subject: string; text: string; html: string } {
  const subject = "🔥 Streak kamu berisiko hilang hari ini";
  const text = `Halo ${candidate.displayName},

Kamu sudah membangun streak belajar ${candidate.currentStreakDays} hari di Koinaku. Jangan biarkan putus — selesaikan satu pelajaran hari ini supaya streak tetap menyala.

Buka Koinaku: https://web.koinaku.com/learn

Tim Koinaku`;

  const html = `<p>Halo ${candidate.displayName},</p>
<p>Kamu sudah membangun streak belajar <strong>${candidate.currentStreakDays} hari</strong> di Koinaku. Jangan biarkan putus — selesaikan satu pelajaran hari ini supaya streak tetap menyala.</p>
<p><a href="https://web.koinaku.com/learn" style="display:inline-block;padding:12px 24px;background:#01696f;color:#fff;text-decoration:none;border-radius:8px;">Lanjutkan belajar</a></p>
<p>Tim Koinaku</p>`;

  return { subject, text, html };
}

export async function getStreakReminderCandidates(): Promise<StreakReminderCandidate[]> {
  const now = new Date();
  const currentTime = `${String(now.getHours()).padStart(2, "0")}:${String(now.getMinutes()).padStart(2, "0")}:00`;

  const { data, error } = await supabaseAdmin.rpc("get_streak_reminder_candidates", {
    p_current_time: currentTime,
  });

  if (error) {
    console.error("getStreakReminderCandidates error:", error.message);
    throw new Error(error.message);
  }

  return (data ?? []).map((row: Record<string, unknown>) => ({
    userId: String(row.user_id),
    email: String(row.email),
    displayName: String(row.display_name),
    currentStreakDays: Number(row.current_streak_days),
    streakStatus: String(row.streak_status) as StreakReminderCandidate["streakStatus"],
  }));
}

export interface SendReminderResult {
  sent: number;
  failed: number;
}

export async function sendStreakReminders(): Promise<SendReminderResult> {
  const candidates = await getStreakReminderCandidates();
  let sent = 0;
  let failed = 0;

  for (const candidate of candidates) {
    try {
      const { subject, text, html } = getReminderBody(candidate);

      await sendEmail({
        to: candidate.email,
        subject,
        text,
        html,
      });

      await supabaseAdmin.from("notifications_queue").insert({
        user_id: candidate.userId,
        notification_type: "streak_reminder",
        title: subject,
        body: `Streak ${candidate.currentStreakDays} hari berisiko hilang. Selesaikan pelajaran hari ini.`,
        sent_at: new Date().toISOString(),
      });

      await trackServerEvent({
        userId: candidate.userId,
        name: "streak_reminder_sent",
        properties: {
          streak_days: candidate.currentStreakDays,
          streak_status: candidate.streakStatus,
        },
      });

      sent += 1;
    } catch (e) {
      console.error(`Failed to send streak reminder to ${candidate.userId}:`, e);
      failed += 1;
    }
  }

  return { sent, failed };
}
