"use client";
import { useSearchParams, useRouter } from "next/navigation";
import { useState } from "react";
import { Suspense } from "react";
function ReactivateContent() {
  const token = useSearchParams().get("token"); const router = useRouter(); const [message, setMessage] = useState<string | null>(null); const [loading, setLoading] = useState(false);
  const reactivate = async () => { setLoading(true); const response = await fetch("/api/account-deletion/reactivate", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(token ? { token } : {}) }); const body = await response.json(); setLoading(false); if (!response.ok) return setMessage(body.error); setMessage("Your account is active again. You can continue using Koinaku."); if (!token) router.replace("/"); };
  return <main className="mx-auto flex min-h-screen max-w-lg items-center p-5"><section className="w-full rounded-lg border border-border bg-surface p-6"><h1 className="font-display text-2xl font-bold">Reactivate your account</h1><p className="mt-2 text-sm text-muted-foreground">Your account is scheduled for deletion. Reactivate it before the seven-day deadline to keep your profile and data.</p>{message && <p className="mt-4 text-sm text-primary">{message}</p>}<button onClick={reactivate} disabled={loading} className="mt-5 w-full rounded-md bg-primary px-4 py-3 font-semibold text-primary-foreground disabled:opacity-50">{loading ? "Reactivating…" : "Reactivate my account"}</button></section></main>;
}

export default function ReactivatePage() {
  return <Suspense fallback={<main className="flex min-h-screen items-center justify-center">Loading…</main>}><ReactivateContent /></Suspense>;
}
