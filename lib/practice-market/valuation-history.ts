import { supabase } from "@/lib/auth/client";

export const PRACTICE_MARKET_SEASON_ONE_SLUG = "season-1-price-pressure-calm-choices";

export interface PracticeMarketValuation {
  sessionNumber: number;
  valuedAt: string;
  cashBalance: number;
  holdingsValue: number;
  totalValue: number;
}

const inFlightHistoryRequests = new Map<string, Promise<PracticeMarketValuation[]>>();

function readMoney(value: unknown): number | null {
  if (typeof value === "number" && Number.isFinite(value)) return value;
  if (typeof value === "string" && value.trim() !== "") {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }
  return null;
}

function parseValuation(row: unknown): PracticeMarketValuation | null {
  if (!row || typeof row !== "object") return null;
  const value = row as Record<string, unknown>;
  const sessionNumber = readMoney(value.session_number);
  const cashBalance = readMoney(value.cash_balance);
  const holdingsValue = readMoney(value.holdings_value);
  const totalValue = readMoney(value.total_value);

  if (
    sessionNumber === null ||
    !Number.isInteger(sessionNumber) ||
    sessionNumber < 1 ||
    sessionNumber > 10 ||
    typeof value.valued_at !== "string" ||
    value.valued_at.trim() === "" ||
    cashBalance === null ||
    holdingsValue === null ||
    totalValue === null
  ) {
    return null;
  }

  // This is a shape conversion only. The immutable ledger value remains the
  // sole value displayed by the chart; the browser never reconstructs it.
  return {
    sessionNumber,
    valuedAt: value.valued_at,
    cashBalance,
    holdingsValue,
    totalValue,
  };
}

/**
 * The only Season portfolio history reader. KO-421 authorises this RPC for
 * the signed-in learner and returns immutable, session-close ledger values.
 */
export async function getPracticeMarketValuationHistory(
  seasonSlug = PRACTICE_MARKET_SEASON_ONE_SLUG,
): Promise<PracticeMarketValuation[]> {
  const activeRequest = inFlightHistoryRequests.get(seasonSlug);
  if (activeRequest) return activeRequest;

  const request = Promise.resolve(
    supabase.rpc("get_practice_market_valuation_history", { p_season_slug: seasonSlug }),
  )
    .then(({ data, error }) => {
      if (error) throw new Error(error.message);
      if (!Array.isArray(data)) return [];
      return data.map(parseValuation).filter((row): row is PracticeMarketValuation => row !== null);
    });

  inFlightHistoryRequests.set(seasonSlug, request);
  const clearInFlight = () => {
    if (inFlightHistoryRequests.get(seasonSlug) === request) {
      inFlightHistoryRequests.delete(seasonSlug);
    }
  };
  void request.then(clearInFlight, clearInFlight);

  return request;
}
