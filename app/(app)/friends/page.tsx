"use client";

import { useEffect, useRef, useState } from "react";
import QRCode from "qrcode";
import jsQR from "jsqr";
import { useAuth } from "@/lib/auth/use-auth";
import { addFriendByQr, getFriends, type Friend } from "@/lib/friends/client";
import { getWeeklyLeaderboard, type WeeklyLeaderboard } from "@/lib/home/client";
import { joinCohortByCode, getCohorts, type Cohort } from "@/lib/cohorts/client";
import { EmptyState } from "@/components/EmptyState";

export default function FriendsPage() {
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
      setCohortMessage(result.alreadyMember ? "You're already in this cohort." : `Joined ${result.cohortName}!`);
      setCohortCodeInput("");
      const cohortsData = await getCohorts(user.id);
      setCohorts(cohortsData);
    } else {
      setCohortMessage("Cohort not found. Check the code and try again.");
    }
  };

  const isLoading = authLoading || loading;
  const acceptedFriends = friends.filter((f) => f.status === "accepted");
  const pendingFriends = friends.filter((f) => f.status === "pending");

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6">
        <p className="text-sm text-muted-foreground">Learn together,</p>
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Friends</h1>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          <div className="h-32 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-24 animate-pulse rounded-radius-lg bg-muted" />
        </div>
      ) : (
        <div className="space-y-5">
          <QrSection
            userId={user?.id ?? ""}
            displayName={profile?.display_name ?? "Learner"}
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
            <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">Friends</h2>
            {acceptedFriends.length === 0 ? (
              <EmptyState
                icon="👥"
                title="No friends yet"
                description="Share your QR code or scan a friend's code to start learning together."
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
            cohorts={cohorts}
            codeInput={cohortCodeInput}
            onCodeChange={setCohortCodeInput}
            onJoin={handleJoinCohort}
            message={cohortMessage}
          />
        </div>
      )}
    </main>
  );
}

function QrSection({
  userId,
  displayName,
  onFriendAdded,
  message,
  setMessage,
}: {
  userId: string;
  displayName: string;
  onFriendAdded: () => void;
  message: string | null;
  setMessage: (value: string | null) => void;
}) {
  const [qrSvg, setQrSvg] = useState<string | null>(null);
  const [scannerOpen, setScannerOpen] = useState(false);

  useEffect(() => {
    if (!userId) return;
    let cancelled = false;
    QRCode.toString(userId, {
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
  }, [userId]);

  const shareText = `Add me on Koin and learn to invest together! My user ID: ${userId}`;

  const handleShare = async () => {
    const shareData = {
      title: `Add ${displayName} on Koin`,
      text: shareText,
      url: typeof window !== "undefined" ? window.location.origin : "",
    };
    if (navigator.canShare && navigator.canShare(shareData)) {
      try {
        await navigator.share(shareData);
      } catch {
        // User cancelled or share failed.
      }
    }
  };

  const handleScanResult = async (scannedUserId: string) => {
    setMessage(null);
    const result = await addFriendByQr(scannedUserId.trim());
    if (result) {
      setMessage(result.status === "accepted" ? "You're now friends!" : "Friend request sent.");
      await onFriendAdded();
    } else {
      setMessage("Could not add friend. Check the QR code and try again.");
    }
  };

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <h2 className="text-sm font-semibold text-foreground">Invite friends</h2>
      <p className="text-xs text-muted-foreground">Share your QR code or scan a friend&apos;s code to connect.</p>

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
            Share
          </button>
          <button
            onClick={() => setScannerOpen(true)}
            className="flex-1 rounded-radius-md bg-foreground py-2.5 text-sm font-semibold text-background active:opacity-90"
          >
            Scan QR
          </button>
        </div>
      </div>

      {message && (
        <p className={`mt-4 text-center text-xs ${message.includes("friends") || message.includes("sent") ? "text-success" : "text-danger"}`}>
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
    isCameraSupported ? null : "Camera not available in this browser. You can enter a user ID manually below."
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
        setCameraError("Could not access camera. You can enter a user ID manually below.");
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
          <label htmlFor="manual-user-id" className="block text-xs font-medium text-muted-foreground">
            Or enter user ID manually
          </label>
          <div className="flex gap-2">
            <input
              id="manual-user-id"
              type="text"
              value={manualInput}
              onChange={(e) => setManualInput(e.target.value)}
              placeholder="Paste user ID"
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
  cohorts,
  codeInput,
  onCodeChange,
  onJoin,
  message,
}: {
  cohorts: Cohort[];
  codeInput: string;
  onCodeChange: (value: string) => void;
  onJoin: (e: React.FormEvent) => void;
  message: string | null;
}) {
  return (
    <section>
      <h2 className="mb-2 text-sm font-semibold uppercase tracking-wider text-muted-foreground">Cohorts</h2>
      <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
        <p className="text-xs text-muted-foreground">Join a class or group with an invite code.</p>
        <form onSubmit={onJoin} className="mt-3 flex gap-2">
          <input
            type="text"
            value={codeInput}
            onChange={(e) => onCodeChange(e.target.value.toUpperCase())}
            placeholder="Cohort code"
            className="flex-1 rounded-radius-md border border-muted bg-background px-3 py-2 text-sm text-foreground outline-none focus:border-primary"
          />
          <button
            type="submit"
            disabled={!codeInput.trim()}
            className="rounded-radius-md bg-foreground px-4 py-2 text-sm font-semibold text-background disabled:opacity-50 active:opacity-90"
          >
            Join
          </button>
        </form>
        {message && (
          <p className={`mt-2 text-xs ${message.includes("Joined") || message.includes("already") ? "text-success" : "text-danger"}`}>
            {message}
          </p>
        )}

        {cohorts.length > 0 && (
          <div className="mt-4 space-y-2">
            {cohorts.map((cohort) => (
              <div key={cohort.id} className="rounded-radius-md bg-muted px-3 py-2">
                <p className="text-sm font-semibold text-foreground">{cohort.name}</p>
                <p className="text-[10px] text-muted-foreground">Joined {new Date(cohort.joinedAt).toLocaleDateString("id-ID")}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </section>
  );
}

function LeaderboardSection({
  title,
  entries,
  valueKey,
}: {
  title: string;
  entries: { rank: number; displayName: string; xpThisWeek?: number; koinPointsThisWeek?: number; isCurrentUser: boolean }[];
  valueKey: "xpThisWeek" | "koinPointsThisWeek";
}) {
  if (entries.length === 0) return null;

  return (
    <div className="mt-3 rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">{title}</p>
      <div className="mt-2 space-y-1">
        {entries.map((entry) => (
          <div
            key={entry.rank + entry.displayName}
            className={`flex items-center justify-between rounded-radius-md px-2 py-1.5 ${entry.isCurrentUser ? "bg-primary/5" : ""}`}
          >
            <div className="flex items-center gap-2">
              <span className="flex h-5 w-5 items-center justify-center rounded-full bg-muted text-[10px] font-bold text-muted-foreground">
                {entry.rank}
              </span>
              <span className="text-sm text-foreground">{entry.displayName}</span>
            </div>
            <span className="text-xs font-semibold text-xp">{(entry[valueKey] ?? 0).toLocaleString("id-ID")}</span>
          </div>
        ))}
      </div>
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
