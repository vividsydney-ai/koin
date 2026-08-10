import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(url, key);

async function main() {
  const { data: topics, error: topicsError } = await supabase
    .from('topics')
    .select('id, name, chapter')
    .eq('chapter', 'Grow Your Money');
  if (topicsError) throw topicsError;
  console.log('Topics:', topics);

  const topicIds = topics.map((t) => t.id);
  const { data: lessons, error: lessonsError } = await supabase
    .from('lessons')
    .select('id, title, slug, lesson_number, is_published, topic_id')
    .in('topic_id', topicIds)
    .order('lesson_number');
  if (lessonsError) throw lessonsError;
  console.log('\nLessons:');
  for (const l of lessons) {
    console.log(`  [${l.is_published ? 'PUB' : 'draft'}] #${l.lesson_number} ${l.slug} — ${l.title}`);
  }

  const lessonIds = lessons.map((l) => l.id);
  const { data: visuals, error: visualsError } = await supabase
    .from('lesson_visual_blocks')
    .select('id, lesson_id, block_type, placement, display_order, is_published')
    .in('lesson_id', lessonIds);
  if (visualsError) throw visualsError;
  console.log('\nVisual blocks:', visuals.length);
  for (const l of lessons) {
    const vs = visuals.filter((v) => v.lesson_id === l.id);
    console.log(`  ${l.slug}: ${vs.length} visual block(s)${vs.map((v) => ` [${v.block_type}${v.is_published ? '' : ' UNPUB'}]`).join('')}`);
  }

  const { data: variants, error: variantsError } = await supabase
    .from('content_variants')
    .select('id, lesson_id, variant_type, topic_tag, is_active')
    .in('lesson_id', lessonIds);
  if (variantsError) throw variantsError;
  console.log('\nApplied/visual_applied question coverage:');
  for (const l of lessons) {
    const vs = variants.filter((v) => v.lesson_id === l.id && v.is_active);
    const visualApplied = vs.filter((v) => v.topic_tag === 'visual_applied');
    console.log(`  ${l.slug}: ${vs.length} active variants total, ${visualApplied.length} visual_applied`);
  }

  const { data: sources, error: sourcesError } = await supabase
    .from('content_variants')
    .select('id, lesson_id, variant_type, body')
    .in('lesson_id', lessonIds)
    .eq('variant_type', 'example');
  if (sourcesError) throw sourcesError;
  console.log('\nExample variant source refs:');
  for (const s of sources ?? []) {
    console.log(`  lesson ${s.lesson_id}: source=${JSON.stringify(s.body?.source ?? s.body?.source_ref ?? null)}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
