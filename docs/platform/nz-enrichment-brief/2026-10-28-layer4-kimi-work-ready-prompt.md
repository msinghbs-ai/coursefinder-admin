# Ready-to-paste Kimi Work prompt — Layer 4 Review

Date: 28 October 2026  
Scope: operating prompt only; no Layer 4 decisions or catalogue writes performed.

In Kimi Desktop, open **Work → New Task**, type `/`, select **Layer-4-Review** / `cf-layer4-triage`, then paste the following prompt.

```text
Use the installed Layer-4-Review skill and the connected Kimi Browser Extension to run:

layer4-clear-all

Work through the existing authenticated Platform Admin UI at Data pipeline → Layer 4 Review. Interpret “clear all” as review, decide and reconcile every provider in the current queue — never delete records, bulk-approve uncertain evidence or force the queue to zero.

This instruction authorises the item-level UI decisions already permitted by the skill and its action playbook. It grants no additional permissions.

Before starting:
- Confirm the browser connection and authenticated Layer 4 Review page.
- Record a new L4B-YYYYMMDD-HHMM batch id, scope, start time, total pending, category counts and oldest-item setting.
- Use stored evidence only. Do not run AI re-checks, Firecrawl or new source acquisition.
- Confirm the queue and evidence are trustworthy before making any decision.

During the batch:
- Process providers sequentially, oldest pending work first, and checkpoint after every provider.
- Snapshot and track stable item ids, never changing row positions.
- Read each item’s stored quote, links, proposed value and existing decision context before choosing.
- Put the batch id and concise evidence basis in every decision reason.
- Verify outcomes through the current queue and lightweight universities/items views. Do not open the failing Decided view.
- Do not use SQL, direct database writes, deletion, provider mergers or select-all approval.
- Leave inadequate evidence, identity conflicts, policy judgements, duplicates and unresolved ownership issues pending with a named owner and next action.
- Reconcile a re-raised item once only when the same evidence and rule still apply. If it re-raises again, leave it pending and record a re-raise defect.
- Retry a transient timeout once only after verifying whether the original action succeeded. Stop the batch for repeated shared timeouts, authentication loss, uncertain writes, unexpected consumer-visible changes or unreliable queue state.
- Do not interfere with AER, recovery, enrichment or any other running work.

When finished, refresh once and return one consolidated report containing:
- batch id and elapsed time;
- pending before/after by provider and category;
- decisions by existing outcome;
- values actually admitted, courses archived and adapter rebuilds queued;
- items left pending with owner and next action;
- new and re-raised items;
- baseline-to-current reconciliation and all exceptions;
- AI/Firecrawl consumption, which must be zero unless separately authorised.

Keep reconciled, admitted, left pending and newly raised as separate measures. Do not describe a decision as applied, a rebuild as completed or triage as enrichment unless the current outcome proves it.
```

For a qualification run on one exact provider before the full queue, replace only the command line with:

```text
layer4-clear-all Federation University Australia
```

To resume an interrupted batch instead, replace it with:

```text
layer4-clear-all resume L4B-YYYYMMDD-HHMM
```

Use the original batch id and make the existing consolidated checkpoint available in the Work task. Do not run a second sidebar or Work automation session against the same queue concurrently.
