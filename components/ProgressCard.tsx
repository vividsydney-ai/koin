"use client";

import { useRef, useState, useEffect } from "react";

export interface ProgressCardData {
  displayName: string;
  levelName: string;
  totalXp: number;
  streakDays: number;
  koinPoints: number;
  portfolioReturnPct: number;
}

interface ProgressCardProps {
  data: ProgressCardData;
  onClose: () => void;
}

export function ProgressCardModal({ data, onClose }: ProgressCardProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [imageUrl, setImageUrl] = useState<string | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    const width = 600;
    const height = 340;
    canvas.width = width;
    canvas.height = height;

    // Background gradient.
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, "#01696f");
    gradient.addColorStop(1, "#014f54");
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);

    // Decorative circles.
    ctx.fillStyle = "rgba(255, 255, 255, 0.06)";
    ctx.beginPath();
    ctx.arc(width - 60, 60, 120, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.arc(-40, height - 40, 140, 0, Math.PI * 2);
    ctx.fill();

    // Logo / brand.
    ctx.fillStyle = "#ffffff";
    ctx.font = "bold 28px Satoshi, ui-sans-serif, system-ui, sans-serif";
    ctx.fillText("Koin", 40, 60);

    // User name.
    ctx.font = "bold 36px Satoshi, ui-sans-serif, system-ui, sans-serif";
    ctx.fillText(data.displayName || "Learner", 40, 120);

    // Level.
    ctx.font = "18px Satoshi, ui-sans-serif, system-ui, sans-serif";
    ctx.fillStyle = "rgba(255, 255, 255, 0.85)";
    ctx.fillText(`${data.levelName} • ${data.totalXp.toLocaleString("id-ID")} XP`, 40, 155);

    // Stats grid.
    const stats = [
      { label: "Streak", value: `${data.streakDays}d`, icon: "🔥" },
      { label: "Koin Points", value: data.koinPoints.toLocaleString("id-ID"), icon: "🪙" },
      { label: "Return", value: `${data.portfolioReturnPct >= 0 ? "+" : ""}${data.portfolioReturnPct.toFixed(1)}%`, icon: "📈" },
    ];

    const startX = 40;
    const startY = 210;
    const boxWidth = 170;
    const gap = 15;

    stats.forEach((stat, index) => {
      const x = startX + index * (boxWidth + gap);
      ctx.fillStyle = "rgba(255, 255, 255, 0.12)";
      ctx.beginPath();
      ctx.roundRect(x, startY, boxWidth, 90, 12);
      ctx.fill();

      ctx.font = "24px Satoshi, ui-sans-serif, system-ui, sans-serif";
      ctx.fillStyle = "#ffffff";
      ctx.fillText(stat.icon, x + 14, startY + 34);

      ctx.font = "bold 22px Satoshi, ui-sans-serif, system-ui, sans-serif";
      ctx.fillText(stat.value, x + 14, startY + 62);

      ctx.font = "14px Satoshi, ui-sans-serif, system-ui, sans-serif";
      ctx.fillStyle = "rgba(255, 255, 255, 0.7)";
      ctx.fillText(stat.label, x + 14, startY + 82);
    });

    // Footer.
    ctx.font = "14px Satoshi, ui-sans-serif, system-ui, sans-serif";
    ctx.fillStyle = "rgba(255, 255, 255, 0.6)";
    ctx.fillText("web.koinaku.com", 40, height - 24);

    setImageUrl(canvas.toDataURL("image/png"));
  }, [data]);

  const handleShare = async () => {
    if (!imageUrl) return;
    const response = await fetch(imageUrl);
    const blob = await response.blob();
    const file = new File([blob], "koin-progress.png", { type: "image/png" });

    if (navigator.canShare && navigator.canShare({ files: [file] })) {
      try {
        await navigator.share({
          title: "My Koin progress",
          text: `I'm at ${data.levelName} with ${data.totalXp} XP on Koin!`,
          files: [file],
        });
      } catch {
        // User cancelled.
      }
    }
  };

  const handleDownload = () => {
    if (!imageUrl) return;
    const link = document.createElement("a");
    link.href = imageUrl;
    link.download = "koin-progress.png";
    link.click();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="w-full max-w-md rounded-radius-lg bg-surface p-5 shadow-lg">
        <div className="mb-4 flex items-center justify-between">
          <h2 className="text-lg font-bold text-foreground">Share your progress</h2>
          <button onClick={onClose} className="text-2xl text-muted-foreground">
            ×
          </button>
        </div>

        <canvas ref={canvasRef} className="hidden" />

        {imageUrl && (
          <img
            src={imageUrl}
            alt="Progress card"
            className="w-full rounded-radius-md"
          />
        )}

        <div className="mt-4 grid grid-cols-2 gap-3">
          <button
            onClick={handleDownload}
            className="rounded-radius-md bg-muted py-2.5 text-sm font-semibold text-foreground active:opacity-90"
          >
            Download
          </button>
          <button
            onClick={handleShare}
            className="rounded-radius-md bg-primary py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90"
          >
            Share
          </button>
        </div>
      </div>
    </div>
  );
}
