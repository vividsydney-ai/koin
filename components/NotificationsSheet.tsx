"use client";

import { useEffect, useState } from "react";
import { getNotifications, markNotificationRead, type AppNotification } from "@/lib/notifications/client";

interface NotificationsSheetProps {
  userId: string;
}

export function NotificationBell({ userId }: NotificationsSheetProps) {
  const [open, setOpen] = useState(false);
  const [notifications, setNotifications] = useState<AppNotification[]>([]);
  const [loading, setLoading] = useState(false);

  const unreadCount = notifications.filter((n) => !n.readAt).length;

  useEffect(() => {
    if (!open) return;
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const data = await getNotifications(userId);
      if (mounted) {
        setNotifications(data);
        setLoading(false);
      }
    };
    load();
    return () => {
      mounted = false;
    };
  }, [open, userId]);

  const handleMarkRead = async (id: string) => {
    await markNotificationRead(id);
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, readAt: new Date().toISOString() } : n))
    );
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="relative rounded-md p-2 text-foreground hover:bg-surface-raised"
        aria-label="Notifications"
      >
        <BellIcon className="h-6 w-6" />
        {unreadCount > 0 && (
          <span className="absolute right-1 top-1 flex h-4 min-w-[16px] items-center justify-center rounded-full bg-danger px-1 text-[10px] font-bold text-white">
            {unreadCount > 9 ? "9+" : unreadCount}
          </span>
        )}
      </button>

      {open && (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/40 p-0">
          <div
            className="h-full w-full max-w-sm bg-surface p-5 shadow-xl"
            role="dialog"
            aria-label="Notifications"
          >
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-lg font-bold text-foreground">Notifications</h2>
              <button
                onClick={() => setOpen(false)}
                className="rounded-md p-2 text-muted-foreground hover:bg-surface-raised"
                aria-label="Close"
              >
                ✕
              </button>
            </div>

            {loading ? (
              <div className="space-y-3">
                {Array.from({ length: 3 }).map((_, i) => (
                  <div key={i} className="h-20 animate-pulse rounded-md bg-muted" />
                ))}
              </div>
            ) : notifications.length === 0 ? (
              <p className="text-sm text-muted-foreground">No notifications yet.</p>
            ) : (
              <div className="space-y-3">
                {notifications.map((n) => (
                  <button
                    key={n.id}
                    onClick={() => handleMarkRead(n.id)}
                    className={`w-full rounded-md border p-4 text-left transition-colors ${
                      n.readAt
                        ? "border-border bg-surface opacity-70"
                        : "border-primary/30 bg-primary/5"
                    }`}
                  >
                    <p className="font-semibold text-foreground">{n.title}</p>
                    {n.body && <p className="mt-1 text-sm text-muted-foreground">{n.body}</p>}
                    <p className="mt-2 text-xs text-muted-foreground">
                      {formatDate(n.createdAt)}
                    </p>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}

function BellIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
      <path d="M13.73 21a2 2 0 0 1-3.46 0" />
    </svg>
  );
}

function formatDate(iso: string): string {
  const date = new Date(iso);
  return date.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });
}
