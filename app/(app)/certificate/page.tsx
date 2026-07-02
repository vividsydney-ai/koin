"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/lib/auth/use-auth";
import { getCertificate, type Certificate } from "@/lib/graduation/client";

export default function CertificatePage() {
  const { user, loading: authLoading } = useAuth(true);
  const [certificate, setCertificate] = useState<Certificate | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const data = await getCertificate(user.id);
      if (!mounted) return;
      setCertificate(data);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const isLoading = authLoading || loading;

  if (isLoading) {
    return (
      <main className="min-h-screen bg-background p-5 pb-28">
        <div className="h-96 animate-pulse rounded-radius-lg bg-muted" />
      </main>
    );
  }

  if (!certificate) {
    return (
      <main className="min-h-screen bg-background p-5 pb-28">
        <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-8 text-center">
          <p className="text-4xl">🎓</p>
          <h1 className="mt-3 text-xl font-bold text-foreground">Not graduated yet</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Grow your paper trading portfolio to 3x–5x your starting value to earn your certificate.
          </p>
          <Link
            href="/trade"
            className="mt-4 inline-block rounded-radius-md bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground"
          >
            Go to Trade
          </Link>
        </div>
      </main>
    );
  }

  const shareUrl = certificate.sharePublicId
    ? `${typeof window !== "undefined" ? window.location.origin : ""}/certificate/${certificate.sharePublicId}`
    : null;

  const handleShare = async () => {
    if (!shareUrl) return;
    const shareData = {
      title: "I graduated from Koin Paper Trading",
      text: `I reached ${certificate?.multiplierAchieved.toFixed(1)}x my starting portfolio value!`,
      url: shareUrl,
    };
    if (navigator.canShare && navigator.canShare(shareData)) {
      try {
        await navigator.share(shareData);
      } catch {
        // User cancelled.
      }
    }
  };

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <div className="rounded-radius-lg border border-primary/20 bg-gradient-to-br from-surface to-primary/5 p-6 text-center shadow-sm">
        <p className="text-5xl">🎓</p>
        <h1 className="mt-4 text-2xl font-bold text-foreground">Certificate of Graduation</h1>
        <p className="mt-1 text-sm text-muted-foreground">Koin Paper Trading Program</p>

        <div className="mt-6 space-y-2">
          <p className="text-xs uppercase tracking-wider text-muted-foreground">Portfolio value</p>
          <p className="text-xl font-bold text-foreground">
            Rp {certificate.portfolioValueAtGraduation.toLocaleString("id-ID")}
          </p>
        </div>

        <div className="mt-4 space-y-2">
          <p className="text-xs uppercase tracking-wider text-muted-foreground">Multiplier achieved</p>
          <p className="text-3xl font-bold text-primary">{certificate.multiplierAchieved.toFixed(1)}x</p>
        </div>

        <p className="mt-4 font-mono text-xs text-muted-foreground">{certificate.certificateCode}</p>
        <p className="text-xs text-muted-foreground">Issued {new Date(certificate.issuedAt).toLocaleDateString("id-ID")}</p>

        {shareUrl && (
          <button
            onClick={handleShare}
            className="mt-6 w-full rounded-radius-md bg-primary py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90"
          >
            Share certificate
          </button>
        )}
      </div>

      <div className="mt-4 text-center">
        <Link href="/brokerage" className="text-sm font-semibold text-primary">
          View brokerage recommendations →
        </Link>
      </div>
    </main>
  );
}
