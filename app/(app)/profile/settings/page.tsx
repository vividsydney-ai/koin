"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth/use-auth";
import { supabase } from "@/lib/auth/client";

type Preferences = { notifications_enabled: boolean; streak_reminders_enabled: boolean; friend_alerts_enabled: boolean; cohort_alerts_enabled: boolean };
const defaults: Preferences = { notifications_enabled: true, streak_reminders_enabled: true, friend_alerts_enabled: true, cohort_alerts_enabled: true };

function Toggle({ label, description, checked, disabled, onChange }: { label: string; description: string; checked: boolean; disabled?: boolean; onChange: (value: boolean) => void }) {
  return <label className="flex items-center justify-between gap-4 rounded-lg border border-border bg-surface p-4"><span><span className="block font-semibold text-foreground">{label}</span><span className="mt-1 block text-sm text-muted-foreground">{description}</span></span><input aria-label={label} type="checkbox" checked={checked} disabled={disabled} onChange={(e) => onChange(e.target.checked)} className="h-5 w-5 accent-primary disabled:opacity-50" /></label>;
}

export default function SettingsPage() {
  const { user } = useAuth(true); const [prefs, setPrefs] = useState(defaults); const [saving, setSaving] = useState(false);
  useEffect(() => { if (!user) return; supabase.from("user_settings").select("notifications_enabled, streak_reminders_enabled, friend_alerts_enabled, cohort_alerts_enabled").eq("user_id", user.id).maybeSingle().then(({ data }) => { if (data) setPrefs(data as Preferences); }); }, [user]);
  const update = async (key: keyof Preferences, value: boolean) => { if (!user) return; const next = { ...prefs, [key]: value }; setPrefs(next); setSaving(true); const { error } = await supabase.from("user_settings").upsert({ user_id: user.id, ...next, updated_at: new Date().toISOString() }, { onConflict: "user_id" }); if (error) setPrefs(prefs); setSaving(false); };
  const enabled = prefs.notifications_enabled;
  return <main className="mx-auto max-w-xl p-5 pb-32 sm:p-6"><Link href="/profile/account" className="text-sm font-semibold text-primary hover:underline">← Back to account</Link><h1 className="mt-4 font-display text-2xl font-bold">Notifications</h1><p className="mt-1 text-sm text-muted-foreground">Choose which alerts appear in your Koinaku notification center. Account and security emails are managed separately.</p><div className="mt-6 space-y-3"><Toggle label="In-app notifications" description="Show alerts in the notification center." checked={enabled} onChange={(v) => update("notifications_enabled", v)} /><Toggle label="Streak reminders" description="Reminders when your learning streak needs attention." checked={prefs.streak_reminders_enabled} disabled={!enabled || saving} onChange={(v) => update("streak_reminders_enabled", v)} /><Toggle label="Friend activity" description="Friend invites and new connection alerts." checked={prefs.friend_alerts_enabled} disabled={!enabled || saving} onChange={(v) => update("friend_alerts_enabled", v)} /><Toggle label="Cohort invites" description="Alerts when you are invited to a cohort." checked={prefs.cohort_alerts_enabled} disabled={!enabled || saving} onChange={(v) => update("cohort_alerts_enabled", v)} /></div></main>;
}
