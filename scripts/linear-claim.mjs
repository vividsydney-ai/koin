#!/usr/bin/env node
/**
 * Linear cross-agent claim helper.
 *
 * Lets Codex, Claude, Qwen, Kimi, and human agents show who is currently
 * working on a Linear issue, so other agents (and humans) can see it in the
 * Linear UI without opening the issue.
 *
 * Conventions:
 * - One live-agent label per issue: agent:codex | agent:claude | agent:qwen |
 *   agent:kimi | agent:human | agent:unassigned
 * - One original-author label per issue: author:codex | author:claude |
 *   author:qwen | author:kimi | author:human
 * - First claim sets both agent:<name> and author:<name>.
 * - Later claims (corrections) keep author:<name> and update agent:<name>.
 * - Releasing keeps both labels as historical ownership (done tickets).
 *   Use --unassign to mark an open issue as unclaimed / up for grabs.
 *
 * Usage:
 *   node scripts/linear-claim.mjs setup
 *   node scripts/linear-claim.mjs status --issue KO-42
 *   node scripts/linear-claim.mjs claim --issue KO-42 --agent codex
 *   node scripts/linear-claim.mjs release --issue KO-42 --agent codex
 *   node scripts/linear-claim.mjs release --issue KO-42 --agent codex --unassign
 *   node scripts/linear-claim.mjs claim --issue KO-42 --agent claude --steal
 */

import { config } from "dotenv";
import { existsSync, readFileSync } from "node:fs";

config({ path: ".env.local" });

const API_URL = "https://api.linear.app/graphql";
const TEAM_KEY = "KO";

const AGENTS = ["codex", "claude", "qwen", "kimi", "human", "unassigned"];
const AUTHORS = ["codex", "claude", "qwen", "kimi", "human"];
const AGENT_LABEL_PREFIX = "agent:";
const AUTHOR_LABEL_PREFIX = "author:";

const args = process.argv.slice(2);
const command = args[0] || "";
let dryRun = false;
let issueIdentifier = "";
let agentName = "";
let shouldSteal = false;
let shouldUnassign = false;
let newState = "";

for (let i = 1; i < args.length; i++) {
  const arg = args[i];
  if (arg === "--dry-run") {
    dryRun = true;
  } else if (arg === "--issue") {
    issueIdentifier = args[++i];
  } else if (arg === "--agent") {
    agentName = args[++i];
  } else if (arg === "--steal") {
    shouldSteal = true;
  } else if (arg === "--unassign") {
    shouldUnassign = true;
  } else if (arg === "--state") {
    newState = args[++i];
  }
}

function bail(msg) {
  console.error("[linear-claim] " + msg);
  process.exit(1);
}

if (!process.env.LINEAR_API_KEY) {
  bail("LINEAR_API_KEY not found. Set it in .env.local.");
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

async function loadTeam() {
  const data = await gql(`query {
    teams(filter: { key: { eq: "${TEAM_KEY}" } }) { nodes { id } }
  }`);
  const team = data.teams.nodes[0];
  if (!team) bail(`Linear team "${TEAM_KEY}" not found.`);
  return team.id;
}

async function loadWorkflowStates() {
  const data = await gql(`query {
    workflowStates(filter: { team: { key: { eq: "${TEAM_KEY}" } } }) { nodes { id name } }
  }`);
  return Object.fromEntries(data.workflowStates.nodes.map((s) => [s.name, s.id]));
}

async function loadAgentLabels(teamId) {
  const data = await gql(`query {
    issueLabels(filter: { team: { id: { eq: "${teamId}" } } }) {
      nodes { id name }
    }
  }`);
  const all = data.issueLabels.nodes;
  const agentLabels = Object.fromEntries(
    AGENTS.map((name) => {
      const labelName = `${AGENT_LABEL_PREFIX}${name}`;
      const found = all.find((l) => l.name === labelName);
      return [name, found || null];
    })
  );
  return agentLabels;
}

async function createAgentLabel(teamId, name) {
  const labelName = `${AGENT_LABEL_PREFIX}${name}`;
  const q = `mutation {
    issueLabelCreate(input: {
      name: "${escapeGql(labelName)}"
      teamId: "${teamId}"
    }) { success issueLabel { id name } }
  }`;
  const data = await gql(q);
  return data.issueLabelCreate.issueLabel;
}

async function ensureAgentLabels(teamId) {
  const labels = await loadAgentLabels(teamId);
  for (const name of AGENTS) {
    if (!labels[name]) {
      if (dryRun) {
        console.log(`[linear-claim] Would create label agent:${name}`);
      } else {
        labels[name] = await createAgentLabel(teamId, name);
        console.log(`[linear-claim] Created label agent:${name}`);
      }
    }
  }
  return labels;
}

async function loadAuthorLabels(teamId) {
  const data = await gql(`query {
    issueLabels(filter: { team: { id: { eq: "${teamId}" } } }) {
      nodes { id name }
    }
  }`);
  const all = data.issueLabels.nodes;
  const authorLabels = Object.fromEntries(
    AUTHORS.map((name) => {
      const labelName = `${AUTHOR_LABEL_PREFIX}${name}`;
      const found = all.find((l) => l.name === labelName);
      return [name, found || null];
    })
  );
  return authorLabels;
}

async function createAuthorLabel(teamId, name) {
  const labelName = `${AUTHOR_LABEL_PREFIX}${name}`;
  const q = `mutation {
    issueLabelCreate(input: {
      name: "${escapeGql(labelName)}"
      teamId: "${teamId}"
    }) { success issueLabel { id name } }
  }`;
  const data = await gql(q);
  return data.issueLabelCreate.issueLabel;
}

async function ensureAuthorLabels(teamId) {
  const labels = await loadAuthorLabels(teamId);
  for (const name of AUTHORS) {
    if (!labels[name]) {
      if (dryRun) {
        console.log(`[linear-claim] Would create label author:${name}`);
      } else {
        labels[name] = await createAuthorLabel(teamId, name);
        console.log(`[linear-claim] Created label author:${name}`);
      }
    }
  }
  return labels;
}

async function fetchIssue(issueIdentifier) {
  const match = /^([A-Z]+)-(\d+)$/.exec(issueIdentifier);
  if (!match || match[1] !== TEAM_KEY) bail(`Invalid issue identifier "${issueIdentifier}".`);
  const issueNumber = Number(match[2]);
  const data = await gql(`query {
    issues(filter: { team: { key: { eq: "${TEAM_KEY}" } }, number: { eq: ${issueNumber} } }, first: 1) {
      nodes {
        id
        identifier
        title
        state { name }
        labels { nodes { id name } }
      }
    }
  }`);
  const issue = data.issues.nodes[0];
  if (!issue) bail(`Issue ${issueIdentifier} not found.`);
  return issue;
}

function currentAgent(labelNodes) {
  const agentLabel = labelNodes.find((l) => l.name.startsWith(AGENT_LABEL_PREFIX));
  if (!agentLabel) return null;
  const agent = agentLabel.name.replace(AGENT_LABEL_PREFIX, "");
  return agent === "unassigned" ? null : agent;
}

function currentAuthor(labelNodes) {
  const authorLabel = labelNodes.find((l) => l.name.startsWith(AUTHOR_LABEL_PREFIX));
  return authorLabel ? authorLabel.name.replace(AUTHOR_LABEL_PREFIX, "") : null;
}

async function addComment(issueId, body) {
  const q = `mutation {
    commentCreate(input: {
      issueId: "${issueId}"
      body: "${escapeGql(body)}"
    }) { success comment { id } }
  }`;
  await gql(q);
}

async function updateIssueLabels(issueId, labelIds, stateId) {
  const fields = [`labelIds: [${labelIds.map((id) => `"${id}"`).join(", ")}]`];
  if (stateId) fields.push(`stateId: "${stateId}"`);
  const q = `mutation {
    issueUpdate(id: "${issueId}", input: { ${fields.join(", ")} }) {
      success issue { id identifier state { name } labels { nodes { name } } }
    }
  }`;
  return await gql(q);
}

function buildLabelIds(currentLabels, targetLabel, allAgentLabels) {
  const agentLabelIds = new Set(
    AGENTS.map((name) => allAgentLabels[name]?.id).filter(Boolean)
  );
  const kept = currentLabels
    .map((l) => l.id)
    .filter((id) => !agentLabelIds.has(id));
  kept.push(targetLabel.id);
  return kept;
}

async function runSetup() {
  const teamId = await loadTeam();
  await ensureAgentLabels(teamId);
  await ensureAuthorLabels(teamId);
  if (dryRun) {
    console.log("[linear-claim] Dry run complete.");
  } else {
    console.log("[linear-claim] Agent and author labels ready in Linear team " + TEAM_KEY);
  }
}

async function runStatus() {
  if (!issueIdentifier) bail("--issue is required.");
  const issue = await fetchIssue(issueIdentifier);
  const agent = currentAgent(issue.labels.nodes);
  const author = currentAuthor(issue.labels.nodes);
  console.log(`[linear-claim] ${issue.identifier}: ${issue.title}`);
  console.log(`[linear-claim] State: ${issue.state.name}`);
  console.log(`[linear-claim] Current agent: ${agent || "unassigned"}`);
  console.log(`[linear-claim] Original author: ${author || "unknown"}`);
}

async function runClaim() {
  if (!issueIdentifier) bail("--issue is required.");
  if (!agentName) bail("--agent is required.");
  if (!AGENTS.includes(agentName)) bail(`Unknown agent. Use one of: ${AGENTS.join(", ")}`);

  const teamId = await loadTeam();
  const agentLabels = await ensureAgentLabels(teamId);
  const authorLabels = await ensureAuthorLabels(teamId);
  const issue = await fetchIssue(issueIdentifier);
  const current = currentAgent(issue.labels.nodes);
  const author = currentAuthor(issue.labels.nodes);

  if (current && current !== agentName && !shouldSteal) {
    bail(
      `Issue ${issueIdentifier} is already claimed by ${current}. Use --steal to override.`
    );
  }

  if (current === agentName) {
    console.log(`[linear-claim] Issue ${issueIdentifier} already claimed by ${agentName}.`);
    return;
  }

  const stateId = newState ? (await loadWorkflowStates())[newState] : undefined;
  if (newState && !stateId) bail(`Unknown state "${newState}".`);

  // Preserve non-agent, non-author labels and set the live agent label.
  const agentLabelIds = new Set(AGENTS.map((name) => agentLabels[name]?.id).filter(Boolean));
  const authorLabelIds = new Set(AUTHORS.map((name) => authorLabels[name]?.id).filter(Boolean));
  const kept = issue.labels.nodes
    .filter((l) => !agentLabelIds.has(l.id) && !authorLabelIds.has(l.id))
    .map((l) => l.id);

  const newLabelIds = [...kept, agentLabels[agentName].id];

  // First claim = original author. Later claims keep the existing author label.
  const existingAuthorLabel = issue.labels.nodes.find(
    (l) => l.name === `${AUTHOR_LABEL_PREFIX}${author}`
  );
  if (existingAuthorLabel) {
    newLabelIds.push(existingAuthorLabel.id);
  } else {
    newLabelIds.push(authorLabels[agentName].id);
  }

  const timestamp = new Date().toISOString();
  let commentBody;
  if (author && author !== agentName) {
    const prevText = current && current !== agentName ? ` (stolen from ${current})` : "";
    commentBody = `🛠 Picked up for correction by ${agentName} at ${timestamp} (original author: ${author})${prevText}`;
  } else {
    const prevText = current && current !== agentName ? ` (stolen from ${current})` : "";
    commentBody = `🔒 Claimed by ${agentName} at ${timestamp}${prevText}`;
  }

  if (dryRun) {
    const action = author && author !== agentName ? "pick up for correction" : "claim";
    console.log(`[linear-claim] Would ${action} ${issueIdentifier} for ${agentName}`);
    console.log(`[linear-claim] Would comment: ${commentBody}`);
    if (stateId) console.log(`[linear-claim] Would set state: ${newState}`);
    return;
  }

  await updateIssueLabels(issue.id, newLabelIds, stateId);
  await addComment(issue.id, commentBody);

  if (author && author !== agentName) {
    console.log(`[linear-claim] Picked up ${issue.identifier} for correction by ${agentName} (author: ${author}).`);
  } else {
    console.log(`[linear-claim] Claimed ${issue.identifier} for ${agentName}.`);
  }
}

async function runRelease() {
  if (!issueIdentifier) bail("--issue is required.");
  if (!agentName) bail("--agent is required.");
  if (!AGENTS.includes(agentName)) bail(`Unknown agent. Use one of: ${AGENTS.join(", ")}`);

  const teamId = await loadTeam();
  const labels = await ensureAgentLabels(teamId);
  await ensureAuthorLabels(teamId);
  const issue = await fetchIssue(issueIdentifier);
  const current = currentAgent(issue.labels.nodes);
  const author = currentAuthor(issue.labels.nodes);

  if (current && current !== agentName && !shouldSteal) {
    bail(
      `Issue ${issueIdentifier} is claimed by ${current}, not ${agentName}. Use --steal to override.`
    );
  }

  const agentLabelIds = new Set(
    AGENTS.map((name) => labels[name]?.id).filter(Boolean)
  );
  const baseLabels = issue.labels.nodes.map((l) => l.id);
  const timestamp = new Date().toISOString();
  const stateId = newState ? (await loadWorkflowStates())[newState] : undefined;
  if (newState && !stateId) bail(`Unknown state "${newState}".`);

  let newLabelIds;
  let commentBody;
  let actionText;

  if (shouldUnassign) {
    // Mark as genuinely unclaimed / up for grabs.
    newLabelIds = baseLabels
      .filter((id) => !agentLabelIds.has(id))
      .concat(labels.unassigned.id);
    commentBody = `⏸ Unassigned by ${agentName} at ${timestamp}`;
    actionText = "unassigned";
  } else {
    // Default release: keep the agent label as historical owner.
    newLabelIds = baseLabels.filter((id) => id !== labels.unassigned?.id);
    if (!newLabelIds.includes(labels[agentName].id)) {
      newLabelIds.push(labels[agentName].id);
    }
    const authorText = author ? ` (original author: ${author})` : "";
    commentBody = `✅ Released by ${agentName} at ${timestamp}. Retaining agent:${agentName} as historical owner.${authorText}`;
    actionText = "released";
  }

  if (dryRun) {
    console.log(`[linear-claim] Would ${actionText} ${issueIdentifier} for ${agentName}`);
    console.log(`[linear-claim] Would comment: ${commentBody}`);
    if (stateId) console.log(`[linear-claim] Would set state: ${newState}`);
    return;
  }

  await updateIssueLabels(issue.id, newLabelIds, stateId);
  await addComment(issue.id, commentBody);
  console.log(`[linear-claim] ${actionText.charAt(0).toUpperCase() + actionText.slice(1)} ${issue.identifier} for ${agentName}.`);
}

async function main() {
  switch (command) {
    case "setup":
      await runSetup();
      break;
    case "status":
      await runStatus();
      break;
    case "claim":
      await runClaim();
      break;
    case "release":
      await runRelease();
      break;
    default:
      console.log(`Usage: node scripts/linear-claim.mjs <setup|status|claim|release> [options]`);
      console.log("");
      console.log("Options:");
      console.log("  --issue KO-XXX     Linear issue identifier");
      console.log("  --agent <name>     One of: codex, claude, qwen, kimi, human");
      console.log("  --steal            Override an existing claim");
      console.log("  --unassign         On release, mark issue as unclaimed (default keeps agent/author labels as history)");
      console.log("  --state <name>     Set Linear workflow state (e.g. 'In Progress')");
      console.log("  --dry-run          Show what would happen without mutating Linear");
      process.exit(1);
  }
}

main().catch((e) => {
  console.error("[linear-claim] Failed:", e.message);
  process.exit(1);
});
