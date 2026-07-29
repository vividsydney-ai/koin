-- KO-225: final English answer labels in Indonesian quiz variants.
create or replace function public.ko225_replace_jsonb_strings(value jsonb, replacements jsonb)
returns jsonb language plpgsql immutable as $$
declare item jsonb; key text; result jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    if replacements ? (value #>> '{}') then return to_jsonb(replacements ->> (value #>> '{}')); end if;
    return value;
  elsif jsonb_typeof(value) = 'array' then
    result := '[]'::jsonb; for item in select jsonb_array_elements(value) loop result := result || jsonb_build_array(public.ko225_replace_jsonb_strings(item, replacements)); end loop; return result;
  elsif jsonb_typeof(value) = 'object' then
    result := '{}'::jsonb; for key, item in select * from jsonb_each(value) loop result := result || jsonb_build_object(coalesce(replacements ->> key, key), public.ko225_replace_jsonb_strings(item, replacements)); end loop; return result;
  end if; return value;
end; $$;
with replacements(value) as (values ('{
  "Following unqualified advice":"Mengikuti saran dari pihak yang tidak memenuhi syarat",
  "A decline of 10% or more from a recent peak":"Penurunan 10% atau lebih dari puncak terbaru",
  "Kategorisasi yang benar: {\"Needs\": [\"Pembayaran sewa\", \"Belanja kebutuhan pokok\"], \"Wants\": [\"Langganan Netflix\", \"Keanggotaan gym\", \"Sepatu baru\"], \"Savings\": [\"Setoran dana darurat\"], \"Investments\": [\"SIP bulanan\", \"Pembelian saham\"]}":"Kategorisasi yang benar: {\"Kebutuhan\": [\"Pembayaran sewa\", \"Belanja kebutuhan pokok\"], \"Keinginan\": [\"Langganan Netflix\", \"Keanggotaan gym\", \"Sepatu baru\"], \"Tabungan\": [\"Setoran dana darurat\"], \"Investasi\": [\"SIP bulanan\", \"Pembelian saham\"]}"
}'::jsonb))
update public.content_variants set body_id = public.ko225_replace_jsonb_strings(body_id, replacements.value)
from replacements where is_active = true and body_id is not null;
drop function public.ko225_replace_jsonb_strings(jsonb, jsonb);
