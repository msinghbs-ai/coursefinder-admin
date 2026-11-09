<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 07:41 AEDT (chat). -->

StudySearch — Continuous Multi-Agent Engineering and Production Closure

Platform Admin direction — 2 November 2026

Executive mandate

Continue StudySearch using a coordinated multi-agent delivery model.

The objective is sustained development, testing, verification, housekeeping and operational readiness, including overnight execution wherever the available environment supports it.

Do not stop the entire programme at each checkpoint or wait for another general GO.

The priority remains closing the existing product, preventing repeated defects and moving into self-sufficient operation.

Follow the canonical operating model, Admin execution register, current SS-015 accelerated acceptance decision, Pilot development rules and all existing approval boundaries.

1. Establish six independent delivery workstreams

Create up to six agents or independent execution workflows:

Agent A — Pipeline reliability

- Scheduler health and timeout analysis.
- Admission concurrency and locking.
- Retry, backoff and idempotency.
- Daily processing caps.
- SS-004 and SS-014 permanent corrections.

Agent B — Binding and data integrity

- E16 qualification-level binding prevention.
- Correct provider/course/variant/year matching.
- Scholarship ownership and audience.
- E13 completeness regression.
- Prevent incorrect data entering publication.

Agent C — Layer 4 and evidence housekeeping

- Reconcile E16 candidates.
- Reuse existing pending review items.
- Park unsupported data through the existing governed hold route.
- Audit duplicate links, superseded records, source evidence and outstanding exceptions.
- Verify consumer-visible containment.
- Maintain evidence and audit reconciliation.

Agent D — UI and user acceptance

- SS-016 remaining acceptance cases.
- Six-role fixture journeys.
- Available authenticated UI workflows.
- Navigation, denial messages and operational usability.
- Confirm existing role permissions are unchanged.

Agent E — Recovery and sustainable operations

- Restore rehearsal planning and approved execution.
- Recovery runbook.
- Alert delivery and escalation.
- Budget enforcement.
- Backup/evidence-storage coverage.
- UR-14 and UR-15 completion.

Agent F — QA and release assurance

- Full regression suite.
- Deployed desktop and phone UAT.
- Consumer API compatibility.
- Migration and function checksums.
- Release and deployment validation.
- Final SS-015 evidence reconciliation.

One primary integrator owns shared files, the release queue, production changes and the authoritative register.

2. Production resource isolation

The 07:00 and 07:03 admission timeouts demonstrate that engineering verification can itself disrupt production.

Implement a load-aware validation policy immediately.

Rules:

1. Heavy full-cohort queries run against isolated fixtures, an appropriate read-only replica or offline evidence where available.
2. Production validation uses indexed, bounded, paginated reads.
3. Do not run expensive scans alongside known busy admission windows.
4. Avoid multiple agents making independent large queries against production.
5. One integrator schedules production-facing verification.
6. Measure query execution, locks and scheduler delays.
7. Stop or throttle non-critical verification when production becomes constrained.
8. Use existing settings and mechanisms rather than introducing a new scheduler.

If replicas or isolated environments are unavailable, default to small, bounded production checks.

Do not confuse more concurrent agents with permission for more concurrent production workload.

3. Gate C — Treat the 07:00 incident accurately

Record:

- "coverage-admit" timeout at 07:00.
- "adapter-overwrite" timeout at 07:03.
- The contemporaneous heavy E13 verification query.
- Evidence of increased runtime and any database contention.
- Automatic recovery and subsequent successful runs.
- Confirmation of whether any records or queue states were affected.

Do not claim the original zero-failure T1 condition passed.

Classify the event separately as suspected validation-induced interference, pending root-cause verification.

Perform a bounded targeted retest after the heavy-query pattern is removed.

The Platform Admin's preferred disposition is an exception-based accelerated Gate C assessment, not an automatic restart of the entire project.

Acceptance may rely on this exception only if the revised decision explicitly records:

- The actual failed T1 result.
- Verified cause or remaining uncertainty.
- Remediation.
- Successful post-remediation evidence.
- Residual risk.
- Continuing seven-day monitoring.

A new unexplained production failure remains a genuine blocker.

4. Correct the unnecessary AI-matching calls

The D14 idle-pause mechanism is generating approximately 1,440 avoidable calls daily because its check includes the current unanswered call.

Fix the existing logic so the current in-flight attempt does not prevent an eligible idle pause.

Validate:

- Correct pause timing.
- No unintended permanent pause.
- Safe restart.
- No duplicate processing.
- No unnecessary paid AI reads.
- Accurate Health and scheduled-job reporting.

Use the existing SS-014 work item and regression coverage.

Do not create a new automation subsystem.

5. E16 — Permanent prevention and governed containment

Prioritise the binding identity fix.

Do not manually reacquire all 67 suspected wrong links as a release dependency.

Use the existing Layer 4 and SS-007 hold/review mechanism for unresolved records.

Retain valid records, quarantine unsupported published destinations and suppress independently verified wrong-course fees through the approved correction path.

Respect the exact approval boundaries for consumer-visible changes.

After containment:

- Verify Website and Zoho show no known incorrect values.
- Confirm each unresolved item has a review owner and evidence.
- Prove future wrong-programme binding is blocked.
- Complete the housekeeping and evidence audit.

Missing links and fees remain normal enrichment gaps, not engineering failures.

6. Release management

Each workstream may prepare and test independent changes.

Only the integrator merges and releases production changes.

Before release:

- Decision recorded in Admin.
- Exact scope and affected functions known.
- Full test suite green.
- No skipped required tests.
- Migration/function compatibility verified.
- Live dry run where applicable.
- Consumer contract checked.

After release:

- Live version confirmed.
- Migration history verified.
- Function checksums match.
- Deployed UAT passes.
- Affected operational workflow tested.
- Evidence recorded in Admin.

Batch compatible low-risk fixes when this reduces repeated release overhead without increasing deployment risk.

No conflicting deployments or competing production writes.

7. Continuous execution and overnight delivery

Operate workstreams continuously while the active session or authorised persistent automation supports execution.

Use independent parallel agents for code reviews, regression fixtures, evidence classification and documentation.

Use scheduled jobs for repeatable checks where a supported execution environment is available.

Do not claim that a dormant interactive session continues working autonomously.

Every session must leave:

- Exact repository and branch state.
- Open agent/workstream status.
- Test results.
- Pending release state.
- Current blockers.
- Next executable steps.

A resumed session must reconcile current state before proceeding.

Avoid repeated non-informative progress messages.

8. Scope discipline

No new broad audits or architecture programmes.

Every finding must be classified:

- P0: unsafe published data, security or irreversible integrity failure.
- P1: critical operational capability or handover blocker.
- P2: non-critical issue with safe containment.
- Normal operations: incomplete enrichment and held review data.

P0 must be corrected or safely contained.

P1 must be resolved or explicitly accepted with suitable containment under the approved operational gate.

P2 and normal data gaps must not repeatedly move the project deadline.

Do not reopen E1, E14 or E15 without new evidence of recurrence.

9. Continuous housekeeping

Use the existing platform mechanisms to verify:

- No uncontrolled duplicate official links.
- No incorrect primary selection.
- No orphaned evidence.
- No invalid admissions following E13.
- No unnecessary retry loops.
- No stale completed batches marked running.
- No obsolete operational jobs or scripts without retirement disposition.
- Accurate limits, runbooks and role guides.

Preserve history, evidence retention and manual protections.

Record all actual clean-up actions and before/after counts.

10. Required dashboard

Every meaningful checkpoint:

StudySearch Continuous Delivery — [AEDT timestamp]

- Active workstreams and completed deliverables.
- Engineering: completed/verifying/remaining.
- SS-016 accepted/implemented/pending.
- SS-015 Gates A–E with evidence.
- P0/P1 open and contained.
- E16 confirmed/contained/pending.
- Layer 4 pending and admitted.
- Test suite and deployed UAT.
- Production job failures and recoveries.
- Current version, commit and release.
- Spend and resource utilisation.
- Next release candidate and expected acceptance point.

Report outcomes and movement, not agent activity alone.

11. Production closure

Maintain the accelerated release-candidate and GO/NO-GO process.

Do not let routine data-enrichment work, P2 monitoring language, missing optional fields or an unresolved Layer 4 queue indefinitely delay handover.

Do not pass a failed safety condition by relabelling it.

A documented exception-based acceptance requires explicit risk acceptance and evidence of successful containment and recovery.

12. Immediate execution sequence

1. Record the 07:00/07:03 incident and isolate heavy production verification.
2. Complete the current deployed UAT and SS-015 evidence.
3. Finish the E16 prevention release and authorised quarantine.
4. Repair D14 idle-pause logic.
5. Complete housekeeping and evidence reconciliation.
6. Progress recovery runbook and authorised restore testing.
7. Continue SS-016 acceptance.
8. Prepare the next GO/NO-GO report.

Use independent agents wherever supported and maintain one release integrator.

Goal: continuous, sustainable delivery of the existing StudySearch platform, without unnecessary repeated manual validation, disruptive production testing or uncontrolled scope expansion.