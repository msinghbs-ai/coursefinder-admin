# CourseFinder Project Run Sheets

**Status:** ACTIVE CROSS-CHAT OPERATIONAL LEDGER  
**Effective:** 26 August 2026  
**Authority:** Supporting operational source of truth under `PROJECT_INSTRUCTIONS.md`, Change Control and the accepted project governance documents.

## Purpose

Project run sheets remove dependence on long ChatGPT conversation history. Each active milestone/phase keeps a concise, chronological, outcome-oriented record of what actually happened, what is currently true, what evidence proves it and exactly what the next continuation must do.

Conversation history is not the handoff mechanism. The repository is.

## Folder convention

Use:

`project-runsheets/milestone-<n>/<phase-or-workstream>/`

Each active phase contains only three durable files unless more evidence-specific files are genuinely required:

- `RUNSHEET.md` — append-only chronological execution ledger;
- `CURRENT-STATE.md` — reconciled current truth, blockers, active changes and next gates;
- `NEXT-CHAT.md` — compact copy/paste continuation prompt generated from current repo/deployed truth.

Do not create one document per chat session. This avoids documentation sprawl and chat-limit problems.

## Mandatory session behaviour

At the start of a continuation chat:

1. read `PROJECT_INSTRUCTIONS.md` and its referenced current governance documents;
2. read the applicable `project-runsheets/.../CURRENT-STATE.md` and `NEXT-CHAT.md`;
3. reconcile them against current GitHub source, deployed Supabase/runtime state, CI/UAT and overlapping Change Controls;
4. treat newer repository/deployed evidence as authoritative over stale run-sheet wording;
5. execute the stated next gate autonomously;
6. before handoff, update the run sheet and current state with actual outcomes and evidence;
7. rewrite `NEXT-CHAT.md` so the following chat can begin without referring back to the previous conversation.

## RUNSHEET entry format

Append one entry per meaningful execution block, not per message.

```md
## YYYY-MM-DD HH:MM TZ — <workstream / execution block>

**Intent:** <what outcome was being pursued>

**Starting state:** <important repo/deployed/change-control baseline>

**Actions:**
- <material action>

**Outcome:** PASS | PARTIAL | BLOCKED | DEFERRED

**Evidence:**
- repo/commit/migration/run/UAT/advisor reference

**Follow-up:**
- <only unresolved or newly-created work>
```

## CURRENT-STATE rules

Keep it short and replace stale state rather than accumulating history. It should answer:

- What milestone/phase is active?
- What is accepted and frozen?
- What is currently deployed?
- Which Change Controls are open?
- What is blocked and why?
- Which regressions/UAT remain?
- What exact gate is next?

## NEXT-CHAT rules

The continuation prompt must be execution-oriented. It must:

- tell the next chat to read `PROJECT_INSTRUCTIONS.md` and this run-sheet folder first;
- prohibit reliance on conversation history, stale SHAs, counts or prompt assumptions;
- state exact immediate work in dependency order;
- require autonomous UAT and evidence retention;
- require run-sheet/current-state/update before handoff;
- avoid pasting historical narrative already retained in `RUNSHEET.md`;
- remain compact enough for repeated reuse.

## Relationship to Change Control

Run sheets do not replace Change Control. Change Controls remain the durable record for material semantic, schema, security, UI, Search/publication and operational changes. The run sheet records execution sequence and cross-chat continuity and links to those records.

## Outcome standard

A work block ends only as:

- **PASS** — stated gate completed with evidence;
- **PARTIAL** — material progress made and remaining work explicitly bounded;
- **BLOCKED** — blocker reproduced and evidenced;
- **DEFERRED** — explicitly moved outside the current gate.

Do not use vague states such as “mostly done”, “looks good” or “continue later”.
