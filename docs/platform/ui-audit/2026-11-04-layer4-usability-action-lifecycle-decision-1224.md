<!-- Platform Admin decision, received 4 Nov 2026 12:24 AEDT; recorded verbatim before code. -->

StudySearch — Layer 4 Complete Usability, Action Lifecycle and Audit Review

Platform Admin decision — 4 November 2026

Continue as the existing Integration Controller.

The Platform Admin attempted "Re-read from stored evidence" on RMIT Diploma of Commerce, CRICOS 111278B.

The original Layer 4 item remained visible without a clear acknowledgement, timestamp, processing state or result.

This demonstrates an incomplete user experience across the Layer 4 workflow.

Review and correct all 17 existing Layer 4 review kinds, description reviews and the new Human input needed interventions.

Read the canonical operating model, Layer 4 action playbook v6, SS-020, SS-021, the 06:30 human-assisted recovery decision and current Pilot implementation.

1. Investigate the actual RMIT re-read

Reconcile the live review item, recovery-action audit, corrected-read request, reader execution, completeness gate and current replacement state.

Establish:

- Whether the button submitted successfully.
- Whether an action audit record was created.
- Exact request timestamp and action ID.
- Whether the reader accepted or refused the correction.
- Whether the reader actually executed.
- Whether the source and evidence changed.
- Whether two dropped requirements remain unresolved.
- Whether the original item should remain pending.
- What the correct next action is.

Do not claim the re-read succeeded merely because a button was clicked.

Do not repeat an identical unsuccessful read.

Use existing issue fingerprints. Record a new issue only if the observed failure is not already tracked.

2. Introduce a shared action lifecycle

Every Layer 4 action must have a traceable outcome:

Requested → Accepted or refused → Scheduled if required → Executing → Completed, failed or awaiting input → Verified → Review resolved where appropriate.

Reuse existing state objects, action events and job outcomes.

Do not confuse:

- A requested action with a completed action.
- A completed reader execution with a valid extraction.
- A valid extraction with an approved Layer 4 decision.
- An approved decision with an admitted row.
- An admitted row with consumer publication.

3. Mandatory timestamps

Display meaningful timestamps on every review card:

- First entered Layer 4.
- Current review item created.
- Last updated.
- Last reviewer action.
- Last automated attempt.
- Last entered or re-entered review.
- Next scheduled action or retry.
- Decision completed, if applicable.
- Admission and publication verification, if applicable.

Use Australian date/time formatting with AEDT/AEST.

Preserve immutable historical events.

A corrected read must link to its predecessor and identify whether the original item was superseded, remains pending or was validly resolved.

Do not reset an item's original age merely because it was reprocessed.

4. Immediate action acknowledgement

After every reviewer action, show a durable result:

- Action accepted: reference and timestamp.
- Action refused: exact reason and permitted alternative.
- Job queued: job identity and next execution.
- Already requested: original action reference and current state.
- Recovery completed: actual verified result.
- Still incomplete: remaining failed requirements and next recommended action.
- Human input needed: link to the existing intervention.

Refresh must preserve this information.

The reviewer must not have to check database tables to understand what happened.

If an action is asynchronous, display its progress from authoritative persisted records.

Do not show success before the server confirms it.

5. Audit every existing review kind

Evaluate every action described in the current Layer 4 v6 playbook.

For each kind, document:

- Current actions and role permissions.
- Whether each action directly decides, navigates or schedules downstream work.
- Missing evidence or information.
- Actual success/failure response.
- Audit coverage.
- Current status and timestamps.
- Whether the item automatically progresses afterwards.
- Whether a reviewer is forced to reject because recovery is unavailable.
- Whether a repeated action causes wasted reads or duplicate work.

Correct shared defects centrally rather than building a different lifecycle for each kind.

6. Make review items genuinely actionable

Each card must show:

Issue: what is wrong or missing.

Evidence: source URL, stored evidence, current data and failed checks.

Recommended action: what a reviewer or autonomous recovery can do next.

Action controls: permitted decisions and recovery options.

Progress: previous attempts, latest result, owner, next action and timestamps.

Outcome: pending, returned, superseded, admitted, published or correctly excluded.

Keep technical diagnostics expandable rather than displaying raw JSON in the main card.

For mobile screens, avoid extremely long unstructured recovery-case listings.

7. University and kind navigation

Selecting a review-kind pill for a university must filter to that university's pending items of that kind.

Show:

- Exact pending review-item count.
- Items ready for judgement.
- Technical recovery items.
- Human input required.
- Oldest waiting item.
- Recent decisions and recovery outcomes.

Retain filters through refresh and pagination.

A total active-course count must not be presented as the number of outstanding review decisions.

8. Automatic downstream processing

After a successful correction, source submission, identity resolution or reviewer decision, the platform must automatically perform the next permitted action.

Examples:

- AER corrected read → completeness verification → review-ready.
- Official URL supplied → source validation → reader scheduled.
- Fee corrected → catalogue saved → projection verified.
- Scholarship eligibility confirmed → governed admission route → publication check.
- Adapter repaired → qualification → source processing.
- Counsellor correction saved → verify and close report.

If the downstream operation fails, park the affected work with its cause and recovery deadline.

Do not leave a completed reviewer intervention disconnected from its next pipeline stage.

9. Production-scale and mobile testing

Test representative records for all 17 kinds, plus descriptions and interventions.

Include:

- The RMIT Diploma of Commerce E13 example.
- Re-read accepted but still incomplete.
- Re-read refused.
- Duplicate action request.
- Successful corrected read.
- Superseded review item.
- Role-disabled action.
- Successful admission and publication.
- Re-entry after technical recovery.
- Refresh during an asynchronous operation.

Preserve current admission rules, manual locks, role permissions and item-level audit.

Maintain production-scale performance and phone-width support.

10. Reporting

Maintain an audit matrix in the existing Admin repository:

Review kind| Action gap| Evidence gap| Timestamp gap| Recovery works| Decision works| Production verified

Track:

- Items entering and re-entering Layer 4.
- Time waiting for human review.
- Time waiting for technical recovery.
- Actions requested, refused and completed.
- Automatic resumptions.
- Verified admissions.
- Consumer publication.
- Repeated no-yield actions.

Report per-kind exceptions with root cause, owner and next checkpoint.

11. Execution

Treat RMIT's missing action feedback as the first reproducible case, not as a one-off provider fix.

Prioritise:

1. Immediate action acknowledgement and persistent timestamps.
2. RMIT re-read outcome and automatic next action.
3. Shared lifecycle and action history.
4. All Layer 4 review kinds.
5. University kind filters and mobile readability.
6. End-to-end verification and operational reporting.

Use maximum safe parallel investigation while retaining one Integration Controller for integration and deployment.

Do not create a second Layer 4 system.

Do not alter admission authority, spending limits, manual locks or consumer API contracts without the existing approvals.

Acceptance: Every reviewer must know what action was taken, when it occurred, whether it succeeded, why an item remains pending and what can happen next.

The platform must resume processing automatically after valid interventions. A button click must never become an invisible or untraceable operation.