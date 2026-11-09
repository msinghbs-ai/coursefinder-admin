# StudySearch — Renewed Execution Mandate: Platform Admin direction (verbatim)

**Received:** 1 Nov 2026, 19:42 AEDT. Saved verbatim before implementation (operating model).

---

StudySearch — Renewed Execution Mandate

Layer 4 Settlement, UI Operability and Production Readiness

Date: 1 November 2026

1. Mandate

This instruction renews the existing StudySearch execution mandate. Continue from the latest verified checkpoint without restarting completed work.

Operate as the senior data engineer and primary integrator for StudySearch.

Read and follow the canonical operating model, current execution register and relevant implementation records.

Admin repository: "msinghbs-ai/coursefinder-admin"

Pilot repository: "msinghbs-ai/Coursefinder-Pilot"

Required references:

- "docs/platform/AGENT-OPERATING-MODEL.md"
- "docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md"
- "docs/platform/nz-enrichment-brief/2026-11-01-layer4-batch-L4B-1253.md"
- "docs/platform/nz-enrichment-brief/2026-11-01-role-guides-usability-operability-review.md"
- "docs/platform/skills/cf-layer4-kbe/SKILL.md"
- "docs/platform/skills/cf-layer4-kbe/references/action-playbook.md"

2. Reconcile the latest checkpoint

Last reported figures:

Metric| Verified
Layer 4 opening pending| 1,870
Latest pending| 1,374
Decisions saved| 498
Admitted items| 437
AER rows Active| 1,173
AER remaining| 560
SS-016 findings technically implemented| 5/17
SS-016 findings accepted| 0/17
Existing engineering programme| 10/15 completed

Treat these as historical checkpoint figures, not live values.

Reconcile the current state, audit events, admissions, exceptions and outstanding tasks before executing further work.

Do not repeat previously saved decisions.

3. Priority 1 — Finish actionable Layer 4 settlement

Continue from batch "L4B-20261101-1253", using the existing controller and v5 action playbook.

Proceed in this order:

A. Remaining small-provider AER reads

Process the remaining providers with 1–22 course-entry reads.

Verify each row against its quote and newest stored copy.

Approve only supported entries and verify actual Active destination rows.

B. QUT — 38 held items

Review decision-pack item E12.

Separate domestic entry rules from international requirements.

Use Approve except only where the existing D4 rules and current active-row state permit it.

Hold any conflicting or unsupported item.

C. RMIT — 298 items

The previous source contained domestic-student information.

Do not approve from those copies.

Prepare the exact controlled recovery requirements for an international-view source and fresh read, subject to existing ingestion/spend authority.

D. Monash, AUT and ANU exceptions

Keep the previously held items pending until their evidence issues are resolved.

Do not invent grades, qualifications, country scope or missing conditions.

E. All remaining Layer 4 kinds

Traverse the remaining kinds using stable references.

Settle only eligible items supported by the existing evidence and decision rules.

Track reconciled, admitted, deferred, downstream and pending outcomes separately.

Do not force the queue to zero.

4. Priority 2 — Complete SS-016 UI usability improvements

Five findings have been implemented but not yet accepted:

UR-04, UR-05, UR-06, UR-07 and UR-13.

Complete their required acceptance tests before marking them finished.

Immediately address the observed UI issues:

- Proposed fee, currency, year and fee basis must be clear on review cards.
- Deep links must select the correct Layer 4 kind without showing stale results.
- Review position, filters and stable references must survive navigation.
- A completed decision must show actual admissions and downstream outcomes.
- Large review kinds must remain fully traversable beyond 200 items.

Then implement UR-01, UR-02, UR-03 and UR-17.

Correct alert guidance, role permissions, SOP synchronisation and specialist guide discovery.

Continue the remaining UR findings according to the canonical priority and dependency order.

Do not duplicate existing screens, scripts, SOP systems or monitoring tools.

5. Priority 3 — Close production engineering verification

Continue SS-004, SS-007, SS-010, SS-014 and SS-015 according to their verified milestones.

Preserve the existing 24-hour, seven-day and two-week observation windows.

Do not declare production acceptance before the required evidence is complete.

Maintain the current production holds, spend restrictions, consumer API contracts and release safeguards.

6. Execution autonomy

This mandate authorises continuing normal, already-approved engineering, testing, deployment and evidence-supported UI settlement under existing governance.

Do not ask for another general GO between tasks.

Where a separate policy, source-acquisition, merger, paid-processing, security or destructive-change approval is required, prepare a consolidated decision pack and continue other authorised work.

Do not allow multiple settlement controllers to act on the same refs.

Pause review writes if a deployment changes the Layer 4 decision contract until compatibility has been verified.

Do not use SQL or bulk approval to bypass the UI settlement procedure.

7. Mandatory progress dashboard

Every substantial checkpoint must start with:

StudySearch Progress — [AEDT date/time]

Engineering: X/15 completed, X verifying, X in progress, X remaining — X%.

UI usability: X/17 accepted, X technically implemented awaiting acceptance, X remaining.

Layer 4: X opening, X currently pending, X decisions verified, X items admitted, X Active destination rows, X exceptions.

Current work: SS-XXX / UR-XX / Layer 4 kind.

Next milestone: Specific action and acceptance evidence.

Report movement since the last checkpoint, not only cumulative totals.

Never equate a reduced pending queue with successful admission or full completion.

8. Completion criteria

Continue until:

1. Every eligible Layer 4 item supported by current evidence is settled and verified.
2. Unresolved items are classified by reason, owner and next action.
3. All 17 SS-016 findings have documented disposition and their approved improvements have been verified.
4. Role-specific UI workflows have been tested against their actual permission boundaries.
5. The current engineering tasks have satisfied their respective acceptance criteria.
6. The Admin execution register reflects the exact current state.
7. Releases, migrations, tests and change-control records are complete.

Do not declare the whole platform production-ready solely because a review queue has reduced.

9. Immediate execution

Resume with the remaining small-provider AER reads, then assess QUT E12.

In parallel, undertake independent SS-016 UI acceptance and operational-guide improvements where they do not interfere with active settlement.

Reconcile live progress before each substantial tranche, maintain auditable checkpoints, and automatically proceed through the authorised tasks.

Do not stop after each provider, finding or release to request routine permission.

Only stop for a genuine safety, authorisation or compatibility boundary.

Record each substantial milestone in the Admin repository and provide a concise progress dashboard with exact commits, releases and verified results.