---
name: cf-layer4-triage
description: Reconcile CourseFinder Layer 4 Review queues through the Kimi Browser Extension using the existing Platform Admin UI, evidence rules and audit trail. Use when asked to clear, triage, review or drain Layer 4 records across all or selected universities, complete a bounded By kind decision qualification run, resume an interrupted triage batch, or run commands such as layer4-clear-all, layer4-by-kind-qualify and layer4-university-triage. Supports resumable batches without deleting records, bulk-approving uncertain evidence, requesting SQL, substituting snapshots for decisions, or looping over re-raised items.
---

# CourseFinder Layer 4 triage

Reconcile pending Layer 4 items through the existing UI. Interpret “clear” as **review, decide and reconcile**, never delete or force the queue to zero. Snapshot collection, planning and proposed actions are not decisions or queue progress.

Read [references/action-playbook.md](references/action-playbook.md) before making category-specific decisions.

## Invoke

- `layer4-by-kind-qualify` — prove one saved decision in one suitable kind, then complete up to four more verified decisions in that kind.
- `layer4-clear-all` — reconcile every provider in the current Layer 4 queue, but only after the current environment has a verified decision write path.
- `layer4-clear-all <provider>` — reconcile one exact provider.
- `layer4-clear-all resume <batch-id>` — resume the first incomplete provider without repeating decided item ids.
- Natural-language equivalents such as “clear all Layer 4”, “triage Layer 4 by kind” or “continue the Layer 4 batch” use the matching workflow.

For a new workstation, an untested browser connection, or any previous zero-decision/uncertain batch, run `layer4-by-kind-qualify` before `layer4-clear-all`. Do not keep starting full-queue batches when no decision has been verified.

## Preflight

1. Use the connected browser and authenticated Platform Admin session on **Data pipeline → Layer 4 Review**. If unavailable, request connection or sign-in; never substitute SQL.
2. Record batch id `L4B-YYYYMMDD-HHMM`, workflow, scope, start time, total pending, category counts and the oldest-item setting. Use the batch id in every decision reason.
3. Check service health and available model credit. Default to stored evidence only. Do not invoke AI re-checks, Firecrawl or new source acquisition without explicit authorisation.
4. Confirm that the user’s instruction authorises the same UI decisions as individual triage. Batching grants no extra permission.
5. Do not rely on another workstation's snapshots or checkpoint state. Transfer the consolidated checkpoint separately when resuming; otherwise start a new batch.

## Qualify the write path by kind

Use this bounded workflow before broader automation on a new or previously unsuccessful setup.

1. Open **By kind** and select one existing kind with pending items and stored evidence suitable for conservative decisions. Prefer a fee-cross-check item that supports keeping the registered total, or a held-scholarship item that supports **Not for international students** or **Not a scholarship**.
2. For qualification, do not choose official course-page replacement, archive, provider-departure/ownership, conjoint/no-page, central-page or adapter decisions.
3. Review no more than the 10 oldest items in that kind and submit no more than five decisions. Process no other kind and no provider-wide or full-queue scan.
4. For the first eligible item, state its stable review-item id, subject/provider, intended existing UI choice and evidence basis. Submit that one decision with the batch id and evidence basis in its reason; do not merely recommend it.
5. Verify through the current By kind queue and lightweight items view that the decision saved and the item left **Waiting for a person**. Refresh once if needed. Do not open the failing **Decided** view or use SQL.
6. If the first result is uncertain, the item remains waiting, or the UI/network fails, stop and report the exact last screen/error. Verify whether the original action succeeded before any retry.
7. Only after that first verified decision, process up to four additional eligible items in the same kind, verifying each individually. Leave inadequate or conflicting items pending with stable item id, blocker, owner and next action.
8. Stop after five submitted decisions, 10 reviewed items or exhaustion of eligible items, whichever occurs first. Report actual submitted and verified decisions, not proposed decisions.

## Execute one resumable provider batch

1. Process providers sequentially, oldest pending work first unless the user supplies a priority. For a named-provider scope, process only that exact provider record; do not merge or triage sibling records.
2. Snapshot the provider’s pending item ids, categories and evidence. Never identify an item by its changing row position.
3. For each item:
   - Read the stored quote, link, proposed value and existing decision context.
   - Apply the action playbook and existing UI choice.
   - Submit the supported decision; do not stop at a proposed-action summary.
   - Record a concise reason containing the batch id and evidence basis.
   - Verify the decision through the current queue and lightweight universities/items views, confirming that the item leaves **Waiting for a person**. Do not open the failing **Decided** view.
4. Checkpoint after every provider: pending before/after, submitted decision count, stable review-item ids, outcomes, admitted values, archives, rebuilds, exceptions and elapsed time. The existing audit trail is the decision store; keep one consolidated batch narrative rather than a chat per provider.
5. Refresh once after a provider reaches zero. Treat subsequently appearing items as new work, not failed decisions.
6. Reconcile a newly raised item once when the same evidence and rule still apply. If the same issue re-raises again, leave it pending, record a re-raise defect and move on. Never enter a keep/rebuild loop.
7. Retry a transient UI or database timeout once with backoff and verify the result before retrying. Stop the whole batch after repeated shared timeouts or evidence that writes are unreliable.
8. Record provider-local ambiguity as a named exception and continue. Stop the whole batch for authentication loss, a shared reader/decision defect, unexpected consumer-visible writes, or untrustworthy queue/evidence state.
9. Do not substitute broad By kind snapshots for provider decisions and checkpoints. On completion, refresh the queue and reconcile baseline minus decisions, new items and remaining exceptions.

## Resume safely

- Read the batch checkpoints and current queue state before continuing. Do not rely on page/session memory or the failing **Decided** view.
- Skip decided item ids, not whole providers with new pending items.
- Do not repeat an archive, publish, approval, rebuild or adapter action merely because its earlier result is unclear; verify first.
- Preserve the original batch id and append resume checkpoints.
- If no checkpoint is available on the current workstation, do not claim a portable resume. Start a new bounded qualification run instead.

## Hard boundaries

- No select-all approval, arbitrary SQL, direct database writes, deletion, provider merger or ownership change.
- No new reader, status, panel, consumer field or API change.
- No publishing, admission, archiving or source replacement without item-level evidence and the existing rule.
- No approval to make a metric look better. Leave genuine human source, policy, identity and ownership decisions pending with an owner.
- No repeated retries, autonomous reader repair or interference with unrelated AER, recovery or enrichment work.

## Report once

Return one table by provider or qualified kind and totals by category:

- pending before/after and decisions actually submitted and verified by existing outcome;
- stable review-item ids and evidence basis for each decision;
- scholarships, pages, fees or other values actually admitted;
- courses archived and adapter rebuilds queued;
- new/re-raised items and remaining exceptions by cause;
- human owner and next action for every unresolved exception;
- checkpoint location, elapsed time and any AI/Firecrawl consumption.

State **reconciled**, **admitted**, **left pending** and **newly raised** separately. If zero decisions were submitted, say so and identify the exact blocker for each reviewed candidate. Never present local helper files, snapshots, planning or proposed actions as Layer 4 progress. Do not call triage enrichment unless a value was actually admitted.
