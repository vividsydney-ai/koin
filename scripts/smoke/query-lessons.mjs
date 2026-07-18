import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(url, key);

async function main() {
  const { data: lesson } = await supabase
    .from('lessons')
    .select('id, title, slug')
    .ilike('title', '%what is money%')
    .eq('is_published', true);
  console.log('Lessons:', lesson);

  const lessonId = lesson?.find((l) => l.slug === 'fz-what-is-money')?.id;
  if (!lessonId) return;

  console.log('\n=== Example variants for fz-what-is-money ===');
  const { data: examples, error } = await supabase
    .from('content_variants')
    .select('id, body, is_active')
    .eq('lesson_id', lessonId)
    .eq('variant_type', 'example');
  if (error) console.error(error.message);
  else {
    console.log('Count:', examples?.length);
    console.log(JSON.stringify(examples?.map((e) => ({ id: e.id, text: e.body?.text?.slice(0, 80), active: e.is_active })), null, 2));
  }
}

main();
