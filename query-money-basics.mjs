import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config({ path: '.env.local' });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
  // Get all topics with their chapter field
  const { data: topics, error: topicsError } = await supabase
    .from('topics')
    .select('id, slug, name, chapter, display_order')
    .order('display_order', { ascending: true });

  if (topicsError) {
    console.error('Topics error:', topicsError.message);
    return;
  }

  // Find topics in "Money Basics" chapter
  const moneyBasicsTopics = topics.filter(t => t.chapter === 'Money Basics');

  console.log(`Topics in "Money Basics" chapter (${moneyBasicsTopics.length}):\n`);

  // Get all lessons for these topics
  const topicIds = moneyBasicsTopics.map(t => t.id);

  const { data: lessons, error: lessonsError } = await supabase
    .from('lessons')
    .select('id, lesson_number, slug, title, title_id, difficulty, is_published, topic_id')
    .in('topic_id', topicIds)
    .order('lesson_number', { ascending: true });

  if (lessonsError) {
    console.error('Lessons error:', lessonsError.message);
    return;
  }

  console.log(`Lessons in "Money Basics" (${lessons.length}):\n`);

  lessons.forEach((l, i) => {
    const status = l.is_published ? '✓' : ' ';
    const topic = moneyBasicsTopics.find(t => t.id === l.topic_id);
    console.log(`${status} #${String(l.lesson_number).padStart(2)} [${l.difficulty.padEnd(12)}] ${l.title}`);
    console.log(`       ${l.title_id}`);
    console.log(`       Topic: ${topic?.slug}`);
  });

  // Check for potential duplicates by title similarity
  console.log('\n--- Potential Duplicates ---\n');

  const titleMap = {};
  lessons.forEach(l => {
    const key = l.title.toLowerCase().replace(/[^a-z0-9]/g, '');
    if (!titleMap[key]) titleMap[key] = [];
    titleMap[key].push(l);
  });

  for (const [key, ls] of Object.entries(titleMap)) {
    if (ls.length > 1) {
      console.log(`DUPLICATE KEY: "${key}"`);
      ls.forEach(l => console.log(`  - #${l.lesson_number}: ${l.title}`));
      console.log();
    }
  }
}

main().catch(console.error);
