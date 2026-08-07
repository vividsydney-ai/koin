import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const admin = createClient(url, serviceKey);

let failures = 0;
function check(name, ok, detail) {
  console.log(`${ok ? 'PASS' : 'FAIL'} — ${name}${detail ? ` (${detail})` : ''}`);
  if (!ok) failures++;
}

async function main() {
  // 1. Fresh test user
  const email = `abuse-smoke-${Date.now()}@koinaku.com`;
  const password = 'TestPass123!';
  const { data: created, error: createErr } = await admin.auth.admin.createUser({
    email, password, email_confirm: true, user_metadata: { display_name: 'Abuse Smoke' },
  });
  if (createErr) throw createErr;
  const userId = created.user.id;
  await admin.from('profiles').upsert({ id: userId, display_name: 'Abuse Smoke', email });

  const { data: signIn, error: signInErr } = await admin.auth.signInWithPassword({ email, password });
  if (signInErr) throw signInErr;
  const client = createClient(url, anonKey);
  await client.auth.setSession({
    access_token: signIn.session.access_token,
    refresh_token: signIn.session.refresh_token,
  });

  // 2. Get a published lesson
  const { data: lesson } = await admin
    .from('lessons').select('id, slug, xp_reward').eq('slug', 'fz-what-is-money').single();
  if (!lesson) throw new Error('lesson not found');

  const args = {
    p_user_id: userId,
    p_lesson_id: lesson.id,
    p_score: 1,
    p_max_score: 1,
    p_answers_json: [],
    p_time_spent_seconds: 60,
    p_quiz_correct: true,
  };

  // 3. First completion → XP awarded
  const first = await client.rpc('complete_lesson', args);
  check('first completion succeeds', !first.error, first.error?.message);
  check(
    'first completion awards lesson XP + quiz bonus',
    first.data?.xp_earned === lesson.xp_reward + 10,
    `xp_earned=${first.data?.xp_earned} expected=${lesson.xp_reward + 10}`
  );
  check('first completion not flagged as replay', first.data?.already_completed === false);

  const { count: xpAfterFirst } = await admin
    .from('xp_events').select('*', { count: 'exact', head: true }).eq('user_id', userId);
  const { data: balAfterFirst } = await admin
    .from('koin_point_balances').select('current_balance').eq('user_id', userId).maybeSingle();

  // 4. Replay same lesson → no new XP/KP
  const replay = await client.rpc('complete_lesson', { ...args, p_time_spent_seconds: 120 });
  check('replay succeeds (no error)', !replay.error, replay.error?.message);
  check('replay awards 0 XP', replay.data?.xp_earned === 0, `xp_earned=${replay.data?.xp_earned}`);
  check('replay flagged already_completed', replay.data?.already_completed === true);

  const { count: xpAfterReplay } = await admin
    .from('xp_events').select('*', { count: 'exact', head: true }).eq('user_id', userId);
  check('xp_events unchanged after replay', xpAfterReplay === xpAfterFirst, `${xpAfterFirst} -> ${xpAfterReplay}`);

  const { data: balAfterReplay } = await admin
    .from('koin_point_balances').select('current_balance').eq('user_id', userId).maybeSingle();
  check(
    'Koin Points unchanged after replay',
    (balAfterReplay?.current_balance ?? 0) === (balAfterFirst?.current_balance ?? 0),
    `${balAfterFirst?.current_balance} -> ${balAfterReplay?.current_balance}`
  );

  // 5. Direct mint attempt → permission denied
  const mint = await client.rpc('award_koin_points', {
    p_user_id: userId, p_amount: 999999, p_source_type: 'reward', p_description: 'hack',
  });
  check('direct award_koin_points is denied', !!mint.error, mint.error?.message);

  const { data: balAfterMint } = await admin
    .from('koin_point_balances').select('current_balance').eq('user_id', userId).maybeSingle();
  check('balance unchanged after mint attempt', (balAfterMint?.current_balance ?? 0) === (balAfterReplay?.current_balance ?? 0));

  // 6. Direct check_in_streak → denied
  const streak = await client.rpc('check_in_streak', { p_user_id: userId });
  check('direct check_in_streak is denied', !!streak.error, streak.error?.message);

  // 7. Speedrun completion → rejected
  const speed = await client.rpc('complete_lesson', { ...args, p_time_spent_seconds: 5 });
  check('sub-30s completion rejected', !!speed.error, speed.error?.message);

  // Cleanup
  await admin.auth.admin.deleteUser(userId);
  console.log('cleanup done');

  if (failures > 0) process.exit(1);
  console.log('ALL CHECKS PASSED');
}

main().catch((e) => { console.error(e); process.exit(1); });
