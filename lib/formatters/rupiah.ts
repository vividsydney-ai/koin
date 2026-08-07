export function formatRupiah(value: number): string {
  return `Rp ${new Intl.NumberFormat("id-ID", {
    maximumFractionDigits: 0,
  }).format(Math.abs(value))}`;
}

export type ChangeTone = "positive" | "negative" | "neutral";

export function getChangeTone(change: number | null): ChangeTone {
  if (change === null || change === 0) return "neutral";
  return change > 0 ? "positive" : "negative";
}

export function formatRupiahChange(change: number | null): string {
  if (change === null) return "—";
  const prefix = change > 0 ? "+ " : change < 0 ? "- " : "";
  return `${prefix}${formatRupiah(change)}`;
}
