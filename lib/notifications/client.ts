import { supabase } from "@/lib/auth/client";

export interface AppNotification {
  id: string;
  notificationType: string;
  title: string;
  body: string | null;
  readAt: string | null;
  createdAt: string;
}

export async function getNotifications(userId: string): Promise<AppNotification[]> {
  const { data, error } = await supabase
    .from("notifications_queue")
    .select("id, notification_type, title, body, read_at, created_at")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) {
    console.error("getNotifications error:", error.message);
    return [];
  }

  return (
    data?.map((n) => ({
      id: n.id,
      notificationType: n.notification_type,
      title: n.title,
      body: n.body,
      readAt: n.read_at,
      createdAt: n.created_at,
    })) ?? []
  );
}

export async function markNotificationRead(notificationId: string): Promise<void> {
  const { error } = await supabase
    .from("notifications_queue")
    .update({ read_at: new Date().toISOString() })
    .eq("id", notificationId);

  if (error) {
    console.error("markNotificationRead error:", error.message);
  }
}
