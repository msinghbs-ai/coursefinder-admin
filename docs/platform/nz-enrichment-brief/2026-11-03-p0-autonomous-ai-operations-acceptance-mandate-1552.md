StudySearch — P0 Autonomous AI Operations, Self-Healing, Continuous Improvement and Production Acceptance

Mandate date: 3 November 2026
Priority: P0 — Platform-wide operational autonomy
Status: Approved for governed execution
Operating mode: Active Remediation → Verified Acceptance → Steady-State Autonomous Operations
Execution authority: Existing StudySearch Integration Controller
Scope: All supported countries, providers, courses, scholarships, entry requirements, enrichment layers, operational jobs and consumers

---

1. Executive mandate

Build and deliver a permanent, production-grade autonomous AI operating capability within StudySearch.

The platform must independently:

1. Detect missing data, operational failures, coverage discrepancies and regressions.
2. Diagnose underlying causes rather than repeatedly treating symptoms.
3. Determine appropriate corrective actions using its own AI and deterministic logic.
4. Execute corrections that fall within its approved operational authority.
5. Discover and recover missing source evidence.
6. Improve course, provider, scholarship and entry-requirement completeness.
7. Repair failed, stalled and inefficient enrichment workflows.
8. Validate every correction against live production outcomes.
9. Learn from verified results and continuously improve its operating methods.
10. Escalate only genuine governance, security, evidence or budget decisions.

The desired end state is an operationally self-sustaining StudySearch platform, not a monitoring system requiring Claude to resolve every newly discovered issue.

Claude is responsible for developing, integrating and proving this capability.

StudySearch's own AI must subsequently undertake routine operational investigation, recovery, optimisation and improvement.

Do not implement isolated fixes where a reusable autonomous capability can address the underlying problem.

Do not conclude the programme when development is finished. Completion requires verified production behaviour and the defined acceptance criteria.

---

2. Canonical governance and operating model

Before continuing development, read and reconcile:

- "msinghbs-ai/coursefinder-admin/docs/platform/AGENT-OPERATING-MODEL.md"
- "msinghbs-ai/coursefinder-admin/docs/platform/nz-enrichment-brief/INDEX.md"
- Applicable Admin thread files and current standing orders.
- "msinghbs-ai/Coursefinder-Pilot/CLAUDE.md"
- "docs/platform/PIPELINE-LINEAGE.md"
- "docs/platform/TEST-REGISTER.md"
- Existing Layer 4 operating rules and action playbook.
- Existing AI enrichment, AER, scholarship, coverage and provider lifecycle specifications.

Review the existing documents:

- "2026-11-03-p0-autonomous-ai-operations-mandate-1537.md"
- "2026-11-03-ai-operations-workstreams-1540.md"
- "2026-11-03-p0-autonomy-cycles.md"
- Relevant v2.15.425 and v2.15.426 release and verification records.

The canonical operating model takes precedence over this prompt where any implementation detail conflicts.

Maintain the established separation:

Admin repository: Governance, architecture, decisions, operating documentation and programme evidence.

Pilot repository: Executable implementation, migrations, functions, tests and production releases.

The Integration Controller remains the sole release and integration authority.

Development agents must not independently merge, deploy, perform production writes or consume shared vendor budgets.

Preserve existing change-control gates, including destructive-change and consumer-API approval requirements.

Do not introduce invented tables, functions, jobs or existing capabilities. Verify all referenced objects against actual code, lineage and the live database.

---

3. Current production baseline

The supplied operational baseline is:

Component| Current state
Release| v2.15.426 live
Automated test suite| 1,614 passed
Recorded data gaps| 20,621
Unresolved page identities| 4,710
Missing-source gaps| 4,665
Evidence-pending gaps| 2,694
Gaps on another stored page| 579
Courses requiring D1 assessment| 1,222
Existing detected integration issues| 48
New coverage-admit failure| IQ-00067
Autonomous execution| Two productive cycles demonstrated
Full self-sustainability| Not yet verified
Acceptance test| 24-hour unattended test outstanding

Other relevant issues:

- IQ-00053: Description-recording time-outs.
- IQ-00064: Interrupted course-page search.
- IQ-00066: Empty plans and zero-yield execution.
- IQ-00041 and IQ-00058: Scholarship and AER coverage work.
- IQ-00054 and IQ-00045: Cost and yield investigations.
- IQ-00063: Invalid onboarding website loop, operationally closed but source identity unresolved.

These are checkpoint figures, not immutable targets.

Reconcile the current live production state before further implementation.

Record changes against a stable baseline and distinguish new work, already-resolved work and outstanding defects.

---

4. Approved executive decisions

The following decisions are included in the execution mandate.

D1 — Paid course-page search

Decision: Remain disabled.

The 1,222 courses currently without an approved discovery route must be evaluated as a recovery cohort.

Automatically exhaust:

- Existing snapshots.
- Stored page evidence.
- Existing course links.
- Provider-level source mappings.
- Canonical URL reconciliation.
- Approved free discovery.
- Evidence shared by other courses.
- Authorised existing crawls.

Produce a consolidated cost-and-yield assessment for records genuinely requiring paid search.

Do not activate D1 paid course-page search without explicit authorisation.

Rationale: A large number of apparent course-level problems may share a small number of provider-level root causes. Resolving those causes first reduces expenditure and improves future coverage.

D6 — Scheduled AER reading

Decision: Approved within existing operational and financial controls.

Implement governed scheduled entry-requirement reading using available evidence and approved acquisition capacity.

Cover country-specific, qualification-specific and course-specific requirements.

Retain source provenance, confidence checks, manual locks and Layer 4 admission rules.

Do not treat D6 approval as permission to expand paid-service budgets or automatically admit judgement-sensitive requirements.

Rationale: Entry-requirement completeness should improve continuously rather than depend on manually reported missing universities or qualifications.

NEWGEN EDUCATION — CRICOS 03871F

Decision: Authorise evidence-backed correction only.

The existing website value is malformed.

Do not assume "https://newgen.edu.au" is correct merely because it resembles the provider's email domain.

Verify the provider's identity and website through an authoritative register or adequately supported first-party evidence.

Where verified, perform the permitted, provenance-backed correction through existing governance.

Otherwise retain a named source-identity blocker.

Rationale: Automatically guessing official domains can introduce incorrect provider associations and corrupt subsequent course discovery.

Firecrawl and AI expenditure

Decision: Continue within the existing approved limits.

Prioritise reuse of previously acquired evidence.

Perform provider-level discovery where it can recover multiple records.

Allow adaptive work scheduling and batching within existing limits.

Any proposed budget increase must include:

- Estimated expenditure.
- Expected verified data recovery.
- Alternative routes already attempted.
- Marginal cost per verified result.
- Risk of unsuccessful paid operations.

Do not treat this mandate as a new unlimited spending approval.

---

5. Seven parallel development workstreams

Continue the seven existing workstreams.

Do not restart completed work.

Maintain explicit responsibility boundaries and controlled integration.

Workstream| Responsibility| Required end state
A — AI Operations Controller| Diagnosis, remediation selection, execution and verification| Operational AI resolves eligible issues end-to-end
B — Gap Recovery| Source discovery, page identity, missing-field recovery| Shared root causes fixed and gaps measurably reduced
C — Scholarship and AER| Provider-level coverage and source-listing reconciliation| Continuous coverage validation and governed enrichment
D — Pipeline Self-Healing| Job states, retries, persistence, dependency recovery| Routine pipeline failures recover without manual intervention
E — AI Self-Improvement| Evaluations, controlled experimentation, learning| Versioned improvements proven before promotion
F — Cost and Yield| Spending control, execution efficiency and waste prevention| Increased verified yield within approved cost limits
G — Provider Identity and Lifecycle| Official identity, websites, retirement and cascading housekeeping| Reliable entity lifecycle with preserved referential integrity

The Integration Controller owns interface coordination, release sequencing, integration tests, production verification and final programme acceptance.

Workstream completion is not programme completion.

---

6. Workstream A — Autonomous AI Operations Controller

Required architecture

Extend the existing integration feedback queue and monitoring architecture.

Do not build another independent queue or introduce a competing source of operational truth.

The controller must implement:

Detect → Diagnose → Correlate → Plan → Authorise → Execute → Verify → Learn → Close

The controller must select between deterministic remediation and AI-assisted remediation.

Use deterministic rules where the cause and correction are known.

Use AI for interpretation, ambiguous source comparison, multi-symptom diagnosis and remedy selection where deterministic methods are insufficient.

Require evidence before operational changes.

Incident intelligence

For every integration issue, retain:

- Stable issue identity and fingerprint.
- Affected provider, course or pipeline scope.
- Root-cause classification.
- Related incidents and shared dependencies.
- Supporting logs and evidence.
- Proposed corrective action.
- Confidence and risk assessment.
- Approval category.
- Execution history.
- Verification result.
- Regression history.
- Final operational outcome.

Existing issue backlog

Ingest and classify all 48 currently detected issues.

Do not limit the controller to new incidents.

Group historical issues by common root cause and affected subsystem.

Prevent duplicate investigations where several issues share a defect.

Preserve individual issue traceability when one shared remediation fixes multiple issues.

Explicit AI authority

The controller may autonomously execute permitted operational changes.

It must not:

- Expand its own permissions.
- Modify approval boundaries.
- Increase authorised budgets.
- Override manual locks.
- Bypass Layer 4.
- Apply destructive changes without approval.
- Modify security controls outside governance.
- Publish unverified source claims.

Enforce these restrictions in the backend, not solely through AI prompts.

End state A

An eligible issue can enter the integration queue, be diagnosed, corrected, verified and closed without an external Claude session.

A recurring issue reopens with its previous evidence and correction history.

A policy-blocked issue is accurately escalated rather than repeatedly retried.

---

7. Workstream B — Autonomous gap and source recovery

Core requirement

Build a permanent source-recovery capability that addresses provider-level defects before undertaking expensive per-course operations.

Cover:

- Incorrect page identity.
- Missing course links.
- Invalid canonical URLs.
- Incorrect page-to-course matching.
- Missing source mappings.
- Stale provider websites.
- Evidence on another stored page.
- Missing field-specific source evidence.
- Incorrectly classified absence.
- Source pages that have moved or changed structure.

Recovery priority

Use the following order:

1. Existing verified evidence.
2. Stored page snapshots.
3. Existing provider and course mappings.
4. Deterministic source reconciliation.
5. Shared provider-level discovery.
6. Authorised free acquisition.
7. Approved Firecrawl operations.
8. AI extraction from acquired evidence.
9. Governed escalation for additional paid acquisition.

Recover all applicable missing fields from one acquired page in a single extraction where practical.

Do not repeat paid acquisition merely because an earlier write failed.

Maintain evidence reuse and result persistence.

Root-cause clustering

Investigate the 4,710 unresolved page identities as a grouped population.

Determine whether common problems include:

- URL normalisation.
- Provider-domain mismatches.
- Course identifier mismatches.
- Incorrect source classifications.
- Duplicate or redirected pages.
- Stale source mappings.
- Incomplete evidence indexing.

Create shared corrections wherever appropriate.

D1 cohort

Automatically reconcile the 1,222 blocked courses.

Provide counts of:

- Recovered using existing evidence.
- Recovered using free discovery.
- Already in progress.
- Waiting on Layer 4.
- Protected by manual locks.
- Requiring new paid discovery.
- Unable to recover because authoritative evidence is unavailable.

Do not report the entire cohort as failed merely because D1 remains disabled.

End state B

The platform routinely resolves recoverable missing-source problems without manual discovery.

Missing-data reporting distinguishes genuine evidence limitations from broken source discovery.

Provider-level corrections improve multiple affected courses.

---

8. Workstream C — Scholarship and AER coverage

Scholarship coverage

Implement continuous comparison between provider source listings and catalogue records.

Support:

- Undergraduate scholarships.
- Postgraduate scholarships.
- Research scholarships.
- International scholarships.
- Country-specific eligibility.
- Funding type.
- Financial value.
- Application dates.
- Study level.
- Academic and residency requirements.

Do not conclude scholarship coverage is complete simply because a provider has some scholarship records.

Compare the actual published source inventory against:

- Discovered scholarships.
- Extracted scholarships.
- Layer 4 pending scholarships.
- Admitted scholarships.
- Archived scholarships.
- Unresolved source gaps.

Use provider-level crawling and classification to avoid repeated individual searches.

Entry requirements

Validate requirements across:

- Provider.
- Course.
- Country of applicant.
- Qualification type.
- Education system or curriculum.
- Study level.
- English-language requirements where relevant.
- Academic conditions.
- Official source URL.
- Effective or intake period where available.

Cover international qualifications such as IB and relevant country-specific pathways, including Nepal.

Ensure major registered providers are not silently omitted.

Do not infer universal entry requirements from a domestic-only source.

Scheduled validation

Run incremental coverage reconciliation based on relevant source or catalogue changes, together with periodic broader validation.

Avoid unnecessarily scanning the whole catalogue every hour.

Prioritise providers with measurable coverage discrepancies.

End state C

The platform independently identifies when a provider has incomplete scholarship or AER coverage.

It acquires permitted evidence, produces governed enrichment proposals and tracks every unresolved discrepancy.

Coverage is measured against source evidence rather than the simple existence of records.

---

9. Workstream D — Pipeline self-healing

Required capabilities

Address:

- Time-outs.
- Cancelled jobs.
- Interrupted page searches.
- Stale worker leases.
- Broken dependencies.
- Duplicate jobs.
- Infinite retry loops.
- Empty plans.
- Misleading success states.
- AI responses acquired but not persisted.
- Failed persistence after successful extraction.
- Work repeatedly scheduled despite permanent ineligibility.

Explicit outcomes

Support distinct outcomes for:

- Completed with verified data movement.
- Completed successfully with no data movement.
- Not needed.
- Deferred.
- Blocked by policy.
- Blocked by evidence.
- Retryable failure.
- Permanent failure requiring remediation.

Add a compatible job-outcome representation rather than weakening existing task-state constraints.

Historical execution records must remain auditable.

Use reconciled outcome reporting instead of rewriting immutable historical facts.

Paid-result preservation

When AI extraction succeeds but recording fails:

1. Preserve the paid result where permitted.
2. Identify the persistence failure.
3. Retry only the failed recording operation.
4. Confirm the final database state.
5. Do not repeat the AI call unless the original result is genuinely unusable.

Specific incidents

IQ-00053

Verify sustained resolution of description-recording time-outs after v2.15.426.

Validate actual recording throughput and duplicate-check performance.

IQ-00064

Automatically recover interrupted page searches without duplicate paid work.

IQ-00066

Ensure planned work is eligible and executable.

Prevent zero-yield plans from being reported as productive.

IQ-00067

Treat the coverage-admit failure as an integration priority.

Investigate why three of six recent executions failed.

Inspect transaction boundaries, dependencies, concurrency, evidence validation, idempotency, partial writes and admission handling.

Determine whether records were partially admitted or left inconsistent.

Implement a systemic correction, reconcile any affected data and establish regression guards.

Do not bypass admission validation merely to make the job successful.

End state D

Recoverable operational failures are repaired automatically.

Failed writes do not force unnecessary repeated paid reads.

Every job accurately reports its result.

The system distinguishes useful work, harmless no-op execution and genuine failure.

---

10. Workstream E — AI evaluation and self-improvement

Objective

Implement a controlled learning system that improves StudySearch's AI operations using verified outcomes.

Do not implement uncontrolled model self-modification.

The platform may improve its instructions, routing, extraction policies and execution strategies within governed boundaries.

Evaluation evidence

Use:

- Human-reviewed Layer 4 decisions.
- Verified catalogue corrections.
- Authoritative provider evidence.
- Previously resolved integration issues.
- Failed extraction examples.
- Regression test cases.
- Rejected or reversed corrections.

Do not treat unreviewed AI outputs as definitive ground truth.

Improvement lifecycle

Observe → Hypothesise → Build candidate → Evaluate → Canary → Compare → Promote or Reject → Monitor

Each proposed improvement must record:

- Current behaviour.
- Identified defect or inefficiency.
- Proposed change.
- Supporting evidence.
- Evaluation dataset.
- Expected benefit.
- Safety constraints.
- Regression results.
- Actual observed performance.
- Version and rollback path.

Candidate improvements

Support evaluation of:

- AI extraction prompts.
- Source selection.
- Page matching.
- Scholarship classification.
- AER interpretation.
- Field extraction.
- Source-proof reasoning.
- Retry decisions.
- Provider-level scheduling.
- Batch sizes.
- Cache reuse.
- Token efficiency.
- Job priority.
- Confidence thresholds within approved bounds.

Promotion controls

Reject any candidate that improves yield while introducing unacceptable:

- Incorrect admissions.
- Unverified data.
- Broken manual locks.
- Increased duplicate expenditure.
- Consumer data inconsistency.
- Critical performance regression.
- Governance violations.

Promote operational configuration changes only within pre-approved limits.

Code and database changes must follow the existing engineering release process.

End state E

StudySearch continuously identifies improvement opportunities, evaluates alternatives and safely adopts verified enhancements.

Unsuccessful approaches are recorded and not blindly repeated.

The platform becomes more efficient and accurate over time without weakening its safety boundaries.

---

11. Workstream F — Cost, efficiency and yield

Objective

Optimise the value of each execution while preserving coverage, correctness and governance.

For each planned operation, calculate where feasible:

- Eligible records.
- Existing usable evidence.
- Expected recovery.
- Estimated new acquisition cost.
- Previous failure history.
- Likelihood of successful persistence.
- Expected verified improvement.
- Duplicate or overlapping activity.

Prioritisation

Prefer:

1. Critical data-integrity repair.
2. Systemic fixes affecting many records.
3. Recovery using already-paid evidence.
4. High-yield source reconciliation.
5. Free discovery with measurable recovery.
6. Authorised paid work with acceptable expected yield.

Do not optimise cost by abandoning difficult but important providers.

Track unresolved coverage debt separately.

Circuit breakers

Automatically reduce, defer or stop execution when:

- Repeated failures produce no improvement.
- Source evidence is invalid.
- The same task repeatedly consumes paid resources.
- Costs approach authorised limits.
- Upstream infrastructure is unhealthy.
- Production integrity checks fail.

Resume only when the triggering condition has been corrected or a governed override exists.

End state F

Cost per verified improvement is measurable.

Duplicate paid reads are prevented wherever valid cached evidence can be reused.

Waste is detected automatically.

Budget restrictions remain enforceable independently of AI decisions.

---

12. Workstream G — Provider identity and lifecycle

Provider identity validation

Continuously validate:

- Registered provider identity.
- Official registration number.
- Official provider website.
- Canonical domain.
- Current registration status.
- Provider aliases and mergers.
- Source ownership and provenance.

Use authoritative registration evidence.

Do not assume a provider website from an email address.

Provider retirement

A missing website, failed crawl or temporary server outage is insufficient evidence of retirement.

Where authoritative evidence establishes that a provider has ceased, merged or otherwise legitimately changed status, initiate the appropriate governed lifecycle transition.

Reconcile related:

- Courses.
- Scholarships.
- AER records.
- Campuses.
- Provider contacts.
- Source mappings.
- Layer 1 references.
- Layer 2 and 3 jobs.
- Layer 4 pending proposals.
- Search projections.
- Consumer-visible records.

Preserve historical evidence and audit history.

Do not silently delete records.

Country retirement

Apply relationship-aware cascading housekeeping when a country is legitimately retired.

Archive or retire dependent entities and jobs under the existing lifecycle rules.

Use reversible transitions where possible.

Verify downstream consistency.

End state G

Registered providers have traceable identity evidence.

Invalid provider websites do not create infinite onboarding loops.

Retired entities no longer produce inappropriate active work.

Related records remain consistent and auditable.

---

13. Cross-platform autonomous coverage validation

Implement continuous reconciliation across every supported active country.

For each provider, maintain coverage measurements for:

- Registration.
- Course inventory.
- Course fields.
- Scholarship inventory.
- Entry requirements.
- Source URLs.
- Source-proof status.
- Layer 4 review.
- Published records.
- Consumer availability.

Distinguish:

- Source-discovered.
- Extracted.
- Validated.
- Pending review.
- Admitted.
- Published.
- Blocked.
- Retired.

Detect discrepancies between layers.

A course admitted into the database but missing from the public search projection is not a complete successful outcome.

A scholarship discovered but never admitted is not counted as catalogue coverage.

A source with no relevant information must not be misreported as a confirmed absence unless the evidence supports that conclusion.

Use event-based and incremental checking wherever practical.

Reserve full catalogue scans for justified reconciliation, maintenance or controlled validation windows.

---

14. Automatic root-cause correlation

This capability is mandatory across all workstreams.

Examples:

Scenario A — 4,710 page identities unresolved

Do not generate 4,710 unrelated AI investigations.

Determine whether shared matching or normalisation defects explain substantial portions of the cohort.

Scenario B — 17 scholarship plans produce zero results

Determine whether the plan builder selected ineligible providers.

Repair eligibility selection rather than repeatedly dispatching empty plans.

Scenario C — Description time-outs

Investigate recording and duplicate-detection performance rather than repeatedly lowering batch sizes without proof.

Scenario D — Provider website invalid

Stop the loop, classify the identity problem, seek authoritative evidence and recover onboarding only when appropriate.

Scenario E — Coverage-admit failures

Investigate transaction and admission consistency across executions.

Scenario F — Missing scholarships despite provider source listings

Treat the discrepancy as a provider-level coverage investigation.

The AI must learn to recognise shared failure patterns and select systemic remedies.

---

15. Production integration and continuous feedback

Use one Integration Controller.

All workstreams must integrate through existing issue ownership and release controls.

For each release:

1. Record the governing decision.
2. Identify affected objects.
3. Identify dependencies.
4. Complete unit and integration testing.
5. Complete database fixture and contract tests.
6. Verify required live function checksums.
7. Confirm migration compatibility.
8. Merge through the authorised release process.
9. Verify actual production deployment.
10. Validate operational outcomes.
11. Update issue status and durable evidence.
12. Reopen or create remediation issues for failures.

The full local test suite must have no failed or skipped tests under established test governance.

Verify downstream integrations, not just isolated functions.

Use the canonical V1–V4 validation framework.

- V1: Development and local tests.
- V2: Cross-layer integration.
- V3: Production deployment and smoke checks.
- V4: Continuous production monitoring.

Do not allow parallel development to create competing migrations, releases or ownership over the same function.

Return failed integration outcomes to the queue.

Continue remediation until acceptance criteria pass.

---

16. Operational authority and autonomous decisions

Autonomous actions permitted

Subject to existing safeguards:

- Diagnose production issues.
- Classify root causes.
- Correlate repeated defects.
- Reuse stored evidence.
- Perform authorised discovery.
- Recover interrupted jobs.
- Reconcile stale leases.
- Suppress duplicate work.
- Retry failed persistence.
- Correct permitted operational settings.
- Optimise execution within limits.
- Generate regression tests.
- Update issue evidence.
- Produce improvement proposals.
- Execute approved reversible remediations.

Actions requiring governed engineering control

- Code modification.
- Database schema changes.
- Function replacement.
- Migration execution.
- Routing-rule changes that affect admission or consumers.
- Deployment of new AI behaviour.

These may be developed and tested under the existing mandate but must satisfy current release gates.

Actions requiring explicit Platform Admin authorisation

- Increased paid-service expenditure.
- Enabling D1 paid searches.
- Destructive database operations.
- Changes to consumer API shape.
- Removal of manual locks.
- Weakening Layer 4 safeguards.
- Unauthorised material permission changes.
- Publication of unverified official sources.

Do not repeatedly ask for approval for decisions already authorised.

Batch genuine policy decisions into consolidated escalation records.

Continue unrelated authorised work.

---

17. Operating observability and reporting

Build or extend the existing operational dashboards.

Avoid creating duplicate dashboards, scripts or SOPs where a supported existing component can be improved.

Required operational scorecard

Metric| Required measurement
Autonomous resolution| Eligible incidents resolved without external intervention
Detection-to-diagnosis time| Time to identify a supported root cause
Diagnosis-to-resolution time| Time to verified correction
Recurrence| Previously resolved defects reopening
Data recovery| Verified fields and records improved
Coverage| Provider, course, scholarship and AER completeness
Pipeline yield| Actual data improvement per execution
Wasted operations| No-op work and repeated paid reads
Spending| AI, Firecrawl and other acquisition costs
Layer 4| Pending, held, admitted and technically blocked
Data integrity| Mismatches, orphaned dependencies and publication inconsistencies
Platform health| Worker failures, time-outs, stale leases and queue delays
Learning| Evaluated, accepted and rejected improvement candidates

Use deduplicated alerts and exception-driven reporting.

Maintain hourly internal checkpoints and daily consolidated summaries through the approved reporting mechanisms.

Critical integrity, security or budget incidents must follow existing urgent alert policies.

Do not require the Platform Admin to monitor individual university or course gaps manually.

---

18. Measurable operational acceptance targets

Targets must be evaluated against real live data.

Do not invent a successful result or claim acceptance from a local simulation alone.

Autonomous resolution

Target: At least 90% of eligible routine incidents resolved autonomously over a sufficiently representative observation window.

Exclude genuine policy, external-evidence and approval blockers from the eligible denominator, but report them separately.

Do not exclude difficult operational failures simply to improve the percentage.

Paid acquisition efficiency

Target: Zero avoidable duplicate paid reads when the original valid result is available for reuse.

Distinguish unavoidable retries from failures caused by missing persistence or broken idempotency.

Data integrity

Target: Zero unauthorised admissions, manual-lock overrides, destructive changes or unapproved budget expansions.

Any such event fails acceptance and triggers the existing incident response.

Operational stability

Target: 24 consecutive hours of validated unattended execution during the initial acceptance test.

The tested workflow must include representative recovery, data improvement, issue verification and scheduler execution.

Coverage improvement

Demonstrate measurable reduction in recoverable baseline gaps.

Track a fixed baseline cohort separately from newly discovered gaps to prevent misleading progress.

Integration issue reconciliation

All 48 historical detected issues must be:

- Verified resolved; or
- Validly superseded by a shared root-cause issue with retained traceability; or
- Explicitly blocked with supporting evidence and the required external decision.

Moving an issue from "detected" to "investigating" does not count as resolution.

---

19. Programme phases and completion gates

Phase 0 — Live reconciliation

Confirm current deployment, database functions, pending incidents and workstream ownership.

Exit condition: Validated baseline and active integration queue.

Phase 1 — Stabilisation

Resolve or correctly classify outstanding incidents, especially IQ-00053, IQ-00064, IQ-00066 and IQ-00067.

Exit condition: Known critical operational defects no longer undermine autonomous execution.

Phase 2 — Controller foundation

Deploy root-cause correlation, remedy selection, permission enforcement and verification.

Exit condition: The controller demonstrates end-to-end recovery for representative eligible incidents.

Phase 3 — Data recovery and coverage

Integrate Workstreams B and C.

Exit condition: Course, scholarship and AER gaps enter autonomous discovery, reconciliation and governed enrichment.

Phase 4 — Self-improvement and cost controls

Integrate Workstreams E and F.

Exit condition: AI improvements are versioned, evaluated, controlled and measurable.

Phase 5 — Provider lifecycle and integration

Complete Workstream G and all cross-workstream interfaces.

Exit condition: Lifecycle transitions, jobs, evidence, admissions and consumer projections remain consistent.

Phase 6 — Production acceptance

Execute all V1–V4 validation requirements and the 24-hour unattended test.

Exit condition: Every mandatory production acceptance condition passes with supporting evidence.

Phase 7 — Steady-state autonomous operations

Transition from Active Remediation to Steady-State Monitoring only after the Integration Controller formally records acceptance.

Exit condition: Ongoing scheduled monitoring, autonomous issue recovery and regression feedback remain operational without continued Claude orchestration.

---

20. Required final platform end states

These end states are mandatory and define what the overall mandate constitutes.

End State 1 — Autonomous operational recovery

StudySearch identifies and repairs routine failures using its own AI and operational services.

Proof: A representative eligible failure is detected, diagnosed, repaired and verified without external manual dispatch.

End State 2 — Self-maintaining data coverage

The platform continuously compares official provider evidence against the catalogue and identifies missing or incomplete records.

Proof: Representative course, scholarship and AER gaps are independently discovered and routed to verified recovery or governed review.

End State 3 — Systemic root-cause elimination

The platform groups related defects and fixes shared causes rather than repeatedly addressing individual symptoms.

Proof: A validated shared correction resolves multiple associated records or incidents, with recurrence monitoring.

End State 4 — Cost-aware autonomous execution

The platform chooses efficient acquisition and enrichment strategies within approved budgets.

Proof: Measurable evidence reuse, prevented duplicate reads and reliable cost-per-improvement reporting.

End State 5 — Governed AI self-improvement

The platform evaluates and improves prompts, extraction strategies and operational decisions.

Proof: A versioned candidate improvement is evaluated, safely promoted or rejected, and its results are recorded.

End State 6 — Reliable provider lifecycle

Provider identity, registration status, websites and retirement dependencies remain aligned.

Proof: Representative invalid-website and lifecycle cases are handled without incorrect source publication, unwanted active work or referential-integrity loss.

End State 7 — End-to-end data integrity

Course, scholarship and entry-requirement changes are consistent from source acquisition through review, publication and consumers.

Proof: Cross-layer verification confirms accepted records reach the correct downstream state and protected records remain unchanged.

End State 8 — Operational independence

Routine platform operations no longer require Claude sessions or owner-initiated remediation.

Proof: The 24-hour unattended test passes with real productive cycles, representative recovery and no unauthorised intervention.

End State 9 — Transparent governance

Every significant autonomous decision is attributable, explainable and auditable.

Proof: Each remediation has traceable evidence, permitted authority, execution outcome and production verification.

End State 10 — Continuous improvement after acceptance

The system continues detecting new issues and reopens previously fixed issues when regressions occur.

Proof: V4 monitoring creates or reopens the appropriate fingerprinted issue, and eligible remediation resumes through the established operating model.

---

21. Final deliverables

Produce and maintain in the Admin repository:

1. Architecture and ownership documentation.
2. AI Operations Controller design and implemented interface mapping.
3. Permission and decision-authority matrix.
4. Root-cause and remediation taxonomy.
5. Autonomous source-discovery specifications.
6. Coverage reconciliation rules.
7. AI evaluation and learning policy.
8. Cost and yield controls.
9. Provider lifecycle and housekeeping specifications.
10. Integrated test and regression evidence.
11. Production release history.
12. Reconciled historical issue results.
13. Coverage and operational improvement scorecards.
14. 24-hour unattended acceptance evidence.
15. Outstanding policy blockers and residual risks.
16. Steady-state operations handover.

Maintain the mandated dated thread records and update the canonical index, lineage and test register wherever required.

Consolidate or retire redundant documentation and scripts after verifying their dependencies.

Avoid creating competing sources of truth.

---

22. Execution and continuation directive

The seven workstreams are already running.

Continue from their current state.

Do not reset their progress, recreate completed work or ask for another general authorisation.

The Integration Controller must:

1. Reconcile workstream status and shared interfaces.
2. Prioritise IQ-00067 and critical integration defects.
3. Incorporate all 48 historical detected issues.
4. Continue parallel development safely.
5. Integrate independently tested workstream changes.
6. Release improvements under existing governance.
7. Verify production outcomes after each release.
8. Return unsuccessful results to the integration queue.
9. Repeat diagnosis, remediation and validation until acceptance passes.
10. Conduct and record the 24-hour unattended operational test.
11. Declare programme acceptance only from verified evidence.
12. Transition to steady-state autonomous operations.
13. Preserve ongoing monitoring and automatic remediation after acceptance.

For an issue blocked by an external decision, record the exact evidence, impact, requested decision and recommended option.

Do not permit that blocker to halt unrelated approved work.

If all workstreams cannot be completed within the current execution session, preserve accurate progress and resumable ownership in the repository. Do not represent incomplete work as deployed or accepted.

---

23. Non-negotiable completion definition

This mandate is not completed because:

- Seven development agents finished their tasks.
- All pull requests were merged.
- The test suite passed.
- The Worker deployed.
- The integration queue became smaller.
- Missing-data counts changed.
- An AI controller was installed.
- A monitoring dashboard reports green.
- A scheduled job executed successfully.

Completion requires that the deployed StudySearch platform demonstrates its ability to identify, diagnose, correct, verify and learn from eligible operational issues using its own controlled capabilities.

It must also demonstrate:

- Measurable verified catalogue improvement.
- Controlled spending.
- Reliable source provenance.
- Preserved Layer 4 and manual-lock safeguards.
- Cross-layer and consumer consistency.
- Accurate historical issue reconciliation.
- Successful unattended acceptance.
- Sustainable continuous monitoring and recovery.

The Integration Controller is the only authority that can declare the programme accepted under the canonical operating model.

Final instruction: Implement the complete capability, validate it in production, document the actual outcomes and transition StudySearch to governed steady-state autonomous operations. Do not stop at recommendations, implementation plans or monitoring-only features.