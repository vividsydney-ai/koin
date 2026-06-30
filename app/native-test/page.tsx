"use client";

import { useEffect, useState } from "react";
import { shareContent } from "@/lib/native/share";
import { initPushNotifications } from "@/lib/native/push-notifications";
import { Capacitor } from "@capacitor/core";

export default function NativeTestPage() {
  const [platform, setPlatform] = useState<string>("web");
  const [status, setStatus] = useState<string>("Ready");

  useEffect(() => {
    setPlatform(Capacitor.getPlatform());
  }, []);

  const handleShare = async () => {
    try {
      setStatus("Opening share sheet...");
      await shareContent({
        title: "Koin Progress",
        text: "I'm learning finance with Koin! 🪙",
        url: "https://koin.app",
      });
      setStatus("Share sheet opened");
    } catch (err) {
      setStatus(`Share failed: ${err instanceof Error ? err.message : String(err)}`);
    }
  };

  const handlePushPermission = async () => {
    try {
      setStatus("Requesting push permission...");
      await initPushNotifications();
      setStatus("Push permission flow complete");
    } catch (err) {
      setStatus(`Push failed: ${err instanceof Error ? err.message : String(err)}`);
    }
  };

  return (
    <main className="min-h-screen p-6 bg-background">
      <div className="max-w-md mx-auto space-y-6">
        <h1 className="text-2xl font-display font-bold text-foreground">
          Native Bridge Test
        </h1>
        <p className="text-muted-foreground">
          Platform: <span className="font-medium text-foreground">{platform}</span>
        </p>
        <p className="text-sm text-muted-foreground">
          Status: <span className="font-medium text-foreground">{status}</span>
        </p>

        <div className="space-y-3">
          <button
            onClick={handleShare}
            className="w-full touch-target rounded-radius-md bg-primary px-4 py-3 text-primary-foreground font-medium"
          >
            Test Share Sheet
          </button>

          <button
            onClick={handlePushPermission}
            className="w-full touch-target rounded-radius-md bg-surface border border-muted px-4 py-3 text-foreground font-medium"
          >
            Test Push Notification Permission
          </button>
        </div>

        <p className="text-xs text-muted-foreground">
          Note: native plugins only work inside the iOS/Android app. In a browser,
          share falls back to Web Share API and push shows a console log.
        </p>
      </div>
    </main>
  );
}
