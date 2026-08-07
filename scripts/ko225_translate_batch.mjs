import dotenv from "dotenv";
import { createClient } from "@supabase/supabase-js";

dotenv.config({ path: ".env.local", quiet: true });
const source = process.env.KO225_SOURCE ?? "en";
const limit = Number(process.env.KO225_LIMIT ?? 10);
const offset = Number(process.env.KO225_OFFSET ?? 0);
const pair = process.env.KO225_PAIR ?? "";
const targetField = process.env.KO225_FIELD ?? (source === "en" ? "body_id" : "body");
const mixed = process.env.KO225_MIXED === "1";
const unique = process.env.KO225_UNIQUE === "1";
const exactAny = process.env.KO225_EXACT_ANY === "1";
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
const english = "the and or is are to of in for with what which how why should can from your you this that than when where does have income wealth money saving savings debt risk price market asset assets return investing budget loan interest inflation answer correct someone compare choose buy sell first last monthly year rate amount called means ability use financial needs wants only higher lower before after because without many one two four five true false fill blank define definition liquidity solvency leverage volatility".split(" ");
const indonesian = "yang dan atau adalah untuk dari di dengan apa mana bagaimana mengapa harus dapat kamu ini itu daripada ketika memiliki pendapatan kekayaan uang tabungan utang risiko harga pasar aset anggaran pinjaman bunga inflasi jawaban benar seseorang pilih beli jual pertama terakhir bulanan tahun jumlah disebut berarti kemampuan gunakan kebutuhan keinginan hanya sebelum setelah karena tanpa banyak satu dua empat lima salah isi kosong definisi likuiditas solvabilitas leverage volatilitas".split(" ");
const text = (value) => typeof value === "string" ? value : JSON.stringify(value ?? "");
const score = (value, markers) => { const words = ` ${text(value).toLowerCase().replace(/[^a-z0-9à-ž]+/g, " ")} `; return markers.reduce((n, marker) => n + (words.includes(` ${marker} `) ? 1 : 0), 0); };
const language = (value) => { const en = score(value, english), id = score(value, indonesian); return en > id + 1 ? "en" : id > en + 1 ? "id" : "neutral"; };
const hasEnglishString = (value) => {
  if (typeof value === "string") return value.length > 18 && /\b(the|and|or|is|are|to|of|in|for|with|what|which|how|why|should|can|from|your|you|this|that|when|where|does|have|income|wealth|money|saving|debt|risk|price|market|asset|return|investing|budget|loan|interest|inflation|answer|correct|someone|compare|choose|buy|sell|monthly|financial|needs|wants|define|definition)\b/i.test(value);
  if (Array.isArray(value)) return value.some(hasEnglishString);
  if (value && typeof value === "object") return Object.values(value).some(hasEnglishString);
  return false;
};
function restoreEnums(value, original) {
  if (Array.isArray(value) && Array.isArray(original)) { value.forEach((item, index) => restoreEnums(item, original[index])); return; }
  if (!value || typeof value !== "object" || !original || typeof original !== "object") return;
  for (const key of Object.keys(value)) {
    if ((key === "type" || key === "difficulty") && original[key] !== undefined) value[key] = original[key];
    else restoreEnums(value[key], original[key]);
  }
}

const { data, error } = await supabase.from("content_variants").select("id,body,body_id").eq("is_active", true);
if (error) throw error;
let rows = data.filter((row) => {
  if (exactAny) return JSON.stringify(row.body) === JSON.stringify(row.body_id);
  if (pair === "id_id") return language(row.body) === "id" && language(row.body_id) === "id";
  if (pair === "en_en") return language(row.body) === "en" && language(row.body_id) === "en";
  if (mixed) return hasEnglishString(row.body_id);
  return JSON.stringify(row.body) === JSON.stringify(row.body_id) && language(row.body) === source;
}).sort((a, b) => a.id.localeCompare(b.id));
if (unique) {
  const seen = new Set();
  rows = rows.filter((row) => { const key = JSON.stringify(row.body_id); if (seen.has(key)) return false; seen.add(key); return true; });
}
rows = rows.slice(offset, offset + limit);
if (!rows.length) process.exit(0);
const target = source === "en" ? "Indonesian" : "English";
const prompt = mixed
  ? `Each JSON payload below is intended for Indonesian learners but contains some remaining English human-facing strings. Translate ONLY those English strings into clear everyday Indonesian; leave existing Indonesian, acronyms, numbers, and established technical terms unchanged. Preserve every key, structure, enum value, and answer relationship. Return ONLY a JSON object with {"translated":[...]} in the same order.\n${JSON.stringify(rows.map((row) => row.body_id))}`
  : pair === "en_en"
  ? `Each JSON payload below is intended for Indonesian learners but still contains English human-facing strings. Translate EVERY remaining English phrase, including values and definitions inside answer objects, option labels, explanations, and nested structures. Translate category labels such as Inflation Hedge, Inflation Risk, Needs, Wants, Savings, and Investments consistently wherever they appear. Preserve only JSON property names that are structural keys, plus established technical acronyms/names such as OJK, BI, IDX, EPS, P/E, ETF, FOMO, KYC, and Bull Market/Bear Market when they are used as named concepts. Preserve every key, structure, enum value, number, and answer relationship. No English sentence or definition should remain. Return ONLY a JSON object with {"translated":[...]} in the same order.\n${JSON.stringify(rows.map((row) => row.body_id))}`
  : `Translate each JSON payload from ${source === "en" ? "English" : "Indonesian"} to natural everyday ${target} for a young financial-literacy audience. Translate EVERY human-facing string recursively, including question, explanation, answer, options, labels, visible object keys, scenario text, and image descriptions. Preserve every JSON key/structure, number, acronym and technical finance term (OJK, BI, ETF, EPS, P/E, CAGR, FOMO, Sharpe). Do not translate enum values of type or difficulty. For matching/categorization objects, translate labels consistently in answer, options, and definitions so references still match. Keep fill-blank answers grammatical in the sentence. Return ONLY {"translated":[...]} in the same order.\n${JSON.stringify(rows.map((row) => row.body))}`;
const response = await fetch("https://api.openai.com/v1/chat/completions", { method: "POST", headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}`, "Content-Type": "application/json" }, body: JSON.stringify({ model: "gpt-4o", temperature: 0, response_format: { type: "json_object" }, messages: [{ role: "system", content: "You are an expert bilingual financial-literacy editor. Use clear everyday Indonesian, not slang. Never omit fields." }, { role: "user", content: prompt }] }) });
const payload = await response.json();
if (payload.error) throw new Error(JSON.stringify(payload.error));
const translated = JSON.parse(payload.choices[0].message.content).translated;
if (!Array.isArray(translated) || translated.length !== rows.length) throw new Error("translation length mismatch");
translated.forEach((value, index) => { restoreEnums(value, rows[index].body); const where = unique ? `body_id = $json$${JSON.stringify(rows[index].body_id)}$json$::jsonb` : `id = '${rows[index].id}'`; console.log(`update public.content_variants set ${targetField} = $json$${JSON.stringify(value)}$json$::jsonb where ${where};`); });
