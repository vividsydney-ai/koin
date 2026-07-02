"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth/use-auth";
import { createFriendInvite, acceptFriendInvite, getFriends, type FriendInvite, type Friend } from "@/lib/friends/client";

export default function FriendsPage() {
  const { user, profile, loading: authLoading } = useAuth(true);
  const [invite, setInvite] = useState<FriendInvite | null>(null);
  const [friends, setFriends] = useState<Friend[]>([]);
  const [codeInput, setCodeInput] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const [friendsData] = await Promise.all([getFriends(user.id)]);
      if (!mounted) return;
      setFriends(friendsData);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const handleCreateInvite = async () => {
    if (!user) return;
    setMessage(null);
    const result = await createFriendInvite(user.id);
    if (result) {
      setInvite(result);
    } else {
      setMessage("Could not create invite. Try again.");
    }
  };

  const handleAccept = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !codeInput.trim()) return;
    setMessage(null);
    const result = await acceptFriendInvite(user.id, codeInput.trim());
    if (result) {
      setMessage("Invite accepted! You're now friends.");
      setCodeInput("");
      const friendsData = await getFriends(user.id);
      setFriends(friendsData);
    } else {
      setMessage("Invalid or expired invite code.");
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
          <InviteSection
            invite={invite}
            displayName={profile?.display_name ?? "Learner"}
            onCreate={handleCreateInvite}
            codeInput={codeInput}
            onCodeChange={setCodeInput}
            onAccept={handleAccept}
            message={message}
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
              <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-4">
                <p className="text-sm text-muted-foreground">No friends yet. Share your invite code to get started.</p>
              </div>
            ) : (
              <div className="space-y-2">
                {acceptedFriends.map((friend) => (
                  <FriendRow key={friend.userId} friend={friend} />
                ))}
              </div>
            )}
          </section>
        </div>
      )}
    </main>
  );
}

function InviteSection({
  invite,
  displayName,
  onCreate,
  codeInput,
  onCodeChange,
  onAccept,
  message,
}: {
  invite: FriendInvite | null;
  displayName: string;
  onCreate: () => void;
  codeInput: string;
  onCodeChange: (value: string) => void;
  onAccept: (e: React.FormEvent) => void;
  message: string | null;
}) {
  const shareText = invite
    ? `Join me on Koin and learn to invest together! Use my invite code: ${invite.inviteCode}`
    : "";

  const handleShare = async () => {
    if (!invite) return;
    const shareData = {
      title: "Join me on Koin",
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

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <h2 className="text-sm font-semibold text-foreground">Invite friends</h2>
      <p className="text-xs text-muted-foreground">Share your code and climb the weekly leaderboard together.</p>

      {invite ? (
        <div className="mt-3 space-y-2">
          <div className="flex items-center justify-between rounded-radius-md bg-muted px-3 py-2">
            <span className="font-mono text-lg font-bold tracking-widest text-foreground">{invite.inviteCode}</span>
            <button
              onClick={handleShare}
              className="rounded-radius-md bg-primary px-3 py-1.5 text-xs font-semibold text-primary-foreground active:opacity-90"
            >
              Share
            </button>
          </div>
          <p className="text-xs text-muted-foreground">
            Used {invite.usesCount} of {invite.maxUses} times. Expires {new Date(invite.expiresAt).toLocaleDateString("id-ID")}.
          </p>
        </div>
      ) : (
        <button
          onClick={onCreate}
          className="mt-3 w-full rounded-radius-md bg-primary py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90"
        >
          Generate invite code
        </button>
      )}

      <form onSubmit={onAccept} className="mt-4 space-y-2">
        <label htmlFor="invite-code" className="text-xs font-medium text-muted-foreground">
          Have a friend's code?
        </label>
        <div className="flex gap-2">
          <input
            id="invite-code"
            type="text"
            value={codeInput}
            onChange={(e) => onCodeChange(e.target.value.toUpperCase())}
            placeholder="Enter code"
            className="flex-1 rounded-radius-md border border-muted bg-background px-3 py-2 text-sm text-foreground outline-none focus:border-primary"
          />
          <button
            type="submit"
            disabled={!codeInput.trim()}
            className="rounded-radius-md bg-foreground px-4 py-2 text-sm font-semibold text-background disabled:opacity-50 active:opacity-90"
          >
            Add
          </button>
        </div>
        {message && (
          <p className={`text-xs ${message.includes("accepted") || message.includes("now friends") ? "text-success" : "text-danger"}`}>
            {message}
          </p>
        )}
      </form>
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
