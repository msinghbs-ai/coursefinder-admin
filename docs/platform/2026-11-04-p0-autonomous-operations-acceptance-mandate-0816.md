<!-- Platform Admin direction, received 4 Nov 2026 08:16 AEDT; recorded verbatim before code. -->

StudySearch — P0 Autonomous Operations Acceptance and Recovery

Platform Admin direction — 4 November 2026

Continue the existing Integration Controller session.

The recurring failure is unacceptable: multiple releases have delivered components of autonomous enrichment, but StudySearch still requires Claude or ChatGPT to diagnose individual scheduled-job failures and manually initiate corrective development.

This mandate addresses that operating-model deficiency across the entire platform.

Do not create a new controller, duplicate integration queue, dashboard or parallel remediation programme.

Read the canonical operating model, SS-018, SS-021, current integration feedback, the live operations contract and production acceptance criteria.

1. Resolve the existing scholarship classifier failure

Use existing IQ-00239 and IQ-00241.

The first scheduled scholarship-coverage-classify run after v2.15.460 failed because multiple input rows targeted the same "(provider_id, item_key)" in one PostgreSQL "ON CONFLICT DO UPDATE" operation.

The coverage items table is currently empty.

Pilot already contains a prepared correction in v2.15.461:

"20261104430000_cf247_sch_coverage_classify_fix.sql"

First reconcile whether this release has been tested, merged, deployed and verified.

Do not build a duplicate fix.

Validate that the corrected classifier:

- Selects exactly one deterministic authoritative record per conflict key.
- Preserves distinct source evidence and alternative classification facts.
- Records duplicate cases without repeatedly submitting them for upsert.
- Is idempotent across repeated executions.
- Isolates reporting errors from successful classification work.
- Does not introduce false eligibility or admission.
- Passes the original PostgreSQL regression fixture.
- Completes an unattended scheduled execution in production.

If the corrected function still fails, update the existing issue with the actual new failure and return it to remediation.

Only close IQ-00239/IQ-00241 after production verification.

2. Audit why released capabilities repeatedly fail on their first run

Investigate the last sequence of autonomous operations releases, particularly SS-018, SS-021, AER scheduled reading, source recovery, scholarship classification and Layer 4 throughput.

For every material failure, establish:

- Was the defect present before deployment?
- Did tests exercise the production source shape and cardinality?
- Did the release require a behaviour switch?
- Was that switch actually activated?
- Did the first scheduled run complete?
- Did the job create expected output records?
- Did downstream work resume?
- Was anything admitted or published?
- Did an existing controller automatically detect and remediate failure?
- Why was human intervention required?

Classify each failure by its actual root cause rather than assuming all are AI reasoning failures.

Identify shared defects in testing, job orchestration, activation, error isolation, issue routing or production validation.

3. Make first-run operational verification mandatory

Extend the existing release-verification contract.

A new or materially changed scheduled capability must have:

1. A production-representative fixture.
2. Full existing V1/V2 tests.
3. Verified deployment and migration/function checks.
4. A successful authorised scheduled execution.
5. An expected-versus-actual output count.
6. Verified downstream work eligibility.
7. Evidence that failures are detected and routed for automatic recovery.
8. A recorded acceptance or explicit awaiting-first-run status.

Do not equate green CI, successful migration, a scheduled-job registration or a configured switch with operational success.

If the next scheduled execution falls outside the deployment window, mark the release deployed but operationally unverified. Continue unrelated releases while the existing validation scheduler checks it.

4. Introduce a producer-to-consumer progress contract

Every autonomous pipeline must report its expected output and the next dependent stage.

Examples:

Scholarships

Coverage classification → source recovery → listing traversal → candidate matching → reading → eligibility validation → Layer 4 where required → admission → publication.

AER

Source discovery → extraction → completeness validation → technical correction where needed → Layer 4 review → active entry records → consumer publication.

For each transition, record:

- Input eligible.
- Input processed.
- Output created.
- Output rejected with reason.
- Output parked with next action.
- Downstream work queued.
- Output admitted.
- Output published.
- Last successful advancement time.

Detect a stalled transition even when its scheduler reports success.

A zero-output run must have a reason: no eligible work, valid cap, blocked authority, correctly excluded inputs or a technical failure.

Do not report all zero-output runs as successful autonomous processing.

5. Repair the automatic recovery loop

The existing controller must detect production failures and choose an authorised response.

For a known failure fingerprint:

- Find the existing integration issue.
- Read evidence and previous unsuccessful remedies.
- Classify the root cause.
- Apply approved settings, retries or remedies where safe.
- Verify the producer resumes.
- Verify dependent work becomes eligible.
- Record outcome and next scheduled action.
- Reopen the issue if the remedy fails.

A SQL or code defect requiring development must become an owned engineering remediation task automatically, with evidence and a bounded next checkpoint.

The controller must not autonomously merge unreviewed code, grant its own budget, bypass Layer 4, override manual locks or perform destructive changes outside existing authority.

If a remedy requires human authority, park the affected work and present one actionable decision in the appropriate existing review or governance channel.

Keep unrelated work progressing.

6. Audit feature switches and activation readiness

Reconcile all recovery-related switches introduced by recent releases, especially:

- Scholarship legal-name identity.
- Scholarship policy disposition.
- Register-page recovery.
- Stored-read recovery.
- Listing recovery.
- AER fairness and back-pressure controls.
- Source recovery and AI fallback.
- Failed-field recovery.
- Work-continuity lane settings.

For every disabled capability, show its operational consequence and the exact condition for activation.

Do not turn switches on merely to improve metrics.

Where activation is already authorised and the prerequisites pass, activate it as a recorded, separately verified settings change.

Where new spending or approval is required, present one consolidated decision pack with expected yield, cost and risk.

Eliminate indefinite "built but off" states without a responsible owner, next checkpoint and decision.

7. Restore scholarship throughput

After v2.15.461 is independently verified:

- Populate and reconcile all 13 classification states.
- Verify provider-level classification coverage.
- Investigate actual rejected and missing eligible scholarships.
- Recover Torrens and TAFE SA through the corrected shared pipeline.
- Resolve Box Hill based on source eligibility evidence.
- Reconcile IQ-00242, IQ-00243 and IQ-00244 without treating zero publication alone as proof of a defect.
- Resume authorised recovery using existing scheduled jobs.
- Present truly unresolved identity or eligibility evidence gaps through the shared Layer 4 human-assisted intervention capability.

Do not manually enqueue individual records to manufacture progress.

Verify successful catalogue admission and consumer publication separately.

8. Restore AER throughput

AER is another example of an operationally registered pipeline with poor downstream yield.

Investigate why scheduled reading and technical recovery are failing to produce active entry rows.

Preserve the 600-item review limit and existing completeness gates.

Use readiness-aware selection, technical recovery, provider fairness and actionable human interventions to keep independent work progressing.

For CDU, UniSQ, UNE, Torrens, ACU, CQU, Deakin, JCU, RMIT and UWA, report actual source, read, technical-block, review-ready, admitted and published states.

Do not substitute a new source record or AI read count for an admitted qualification.

9. Reconcile the new P1 scholarship issues

Existing issues:

- IQ-00242 — Australian Film Television and Radio School.
- IQ-00243 — Manukau Institute of Technology and Unitec.
- IQ-00244 — TAFE Queensland.

For each, establish the authoritative source, current offerings, international eligibility, completed discovery coverage, rejection reasons and evidence of an actual missing eligible scholarship.

A provider with no demonstrated eligible scholarships is not automatically a P1 publication defect.

Preserve the issue history and adjust severity only through the existing governed process.

10. Quantitative self-sustainability acceptance

Build a production scorecard from existing data.

Measure| Acceptance evidence
Scheduled-job reliability| Successful required executions and justified idle/capped runs
Automatic diagnosis| Known failures detected and assigned without Claude intervention
Automatic recovery| Approved remedies applied and verified
Queue continuity| Other providers and fields progress despite failures
Source-to-admission yield| Evidence of valid records entering the active catalogue
Admission-to-publication yield| Website API v2, Wix and Zoho read-back
Human intervention| Actionable Layer 4 items only where necessary
Spending| Existing budget compliance, measured yield
Release correctness| Actual Worker, migration and function verification
Unattended operation| Continuous 24-hour production observation

A release count is not a platform-performance measure.

Record baseline, change and verified outcome for every relevant field.

A 24-hour observation with no errors but also no eligible data processed must not be accepted as self-sustaining unless the absence of eligible work is proven.

11. Execution priorities

Proceed in this order:

1. Integrate and production-verify the existing v2.15.461 classifier fix.
2. Restore scholarship classification output.
3. Verify that the normal scheduler progresses eligible scholarship records.
4. Identify the broader release/activation/first-run verification defect.
5. Correct shared orchestration and recovery weaknesses.
6. Restore AER throughput and missing-university progression.
7. Verify consumer-visible publication and record yield.
8. Complete unattended acceptance.

Use safe parallel engineering with one Integration Controller.

Maintain the existing Admin execution register, issue fingerprints and durable evidence records.

Do not wait for the Platform Admin on already authorised corrective actions.

12. Required checkpoint

Report:

- What actually caused recurring failures after release.
- Which mechanisms were incorrectly assumed operational.
- Which remedies are now working autonomously.
- What is still disabled and why.
- Scholarship and AER records actually advanced.
- Catalogue admissions and consumer publication changes.
- Remaining human-authority blockers.
- Next unattended verification point.

Do not declare self-sustainability accepted until StudySearch independently detects faults, recovers eligible work, continues other operations, admits properly validated data and publishes correct results without Claude manually driving individual records.

The objective is fewer recurring interventions and more verified data progress, not more releases.