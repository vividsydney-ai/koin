"use client";

import { useEffect, useRef, useState } from "react";
import QRCode from "qrcode";
import jsQR from "jsqr";
import { useAuth } from "@/lib/auth/use-auth";
import { addFriendByQr, getFriends, type Friend } from "@/lib/friends/client";
import { getWeeklyLeaderboard, type WeeklyLeaderboard } from "@/lib/home/client";
import { createCohort, joinCohortByCode, getCohorts, type Cohort } from "@/lib/cohorts/client";
import { EmptyState } from "@/components/EmptyState";
import { useLocale } from "@/lib/i18n/LocaleProvider";

export default function FriendsPage() {
  const { t } = useLocale();
  const { user, profile, loading: authLoading } = useAuth(true);
  const [friends, setFriends] = useState<Friend[]>([]);
  const [cohorts, setCohorts] = useState<Cohort[]>([]);
  const [leaderboard, setLeaderboard] = useState<WeeklyLeaderboard | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [cohortCodeInput, setCohortCodeInput] = useState("");
  const [cohortMessage, setCohortMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const [friendsData, leaderboardData, cohortsData] = await Promise.all([
        getFriends(user.id),
        getWeeklyLeaderboard(user.id, "friends"),
        getCohorts(user.id),
      ]);
      if (!mounted) return;
      setFriends(friendsData);
      setLeaderboard(leaderboardData);
      setCohorts(cohortsData);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const handleFriendAdded = async () => {
    if (!user) return;
    const friendsData = await getFriends(user.id);
    setFriends(friendsData);
  };

  const handleJoinCohort = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !cohortCodeInput.trim()) return;
    setCohortMessage(null);
    const result = await joinCohortByCode(user.id, cohortCodeInput.trim());
    if (result) {
      setCohortMessage(result.alreadyMember ? t("friends.alreadyMember") : t("friends.joinedCohort"));
      setCohortCodeInput("");
      const cohortsData = await getCohorts(user.id);
      setCohorts(cohortsData);
    } else {
      setCohortMessage(t("friends.cohortNotFound"));
    }
  };

  const isLoading = authLoading || loading;
  const acceptedFriends = friends.filter((f) => f.status === "accepted");
  const pendingFriends = friends.filter((f) => f.status === "pending");

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6">
        <p className="text-sm text-muted-foreground">{t("friends.inviteBody")}</p>
        <h1 className="text-2xl font-bold tracking-tight text-foreground">{t("friends.inviteTitle")}</h1>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          <div className="h-32 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-24 animate-pulse rounded-radius-lg bg-muted" />
        </div>
      ) : (
        <div className="space-y-5">
          <InviteCard
            userId={user?.id ?? ""}
            displayName={profile?.display_name ?? "Learner"}
            avatarUrl={profile?.avatar_url ?? null}
            onFriendAdded={handleFriendAdded}
            message={message}
            setMessage={setMessage}
          />

          {pendingFriends.length > 0 && (
            <section>
              <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">Pending</h2>
              <div className="space-y-2">
                {pendingFriends.map((friend) => (
                  <FriendRow key={friend.userId} friend={friend} />
                ))}
              </div>
            </section>
          )}

          <section>
            <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">{t("friends.friendsTitle")}</h2>
            {acceptedFriends.length === 0 ? (
              <EmptyState
                icon="👥"
                title="No friends yet"
                description="Share your invite link or scan a friend's code to start learning together."
              />
            ) : (
              <div className="space-y-2">
                {acceptedFriends.map((friend) => (
                  <FriendRow key={friend.userId} friend={friend} />
                ))}
              </div>
            )}
          </section>

          {leaderboard && (
            <section>
              <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">Weekly leaderboard</h2>
              <LeaderboardSection title="XP" entries={leaderboard.xp} valueKey="xpThisWeek" />
              <LeaderboardSection title="Koin Points" entries={leaderboard.koinPoints} valueKey="koinPointsThisWeek" />
            </section>
          )}

          <CohortSection
            userId={user?.id ?? ""}
            cohorts={cohorts}
            codeInput={cohortCodeInput}
            onCodeChange={setCohortCodeInput}
            onJoin={handleJoinCohort}
            onCohortsChange={setCohorts}
            message={cohortMessage}
          />
        </div>
      )}
    </main>
  );
}

function InviteCard({
  userId,
  displayName,
  avatarUrl,
  onFriendAdded,
  message,
  setMessage,
}: {
  userId: string;
  displayName: string;
  avatarUrl: string | null;
  onFriendAdded: () => void;
  message: string | null;
  setMessage: (value: string | null) => void;
}) {
  const { t } = useLocale();
  const [qrSvg, setQrSvg] = useState<string | null>(null);
  const [scannerOpen, setScannerOpen] = useState(false);
  const [linkCopied, setLinkCopied] = useState(false);

  const origin = typeof window !== "undefined" ? window.location.origin : "";
  const inviteUrl = `${origin}/friends/accept?user=${encodeURIComponent(userId)}`;

  useEffect(() => {
    if (!userId) return;
    let cancelled = false;
    QRCode.toString(inviteUrl, {
      type: "svg",
      width: 200,
      margin: 2,
      errorCorrectionLevel: "M",
      color: {
        dark: "#171818",
        light: "#ffffff",
      },
    }).then((svg) => {
      if (!cancelled) setQrSvg(svg);
    });
    return () => {
      cancelled = true;
    };
  }, [inviteUrl, userId]);

  const handleCopyLink = async () => {
    try {
      await navigator.clipboard.writeText(inviteUrl);
      setLinkCopied(true);
      setTimeout(() => setLinkCopied(false), 2000);
    } catch {
      // ignore
    }
  };

  const handleShare = async () => {
    const shareData = {
      title: t("friends.inviteTitle"),
      text: `${displayName} ${t("friends.acceptBody")}`,
      url: inviteUrl,
    };
    if (navigator.canShare && navigator.canShare(shareData)) {
      try {
        await navigator.share(shareData);
      } catch {
        // User cancelled or share failed.
      }
    } else {
      await handleCopyLink();
    }
  };

  const extractUserIdFromScan = (raw: string): string | null => {
    if (!raw) return null;
    // Deep-link URL like https://web.koinaku.com/friends/accept?user=<uuid>
    try {
      const url = new URL(raw);
      const user = url.searchParams.get("user");
      if (user) return user;
    } catch {
      // Not a URL — treat as raw user id.
    }
    return raw.trim();
  };

  const handleScanResult = async (scanned: string) => {
    setMessage(null);
    const scannedUserId = extractUserIdFromScan(scanned);
    if (!scannedUserId) {
      setMessage("Could not read invite. Try again.");
      return;
    }
    const result = await addFriendByQr(scannedUserId);
    if (result) {
      setMessage(result.status === "accepted" ? t("friends.accepted") : t("friends.requestSent"));
      await onFriendAdded();
    } else {
      setMessage("Could not add friend. Check the invite and try again.");
    }
  };

  const initials = displayName
    .split(" ")
    .map((n) => n[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center gap-3">
        {avatarUrl ? (
          <img src={avatarUrl} alt="" className="h-12 w-12 rounded-full object-cover" />
        ) : (
          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary/10 text-base font-bold text-primary">
            {initials || "?"}
          </div>
        )}
        <div>
          <p className="text-sm font-semibold text-foreground">{displayName}</p>
          <p className="text-xs text-muted-foreground">{t("friends.inviteBody")}</p>
        </div>
      </div>

      <div className="mt-4 flex flex-col items-center gap-4">
        <div className="rounded-radius-md bg-white p-3 shadow-sm">
          {qrSvg ? (
            <div
              className="h-44 w-44"
              aria-label={`QR code for ${displayName}`}
              dangerouslySetInnerHTML={{ __html: qrSvg }}
            />
          ) : (
            <div className="flex h-44 w-44 items-center justify-center bg-muted">
              <span className="text-xs text-muted-foreground">Loading QR…</span>
            </div>
          )}
        </div>

        <div className="flex w-full gap-2">
          <button
            onClick={handleShare}
            className="flex-1 rounded-radius-md bg-primary py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90"
          >
            {t("friends.share")}
          </button>
          <button
            onClick={() => setScannerOpen(true)}
            className="flex-1 rounded-radius-md bg-foreground py-2.5 text-sm font-semibold text-background active:opacity-90"
          >
            {t("friends.scanQr")}
          </button>
        </div>
        <button
          onClick={handleCopyLink}
          className="w-full rounded-radius-md border border-muted bg-background py-2.5 text-sm font-semibold text-foreground active:opacity-90"
        >
          {linkCopied ? t("friends.linkCopied") : t("friends.copyLink")}
        </button>
      </div>

      {message && (
        <p className={`mt-4 text-center text-xs ${message.includes(t("friends.accepted")) || message.includes(t("friends.requestSent")) ? "text-success" : "text-danger"}`}>
          {message}
        </p>
      )}

      {scannerOpen && (
        <QrScannerModal
          onClose={() => setScannerOpen(false)}
          onScan={async (id) => {
            setScannerOpen(false);
            await handleScanResult(id);
          }}
        />
      )}
    </div>
  );
}

function QrScannerModal({ onClose, onScan }: { onClose: () => void; onScan: (userId: string) => void }) {
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const rafRef = useRef<number | null>(null);
  const isCameraSupported =
    typeof navigator !== "undefined" && !!navigator.mediaDevices?.getUserMedia;
  const [cameraError, setCameraError] = useState<string | null>(
    isCameraSupported ? null : "Camera not available in this browser. You can enter an invite link below."
  );
  const [manualInput, setManualInput] = useState("");

  useEffect(() => {
    const video = videoRef.current;
    const canvas = canvasRef.current;
    if (!video || !canvas || !isCameraSupported) return;

    const constraints: MediaStreamConstraints = {
      video: { facingMode: "environment" },
    };

    navigator.mediaDevices
      .getUserMedia(constraints)
      .then((stream) => {
        streamRef.current = stream;
        video.srcObject = stream;
        void video.play();

        const ctx = canvas.getContext("2d", { willReadFrequently: true });
        if (!ctx) return;

        const tick = () => {
          if (video.readyState === video.HAVE_ENOUGH_DATA) {
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
            const code = jsQR(imageData.data, imageData.width, imageData.height, {
              inversionAttempts: "dontInvert",
            });
            if (code?.data) {
              onScan(code.data);
              return;
            }
          }
          rafRef.current = requestAnimationFrame(tick);
        };

        rafRef.current = requestAnimationFrame(tick);
      })
      .catch(() => {
        setCameraError("Could not access camera. You can enter an invite link below.");
      });

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      streamRef.current?.getTracks().forEach((track) => track.stop());
      streamRef.current = null;
    };
  }, [onScan, isCameraSupported]);

  const handleManualSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!manualInput.trim()) return;
    onScan(manualInput.trim());
  };

  return (
    <div
      className="fixed inset-0 z-modal flex flex-col bg-background/95 p-4 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      aria-label="Scan QR code"
    >
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-bold text-foreground">Scan friend&apos;s QR</h3>
        <button
          onClick={onClose}
          className="rounded-radius-md px-3 py-1.5 text-sm font-semibold text-muted-foreground active:opacity-70"
          aria-label="Close scanner"
        >
          Close
        </button>
      </div>

      <div className="mt-4 flex flex-1 flex-col items-center justify-center gap-4">
        <div className="relative w-full max-w-sm overflow-hidden rounded-radius-lg bg-black shadow-lg">
          <video ref={videoRef} className="h-auto w-full" muted playsInline />
          <canvas ref={canvasRef} className="sr-only" />
          <div className="pointer-events-none absolute inset-0 rounded-radius-lg border-2 border-primary/40" />
        </div>

        {cameraError && (
          <div className="w-full max-w-sm rounded-radius-md bg-surface-inset p-3 text-center">
            <p className="text-xs text-danger">{cameraError}</p>
          </div>
        )}

        <form onSubmit={handleManualSubmit} className="w-full max-w-sm space-y-2">
          <label htmlFor="manual-invite-link" className="block text-xs font-medium text-muted-foreground">
            Or paste invite link
          </label>
          <div className="flex gap-2">
            <input
              id="manual-invite-link"
              type="text"
              value={manualInput}
              onChange={(e) => setManualInput(e.target.value)}
              placeholder="https://web.koinaku.com/friends/accept?user=..."
              className="flex-1 rounded-radius-md border border-muted bg-background px-3 py-2 text-sm text-foreground outline-none focus:border-primary"
            />
            <button
              type="submit"
              disabled={!manualInput.trim()}
              className="rounded-radius-md bg-foreground px-4 py-2 text-sm font-semibold text-background disabled:opacity-50 active:opacity-90"
            >
              Add
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

function CohortSection({
  userId,
  cohorts,
  codeInput,
  onCodeChange,
  onJoin,
  onCohortsChange,
  message,
}: {
  userId: string;
  cohorts: Cohort[];
  codeInput: string;
  onCodeChange: (value: string) => void;
  onJoin: (e: React.FormEvent) => void;
  onCohortsChange: (cohorts: Cohort[]) => void;
  message: string | null;
}) {
  const { t } = useLocale();
  const [createOpen, setCreateOpen] = useState(false);
  const [newCohortName, setNewCohortName] = useState("");
  const [createMessage, setCreateMessage] = useState<string | null>(null);
  const [creating, setCreating] = useState(false);
  const createdCount = cohorts.filter((c) => c.isCreator).length;
  const canCreateFree = createdCount < 1;

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userId || !newCohortName.trim()) return;
    setCreateMessage(null);
    setCreating(true);
    const result = await createCohort(userId, newCohortName.trim());
    if (result) {
      setNewCohortName("");
      setCreateOpen(false);
      const cohortsData = await getCohorts(userId);
      onCohortsChange(cohortsData);
    } else {
      setCreateMessage(canCreateFree ? "Could not create cohort. Try again." : t("friends.cohortLimitFree"));
    }
    setCreating(false);
  };

  return (
    <section>
      <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">{t("friends.cohorts")}</h2>
      <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
        {!createOpen ? (
          <>
            <div className="flex items-center justify-between">
              <p className="text-xs text-muted-foreground">{t("friends.joinCohort")}</p>
              <button
                onClick={() => setCreateOpen(true)}
                className="rounded-radius-md bg-foreground px-3 py-1.5 text-xs font-semibold text-background active:opacity-90"
              >
                {t("friends.createCohort")}
              </button>
            </div>
            <form onSubmit={onJoin} className="mt-3 flex gap-2">
              <input
                type="text"
                value={codeInput}
                onChange={(e) => onCodeChange(e.target.value.toUpperCase())}
                placeholder={t("friends.cohortCode")}
                className="flex-1 rounded-radius-md border border-muted bg-background px-3 py-2 text-sm text-foreground outline-none focus:border-primary"
              />
              <button
                type="submit"
                disabled={!codeInput.trim()}
                className="rounded-radius-md bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground disabled:opacity-50 active:opacity-90"
              >
                {t("friends.join")}
              </button>
            </form>
          </>
        ) : (
          <form onSubmit={handleCreate} className="space-y-3">
            <div className="flex items-center justify-between">
              <p className="text-xs font-semibold text-foreground">{t("friends.createCohort")}</p>
              <button
                type="button"
                onClick={() => setCreateOpen(false)}
                className="text-xs text-muted-foreground underline"
              >
                Cancel
              </button>
            </div>
            <input
              type="text"
              value={newCohortName}
              onChange={(e) => setNewCohortName(e.target.value)}
              placeholder={t("friends.cohortName")}
              maxLength={60}
              className="w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-sm text-foreground outline-none focus:border-primary"
            />
            {!canCreateFree && (
              <p className="text-xs text-warning">{t("friends.cohortLimitFree")}</p>
            )}
            <button
              type="submit"
              disabled={!newCohortName.trim() || creating || !canCreateFree}
              className="w-full rounded-radius-md bg-primary py-2.5 text-sm font-semibold text-primary-foreground disabled:opacity-50 active:opacity-90"
            >
              {creating ? "Creating…" : t("friends.create")}
            </button>
          </form>
        )}

        {message && (
          <p className={`mt-2 text-xs ${message.includes("Joined") || message.includes("already") ? "text-success" : "text-danger"}`}>
            {message}
          </p>
        )}
        {createMessage && (
          <p className="mt-2 text-xs text-danger">{createMessage}</p>
        )}

        {cohorts.length > 0 && (
          <div className="mt-4 space-y-2">
            {cohorts.map((cohort) => (
              <div key={cohort.id} className="rounded-radius-md bg-muted px-3 py-2">
                <p className="text-sm font-semibold text-foreground">{cohort.name}</p>
                <div className="flex items-center justify-between">
                  <p className="text-[10px] text-muted-foreground">
                    Joined {new Date(cohort.joinedAt).toLocaleDateString("id-ID")}
                  </p>
                  {cohort.inviteCode && (
                    <p className="text-[10px] font-mono text-muted-foreground">{cohort.inviteCode}</p>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </section>
  );
}

type LeaderboardRow = {
  rank: number;
  displayName: string;
  xpThisWeek?: number;
  koinPointsThisWeek?: number;
  isCurrentUser: boolean;
};

// Top-3 rank tints — color-mix against surface per DESIGN.md (never raw -50 backgrounds).
const RANK_TIER_STYLES: Record<number, { badge: string; label: string }> = {
  1: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-gold-500)_22%,var(--color-surface))] text-[var(--rup-gold-700)]",
    label: "gold",
  },
  2: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-grey-500)_18%,var(--color-surface))] text-[var(--rup-grey-700)]",
    label: "silver",
  },
  3: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-brown-400)_24%,var(--color-surface))] text-[var(--rup-brown-700)]",
    label: "bronze",
  },
};

function leaderboardInitials(name: string): string {
  const initials = name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();
  return initials || "?";
}

function LeaderboardSection({
  title,
  entries,
  valueKey,
}: {
  title: string;
  entries: LeaderboardRow[];
  valueKey: "xpThisWeek" | "koinPointsThisWeek";
}) {
  const { t } = useLocale();
  if (entries.length === 0) return null;

  const valueColor = valueKey === "koinPointsThisWeek" ? "text-koin-points" : "text-xp";

  return (
    <div className="mt-3 rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">{title}</p>
      <ol className="mt-2 space-y-1">
        {entries.map((entry) => {
          const tier = RANK_TIER_STYLES[entry.rank];
          return (
            <li
              key={entry.rank + entry.displayName}
              data-rank={entry.rank}
              data-tier={tier?.label}
              data-current-user={entry.isCurrentUser || undefined}
              className={`flex min-h-11 items-center gap-3 rounded-radius-md px-2 py-1.5 ${
                entry.isCurrentUser
                  ? "bg-[color-mix(in_srgb,var(--color-primary)_8%,var(--color-surface))]"
                  : ""
              }`}
            >
              <span
                className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
                  tier ? tier.badge : "bg-muted text-muted-foreground"
                }`}
                aria-label={`Rank ${entry.rank}`}
              >
                {entry.rank}
              </span>
              <span
                aria-hidden="true"
                className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[color-mix(in_srgb,var(--color-primary)_10%,var(--color-surface))] text-xs font-bold text-primary"
              >
                {leaderboardInitials(entry.displayName)}
              </span>
              <span
                className={`flex-1 truncate text-sm ${
                  entry.isCurrentUser ? "font-semibold text-foreground" : "text-foreground"
                }`}
              >
                {entry.displayName}
                {entry.isCurrentUser && (
                  <span className="ml-1.5 text-xs font-medium text-primary">{t("friends.you")}</span>
                )}
              </span>
              <span className={`text-sm font-semibold tabular-nums ${valueColor}`}>
                {(entry[valueKey] ?? 0).toLocaleString("id-ID")}
              </span>
            </li>
          );
        })}
      </ol>
    </div>
  );
}

function FriendRow({ friend }: { friend: Friend }) {
  const initials = friend.displayName
    .split(" ")
    .map((n) => n[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();

  return (
    <div className="flex items-center gap-3 rounded-radius-lg border border-muted/60 bg-surface p-3 shadow-sm">
      {friend.avatarUrl ? (
        <img src={friend.avatarUrl} alt="" className="h-10 w-10 rounded-full object-cover" />
      ) : (
        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10 text-sm font-bold text-primary">
          {initials || "?"}
        </div>
      )}
      <div className="flex-1">
        <p className="text-sm font-semibold text-foreground">{friend.displayName}</p>
        <p className="text-xs text-muted-foreground">
          {friend.status === "pending" ? (friend.isRequester ? "Request sent" : "Request received") : "Friend"}
        </p>
      </div>
    </div>
  );
}
