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
  requestedSymbols: number;
  unavailableSymbols: string[];
  errors: string[];
}

interface ActiveInstrument {
  symbol: string;
  name: string;
  sourceUrl: string;
}

// Compatibility fallback for local development and older test doubles. In
// production, updateMarketData reads the active Supabase catalogue instead.
const FALLBACK_MVP_INSTRUMENTS: ActiveInstrument[] = [
  { symbol: "BBCA", name: "Bank Central Asia Tbk", sourceUrl: "https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/" },
  { symbol: "BBRI", name: "Bank Rakyat Indonesia Tbk", sourceUrl: "https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/" },
  { symbol: "TLKM", name: "Telkom Indonesia Tbk", sourceUrl: "https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/" },
  { symbol: "GOTO", name: "GoTo Gojek Tokopedia Tbk", sourceUrl: "https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/" },
  { symbol: "UNVR", name: "Unilever Indonesia Tbk", sourceUrl: "https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/" },
];

const OFFICIAL_EOD_SOURCE_URL =
  "https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/";

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

async function getActiveInstruments(supabase: SupabaseClient): Promise<ActiveInstrument[]> {
  // The fallback also keeps the server unit tests decoupled from a database
  // query implementation; production Supabase clients always expose select.
  const table = supabase.from("instruments") as unknown as {
    select?: (columns: string) => {
      eq: (column: string, value: boolean) => {
        order: (column: string, options: { ascending: boolean }) => Promise<{
          data: Array<{ symbol: string; name: string; source_url: string }> | null;
          error: { message: string } | null;
        }>;
      };
    };
  };
  if (typeof table.select !== "function") return FALLBACK_MVP_INSTRUMENTS;

  const { data, error } = await table
    .select("symbol, name, source_url")
    .eq("is_active", true)
    .order("symbol", { ascending: true });

  if (error) throw new Error(`Instrument catalogue query failed: ${error.message}`);

  const instruments = (data ?? [])
    .filter((row) => row.symbol && row.name && row.source_url)
    .map((row) => ({ symbol: row.symbol, name: row.name, sourceUrl: row.source_url }));

  if (instruments.length === 0) {
    throw new Error("Instrument catalogue has no active symbols");
  }

  return instruments;
}

/**
 * Attempt to fetch previous-trading-day EOD prices from IDX public endpoint.
 * Returns rows only for the requested active catalogue symbols. If the fetch
 * fails or a symbol is missing, that symbol is omitted so the caller can use
 * the clearly labelled simulated fallback.
 */
export async function fetchIdxEodPrices(
  tradeDate?: string,
  instruments: ActiveInstrument[] = FALLBACK_MVP_INSTRUMENTS
): Promise<IdxPriceRow[]> {
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
  const instrumentBySymbol = new Map(instruments.map((instrument) => [instrument.symbol, instrument]));

  for (const raw of records) {
    const row = raw as Record<string, unknown>;
    const symbol = String(row.Code ?? row.code ?? row.Ticker ?? row.ticker ?? "").trim();
    const instrument = instrumentBySymbol.get(symbol);
    if (!instrument) continue;

    const closePrice = parseIdxNumber(row.ClosePrice ?? row.closePrice ?? row.Close ?? row.close);
    const volume = parseIdxNumber(row.Volume ?? row.volume ?? row.Vol);

    if (closePrice === null) continue;

    bySymbol.set(symbol, {
      symbol,
      companyName: String(row.Name ?? row.name ?? COMPANY_NAMES[symbol] ?? instrument.name),
      closePrice,
      volume: volume ?? 0,
      tradeDate: targetDate.toISOString().split("T")[0],
    });
  }

  return Array.from(bySymbol.values());
}

/**
 * Upsert real IDX prices for the requested date, then generate synthetic
 * drift prices for any active catalogue symbols that are missing. This keeps the paper
 * trading simulator alive even when the public endpoint is down.
 */
export async function updateMarketData(tradeDate?: string): Promise<UpdateMarketDataResult> {
  const targetDate = tradeDate ? new Date(tradeDate) : new Date();
  const dateString = targetDate.toISOString().split("T")[0];
  const errors: string[] = [];
  let inserted = 0;
  let simulated = 0;
  let simulatedSymbols = new Set<string>();
  let instruments = FALLBACK_MVP_INSTRUMENTS;

  const supabase = getAdminClient();
  try {
    instruments = await getActiveInstruments(supabase);
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    errors.push(`Instrument catalogue error: ${message}`);
  }

  let idxRows: IdxPriceRow[] = [];
  try {
    idxRows = await fetchIdxEodPrices(dateString, instruments);
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    errors.push(`IDX fetch error: ${message}`);
  }

  for (const row of idxRows) {
    const { error } = await supabase.from("market_data").upsert(
      {
        symbol: row.symbol,
        company_name: row.companyName,
        trade_date: row.tradeDate,
        close_price: row.closePrice,
        volume: row.volume,
        source_url: OFFICIAL_EOD_SOURCE_URL,
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

  const missingSymbols = instruments.map((instrument) => instrument.symbol).filter(
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
      simulatedSymbols = new Set(
        (data as Record<string, unknown>[] | null)?.map((row) => String(row.symbol)) ?? []
      );
      simulated = missingSymbols.filter((symbol) => simulatedSymbols.has(symbol)).length;
    }
  }

  const unavailableSymbols = missingSymbols.filter((symbol) => !simulatedSymbols.has(symbol));

  return {
    tradeDate: dateString,
    inserted,
    simulated,
    requestedSymbols: instruments.length,
    unavailableSymbols,
    errors,
  };
}
