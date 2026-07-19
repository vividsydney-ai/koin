import { createServerClient } from '@supabase/ssr';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const email = process.env.QA_EMAIL;
const password = process.env.QA_PASS;

let captured = [];
const client = createServerClient(url, anon, {
  cookies: {
    getAll: () => [],
    setAll: (cookiesToSet) => {
      captured = cookiesToSet;
    },
  },
});

const { data, error } = await client.auth.signInWithPassword({ email, password });
if (error) {
  console.log(JSON.stringify({ error: error.message, cookies: [] }));
} else {
  console.log(JSON.stringify({ userId: data.user.id, cookies: captured }));
}
