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
      {/* Bowl */}
      <div className="absolute bottom-[18%] left-1/2 -translate-x-1/2">
        <svg viewBox="0 0 160 80" className="w-40">
          <path
            d="M10 20 Q80 75 150 20"
            fill="none"
            stroke="currentColor"
            strokeWidth="4"
            strokeLinecap="round"
            className="text-foreground"
          />
          <ellipse cx="80" cy="20" rx="70" ry="16" className="fill-surface stroke-foreground" strokeWidth="3" />
          {/* Noodles */}
          <path
            d="M45 18 Q55 8 65 18 Q75 8 85 18 Q95 8 105 18 Q115 8 125 18"
            fill="none"
            stroke="#F59E0B"
            strokeWidth="3"
            strokeLinecap="round"
          />
          {/* Egg */}
          <circle cx="70" cy="22" r="8" className="fill-warning" />
          <circle cx="70" cy="22" r="3" className="fill-surface" />
        </svg>
      </div>

      {/* Steam */}
      <div className="absolute bottom-[48%] left-[42%] flex gap-3">
        <span className="steam-particle h-3 w-1 rounded-full bg-muted-foreground/40" />
        <span className="steam-particle h-4 w-1 rounded-full bg-muted-foreground/40 [animation-delay:0.2s]" />
        <span className="steam-particle h-3 w-1 rounded-full bg-muted-foreground/40 [animation-delay:0.4s]" />
      </div>

      {/* Price tags */}
      <div className="absolute bottom-[62%] left-1/2 w-full -translate-x-1/2 px-6">
        <div className="flex items-end justify-between">
          <PriceTag price="Rp 12.000" year="2020" visible={started} delay={0} />
          <PriceTag price="Rp 16.000" year="2025" visible={started} delay={600} highlight />
        </div>
      </div>

      {/* Wallet */}
      <div className="absolute right-[8%] top-[55%]">
        <div className={`wallet relative h-16 w-24 rounded-radius-md bg-xp p-2 shadow-sm transition-transform duration-700 ease-out-quart ${started ? "scale-100" : "scale-110"}`}>
          <div className="absolute -top-2 right-3 h-4 w-8 rounded-t-radius-sm bg-xp/80" />
          <div className="mt-4 text-center text-xs font-bold text-primary-foreground">Rina</div>
        </div>
        <div
          className={`absolute -right-1 -top-3 flex h-8 w-8 items-center justify-center rounded-full bg-danger text-xs font-bold text-white transition-all duration-700 ease-out-quart ${started ? "translate-y-0 opacity-100 [transition-delay:700ms]" : "translate-y-2 opacity-0"}`}
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
      <span className={`rounded-radius-md px-3 py-1.5 text-sm font-bold ${highlight ? "bg-streak text-white" : "bg-muted text-foreground"}`}>
        {price}
      </span>
      <span className="mt-1 text-xs text-muted-foreground">{year}</span>
    </div>
  );
}
