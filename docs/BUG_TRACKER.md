# Koin Bug Tracker — Google Sheets ↔ Linear sync

**Goal:** Every new bug row added to the [Google Sheet bug tracker](https://docs.google.com/spreadsheets/d/1mBWTiCIsIWrypqM58QoGah2-mOUseyAG8Jtb0XF-4Bs/edit?usp=sharing) is automatically created as a Linear issue in a separate **Koin Bugs** project, so bugs do not mix with dev-task issues.

## Linear setup (already done)

- **Team:** `KO`
- **Project:** `Koin Bugs` — id `97d59b53-c6d1-41aa-9663-ccd7e704e974`
- **Label:** `Bug` — id `f61583a9-2410-4a92-961e-a70ffbc4c3b2`

## Existing bugs already imported

| Sheet row | Title | Linear issue |
|---|---|---|
| 2 | Sign-up confirmation email is not sent after registration | **KO-37** |
| 3 | Home page hero text overlaps on iPhone SE screen | **KO-38** |
| 4 | Bottom navigation does not highlight active page on mobile | **KO-39** |
| 5 | Paper trading page takes 4+ seconds to load on 3G connection | **KO-40** |
| 6 | Profile page is missing 'Edit Profile' button | **KO-41** |

Paste these IDs into the `Linear Issue ID` column in the sheet so future sync runs skip them.

## Google Apps Script setup

1. Open the bug tracker spreadsheet.
2. Go to **Extensions → Apps Script**.
3. Replace the default `Code.gs` contents with the script below.
4. Open **Project Settings** (gear icon) → **Script Properties** → **Add script property**:
   - `LINEAR_API_KEY` — your Linear API key
   - `LINEAR_TEAM_ID` — `a122d5d1-0b49-45b1-ac13-50e0939054cf`
   - `LINEAR_PROJECT_ID` — `97d59b53-c6d1-41aa-9663-ccd7e704e974`
   - `LINEAR_BUG_LABEL_ID` — `f61583a9-2410-4a92-961e-a70ffbc4c3b2`
5. Save the project.
6. Run `processSheet()` once manually and authorize the script when prompted.
7. Add a time-driven trigger:
   - Click the **clock icon** (Triggers) → **+ Add Trigger**
   - Function: `processSheet`
   - Deployment: Head
   - Event source: Time-driven
   - Type: Minutes timer / Every 5 minutes (or every hour)

## Apps Script code

```javascript
const SHEET_NAME = "Sheet1"; // change if your tab has a different name

function getScriptProperty(key) {
  return PropertiesService.getScriptProperties().getProperty(key);
}

function linearPriority(sheetPriority) {
  // Linear: 1 = urgent, 2 = high, 3 = medium, 4 = low
  const map = {
    "P0 Critical": 1,
    "P1 High": 2,
    "P2 Medium": 3,
    "P3 Low": 4,
  };
  return map[sheetPriority] || null;
}

function createLinearIssue(title, description, priority) {
  const query = `
    mutation CreateBug($teamId: String!, $projectId: String, $title: String!, $description: String, $labelIds: [String!], $priority: Int) {
      issueCreate(input: { teamId: $teamId, projectId: $projectId, title: $title, description: $description, labelIds: $labelIds, priority: $priority }) {
        success
        issue { identifier id }
      }
    }
  `;

  const variables = {
    teamId: getScriptProperty("LINEAR_TEAM_ID"),
    projectId: getScriptProperty("LINEAR_PROJECT_ID"),
    title: title,
    description: description,
    labelIds: [getScriptProperty("LINEAR_BUG_LABEL_ID")],
  };

  const p = linearPriority(priority);
  if (p) variables.priority = p;

  const response = UrlFetchApp.fetch("https://api.linear.app/graphql", {
    method: "POST",
    headers: {
      Authorization: getScriptProperty("LINEAR_API_KEY"),
      "Content-Type": "application/json",
    },
    payload: JSON.stringify({ query, variables }),
    muteHttpExceptions: true,
  });

  const json = JSON.parse(response.getContentText());
  if (!json.data?.issueCreate?.success) {
    console.error("Linear error:", JSON.stringify(json, null, 2));
    throw new Error("Failed to create Linear issue: " + title);
  }
  return json.data.issueCreate.issue;
}

function buildDescription(row, headers) {
  const get = (label) => row[headers.indexOf(label)] || "";
  return [
    `**Priority:** ${get("Priority")}`,
    `**Type:** ${get("Type")}`,
    `**Module:** ${get("Module")}`,
    `**Status:** ${get("Status")}`,
    `**Browser / Device:** ${get("Browser / Device")}`,
    `**URL:** ${get("URL")}`,
    `**Date Reported:** ${get("Date Reported")}`,
    "",
    "**Description:**",
    get("Description"),
    "",
    "**Steps to Reproduce:**",
    get("Steps to Reproduce"),
    "",
    "**Expected Result:**",
    get("Expected Result"),
    "",
    "**Actual Result:**",
    get("Actual Result"),
  ].join("\n");
}

function processSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(SHEET_NAME);
  if (!sheet) {
    throw new Error(`Sheet "${SHEET_NAME}" not found`);
  }

  const data = sheet.getDataRange().getValues();
  if (data.length < 2) return;

  const headers = data[0];
  const titleIdx = headers.indexOf("Title");
  const priorityIdx = headers.indexOf("Priority");
  const linearIdIdx = headers.indexOf("Linear Issue ID");

  if (titleIdx === -1 || priorityIdx === -1 || linearIdIdx === -1) {
    throw new Error("Required columns missing: Title, Priority, Linear Issue ID");
  }

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const title = row[titleIdx];
    const existingId = row[linearIdIdx];

    if (!title || existingId) continue;

    const description = buildDescription(row, headers);
    const issue = createLinearIssue(title, description, row[priorityIdx]);
    sheet.getRange(i + 1, linearIdIdx + 1).setValue(issue.identifier);
    console.log(`Created ${issue.identifier}: ${title}`);
  }
}
```

## How it works

- The script scans every row in the configured sheet.
- If a row has a `Title` but no `Linear Issue ID`, it creates a Linear issue in the **Koin Bugs** project with the `Bug` label.
- It writes the new Linear identifier back into the `Linear Issue ID` column.
- Re-runs are idempotent: rows that already have a Linear ID are skipped.

## Changing the sheet tab name

If the bug list lives on a tab other than `Sheet1`, update `const SHEET_NAME = "Sheet1";` at the top of the script.

## Security note

The Linear API key is stored in **Script Properties**, not in the sheet or the script source. Do not commit the key to the repo.
