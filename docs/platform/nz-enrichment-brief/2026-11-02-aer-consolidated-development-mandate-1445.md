# StudySearch — CF-247 Academic Entry Requirements
## Consolidated Development, Coverage Recovery and Continuous Assurance Mandate

**Date:** 2 November 2026  
**Issued by:** Platform Admin  
**Programme:** CF-247 — Academic Entry Requirements (AER)  
**Priority:** P0 — Architectural correctness, coverage completeness and continuous validation  
**Execution model:** Integrate into ongoing StudySearch development  
**Scope:** All eligible Australian and New Zealand providers  
**Status:** Authorised design and implementation mandate, subject to existing production approval gates

---

## 1. Executive mandate

Integrate the revised Academic Entry Requirements design into the existing StudySearch development programme.

The platform must become capable of automatically discovering, extracting, validating, maintaining and reporting academic entry requirements across all eligible Australian and New Zealand education providers.

**The Platform Admin must not be required to manually identify missing countries, qualifications, study levels or admission requirements university by university.**

This mandate consolidates:

1. Academic qualification-first architecture.
2. International/global qualification recognition.
3. Missing country and qualification reconciliation.
4. Undergraduate and postgraduate admission requirements.
5. Provider-level official AER source URL management.
6. Provider-supported Country and Qualification filters.
7. Expansion beyond the original provider pilot.
8. Continuous automated validation and regression detection.
9. Governed automatic recovery and exception handling.
10. Consolidated operational reporting, progress tracking and alerting.

Do not create a parallel AER programme.

Work within the existing architecture, development branches, execution register, governance model, scheduling infrastructure and reporting capabilities.

Continue unrelated approved development concurrently.

## 2. Canonical documents — read before implementation

Repository: `msinghbs-ai/coursefinder-admin`

### Operating authority

- `docs/platform/AGENT-OPERATING-MODEL.md`
- `docs/platform/nz-enrichment-brief/INDEX.md`
- `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`
- Relevant active CF-247 decisions and change controls.

### AER design

- `docs/platform/ENTRY-REQUIREMENTS.md` — **Draft 1.2, Section F**
- `docs/platform/ENTRY-REQUIREMENTS-IMPLEMENTATION.md`
- `docs/platform/ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`

### Gap and automation mandates

- `docs/platform/nz-enrichment-brief/2026-11-02-aer-qualification-coverage-gap-assessment.md`
- `docs/platform/nz-enrichment-brief/2026-11-02-aer-continuous-assurance-mandate.md`

### Reference commits

- AER Draft 1.2: `6cd2c3369686c781028396bb75a4831dfb3f40f1`
- AER gap register: `0d715014292406a038c393cc578031c8bea9bb34`
- Continuous assurance: `602b43aee8dfd6d71d18b252ab1b8375308ecec6`

Use the current canonical versions if subsequent commits supersede these references.

Execution repository: `msinghbs-ai/Coursefinder-Pilot`.

Before changing code, reconcile this mandate with the latest live database, deployed application, active PRs, production restrictions and ongoing workstreams.

## 3. Architectural correction — qualification-first AER

### Current issue

The existing AER implementation is excessively country-oriented.

A student may complete an internationally recognised qualification in a country other than the qualification's traditional origin.

Examples:

- Nepal — International Baccalaureate Diploma (IB).
- Nepal — Cambridge/Pearson GCE A Levels.
- Nepal — American curriculum High School Diploma.
- Switzerland — IB Diploma.
- United Kingdom — GCE A Levels and other qualifications.
- Other countries — Global Assessment Certificate (GAC).

The system must distinguish:

- Student's country of prior education.
- Qualification actually completed.
- Qualification family and awarding body.
- Destination provider.
- Intended study level.
- Destination course.
- Provider-specific recognition conditions.
- Published minimum score and grading scale.
- Intake year and applicable policy edition.

**Country is contextual information, not a substitute for qualification identity.**

### Required qualification categories

**A. International/transnational qualifications**

Examples:

- International Baccalaureate Diploma.
- Global Assessment Certificate.
- GCE/Cambridge/Pearson A Levels, where applicable.
- Other officially recognised international qualification systems.

These must support global qualification identities without fabricated per-country duplicates.

**B. Country-specific qualifications**

Examples:

- Nepal Higher Secondary Certificate.
- Swiss Matura.
- Indian CBSE/ISC qualifications.
- UK national qualification variants.
- Other officially recognised national credentials.

These use country-specific equivalency requirements.

**C. Foreign curricula offered internationally**

Examples:

- American High School Diploma completed in Nepal.
- British curriculum offered outside the UK.
- International school qualifications.

Preserve awarding body, curriculum, accreditation and examination requirements where published.

A qualification being offered in a country does not automatically mean a provider accepts it.

**D. Postgraduate qualifications**

Examples:

- Recognised bachelor's degree.
- Honours degree.
- Graduate diploma.
- Relevant postgraduate qualifications.
- Alternative experience-based pathways.

These require postgraduate-specific academic admission logic.

## 4. Canonical database model

Inspect and reuse existing schema objects:

- `catalogue.provider_entry_matrix`
- `catalogue.course_entry_requirements`
- `pipeline.entry_matrix_sources`
- `pipeline.entry_matrix_runs`
- Existing qualification and study-level reference objects.
- Existing source evidence and Layer 4 admission objects.

Introduce only the additive structures necessary to support reliable qualification identity, qualification aliases, provider recognition and applicability conditions.

### Required logical relationships

**Qualification catalogue**

Maintain:

- Canonical qualification identity.
- Qualification family.
- Alternate names and aliases.
- National/international classification.
- Awarding body or curriculum, where required.
- Relevant study level.
- Grading scale.
- Applicable editions.

**Provider-recognised qualification**

Represent:

- Provider.
- Qualification.
- Applicable study levels.
- Optional course.
- Country/issuing restrictions.
- Published minimum.
- Conditions.
- Source and evidence.
- Status.
- Applicable year/edition.

**Course admission requirement**

Represent:

- Course-specific minimum.
- Recognised prior qualification.
- Subject prerequisites.
- GPA/grade basis.
- Discipline requirements.
- Professional experience.
- Portfolio/interview requirements.
- Alternative admission pathways.
- Course-specific exceptions.

Avoid creating a second AER pipeline or duplicating the same IB rule under numerous countries.

No synthetic `GLOBAL` country code should be introduced as a workaround.

## 5. Resolver enhancements

Extend the existing AER resolver while preserving approved resolution precedence:

1. Active course-specific override.
2. Applicable course-specific qualification/matrix requirement.
3. Course-declared benchmark band resolved against the appropriate qualification equivalency.
4. Applicable provider-level minimum.
5. Evidence-backed case-by-case or contact-provider fallback.

Add qualification identity, awarding-body restrictions, study level and policy edition as matching dimensions.

### Mandatory controls

- Active, verified records only for consumer resolution.
- No automatic eligibility/pass decision.
- No unsupported ATAR-to-percentage conversion.
- No automatic GPA or foreign-grade conversion without an official source.
- No heuristic selection of the easiest available admission threshold.
- No leakage of proposed, inactive, superseded or held records.
- No reuse of undergraduate equivalency rules for postgraduate admission.
- No assumption that a provider accepts every globally offered qualification.

Retain the existing outcomes:

- `minimum_published`
- `case_by_case`
- `contact_provider`

Do not add admission status values merely for this extension.

## 6. Counsellor experience — dependent filters

Implement or formally specify the qualification-aware filtering experience for the existing consumer integrations.

### Recommended workflow

1. Select destination provider.
2. Select intended study level.
3. Select destination course.
4. Select qualification family.
5. Select the actual completed qualification.
6. Select country of prior education where relevant.
7. Display applicable entry requirements.

Provide alternative country-first discovery where appropriate, using the same canonical resolution rules.

### Country dropdown

Display only countries supported by the selected provider's verified country-specific admission policies.

Do not populate country choices indiscriminately from the entire country reference table.

A provider's lack of a national country matrix must not suppress an otherwise applicable international qualification.

### Qualification dropdown

Use searchable, canonical qualification names.

Group into:

- International Qualifications.
- Country-Specific Qualifications.
- Postgraduate Prior Qualifications, where applicable.

### Mandatory counsellor example

A counsellor preparing an application for a Nepalese student with an IB Diploma to RMIT must be able to view RMIT's verified global IB equivalency table.

The result must not depend on Nepal having a dedicated IB entry in its national country matrix.

A Swiss student with IB should resolve through the same applicable RMIT IB policy.

A Nepalese student with Nepal HSC must use the applicable national qualification requirements instead.

Where a course-specific benchmark cannot be linked with authoritative evidence, display the verified qualification equivalency separately and clearly state that the course-specific minimum remains unresolved.

Do not imply the student has satisfied admission requirements.

## 7. Master's and postgraduate requirements

Extend AER coverage to postgraduate coursework and postgraduate research.

Capture officially published requirements including:

- Recognised bachelor's degree or equivalent.
- Required previous study disciplines.
- Minimum GPA/grades and scales.
- Honours classifications.
- Relevant professional experience.
- Alternative admission routes.
- Research-specific prerequisites.
- Other selection conditions.

Postgraduate eligibility must be evaluated against the intended course's published requirements rather than a general Year 12 country matrix.

Review existing proposed course-entry records and their Layer 4 dispositions before generating new reads.

Prioritise reuse of existing stored source evidence.

## 8. Recover known RMIT gaps

Use the documented gap register and production evidence.

Known cases include:

| Case | Previously identified issue |
|---|---|
| International Baccalaureate | Qualification-only page rejected as not a country table |
| Global Assessment Certificate | Same classification failure |
| United Kingdom | 2 of 31 published minimums omitted |
| Nigeria | 6 of 17 published minimums omitted |
| Vietnam | Table-context processing hold |
| Norway | Grading-scale interpretation hold |
| Nepal | National rows exist; global qualification resolution incomplete |
| Switzerland | No identified RMIT country-specific matrix rows; global IB applicability must be resolved |
| Master's requirements | Significant course-entry proposal/admission backlog |

Do not hardcode RMIT-specific fixes where the underlying defect affects multiple providers.

Fix the reusable source reader, qualification model and completeness logic.

Recover source content only through permitted read/review paths.

Every recovered minimum must retain official source evidence and applicable admission approval.

## 9. All-provider AU/NZ coverage

The original approximately 40-provider research sample is no longer the final coverage objective.

Target **all eligible international-enrolling Australian and New Zealand providers in the canonical catalogue**.

First establish the exact current eligible denominator.

Then inventory, for every provider:

- Official entry-requirement landing page.
- Country equivalency pages.
- Global qualification pages.
- Undergraduate entry requirements.
- Master's coursework entry requirements.
- Postgraduate research requirements.
- Foundation, certificate and diploma pathways.
- Course-specific requirements.
- Published editions and official PDFs.
- Source availability and verification status.

Different providers publish different admission models.

Do not expect every provider to publish every country or qualification.

Distinguish:

- Published and captured.
- Published but not extracted.
- Extracted but awaiting admission.
- Verified and active.
- Not published.
- Source inaccessible.
- Not yet discovered.
- Unsupported source format.
- Policy-restricted or awaiting approval.

All missing or unresolved cases require a traceable disposition, but not a separate manual request to the Platform Admin.

### Scope controls

Expansion must be phased using existing settings, budgets, acquisition restrictions and throughput controls.

Reconcile the original 40-provider restriction, RMIT-specific exclusions and ingestion holds before production actions that conflict with them.

This mandate authorises the coverage objective, design integration, inventory, reconciliation and implementation planning. It does not bypass any existing approval gate for restricted reads, paid processing or admission.

## 10. Entry Requirements URLs under Provider entity

Every eligible provider must have a documented official AER source-discovery outcome.

Expose the following in:

`Catalogue → Providers → Provider details → Academic Entry Requirements`

### Primary source

A verified official academic entry requirements landing URL, when published.

### Additional sources

- Country equivalency index.
- Individual country pages.
- International qualification pages.
- Undergraduate admissions.
- Postgraduate coursework admissions.
- Postgraduate research admissions.
- Course-specific requirements.
- Official PDFs and applicable editions.

For each source, retain:

- Provider ID.
- Official URL.
- Source classification.
- Country/global scope.
- Study level/course applicability.
- Source verification status.
- Last successful read.
- Evidence reference.
- Content hash.
- Edition/intake year.
- Extraction status.
- Hold/failure reason.

Reuse existing `pipeline.entry_matrix_sources` and source registry infrastructure.

Avoid duplicating URLs as independent records across different tables.

Provider details should display the canonical primary URL and related source collection.

## 11. Continuous automated AER validation

**This is a mandatory component of completion, not an optional future enhancement.**

Implement a continuous source-to-consumer assurance process.

The Platform Admin must no longer be responsible for finding missing country or qualification entries manually.

### Audit scope

For every eligible provider, compare:

1. Official sources discovered.
2. Source sections and qualifications published.
3. Expected countries and qualification families supported by evidence.
4. Study levels and courses covered.
5. Source snapshots successfully obtained.
6. Extracted requirements.
7. Proposed or held records.
8. Layer 4 admitted requirements.
9. Active canonical records.
10. Consumer-resolvable requirements.

Build an evidence-based expected-section manifest for each provider/source.

Do not treat all countries in the global reference table as expected countries.

Do not consider a source complete simply because its URL was successfully fetched.

### Persistent gap tracking

Every identified gap must have:

- Stable issue/fingerprint.
- Provider and affected source.
- Country or qualification scope.
- Study level/course, where applicable.
- Root cause.
- Severity.
- Evidence reference.
- First detected and last observed.
- Current state.
- Responsible operational role.
- Next approved action.
- Closure evidence.

Automatically deduplicate repeated detections.

When one parser defect affects several universities, record one underlying root-cause issue linked to all affected providers.

Automatically reopen a resolved issue when a later source change or regression reproduces the problem.

### Severity

**P0 — Critical**

Incorrect, unverified or unsupported admission information is consumer-visible; admitted records or resolution are corrupted.

**P1 — High**

Published qualification, country, postgraduate pathway or significant section is missing, held or incomplete.

**P2 — Operational**

Missing source discovery, stale source, newly published edition or other non-critical coverage issue.

Unknown/inaccessible sources must be reported as unknown, never falsely considered complete.

## 12. Governed automatic remediation

Use the existing source acquisition, enrichment, AER reader, Layer 4 and operational scheduling capabilities.

Within current authorisations:

- Reconcile existing stored evidence automatically.
- Detect and skip unchanged source hashes.
- Identify reproducible extraction defects.
- Queue approved deterministic recovery steps.
- Route new or changed admission values through Layer 4.
- Auto-close operational findings only where verified evidence proves resolution.
- Maintain idempotent execution and safe restart behaviour.
- Observe credit budgets, scheduling stagger, robots restrictions and existing holds.

Do not automatically approve academic minimums.

Do not use bulk Layer 4 approval or direct SQL settlement to bypass the review process.

Do not trigger repeated paid reads purely to fill reporting counters.

Where evidence, spending approval or admission approval is required, place the item in the appropriate existing operational queue.

The Platform Admin should receive consolidated decisions rather than individual university-gap notifications.

## 13. Single operational reporting channel

**Decision: Use the existing StudySearch Admin platform as the canonical operational reporting channel.**

Extend the current `Coverage & completeness` capability, using the established AER workspace and existing progress/reporting surfaces.

Do not create another standalone dashboard, external spreadsheet or parallel issue tracker.

### AER overview

Display four distinct measures:

1. Source discovery completeness.
2. Extraction completeness.
3. Verified admission completeness.
4. Consumer-resolvable coverage.

Show both numerator and denominator.

Include:

- Eligible AU/NZ provider count.
- Providers with verified official sources.
- Countries/qualifications published.
- Successfully extracted requirements.
- Requirements awaiting Layer 4.
- Active verified requirements.
- Providers with complete published-source reconciliation.
- Postgraduate course-entry coverage.
- Open P0/P1/P2 issues.
- New, resolved and reopened gaps.
- Source refresh status.
- Progress over 7 and 30 days.

### Provider drill-down

Include:

- Official AER links.
- Supported study levels.
- Published countries.
- International qualifications.
- National qualifications.
- Postgraduate requirements.
- Missing/held sections.
- Source and evidence status.
- Next operational action and owner.

### Progress methodology

Measure actual coverage improvement, not AI-call counts.

Do not allow high row counts from one provider to disguise missing coverage at other providers.

Provide country, qualification, provider and study-level breakdowns.

Distinguish known published requirements from genuinely unpublished or unknown requirements.

## 14. Automated reporting and alerting

Reuse the existing StudySearch operational reporting and alert delivery infrastructure.

### Hourly

Run a lightweight, incremental read-only AER reconciliation.

Use existing source snapshots, persisted state and current canonical tables.

Avoid rescanning every provider website hourly.

Align with the existing staggered scheduler and resource limits.

### Daily

Produce a consolidated AER operational summary covering:

- New gaps.
- Resolved gaps.
- Regressions.
- Changes in verified coverage.
- Stalled providers.
- Source failures.
- Layer 4 backlog.
- Recovery progress.

### Weekly — Monday 8:00 am Australia/Sydney

Deliver an executive AER progress report through the existing platform reporting/email mechanism.

The report must include:

- Overall eligible providers.
- Discovery/extraction/admission/consumer coverage.
- Progress since the prior week.
- Top recurring root causes.
- Providers with no progress.
- New and recovered country/qualification coverage.
- Postgraduate coverage.
- Outstanding critical blockers.
- Layer 4 review workload.
- Actual AI/source-read spending.
- Next scheduled work.
- Decisions genuinely requiring Platform Admin approval.

### Event-driven alerts

Use existing deduplicated critical alert delivery.

Trigger on:

- Consumer admission data integrity regression.
- New P0 issue.
- Sustained severe processing failure.
- Significant verified coverage regression.
- Critical stale or invalid source evidence.

Send recovery notifications when the underlying issue is demonstrably resolved.

Do not send individual alerts for every missing qualification or country.

Avoid notification floods.

## 15. User roles and access control

Respect the existing StudySearch role model.

Suggested responsibilities:

**Platform Admin**
- Governance and exceptional approvals.
- Critical programme decisions.
- Production acceptance.

**PIM Admin / Builder**
- Parser, source-route and enrichment remediation.
- Scheduling and job settings within permissions.
- Technical gap investigation.

**Pipeline Operator**
- Source discovery and operational gap handling.
- Evidence review and appropriate escalation.

**Layer 4 Reviewer**
- Human admission decisions under the approved playbook.

**Counsellor / Consumer**
- Access verified provider, qualification and course requirements.
- No visibility into internal parser errors or proposed/unverified academic values.

Do not expand privileges merely to expose coverage information.

## 16. Engineering sequencing

Implement incrementally in the existing programme.

### Phase A — Baseline and impact assessment

- Inspect current live data and deployed code.
- Reconcile the ten AER gaps.
- Map requirements to existing workstreams.
- Identify current approval and ingestion restrictions.
- Establish the eligible AU/NZ provider baseline.
- Record implementation decisions in the existing SS execution register.

### Phase B — Continuous quality-control foundation

- Introduce evidence-backed source-section manifests.
- Add persistent gap fingerprints and history.
- Implement lightweight reconciliation and delta detection.
- Prove source-read versus extraction-completeness distinction.
- Build initial Admin progress metrics.

Prioritise this foundation so future provider omissions are found automatically.

### Phase C — Qualification architecture and source recovery

- Extend global qualification classification.
- Add canonical qualification identity where necessary.
- Correct RMIT IB/GAC source rejection.
- Reconcile UK and other held countries.
- Extend existing resolver.
- Test national versus international qualification pathways.

### Phase D — Postgraduate and Provider entity enhancements

- Reconcile master's/research requirements.
- Enhance Provider AER source URLs and linked-source display.
- Extend existing AER Admin filters.
- Improve qualification/study-level resolution visibility.

### Phase E — Governed AU/NZ expansion

- Expand to all eligible providers in approved waves.
- Reuse stored sources before external reads.
- Track published-section coverage automatically.
- Respect budgets, admission controls and restricted-source rules.

### Phase F — Consumer integration

- Produce the qualification-aware consumer contract and rendering specification.
- Preserve current website API compatibility.
- Submit any required additive API changes through the frozen-contract approval process.
- Verify counselling scenarios using active evidence-backed records.

### Phase G — Operational acceptance

- Verify scheduled reconciliation.
- Verify gap deduplication and reopening.
- Verify Admin dashboard figures against live database queries.
- Verify weekly report generation.
- Verify alert deduplication and recovery.
- Verify source/qualification admission correctness.
- Confirm successful production operation before declaring completion.

## 17. Mandatory regression scenarios

Cover at minimum:

1. Nepal + IB + RMIT Bachelor.
2. Switzerland + IB + RMIT Bachelor.
3. Nepal + GCE A Levels + RMIT Bachelor.
4. Nepal + American High School Diploma + RMIT Bachelor.
5. Nepal + national HSC + RMIT Bachelor.
6. United Kingdom + GCE A Levels + RMIT Bachelor.
7. Global Assessment Certificate + RMIT Bachelor.
8. A provider with no published country matrix but valid course-specific rules.
9. A provider recognising a qualification without publishing a numeric minimum.
10. Unsupported qualification returning an accurate fallback.
11. Master's admission requiring a recognised bachelor's degree and GPA.
12. Master's admission involving professional experience.
13. Research admission with course-specific prerequisites.
14. A source marked read whose extraction failed.
15. A page where a table column or section was omitted.
16. A global qualification with no country heading.
17. A provider with missing AER source URLs.
18. An unchanged source producing no duplicate gap.
19. A corrected source automatically closing its operational gap after verification.
20. A later regression reopening an earlier gap.
21. A proposed or held row remaining unavailable to consumers.
22. Existing country-only API calls remaining compatible.
23. Alert deduplication and recovery.
24. Dashboard metrics reconciling to underlying database records.

Use real official evidence and governed fixtures.

Do not invent admission scores or eligibility decisions to make tests pass.

## 18. Production safety and governance

Comply with the current canonical operating model.

Specifically:

- Decision before code.
- Additive schema changes unless separately approved.
- No destructive operations without the required approval.
- No uncontrolled source reads.
- No unrestricted paid processing.
- No Layer 4 bypass.
- No invented admission minima.
- No fabricated country/qualification recognition.
- No automatic eligibility pass.
- No unauthorised consumer API changes.
- No duplicate background pipelines.
- No unrelated feature regressions.
- No deployment claims without live verification.

Reconcile previous provider-scope restrictions and ingestion holds explicitly before undertaking any conflicting production action.

Where a restriction requires approval, pause only that affected lane and continue other authorised work.

Ensure all tests, change-control records and release verification required by the operating model are completed.

## 19. Progress and completion reporting

Update the canonical StudySearch execution register and the AER gap register as work progresses.

Do not open a separate manual tracker.

At each major development checkpoint, provide:

1. What was implemented.
2. Which AER gaps were resolved.
3. Eligible providers and actual coverage achieved.
4. Changes to country, international qualification and postgraduate coverage.
5. Current Layer 4 admission backlog.
6. Automated reconciliation and reporting health.
7. Actual processing costs.
8. Outstanding genuine blockers or approvals.
9. Tests, release version and production verification.

Report changes and exceptions, not repetitive provider-by-provider narration.

A task is not complete merely because a migration was merged, a source was fetched or an AI reader extracted rows.

Completion requires evidenced, correctly admitted and consumer-resolvable requirements where applicable.

## 20. Final execution instruction

**Proceed with integration of this consolidated mandate into the ongoing CF-247 and StudySearch programme.**

Treat the committed AER Draft 1.2 and its ten-gap assessment as the architectural baseline.

Treat the continuous assurance mandate as a required operational capability.

Use existing Admin reporting as the single source of truth.

The target operating state is:

- All eligible AU/NZ providers have a continuously maintained AER source-discovery outcome.
- Published countries, qualifications, study levels and admission routes are automatically reconciled.
- Global qualifications resolve independently of inappropriate country restrictions.
- Undergraduate and postgraduate admission rules remain distinct.
- Official AER URLs are accessible through Provider entities.
- Missing and incomplete requirements are detected automatically.
- Recoverable gaps are processed through approved workflows.
- Human admissions remain governed by Layer 4.
- Progress is visible in StudySearch Admin.
- Executive reporting is delivered automatically every Monday.
- Critical regressions generate deduplicated alerts.
- The Platform Admin is involved only for decisions that genuinely require governance authority.

**Do not wait for the Platform Admin to discover the next missing university, country or qualification. The platform must detect and report such gaps itself.**

At the next consolidated development checkpoint, report the implementation baseline, mapped work items, completed changes, live verification and remaining approval dependencies. Continue approved work without repeatedly requesting permission for routine engineering decisions.