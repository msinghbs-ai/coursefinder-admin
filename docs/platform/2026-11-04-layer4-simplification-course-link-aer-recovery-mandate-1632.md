<!-- Platform Admin mandate dated 4 Nov 2026 16:32 AEDT, received 17:06; recorded verbatim before code. -->

StudySearch — Layer 4 Simplification, Course Link Admission and AER Recovery

Platform Admin mandate — 4 November 2026, 16:32 AEDT

Continue as the active StudySearch Integration Controller.

This is a consolidated continuation of the existing SS-018, SS-019, SS-020, SS-021 and human-assisted recovery mandates.

Primary objectives:

1. Reduce unnecessary Layer 4 reviews.
2. Allow existing authorised admission rules to operate without repetitive human intervention.
3. Stop ineffective AER recovery attempts.
4. Route unresolved technical problems to actionable recovery or human-assisted interventions.
5. Demonstrate actual admitted and published data gains.
6. Keep independent workstreams operating when individual providers, courses or sources are blocked.

Do not create another controller, review system, dashboard, execution register or duplicate integration issues.

1. Read the authoritative design and current evidence

Read:

- "docs/platform/AGENT-OPERATING-MODEL.md"
- "docs/platform/ui-audit/2026-11-04-layer4-kind-audit-matrix.md"
- Current Layer 4 action playbook.
- Existing human-assisted recovery design.
- SS-021 work-continuity audit and recovery contract.
- Current AER technical-recovery investigation.
- IQ-00279 and the existing AER recovery integration issue.
- Latest production progress observations and execution register.

Reconcile current main, deployed functions, settings and production queue states before development.

Record this mandate in the existing Admin execution register before code.

2. Redefine Layer 4 operational routing

Classify every review item into four operational groups.

A — Automatically resolvable

The evidence is complete and the existing authorised admission rule permits automatic settlement.

Process through that rule with full validation, audit and downstream publication checks.

Do not create a human review merely because a new value or source was discovered.

No new automatic admission authority is granted by this mandate.

B — Technical recovery

A source is missing, extraction failed, evidence is incomplete, a worker timed out or a technical correction is needed.

Attempt only recovery actions that have a credible possibility of success.

Track attempts, failure classifications and next eligible action.

Park deterministic failures until their recovery conditions change.

Do not repeatedly consume processing capacity or AI credits on unchanged evidence.

C — Human decision required

The evidence is ready but admission, conflicting ownership, manual binding, policy interpretation or another protected action requires human authority.

Keep the item in Layer 4 and present a complete decision package.

D — Human information required

The platform cannot proceed without a specific URL, document, missing qualification, source correction, identity confirmation or other factual input.

Use the existing Human input needed capability.

After valid input is supplied, automatically resume the appropriate pipeline stage.

3. Course Link admission — first simplification pilot

Investigate why newly discovered university Course Links enter Layer 4.

Trace:

Discovery → Official-source validation → Course identity → Existing binding → Authorised admission rule → Layer 4 if required → Active link → Website/Zoho publication.

For every pending Course Link, validate:

- Official university domain and source URL.
- Exact provider, campus and course identity.
- CRICOS code where applicable.
- Course title, qualification and level.
- Existing active/manual bindings.
- Shared-page identity conflicts.
- Stored evidence and last verified source.
- Existing authorised admission rules.
- Earlier decisions, supersessions and duplicates.

Automatically settle only where an existing approved rule explicitly allows it.

Route technical problems to autonomous recovery.

Send unresolved identity or approval questions to Layer 4 with concise evidence and a recommended decision.

Do not overwrite manual bindings or infer approval from AI confidence.

Reconcile the historical Course Link backlog using guarded, auditable transitions.

4. P1 — AER technical recovery has zero yield

Production progress observation: 4 November 2026, 16:32 AEDT

Metric| Current
Technical recovery attempts| 234
Successful recoveries| 0
Technical holds| 132
Duplicates| 22
Currently eligible items| 35
Increase in attempts| +65
Increase in technical holds| +43

These are reported observer figures. Verify their definitions and underlying records before making corrective changes.

The immediate concern is that recovery is repeatedly selecting items that cannot succeed under unchanged evidence or limits.

Investigation

Reconcile the existing AER technical-recovery issue and IQ-00279.

For every attempted item, determine:

- Provider and course identity.
- Original review and recovery references.
- Evidence version or stored-copy checksum.
- Reader version and applicable settings.
- Failure code and classification.
- Previous attempt and outcome.
- Whether source evidence changed.
- Whether the reader or validation rules changed.
- Whether the attempt was genuinely eligible.
- Next permitted recovery action.
- Whether a human decision or input is required.

Identify whether the recovery selector is incorrectly treating deterministic failures as transient.

Required recovery classifications

Row-limit refusal

For E13 cases where the page contains more requirements than the configured limit, do not re-read until an authorised limit or extraction strategy changes.

Unchanged evidence

If the same reader, source copy and settings previously produced a deterministic refusal, do not repeat the operation.

Transient failure

Allow bounded retries for network interruptions, temporary service errors, expired leases and other genuinely transient conditions.

Duplicate work

Reuse existing operations and review items. Do not enqueue or count repeated attempts as new work.

Human-assisted recovery

Where the required remedy is a missing URL, source document, course identity, scoring basis or protected decision, create or update one actionable intervention.

Changed technical conditions

Automatically reconsider parked items when the evidence, reader revision, relevant settings or approved policy changes.

5. Correct the recovery selector and work lifecycle

Implement shared eligibility rules so technical recovery only selects items with a valid next action.

Each technical hold must retain:

- Durable failure classification.
- Last attempt and result.
- Source/evidence version.
- Reader and settings version.
- Next eligible action.
- Next retry time or authority blocker.
- Reason why an identical retry is prohibited.
- Reference to any Human input needed intervention.
- Final recovery, admission and publication outcome.

The selector must skip deterministic holds whose prerequisites remain unchanged.

Do not increase retry caps or spending limits to make attempts appear successful.

Use existing scheduled platform workers to resume eligible work automatically.

Do not manually enqueue individual enrichment items as a substitute for correcting the scheduler.

6. Repair the AER zero-yield condition

Measure actual transitions:

Technical hold → Recovery eligible → Recovery attempted → Corrected read completed → E13 passed → Layer 4 review-ready → Authorised decision → Active catalogue rows → Consumer publication.

Investigate why the existing 35 reportedly eligible items have not produced successful recoveries.

For each, establish whether the item is genuinely recoverable.

If none can succeed under current conditions, reclassify the eligibility accurately and provide the required next action.

A correct outcome may be a safely parked item awaiting evidence rather than an additional failed read.

Prioritise changes that produce a demonstrably complete, review-ready AER record.

Continue work on the missing universities and RMIT without allowing their held items to block other providers.

7. Make Layer 4 understandable to reviewers

Organise the Inbox around three visible operational choices:

Ready for my decision

- Evidence complete.
- Specific authorised decision required.
- Clear consequence of each choice.

Information needed from me

- Exact missing information.
- Current evidence.
- Suggested valid source or answer.
- Simple URL, document, identity or structured-data input.

Technical recovery

- Current failure.
- What has already been attempted.
- Why the item is parked.
- Next automatic action and time.
- Ability to inspect the recovery history.

Keep the detailed technical classifications available in expandable sections.

Every card must explain:

1. Why the item is in Layer 4.
2. What the platform has already done.
3. Whether a person is actually required.
4. What action will move it forward.
5. When it first entered and last changed.
6. Whether an earlier action failed or succeeded.

Do not recommend a re-read when the same evidence, reader and settings have already produced an identical deterministic refusal.

8. Fix remaining kind-audit gaps

Reconcile the existing Layer 4 kind-audit matrix, including:

- Course Link review duplication and unnecessary arrivals.
- 96 held scholarships with duplicate decisions.
- Missing retry guards on onboarding and page-recovery kinds.
- Navigation-only actions lacking durable completion audit.
- Missing evidence on provider and adapter cards.
- Re-raised reviews after valid earlier decisions.
- Human input actions that do not resume the original work.

Implement shared fixes rather than separate mechanisms per review kind.

Preserve historical decisions and item identity.

9. Admission efficiency without bypassing governance

Maintain:

- Existing Layer 4 approval authority.
- AER E13 and D-R3 completeness gates.
- Manual binding protections.
- Scholarship eligibility and ownership rules.
- Fee holds.
- Provider lifecycle restrictions.
- Consumer API controls.
- Existing AI and Firecrawl budgets.

Do not use confidence scores as independent authority for academic admission.

Where a new automated admission rule could safely reduce human workload, prepare a separate Platform Admin decision with its precise eligibility criteria, exclusions, expected impact and verification controls.

10. Production validation

Add tests proving:

1. A deterministic E13 refusal cannot repeat against unchanged evidence and settings.
2. Changed evidence or an authorised reader configuration makes a previously parked item eligible again.
3. Transient failures retain bounded retries.
4. Duplicates do not produce duplicate work or decisions.
5. Every technical hold has a durable next action.
6. Human input resumes the original pipeline.
7. A complete AER read reaches an authorised review decision.
8. Validly approved data becomes active.
9. Consumer publication is verified independently.
10. Other eligible providers and fields continue despite blocked items.

Test Course Link, AER, scholarship and onboarding examples using production-representative fixtures.

11. Reporting and acceptance

Report by workstream:

Kind| Pending| Automatically resolved| Technical holds| Human input| Review-ready| Decided| Admitted| Published

For AER additionally report:

- Total recovery attempts.
- Unique items attempted.
- Successful corrections.
- Deterministic retries prevented.
- Transient retries.
- Duplicates suppressed.
- Items reclassified as human intervention.
- Review-ready rows.
- Actual active AER row increases.
- Actual consumer publication increases.
- AI spending and useful yield.

Compare with the 16:32 AEDT observer baseline and subsequent current-production values.

Record production verification against the existing IQ issues before closure.

Do not count an item merely being moved between queues as a successful recovery or admission.

12. Execution order

1. Record the mandate and reconcile current issues.
2. Diagnose the zero-yield AER recovery selector.
3. Stop repeated deterministic attempts.
4. Ensure every hold has an actionable next state.
5. Restore genuinely eligible unattended recovery.
6. Simplify Course Link routing and existing backlog.
7. Resolve shared Layer 4 kind-audit defects.
8. Verify an end-to-end AER recovery and authorised admission.
9. Measure admissions and publication gains.
10. Update the execution register and continuous validation rules.

Use maximum safe parallel engineering with one Integration Controller for merges and releases.

Do not pause unrelated development or normal platform operations.

Completion requires fewer unnecessary reviews, no repeated deterministic recovery failures, measurable eligible work progression, and actual verified catalogue admissions.

A release, successful scheduler execution or lower Layer 4 count is not sufficient evidence of completion.