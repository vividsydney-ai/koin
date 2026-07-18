import { createClient } from '@supabase/supabase-js';
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
let offset = 0, total = 0, bad = [];
while (true) {
  const { data, error } = await supabase.from('lesson_attempts').select('id, answers_json').range(offset, offset + 999);
  if (error) { console.error(error.message); process.exit(1); }
  if (!data || data.length === 0) break;
  for (const row of data) {
    total++;
    if (row.answers_json !== null && !Array.isArray(row.answers_json)) {
      bad.push({ id: row.id, type: typeof row.answers_json, value: JSON.stringify(row.answers_json).slice(0, 120) });
    }
  }
  if (data.length < 1000) break;
  offset += 1000;
}
console.log('total attempts:', total);
console.log('non-array answers_json:', bad.length);
bad.slice(0, 10).forEach(b => console.log(' -', b.id, b.type, b.value));
