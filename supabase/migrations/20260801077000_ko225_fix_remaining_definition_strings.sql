-- KO-225: final visible English definitions/questions in Indonesian payloads.
create or replace function public.ko225_replace_jsonb_strings(value jsonb, replacements jsonb)
returns jsonb language plpgsql immutable as $$
declare item jsonb; key text; new_key text; result jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    if replacements ? (value #>> '{}') then return to_jsonb(replacements ->> (value #>> '{}')); end if;
    return value;
  elsif jsonb_typeof(value) = 'array' then
    result := '[]'::jsonb; for item in select jsonb_array_elements(value) loop result := result || jsonb_build_array(public.ko225_replace_jsonb_strings(item, replacements)); end loop; return result;
  elsif jsonb_typeof(value) = 'object' then
    result := '{}'::jsonb; for key, item in select * from jsonb_each(value) loop new_key := coalesce(replacements ->> key, key); result := result || jsonb_build_object(new_key, public.ko225_replace_jsonb_strings(item, replacements)); end loop; return result;
  end if; return value;
end; $$;
with replacements(value) as (values ('{
  "Net income divided by number of outstanding shares":"Laba bersih dibagi jumlah saham beredar",
  "Net income divided by shareholders'' equity":"Laba bersih dibagi ekuitas pemegang saham",
  "Market price per share divided by earnings per share":"Harga pasar per saham dibagi laba per saham",
  "Annual dividend per share divided by stock price":"Dividen tahunan per saham dibagi harga saham",
  "Sensitivity of a stock''s returns to market movements":"Sensitivitas imbal hasil saham terhadap pergerakan pasar",
  "Excess return relative to a benchmark":"Imbal hasil berlebih dibandingkan tolok ukur",
  "Risk-adjusted return measuring excess return per unit of risk":"Imbal hasil yang disesuaikan dengan risiko, mengukur imbal hasil berlebih per unit risiko",
  "A measure of the dispersion of returns around the mean":"Ukuran penyebaran imbal hasil di sekitar nilai rata-rata",
  "The use of borrowed capital to increase potential returns":"Penggunaan modal pinjaman untuk meningkatkan potensi imbal hasil",
  "The ability to meet long-term financial obligations":"Kemampuan memenuhi kewajiban keuangan jangka panjang",
  "The ease with which an asset can be converted to cash":"Kemudahan mengubah aset menjadi uang tunai",
  "The degree of variation in trading prices over time":"Tingkat perubahan harga perdagangan dari waktu ke waktu",
  "A sudden dramatic decline of 20% or more in stock prices":"Penurunan harga saham yang tiba-tiba dan drastis sebesar 20% atau lebih",
  "Sensitivity of a stock''s returns to market movements":"Sensitivitas imbal hasil saham terhadap pergerakan pasar",
  "Read the following statement and identify the financial mistakes:\n\nI invest based on my horoscope and the advice of a WhatsApp group admin who claims to have insider information. I never read financial statements.":"Baca pernyataan berikut dan identifikasi kesalahan finansial:\n\nSaya berinvestasi berdasarkan ramalan zodiak dan saran admin grup WhatsApp yang mengaku punya informasi orang dalam. Saya tidak pernah membaca laporan keuangan.",
  "Needs":"Kebutuhan", "Wants":"Keinginan", "Savings":"Tabungan", "Investments":"Investasi",
  "over budget":"melebihi anggaran"
}'::jsonb))
update public.content_variants set body_id = public.ko225_replace_jsonb_strings(body_id, replacements.value)
from replacements where is_active = true and body_id is not null;
drop function public.ko225_replace_jsonb_strings(jsonb, jsonb);
