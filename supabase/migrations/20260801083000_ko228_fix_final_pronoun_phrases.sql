-- KO-228 final context-reviewed phrases discovered by the post-migration audit.
update public.content_variants
set body = jsonb_set(
  jsonb_set(body, '{text}', to_jsonb(replace(body->>'text', 'he immediately paid', 'she immediately paid'))),
  '{text}', to_jsonb(replace(replace(body->>'text', 'he immediately paid', 'she immediately paid'), 'lost his job', 'lost her job'))
)
where id = 'd5833398-ef7b-461b-9137-c8211f138a24';

update public.content_variants
set body = jsonb_set(body, '{text}', to_jsonb(replace(body->>'text', 'lost his job', 'lost her job')))
where id = '98bd93b2-dfe3-4845-b8fc-667d6c4faeb0';
