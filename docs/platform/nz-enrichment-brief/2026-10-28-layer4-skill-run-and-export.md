# Layer 4 Review skill — run and workstation export

Date: 28 October 2026  
Scope: operating instructions for the KBE skill saved as `Layer-4-Review`; no Layer 4 decisions or catalogue writes performed.

## Run the full queue

In the KBE sidebar, type `/`, select **Layer-4-Review**, then run:

```text
layer4-clear-all
```

“Clear” means review, decide and reconcile through the existing Platform Admin UI. It does not mean delete records, bulk-approve uncertain evidence or force the queue to zero. Items lacking sufficient evidence remain pending as named exceptions with an owner and next action.

Before starting, use a connected browser with an authenticated Platform Admin session on **Data pipeline → Layer 4 Review**. The skill records a batch id, baseline counts and checkpoints; processes providers sequentially; uses stable item ids and stored evidence; and stops on shared write, authentication or queue-integrity failures. AI re-checks, Firecrawl and new source acquisition require separate explicit authorisation.

Useful variants:

```text
layer4-clear-all Federation University Australia
layer4-clear-all resume L4B-YYYYMMDD-HHMM
```

The first restricts the run to one exact provider. The second resumes an incomplete batch without repeating decided item ids. Keep the original batch id and supply its checkpoint when resuming elsewhere.

The portable copy retains the Federation-run safeguard: verify through the current queue and lightweight universities/items views; do not open the failing **Decided** view.

## Export and use on another workstation

A validated portable package was supplied in chat as `cf-layer4-triage.skill`. Its canonical skill name is `cf-layer4-triage`; `Layer-4-Review` is the saved KBE display label. It contains:

- `cf-layer4-triage/SKILL.md`
- `cf-layer4-triage/references/action-playbook.md`

On the other workstation:

1. Install/open KBE in Chrome or Edge and use its skill import action.
2. Select `cf-layer4-triage.skill`. After import, invoke it from `/`; the `layer4-clear-all` commands are unchanged. It may be displayed again as `Layer-4-Review` if desired.
3. Connect the browser and sign in to Platform Admin separately. The package contains no login, cookies, browser session or Platform Admin access.
4. Copy any in-flight batch checkpoint separately if resuming work. The skill package contains the workflow and evidence rules, not prior batch state.

If the KBE-only `Layer-4-Review` receives later edits, use KBE's native skill export after those edits so the portable copy remains current.
