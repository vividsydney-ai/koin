"use client";

import { useEffect, useState } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { addFriendByQr } from "@/lib/friends/client";
import { getPublicProfile, type PublicProfile } from "@/lib/profiles/public";
import { useLocale } from "@/lib/i18n/LocaleProvider";

export function AcceptFriendContent() {
  const { t } = useLocale();
  const { user, loading: authLoading } = useAuth(true);
  const searchParams = useSearchParams();
  const router = useRouter();
  const inviterId = searchParams.get("user");

  const [inviter, setInviter] = useState<PublicProfile | null>(null);
  const [notFound, setNotFound] = useState(!inviterId);
  const [accepting, setAccepting] = useState(false);
  const [result, setResult] = useState<{ ok: boolean; message: string } | null>(null);

  useEffect(() => {
    if (!inviterId) return;
    getPublicProfile(inviterId).then((profile) => {
      if (profile) {
        setInviter(profile);
      } else {
        setNotFound(true);
      }
    });
  }, [inviterId]);

  const handleAccept = async () => {
    if (!user || !inviterId) return;
    setAccepting(true);
    setResult(null);
    const friendship = await addFriendByQr(inviterId);
    if (friendship) {
      setResult({
        ok: true,
        message: friendship.status === "accepted" ? t("friends.accepted") : t("friends.requestSent"),
      });
      setTimeout(() => router.push("/friends"), 1500);
    } else {
      setResult({ ok: false, message: "Could not add friend. Please try again." });
    }
    setAccepting(false);
  };

  if (authLoading || (!inviter && !notFound)) {
    return (
      <main className="flex min-h-screen items-center justify-center bg-background p-6">
        <p className="text-sm text-muted-foreground">Loading…</p>
      </main>
    );
  }

  if (notFound || !inviterId || !inviter) {
    return (
      <main className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
        <div className="mx-auto w-full max-w-sm rounded-lg border border-muted/60 bg-surface p-6 shadow-sm">
          <p className="text-4xl">😕</p>
          <h1 className="mt-4 text-lg font-bold text-foreground">{t("friends.userNotFound")}</h1>
          <button
            onClick={() => router.push("/friends")}
            className="mt-4 w-full rounded-md bg-primary py-3 text-sm font-semibold text-primary-foreground active:opacity-90"
          >
            Back to Friends
          </button>
        </div>
      </main>
    );
  }

  const initials = inviter.displayName
    .split(" ")
    .map((n) => n[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();

  return (
    <main className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
      <div className="mx-auto w-full max-w-sm rounded-lg border border-muted/60 bg-surface p-6 shadow-sm">
        {inviter.avatarUrl ? (
          <img src={inviter.avatarUrl} alt="" className="mx-auto h-20 w-20 rounded-full object-cover" />
        ) : (
          <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-primary/10 text-2xl font-bold text-primary">
            {initials || "?"}
          </div>
        )}
        <h1 className="mt-4 text-xl font-bold text-foreground">{inviter.displayName}</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {inviter.displayName} {t("friends.acceptBody")}
        </p>

        {result ? (
          <p className={`mt-4 rounded-md p-3 text-sm ${result.ok ? "bg-success/10 text-success" : "bg-danger/10 text-danger"}`}>
            {result.message}
          </p>
        ) : (
          <button
            onClick={handleAccept}
            disabled={!user || accepting}
            className="mt-6 w-full rounded-md bg-primary py-3 text-sm font-semibold text-primary-foreground disabled:opacity-50 active:opacity-90"
          >
            {accepting ? "Accepting…" : t("friends.acceptButton")}
          </button>
        )}

        <button
          onClick={() => router.push("/friends")}
          className="mt-3 w-full rounded-md border border-muted bg-background py-3 text-sm font-semibold text-foreground active:opacity-90"
        >
          Back to Friends
        </button>
      </div>
    </main>
  );
}
