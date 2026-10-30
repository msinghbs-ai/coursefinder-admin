---
name: cf-layer4-triage
description: Reconcile all 17 current CourseFinder Layer 4 Review decision kinds through the Kimi Browser Extension and existing Platform Admin UI, using item-level evidence, verified actions and audit checkpoints. Use to clear, triage, review or drain one pill, one provider or the queue; complete bounded By kind qualification; resume a batch; or run layer4-by-kind-qualify, layer4-clear-kind, layer4-clear-all and layer4-university-triage. Covers AER, counsellor reports and website outages without bulk-approving uncertain evidence, bypassing roles, requesting SQL or looping over re-raised items.
---

# CourseFinder Layer 4 triage — v5

Reconcile pending Layer 4 items through the existing UI. Interpret **clear** as review, decide and reconcile, never delete or force the queue to zero. Snapshot collection, navigation, planning and proposed actions are not decisions or queue progress.

Cover all 17 UI kinds current on 30 October 2026. Coverage means an evidence-governed path for every kind, not guaranteed closure of every item.

Read [references/action-playbook.md](references/action-playbook.md) before making category-specific decisions.

## Invoke

- `layer4-by-kind-qualify` — prove one saved decision in one suitable kind, then complete up to four more verified decisions in that kind.
- `layer4-clear-kind <kind>` — reconcile one exact kind across providers, one item at a time, after verifying its action route.
- `layer4-clear-kind <kind> resume <batch-id>` — resume that kind from its consolidated checkpoint without repeating decided refs.
- `layer4-clear-all` — reconcile every provider in the current queue, but only after the current environment has a verified decision write path.
- `layer4-clear-all <provider>` — reconcile one exact provider.
- `layer4-clear-all resume <batch-id>` — resume the first incomplete provider without repeating decided refs.
- Treat natural-language equivalents such as “clear the Course link pill”, “triage AER by kind”, “clear all Layer 4” or “continue the Layer 4 batch” as the matching workflow.

For a new workstation, an untested browser connection, or any previous zero-decision/uncertain batch, run `layer4-by-kind-qualify` before broader work. Do not keep starting full-queue batches when no decision has been verified.

## Preflight

1. Use the connected browser and authenticated Platform Admin session on **Data pipeline → Layer 4 Review**. If unavailable, request connection or sign-in; never substitute SQL.
2. Record batch id `L4B-YYYYMMDD-HHMM`, workflow, scope, start time, total pending, category counts and the oldest-item setting. Use the batch id in every decision reason.
3. Check service health and available model credit. Default to stored evidence only. Do not invoke AI re-checks, Firecrawl or new source acquisition without explicit authorisation.
4. Confirm that the user’s instruction authorises the same UI decisions as individual triage. Batching grants no extra permission. Confirm the connected role can see enabled choices; AER decisions require Platform Admin.
5. Match the current pills to the playbook. Process only named current kinds. If a new or renamed kind is absent, leave it pending and report the contract gap; do not infer an action.
6. Do not rely on another workstation's snapshots or checkpoint state. Transfer the consolidated checkpoint separately when resuming; otherwise start a new batch.

## Qualify the write path by kind

Use this bounded workflow before broader automation on a new or previously unsuccessful setup. Qualification proves UI submission and the selected kind's action route; it does not prove every Layer 4 action route. When later work enters a different kind, verify its first decision before continuing.

1. Open **By kind** and select one existing kind with pending items and stored evidence suitable for conservative decisions. Prefer a fee-cross-check item that supports keeping the registered total, or a held-scholarship item that supports **Not for international students** or **Not a scholarship**.
2. For initial environment qualification, do not choose official course-page replacement, archive, provider-departure/ownership, conjoint/no-page, central-page, adapter, AER or counsellor-correction decisions.
3. Review no more than the 10 oldest items in that kind and submit no more than five decisions. Process no other kind and no provider-wide or full-queue scan.
4. For the first eligible item, state its stable UI item/ref id (the review-item UUID where applicable, otherwise the numeric or other kind-specific ref), subject/provider, intended existing UI choice and evidence basis. Submit that one decision with the batch id and evidence basis in its reason; do not merely recommend it.
5. Verify through the current By kind queue and lightweight items view that the decision saved and the item left **Waiting for a person**. Refresh once if needed. Do not open the failing **Decided** view or use SQL.
6. If the first result is uncertain, the item remains waiting, or the UI/network fails, stop and report the exact last screen/error. Verify whether the original action succeeded before any retry.
7. Only after that first verified decision, process up to four additional eligible items in the same kind, verifying each individually. Leave inadequate or conflicting items pending with stable item id, blocker, owner and next action.
8. Stop after five submitted decisions, 10 reviewed items or exhaustion of eligible items, whichever occurs first. Report actual submitted and verified decisions, not proposed decisions.

## Execute one resumable kind batch

1. Select one exact kind by its current key or unique label. Verify its first saved decision before continuing; the fee-check route does not qualify any other route.
2. Snapshot pending refs, providers and evidence. Process oldest first across providers, one item at a time. Never use select-all or a generic bulk-decide path.
3. Read the stored quote, link, proposed value and existing decision context. Apply the kind's playbook section, submit the supported existing UI choice with the batch id and evidence basis, and verify the item leaves waiting.
4. Treat Open course/adapter/central-pages and similar choices as navigation only. Complete the required correction or approval in the destination UI, return to Layer 4 and verify closure before counting a decision.
5. For AER, use the Platform Admin session and decide one item at a time under the AER playbook. Never invoke generic bulk/batch approval or start a paid re-read.
6. Checkpoint after every 10 submitted decisions, after 20 reviewed items without a decision, and before changing scope. Record stable refs, actual choices, verified outcomes, downstream work and exceptions.
7. Leave unsupported items pending with owner and next action; continue other eligible items only while writes and evidence remain trustworthy. Do not repeatedly rebuild, retry or re-decide to make the pill fall.
8. On completion or stop, refresh once and reconcile baseline minus verified decisions, new items, deferred outcomes and remaining exceptions. Do not attribute unrelated global count movement to the batch.

## Execute one resumable provider batch

1. Process providers sequentially, oldest pending work first unless the user supplies a priority. For a named-provider scope, process only that exact provider record; do not merge or triage sibling records.
2. Snapshot the provider’s pending refs, categories and evidence. Never identify an item by its changing row position.
3. For each item, follow the same evidence, existing-choice, linked-action completion and first-decision-per-kind verification rules as a kind batch.
4. Checkpoint after every provider: pending before/after, submitted decision count, stable UI refs, outcomes, admitted values, archives, rebuilds, exceptions and elapsed time. Inbox decisions are recorded in `pipeline.admin_control_events`; routed review items can also have `pipeline.layer4_decisions` rows. Do not expect every kind in both ledgers or count both as separate decisions. Keep one consolidated batch narrative rather than a chat per provider.
5. Refresh once after a provider reaches zero. Treat subsequently appearing items as new work, not failed decisions.
6. Reconcile a newly raised item once when the same evidence and rule still apply. If the same issue re-raises again, leave it pending, record a re-raise defect and move on. Never enter a keep/rebuild loop.
7. Retry a transient UI or database timeout once with backoff and verify the result before retrying. Stop the whole batch after repeated shared timeouts or evidence that writes are unreliable.
8. Record provider-local ambiguity as a named exception and continue. Stop the whole batch for authentication loss, a shared reader/decision defect, unexpected consumer-visible writes, or untrustworthy queue/evidence state.
9. Do not substitute broad By kind snapshots for provider decisions and checkpoints. On completion, refresh the queue and reconcile baseline minus decisions, new items and remaining exceptions.

## Resume safely

- Read the batch checkpoints and current queue state before continuing. Do not rely on page/session memory or the failing **Decided** view.
- Preserve the original batch id and scope. For a kind resume, use the checkpoint's exact kind; for a provider resume, continue the first incomplete provider.
- Skip decided refs, not whole providers with new pending items or whole kinds with new work.
- Do not repeat an archive, publish, approval, rebuild, report closure or adapter action merely because its earlier result is unclear; verify first.
- If no checkpoint is available on the current workstation, do not claim a portable resume. Start a new bounded qualification run instead.

## Hard boundaries

- No select-all approval, arbitrary SQL, direct database writes, deletion, provider merger or ownership change. A provider merger requires separate explicit Platform Admin approval for the exact provider and successor.
- No new reader, status, panel, consumer field or API change.
- No publishing, admission, archiving, source replacement or overwriting a manual value/binding without item-level evidence and the existing rule.
- No AER decision below Platform Admin rank, no AER generic bulk/batch decision, and no AER re-read or other spend without separate authorisation.
- No approval to make a metric look better. Leave genuine human source, policy, identity, ownership and correction decisions pending with an owner.
- No repeated retries, autonomous reader repair or interference with concurrent AER reader, recovery or enrichment jobs. Reviewing an existing AER Inbox item one at a time under this Skill is permitted only when the user's instruction authorises AER decisions.

## Report once

Return one table by provider or kind and totals by category:

- pending before/after and decisions actually submitted and verified by existing outcome;
- stable UI refs and evidence basis for each decision, plus ledger event/decision ids when available;
- scholarships, pages, fees, AER rows or other values actually admitted;
- courses/providers archived, reports closed and adapter rebuilds queued;
- linked corrections completed, deferred/waiting outcomes and downstream work still running;
- new/re-raised items and remaining exceptions by cause;
- human owner and next action for every unresolved exception;
- checkpoint location, elapsed time and any AI/Firecrawl consumption.

State **reconciled**, **admitted**, **deferred**, **left pending** and **newly raised** separately. A queued rebuild is not admission; a linked screen is not closure. If zero decisions were submitted, say so and identify the exact blocker for each reviewed candidate. Never present local helper files, snapshots, planning or proposed actions as Layer 4 progress. Do not call triage enrichment unless a value was actually admitted.
