<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 05:18 AEDT (chat). Decisions E1, E14, E15 (option B), E11 (design; bounded pilot within a separately recorded ceiling), E12 (design and 5-course pilot subject to a recorded ceiling), E13 (build), D-B1, D-B2, D-B3 approved; D-B4 not approved. -->

StudySearch — Morning Execution Mandate and Platform Admin Decisions

Date: 2 November 2026

1. Executive mandate

Continue the existing StudySearch programme from the verified overnight checkpoint.

This instruction incorporates the Platform Admin's decisions on E1, E14, E15, E11–E13 and D-B1–D-B3.

Do not restart completed work or seek another general GO for actions expressly authorised below.

Read and follow:

- "docs/platform/nz-enrichment-brief/2026-11-02-overnight-completion-report.md"
- "docs/platform/nz-enrichment-brief/2026-11-01-consolidated-approval-pack.md"
- "docs/platform/nz-enrichment-brief/2026-11-01-provider-bulk-review-design.md"
- "docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md"
- "docs/platform/AGENT-OPERATING-MODEL.md"
- Pilot "CLAUDE.md"

Record these decisions verbatim in the Admin repository before implementation.

2. Platform Admin decisions — approved directions

E1 — Unsupported fee admissions

Decision: APPROVE the documented withdrawal of the 41 unsupported fee rows.

Conditions:

- Reconcile all 41 records against current live status and evidence.
- Confirm the exact approved IDs and original count-guarded scope.
- Do not touch the five excluded or independently supported fees.
- Use the existing authorised remediation path.
- Capture before/after counts and Website/Zoho effects.
- Preserve rollback capability.
- Stop if the reconciled scope differs materially from the approved pack.

Do not delete records or infer replacement fees.

E14 — Incorrectly admitted entry requirements

Decision: APPROVE withdrawal of the 105 affected Active entry rows across 18 courses.

Use the existing Catalogue → Entry requirements withdrawal controls as the preferred path.

Requirements:

- Verify all 105 row IDs and current status.
- Check the recorded count and checksum before starting.
- Withdraw one row at a time with an E14-specific reason.
- Verify each saved outcome and audit event.
- Confirm zero remaining Active E14 rows on the affected 18 courses.
- Preserve history and rollback capability.
- Verify Website and Zoho projections after settlement.

Do not use the SQL fallback unless the documented UI route cannot safely complete and separate authority is obtained.

E15 — Course-link data correction

Decision: APPROVE the documented E15 repair, including recommended option B for Part 2.

Scope:

- Part 1: the four affected TAFE courses.
- Part 2: Waikato WI0194 and MITO 4226, following option B in the consolidated approval pack.

Before application, verify the exact records, current official links, manual locks, existing primary addresses and rollback plan.

Use the already-deployed v2.15.398 correction path where supported.

Verify that:

- The correct official page becomes active and primary.
- Superseded automatic links are retired appropriately.
- Protected manual links remain unchanged.
- Course URLs and consumer projections match the intended outcome.
- No unrelated catalogue records are modified.

Stop if option B's exact operations or scope cannot be reconciled with the canonical pack.

E11 — RMIT international entry requirements

Decision: APPROVE the recovery design, not unrestricted processing.

First investigate whether the existing stored copies already contain the complete international qualification sections.

Reuse existing copies where valid.

Authorise a bounded, existing-copy pilot only where the actual number of AI reads and cost remain within a separately recorded ceiling.

No new paid page acquisition, uncontrolled full-provider re-reading or bulk rejection of the existing 298 items is authorised by this direction.

After a successful pilot, prepare the measured full-run scope and cost for approval.

E12 — QUT international entry requirements

Decision: APPROVE the international-only extraction design and five-course pilot, subject to the recorded cost ceiling.

Use the existing stored "requirements-international" content.

The pilot must demonstrate:

- No domestic ATAR or guaranteed-offer rows.
- Correct qualification and country scope.
- Explicit scales for every numeric score.
- No omitted routes caused by the six-row limit.
- Complete accounting of proposed and dropped rows.
- No admission of incomplete reads.

Do not automatically approve the existing 38 held items.

Production admission remains governed by D4 and individual review.

E13 — Entry-requirement completeness

Decision: APPROVE development of the whole-read completeness gate.

Retain the 59 previously approved reads unless they are independently identified as incorrect.

Implement and test:

- Hold a read when rows are dropped due to "over_row_limit".
- Detect joined requirements separated by the cap.
- Detect requirements belonging to sibling programme variants.
- Preserve configurable limits and provider-specific applicability.
- Prevent incomplete reads from reaching approval.

Test against existing stored evidence and isolated fixtures.

Do not globally raise the reader cap, re-read courses or incur additional AI charges without a separately authorised, measured rollout.

3. D-B1 to D-B3 — Provider-level bulk review

D-B1: APPROVED — Eligible-field policy

Adopt the policy defined in the provider bulk-review design.

Implementation order:

1. Country.
2. State/territory.
3. Campus.
4. Actual course delivery location.
5. Intake, with programme/campus/year-specific evidence.
6. English requirements, with course-level exceptions and exact scores/bands.

AER academic entry requirements remain excluded from bulk approval.

D-B2: APPROVED — Role boundary

- Platform Admin can apply authorised bulk changes.
- Other authorised reviewers can preview only.
- Manual locks and course-specific overrides remain protected.
- Every included course requires sufficient applicability evidence.

D-B3: APPROVED — Build and isolated fixture testing

Proceed with the governed implementation using the existing Layer 4 university view and admission/audit architecture.

Requirements:

- Deterministic preview.
- Exact eligible/excluded/protected counts.
- Course-level evidence and applicability.
- Idempotent bounded application.
- Per-course auditing.
- Conflict detection.
- Partial-failure handling.
- Verified destination outcomes.
- Reversible, documented remediation.
- Full test coverage.

Production bulk-write capability must remain disabled by default.

D-B4: NOT APPROVED

Production activation remains a separate Platform Admin decision following fixture tests, release verification and a supervised-provider assessment.

Do not interpret approval to build as approval to bulk-modify catalogue records.

4. Immediate implementation sequence

1. Reconcile live production with the overnight report.
2. Record these Platform Admin decisions in the Admin repository.
3. Execute E1 and E14 using their exact guards and authorised UI paths.
4. Execute the E15 repair after checking option B's exact scope.
5. Verify corrected consumer data and audit records.
6. Complete the E13 completeness gate and fixture tests.
7. Perform the authorised, cost-controlled QUT pilot only when its spend ceiling is explicitly recorded.
8. Prepare the RMIT recovery pilot using stored evidence.
9. Begin UR-18 bulk-review implementation with production application disabled.
10. Continue SS-016 acceptance walkthroughs and existing SS-004/SS-007/SS-014/SS-015 verification.

Independent work may proceed concurrently, but production writes and releases must be coordinated by one integrator.

5. Verification and governance

For every data remediation:

- Verify current IDs, counts, hashes and existing values.
- Record before-state evidence.
- Use the approved existing decision or correction route.
- Confirm each saved outcome.
- Check actual destination records and consumer projections.
- Retain audit and recovery evidence.
- Stop on count mismatch, unexpected updates or uncertain writes.

For every engineering release:

- Follow decision-before-code.
- Run the full suite with zero failures and skipped tests.
- Perform required dry runs.
- Verify migration/function checksums.
- Deploy through the approved Pilot workflow.
- Confirm live version and post-merge checks.
- Record change control and Replaces/Retires.

Consumer API shape changes and destructive operations remain under their separate existing gates.

6. Mandatory progress dashboard

At each substantial milestone, display:

StudySearch Progress — [AEDT date/time]

Engineering: X/15 completed and verified, X verifying, X remaining.

SS-016: X/17 accepted, X implemented awaiting acceptance, X remaining.

Layer 4: opening 1,870; current pending X; decisions verified X; admitted items X; Active destination rows X; exceptions X.

Data remediation:

- E1: X/41 withdrawn and verified.
- E14: X/105 withdrawn and verified.
- E15: X/6 course-link corrections verified.
- E11: recovery pilot status and measured cost.
- E12: X/5 pilot courses completed and measured cost.
- E13: completeness gate design/build/test/live state.

UR-18: design, fixture build, tested, deployed-disabled and production-enabled shown separately.

Release: version, commit, tests and live verification.

Show the exact movement since the previous checkpoint and the next three highest-priority actions.

7. Continue authorised execution

Proceed through approved work without asking for routine confirmation.

If one remediation fails or cannot be reconciled, stop that specific write path, preserve its evidence, and continue independent authorised work.

Do not bypass the cost ceiling, role restrictions, evidence gates or production activation controls.

Do not force the Layer 4 queue to zero.

Begin with live reconciliation and recording the Platform Admin decisions, then execute E1, E14 and E15 in bounded, auditable tranches. Continue E13 and UR-18 engineering in parallel where safe.

Write the full milestone result into the Admin repository before the concise chat checkpoint.