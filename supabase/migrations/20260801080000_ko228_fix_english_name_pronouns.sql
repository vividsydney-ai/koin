-- KO-228: correct English-source pronouns for established feminine names.
-- Indonesian ia/dia remains intentionally gender-neutral.
create or replace function public.ko228_replace_text(value jsonb, replacements jsonb)
returns jsonb language plpgsql immutable as $$
declare item jsonb; key text; result text; rebuilt jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    result := value #>> '{}';
    for key in select jsonb_object_keys(replacements) loop
      result := replace(result, key, replacements ->> key);
    end loop;
    return to_jsonb(result);
  elsif jsonb_typeof(value) = 'array' then
    rebuilt := '[]'::jsonb;
    for item in select jsonb_array_elements(value) loop
      rebuilt := rebuilt || jsonb_build_array(public.ko228_replace_text(item, replacements));
    end loop;
    return rebuilt;
  elsif jsonb_typeof(value) = 'object' then
    rebuilt := '{}'::jsonb;
    for key, item in select * from jsonb_each(value) loop
      rebuilt := rebuilt || jsonb_build_object(key, public.ko228_replace_text(item, replacements));
    end loop;
    return rebuilt;
  end if;
  return value;
end;
$$;

with replacements(value) as (values ('{
  "He only paid":"She only paid", "He had to buy":"She had to buy", "He chose":"She chose",
  "He looked":"She looked", "He decided":"She decided", "He also knows":"She also knows",
  "He didn''t":"She didn''t", "He is interested":"She is interested", "He realized":"She realized",
  "He set":"She set", "He checked":"She checked", "He opened":"She opened",
  "He lost":"She lost", "He bought":"She bought", "He separated":"She separated",
  "he puts":"she puts", "he buys":"she buys", "he had":"she had", "he accepts":"she accepts",
  "he checked":"she checked", "he is":"she is", "he was willing":"she was willing",
  "his goal":"her goal", "his income":"her income"
}'::jsonb))
update public.content_variants
set body = public.ko228_replace_text(body, replacements.value)
from replacements
where id in (
  '09c3cf85-3540-443c-a2b2-098582d21cb5', '0a60f6f6-6364-4531-90ef-7dd80f235544',
  '0be04543-dc6b-4d50-9292-d0250db604eb', '0f782703-54ff-4292-a678-08fa6d7fdf70',
  '19d4e535-fc47-45c7-8e66-898af92cbc59', '2da95141-a69e-4880-8e6d-5760fd9a0968',
  '31059c8c-324c-44e8-83e7-21944bf08e91', '32897b1f-4ca4-44f9-b1ac-10a9351f419d',
  '3ca15970-f57e-4e2a-a4d6-a7728b9bca6a', '4573ae74-7a47-4f9b-a91b-97f193fbb4ba',
  '4ea2cc08-1c72-4bb9-92d3-913466ad4f55', '6e22a1b2-3e5d-486e-a6c1-1a89b52565b1',
  '71a1145d-6074-4bd6-ae20-1f12a9f81430', '7b8fbfdf-6c5c-4745-b9b7-bf7188c68c3b',
  '8cecd791-b370-4bb8-b78d-8be968fdf07f', '98bd93b2-dfe3-4845-b8fc-667d6c4faeb0',
  '9cef2e89-e351-4b5a-98bd-bfe990f2b15e', 'a3d26a22-04a0-4b3c-a4b7-10a9c0c70fae',
  'b8058b41-c540-43a9-ae5b-332592daf77d', 'b867493b-629a-4438-b7cf-e23d154c3e9f',
  'c6e83d79-a1d5-441c-a83d-b4df525a5c1f', 'cd40e584-3c14-42a5-8639-2df128cc33f2',
  'cef629d7-f476-4344-8028-87b6c2bde7ad', 'd1901dce-f7ea-46a0-a57c-24332ba3f87e',
  'd1acd9cd-1c8f-4887-bc94-2824ff284491'
);

drop function public.ko228_replace_text(jsonb, jsonb);
