"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { signOut } from "@/lib/auth/client";

export default function DeleteAccountPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmed, setConfirmed] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const submit = async (event: React.FormEvent) => {
    event.preventDefault(); setLoading(true); setError(null);
    const response = await fetch("/api/account-deletion/request", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ email, password }) });
    const body = await response.json(); setLoading(false);
    if (!response.ok) return setError(body.error ?? "Could not schedule deletion.");
    await signOut(); router.replace("/login?deleted=pending");
  };
  return <main className="mx-auto max-w-lg p-5 pb-32 sm:p-6">
    <Link href="/profile/account" className="text-sm font-semibold text-primary hover:underline">← Back to account</Link>
    <div className="mt-5 rounded-lg border border-danger/40 bg-danger/5 p-5">
      <div className="flex gap-3"><span aria-hidden="true" className="text-xl text-danger">⚠</span><div><h1 className="font-display text-2xl font-bold text-danger">Delete my account</h1><p className="mt-2 text-sm text-muted-foreground">Your account will be deactivated now and permanently removed in 7 days. We’ll email a recovery link; signing in before then lets you reactivate it.</p></div></div>
      <form onSubmit={submit} className="mt-5 space-y-4">
        <label className="block text-sm font-semibold">Type your email to confirm<input required type="email" value={email} onChange={(e) => setEmail(e.target.value)} className="mt-1.5 w-full rounded-md border border-border bg-background px-3 py-2" /></label>
        <label className="block text-sm font-semibold">Current password<input required type="password" value={password} onChange={(e) => setPassword(e.target.value)} className="mt-1.5 w-full rounded-md border border-border bg-background px-3 py-2" /></label>
        <label className="flex gap-2 text-sm"><input type="checkbox" checked={confirmed} onChange={(e) => setConfirmed(e.target.checked)} />I understand permanent deletion happens after 7 days.</label>
        {error && <p role="alert" className="text-sm text-danger">{error}</p>}
        <button disabled={!confirmed || loading} className="w-full rounded-md bg-danger px-4 py-3 font-semibold text-white disabled:opacity-50">{loading ? "Scheduling…" : "Schedule account deletion"}</button>
      </form>
    </div>
  </main>;
}
