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
  console.log('Exporting reorganized curriculum...\n');

  // Get all topics
  const { data: topicsData, error: topicsError } = await supabase
    .from('topics')
    .select('id, slug, name, chapter, display_order')
    .order('display_order');

  if (topicsError) {
    console.error('Topics error:', topicsError);
    return;
  }

  const topics = topicsData || [];

  // Get all lessons
  const { data: lessonsData, error: lessonsError } = await supabase
    .from('lessons')
    .select('*')
    .order('lesson_number', { ascending: true });

  if (lessonsError) {
    console.error('Lessons error:', lessonsError);
    return;
  }

  const lessons = lessonsData || [];
  console.log(`Found ${lessons.length} lessons and ${topics.length} topics\n`);

  // Identify duplicates (main track vs Foundation 0)
  const titleMap = {};
  const duplicateIds = new Set();

  lessons.forEach(l => {
    const topic = topics.find(t => t.id === l.topic_id);
    const isFoundationZero = topic?.slug === 'foundation_zero';
    const key = l.title.toLowerCase().replace(/\([^)]*\)/g, '').replace(/[^a-z0-9]/g, '').trim();

    if (!titleMap[key]) {
      titleMap[key] = [];
    }
    titleMap[key].push({ ...l, topic, isFoundationZero });
  });

  for (const [key, ls] of Object.entries(titleMap)) {
    if (ls.length > 1) {
      const mainTrack = ls.find(l => !l.isFoundationZero);
      const foundationZero = ls.find(l => l.isFoundationZero);

      if (mainTrack && foundationZero) {
        duplicateIds.add(mainTrack.id);
      }
    }
  }

  // Define new chapter structure
  const chapterConfig = [
    { name: 'Foundation 0', slugs: ['foundation_zero'], orderStart: 0 },
    { name: 'Chapter 01: Money Basics', slugs: ['money_basics', 'value_purchasing_power', 'inflation', 'risk_basics', 'time_value_money'], orderStart: 100 },
    { name: 'Chapter 02: Money Life Skills', slugs: ['budgeting', 'saving_habits', 'spending_behavior', 'behavioral_finance'], orderStart: 200 },
    { name: 'Chapter 03: Protect Yourself', slugs: ['scam_defense', 'ojk_license_check', 'phishing_social_engineering', 'mlm_pyramid'], orderStart: 300 },
    { name: 'Chapter 04: Debt Management', slugs: ['debt_management'], orderStart: 400 },
    { name: 'Chapter 05: Financial Planning', slugs: ['emergency_fund', 'goal_setting', 'financial_planning'], orderStart: 500 },
    { name: 'Chapter 06: Grow Your Money', slugs: ['interest', 'compound_interest', 'bank_vs_investment', 'risk_return', 'diversification', 'reksa_dana'], orderStart: 600 },
    { name: 'Chapter 07: Investing in Indonesia', slugs: ['stocks', 'idx_basics', 'stock_analysis', 'portfolio', 'taxes', 'macro_indicators'], orderStart: 700 },
    { name: 'Chapter 08: Cryptocurrency', slugs: ['cryptocurrency'], orderStart: 800 },
  ];

  // Categorize lessons
  const categorized = [];

  lessons.forEach(l => {
    const topic = topics.find(t => t.id === l.topic_id);
    const isDuplicate = duplicateIds.has(l.id);
    const isFoundationZero = topic?.slug === 'foundation_zero';

    // Determine chapter
    let chapter = 'Uncategorized';
    let lessonOrder = 999;

    if (isFoundationZero) {
      chapter = 'Foundation 0';
      lessonOrder = l.lesson_number; // Keep 101-112
    } else if (topic) {
      for (const config of chapterConfig) {
        if (config.slugs.includes(topic.slug)) {
          chapter = config.name;
          lessonOrder = config.orderStart;
          break;
        }
      }
    }

    // Determine action
    let action = 'KEEP';
    let published = l.is_published;

    if (isDuplicate) {
      action = 'DEACTIVATE (duplicate)';
      published = false;
    } else if (!isFoundationZero && (l.difficulty === 'advanced' || l.lesson_number >= 45)) {
      // Only mark as unpublished if it's NOT Foundation 0
      action = 'KEEP_UNPUBLISHED (advanced)';
      published = false;
    }

    categorized.push({
      ...l,
      chapter,
      lessonOrder,
      action,
      published,
      isDuplicate,
      topic
    });
  });

  // Sort by chapter and lesson_order
  categorized.sort((a, b) => {
    const chapterOrder = [
      'Foundation 0',
      'Chapter 01: Money Basics',
      'Chapter 02: Money Life Skills',
      'Chapter 03: Protect Yourself',
      'Chapter 04: Debt Management',
      'Chapter 05: Financial Planning',
      'Chapter 06: Grow Your Money',
      'Chapter 07: Investing in Indonesia',
      'Chapter 08: Cryptocurrency',
      'Uncategorized'
    ];
    const aIdx = chapterOrder.indexOf(a.chapter);
    const bIdx = chapterOrder.indexOf(b.chapter);
    if (aIdx !== bIdx) return aIdx - bIdx;
    return a.lessonOrder - b.lessonOrder;
  });

  // Generate CSV
  const csvRows = [
    [
      'new_order',
      'old_lesson_number',
      'slug',
      'title_en',
      'title_id',
      'chapter',
      'topic_slug',
      'topic_name',
      'difficulty',
      'is_published',
      'action',
      'is_duplicate',
      'xp_reward',
      'estimated_minutes',
      'summary_en',
      'summary_id'
    ]
  ];

  let order = 1;
  categorized.forEach(l => {
    const topic = l.topic;

    csvRows.push([
      order++,
      l.lesson_number,
      l.slug,
      escapeCSV(l.title),
      escapeCSV(l.title_id),
      l.chapter,
      topic?.slug || '',
      escapeCSV(topic?.name || ''),
      l.difficulty,
      l.published,
      l.action,
      l.isDuplicate,
      l.xp_reward,
      l.estimated_minutes,
      escapeCSV(l.summary || ''),
      escapeCSV(l.summary_id || '')
    ]);
  });

  const csvContent = csvRows.map(r => r.join(',')).join('\n');
  const filename = `reorganized-curriculum-FINAL-${new Date().toISOString().split('T')[0]}.csv`;
  writeFileSync(filename, csvContent);

  console.log(`✓ Exported reorganized curriculum to ${filename}`);
  console.log(`\nTotal lessons: ${categorized.length}`);
  console.log(`\nBreakdown by chapter:`);

  const byChapter = {};
  categorized.forEach(l => {
    if (!byChapter[l.chapter]) byChapter[l.chapter] = { total: 0, published: 0, deactivated: 0 };
    byChapter[l.chapter].total++;
    if (l.published) byChapter[l.chapter].published++;
    if (l.isDuplicate) byChapter[l.chapter].deactivated++;
  });

  for (const [chapter, counts] of Object.entries(byChapter).sort()) {
    console.log(`  ${chapter.padEnd(35)} ${counts.total} total, ${counts.published} published, ${counts.deactivated} deactivated`);
  }

  console.log(`\n=== DUPLICATES TO DEACTIVATE (5) ===`);
  categorized.filter(l => l.isDuplicate).forEach(l => {
    console.log(`  #${l.lesson_number} "${l.title}" (${l.topic?.slug})`);
  });

  console.log(`\n=== MIGRATION READY ===`);
  console.log(`File: supabase/migrations/20260725200000_reorganize_curriculum.sql`);
  console.log(`\nTo apply:`);
  console.log(`  supabase db push`);
}

main().catch(console.error);
