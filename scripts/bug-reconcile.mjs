import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '../.env.local') });

const SHEET_ID = '1mBWTiCIsIWrypqM58QoGah2-mOUseyAG8Jtb0XF-4Bs';
const API_KEY = process.env.GOOGLE_SHEET_API;
const LINEAR_KEY = process.env.LINEAR_API_KEY;

function hasEnv(name) {
  const v = process.env[name];
  return v ? `${name}=SET (${v.length} chars)` : `${name}=MISSING`;
}

async function fetchSheetMeta() {
  const url = `https://sheets.googleapis.com/v4/spreadsheets/${SHEET_ID}?key=${API_KEY}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Sheets meta failed: ${res.status} ${await res.text()}`);
  return res.json();
}

async function fetchSheet(range) {
  const url = `https://sheets.googleapis.com/v4/spreadsheets/${SHEET_ID}/values/${encodeURIComponent(range)}?key=${API_KEY}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Sheets read failed: ${res.status} ${await res.text()}`);
  return res.json();
}

async function linearQuery(query, variables = {}) {
  const res = await fetch('https://api.linear.app/graphql', {
    method: 'POST',
    headers: { Authorization: LINEAR_KEY, 'Content-Type': 'application/json' },
    body: JSON.stringify({ query, variables }),
  });
  if (!res.ok) throw new Error(`Linear HTTP error: ${res.status}`);
  const json = await res.json();
  if (json.errors) throw new Error(`Linear GraphQL error: ${JSON.stringify(json.errors)}`);
  return json.data;
}

async function main() {
  console.log('Credential check:');
  console.log(hasEnv('GOOGLE_SHEET_API'));
  console.log(hasEnv('GOOGLE_OAUTH_SECRET'));
  console.log(hasEnv('GOOGLE_CLIENT_ID'));
  console.log(hasEnv('GOOGLE_REFRESH_TOKEN'));
  console.log(hasEnv('LINEAR_API_KEY'));
  console.log('');

  const meta = await fetchSheetMeta();
  const sheets = meta.sheets.map(s => s.properties.title);
  console.log('Available sheets:', sheets.join(', '));
  const range = sheets[0];
  const data = await fetchSheet(range);
  const rows = data.values || [];
  const headers = rows[0];
  const statusIdx = headers.indexOf('Status');
  const linearIdIdx = headers.indexOf('Linear Issue ID');
  const titleIdx = headers.indexOf('Title');

  console.log(`\nSheet rows:`);
  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    const title = row[titleIdx] || '';
    const status = row[statusIdx] || '';
    const linearId = row[linearIdIdx] || '';
    console.log(`Row ${i + 1}: ${linearId || '(no ID)'} | ${status || '(no status)'} | ${title}`);
  }

  if (!LINEAR_KEY) {
    console.log('\nNo LINEAR_API_KEY; skipping Linear query');
    return;
  }

  const teamRes = await linearQuery(`
    query Issues($filter: IssueFilter) {
      issues(filter: $filter, first: 100) {
        nodes { identifier title state { name } }
      }
    }
  `, { filter: { team: { key: { eq: 'KO' } } } });
  console.log(`\nLinear KO issues (${teamRes.issues.nodes.length}):`);
  for (const issue of teamRes.issues.nodes) {
    console.log(`${issue.identifier}: [${issue.state.name}] ${issue.title}`);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
