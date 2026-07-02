"use client";

import { useEffect, useState } from "react";
import { getBrokerageRecommendations, type BrokerageRecommendation } from "@/lib/brokerage/client";

export default function BrokeragePage() {
  const [recommendations, setRecommendations] = useState<BrokerageRecommendation[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const data = await getBrokerageRecommendations();
      if (!mounted) return;
      setRecommendations(data);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, []);

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Brokerage recommendations</h1>
        <p className="text-sm text-muted-foreground">
          After graduating from paper trading, these OJK-registered platforms can help you invest for real.
        </p>
      </header>

      {loading ? (
        <div className="space-y-3">
          <div className="h-28 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-28 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-28 animate-pulse rounded-radius-lg bg-muted" />
        </div>
      ) : (
        <div className="space-y-3">
          {recommendations.map((rec) => (
            <a
              key={rec.slug}
              href={rec.url}
              target="_blank"
              rel="noopener noreferrer"
              className="block rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm transition-colors hover:border-primary/30"
            >
              <div className="flex items-start gap-3">
                <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-radius-md bg-muted text-xl">
                  🏦
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between">
                    <h2 className="font-semibold text-foreground">{rec.name}</h2>
                    <span className="rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-primary">
                      {rec.riskLevel}
                    </span>
                  </div>
                  <p className="mt-1 text-sm text-muted-foreground">{rec.description}</p>
                  <div className="mt-2 flex flex-wrap gap-1">
                    {rec.productTypes.map((type) => (
                      <span
                        key={type}
                        className="rounded-radius-md bg-muted px-2 py-0.5 text-[10px] text-muted-foreground"
                      >
                        {type.replace("_", " ")}
                      </span>
                    ))}
                  </div>
                  {rec.ojkRegistered && (
                    <p className="mt-2 text-[10px] font-medium text-success">OJK registered</p>
                  )}
                </div>
              </div>
            </a>
          ))}
        </div>
      )}
    </main>
  );
}
