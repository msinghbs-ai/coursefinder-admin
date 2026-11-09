StudySearch — Overnight Continuous Delivery and Decision Implementation

Platform Admin review direction — 2 November 2026

Continue the active multi-agent workstreams from the current live state.

Do not restart completed work or recreate investigations.

1. Decision package

The following are recommended dispositions to prepare and validate. Record them in Admin as proposed until Platform Admin approval is explicit where required.

Scholarships

- Expand provider eligibility beyond universities through existing provider-type governance, subject to verified source identity and scope.
- Replace the 30-course minimum with evidence-based scholarship legitimacy checks.
- Retain past scholarships as historical "closed" records where supported, while preventing them from appearing as currently open.
- Preserve source, country, eligibility, award period, closing date, application rules and status evidence.
- Restore normal configured Firecrawl budget controls after the temporary authority expires.
- Do not introduce unlimited spending or paid acquisition without an approved ceiling.

AER D-R1

Support global qualifications such as IB without fabricating a country association.

Do not admit incomplete or unsupported matrix runs.

An approved global qualification row must retain issuer, qualification identity, study level, grade/scale, source evidence, restrictions and applicable provider.

AER D-R2

Implement safe replacement of a pending AER read with a corrected, complete read.

Requirements:

- Same intended source and provider/course identity.
- New evidence version and immutable history.
- Atomic supersession of the previous pending review.
- No duplicate active review.
- No automatic approval.
- Reviewer can inspect differences.
- Existing manual decisions and locks protected.

AER D-R3

Apply whole-read completeness protection to provider entry-matrix runs.

Verify source table completeness, row counts, qualification/country coverage, dropped rows, quote-on-page, grade basis and cross-programme contamination.

Refuse approval when material completeness cannot be demonstrated.

Extend equivalent safeguards to the reported 170 incomplete course reads that currently bypass E13, using reproducible failure fixtures.

Descriptions

Prepare the 1,200-character setting adjustment with regression testing.

Preserve original source evidence. Avoid cutting essential conditions or publishing fragments as complete descriptions.

Intake wording

Treat the explicit phrase "Semester 1 and 2" as evidence that both teaching periods are named.

Do not derive exact calendar dates from semester labels alone.

Weekly AER reporting

Prefer existing automation credentials, GitHub Actions artifacts or a documented snapshot branch.

Do not request an additional credential unless no supported existing mechanism meets the required governance controls.

2. Continue six-agent execution

A — AER reader repair, completeness and supersession.

B — Scholarship discovery and source completeness.

C — University and course description coverage.

D — Intake calendar persistence and provenance.

E — Layer 4 routing, evidence reconciliation and housekeeping.

F — Integration, regression, operational health and release assurance.

One integrator controls production writes and releases.

3. Continuous validation

Every pipeline stage must distinguish:

- Job invocation succeeded.
- Source accessed.
- Pages discovered.
- Pages read completely.
- Records extracted.
- Records accepted or held.
- Records published.
- Consumer read-back verified.

A successful scheduler invocation with zero successful work and an underlying error is not a successful pipeline outcome.

Detect persistent zero-yield runs, hidden errors, incomplete pagination, provider-specific coverage gaps and repeated failed attempts.

Create or update the existing integration queue until the root cause is resolved.

Do not generate duplicate issues.

4. Resource protection

Maintain bounded Firecrawl concurrency and existing budget guards.

Limit heavy production validation around scheduled admission runs.

Scale acquisition based on measured throughput, timeout rates and remaining credits.

After the temporary Firecrawl allowance expires, revert to normal approved limits and verify the actual settings.

5. Acceptance

The work is complete only when:

- Corrected readers pass regression tests.
- Live publication and Layer 4 admission boundaries remain intact.
- Source completeness is measured, not assumed.
- Provider and course coverage reports reconcile.
- Website and Zoho reflect only supported values.
- No unresolved critical job failures are hidden behind successful scheduler status.
- Changes are documented in the canonical Admin register with version, evidence, audit and rollback references.

Continue all authorised work overnight where the execution environment supports it.

Report actual completed releases, provider/course coverage improvement, cost, remaining material blockers and the next executable action.

Do not wait for all missing enrichment to be populated before advancing platform acceptance.