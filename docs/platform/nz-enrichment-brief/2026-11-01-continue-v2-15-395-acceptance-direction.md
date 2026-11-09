# StudySearch — Continue v2.15.395 Release, UI Acceptance and Layer 4 Settlement: Platform Admin direction (verbatim)

**Received:** 1 Nov 2026, 21:02 AEDT. Saved verbatim before implementation (operating model).

---

# StudySearch — Continue v2.15.395 Release, UI Acceptance and Layer 4 Settlement

## Executive mandate

Continue the existing StudySearch development programme without restarting completed work or requesting another general GO.

Follow the canonical Admin operating model, current execution register, Pilot `CLAUDE.md`, SS-016 usability review and the Layer 4 action playbook.

Maintain the existing engineering, usability and Layer 4 progress dashboards separately.

## 1. Complete release v2.15.395

The release contains UR-01, UR-02, UR-03 and UR-17.

The full test suite was running at the previous checkpoint. Do not assume it passed.

Complete the existing release procedure:

1. Confirm the complete test suite passed with zero failures and skipped tests.
2. Regenerate the test register.
3. Verify SOP content fingerprints and source-release metadata.
4. Follow existing change-control and merge requirements.
5. Deploy through the approved Pilot workflow.
6. Confirm the deployed version and required function checksums.
7. Inspect the affected live Guides and SOP screens.
8. Synchronise and verify the Admin SOP mirrors.
9. Record the actual release, tests and production-verification evidence in Admin.

Do not mark UR-01, UR-02, UR-03 or UR-17 accepted merely because the release deployed.

## 2. Correct the misleading role-denial message

Investigate the server message that incorrectly says Platform Admin is required when PIM Admin is actually authorised.

Confirm the effective server-side role check for the specific control.

Correct only the message, not the permission boundary.

Acceptance:
- Pipeline Operator receives an accurate denial.
- PIM Admin succeeds where authorised.
- Platform Admin retains the required higher-level controls.
- No permission expansion occurs.

Add the correction to the smallest suitable existing release or follow-up release.

## 3. SS-016 — Execute acceptance walkthroughs

Six previously implemented findings are awaiting acceptance:

UR-04, UR-05, UR-06, UR-07, UR-09 and UR-13.

Now also assess UR-01, UR-02, UR-03 and UR-17 once v2.15.395 is live.

For each finding, record:

- Expected operational behaviour.
- Actual result.
- Role used.
- Evidence and destination.
- Pass, Fail or Insufficient Evidence.
- Defect and corrective action where applicable.

Prioritise real workflow completion over documentation or version-stamp checks.

Test:
- Layer 4 traversal beyond 200 items.
- Evidence/source visibility.
- Actual saved decision and destination outcome.
- Deep-link navigation and state restoration.
- Retired automation controls.
- Migration checksum refusal and safe replay.
- Alert guidance and delivery/receipt distinction.
- Operator/PIM Admin role boundaries.
- SOP mirror synchronisation.
- Specialist guide navigation.

Use isolated fixtures or appropriately authorised sessions for write-path tests. Do not modify production catalogue data merely to demonstrate a test.

## 4. E14 — Controlled entry-row withdrawal

The Entry requirements screen already provides a reason-gated withdrawal route.

Preserve this as the preferred remediation method rather than direct SQL.

Before withdrawing any of the 105 rows:

1. Reconcile the exact current row IDs and statuses.
2. Verify why each row is invalid or superseded.
3. Confirm the intended consumer-visible effect.
4. Ensure the correct role is authorised.
5. Prepare a count-guarded before/after reconciliation and rollback strategy.
6. Obtain the specific Platform Admin approval required by E14.

Do not interpret this mandate as authority to withdraw the 105 rows.

Keep the SQL paste path as a governed fallback only.

## 5. Continue eligible Layer 4 settlement

Resume evidence-supported decisions using the canonical v5 playbook and latest batch checkpoint.

Do not repeat previously saved audit events.

Continue through eligible kinds while preserving holds for unresolved RMIT, QUT, ANU and other interpretation/source defects.

Do not use bulk AER decisions, SQL, paid AI reads or source acquisition to accelerate queue reduction.

If a separate ChatGPT browser controller is operating, coordinate exclusive ownership of refs.

## 6. Bulk provider review — UR-18

Continue the existing design and test planning without enabling production bulk writes.

Prioritise country, state, campus and delivery location.

Intake and English remain evidence- and scope-dependent.

AER remains excluded.

Preserve Platform Admin-only apply rights and the separate production activation gate.

Validate that catalogue gaps without an existing Layer 4 review item can be handled safely through an approved admission contract.

Do not assume existing review functions already support such records.

## 7. Mandatory progress dashboard

Every substantial checkpoint must begin with:

**StudySearch Progress — [AEDT date/time]**

Engineering: X/15 completed and verified; X verifying; X in progress.

SS-016: X/17 accepted; X implemented awaiting acceptance; X remaining.

UR-18: Design / build / fixture-tested / production-enabled.

Layer 4: opening pending, current pending, decisions verified, admitted items, Active destination rows and exceptions.

Current release: version, test results, deployment state and production verification.

Current work and next milestone.

Report changes since the previous checkpoint, not just cumulative figures.

## 8. Execution order

1. Finish and verify v2.15.395.
2. Synchronise Admin SOP mirrors and complete the release record.
3. Resolve the role-denial message.
4. Begin SS-016 end-to-end acceptance walkthroughs.
5. Continue eligible Layer 4 settlement without overlapping another controller.
6. Prepare the E14 withdrawal approval pack.
7. Continue UR-18 fixture implementation only within the recorded approval boundaries.
8. Maintain SS-004, SS-007, SS-014 and SS-015 observation windows.

Proceed automatically through authorised work.

Do not stop for routine confirmation, but preserve mandatory approval and safety boundaries.

At the next checkpoint provide exact release commits, live verification results, accepted UR findings, any new Layer 4 decisions, and the remaining work.

Record the full result in the Admin repository before the concise chat update.