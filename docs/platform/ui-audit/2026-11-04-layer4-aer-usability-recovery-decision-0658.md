# StudySearch — Layer 4 AER Usability and Recovery Correction

Platform Admin decision: Correct two problems in the existing Layer 4 Review interface.

Coordinate this work with SS-020 Inbox performance remediation and the 06:30 human-assisted recovery design. Do not create another standalone review system.

## 1. Fix incomplete AER review actions

Current screenshot: UNSW Bachelor of Actuarial Studies and Bachelor of Actuarial Studies (Honours).

Both are held by E13 because requirements were dropped during extraction. Approve all and Approve except are disabled. Reject the read is the only available action.

Keep the E13 safety guard. Do not enable approval of incomplete reads.

Instead provide governed recovery actions:

- Re-read using the existing reader and stored evidence.
- Request additional official evidence or document.
- Ask the approved AI recovery mechanism to analyse the exact failure.
- Open a human-assisted intervention to enter or correct missing information.
- Reject the read when genuinely appropriate.

Use existing actions where possible and the common intervention capability where new actions are required.

For every recovery action, record the reason, affected rows, missing quotes, previous evidence, reviewer, new work-item status and next automatic operation.

The platform must automatically resume the correct reader after valid intervention. No SQL or manual scheduler invocation should be necessary.

Do not create repeated Layer 4 items for the same unchanged problem.

## 2. Correct AER pill navigation

When the operator selects a university's Entry requirements (AER) pill:

- Filter the main review panel to that university.
- Select only pending AER review items.
- Display the exact pending count in the heading.
- Do not substitute the university's total active course count.
- Distinguish review items from the number of proposed requirement rows.
- Preserve the selected university and kind through paging, refresh and saved decisions.
- Update the count immediately when an item is resolved or returned through an audited transition.

Selecting Course link, Held scholarship or University description must likewise show only that university's pending items of the selected kind.

Clicking the university name may continue to show all pending review kinds.

## 3. Improve incomplete-read presentation

For E13-held AER items display:

- Number of waiting rows.
- Number of dropped requirements.
- Exact completeness failure reasons.
- Links to stored evidence.
- Recommended technical recovery.
- Whether human input is necessary.
- Current recovery owner and next attempt.
- Last attempt result and status.

Group repeated reader failures into one actionable recovery case where existing rules permit.

Do not force a reviewer to reject accurate requirements because some rows failed extraction.

## 4. Performance and responsive design

Integrate with the current SS-020 Inbox query optimisation.

Use server-side filtering and pagination. Do not load all courses for a university simply to display two pending AER reviews.

Preserve existing role permissions, review decisions, audit history and phone-width behaviour.

## 5. Production acceptance

Validate using the two UNSW items shown in the screenshot and additional university samples.

Acceptance requires:

1. An E13-held item cannot be improperly approved.
2. The reviewer has a valid recovery action other than Reject.
3. Recovery creates a tracked, deduplicated operation with evidence.
4. The platform automatically retries when the dependency is resolved.
5. The university's AER pill shows the correct pending AER records.
6. Counts and filters remain correct after decisions and refreshes.
7. The Inbox loads within its existing performance limits.
8. All actions preserve Layer 4 and manual-binding protections.

Record changes, tests, release and production verification under the existing SS-020 and recovery workstreams.

**Expected outcome:** Layer 4 must help an operator resolve an incomplete read, not leave Reject as the only usable control. Selecting a university's review-kind pill must show precisely the outstanding decisions for that university and kind.