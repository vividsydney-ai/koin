import { createClient, type SupabaseClient } from "@supabase/supabase-js";

let adminClient: SupabaseClient | null = null;

export interface IdxPriceRow {
  symbol: string;
  companyName: string;
  closePrice: number;
  volume: number;
  tradeDate: string; // YYYY-MM-DD
}

export interface UpdateMarketDataResult {
  tradeDate: string;
  inserted: number;
  simulated: number;
  errors: string[];
}

const MVP_SYMBOLS = ["BBCA", "BBRI", "TLKM", "GOTO", "UNVR"];
const SUPPORTED_SYMBOLS = [
  "BBCA", "BBNI", "BBRI", "BMRI", "GOTO", "ICBP", "INDF", "TLKM", "UNVR",
  "XISR", "XIIT", "XISC",
];

const COMPANY_NAMES: Record<string, string> = {
  BBCA: "Bank Central Asia Tbk",
  BBNI: "Bank Negara Indonesia (Persero) Tbk",
  BBRI: "Bank Rakyat Indonesia Tbk",
  BMRI: "Bank Mandiri (Persero) Tbk",
  TLKM: "Telkom Indonesia Tbk",
  GOTO: "GoTo Gojek Tokopedia Tbk",
  ICBP: "Indofood CBP Sukses Makmur Tbk",
  INDF: "Indofood Sukses Makmur Tbk",
  UNVR: "Unilever Indonesia Tbk",
  XISR: "Reksa Dana Indeks Syariah Indonesia ETF",
  XIIT: "Premier ETF Indonesia Financial",
  XISC: "Premier ETF Indonesia Consumer",
};

function getAdminClient(): SupabaseClient {
  if (!adminClient) {
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("Missing Supabase service role credentials for market data updater");
    }

    adminClient = createClient(supabaseUrl, serviceRoleKey);
  }

  return adminClient;
}

function formatIdxDate(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}${m}${d}`;
}

function parseIdxNumber(value: unknown): number | null {
  if (typeof value === "number") return value;
  if (typeof value !== "string") return null;
  const cleaned = value.replace(/,/g, "").trim();
  if (cleaned === "-" || cleaned === "") return null;
  const parsed = Number(cleaned);
  return Number.isFinite(parsed) ? parsed : null;
}

/**
 * Attempt to fetch previous-trading-day EOD prices from IDX public endpoint.
 * Returns rows only for the MVP symbols. If the fetch fails or a symbol is
 * missing, that symbol is omitted so the caller can fall back to synthetic.
 */
export async function fetchIdxEodPrices(tradeDate?: string): Promise<IdxPriceRow[]> {
  const targetDate = tradeDate ? new Date(tradeDate) : new Date();
  const formatted = formatIdxDate(targetDate);
  const url = `https://www.idx.co.id/umbraco/Surface/TradingSummary/GetStockSummary?date=${formatted}&start=0&length=1000`;

  const response = await fetch(url, {
    headers: {
      Accept: "application/json",
    },
  });

  if (!response.ok) {
    throw new Error(`IDX fetch failed: ${response.status} ${response.statusText}`);
  }

  const json = (await response.json()) as Record<string, unknown>;
  const records = Array.isArray(json.data) ? json.data : Array.isArray(json) ? json : [];

  const bySymbol = new Map<string, IdxPriceRow>();

  for (const raw of records) {
    const row = raw as Record<string, unknown>;
    const symbol = String(row.Code ?? row.code ?? row.Ticker ?? row.ticker ?? "").trim();
    if (!SUPPORTED_SYMBOLS.includes(symbol)) continue;

    const closePrice = parseIdxNumber(row.ClosePrice ?? row.closePrice ?? row.Close ?? row.close);
    const volume = parseIdxNumber(row.Volume ?? row.volume ?? row.Vol);

    if (closePrice === null) continue;

    bySymbol.set(symbol, {
      symbol,
      companyName: COMPANY_NAMES[symbol] ?? String(row.Name ?? row.name ?? symbol),
      closePrice,
      volume: volume ?? 0,
      tradeDate: targetDate.toISOString().split("T")[0],
    });
  }

  return Array.from(bySymbol.values());
}

/**
 * Upsert real IDX prices for the requested date, then generate synthetic
 * drift prices for any MVP symbols that are missing. This keeps the paper
 * trading simulator alive even when the public endpoint is down.
 */
export async function updateMarketData(tradeDate?: string): Promise<UpdateMarketDataResult> {
  const targetDate = tradeDate ? new Date(tradeDate) : new Date();
  const dateString = targetDate.toISOString().split("T")[0];
  const errors: string[] = [];
  let inserted = 0;
  let simulated = 0;

  let idxRows: IdxPriceRow[] = [];
  try {
    idxRows = await fetchIdxEodPrices(dateString);
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    errors.push(`IDX fetch error: ${message}`);
  }

  const supabase = getAdminClient();

  for (const row of idxRows) {
    const { error } = await supabase.from("market_data").upsert(
      {
        symbol: row.symbol,
        company_name: row.companyName,
        trade_date: row.tradeDate,
        close_price: row.closePrice,
        volume: row.volume,
        source_url: "https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/",
        is_simulated: false,
      },
      { onConflict: "symbol,trade_date" }
    );

    if (error) {
      errors.push(`Upsert ${row.symbol}: ${error.message}`);
    } else {
      inserted += 1;
    }
  }

  const missingSymbols = MVP_SYMBOLS.filter(
    (symbol) => !idxRows.some((row) => row.symbol === symbol)
  );

  if (missingSymbols.length > 0) {
    errors.push(`Missing symbols, will synthesize: ${missingSymbols.join(", ")}`);

    const { data, error } = await supabase.rpc("seed_next_market_data", {
      p_trade_date: dateString,
    });

    if (error) {
      errors.push(`Synthetic fallback error: ${error.message}`);
    } else {
      const syntheticSymbols = new Set(
        (data as Record<string, unknown>[] | null)?.map((row) => String(row.symbol)) ?? []
      );
      simulated = syntheticSymbols.size;
    }
  }

  return { tradeDate: dateString, inserted, simulated, errors };
}
