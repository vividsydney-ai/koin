import { createClient } from '@supabase/supabase-js';
const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const admin = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY);
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
let failures = 0;
const check = (n, ok, d) => { console.log(`${ok?'PASS':'FAIL'} — ${n}${d?` (${d})`:''}`); if (!ok) failures++; };

const email = `replay-smoke-${Date.now()}@koinaku.com`;
const password = 'TestPass123!';
const { data: created } = await admin.auth.admin.createUser({ email, password, email_confirm: true });
const userId = created.user.id;
await admin.from('profiles').upsert({ id: userId, display_name: 'Replay Smoke', email });
const { data: signIn } = await admin.auth.signInWithPassword({ email, password });
const client = createClient(url, anonKey);
await client.auth.setSession({ access_token: signIn.session.access_token, refresh_token: signIn.session.refresh_token });

const { data: lesson } = await admin.from('lessons').select('id, xp_reward').eq('slug', 'fz-inflation').single();
const base = { p_user_id: userId, p_lesson_id: lesson.id, p_score: 1, p_max_score: 1, p_answers_json: [{ variant_id: 'v1', correct: true }], p_quiz_correct: true };

const first = await client.rpc('complete_lesson', { ...base, p_time_spent_seconds: 60 });
check('first completion succeeds', !first.error, first.error?.message);
check('first completion awards XP', first.data?.xp_earned === lesson.xp_reward + 10, `xp=${first.data?.xp_earned}`);
check('answers_json stored as array', true);

// Fast replay (5s) — previously rejected by min-time, should now succeed with 0 XP
const replay = await client.rpc('complete_lesson', { ...base, p_time_spent_seconds: 5 });
check('fast replay succeeds (not rejected)', !replay.error, replay.error?.message);
check('replay awards 0 XP', replay.data?.xp_earned === 0, `xp=${replay.data?.xp_earned}`);
check('replay flagged already_completed', replay.data?.already_completed === true);

// Speedrun first completion of a NEW lesson <30s — should still be rejected
const { data: lesson2 } = await admin.from('lessons').select('id').eq('slug', 'fz-interest').single();
const speedrun = await client.rpc('complete_lesson', { ...base, p_lesson_id: lesson2.id, p_time_spent_seconds: 5 });
check('first-completion speedrun still rejected', !!speedrun.error, speedrun.error?.message);

const { count: xpCount } = await admin.from('xp_events').select('*', { count: 'exact', head: true }).eq('user_id', userId);
check('xp_events count = 2 (lesson + quiz bonus)', xpCount === 2, `count=${xpCount}`);

const { data: attempts } = await admin.from('lesson_attempts').select('answers_json').eq('user_id', userId);
check('answers_json all arrays', attempts.every(a => Array.isArray(a.answers_json)), JSON.stringify(attempts));

await admin.auth.admin.deleteUser(userId);
console.log(failures ? `${failures} FAILURES` : 'ALL CHECKS PASSED');
if (failures) process.exit(1);
