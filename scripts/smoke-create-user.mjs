import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!url || !key) {
  console.error('Missing env vars');
  process.exit(1);
}

const supabase = createClient(url, key);

const email = `test-${Date.now()}@koinaku.com`;
const password = 'TestPass123!';

const { data, error } = await supabase.auth.admin.createUser({
  email,
  password,
  email_confirm: true,
  user_metadata: { display_name: 'Smoke Test User' },
});

if (error) {
  console.error('Create user error:', error.message);
  process.exit(1);
}

console.log('Created user:', data.user.id, email);

const { error: profileError } = await supabase
  .from('profiles')
  .upsert({ id: data.user.id, display_name: 'Smoke Test User', email });

if (profileError) {
  console.error('Profile error:', profileError.message);
}

const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
  email,
  password,
});

if (signInError) {
  console.error('Sign in error:', signInError.message);
  process.exit(1);
}

console.log('ACCESS_TOKEN:', signInData.session.access_token);
console.log('REFRESH_TOKEN:', signInData.session.refresh_token);
