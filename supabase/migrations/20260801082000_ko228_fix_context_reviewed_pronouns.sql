-- KO-228 final context-reviewed corrections for the remaining feminine-name examples.
create or replace function public.ko228_replace_context(value jsonb)
returns jsonb language plpgsql immutable as $$
declare item jsonb; key text; old_text text; new_text text; result text; rebuilt jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    result := value #>> '{}';
    for old_text, new_text in select * from (values
      ('he also knows', 'she also knows'),
      ('made him regret', 'made her regret'),
      ('if he still wanted it', 'if she still wanted it'),
      ('he immediately sold', 'she immediately sold'),
      ('adjust his spending', 'adjust her spending'),
      ('sshe could use', 'she could use'),
      ('if he got sick', 'if she got sick'),
      ('helps him stay disciplined', 'helps her stay disciplined'),
      ('As soon as he arrived home', 'As soon as she arrived home'),
      ('Every month he pays', 'Every month she pays')
    ) as replacements(old_text, new_text) loop
      result := replace(result, old_text, new_text);
    end loop;
    return to_jsonb(result);
  elsif jsonb_typeof(value) = 'array' then
    rebuilt := '[]'::jsonb;
    for item in select jsonb_array_elements(value) loop
      rebuilt := rebuilt || jsonb_build_array(public.ko228_replace_context(item));
    end loop;
    return rebuilt;
  elsif jsonb_typeof(value) = 'object' then
    rebuilt := '{}'::jsonb;
    for key, item in select * from jsonb_each(value) loop
      rebuilt := rebuilt || jsonb_build_object(key, public.ko228_replace_context(item));
    end loop;
    return rebuilt;
  end if;
  return value;
end;
$$;

update public.content_variants
set body = public.ko228_replace_context(body)
where id in (
  '4ea2cc08-1c72-4bb9-92d3-913466ad4f55', '71a1145d-6074-4bd6-ae20-1f12a9f81430',
  '7b8fbfdf-6c5c-4745-b9b7-bf7188c68c3b', '8750708a-9e0c-403a-8b64-c22b43b518e6',
  '8cecd791-b370-4bb8-b78d-8be968fdf07f', '98bd93b2-dfe3-4845-b8fc-667d6c4faeb0',
  'cdacbda0-97db-4db2-ba85-0e86c75bc6f0', 'cef629d7-f476-4344-8028-87b6c2bde7ad',
  'd5833398-ef7b-461b-9137-c8211f138a24'
);

drop function public.ko228_replace_context(jsonb);
