<!-- Platform Admin observation, received 4 Nov 2026 13:00 AEDT; recorded verbatim before code. Extends the 12:24 decision (same RMIT case, IQ-00279). -->

# StudySearch — Layer 4 Re-read Transparency, Audit and Automatic Resumption

**Platform Admin observation — 4 November 2026**

A reviewer selected **Re-read from stored evidence** for RMIT Diploma of Commerce, CRICOS 111278B, in Layer 4 AER.

The item remained in the queue, and the UI provided no visible confirmation, updated timestamp, recovery status or result.

This is an operational usability and traceability defect.

Continue the existing SS-019, SS-020, SS-021 and human-assisted recovery workstreams. Do not create a separate recovery mechanism.

## 1. Investigate the actual request

Trace the specific RMIT item from the browser action through:

UI → recovery action → stored work item → scheduled reader → execution result → E13 validation → Layer 4 review state.

Determine whether the click:

- Failed silently.
- Was accepted but deferred.
- Was refused by an existing gate.
- Created a queued recovery.
- Ran but reproduced the original error.
- Produced a corrected replacement read.
- Was deduplicated against an existing request.

Record the actual cause using the existing integration issue system.

Do not assume that a visible pending item means the re-read failed.

## 2. Record immutable lifecycle events

Every Layer 4 and recovery transition must have:

- Original item ID.
- Provider and course ID.
- Entered Layer 4 timestamp.
- Recovery request timestamp.
- Requesting actor.
- Recovery operation ID.
- Reader start and completion timestamps.
- Attempt number.
- Outcome and error classification.
- Original and replacement read IDs.
- Re-entered Layer 4 timestamp where applicable.
- Current state and next eligible action.

Preserve history across re-reads, supersession and decisions.

Do not overwrite the original entry timestamp.

Use existing audit records and work-item contracts where possible.

## 3. Provide immediate button feedback

After selecting Re-read from stored evidence, display the authoritative result returned by the server.

Examples:

- **Recovery queued — 12:09 AEDT**
- **Already queued — existing request retained**
- **Recovery deferred — daily limit reached**
- **Recovery refused — unchanged evidence and reader**
- **Recovery completed — still held under E13**
- **Recovery completed — replacement read ready for review**

Never display a success message until the server has confirmed the corresponding operation.

If no operation was accepted, display the refusal reason and an actionable next step.

## 4. Add an audit timeline to each Layer 4 card

Show a compact summary by default:

- First entered Layer 4.
- Current status.
- Last reviewer action.
- Last recovery attempt and result.
- Next eligible retry.
- Waiting duration.

Provide an expandable event history showing all requests, reads, validation outcomes, supersessions and decisions.

Display dates in the user's Australian timezone, including AEDT/AEST as appropriate.

## 5. Automatic state reconciliation

When a recovery completes:

- Refresh the affected item and counters.
- Link any replacement read.
- Mark the previous read as superseded only through its authorised transition.
- Show whether the new read is complete.
- Enable approval only if the E13 and other admission guards pass.
- Preserve pending status if a human decision is still required.

The original item must not disappear merely because a re-read was requested.

## 6. Prevent duplicate and ineffective retries

Repeated clicks must return the existing operation while it is queued or running.

For unchanged evidence and unchanged reader logic, apply bounded retry and the appropriate technical-recovery or human-intervention route.

Do not repeatedly spend credits on the same deterministic failure.

Continue other provider and course processing.

## 7. Verify the RMIT example

Use the exact Diploma of Commerce review item from production.

Reconcile the clicked action against the existing audit and job history.

Report:

| Field | Verified value |
|---|---|
| Review item/reference | |
| Original entry time | |
| Re-read request time | |
| Operation ID | |
| Started/completed | |
| Actual outcome | |
| Current E13 reason | |
| Next permitted action | |

If there is no corresponding action record, identify the missing UI-to-server hand-off.

## 8. Acceptance

Demonstrate in the deployed Layer 4 Inbox that:

1. Every recovery click returns visible feedback.
2. Original and re-entry timestamps are preserved.
3. The recovery event has an immutable audit reference.
4. Deferred and refused actions explain why.
5. Repeated clicks cannot enqueue duplicates.
6. Completed recovery automatically updates the card.
7. Corrected reads become eligible for authorised admission.
8. Failed reads retain their evidence and a usable next action.
9. All review actions remain role-gated and auditable.
10. Existing course and provider processing continues independently.

Update the existing execution register and UI guide. Complete full release and production verification.

**Required outcome:** A reviewer must always know what happened after pressing Re-read, when it happened, why the item is still pending, and what action will resolve it.