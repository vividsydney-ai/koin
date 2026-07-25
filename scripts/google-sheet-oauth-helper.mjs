import dotenv from 'dotenv';
import http from 'http';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '../.env.local') });

const CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const CLIENT_SECRET = process.env.GOOGLE_OAUTH_SECRET;
const PORT = 8080;
const REDIRECT_URI = `http://localhost:${PORT}/oauth2callback`;
const SCOPE = 'https://www.googleapis.com/auth/spreadsheets';

function missing(name) {
  console.error(`Missing ${name} in .env.local`);
  process.exit(1);
}

if (!CLIENT_ID) missing('GOOGLE_CLIENT_ID');
if (!CLIENT_SECRET) missing('GOOGLE_OAUTH_SECRET');

function buildAuthUrl() {
  const params = new URLSearchParams({
    client_id: CLIENT_ID,
    redirect_uri: REDIRECT_URI,
    response_type: 'code',
    scope: SCOPE,
    access_type: 'offline',
    include_granted_scopes: 'true',
    prompt: 'consent',
  });
  return `https://accounts.google.com/o/oauth2/v2/auth?${params.toString()}`;
}

async function exchangeCode(code) {
  const body = new URLSearchParams({
    code,
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
    redirect_uri: REDIRECT_URI,
    grant_type: 'authorization_code',
  });
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: body.toString(),
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Token exchange failed: ${res.status} ${text}`);
  }
  return res.json();
}

async function waitForCode() {
  return new Promise((resolve, reject) => {
    const server = http.createServer(async (req, res) => {
      const url = new URL(req.url, `http://localhost:${PORT}`);
      if (url.pathname !== '/oauth2callback') {
        res.writeHead(404);
        res.end('Not found');
        return;
      }
      const code = url.searchParams.get('code');
      const error = url.searchParams.get('error');
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      if (error) {
        res.end(`Authorization error: ${error}`);
        server.close();
        reject(new Error(`OAuth error: ${error}`));
        return;
      }
      if (!code) {
        res.end('No code received');
        server.close();
        reject(new Error('No authorization code received'));
        return;
      }
      res.end('Authorization successful. You can close this tab.');
      server.close();
      resolve(code);
    });
    server.listen(PORT, () => {
      console.log(`\nWaiting for authorization on ${REDIRECT_URI}`);
      console.log(`Open this URL in your browser:\n${buildAuthUrl()}\n`);
    });
    server.on('error', reject);
  });
}

async function main() {
  const code = await waitForCode();
  const tokens = await exchangeCode(code);
  console.log('\nAdd this line to .env.local:');
  console.log(`GOOGLE_REFRESH_TOKEN=${tokens.refresh_token}`);
  if (tokens.access_token) {
    console.log('\nAccess token (valid for ~1 hour):');
    console.log(tokens.access_token);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
