"use client";

import { useEffect, useState } from "react";
import PracticeMarketCutover from "@/components/practice-market/PracticeMarketCutover";
import PracticeMarketSeasonPortfolio from "@/components/practice-market/PracticeMarketSeasonPortfolio";
import {
  getPracticeMarketCutoverStatus,
  type PracticeMarketCutoverStatus,
} from "@/lib/practice-market/cutover";

export default function TradePage() {
  const [status, setStatus] = useState<PracticeMarketCutoverStatus>();

  useEffect(() => {
    let active = true;
    void getPracticeMarketCutoverStatus().then((nextStatus) => {
      if (active) setStatus(nextStatus);
    });
    return () => {
      active = false;
    };
  }, []);

  if (status?.seasonAccessEnabled) {
    return <PracticeMarketSeasonPortfolio />;
  }

  return <PracticeMarketCutover status={status} />;
}
