<!-- Platform Admin direction dated 4 Nov 2026 10:00 AEDT, received 11:05; recorded verbatim before code. Includes the SS-020 Option A role decision (§8). -->

# StudySearch — Autonomous Admission Throughput and Development Alignment

**Platform Admin direction — 4 November 2026, 10:00 AEDT**

Continue as the existing Integration Controller.

Read the canonical operating model, latest execution register and these verified reports:

- `docs/platform/2026-11-04-first-run-failure-audit.md`
- `docs/platform/2026-11-04-aer-throughput-investigation.md`
- `docs/platform/2026-11-04-scholarship-throughput-reconciliation.md`

Reconcile current live production before taking action.

Do not create another controller, reporting system or duplicate integration issues.

## 1. Main objective

Development must now prioritise **eligible data reaching the active catalogue and consumers**, not merely additional functions, releases, classifications or queued work.

The autonomous platform should perform discovery, evidence acquisition, technical correction, prioritisation, review preparation, resumption and publication verification itself.

Humans remain responsible for decisions that require human admission authority.

Do not confuse automation with bypassing Layer 4.

## 2. Immediate P1 — Fix scholarship-to-Layer 4 hand-off

Investigate IQ-00264 first.

The controller detected approximately 132 scholarship cases eligible for Layer 4, with no review items created for six hours.

Trace:

Classification → admission eligibility → work selection → Layer 4 generation → deduplication → Inbox visibility → decision → admission → publication.

Determine why the already-classified eligible cases are not becoming actionable review items.

Correct the shared hand-off.

Do not wait for classification of all 2,560 providers before processing the first 80.

Prove that:

- Eligible cases create the appropriate review or technical recovery work.
- Ineligible cases retain an explicit evidence-backed disposition.
- Existing decisions are not duplicated.
- A failing provider does not prevent others progressing.
- The next eligible stage runs unattended.
- Completed decisions lead to verified publication where authorised.

Do not solve this by manually enqueuing the 132 cases.

## 3. AER — Separate reviewer-ready from technical recovery

The reported 605 AER items include:

- 169 complete course reads awaiting review.
- 23 matrix runs ready for review.
- 395 incomplete course reads requiring technical correction or valid exclusions.

Verify these figures against current production.

### Reviewer-ready items

Prepare an actionable university-by-university review queue for the 192 eligible items.

The reviewer interface must provide:

- Exact provider and course.
- Qualification, country and audience.
- Current stored evidence and quotations.
- Proposed requirements.
- Existing active rows and manual locks.
- Completeness and conflict checks.
- Recommended existing Layer 4 decision.
- Consequences of approval or rejection.

Permit efficient sequential review by an authorised reviewer, preserving one item-level decision and audit event at a time.

Do not implement blanket AER approvals or grant AI independent admission authority.

Coordinate exclusive item ownership with the existing ChatGPT browser reviewer.

### Technically blocked items

Automatically classify and route:

- Row-limit failures.
- Shared-page identity problems.
- Dropped requirements.
- Incorrect quote associations.
- Missing scales and country mappings.
- Source access and rendered-page failures.

Apply the approved technical remedy when available.

For unresolved cases, create one deduplicated human-assisted intervention requesting exactly the missing source, field, evidence or identity confirmation.

Do not send technically incomplete reads to ordinary approval actions.

After a reviewer supplies valid information, automatically resume the appropriate read and validation path.

## 4. AER recovery settings and throughput

v2.15.465 is live. Verify the first readiness runs and the movement of previously unchecked items.

Keep the 600-item safety limit and E13/D-R3 admission rules unchanged.

Evaluate `wc.aer_fair_on` using the corrected readiness classifications before activation.

Record projected capacity and per-provider fairness.

For `aer.e13_recover_on`, prepare a bounded, reversible pilot. Limit it to eligible stored-evidence reads and verify actual replacement yield. Never repeatedly re-run a deterministic reader against unchanged evidence when its failure cannot be corrected.

For the 162 row-limit cases, assess the required row boundaries and source structure. Pilot a provider-specific configuration for RMIT only after the evidence and completeness tests justify it.

For the 45 shared-page cases, prioritise identity/source mapping rather than repeated AI extraction.

Continue free source discovery and existing stored-evidence recovery for the named missing universities. Park paid discovery requiring new authority without blocking independent work.

## 5. Scholarship recovery and provider identity

For Torrens, TAFE SA, Box Hill and IQ-00242–244, distinguish:

- Incorrect source matching.
- Legitimate international eligibility exclusions.
- Expired scholarships.
- Incomplete listing traversal.
- Wrong provider ownership.
- Pilot-policy exclusion.
- Valid scholarships awaiting review.
- Admitted scholarships not published.

Do not treat every zero-publication provider as a P1 defect.

### Torrens

Evaluate the legal-name identity defect against verified canonical legal and trading names.

Do not automatically trust arbitrary aliases.

Prepare the approved-authority decision for the relevant identity switch and recoverable cases.

### MIT/Unitec

Do not split a provider record merely because two institution names or hosts appear.

First verify legal registration, institutional ownership, catalogue relationships, existing courses and downstream lifecycle implications.

A provider split, if required, follows the existing governed lifecycle and migration approval process.

### Other providers

Preserve pilot membership and scholarship admission policies unless explicitly changed by the Platform Admin.

Allow source discovery and evidence classification to record legitimate gaps without admitting out-of-scope scholarships.

## 6. Close the first-run verification gaps

The two jobs:

- `layer4-interventions`
- `layer4-readiness`

must report measurable production outcomes.

Add the smallest compatible output contract to the existing verification mechanism.

For interventions, measure created, reused, resolved, returned to recovery and awaiting human input.

For readiness, measure checked, newly classified, technical-blocked, judgement-ready and superseded.

Do not count a successful zero-output run as an operationally verified capability unless the zero result is justified.

Persist classifier `duplicate_cases` and `report_errors`, which were previously discarded by the scheduled job.

## 7. Complete the automatic recovery loop

For each pipeline stage, enforce:

Detect → Diagnose → Select authorised remedy → Execute or park → Verify → Advance downstream → Record.

Each failure requires a named next action and bounded checkpoint.

No persistent state may mean simply "failed indefinitely" without a recovery condition or explicit authority blocker.

Prioritise issues that prevent otherwise eligible downstream work over new features with no demonstrated effect on catalogue completeness.

Avoid per-provider patches where one shared correction is possible.

## 8. SS-020 role decision

**Approved direction: Option A — retain Pipeline Operator access to existing Layer 1 scheduling and run controls.**

Rewire Layer 1 › Sources to the authoritative refresh policies before retiring the legacy screen.

Preserve existing role boundaries and audit behaviour.

Do not widen access beyond the role's current operational authority.

Release through the existing SS-020 change-control and compatibility process.

## 9. Other approval-dependent changes

Prepare, but do not silently execute:

- Additive academic AER output in Zoho and the single-course Website API, following G3 compatibility and developer-guide requirements.
- Any increased AI or Firecrawl expenditure.
- Changes to scholarship pilot admission policy.
- Destructive provider splits or lifecycle moves.
- A higher-cost stronger-model configuration.
- Any change bypassing manual locks or human admission authority.

Use one consolidated decision pack containing only genuinely unresolved approvals.

## 10. Governed issue severity

Implement an authorised issue severity-update function within the existing integration system.

Require:

- Original and new severity.
- Evidence-based reason.
- Decision authority.
- Audit event and timestamp.
- Preservation of issue fingerprint and history.

Do not close or recreate an issue merely to downgrade it.

## 11. Self-sustainability measurements

Report verified progress by transition:

| Pipeline | Eligible | Processed | Technically recovered | Review-ready | Human-decided | Admitted | Published | Blocked |
|---|---:|---:|---:|---:|---:|---:|---:|---:|

Measure separately:

- Scholarship classifier coverage of the 2,560-provider scope.
- The exact meaning of the narrower 755-provider eligibility count.
- Layer 4 interventions actually produced.
- Interventions completed and automatically resumed.
- AER technical holds resolved.
- AER admissions and new active rows.
- Scholarship admissions and publication.
- Consumer consistency.
- Actual AI and Firecrawl spending.
- Next scheduled recovery.
- Remaining human-authority decisions.

## 12. Acceptance requirements

Do not declare the platform self-sustaining because v2.15.465 is deployed, jobs run or coverage classifications increase.

Required proof:

1. Unattended execution advances independent eligible work.
2. Known technical failures recover or park safely.
3. Layer 4 receives evidence-complete actionable requests.
4. Human decisions automatically trigger the next pipeline operation.
5. Approved records reach the active catalogue.
6. Consumer publication matches the catalogue.
7. Spending and manual-lock controls remain intact.
8. The existing 24-hour acceptance observation passes.

Keep unrelated development and operational lanes progressing.

**Immediate focus: resolve scholarship hand-off IQ-00264, prove human-assisted automatic resumption, prepare the 192 AER items for efficient authorised review, and restore technical recovery of the incomplete AER backlog.**

The objective is not additional releases. It is consistent, measured progress from source evidence to correctly admitted and published data.