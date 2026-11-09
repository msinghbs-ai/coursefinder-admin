# StudySearch — Next Tranche: Controlled Bulk Review, Data Quality and UI Acceptance: Platform Admin direction (verbatim)

**Received:** 1 Nov 2026, 20:08 AEDT. Saved verbatim before implementation (operating model). Section 1 is a proposed disposition for ratification, not an approval (its own words).

---

# StudySearch — Next Tranche: Controlled Bulk Review, Data Quality and UI Acceptance

Continue the existing execution mandate using the latest verified Admin records.

## 1. Bulk review — decisions for implementation planning

Use the recommendations below as the proposed disposition for Platform Admin ratification. Do not treat this prompt as bypassing an approval gate.

- D-B1: Adopt the section 3 eligible-field design, with country, state, campus and delivery location first. Intake and English require stricter scope-specific eligibility. Academic entry (AER) remains excluded.
- D-B2: Platform Admin-only application; other authorised reviewers may preview.
- D-B3: Prepare and test the implementation using isolated fixtures, with production bulk writes disabled.
- D-B4: Do not activate production bulk settlement until a separate explicit approval following the tests and a supervised-provider assessment.

Follow:
`docs/platform/nz-enrichment-brief/2026-11-01-provider-bulk-review-design.md`

Confirm that the proposed bulk path can safely reuse existing admission and audit functions for catalogue gaps, including records that have no pending Layer 4 item. Do not assume the current decision RPC supports those records. Resolve that contract before implementation.

Do not perform unauthorised bulk writes.

## 2. Priority — Existing data-integrity exception E1

Investigate the 46 historically admitted fee rows documented in the exception decision pack.

Verify:
- Their current active status.
- Evidence and fee-year validity.
- Consumer impact.
- Whether any rows have been superseded.
- The exact count-guarded remediation and rollback scope.

Prepare the final safe remediation for the required approval. Do not withdraw or overwrite values merely to reduce the exception count.

## 3. RMIT, QUT and the six-row limitation

**E11 — RMIT**

Preserve the 298 existing held items.

Validate the international page-view retrieval and identity checks using the approved read-only methods.

Do not acquire approximately 300 new pages or initiate paid AI reads without a cost ceiling and explicit authority.

**E12 — QUT**

Do not approve incomplete international rows from the existing capped reads.

Validate a proposed international-only extraction method, including complete qualification, score and scale coverage.

Prepare a bounded pilot and consumption estimate.

**E13 — Entry row cap**

Keep the 59 already approved items and 354 verified Active rows unchanged.

Investigate whether the six-row cap prevents complete entry-route publication.

Compare a representative sample of full stored pages against the rows admitted.

Propose a configurable cap and whole-read completeness gate, with tests before changing production settings.

Do not initiate paid re-reading under this mandate.

## 4. SS-016 — Complete operational usability remediation

Prioritise the unstarted UR-01, UR-02, UR-03 and UR-17.

Correct:
- Alert-delivery guidance and receipt verification.
- Pipeline Operator versus PIM Admin action permissions.
- Synchronisation of Pilot/Admin SOP mirrors.
- Specialist role-guide links and operational handoffs.

Run acceptance testing for the six technically implemented findings: UR-04, UR-05, UR-06, UR-07, UR-09 and UR-13.

Mark each Accepted only after its specific walkthrough passes. Keep the remaining findings in the canonical register.

## 5. Continue Layer 4 settlement

Continue all currently actionable evidence-supported reviews under the existing v5 playbook.

Exclude RMIT, QUT, ANU and other evidence/interpretation blockers until their applicable gates are satisfied.

Do not let blocked groups prevent progress through unrelated eligible kinds.

Keep one active controller per review ref, verify every outcome and preserve the safety-stop rules.

## 6. Progress reporting

Every substantial checkpoint must show:

**Engineering:** X/15 completed and verified, X remaining.

**SS-016:** X/17 accepted, X technically implemented awaiting acceptance, X remaining.

**Bulk review:** Design / approved / implemented / fixture tested / production enabled, showing each stage separately.

**Layer 4:** opening, current pending, verified decisions, admitted items, Active destination rows, exceptions and new arrivals.

**Data integrity:** E1 affected/verified/remediated, E11/E12 awaiting authority, E13 completeness status.

For each milestone, identify the next action, owner, exact commit or release and acceptance evidence.

## 7. Execution

Reconcile live state and the current register first.

Proceed with authorised read-only investigation, code preparation, fixture testing, documentation remediation and existing permitted engineering releases without routine confirmation.

Record genuine approval boundaries in one consolidated decision pack.

Maintain full-suite green, deployment checksum verification, migration safeguards and production read-back.

Do not declare usability complete or production-ready on implementation evidence alone.

**Immediate order:** assess E1 consumer integrity, complete SS-016 operational-guide corrections and acceptance, finalise the bulk implementation contract, then continue eligible Layer 4 settlement and approved engineering work.

Record the outcomes in the Admin repository and provide the next concise progress dashboard.