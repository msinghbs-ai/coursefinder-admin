# StudySearch — Usability, Role Guides and Operational Excellence Remediation: Platform Admin mandate (verbatim)

**Received:** 1 Nov 2026, 11:48 AEDT. Saved verbatim before implementation (operating model).

---

# StudySearch — Usability, Role Guides and Operational Excellence Remediation

## 1. Executive mandate

Integrate the independent ChatGPT browser-based usability review into the **existing StudySearch development programme**.

Canonical review:

https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-01-role-guides-usability-operability-review.md

Read the complete review, including findings UR-01 through UR-17, recommended implementation order, evidence limitations and acceptance criteria.

Also follow:

- `docs/platform/AGENT-OPERATING-MODEL.md`
- `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`
- Pilot `CLAUDE.md`
- Existing StudySearch transformation and operational-acceptance records.

**Do not restart the existing programme or duplicate completed work.**

The goal is to improve the current StudySearch platform so that each authorised role can reliably navigate, operate, maintain, troubleshoot and complete its assigned tasks.

## 2. Integration with ongoing development

This is an additional authorised engineering workstream, not a replacement for existing SS-004 through SS-015 work.

Before implementing:

1. Reconcile the review findings against the latest Pilot main, live deployment and ongoing development branches.
2. Identify findings already corrected by concurrent changes.
3. Identify overlaps with existing SS tasks, PRs, migrations and scheduled work.
4. Record UR-01–UR-17 in the single StudySearch execution register, mapped to existing SS task IDs or new IDs allocated only where necessary.
5. Preserve existing approvals and verification milestones.
6. Avoid modifying files involved in another in-progress release without coordinating the changes.

If an existing release is currently undergoing deployment or verification, do not interrupt it unnecessarily.

Continue independent authorised investigations while that release completes.

## 3. Execution priorities

### Tranche A — Operational correctness and role guides

Address:

UR-01, UR-02, UR-03, UR-08, UR-09, UR-10 and UR-17.

Deliver:

- Accurate alerting guidance reflecting the existing D12 push/email implementation.
- Correct role responsibility for diagnosing, pausing, pacing and controlling jobs.
- Role-aware navigation to the exact task, tab and destination.
- Correct documentation of conditional automatic admission versus human review.
- Accurate budget controls, Observe mode and enforced spending gates.
- Discoverable specialist AER and incident-response instructions.
- Synchronised Pilot and Admin SOP copies with controlled consistency checks.

Do not broaden permissions merely to match outdated documentation.

Do not introduce a second guide system or duplicate SOP framework.

Validate that existing user-facing instructions agree with actual permissions and deployed behaviour.

### Tranche B — Layer 4 Review usability and settlement completion

Address:

UR-04, UR-05 and UR-06.

**This is a priority workstream because Layer 4 settlement is currently being undertaken through ChatGPT's interactive browser.**

#### UR-04 — Review-list pagination

The current review list requests only 200 items per kind.

Implement stable, server-supported pagination or cursor traversal in the existing Layer 4 interface.

Requirements:

- Reach every eligible item in kinds containing more than 200 items.
- Preserve oldest-first processing.
- Use stable item identifiers and deterministic ordering.
- Avoid duplicate decisions during concurrent updates.
- Restore kind, provider, filter and position after destination navigation.
- Avoid raising the 200-item cap as a substitute for pagination.

#### UR-05 — Evidence and destination visibility

Improve existing review cards to expose the evidence required for safe decisions.

Include, where available:

- Stable review reference.
- Source and evidence link.
- Capture date and newest-copy indication.
- Course/provider identity.
- Manual lock or ownership restrictions.
- Current and proposed values.
- Relevant fee year, currency and basis.
- Entry-score scale, qualification and scope.
- Direct correction destination.

Reuse existing evidence overlays and destination screens.

Do not introduce a separate Layer 4 review console.

#### UR-06 — Verified settlement outcomes

Improve the existing decision-completion response.

Clearly distinguish:

- Admitted or applied values.
- Reconciled without admission.
- Rejected or excluded values.
- Superseded and retained rows.
- Deferred outcomes.
- Downstream work still pending.
- Uncertain or failed decisions.

Expose existing audit identifiers and destination links where available.

Do not count a disappearing review card as proof that a value was admitted.

Ensure a reviewer can verify the actual destination outcome before proceeding.

#### Regression cases

Include the earlier Niagara central-page timeout and ANU score-interpretation issues as regression scenarios.

Do not assume these issues remain live without reproducing them.

Preserve the canonical Layer 4 action playbook, role restrictions and one-decision-at-a-time requirements.

**Acceptance:** demonstrate complete traversal of a kind containing more than 200 pending items and verified settlement outcomes through each supported route.

### Tranche C — Maintenance, retirement and recovery safety

Address:

UR-07, UR-13, UR-14 and UR-15.

Priorities:

1. Prevent logically retired jobs from displaying operational Resume controls or being restarted through area-level controls.
2. Harden `scripts/ci/apply-migration.sh` so an already-applied migration is checked against recorded history before being skipped.
3. Validate a compatible recovery release rather than assuming the older v2.15.79 baseline remains appropriate.
4. Clarify backup scope and distinguish publishing/settings recovery from full disaster recovery.
5. Prepare an isolated restore and recovery rehearsal.

Do not automatically accept a new release as the rollback baseline.

Do not execute destructive cleanup or live restoration under this mandate.

Where acceptance requires release-owner approval, prepare the evidence and one consolidated decision request.

### Tranche D — Durable operational assurance

Address:

UR-11, UR-12 and UR-16, plus the six role walkthroughs.

Deliver:

- Correct freshness and capture-time labels on operational metrics.
- Consistent live-versus-snapshot queue figures.
- Reconciled Admin INDEX and execution-register references.
- Accurate test-register counts.
- Stronger central semantic tests for guides and role-dependent navigation.
- Retirement criteria that consider dependencies and business purpose, not only screen-use counts.

Validate these roles:

Viewer, Counsellor, Curator, Pipeline Operator, PIM Admin and Platform Admin.

For each, verify permitted actions, forbidden actions, task navigation, outcomes and escalation ownership.

Use isolated test accounts or appropriate fixtures. Source inspection alone must not be reported as a completed live role walkthrough.

## 4. Engineering principles

Retain and improve existing architecture.

Avoid:

- New databases or unnecessary tables.
- A separate Layer 4 settlement console.
- Duplicate SOP generators.
- New monitoring frameworks.
- Unnecessary background jobs.
- Hard-coded operational thresholds.
- Redundant tests where central guards already exist.
- Rewriting completed components solely for cosmetic reasons.

Prefer small, reversible, measurable changes with clear Replaces/Retires records.

## 5. Execution autonomy and approval boundaries

Complete routine internal engineering, testing, governed releases and production verification under the existing operating model.

Do not request permission after every UR finding.

Prepare related improvements in sensible releases rather than seventeen separate releases.

Keep existing approvals for:

- Consumer-visible API changes.
- Destructive operations and retirements.
- Changes to security authority.
- New paid processing.
- Production restore operations.
- Material changes to data admission policy.

If a finding requires separate approval, complete its design and testing, record the blocker and continue with the next authorised work item.

Any consumer API change requires the existing developer-guide issue, version line, compatibility assessment and handover.

## 6. Progress reporting — mandatory

Every substantial update must begin with:

**StudySearch Progress — [date/time]**

**Existing engineering programme**
- Completed and verified: X/15.
- Verifying: X.
- In progress: X.
- Blocked: X.
- Overall completion: X%, derived from the canonical SS register.

**Usability remediation**
- Findings: 17.
- Implemented and verified: X/17.
- In progress: X.
- Remaining: X.
- Tranche: A/B/C/D.
- Current UR finding(s).
- Next action.

**Layer 4 settlement**
- Live pending count.
- Reviewed and settled.
- Admitted values.
- Deferred/downstream.
- Remaining eligible and exception work, where known.

Do not confuse engineering completion percentages with Layer 4 queue progress.

Display measurable improvements and exact release references.

Keep the dashboard concise.

## 7. Release and verification

For every implementation tranche:

1. Record the change decision in Admin.
2. Confirm current source and deployed compatibility.
3. Identify affected roles and downstream integrations.
4. Implement the smallest necessary changes.
5. Update the existing test guards.
6. Run the complete applicable suite with no failures or skipped tests.
7. Perform required safe dry runs.
8. Verify existing function checksums where relevant.
9. Follow the existing release authority and deployment controls.
10. Verify live behaviour and record before/after evidence.

Do not claim completion from a passing unit test or successful merge alone.

## 8. Success criteria

The programme succeeds when:

- Operational guides reflect actual deployed behaviour.
- Role instructions agree with effective permissions.
- Layer 4 can traverse and settle large queues without hidden items.
- Reviewers can inspect required stored evidence and destination records.
- Decision outcomes show actual admissions and saved corrections.
- Retired components cannot accidentally restart.
- Migration history cannot silently accept modified previously applied files.
- Recovery instructions and supported backups are demonstrably usable.
- Operational metrics clearly identify their source and freshness.
- All six role workflows have documented, verified acceptance results.

Maintain the Admin repository as the authoritative record throughout.

## 9. Immediate instruction

Continue the existing development session.

First reconcile all UR findings with current Pilot changes and the SS execution register.

Then prioritise the smallest safe improvements that unblock Layer 4 settlement, followed by operational-guide correctness, maintenance safeguards and role-based validation.

You may prepare independent tranches in parallel, but coordinate production releases to avoid conflicts.

**Do not stop after each finding or ask for another general GO. Deliver substantial verified improvements across related findings, while respecting genuine governance boundaries.**

At the next milestone, provide the updated execution dashboard, changes delivered, outstanding findings, live verification results, and exact Admin/Pilot commit references.