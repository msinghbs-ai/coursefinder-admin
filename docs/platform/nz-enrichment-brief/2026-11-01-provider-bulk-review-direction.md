# Priority 1A — Provider-Level Bulk Review and Settlement: Platform Admin direction (verbatim)

**Received:** 1 Nov 2026, 19:42 AEDT, with the renewed execution mandate. Saved verbatim before any design or implementation (operating model).

---

Priority 1A — Provider-Level Bulk Review and Settlement

Objective

Extend the existing StudySearch Layer 4 Review interface to support efficient, evidence-backed bulk settlement of common course attributes for the same provider.

Many courses share institutional rules and information. Reviewers should not need to repeat identical decisions across hundreds of courses when the authoritative evidence is common and the correct applicability scope has been established.

Implement this within the existing Layer 4 interface, without creating a separate review console.

1. Eligible bulk-review categories

Support controlled bulk settlement for:

Field| Shared evidence / applicability requirements
Country| Verified provider/campus country and exact course delivery location
State / territory / region| Official campus address, location and state mapping
Campus| Registered or officially published campus and course-campus relationship
Course location| Actual delivery campus or mode, not provider headquarters
Intake| Official provider-wide or course-group intake calendar, including year, term and campus applicability
English requirements| Official provider-wide policy, with the exact qualification/test, score, band minimum, applicable level, programme and country rules

Bulk processing must operate on the precise group of courses covered by the evidence, not automatically on every course belonging to the provider.

2. Bulk-review user interface

Inside the existing Layer 4 Review screen, implement:

1. Group by provider and review kind.
2. Display the authoritative shared evidence and its capture date.
3. Show the proposed common value.
4. List all affected courses with course code, title, study level, campus and current value.
5. Identify exceptions and mismatches.
6. Allow the reviewer to select or exclude individual courses.
7. Display manual locks and existing values.
8. Preview changes and expected admissions before submission.
9. Require an explicit confirmation with an auditable reason.
10. Show the actual results after execution.

Include a summary such as:

Provider: Example University

- Candidate courses: 125
- Eligible under shared evidence: 112
- Excluded due to exceptions: 8
- Protected manual values: 5
- Proposed changes: 112
- Expected downstream actions: 0

Do not present the candidate count as the confirmed eligible count.

3. Applicability and evidence rules

Before a bulk group qualifies:

- Confirm provider identity and official evidence.
- Check current registered campus and actual course delivery location.
- Match each course's relevant campus, location, mode and study level.
- Verify course-specific overrides and exclusions.
- Preserve existing manually approved or manually bound values.
- Validate current versus proposed values.
- Ensure the stored evidence supports every included course.
- Exclude ambiguous, unsupported or conflicting records.

For English requirements, never apply one provider-wide IELTS/PTE/TOEFL score to every programme if professional accreditation, study level, faculty, country or course-specific requirements differ.

For intakes, do not assume all courses share the same commencement dates. Distinguish annual dates from recurring terms and campus-specific availability.

Never infer a delivery location from a provider's registered address alone.

4. Safe bulk execution

Implement a two-stage process:

Stage A — Preview and validate

- Produce a deterministic eligible-course list.
- Record evidence identity, scope and proposed values.
- Identify protected and excluded records.
- Display the expected affected count.
- Validate current values and relevant manual locks.

Stage B — Apply and verify

After authorised confirmation:

- Revalidate the selected records against the current state.
- Apply only qualified changes.
- Use bounded batches with an idempotent operation key.
- Record an audit outcome per affected course.
- Report applied, unchanged, excluded, conflicted and failed records separately.
- Support safe retry without duplicate writes.
- Verify the actual destination values after completion.

A failed or partially completed bulk operation must not be reported as fully successful.

5. Governance and approval

The existing v5 playbook prohibits generic bulk approvals, particularly AER approvals.

Therefore:

- Do not activate bulk settlement under the present mandate alone.
- Produce an Admin decision record and obtain the required Platform Admin approval for the exact bulk-action policy and role boundary.
- Preserve AER's existing one-item-at-a-time approval rule until a separate, explicitly approved D4-compatible policy replaces it.
- Never bulk-approve AER matrices, interpretation-sensitive scores or other high-risk data merely because the provider is shared.
- Do not use direct SQL to bypass the existing Layer 4 decision and admission rules.
- Do not create a second admission system.
- Reuse existing evidence provenance, validation, row-lock protection, audit and rollback mechanisms.

The feature should distinguish low-risk common metadata from high-risk academic admission requirements.

6. Acceptance tests

Test at least:

- One provider with 100+ eligible courses.
- Multiple campuses and states.
- Online and on-campus delivery.
- Mixed undergraduate and postgraduate requirements.
- Course-specific English exceptions.
- Intake dates that differ by programme.
- Existing manual values and locked records.
- Concurrent reviewer changes.
- Partially failed and retried operations.
- A stale shared-evidence version.
- Correct consumer visibility after admission.

Validate actual changes in an isolated fixture before any authorised production activation.

7. Expected business outcome

Reduce repetitive manual Layer 4 work while maintaining the same source quality, admission rules and auditability.

Track:

- Number of providers reviewed.
- Candidate and eligible courses.
- Fields successfully admitted.
- Exceptions excluded.
- Manual values protected.
- Time spent per 100 records.
- Error or rollback rate.
- Estimated manual decisions avoided.

Do not count projected time savings as realised savings.

8. Integration with existing work

Add this capability to the single StudySearch execution register as a governed enhancement to Layer 4 operability, linked to SS-016.

Prioritise the design and scope assessment alongside the ongoing Layer 4 settlement.

Continue existing authorised one-item-at-a-time settlement while the bulk feature is being designed, implemented and tested.

Do not delay unrelated engineering or stop routine settlement merely because the bulk feature awaits its policy approval.

Deliver first: a concrete bulk-review design, eligible-field policy, UI preview contract, affected existing components, implementation estimate, test plan and approval decision pack.

Once approved, implement and verify the smallest safe extension to the existing Layer 4 UI and admission path.