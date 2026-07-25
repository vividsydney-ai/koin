import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { writeFileSync } from 'fs';

dotenv.config({ path: '.env.local' });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

function escapeCSV(str) {
  if (!str) return '';
  str = String(str);
  if (str.includes(',') || str.includes('"') || str.includes('\n')) {
    return '"' + str.replace(/"/g, '""') + '"';
  }
  return str;
}

async function main() {
  console.log('Querying all lessons...\n');

  // Get all topics
  const { data: topics, error: topicsError } = await supabase
    .from('topics')
    .select('id, slug, name, name_id, chapter, display_order')
    .order('display_order');

  if (topicsError) console.error('Topics error:', topicsError.message);

  // Get all lessons
  const { data: lessons, error: lessonsError } = await supabase
    .from('lessons')
    .select('*')
    .order('lesson_number', { ascending: true });

  if (lessonsError) console.error('Lessons error:', lessonsError.message);

  console.log(`Found ${topics?.length || 0} topics and ${lessons?.length || 0} lessons\n`);

  // Get content variants count per lesson
  const { data: variants } = await supabase
    .from('content_variants')
    .select('lesson_id, variant_type, is_active');

  // Get lesson sources
  const { data: lessonSources } = await supabase
    .from('lesson_sources')
    .select('lesson_id, source_id, is_primary');

  // Get sources
  const { data: sources } = await supabase
    .from('sources')
    .select('id, source_code, title, url');

  const sourcesById = {};
  (sources || []).forEach(s => sourcesById[s.id] = s);

  // Build variant counts
  const variantCounts = {};
  (variants || []).forEach(v => {
    if (!v.is_active) return;
    if (!variantCounts[v.lesson_id]) {
      variantCounts[v.lesson_id] = { example: 0, question: 0, explanation: 0 };
    }
    variantCounts[v.lesson_id][v.variant_type]++;
  });

  // Build source map
  const sourceMap = {};
  (lessonSources || []).forEach(ls => {
    if (!sourceMap[ls.lesson_id]) sourceMap[ls.lesson_id] = [];
    const src = sourcesById[ls.source_id];
    if (src) {
      sourceMap[ls.lesson_id].push({
        code: src.source_code,
        title: src.title,
        url: src.url,
        is_primary: ls.is_primary
      });
    }
  });

  // Build CSV
  const headers = [
    'lesson_number',
    'slug',
    'title_en',
    'title_id',
    'chapter',
    'topic_slug',
    'topic_name',
    'difficulty',
    'is_published',
    'xp_reward',
    'estimated_minutes',
    'summary_en',
    'summary_id',
    'concept_body_en',
    'concept_body_id',
    'indonesian_example_en',
    'indonesian_example_id',
    'example_variants',
    'question_variants',
    'explanation_variants',
    'sources',
    'prerequisite_slug',
    'created_at'
  ];

  const rows = [headers.join(',')];

  for (const lesson of lessons || []) {
    const topic = topics?.find(t => t.id === lesson.topic_id);
    const prerequisite = lessons?.find(l => l.id === lesson.prerequisite_lesson_id);
    const vCounts = variantCounts[lesson.id] || { example: 0, question: 0, explanation: 0 };
    const sources = sourceMap[lesson.id] || [];

    const sourcesStr = sources.map(s =>
      `${s.code}: ${s.title} (${s.url})${s.is_primary ? ' [PRIMARY]' : ''}`
    ).join(' | ');

    const row = [
      lesson.lesson_number,
      escapeCSV(lesson.slug),
      escapeCSV(lesson.title),
      escapeCSV(lesson.title_id),
      escapeCSV(topic?.chapter || ''),
      escapeCSV(topic?.slug || ''),
      escapeCSV(topic?.name || ''),
      lesson.difficulty,
      lesson.is_published,
      lesson.xp_reward,
      lesson.estimated_minutes,
      escapeCSV(lesson.summary || ''),
      escapeCSV(lesson.summary_id || ''),
      escapeCSV((lesson.concept_body || '').substring(0, 500)),
      escapeCSV((lesson.concept_body_id || '').substring(0, 500)),
      escapeCSV((lesson.indonesian_example || '').substring(0, 500)),
      escapeCSV((lesson.indonesian_example_id || '').substring(0, 500)),
      vCounts.example,
      vCounts.question,
      vCounts.explanation,
      escapeCSV(sourcesStr),
      escapeCSV(prerequisite?.slug || ''),
      lesson.created_at
    ];

    rows.push(row.join(','));
  }

  const csvContent = rows.join('\n');
  const filename = `all-lessons-${new Date().toISOString().split('T')[0]}.csv`;
  writeFileSync(filename, csvContent);

  console.log(`✓ Exported ${lessons?.length || 0} lessons to ${filename}`);
  console.log(`\nFile columns: ${headers.length}`);
  console.log(`\nBreakdown by chapter:`);

  const byChapter = {};
  for (const lesson of lessons || []) {
    const topic = topics?.find(t => t.id === lesson.topic_id);
    const chapter = topic?.chapter || '(no chapter)';
    if (!byChapter[chapter]) byChapter[chapter] = 0;
    byChapter[chapter]++;
  }

  for (const [chapter, count] of Object.entries(byChapter).sort()) {
    console.log(`  ${chapter.padEnd(30)} ${count} lessons`);
  }

  console.log(`\nBreakdown by topic:`);
  const byTopic = {};
  for (const lesson of lessons || []) {
    const topic = topics?.find(t => t.id === lesson.topic_id);
    const topicName = topic?.slug || 'unknown';
    if (!byTopic[topicName]) byTopic[topicName] = 0;
    byTopic[topicName]++;
  }

  for (const [topic, count] of Object.entries(byTopic).sort()) {
    console.log(`  ${topic.padEnd(35)} ${count} lessons`);
  }
}

main().catch(console.error);
