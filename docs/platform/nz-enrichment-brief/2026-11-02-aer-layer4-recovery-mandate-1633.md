# StudySearch — CF-247 Layer 4 AER Recovery and Governed Admission

## Platform Admin Execution Mandate — 2 November 2026

Integrate this mandate into the ongoing CF-247 Academic Entry Requirements development programme.

### 1. Read the investigation

Read the newly committed Admin record:

`docs/platform/nz-enrichment-brief/2026-11-02-aer-layer4-admission-review-and-playbook.md`

Also read:

- `docs/platform/AGENT-OPERATING-MODEL.md`
- `docs/platform/ENTRY-REQUIREMENTS.md` — Draft 1.2
- `docs/platform/AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md`
- `docs/platform/nz-enrichment-brief/2026-11-02-morning-execution-mandate-and-decisions.md`
- The latest StudySearch execution register and applicable Layer 4 action playbook.

Use the current production queue rather than assuming earlier counts remain unchanged.

### 2. Objective

Investigate, classify, correct and facilitate the governed settlement of pending AER Layer 4 reviews.

The objective is not simply to reduce pending items. It is to ensure that the maximum number of accurate, source-supported academic entry requirements becomes available for counselling.

Avoid repeated manual requests asking the Platform Admin to investigate individual university records.

### 3. Current findings

The verified baseline from the live queue is:

- 539 pending AER reviews.
- 499 course first-read reviews.
- 40 provider-matrix first-run reviews.
- 353 course reviews with dropped extraction rows.
- 162 course reviews affected by `over_row_limit`.
- 258 affected by `score_without_basis`.
- 224 affected by `quote_not_on_page`.

These groups overlap.

RMIT has 298 pending course reviews. QUT has 38, all showing material reader-drop issues.

ANU has 22 pending provider-source reviews. UWA has one pending matrix review proposing 177 rows with eight dropped.

Reconcile these figures against live state before processing.

### 4. Classify every pending item

Build a read-only review readiness assessment grouped into:

**A — Evidence-complete, review-ready**

- Correct provider/course identity.
- Official stored evidence available.
- Complete published requirements accounted for.
- Correct qualification, level, country and audience.
- Exact source-supported quote and grade basis.
- No unresolved material extraction omissions.
- No active duplication or supersession conflict.

These items may be recommended for individual admission through Layer 4.

**B — Correctable reader defect**

Examples:

- Missing score basis.
- Failed quote matching.
- Incomplete columns.
- Six-row extraction truncation.
- Unrecognised global qualifications.
- Incorrect programme variants.

Classify the root cause and repair through existing governed engineering routes.

**C — Insufficient evidence**

- Source unavailable or stale.
- Incorrect source identity.
- Incomplete table.
- Uncertain qualification applicability.
- Missing official minimum.
- Conflicting editions.

Return or hold for evidence under the existing playbook.

**D — Invalid or superseded**

- Duplicate old read.
- Wrong provider/course.
- Superseded edition.
- Unrelated content.
- Invalid entire read.

Recommend rejection only when the reason is demonstrated and recorded.

**E — Verified no published requirement**

Only use this outcome where the official stored source has been checked and genuinely contains no applicable published requirement.

A failed reader is not proof that the provider publishes nothing.

### 5. Correct shared defects before large-scale admission

Prioritise the E13 whole-read completeness gate and related extraction defects.

Ensure:

- No material academic requirements are silently lost due to `over_row_limit`.
- A six-row result is never treated as complete solely because six rows were retained.
- Joined requirements and sibling programme variants are identified.
- Grade scales and source quotes remain validated.
- International, domestic and course-specific applicability is preserved.
- English-test content is not incorrectly admitted as academic entry requirements.
- Legitimate alternative pathways are not discarded.
- Fixes are reusable across providers, not hardcoded per university.

Use existing stored evidence first.

Do not initiate paid re-reads or broaden the read scope without satisfying the existing approval and cost controls.

### 6. Prioritise provider-level reviews

Examine the 40 pending provider-matrix reviews.

Start with potentially high-impact, evidence-complete sources.

Assess ANU's 22 qualification-specific reviews independently, preserving each qualification's published scope.

For UWA, reconcile:

- The one pending provider review.
- 177 proposed rows.
- Eight dropped rows.
- Existing non-active matrix records.
- Duplicates and grading scales.
- Country and qualification coverage.
- Actual Layer 4 status and edition handling.

For zero-row provider reviews, prove that the correct official rendered source publishes no applicable matrix before accepting a no-table outcome.

Do not assume a successful reader run is automatically approvable.

### 7. RMIT and QUT special handling

**RMIT — E11**

- Reconcile all 298 pending reviews.
- Check source identity and stored-copy completeness.
- Protect previously withdrawn E14 rows from re-admission.
- Correct programme and qualification applicability.
- Recover global IB/GAC and country-related reader gaps through the separately approved design.
- Do not bulk-reject the 298 items.
- Follow the E11 cost-ceiling and pilot requirements.

**QUT — E12**

- Analyse all 38 pending course reviews.
- Treat material row-limit and quote/basis losses as completeness blockers.
- Distinguish domestic ATAR rules from international admissions.
- Use the approved international-only pilot after its required spending ceiling is recorded.
- Do not automatically approve existing incomplete reviews.

### 8. Layer 4 decision execution

Preserve the current authorised Layer 4 workflow.

Before every decision:

1. Confirm the item remains pending.
2. Reconcile the current source and stored evidence.
3. Check for another reviewer or newer read.
4. Verify all applicable academic rules and extracted rows.
5. Select the correct existing decision action.
6. Save one decision through the authorised interface.
7. Confirm the decision persisted.
8. Verify the destination canonical records.
9. Verify consumer resolution where applicable.
10. Record the audit reference and outcome.

Do not approve AER through SQL, generic bulk approval or migration-based status changes.

Do not treat this mandate as an authorisation to bypass human Layer 4 decisions.

Claude should prepare evidence-backed recommendations and coordinate with the dedicated Layer 4 reviewer. It may submit decisions only where the existing role permissions, playbook and explicit execution authority permit them.

### 9. Continuous review-readiness validation

Extend the AER continuous assurance design so the queue is automatically classified as:

- Review-ready.
- Reader correction required.
- Evidence required.
- Superseded/invalid.
- Awaiting authorised human review.

Maintain persistent root-cause fingerprints and links to affected providers/courses.

The same reader defect should be repaired once and tracked across all affected reviews.

Avoid reopening settled reviews without a demonstrated source or policy change.

### 10. Reporting

Use the existing StudySearch Admin reporting channel.

Report:

- Pending AER items.
- Reviewed items.
- Approved and edited-approved.
- Rejected or returned.
- Blocked by reader defects.
- Blocked by missing evidence.
- Active destination rows.
- Consumer-resolvable course improvements.
- Review throughput.
- Remaining Layer 4 work.
- Reader defects fixed.
- Exact approval/cost gates.

Keep decision counts separate from actual improvements in verified academic coverage.

### 11. Execution order

1. Reconcile the current live queue and review evidence.
2. Validate E13 implementation and deployed completeness behaviour.
3. Classify all pending AER reviews by readiness.
4. Prioritise safe, complete provider reviews.
5. Prepare and route evidence-complete course reviews.
6. Correct shared reader defects.
7. Follow the separately authorised RMIT and QUT pilot paths.
8. Reconcile destination records and consumer results.
9. Update the existing execution register and AER progress dashboard.

Continue authorised non-conflicting work autonomously.

Escalate only genuine evidence, spending, admission-authority or production-approval blockers.

### 12. Completion criteria

- Every pending item has a current, evidence-based readiness classification.
- Material incomplete reads cannot be admitted as complete.
- Shared reader problems are tracked and remediated systematically.
- Safe review candidates are available to authorised reviewers with clear recommendations.
- Saved Layer 4 decisions are verified individually.
- Incorrect and superseded data does not re-enter active catalogue records.
- Consumer-visible academic requirements remain traceable to authoritative sources.
- Progress is continuously measured without requiring the Platform Admin to identify each missing requirement manually.

**Proceed with the review-readiness assessment and all currently authorised corrective work. Do not force the AER queue to zero or circumvent Layer 4 governance.**