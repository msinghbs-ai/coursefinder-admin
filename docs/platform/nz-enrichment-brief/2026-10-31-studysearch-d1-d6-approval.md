StudySearch — Executive Approval: D1–D6 and Consolidated Execution

1. Decisions approved

The Platform Admin has reviewed the consolidated decision pack.

These decisions supersede the pending approval requests for D1–D6, within the boundaries stated below.

D1 — SS-007 Batch A: APPROVED

Proceed with the controlled correction of 177 course-page bindings across 25 providers, including the expected retraction of 167 incorrect consumer-visible official links.

Requirements:

- Use the existing v2.15.379 remediation hold.
- Execute provider by provider, with count guards.
- Verify existing classifications immediately before each batch.
- Preserve original URLs, admitted field values, evidence and rollback records.
- Confirm that held courses do not trigger paid searches, page reads or AI matching.
- Reconcile the actual changes against the 177-course manifest.
- Verify Website and Zoho API results before and after the correction.
- Provide the developer with the data-correction handover note and affected-course manifest.

Stop only if actual changes exceed the approved manifest, protected manual bindings are affected, new paid processing is triggered, or consumer regressions occur.

D2 — SS-007 Batch B: RETAIN

Keep all 125 school international and ELICOS level-page bindings unchanged.

Document why they are being retained and any residual identity uncertainty.

Do not release or re-role these bindings under this approval.

D3 — SS-008 Rule 4: APPROVED FOR LOGICAL RETIREMENT

Retire the obsolete Rule 4 automatic admission mechanism.

- Keep automatic admissions disabled.
- Verify dependencies and downstream consumers.
- Remove the rule from active scheduling and operational controls using existing governed retirement mechanisms.
- Preserve historical decisions, evidence and audit trails.
- Do not delete database objects or history under this authorisation.
- Any destructive cleanup remains subject to the existing approval process.

Record the retired component and its replacement or reason for retirement in the component register.

D4 — SS-009 Multiple Entry Scores: APPROVED

Proceed with the additive "entry.min_scores[]" enhancement.

- Preserve the existing "min_score" field and its behaviour.
- Include all independently verified, published alternative entry scores.
- Do not infer unstated scores or grading scales.
- Preserve qualification type, score, scale and source evidence as appropriate.
- Follow G3 consumer API change controls.
- Prepare developer-guide issue 7, version line, compatibility assessment and handover note.
- Run all consumer contract and regression tests.
- Verify Website and Zoho responses after deployment.

This approval applies only to the proposed additive field and its necessary supporting implementation. No removal, renaming or retyping of existing fields is authorised.

D5 — SS-010 Enrichment Efficiency: APPROVED

Approve both parts:

A. Prevent mismatch-page courses from repeatedly re-entering enrichment queues.

B. Reprocess the 67 previously withdrawn values that now have verified course pages, subject to a maximum incremental AI spend of US$1.

Requirements:

- Reuse the existing central hold and eligibility controls where possible.
- Preserve provenance and admission validation rules.
- Use count-guarded, bounded retries.
- Do not reprocess courses without verified identity evidence and a usable stored page copy.
- Record attempted, admitted, held, rejected and no-value outcomes.
- Verify that admission quality is not weakened.
- Do not broaden the reprocessing scope or exceed the approved spending ceiling.

D6 — SS-011 Website Search Performance: APPROVED

Proceed with optimisation of the two identified consumer search functions.

The objective is to reduce search latency while preserving the existing response contract and search semantics.

- Capture baseline execution plans and representative results.
- Optimise query execution, result construction, sorting and counting.
- Prove equivalent outputs for representative searches, pagination, filters, sorting, null handling and empty results.
- Run performance benchmarks before and after.
- Preserve existing API identifiers, routes and response structures.
- Validate both Website and Zoho consumer behaviour.
- Follow G3 and prepare the required developer documentation, version and handover where the implementation touches protected consumer API functions.
- Do not deploy any change that fails contract-equivalence testing.

Recommend that the Website developer request 20 results per page where practical, but preserve the existing supported 50-result capability. Do not make the consumer's page-size change a prerequisite for the backend optimisation.

2. Mandatory execution order

Execute in the following sequence:

Order| Task| Required result
1| SS-007 D1| Batch A corrected and consumer-verified
2| SS-007 D2| Batch B retained and documented
3| SS-010 D5| Queue efficiency fixed and bounded recovery completed
4| SS-011 D6| Search optimisation deployed and benchmarked
5| SS-008 D3| Rule 4 logically retired
6| SS-009 D4| Multiple entry scores released with developer-guide issue 7
7| SS-004| Continue 24-hour and seven-day reliability verification
8| StudySearch operations| Consolidate reliability, admission yield, cost and outstanding risks

Independent engineering tasks may be prepared in parallel, but production releases must respect dependencies and required verification.

Do not reopen settled decisions unless new evidence materially changes the risk or scope.

3. Execution autonomy

Complete the authorised work from implementation through production verification under the existing operating model.

Do not stop for routine engineering decisions, intermediate PR preparation, standard testing, migration dry runs or existing authorised deployment steps.

Do not stop after each sub-phase to request another GO.

If one task encounters a genuine blocker, record it and continue with the next independent authorised task.

Only escalate when:

- Actual impact exceeds the approved scope.
- A destructive or irreversible action is required.
- Consumer compatibility cannot be demonstrated.
- Security protections would be weakened.
- The approved financial ceiling would be exceeded.
- Production behaviour deviates from the expected results.

4. Measure substantial gains

After implementation, report:

Measure| Baseline| After change| Result
Incorrect published course URLs| 167 expected in Batch A| Actual remaining| Corrected / held
Unproductive enrichment attempts/day| 1,600–2,200| Actual| Reduction
Withdrawn values eligible for recovery| 67| Admitted / held / rejected| Recovery yield
Website search latency, p50/p95| Measured baseline| Measured result| Improvement
Rule 4 active admissions| Disabled| Disabled and retired| Verified
Multiple entry-score coverage| 24 affected courses identified| Correctly returned alternatives| Coverage improvement
Mandatory job failures| Current baseline| Subsequent observation| Reliability

Do not invent measurements or claim a seven-day reliability pass before the observation period has elapsed.

5. Continuous session progress

Keep the Platform Admin informed throughout the session.

At meaningful milestones provide:

Current task: SS-XXX
Completed: Verified outcomes
Current execution: What is running or being changed
Measured gains: Before and after
Issues: Genuine blockers only
Next action: What you will do automatically
Admin/Pilot record: Commit, PR and release references

Explain material production changes before execution, but do not turn progress reports into approval requests where authority already exists.

6. Governance and documentation

Maintain:

"docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md"

And:

"docs/platform/nz-enrichment-brief/2026-10-31-studysearch-transformation.md"

Record all decisions, changes, tests, evidence, cost, deployment versions, consumer handovers and rollback details.

Use the existing Admin governance structure and avoid duplicate records.

Protect the live Website and Zoho integrations throughout.

7. Final objective

Deliver substantial measurable gains in:

- Production reliability.
- Course-page data accuracy.
- Enrichment efficiency.
- Consumer API performance.
- Academic entry-requirement completeness.
- Operational simplicity.
- Cost-controlled, self-sustaining automation.

These D1–D6 decisions are approved within the stated boundaries. Proceed with execution without requesting another general GO.

Continue until the authorised work is completed or a genuine governance or technical blocker is reached. Provide verified results and repository references, not just implementation plans.