# StudySearch — Overnight Autonomous Execution Mandate: Platform Admin direction (verbatim)

**Received:** 1 Nov 2026, 22:01 AEDT. Saved verbatim before implementation (operating model).

---

# StudySearch — Overnight Autonomous Execution Mandate
## Role Simulation, UI Remediation, Operational Assurance and Layer 4 Settlement

**Mandate window:** Next 8–10 hours from receipt, covering the overnight period of 1–2 November 2026 AEDT.

**Execution mode:** Maximum safe parallelism, minimal supervision, continuous documented checkpoints.

**Primary objective:** Deliver the greatest possible number of verified operational improvements by morning, without reverting unrelated development, weakening safeguards or waiting unnecessarily for user replies.

This extends the existing StudySearch engineering mandate. Do not restart completed work.

## 1. Canonical authority and starting point

Read and follow:

- `docs/platform/nz-enrichment-brief/INDEX.md`
- `docs/platform/AGENT-OPERATING-MODEL.md`
- `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`
- `docs/platform/nz-enrichment-brief/2026-11-01-role-guides-usability-operability-review.md`
- `docs/platform/nz-enrichment-brief/2026-11-01-ss016-acceptance-walkthroughs.md`
- `docs/platform/nz-enrichment-brief/2026-11-01-layer4-batch-L4B-1253.md`
- `docs/platform/nz-enrichment-brief/2026-11-01-layer4-exception-decision-pack.md`
- `docs/platform/nz-enrichment-brief/2026-11-01-provider-bulk-review-design.md`
- Pilot repository `CLAUDE.md`

Reconcile the current live release, Admin register, deployed permissions and review queue before making changes.

Last known release: v2.15.395, Pilot `73f46d1a`, PR #787, 1,355 passing tests.

Last recorded state:
- Engineering: 11/15 completed.
- SS-016: 2/17 accepted; 8 implemented awaiting acceptance; 7 remaining.
- Layer 4: 1,355 pending; 519 verified decisions; 458 admitted items; 1,230 Active AER rows.
- UR-18 bulk-review feature: design only, production disabled.
- E1, E14, E11–E13 and D-B1–D-B4 have outstanding approval boundaries.

These are reference values, not current live measurements.

## 2. Parallel execution strategy

Use Claude's available subagents, independent workflows and browser/computer-use capabilities wherever supported.

Create five coordinated workstreams. If actual parallel agents are unavailable, execute the same workstreams sequentially in priority order.

### Agent A — UI Role Simulation and Acceptance

Ownership: SS-016 acceptance and end-to-end user journeys.

### Agent B — UI Defect Remediation

Ownership: React navigation, review controls, evidence presentation, usability defects and regression tests.

### Agent C — Operational Engineering and Documentation

Ownership: remaining UR findings, role guides, SOPs, controls, health visibility and release/recovery checks.

### Agent D — Layer 4 Review Settlement

Ownership: eligible stored-evidence review decisions through authorised UI paths, only if there is no other active settlement controller.

### Agent E — QA, Integration and Production Verification

Ownership: test orchestration, browser walkthroughs, integration checks, deployment verification and evidence reconciliation.

**One primary integrator is mandatory.**

The integrator owns the execution register, change-control sequencing, shared-file conflicts, merge decisions and production deployment order.

No two agents may independently deploy conflicting changes, edit the same migration, or submit decisions against the same review item.

Independent read-only test work may proceed concurrently.

## 3. Highest priority — Simulate all six roles

Claude has access to an authenticated browser session. Use it for live Platform Admin walkthroughs and to validate deployed navigation.

For lower-role scenarios, create isolated test fixtures or use existing authorised test accounts and sessions.

Do not impersonate another production user, weaken authentication, fabricate sessions or alter production role assignments merely to pass tests.

Where the browser exposes only Platform Admin, reproduce lower-role controls in an isolated environment using real application routing, effective permissions and actual server authorisation functions.

Test these six roles:

| Role | Required end-to-end journey |
|---|---|
| Viewer | Find course, inspect provenance, restricted Evidence response, no write access |
| Counsellor | Search, shortlist, interpret estimates and English requirements, submit correction report |
| Curator | Edit sourced information, preserve provenance, complete eligible non-AER review, correctly denied AER approval |
| Pipeline Operator | Diagnose failures, start permitted tasks, escalate pacing/pause; verify rank-4 denial |
| PIM Admin | Pause/resume an authorised fixture job, change permitted settings, test adapter, respect rank-6 restrictions |
| Platform Admin | Approve review, verify destination, inspect health/alerts, compare backup, perform safe recovery rehearsal |

For every role:

1. Identify the actual minimum effective rank.
2. Open the relevant UI journey.
3. Test permitted navigation and actions.
4. Test at least one forbidden action.
5. Confirm the server enforces the expected role boundary.
6. Verify the displayed message identifies the correct next owner.
7. Check the audit record and expected destination state.
8. Record Pass, Fail or Insufficient Evidence.

Do not claim a real lower-role session was tested when only an isolated fixture was used. Label fixture tests and live tests separately.

## 4. Close SS-016 acceptance gaps urgently

Prioritise the eight implemented-but-unaccepted findings.

**UR-01:** Compare Alerts guide, Health and settings. Verify raised, sent, received and recovery states. Actual recipient receipt remains externally dependent; do not invent confirmation.

**UR-02:** Exercise rank-4 and rank-5 permission paths in isolated fixtures or authorised accounts. Verify both allow and deny behaviours.

**UR-03:** Rehearse a controlled SOP mirror conflict using separate temporary branches or isolated repository copies. Verify one stale writer cannot silently overwrite the other.

**UR-04:** Test item traversal beyond 200 while insertions and decisions occur. Prove stable refs, no duplicates and no starvation.

**UR-05:** Verify a complete evidence-to-destination correction using fixture-backed records, or an independently authorised real correction. Confirm saved provenance.

**UR-07:** Attempt single-job and area-level Resume on retired fixture jobs. Confirm server refusal and correct UI state; verify an active paused fixture job can resume.

**UR-09:** Replay current routes, Back navigation and legacy bookmarks for every supported role.

**UR-17:** Validate specialist task guides and exact destinations at each allowed role. Confirm denied role paths show an appropriate handoff.

UR-06 and UR-13 are already accepted. Retain their acceptance unless new evidence reveals a regression.

For each test failure, implement the smallest safe correction and rerun the failed journey.

Do not stop after finding a defect; fix, test and verify it under normal release governance.

## 5. Complete remaining SS-016 implementation

After the highest-priority acceptance gaps, progress the remaining findings:

- UR-08: automation and admission ownership descriptions.
- UR-10: effective budget modes and refusal reasons.
- UR-11: freshness, source and snapshot labels.
- UR-12: retirement criteria and component dependencies.
- UR-14: compatible recovery baseline and rehearsal design.
- UR-15: backup scope, recovery usability and runbook.
- UR-16: test-register and semantic contract consistency.

Confirm the current status of each finding first. Do not duplicate work already implemented by another active branch or release.

Prefer changes to existing screens, guides, tests and scripts.

No unnecessary second dashboard, separate SOP system, new monitoring framework or paid tooling.

For UR-14, do not promote a rollback baseline without the required acceptance and compatibility evidence. Complete the safe investigation and isolated rehearsal first.

## 6. Layer 4 — Continue authorised settlement

If no other review controller is active, resume from the current batch using the canonical v5 playbook.

Focus on eligible items that can be decided using existing stored evidence.

Verify every item is pending immediately before its decision.

Save one decision at a time and verify audit and actual destination outcomes.

Exclude items requiring unavailable evidence, new policy, paid reads, provider-merger authority or unresolved interpretation.

Preserve the existing holds on RMIT, QUT, ANU and similar source/scale issues.

Do not use generic bulk AER approval or direct database settlement.

If another ChatGPT Work controller is active, Agent D must remain read-only and instead assist with exception analysis and fixture tests.

Keep review settlement independent of deployment work, but pause writes during Layer 4 contract changes until compatibility is verified.

## 7. UR-18 — Provider-level bulk review

Continue safe design validation and implementation preparation.

The proposed solution must:

- Reuse the existing university view.
- Support provider → field → evidence scope → eligible courses → preview → confirm → verify.
- Respect current manual locks.
- Use deterministic operation keys and idempotent retries.
- Show course-level exclusions and actual outcomes.
- Support safe rollback with audit.
- Keep academic entry review excluded from bulk actions.

Prioritise country, state, campus and course delivery location.

Intake and English eligibility must be separately scoped by course, campus, level and evidence.

**Approval boundary:** D-B1–D-B3 remain unratified. Do not implement changes requiring those approvals as though permission had been granted. Continue with read-only contract validation, test planning and other authorised work.

D-B4 production activation remains a separate explicit decision even after implementation and fixture verification.

## 8. E1, E14 and other held decisions

Preserve the outstanding exception-pack decisions.

E1: verify the current status, evidence and consumer impact of the 41 unsupported fee rows proposed for withdrawal.

E14: verify the 105 entry rows and their existing reason-gated withdrawal route.

Do not execute either withdrawal without specific authority.

E11/E12: validate RMIT and QUT recovery designs without undertaking unapproved paid source acquisition or AI reads.

E13: analyse the six-row completeness cap using existing stored copies and fixture-based tests. Do not initiate re-reading merely to fill the cap.

Produce one consolidated approval pack with exact IDs, expected impact, guards, rollback and cost ceilings, rather than interrupting the entire overnight programme for individual decisions.

## 9. Engineering execution and deployments

Use the existing approval and change-control framework.

Each independent agent may prepare and test its own changes, but the primary integrator serialises production deployments.

Before each authorised merge or deploy:

- Reconcile Pilot main and affected shared files.
- Confirm decision-before-code records.
- Run the applicable full test suite with zero failures and skipped tests.
- Validate migration and function checksums against live state.
- Perform safe dry runs where required.
- Confirm consumer API compatibility.
- Record the exact Replaces/Retires impact.

After deployment:

- Confirm live version and migration head.
- Confirm relevant function md5 values.
- Run deployed UAT.
- Inspect the actual affected browser journeys.
- Confirm no new regression in Layer 4, Jobs, Guides or consumer behaviour.
- Update Admin with the verified outcome.

Do not automatically revert or roll back an unrelated release. If a deployment fails, stop that release lane, preserve the last known good state and use the documented approved recovery procedure.

No destructive database operations or consumer API shape changes without the required separate authorisation.

## 10. Overnight schedule and checkpoints

Target an 8–10-hour execution window if the environment supports persistent operation.

**Hours 0–1:** Live reconciliation, parallel work allocation, role fixtures and critical UI gap classification.

**Hours 1–3:** Role simulations, UR-02/03/04/07/09/17 acceptance and immediate defect fixes.

**Hours 3–5:** Remaining UI corrections, Guides, operations and safe engineering releases.

**Hours 5–7:** Deeper end-to-end integration testing, recovery/backup fixtures, eligible Layer 4 settlement.

**Hours 7–9:** Regression testing, reconciliation, clean releases and remaining accepted UR closure.

**Final hour:** Independent verification and morning handover.

This is an ordering and execution budget, not permission to skip verification or a guarantee that every lane will finish.

At each substantial milestone and approximately hourly while actively running, publish a consolidated checkpoint to the canonical Admin record.

Avoid excessive chat messages. Do not ask the user to confirm routine progression.

If the environment does not support unattended continuation, persist all checkpoints and exact resumption instructions before ending. Do not report that work continued while the session was inactive.

## 11. Mandatory progress dashboard

Every consolidated checkpoint must begin with:

**StudySearch Overnight Progress — [AEDT date/time]**

**Engineering:** X/15 verified complete; X verifying; X in progress; X remaining.

**SS-016:** X/17 accepted; X implemented awaiting acceptance; X not implemented.

**Role simulation:** X/6 live role journeys passed; X/6 fixture role journeys passed; X blocked by missing authorised session.

**UI remediation:** X defects found; X fixed; X deployed and verified; X unresolved.

**Layer 4:** Opening pending, current pending, verified decisions, admitted items, Active rows, new arrivals and exception counts.

**UR-18:** design, approval, build, fixture and production states separately.

**Releases:** exact Pilot SHA, version, test results and deployed verification.

**Next action:** three highest-value outstanding actions and their owner.

Do not combine counts from unrelated workstreams into one misleading percentage.

## 12. Morning completion report

By the end of the available execution session, produce one authoritative Admin record containing:

1. Starting versus final engineering progress.
2. Starting versus final SS-016 acceptance.
3. Six-role walkthrough coverage, clearly identifying live versus fixture tests.
4. UI defects corrected and deployed.
5. New releases, PRs and verification results.
6. Layer 4 decisions and actual admissions, if any.
7. Unresolved exceptions and approval-gated work.
8. UR-18 implementation/approval status.
9. Tests passed, failed or not executed.
10. Production health and any regression.
11. Exact remaining tasks and owners.
12. Next-session resumption instructions.

Do not claim acceptance for any incomplete journey.

## 13. Standing instruction

Maximise useful overnight progress through independent, non-conflicting workstreams.

Use available parallel agents and browser workflows where supported.

Continue authorised work without repeated user interaction.

When a workstream encounters an approval or authentication boundary, document the exact blocker, switch that workstream to safe read-only or fixture work, and continue the other workstreams.

Do not bypass role controls, data-admission rules, production safeguards or cost approvals.

**Begin now with live reconciliation, parallel role-acceptance testing and the highest-impact UI defects. Deliver verified improvements rather than additional planning-only reports.**