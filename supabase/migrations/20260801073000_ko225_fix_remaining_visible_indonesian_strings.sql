-- KO-225 group 5: replace remaining clearly English, user-visible strings in
-- Indonesian quiz payloads. Technical names/acronyms remain unchanged.
create or replace function public.ko225_replace_jsonb_strings(value jsonb, replacements jsonb)
returns jsonb
language plpgsql
immutable
as $$
declare
  item jsonb;
  key text;
  new_key text;
  result jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    if replacements ? (value #>> '{}') then
      return to_jsonb(replacements ->> (value #>> '{}'));
    end if;
    return value;
  elsif jsonb_typeof(value) = 'array' then
    result := '[]'::jsonb;
    for item in select jsonb_array_elements(value) loop
      result := result || jsonb_build_array(public.ko225_replace_jsonb_strings(item, replacements));
    end loop;
    return result;
  elsif jsonb_typeof(value) = 'object' then
    result := '{}'::jsonb;
    for key, item in select * from jsonb_each(value) loop
      new_key := coalesce(replacements ->> key, key);
      result := result || jsonb_build_object(new_key, public.ko225_replace_jsonb_strings(item, replacements));
    end loop;
    return result;
  end if;
  return value;
end;
$$;

with replacements(value) as (
  values ('{
    "Analyze financial statements":"Menganalisis laporan keuangan",
    "Consider market conditions":"Mempertimbangkan kondisi pasar",
    "Unrealistic return promise":"Janji imbal hasil yang tidak realistis",
    "Secrecy requirement is red flag":"Syarat untuk merahasiakan informasi adalah tanda bahaya",
    "No verification of legitimacy":"Tidak ada verifikasi legalitas",
    "Budget allocation framework":"Kerangka pembagian anggaran",
    "Report to authorities if needed":"Melapor kepada pihak berwenang jika perlu",
    "Social media driven investing":"Investasi yang didorong media sosial",
    "Superstition-based investing":"Investasi berdasarkan takhayul",
    "Adjust spending to meet goals":"Menyesuaikan pengeluaran agar sesuai tujuan",
    "Advanced Investor":"Investor Lanjutan",
    "Uses derivatives, manages risk":"Menggunakan derivatif dan mengelola risiko",
    "Check savings interest rate":"Memeriksa suku bunga tabungan",
    "Review your investment plan":"Meninjau rencana investasi",
    "Concentrated all savings in one stock":"Menempatkan seluruh tabungan pada satu saham",
    "Expected guaranteed high returns in short time":"Mengharapkan imbal hasil tinggi yang dijamin dalam waktu singkat",
    "Using credit for routine purchases without plan":"Menggunakan kredit untuk pembelian rutin tanpa rencana",
    "Accumulating 2.5% monthly interest":"Bunga 2,5% per bulan yang terus bertambah",
    "Inverted needs/wants ratio":"Rasio kebutuhan/keinginan yang terbalik",
    "Emergency fund in volatile asset":"Dana darurat pada aset yang volatil",
    "Ease of converting to cash":"Kemudahan mengubah aset menjadi uang tunai",
    "Price fluctuation magnitude":"Besarnya perubahan harga",
    "Spreading risk across assets":"Menyebarkan risiko ke berbagai aset",
    "High inflation + stagnation":"Inflasi tinggi + stagnasi",
    "A sustained decrease in the general price level":"Penurunan berkelanjutan pada tingkat harga umum",
    "A sustained increase in the general price level of goods and services":"Kenaikan berkelanjutan pada tingkat harga umum barang dan jasa",
    "A period of high inflation combined with economic stagnation":"Periode inflasi tinggi yang disertai stagnasi ekonomi",
    "Extremely rapid and out-of-control price increases":"Kenaikan harga yang sangat cepat dan tidak terkendali",
    "Correct path: OJK license status. This represents the most financially sound decision at this stage.":"Langkah yang benar: memeriksa status izin OJK. Ini adalah keputusan yang paling sehat secara finansial pada tahap ini.",
    "Accumulating 2.5% monthly interest":"Bunga 2,5% per bulan yang terus bertambah",
    "Fear of losses > joy of gains":"Takut rugi > senang mendapat untung",
    "Kata-kata yang benar dari pihak bank adalah : risk, return.":"Kata-kata yang benar dari pihak bank adalah: risiko, imbal hasil.",
    "Kata-kata yang benar dari bank adalah: saving, budgeting.":"Kata-kata yang benar dari bank adalah: menabung, membuat anggaran."
  }'::jsonb)
)
update public.content_variants
set body_id = public.ko225_replace_jsonb_strings(body_id, replacements.value)
from replacements
where is_active = true
  and body_id is not null;

drop function public.ko225_replace_jsonb_strings(jsonb, jsonb);
