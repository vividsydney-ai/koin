"use client";

import { useState, useEffect } from "react";

export function PriceRiseAnimation() {
  const [started, setStarted] = useState(false);

  useEffect(() => {
    const t = setTimeout(() => setStarted(true), 300);
    return () => clearTimeout(t);
  }, []);

  return (
    <div className="relative mx-auto aspect-square w-full max-w-[280px]">
      {/* Rising price bars in background */}
      <div className="absolute inset-x-0 bottom-[15%] flex items-end justify-center gap-4">
        <PriceBar height={40} year="2020" delay={100} />
        <PriceBar height={64} year="2023" delay={300} />
        <PriceBar height={88} year="2025" delay={500} active />
      </div>

      {/* Bowl */}
      <div className="absolute bottom-[18%] left-1/2 z-10 -translate-x-1/2">
        <svg viewBox="0 0 160 80" className="w-36 drop-shadow-sm">
          <path
            d="M10 20 Q80 75 150 20"
            fill="none"
            stroke="currentColor"
            strokeWidth="4"
            strokeLinecap="round"
            className="text-foreground"
          />
          <ellipse
            cx="80"
            cy="20"
            rx="70"
            ry="16"
            className="fill-surface stroke-foreground"
            strokeWidth="3"
          />
          {/* Noodles */}
          <path
            d="M45 18 Q55 8 65 18 Q75 8 85 18 Q95 8 105 18 Q115 8 125 18"
            fill="none"
            stroke="#F59E0B"
            strokeWidth="3"
            strokeLinecap="round"
          />
          {/* Egg */}
          <circle cx="70" cy="22" r="7" className="fill-warning" />
          <circle cx="70" cy="22" r="2.5" className="fill-surface" />
        </svg>
      </div>

      {/* Steam */}
      <div className="absolute bottom-[44%] left-[42%] z-20 flex gap-3">
        <span className="steam-particle h-3 w-1 rounded-full bg-muted-foreground/40" />
        <span className="steam-particle h-4 w-1 rounded-full bg-muted-foreground/40 [animation-delay:0.2s]" />
        <span className="steam-particle h-3 w-1 rounded-full bg-muted-foreground/40 [animation-delay:0.4s]" />
      </div>

      {/* Price tags */}
      <div className="absolute bottom-[62%] left-1/2 z-20 w-full -translate-x-1/2 px-5">
        <div className="flex items-end justify-between">
          <PriceTag price="Rp 12.000" year="2020" visible={started} delay={0} />
          <PriceTag price="Rp 16.000" year="2025" visible={started} delay={600} highlight />
        </div>
      </div>

      {/* Wallet */}
      <div className="absolute right-[6%] top-[54%] z-20">
        <div
          className={`wallet relative h-[58px] w-[88px] rounded-radius-md bg-foreground p-2 shadow-sm transition-transform duration-700 ease-out-quart ${
            started ? "scale-100" : "scale-110"
          }`}
        >
          <div className="absolute -top-2 right-2 h-3.5 w-7 rounded-t-radius-sm bg-foreground/80" />
          <div className="mt-3 text-center text-[10px] font-bold uppercase tracking-wide text-primary-foreground">
            Rina
          </div>
        </div>
        <div
          className={`absolute -right-1 -top-3 flex h-8 w-8 items-center justify-center rounded-full bg-danger text-xs font-bold text-white transition-all duration-700 ease-out-quart ${
            started ? "translate-y-0 opacity-100 [transition-delay:700ms]" : "translate-y-2 opacity-0"
          }`}
        >
          -25%
        </div>
      </div>

      <style jsx>{`
        .steam-particle {
          animation: rise 2.2s ease-out infinite;
          opacity: 0;
        }
        @keyframes rise {
          0% {
            transform: translateY(0) scaleY(0.6);
            opacity: 0;
          }
          20% {
            opacity: 0.6;
          }
          80% {
            opacity: 0.3;
          }
          100% {
            transform: translateY(-28px) scaleY(1.2);
            opacity: 0;
          }
        }
        @media (prefers-reduced-motion: reduce) {
          .steam-particle {
            animation: none;
            opacity: 0.4;
          }
        }
      `}</style>
    </div>
  );
}

function PriceBar({
  height,
  year,
  delay,
  active = false,
}: {
  height: number;
  year: string;
  delay: number;
  active?: boolean;
}) {
  return (
    <div className="flex flex-col items-center gap-1.5">
      <div
        className={`w-7 rounded-t-radius-sm transition-all duration-700 ease-out-quart ${
          active ? "bg-primary" : "bg-muted"
        }`}
        style={{
          height: `${height}px`,
          transitionDelay: `${delay}ms`,
        }}
      />
      <span className="text-[10px] font-medium text-muted-foreground">{year}</span>
    </div>
  );
}

function PriceTag({
  price,
  year,
  visible,
  delay,
  highlight = false,
}: {
  price: string;
  year: string;
  visible: boolean;
  delay: number;
  highlight?: boolean;
}) {
  return (
    <div
      className={`flex flex-col items-center transition-all duration-500 ease-out-quart ${
        visible ? "translate-y-0 opacity-100" : "translate-y-4 opacity-0"
      }`}
      style={{ transitionDelay: `${delay}ms` }}
    >
      <span
        className={`rounded-radius-md px-3 py-1.5 text-sm font-bold shadow-sm ${
          highlight ? "bg-primary text-primary-foreground" : "bg-muted text-foreground"
        }`}
      >
        {price}
      </span>
      <span className="mt-1 text-xs text-muted-foreground">{year}</span>
    </div>
  );
}
