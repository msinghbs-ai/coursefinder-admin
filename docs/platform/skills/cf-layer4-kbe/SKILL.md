---
name: cf-layer4-kbe
description: Continuously reconcile all 17 current CourseFinder Layer 4 Review kinds directly through the Kimi Browser Extension sidebar on the authenticated Platform Admin web page. Use when asked to keep going through every parked Layer 4 item, clear all actionable work without Kimi Work, move admitted values into their destination fields, run layer4-kbe-continuous, or resume a visible sidebar batch. Covers AER and all current pills with verified existing UI actions, stored evidence, chat checkpoints and exception stopping rather than forced zero, SQL, bulk approval or repeated loops.
---

# CourseFinder Layer 4 — continuous direct KBE

Operate directly in the current authenticated Platform Admin tab through the Kimi Browser Extension sidebar. Do not require Kimi Work, local-agent remote control, GitHub, SQL, uploads or local checkpoint files.

Read [references/action-playbook.md](references/action-playbook.md) before category-specific decisions. Cover all 17 current kinds; coverage is not guaranteed closure of every item.

The finish line is **no currently actionable stored-evidence items remain after a complete pass and final refresh**, or a safety/authorisation stop occurs. Never force the queue to zero.

## Invoke

- `layer4-kbe-continuous` — run all eligible kinds continuously, By kind, until the finish line.
- `layer4-kbe-continuous resume` — resume only from a checkpoint visible in the current sidebar chat.
- Treat “keep clearing Layer 4”, “resolve everything AI can resolve” and equivalent requests as the continuous command.

Do not ask “shall I continue?” between items or kinds. Continue automatically within the user's mandate and existing UI permissions.

## Preflight

1. Open **Data pipeline → Layer 4 Review**. Confirm authentication, Platform Admin rank where AER is involved, enabled choices and the current pill contract. Stop on an unknown/renamed kind or choice.
2. Create one batch id `L4B-YYYYMMDD-HHMM`. Record start time, live total, kind counts and oldest-item setting. Use the batch id in every reason.
3. Use stored evidence only. No AI re-checks, Firecrawl, paid reads or new source acquisition without separate explicit authorisation. Do not interfere with concurrent reader, recovery or enrichment jobs.
4. Read page text/controls first. Screenshot only for unclear state or errors. Avoid long plans and repeated broad queue scans.

## Continuous loop

Repeat this loop without waiting for another user prompt:

1. **Select work:** use the resumed/current kind, otherwise choose the oldest pending kind with eligible stored-evidence work. Open **By kind** and that exact pill. Do not process providers or kinds indiscriminately.
2. **Snapshot:** record current stable refs, providers/subjects and the pending count. Never use changing row positions as identifiers.
3. **Qualify the route:** for each kind and materially different action route, submit one eligible existing choice and verify its result before repeating that route. Qualification for Course link, fee-check or scholarship refusal does not qualify another kind or scholarship Publish.
4. **Decide:** read the stored quote/link/proposed value/context and apply the playbook. Process oldest first, one item at a time; no select-all or generic bulk decision.
5. **Complete linked work:** Open course/adapter/central-pages and similar choices are navigation only. Finish the supported correction or approval in the destination UI, return to Layer 4 and verify closure.
6. **Verify:** confirm each exact ref leaves **Waiting for a person**. Refresh once only if needed. Do not open the failing **Decided** view or use SQL.
7. **Checkpoint:** post a compact consolidated checkpoint in this sidebar chat every 10 submitted decisions, every 20 reviews without a decision and at every kind transition. Include verified refs/choices, actual admissions, downstream work, new items and exceptions.
8. **Exhaust the kind:** when no eligible items remain, record its pending exceptions with owner/next action and move automatically to the next eligible kind. Do not re-review unchanged blockers.
9. **Finish the pass:** after every current kind has been passed, refresh once and reconcile counts. Process eligible newly raised work once, then stop. Do not chase an endless stream of new work.

If the first result on a route is uncertain, the ref remains waiting or the write fails, do not repeat it. Check whether the original action saved; retry a transient failure at most once with backoff. Stop the route or whole batch as reliability requires.

## Admission and completion contract

Report what actually happened, not what the choice was called:

- **Admitted/applied:** verify the actual course page, fee, scholarship, website, central-page value, counsellor correction, AER rows or other destination value saved under the existing rule.
- **Reconciled without admission:** a supported refusal, rejection or Keep decision can close an item without admitting a value; report it separately.
- **Downstream:** a queued read, search refresh, rebuild, onboarding retry or re-check is not a completed admission. Track its outcome separately.
- **Deferred:** Website not answering → Keep waiting and similar outcomes are not reconciled or admitted.
- **Left pending:** inadequate evidence, identity/ownership conflict, duplicates, policy judgement, unavailable role or rejected/uncertain writes remain pending with owner and next action.

For Course link Enter another address, distinguish an `edited_approved` page-address outcome from a held-fee read-again path. Never infer fee admission from either. For AER, record admitted, excluded, superseded and retained rows separately and follow D4 exactly.

Never overwrite a manual value/binding, publish from unquoted inference, archive from a reader failure, or approve to improve a metric.

## Exceptions, new work and resume

Maintain one exception register in the chat, keyed by stable ref and cause. Do not create new statuses.

- Reconcile a newly raised item once when the same evidence and rule still apply.
- If the same issue re-raises again, leave it pending with old/new refs where available, record a re-raise defect and move on.
- Queue an adapter rebuild or onboarding retry at most once under the playbook; repeated failure goes to platform review.
- Provider mergers require separate explicit approval for the exact provider/successor. CRICOS-data-only choices require existing policy or explicit operating authority.
- AER decisions require Platform Admin and one-item-at-a-time review; no generic bulk decision, re-read or spend.

Resume only while the consolidated checkpoint remains visible in this sidebar chat. Otherwise start a new batch from current queue state; never repeat a ref already absent or an uncertain archive/publish/approval/rebuild without verification.

## Stop conditions

Stop and preserve the checkpoint for:

- authentication or required-role loss;
- repeated uncertain writes or statement timeouts;
- a shared evidence/decision defect;
- unexpected consumer-visible changes;
- queue refs/counts that cannot be reconciled;
- a new/changed UI contract absent from the playbook;
- remaining work requiring separate source, spend, merger or policy authority.

## Final report

Return one consolidated report by kind:

- pending before/current and reviewed counts;
- decisions actually submitted and verified by existing choice;
- stable refs/evidence basis and ledger ids where exposed by the UI;
- values actually admitted/applied, with destination field/record;
- refusals/rejections reconciled without admission;
- downstream reads/refreshes/rebuilds/onboarding and deferred outcomes;
- new/re-raised items and remaining exceptions by cause, owner and next action;
- checkpoint location (this sidebar chat), elapsed time and AI/Firecrawl/new-source consumption;
- final live counts after one refresh.

State **reconciled**, **admitted/applied**, **deferred**, **downstream**, **left pending** and **newly raised** separately. Snapshots, navigation and proposed actions are not progress. If pending is not zero, state precisely which classes remain and why; never claim absolute clearance while actionable work or unresolved exceptions remain.
