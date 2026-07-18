import { createClient } from '@supabase/supabase-js';
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
const { data: lessons } = await supabase.from('lessons').select('id, slug, lesson_number').eq('is_published', true).order('lesson_number');
const SUPPORTED = ['multiple_choice','true_false','fill_blank','word_bank','ordering','matching','case_study'];
for (const l of lessons) {
  let offset = 0, all = [];
  while (true) {
    const { data } = await supabase.from('content_variants').select('body').eq('lesson_id', l.id).eq('variant_type', 'question').eq('is_active', true).range(offset, offset + 999);
    if (!data || data.length === 0) break;
    all = all.concat(data);
    if (data.length < 1000) break;
    offset += 1000;
  }
  const valid = all.filter(v => SUPPORTED.includes(v.body?.type));
  const types = [...new Set(valid.map(q => q.body?.type))].join(',');
  const flag = valid.length === 0 ? '  <-- FALLBACK (always T/F)' : (valid.length === 1 ? '  <-- ONLY 1 VALID' : '');
  console.log(`${String(l.lesson_number).padStart(2)} | ${l.slug} | total=${all.length} valid=${valid.length} | ${types}${flag}`);
}
