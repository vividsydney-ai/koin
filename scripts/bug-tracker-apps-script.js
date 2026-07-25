// Copy this code into the bug tracker spreadsheet's Apps Script project
// (Extensions → Apps Script) and run reconcileSheet() after fixes ship.

// This function is invoked from the Apps Script editor, not from Node.
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function reconcileSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('koin-bug-tracker-data.csv');
  if (!sheet) {
    throw new Error('Sheet "koin-bug-tracker-data.csv" not found');
  }

  const data = sheet.getDataRange().getValues();
  if (data.length < 2) return;

  const headers = data[0];
  const statusIdx = headers.indexOf('Status');
  const linearIdIdx = headers.indexOf('Linear Issue ID');

  if (statusIdx === -1) {
    throw new Error('Required column missing: Status');
  }

  const issues = fetchBugSheetIssues();

  for (let i = 1; i < data.length; i++) {
    const sheetRow = i + 1;
    const issue = issues[sheetRow];
    if (!issue) continue;

    const status = issue.state.name === 'Done' ? 'Done' : issue.state.name;
    sheet.getRange(i + 1, statusIdx + 1).setValue(status);

    if (linearIdIdx !== -1 && !data[i][linearIdIdx]) {
      sheet.getRange(i + 1, linearIdIdx + 1).setValue(issue.identifier);
    }
  }
}

function fetchBugSheetIssues() {
  const query = `
    query($filter: IssueFilter) {
      issues(filter: $filter, first: 100) {
        nodes { identifier title state { name } }
      }
    }
  `;

  const variables = {
    filter: {
      team: { key: { eq: 'KO' } },
      title: { contains: '[BUG-SHEET-' },
    },
  };

  const response = UrlFetchApp.fetch('https://api.linear.app/graphql', {
    method: 'POST',
    headers: {
      Authorization: getScriptProperty('LINEAR_API_KEY'),
      'Content-Type': 'application/json',
    },
    payload: JSON.stringify({ query, variables }),
    muteHttpExceptions: true,
  });

  const json = JSON.parse(response.getContentText());
  if (json.errors) {
    console.error('Linear error:', JSON.stringify(json, null, 2));
    throw new Error('Failed to fetch Linear issues');
  }

  const map = {};
  for (const issue of json.data.issues.nodes) {
    const match = issue.title.match(/\[BUG-SHEET-(\d+)\]/);
    if (match) {
      map[parseInt(match[1], 10)] = issue;
    }
  }
  return map;
}
