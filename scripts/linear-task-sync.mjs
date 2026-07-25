#!/usr/bin/env node
/**
 * Linear task synchronizer.
 *
 * Enforces the Koinaku rule: every implementation task must have a Linear
 * issue before coding starts. Multi-outcome tasks must be atomized into linked
 * child issues.
 *
 * Usage:
 *   node scripts/linear-task-sync.mjs --task-id KO-XXX --title "Parent title" \
 *     --description "..." --children children.json [--state Todo] [--dry-run]
 *
 * children.json:
 *   [
 *     { "title": "[KO-XXX-A] Atomic child", "description": "...", "state": "Todo" },
 *     ...
 *   ]
 *
 * Behavior:
 * - Reads LINEAR_API_KEY from .env.local (never writes it).
 * - Uses Linear team KO.
 * - Searches for existing issues before creating anything.
 * - Creates a parent issue when none exists.
 * - Creates missing atomic children under the parent.
 * - Writes resulting IDs into loop-state.md when present.
 * - Exits non-zero on any failure so loop scripts can block implementation.
 */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { config } from "dotenv";

config({ path: ".env.local" });

const API_URL = "https://api.linear.app/graphql";
const TEAM_KEY = "KO";

const args = process.argv.slice(2);
let dryRun = false;
let taskId = "";
let title = "";
let description = "";
let childrenPath = "";
let defaultState = "Todo";

for (let i = 0; i < args.length; i++) {
  const arg = args[i];
  if (arg === "--dry-run") {
    dryRun = true;
  } else if (arg === "--task-id") {
    taskId = args[++i];
  } else if (arg === "--title") {
    title = args[++i];
  } else if (arg === "--description") {
    description = args[++i];
  } else if (arg === "--children") {
    childrenPath = args[++i];
  } else if (arg === "--state") {
    defaultState = args[++i];
  }
}

function bail(msg) {
  console.error("[linear-task-sync] " + msg);
  process.exit(1);
}

if (!process.env.LINEAR_API_KEY) {
  bail("LINEAR_API_KEY not found in environment. Set it in .env.local.");
}

if (!taskId) bail("--task-id is required.");
if (!title) bail("--title is required.");

let children = [];
if (childrenPath) {
  try {
    children = JSON.parse(readFileSync(childrenPath, "utf8"));
    if (!Array.isArray(children)) bail("--children file must contain a JSON array.");
  } catch (e) {
    bail(`Failed to parse children file: ${e.message}`);
  }
}

const API_KEY = process.env.LINEAR_API_KEY;

async function gql(query, variables = {}) {
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      Authorization: API_KEY,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ query, variables }),
  });
  const json = await res.json();
  if (json.errors) {
    const msgs = json.errors.map((e) => e.message).join("; ");
    throw new Error(`Linear GraphQL error: ${msgs}`);
  }
  return json.data;
}

function escapeGql(str) {
  return String(str).replace(/\\/g, "\\\\").replace(/"/g, '\\"').replace(/\n/g, "\\n");
}

async function loadTeamAndStates() {
  const data = await gql(`query {
    teams(filter: { key: { eq: "${TEAM_KEY}" } }) { nodes { id } }
    workflowStates(filter: { team: { key: { eq: "${TEAM_KEY}" } } }) { nodes { id name } }
  }`);
  const team = data.teams.nodes[0];
  if (!team) bail(`Linear team "${TEAM_KEY}" not found.`);
  const states = Object.fromEntries(data.workflowStates.nodes.map((s) => [s.name, s.id]));
  return { teamId: team.id, states };
}

async function findExistingIssues(teamId, searchTerm) {
  const data = await gql(`query {
    issues(filter: {
      team: { id: { eq: "${teamId}" } },
      title: { contains: "${escapeGql(searchTerm)}" }
    }, first: 50) {
      nodes { id identifier title state { name } parent { id } }
    }
  }`);
  return data.issues.nodes;
}

async function createIssue(input) {
  const fields = [
    `teamId: "${input.teamId}"`,
    `title: "${escapeGql(input.title)}"`,
    `description: "${escapeGql(input.description || "")}"`,
    `stateId: "${input.stateId}"`,
  ];
  if (input.parentId) fields.push(`parentId: "${input.parentId}"`);
  const q = `mutation { issueCreate(input: { ${fields.join(", ")} }) { success issue { id identifier title state { name } } } }`;
  const data = await gql(q);
  return data.issueCreate.issue;
}

async function updateIssueState(issueId, stateId) {
  const q = `mutation { issueUpdate(id: "${issueId}", input: { stateId: "${stateId}" }) { success issue { id identifier state { name } } } }`;
  const data = await gql(q);
  return data.issueUpdate.issue;
}

async function main() {
  const { teamId, states } = await loadTeamAndStates();
  if (!states[defaultState]) bail(`Unknown state "${defaultState}". Available: ${Object.keys(states).join(", ")}`);

  // --- Parent ---
  const searchTerm = taskId;
  const existing = await findExistingIssues(teamId, searchTerm);
  let parent = existing.find((i) => i.title.startsWith(`[${taskId}]`) && !i.parent);

  if (parent) {
    console.log(`[linear-task-sync] Reusing parent ${parent.identifier}: ${parent.title}`);
  } else if (dryRun) {
    console.log(`[linear-task-sync] Would create parent: ${title}`);
  } else {
    parent = await createIssue({
      teamId,
      title,
      description,
      stateId: states[defaultState],
    });
    console.log(`[linear-task-sync] Created parent ${parent.identifier}: ${parent.title}`);
  }

  // --- Children ---
  function extractBracketCode(title) {
    const m = String(title).match(/\[([^\]]+)\]/);
    return m ? `[${m[1]}]` : null;
  }
  function issueNumber(issue) {
    const n = Number(issue.identifier.split("-")[1]);
    return Number.isNaN(n) ? Infinity : n;
  }

  const syncedChildren = [];
  for (const child of children) {
    const childCode = extractBracketCode(child.title);
    if (!childCode) bail(`Child title missing bracketed code: ${child.title}`);

    // Search by the exact atomic code (e.g. [KO-WORKFLOW-001-A]) to avoid false positives.
    const childMatches = existing
      .filter((i) => i.title.includes(childCode))
      .sort((a, b) => issueNumber(a) - issueNumber(b));
    let childIssue = childMatches.find((i) => i.parent?.id === parent?.id) || childMatches[0];
    const childState = child.state || defaultState;
    if (!states[childState]) bail(`Unknown child state "${childState}".`);

    if (childIssue) {
      console.log(`[linear-task-sync] Reusing child ${childIssue.identifier}: ${childIssue.title}`);
    } else if (dryRun) {
      console.log(`[linear-task-sync] Would create child: ${child.title}`);
    } else {
      childIssue = await createIssue({
        teamId,
        title: child.title,
        description: child.description || "",
        stateId: states[childState],
        parentId: parent.id,
      });
      console.log(`[linear-task-sync] Created child ${childIssue.identifier}: ${childIssue.title}`);
    }
    syncedChildren.push(childIssue);
  }

  // --- Update loop-state.md ---
  if (existsSync("loop-state.md") && parent) {
    let stateMd = readFileSync("loop-state.md", "utf8");
    const trackingBlock = `## Linear Tracking
- Linear parent: [${parent.identifier}](https://linear.app/vnsavitri/issue/${parent.identifier}) — ${parent.title}
- Linear children:
${syncedChildren.map((c) => `  - [${c.identifier}](https://linear.app/vnsavitri/issue/${c.identifier}) — ${c.title}`).join("\n")}
- Linear sync status: synced
- Linear synced at: ${new Date().toISOString()}
`;
    if (stateMd.includes("## Linear Tracking")) {
      stateMd = stateMd.replace(/## Linear Tracking[\s\S]*?(?=\n## |$)/, trackingBlock.trim() + "\n");
    } else {
      stateMd = stateMd.replace(
        /(## Current Task\n[\s\S]*?\n)(## Plan Summary)/,
        `$1${trackingBlock}\n$2`
      );
    }
    if (!dryRun) {
      writeFileSync("loop-state.md", stateMd);
      console.log("[linear-task-sync] Updated loop-state.md");
    }
  }

  if (dryRun) {
    console.log("[linear-task-sync] Dry run complete. No Linear mutations made.");
  } else {
    console.log("[linear-task-sync] Sync complete.");
  }
}

main().catch((e) => {
  console.error("[linear-task-sync] Failed:", e.message);
  process.exit(1);
});
