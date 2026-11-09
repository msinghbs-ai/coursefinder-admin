# Layer 4 release scope and uncleared filter pills

Date: 30 October 2026  
Scope: explain Admin `v2.15.373`, available `v2.15.374`, and why the Layer 4 filter pills remain after the bounded Skill qualification. Read-only explanation; no queue, decision, catalogue or schema changes.

## Short answer

The application releases and the triage Skill are separate. Neither Admin release is a bulk Layer 4 clearance feature, and the successful Skill run was deliberately limited to **one kind and at most five decisions**. It processed five `fee_check` items only. Course link, Held scholarship, AER and every other kind were outside that run.

The filter pills are **category selectors**, not bulk-clear buttons. Selecting one displays that work; a person or an authorised UI workflow must still make and verify an evidenced decision for each item.

## What the two Admin versions cover

### `v2.15.373` — W34/W35 admin-read performance and visibility

Release commit: `b74abefbfe893dd4a3ca9a953260bbeedb79476b`.

- Cached course-coverage totals, with snapshot age/stale display and live drill-downs.
- Page-first reads for Providers, Courses and Pipeline jobs, preserving the existing fields, rows, ordering and totals.
- Cached snapshots for toolset notices, scholarship publishability and field-coverage overview figures, with snapshot timestamps and stale markers.
- Actual start/finish visibility for **Why values are missing** gap-cause runs.
- Permissions, admission/publication behaviour and the consumer API are unchanged.

This version makes slow admin reads cheaper and their freshness clearer. It does not submit Layer 4 decisions or drain any filter pill.

### `v2.15.374` — AER D4 supersession and D6 adapter-measures authorisation

Release commit: `a50aeb8dc8c18590e7def76dbb258a08128b4a6d`.

- Under AER **Approve except**, an active row is superseded only when an approved replacement with the same identity exists.
- An active row whose replacement is excluded, or which the new read does not carry, remains active and untouched.
- Conflicting approved replacements hold the whole decision with nothing changed; a course page with active rows also holds **Approve except**.
- Adapter measures now enforce the intended claims-based rank-5-or-above API access check.
- The consumer API is unchanged.

D4 changes how an AER decision is applied **when someone submits one**. It does not create those decisions, and its conflict/held rules can correctly leave an item waiting. D6 is unrelated to queue clearance.

## Why Course link, Held scholarship and the other pills remain

Batch `L4B-20261030-0938` used the Skill's bounded **By kind qualification** workflow:

- one selected kind: `fee_check` / **Fee fails the check**;
- no more than the 10 oldest items reviewed;
- no more than five decisions;
- no provider-wide or full-queue scan;
- no other kind processed.

Five real Inbox decisions were independently verified. That qualifies the fee-check/flag-release route only; it does not qualify the course-link, scholarship, AER, archive, adapter or other action routes.

The remaining categories require their own item-level evidence and existing UI choices. For example:

- **Course link:** keep the held official page, use a proven replacement, or enter a verified address; identity conflicts stay pending.
- **Held scholarship:** publish only with proof of the scholarship, benefit, provider and international eligibility; otherwise use the supported non-international/not-a-scholarship outcome where the evidence permits.
- **AER:** make the applicable entry-requirements decision under the route's own rules; conflicts can remain held.

A pill's count therefore falls only when waiting items in that category are actually decided and leave the queue, or when unrelated background work changes the queue. Clicking the pill itself changes neither.

## Screenshot reconciliation: Fee fails the check `(5)`

The screenshot's five fee items and total of 2,745 do not agree with the independently audited post-batch state:

- five Inbox events `25591`–`25595` exist for the five fee decisions;
- all five source flags remain released;
- the independent live queue check found **zero** `fee_check` items;
- the checkpoint completion total was **2,740**, while other live category movement showed that global totals are not attributable solely to this batch.

Accordingly, the screenshot is a stale or timing-mismatched display, **not evidence that the five items re-raised**. Do not submit those five decisions again merely because the old window still shows them.

1. Click **Reload** to move the open Admin window to `v2.15.374`.
2. Click **Refresh** in Layer 4 Review and reconcile the category counts.
3. If Fee fails the check still shows five after that, treat it as a reader/display investigation: capture the current stable UI refs and compare them with the already-decided refs before any further action.

Reloading and refreshing update the client and its data view; they do not clear Course link, Held scholarship or any other category.

## Safe continuation

For a different kind, use a new bounded UI run and verify that kind's first saved decision before continuing. Do not infer every route is qualified from the successful fee batch, and do not use select-all approval to make counts fall. This explanation does not authorise full-queue clearance, direct canonical writes or course-link apply-path changes.

## Sources

- Pilot `docs/release-notes/v2.15.373.md` and release commit `b74abefbfe893dd4a3ca9a953260bbeedb79476b`.
- Pilot `docs/release-notes/v2.15.374.md` and release commit `a50aeb8dc8c18590e7def76dbb258a08128b4a6d`.
- Admin `docs/platform/nz-enrichment-brief/2026-10-30-layer4-batch-0938-verification.md`.
- Admin `docs/platform/skills/cf-layer4-triage/SKILL.md`, **Qualify the write path by kind**.
- Admin `docs/platform/skills/cf-layer4-triage/references/action-playbook.md`, category rules.
