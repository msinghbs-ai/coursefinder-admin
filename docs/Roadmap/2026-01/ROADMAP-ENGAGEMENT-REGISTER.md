# StudySearch roadmap engagement register

## Open the register

| File | Purpose |
|---|---|
| [Roadmap_Engagement_Register.xlsx](Roadmap_Engagement_Register.xlsx) | Excel view with milestone totals and a filterable engagement log. Read-only for agents: Claude regenerates it from the CSVs |
| [ROADMAP-ENGAGEMENTS.csv](ROADMAP-ENGAGEMENTS.csv) | Current engagement ledger. Open directly in Excel for the latest entries. |
| [ROADMAP-MILESTONES.csv](ROADMAP-MILESTONES.csv) | Milestones and work items with parent, owner, request references, status and next action |
| [Operating model](../../platform/AGENT-OPERATING-MODEL.md#roadmap-milestones-and-human-engagement-time) | Mandatory logging instruction for every StudySearch roadmap session |
| [API v3 workstream briefs](V3-QUICK-WINS-MODULES.md) | Module scope and copy-ready session prompt |

## What counts

Record **one entry per substantive human engagement** on a roadmap topic or item. This includes requests for prompts, planning, design discussions, decisions, development direction, review, acceptance and handover. Use the human-reported active duration with a **15-minute minimum**. If duration was not supplied, record **15 minutes** with time basis `minimum`. When duration is supplied, record `max(15, reported minutes)` with basis `reported` and retain the original duration in the outcome if below 15. Do not infer duration from chat wall-clock time.

Use `Planning` when the human requests a design or prompt. Use `Development` for a separate human interaction directing or discussing implementation. A copied planning prompt initiating a distinct human-requested implementation engagement counts once as Development. The original Planning entry stays separate. Use `Review`, `Decision`, `Acceptance` or `Handover` when one of those is the primary activity.

Exclude background agents, tool runs, build/CI time, monitoring, idle/wait time and assistant-only messages. Multiple exchanges during a single human-reported meeting use one entry for the meeting. A standalone new human follow-up advancing the work is a new engagement. When one interaction spans several items, record the time once under the primary item, then list the related IDs. A shared meeting or copied handoff already counted in another chat reuses its engagement ID.

## Record each engagement before replying

1. Read the milestone register. Use the existing RM ID or the narrowest registered child. Use a parent when the scope applies across that milestone. Preserve published milestone IDs and requirement IDs.
2. Capture the request or meeting start timestamp as an ISO 8601 value with the Melbourne UTC offset, such as `2026-11-13T14:30:00+11:00`. If the original time is unavailable, use the current observed time and say `timestamp recorded at logging` in the outcome. For historical engagements with only a known date, record the date without an invented time and label that limitation. Never invent retrospective minutes or meetings.
3. Assign a stable unique ID, preferably from the user turn or meeting ID where available. Otherwise generate a timestamp, session slug and short random suffix once and retain it across retries. Record platform/session name, activity, human minutes and time basis, concise topic, outcome, next action and relevant repo references. Use only project-safe summaries and references in the public Admin repo. Omit chat transcripts, private meeting links, personal details, secrets and prompts copied verbatim.
4. Append one CSV row. Use a CSV writer or correctly quote commas and quotes. Keep each field on one physical line. Update the milestone row only when its status, owner or next action materially changes. Log the actual result and evidence in the existing feature acceptance and Execution Register where applicable.
5. Use an optimistic write. With the GitHub connector, fetch the current file and blob SHA, check for the engagement ID, append, and update with that SHA. If another chat wrote first, reread and reapply just your new row. With Git, fetch and integrate the latest main before a normal fast-forward push, then retry safely after a conflict. Never force-push a competing ledger write. Read back the matching ID from the committed branch. If GitHub write access is unavailable, keep the pending entry with its original ID and timestamp, disclose that it is pending and append it once write access is restored.

Corrections are appended with a new ID and `supersedes_id` pointing to the old ID, using the corrected values in full. Keep the audit trail. Count only the current entry in a correction chain. Duplicate keys and a second correction of the same prior row must be reconciled before counting. Use a concise commit message such as `Record RM1A Planning engagement`.

### Excel maintenance

**Rule (Platform Admin, 13 November 2026):** the two CSVs are the only files ChatGPT and Claude write to. Neither agent edits `Roadmap_Engagement_Register.xlsx` directly. Claude regenerates the workbook from the CSVs on `main` and commits it, when asked and at each milestone review or handover. Between refreshes, the CSV is the current record and the workbook may lag.

To regenerate, from this folder run `python3 refresh-engagement-workbook.py Roadmap_Engagement_Register.xlsx ROADMAP-MILESTONES.csv ROADMAP-ENGAGEMENTS.csv` (needs `openpyxl`). It keeps the formatting, fills the tables from the CSVs, keeps Occurred at as Melbourne ISO text, fills the calculated columns down and resizes the tables. Before committing, recalculate the workbook and check its row count and human-minute total match the CSV. The earlier [Node generator](build-engagement-workbook.mjs) depends on a ChatGPT-only library and is kept for reference only.

### Prompt clause

```text
Roadmap engagement logging (required). Use the item ID in this prompt and follow
docs/platform/AGENT-OPERATING-MODEL.md#roadmap-milestones-and-human-engagement-time.
Before replying to each substantive human interaction, append and verify one row
in docs/Roadmap/2026-01/ROADMAP-ENGAGEMENTS.csv on Admin main. Timestamp it in
Australia/Melbourne and record the item, activity, outcome, next action and
human minutes. Use at least 15 minutes and use 15 if no duration was supplied.
The prompt-generation discussion is Planning. Log Development for the separate
human request that starts or directs implementation. Count each human
engagement once. Exclude autonomous processing, CI and waiting time.
```

### Example

An RM1A prompt request is one **Planning · 15 min minimum** row. Starting implementation by giving that prompt to Claude is a separate **Development · 15 min minimum** row. A later 35-minute human review is **Review · 35 min reported**. The combined recorded human engagement is **65 minutes**. This example is illustrative. The live ledger records the actual register setup under RM0A.
