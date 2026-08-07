import { supabase } from "@/lib/auth/client";
import { ok, err, type Result } from "@/lib/types/result";
import { serviceError, type ServiceError } from "@/lib/types/service-error";
import { executeTradeSchema } from "@/lib/schemas/trading";
import type { ExecuteTradeInput } from "@/lib/schemas/trading";
import type { TradeResult } from "@/lib/trading/client";

export type { ExecuteTradeInput } from "@/lib/schemas/trading";

export async function executeTrade(
  input: ExecuteTradeInput
): Promise<Result<TradeResult, ServiceError>> {
  const parsed = executeTradeSchema.safeParse(input);
  if (!parsed.success) {
    return err(serviceError("validation_error", parsed.error.issues[0].message));
  }

  const { userId, symbol, tradeType, lotCount } = parsed.data;

  const { data, error } = await supabase.rpc("execute_trade", {
    p_user_id: userId,
    p_symbol: symbol,
    p_trade_type: tradeType,
    p_lot_count: lotCount,
  });

  if (error || !data) {
    return err(serviceError("rpc_error", error?.message ?? "Trade failed"));
  }

  const raw = data as Record<string, unknown>;
  return ok({
    tradeId: String(raw.trade_id),
    symbol: String(raw.symbol),
    tradeType: raw.trade_type as "buy" | "sell",
    shares: Number(raw.shares),
    lotCount: Number(raw.lot_count),
    price: Number(raw.price),
    totalAmount: Number(raw.total_amount),
    cashBalance: Number(raw.cash_balance),
  });
}
