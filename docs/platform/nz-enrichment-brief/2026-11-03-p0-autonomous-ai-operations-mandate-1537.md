StudySearch — P0 Autonomous AI Operations, Self-Healing and Continuous Improvement

Executive mandate

Implement a permanent, governed AI operating capability within StudySearch.

The platform must increasingly operate, diagnose, repair, validate and improve itself without relying on external Claude sessions, manual SQL interventions or the platform owner identifying individual gaps.

This is a production engineering mandate, not a proposal for another monitoring dashboard or a one-off remediation exercise.

Use maximum safe parallel agent development, while preserving the canonical StudySearch operating model and production governance.

Primary outcome: StudySearch must be capable of detecting problems, identifying their root causes, executing permitted corrections, validating actual data improvements and preventing recurrence.

Claude's role is to design, implement, test and deploy the autonomous capability. The platform's own AI must subsequently perform routine operations independently.

Do not repeatedly request approval for decisions already delegated in this mandate.

---

1. Canonical alignment and baseline

Read and reconcile the current state against:

- "msinghbs-ai/coursefinder-admin"
- "msinghbs-ai/Coursefinder-Pilot"
- "docs/platform/AGENT-OPERATING-MODEL.md"
- "docs/platform/nz-enrichment-brief/"
- "docs/platform/nz-enrichment-brief/2026-11-03-v2.15.425-release-b-deployed.md"
- "docs/platform/nz-enrichment-brief/2026-11-03-p0-autonomy-cycles.md"
- Current source-proof, enrichment, Layer 4, AER, scholarship, coverage and operating SOP documents.

Confirm actual live database state, deployed functions, feature flags, job schedules, queue ownership, release versions and outstanding incidents before making changes.

Treat the following as the supplied baseline, subject to live verification:

- v2.15.425 deployed: 1,607 tests passed.
- v2.15.426 deployed: 1,614 tests passed.
- 35,690 courses examined by the first gap-queue pass.
- 20,621 gaps classified by reason.
- 1,018 gap items queued.
- 4,038 page-proof rows, initially including 297 proven.
- 253 descriptions routed to Layer 4.
- Application deadline recording producing real results.
- 1,222 courses without an approved source-proof route because D1 paid course-page search is disabled.
- IQ-00053 timeout optimisation deployed, with clean-hour verification pending in the supplied checkpoint.
- IQ-00066 empty-plan fix deployed, with subsequent-cycle verification pending.
- IQ-00063 onboarding loop closed; invalid provider website remains unresolved.
- IQ-00064 interrupted course-page searches awaiting automatic recovery.
- Two automatic cycles have moved actual data, but the 24-hour unattended acceptance test has not passed.

Preserve successful behaviour and do not recreate completed work.

2. Establish the Autonomous AI Operations Controller

Implement a persistent AI Operations Controller integrated with existing StudySearch services.

It must supervise:

1. Provider onboarding and identity validation.
2. Country and official-register coverage.
3. Course discovery, linking and completeness.
4. Scholarship discovery and completeness.
5. AER and international entry-requirement extraction.
6. Course descriptions, fees, deadlines, campus and study-level fields.
7. Source discovery, evidence integrity and source-proof routing.
8. Layer 2 and Layer 3 enrichment.
9. Layer 4 technical readiness and review integration.
10. Job execution, scheduling, retries, stuck tasks and dependencies.
11. AI costs, Firecrawl usage, duplicate work and pipeline efficiency.
12. Downstream publication and consumer consistency.
13. Operational documentation, alerting and regression detection.

Use existing services and database infrastructure wherever practical.

Do not introduce a parallel queue system or duplicate orchestration components without a documented architectural justification.

The controller must operate continuously through scheduled and event-driven execution, not through a persistent external Claude conversation.

3. Autonomous diagnosis and root-cause repair

Every meaningful failure must enter a standard lifecycle:

Detect → Classify → Correlate → Diagnose → Select remedy → Execute → Validate → Learn → Close.

Requirements:

- Correlate failures across providers, courses, sources, jobs and pipeline stages.
- Identify common upstream defects.
- Distinguish transient infrastructure failure from permanent data or rule defects.
- Detect repeated no-yield activity and retry loops.
- Detect jobs marked completed without actual data movement.
- Detect problems created by previous fixes.
- Distinguish missing information from information not present on a particular page.
- Prevent multiple agents independently repairing the same underlying defect.
- Attach each diagnosis to supporting evidence and a confidence assessment.

Prioritise shared fixes over individual record-by-record interventions.

For example, investigate whether thousands of unresolved page identities share URL-normalisation, course-identity, page-classification or matching-rule defects before searching for each course individually.

A failed operation must not continue retrying indefinitely without a change in evidence, execution conditions or remediation strategy.

4. Autonomous source discovery and gap resolution

Develop a comprehensive recovery process for existing data gaps.

Support the current classifications:

- Not on this page.
- Page identity unresolved.
- Needs a source.
- Evidence pending.
- On another stored page.

Route each classification to an appropriate recovery strategy.

Required discovery order

1. Reuse already stored evidence and snapshots.
2. Search existing provider and course source mappings.
3. Reconcile official URLs, redirects, canonical pages and identifiers.
4. Reuse provider-level crawl results across multiple courses.
5. Use permitted free discovery mechanisms.
6. Use existing Firecrawl evidence or authorised new crawling.
7. Use AI interpretation only where deterministic extraction is inadequate.
8. Escalate genuine paid-search requirements under the established D1 policy.

Do not incur a new paid read simply because a previous task failed to persist a result.

Maintain idempotent acquisition and recording, evidence fingerprints, deduplication and shared page caches.

A source proving that a field is absent must be distinguished from a source that does not discuss that field.

Special case: D1 blocked courses

The current 1,222 blocked courses must be managed as an explicit autonomous recovery cohort.

Group them by provider and common source requirements.

Exhaust free and authorised existing-evidence routes.

Report:

- Courses recovered without paid search.
- Courses waiting on current work.
- Courses waiting on Layer 4.
- Courses with locked fields.
- Courses still requiring paid discovery.
- Estimated provider-level recovery yield.
- Incremental cost and expected benefit of any proposed paid work.

Do not switch on D1 paid course-page search without authorisation.

5. Scholarship and AER coverage

Extend the controller to verify that registered providers are adequately represented across:

- Scholarships, including research, undergraduate, postgraduate and international eligibility.
- Entry requirements, including country, qualification, curriculum and study-level variations.
- Provider entry-requirement source URLs.
- Course-level requirements and eligibility conditions.
- Intake and application deadlines.

Provider coverage cannot be declared complete merely because some records exist.

Compare discovered source listings, admitted records, held records and known gaps.

Automatically detect underrepresented providers and missing categories.

Use source-listing reconciliation to identify potential missing records.

Maintain appropriate evidence and Layer 4 admission controls.

When a source contains substantially more eligible scholarships than the catalogue, open a provider-level coverage investigation rather than creating unrelated individual exceptions.

6. Intelligent AI execution and self-improvement

Implement a controlled improvement loop for the platform's own AI.

The AI must evaluate its operational outcomes and identify opportunities to improve:

- Source selection.
- Page identification.
- Provider matching.
- Course matching.
- Scholarship classification.
- Entry-requirement interpretation.
- Extraction schemas.
- Prompt effectiveness.
- Retry strategies.
- Job ordering.
- Batching.
- Concurrency.
- Token usage.
- Firecrawl usage.
- Evidence reuse.
- False positives and false negatives.

Learning and improvement mechanism

Record:

- The problem observed.
- The current method.
- The proposed improvement.
- Supporting production evidence.
- Expected benefits.
- Known risks.
- Evaluation dataset and acceptance criteria.
- Actual results after implementation.

Use historical accepted corrections, verified Layer 4 decisions and validated source evidence as evaluation inputs.

Do not treat unreviewed AI-generated data as ground truth.

Support versioned prompt and rule candidates, offline regression evaluation, controlled canary execution and rollback.

Allow automatically approved operational adjustments within established guardrails.

Changes to admission rules, security controls, production code, database schemas or material paid-service permissions require the existing engineering governance path.

The AI must never grant itself broader permissions or alter its own approval boundaries.

Improvement acceptance criteria

Accept an improvement only when it demonstrates a measurable benefit without unacceptable regression in:

- Accuracy.
- Source integrity.
- Coverage.
- Data admission safety.
- Cost.
- Execution reliability.
- Consumer compatibility.

Retain previous versions and rollback capability.

Rejected or ineffective improvements must be recorded so the controller does not repeatedly propose the same unsuccessful change.

7. Self-healing pipeline execution

Build or extend automated recovery for:

- Time-outs.
- Cancelled or interrupted jobs.
- Stale leases and orphaned workers.
- Zero-yield plans.
- Duplicate plans.
- Stuck source-proof work.
- Broken provider links.
- Invalid onboarding websites.
- Missing course pages.
- Too-few-course-page conditions.
- Dependency sequencing.
- Misclassified job completion.
- Failed persistence after successful extraction.
- Jobs with excessive paid retry costs.

Each job must have an explicit outcome:

- Succeeded with measurable result.
- Succeeded without data movement.
- Not needed.
- Deferred for dependency.
- Blocked by policy.
- Blocked by evidence.
- Failed and retryable.
- Failed and requiring remediation.

Implement these as consistent operational semantics.

Where database task-state constraints currently prevent a true "Not needed" status, design a backwards-compatible migration instead of permanently interpreting cancellation as success or not-needed.

Historical plans must retain truthful outcomes. Correct legacy reporting through reconciled outcome records rather than rewriting immutable execution history.

IQ-00053

Monitor timeout rates after v2.15.426.

Use actual evidence to tune batch size and concurrency.

Keep any automatic adjustment within approved operational limits.

Validate throughput and persistence, not only successful function calls.

IQ-00066

Verify that plans contain eligible executable work.

Detect false progress where no actual records were improved.

Prevent repeated empty cycles.

IQ-00064

Recover interrupted page-search jobs automatically.

Ensure expired leases, duplicate execution and stale dependencies are reconciled.

8. Provider website correction and identity controls

For onboarding provider "2db6cb5e…", the currently supplied website value is malformed:

"https://info@newgen.edu.au"

Do not derive or approve a provider website merely by removing the email prefix.

The candidate "https://newgen.edu.au" remains unverified.

The AI controller must independently locate the provider through authoritative registers and first-party evidence.

Check the registered identity, official domain, website redirects and matching provider details.

If sufficiently verified, submit a provenance-backed correction through the authorised data-maintenance path.

If the identity remains uncertain, retain the record in a named blocked state with supporting evidence.

Do not repeatedly onboard it.

Do not publish an invented website or substitute another provider's domain.

Generalise this repair into permanent provider identity and website validation across the catalogue.

9. Provider and country lifecycle housekeeping

Implement consistent archival and retirement behaviour.

If a provider is verified as deregistered, closed, merged or otherwise legitimately retired:

- Record authoritative evidence and effective date.
- Distinguish retirement from a temporary website outage or crawl failure.
- Apply the appropriate provider lifecycle transition.
- Reconcile related courses, scholarships, entry requirements and source mappings.
- Cancel or retire inappropriate future jobs.
- Remove invalid work from active Layer 4 queues.
- Update official-register reconciliation and consumer projections.
- Preserve audit history and historical evidence.

Apply equivalent relationship-aware lifecycle management when an entire country is retired.

Do not cascade deletions or retirement from weak AI inference.

Use reversible or versioned lifecycle transitions where applicable.

10. Autonomous Layer 4 preparation

The controller must improve Layer 4 readiness without bypassing human review.

Automatically:

- Repair invalid source links.
- Resolve stale or missing evidence where permitted.
- Reconcile duplicate proposals.
- Detect superseded work.
- Classify technical blockers.
- Route items to the appropriate review kind.
- Identify existing approvals that remove the need for duplicate review.
- Verify admission results after authorised decisions.

Preserve:

- Manual locks.
- Evidence provenance.
- Source freshness.
- Decision history.
- Admission policies.
- Human-review authority for judgement-sensitive cases.

Do not convert technical repair authority into automatic permission to approve substantive entry requirements, scholarships or uncertain source interpretations.

11. Budget-aware execution

Introduce an AI cost and yield controller.

Every enrichment or discovery plan must estimate:

- Expected eligible records.
- Expected data recovery.
- Evidence already available.
- Estimated incremental cost.
- Likelihood of useful output.
- Existing in-progress work.
- Retry expenditure and previous failure reason.

Prioritise work with the highest expected verified improvement per unit of cost, while maintaining critical correctness and safety priorities.

Prevent:

- Repeated AI reads of identical evidence.
- Repeated searches with no new information.
- Paid acquisition for already stored pages.
- Unlimited retries.
- Expensive low-confidence extraction loops.
- High-volume scans of providers known to be ineligible.

Apply rate limits, daily budgets, bounded concurrency and circuit breakers.

D1 and other established spending controls remain authoritative.

12. Continuous coverage validation

Build permanent provider-to-record reconciliation.

For each active country and provider, calculate:

- Official-register status.
- Provider discovery coverage.
- Course coverage.
- Course-field completeness.
- Scholarship coverage.
- Entry-requirement coverage.
- Source-proof completeness.
- Layer 4 backlog.
- Blocked and unresolved work.
- Last successful acquisition.
- Last verified source refresh.
- Autonomous recovery yield.

Compare coverage across pipeline stages and downstream consumers.

Detect unexplained decreases, missing providers, unexpected retirements, admissions that did not publish and source records that failed to propagate.

A successful queue run is not sufficient evidence of healthy catalogue coverage.

13. Validation and regression feedback loop

Every autonomous correction must produce evidence of:

1. The original defect.
2. The identified root cause.
3. The selected remediation.
4. The actual execution result.
5. The resulting database changes.
6. Any affected downstream consumers.
7. Regression-test results.
8. The post-fix monitoring outcome.
9. Whether the same defect recurred.

Automatically create or update issue records when corrections fail.

Reopen an issue if the defect recurs or its remediation proves ineffective.

Continue bounded autonomous investigation and correction until the issue is resolved, genuinely blocked or requires a governed decision.

Do not close an issue solely because a job executed, a pull request merged or a release deployed.

Close it when the expected operational and data results are verified.

14. Parallel agent development and integration

Use the maximum safe parallelism supported by available development tools.

Divide development into bounded workstreams:

- A: AI Operations Controller and root-cause engine.
- B: Source discovery and coverage recovery.
- C: Scholarship and AER completeness.
- D: Pipeline self-healing and queue lifecycle.
- E: AI evaluation and controlled self-improvement.
- F: Cost optimisation and observability.
- G: Provider lifecycle and cascading housekeeping.
- H: Integration, regression testing and operating documentation.

Identify shared schemas and interfaces before parallel implementation.

Assign explicit ownership to avoid conflicting database changes.

Maintain an integration queue covering cross-workstream dependencies, failed tests, unresolved interface mismatches and deployment blockers.

Continuously reconcile that queue until fixes are integrated and validated.

Do not mark an individual workstream complete if its functionality fails at integration.

Preserve the existing production release checks, migration controls, automated tests and rollback mechanisms.

Deploy compatible releases incrementally rather than merging an unverified large change.

15. Operational decisions and escalation policy

Decisions already authorised

Proceed autonomously with:

- Investigation and diagnosis.
- Reuse of existing evidence.
- Free source discovery within approved operational limits.
- Idempotent repair of operational state.
- Recovery of stale or interrupted work.
- Removal of empty plans.
- Eligibility validation.
- Retry suppression.
- Deduplication.
- Monitoring and alerts.
- Evaluation and proposal of improvements.
- Reversible settings optimisation within approved bounds.
- Non-destructive documentation updates.
- Creation of regression tests.

Changes requiring existing engineering release gates

- Production code modifications.
- Database migrations.
- Schema and constraint changes.
- Material pipeline-routing changes.
- New autonomous agent permissions.

These can be developed and tested without repeated owner approval, but must pass the established controlled deployment process.

Decisions requiring explicit authorisation

- Increasing paid-service budgets or enabling D1 paid search.
- Removing manual locks.
- Weakening Layer 4 admission safeguards.
- Destructive or irreversible record changes.
- Material security or permission changes.
- Publishing unverified official sources.
- Any action outside the established operational authority.

When escalation is required, provide consolidated options, evidence, costs, risks and a recommended decision.

Do not block unrelated authorised work.

16. Continuous reporting

Provide one consolidated operational report instead of fragmented issue updates.

The report must show:

Platform health

- Scheduler and worker health.
- Current failures.
- Time-outs and retries.
- Recovery success.
- Stuck jobs and dependencies.

Data improvement

- Missing fields at start and end.
- New verified records.
- Courses repaired.
- Scholarships added.
- AER coverage improved.
- Descriptions and deadlines recovered.
- Source identities resolved.

Autonomy

- Issues detected automatically.
- Root causes diagnosed.
- Corrections executed.
- Corrections verified.
- Issues reopened.
- Interventions requiring human decisions.

Efficiency

- Paid operations and cost.
- Evidence cache reuse.
- Avoided duplicate reads.
- Useful yield per execution.
- AI and Firecrawl consumption.
- Estimated cost per verified improvement.

Governance

- Changes deployed.
- Versioned AI improvements.
- Regression results.
- Layer 4 backlog.
- Open policy blockers.
- Consumer consistency.

Produce hourly internal checkpoints and daily consolidated summaries using existing reporting and delivery infrastructure.

Alert immediately for critical security, integrity, budget or production incidents.

Avoid repetitive notifications when the same incident is already being handled.

17. Acceptance and unattended-operation test

First establish a live baseline.

Then validate at least 24 consecutive hours of unattended operation with no manual dispatch of routine work.

The acceptance test must demonstrate:

1. Scheduled cycles execute as intended.
2. Eligible work is selected automatically.
3. Verified data improvements continue.
4. Jobs recover from transient failures.
5. Permanent defects enter diagnosis rather than infinite retries.
6. AI operations remain within established cost controls.
7. No unauthorised Layer 4 admission occurs.
8. No manual locks are overridden.
9. No unexplained data loss or retirement occurs.
10. No new critical regression appears.
11. Downstream consumer integrity remains intact.
12. The controller detects and resolves representative recoverable failures.
13. Unresolvable issues are accurately classified and escalated.
14. Production metrics match reported outcomes.

A 24-hour pass establishes operational sustainability for the tested period; it does not establish indefinite reliability or zero future defects.

Continue monitoring after acceptance.

18. Documentation and permanent operating model

Update the Admin repository with:

- Autonomous AI architecture.
- Agent responsibility boundaries.
- Decision rights and escalation matrix.
- Root-cause taxonomy.
- Recovery playbooks.
- Source-discovery and evidence-reuse SOP.
- AI evaluation and self-improvement policy.
- Budget guardrails.
- Coverage validation rules.
- Release and rollback procedures.
- Operational scorecards.
- 24-hour acceptance evidence.
- Outstanding risks and residual limitations.

Document implemented behaviour, not only planned features.

Retire or consolidate superseded scripts, prompts and monitoring functions after dependency verification.

Do not create multiple competing sources of operational truth.

19. Immediate execution sequence

Phase 0 — Current-state reconciliation

Verify live release state and outstanding IQ incidents.

Phase 1 — Stabilisation

Finish IQ-00053, IQ-00066 and IQ-00064 validation and recovery. Resolve provider website identity through evidence, not guessing.

Phase 2 — Autonomous controller

Implement event correlation, root-cause analysis, guarded remediation and verification.

Phase 3 — Coverage recovery

Connect source-proof, course fields, scholarship, AER and provider discovery to the controller.

Phase 4 — Self-improvement

Implement evaluation datasets, versioned AI instructions, canary testing, rollback and outcome learning.

Phase 5 — Platform integration

Complete cross-workstream integration, queue reconciliation, release testing and documentation.

Phase 6 — Acceptance

Execute the 24-hour unattended test and verify real catalogue improvement.

Phase 7 — Continuous operations

Enable ongoing autonomous remediation, coverage validation, cost optimisation and reporting.

20. Final operating principle

StudySearch must not rely on the platform owner noticing that a university is missing, a scholarship collection is incomplete, a course has no entry requirements or a pipeline has repeatedly failed.

These should be detected and investigated by the platform.

The platform must use its own AI intelligently, reuse reliable evidence, execute permitted corrections, verify outcomes and improve its operating methods.

A detected issue is not resolved until the intended result has been verified.

A successful job is not proof of successful data enrichment.

Self-improvement does not authorise self-expansion of permissions, budgets or admission authority.

Claude should implement the operating capability; StudySearch should perform the routine operational work thereafter.

Start by reconciling the deployed baseline and opening the parallel development workstreams. Execute all authorised stages without repeated confirmation. Escalate only decisions genuinely outside the existing mandate.