-- KO-228 follow-up: finish context-reviewed English pronoun corrections.
-- Do not translate Indonesian ia/dia, or change pronouns belonging to a named friend.
create or replace function public.ko228_replace_remaining(value jsonb)
returns jsonb language plpgsql immutable as $$
declare item jsonb; key text; old_text text; new_text text; result text; rebuilt jsonb;
begin
  if jsonb_typeof(value) = 'string' then
    result := value #>> '{}';
    for old_text, new_text in select * from (values
      ('Sshe checked', 'She checked'),
      ('he just registered', 'she just registered'),
      ('He is targeting', 'She is targeting'),
      ('He closed', 'She closed'),
      ('He switched', 'She switched'),
      ('he can', 'she can'),
      ('his money', 'her money'),
      ('his budget', 'her budget'),
      ('his salary', 'her salary'),
      ('his skincare', 'her skincare'),
      ('He used', 'She used'),
      ('his savings', 'her savings'),
      ('he auto-debits', 'she auto-debits'),
      ('he could use', 'she could use'),
      ('he could', 'she could'),
      ('He had', 'She had'),
      ('He realized', 'She realized'),
      ('his loan', 'her loan'),
      ('He records', 'She records'),
      ('he received', 'she received'),
      ('him more value', 'her more value'),
      ('he was afraid', 'she was afraid'),
      ('Loss aversion makes him overreact', 'Loss aversion makes her overreact')
    ) as replacements(old_text, new_text) loop
      result := replace(result, old_text, new_text);
    end loop;
    return to_jsonb(result);
  elsif jsonb_typeof(value) = 'array' then
    rebuilt := '[]'::jsonb;
    for item in select jsonb_array_elements(value) loop
      rebuilt := rebuilt || jsonb_build_array(public.ko228_replace_remaining(item));
    end loop;
    return rebuilt;
  elsif jsonb_typeof(value) = 'object' then
    rebuilt := '{}'::jsonb;
    for key, item in select * from jsonb_each(value) loop
      rebuilt := rebuilt || jsonb_build_object(key, public.ko228_replace_remaining(item));
    end loop;
    return rebuilt;
  end if;
  return value;
end;
$$;

update public.content_variants
set body = public.ko228_replace_remaining(body)
where id in (
  '0f782703-54ff-4292-a678-08fa6d7fdf70', '2da95141-a69e-4880-8e6d-5760fd9a0968',
  '7b8fbfdf-6c5c-4745-b9b7-bf7188c68c3b', '8cecd791-b370-4bb8-b78d-8be968fdf07f',
  '9cef2e89-e351-4b5a-98bd-bfe990f2b15e', 'b867493b-629a-4438-b7cf-e23d154c3e9f',
  'c6e83d79-a1d5-441c-a83d-b4df525a5c1f', 'd5833398-ef7b-461b-9137-c8211f138a24',
  '4ea2cc08-1c72-4bb9-92d3-913466ad4f55', '19d4e535-fc47-45c7-8e66-898af92cbc59',
  'a3d26a22-04a0-4b3c-a4b7-10a9c0c70fae', 'd1acd9cd-1c8f-4887-bc94-2824ff284491',
  '71a1145d-6074-4bd6-ae20-1f12a9f81430', 'cdacbda0-97db-4db2-ba85-0e86c75bc6f0',
  '8d394cf1-151c-4579-aae8-8e4de3640489', '44b16109-6165-47ac-aa56-490486f96d10',
  'b8058b41-c540-43a9-ae5b-332592daf77d', '31059c8c-324c-44e8-83e7-21944bf08e91',
  '8750708a-9e0c-403a-8b64-c22b43b518e6', '98bd93b2-dfe3-4845-b8fc-667d6c4faeb0'
);

drop function public.ko228_replace_remaining(jsonb);
