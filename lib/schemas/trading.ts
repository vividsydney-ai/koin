import { z } from "zod";

export const tradeTypes = ["buy", "sell"] as const;

export const executeTradeSchema = z.object({
  userId: z.string().uuid("Invalid user ID"),
  symbol: z.string().min(1, "Symbol is required").max(20, "Symbol is too long").toUpperCase(),
  tradeType: z.enum(tradeTypes, { message: "Trade type must be buy or sell" }),
  lotCount: z.number().int("Lot count must be a whole number").min(1, "At least 1 lot is required"),
});

export type ExecuteTradeInput = z.infer<typeof executeTradeSchema>;
