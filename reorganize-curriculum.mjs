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
  console.log('Analyzing all lessons for reorganization...\n');

  // Get all topics
  const { data: topics } = await supabase
    .from('topics')
    .select('id, slug, name, chapter, display_order')
    .order('display_order');

  // Get all lessons
  const { data: lessons } = await supabase
    .from('lessons')
    .select('*')
    .order('lesson_number', { ascending: true });

  console.log(`Found ${lessons?.length || 0} lessons\n`);

  // Analyze duplicates
  const titleMap = {};
  const duplicates = [];

  lessons.forEach(l => {
    const topic = topics?.find(t => t.id === l.topic_id);
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
        duplicates.push({
          key,
          main: mainTrack,
          foundation: foundationZero,
          action: 'DEACTIVATE_MAIN'
        });
      }
    }
  }

  console.log('=== DUPLICATES FOUND ===\n');
  duplicates.forEach(d => {
    console.log(`Main: #${d.main.lesson_number} "${d.main.title}" (${d.main.is_published ? 'published' : 'unpublished'})`);
    console.log(`  vs Foundation 0: #${d.foundation.lesson_number} "${d.foundation.title}" (${d.foundation.is_published ? 'published' : 'unpublished'})`);
    console.log(`  Action: ${d.action}`);
    console.log();
  });

  // Propose new curriculum structure
  console.log('=== PROPOSED CURRICULUM REORGANIZATION ===\n');

  const newStructure = {
    // Foundation 0 stays as is (lessons 101-112)
    foundationZero: lessons.filter(l => {
      const topic = topics?.find(t => t.id === l.topic_id);
      return topic?.slug === 'foundation_zero';
    }),

    // Chapter 01: Money Basics - truly basic, beginner level, no duplicates with Foundation 0
    chapter01: [],

    // Chapter 02: Money Life Skills
    chapter02: [],

    // Chapter 03: Protect Yourself
    chapter03: [],

    // Chapter 04: Let's Talk About Debt
    chapter04: [],

    // Chapter 05: Plan Your Money
    chapter05: [],

    // Chapter 06: Grow Your Money
    chapter06: [],

    // Chapter 07: Investing in Indonesia
    chapter07: [],

    // Chapter 08: Cryptocurrency 101
    chapter08: [],

    // Advanced/Unpublished lessons - keep unpublished
    advanced: []
  };

  // Categorize lessons
  lessons.forEach(l => {
    const topic = topics?.find(t => t.id === l.topic_id);
    const isFoundationZero = topic?.slug === 'foundation_zero';
    const isDuplicate = duplicates.some(d => d.main.id === l.id);

    if (isFoundationZero) {
      // Foundation 0 stays as is
      return;
    }

    if (isDuplicate) {
      // Mark for deactivation
      l.action = 'DEACTIVATE';
      l.newChapter = 'ARCHIVED';
      return;
    }

    // Categorize by chapter/topic
    const chapter = topic?.chapter;
    switch (chapter) {
      case 'Money Basics':
        newStructure.chapter01.push(l);
        break;
      case 'Money Life Skills':
        newStructure.chapter02.push(l);
        break;
      case 'Protect Yourself':
        newStructure.chapter03.push(l);
        break;
      case "Let's Talk About Debt":
        newStructure.chapter04.push(l);
        break;
      case 'Plan Your Money':
        newStructure.chapter05.push(l);
        break;
      case 'Grow Your Money':
        newStructure.chapter06.push(l);
        break;
      case 'Investing in Indonesia':
        newStructure.chapter07.push(l);
        break;
      case 'Cryptocurrency 101':
        newStructure.chapter08.push(l);
        break;
    }

    // Mark advanced lessons to stay unpublished
    if (l.difficulty === 'advanced' || l.lesson_number >= 45) {
      l.action = 'KEEP_UNPUBLISHED';
    }
  });

  // Print new structure
  const sections = [
    { name: 'Foundation 0', lessons: newStructure.foundationZero },
    { name: 'Chapter 01: Money Basics', lessons: newStructure.chapter01 },
    { name: 'Chapter 02: Money Life Skills', lessons: newStructure.chapter02 },
    { name: 'Chapter 03: Protect Yourself', lessons: newStructure.chapter03 },
    { name: 'Chapter 04: Debt Management', lessons: newStructure.chapter04 },
    { name: 'Chapter 05: Financial Planning', lessons: newStructure.chapter05 },
    { name: 'Chapter 06: Grow Your Money', lessons: newStructure.chapter06 },
    { name: 'Chapter 07: Investing in Indonesia', lessons: newStructure.chapter07 },
    { name: 'Chapter 08: Cryptocurrency', lessons: newStructure.chapter08 },
  ];

  sections.forEach(s => {
    console.log(`${s.name} (${s.lessons.length} lessons):`);
    s.lessons.forEach((l, i) => {
      const action = l.action ? ` [${l.action}]` : '';
      const published = l.is_published ? '✓' : ' ';
      console.log(`  ${published} #${l.lesson_number} ${l.title}${action}`);
    });
    console.log();
  });

  // Generate renumbered CSV
  console.log('\n=== GENERATING NEW CSV ===\n');

  const csvRows = [['lesson_number', 'slug', 'title_en', 'title_id', 'chapter', 'topic_slug', 'difficulty', 'is_published', 'action', 'old_lesson_number']];

  let newNumber = 1;

  // Foundation 0 first (101-112 stay as is)
  newStructure.foundationZero.forEach(l => {
    csvRows.push([
      l.lesson_number,
      l.slug,
      escapeCSV(l.title),
      escapeCSV(l.title_id),
      'Foundation 0',
      'foundation_zero',
      l.difficulty,
      l.is_published,
      'KEEP',
      l.lesson_number
    ]);
  });

  // Then main chapters
  sections.slice(1).forEach(s => {
    s.lessons.sort((a, b) => {
      // Sort by difficulty: beginner, intermediate, advanced
      const diffOrder = { beginner: 1, intermediate: 2, advanced: 3 };
      return (diffOrder[a.difficulty] || 99) - (diffOrder[b.difficulty] || 99);
    });

    s.lessons.forEach(l => {
      const action = l.action || 'KEEP';
      csvRows.push([
        newNumber++,
        l.slug,
        escapeCSV(l.title),
        escapeCSV(l.title_id),
        s.name,
        topics?.find(t => t.id === l.topic_id)?.slug || '',
        l.difficulty,
        l.is_published,
        action,
        l.lesson_number
      ]);
    });
  });

  const csvContent = csvRows.map(r => r.join(',')).join('\n');
  const filename = `reorganized-curriculum-${new Date().toISOString().split('T')[0]}.csv`;
  writeFileSync(filename, csvContent);

  console.log(`✓ Exported reorganized curriculum to ${filename}`);
  console.log(`\nTotal lessons: ${csvRows.length - 1}`);

  // Generate SQL for reorganization
  console.log('\n=== GENERATING MIGRATION SQL ===\n');

  const sqlLines = [
    '-- Migration: Reorganize curriculum structure',
    '-- Deactivate duplicates and renumber lessons',
    '',
  ];

  // Deactivate duplicates
  const toDeactivate = lessons.filter(l => duplicates.some(d => d.main.id === l.id));
  if (toDeactivate.length > 0) {
    sqlLines.push('-- Deactivate main track duplicates (Foundation 0 versions are canonical)');
    toDeactivate.forEach(l => {
      sqlLines.push(`UPDATE lessons SET is_published = false, updated_at = NOW() WHERE id = '${l.id}'; -- #${l.lesson_number} "${l.title}"`);
    });
    sqlLines.push('');
  }

  writeFileSync('reorganize-curriculum.sql', sqlLines.join('\n'));
  console.log('✓ Generated reorganize-curriculum.sql');
  console.log(`  - ${toDeactivate.length} lessons to deactivate`);
}

main().catch(console.error);
