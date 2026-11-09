StudySearch — CF-247 Scholarship Coverage Recovery, Provider-Wide Discovery and Continuous Assurance

Priority: P0 — Production Data Completeness
Execution: Continuous, autonomous, parallel workstreams
Scope: All active, eligible providers across scholarship-enabled countries
Initial priority: Australia, followed by New Zealand and Canada
Governance: Existing CF-247 operating model and approval gates

1. Operating instructions

Read and follow the canonical operating model:

https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/AGENT-OPERATING-MODEL.md

Read the current Admin INDEX, scholarship mechanism, scholarship architecture, execution register, pipeline lineage and Pilot "CLAUDE.md".

Relevant starting documents:

- "docs/scholarships/SCHOLARSHIP-MECHANISM.md"
- "docs/scholarships/scholarship-module-plan-v1.md"
- "docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md"
- "docs/platform/PIPELINE-LINEAGE.md"
- All active AER continuous-assurance and Layer 4 settlement mandates.

Reconcile documentation against deployed code and live Supabase objects before making implementation decisions. Where documents conflict, establish the active rule and record the discrepancy.

Record this mandate in Admin before implementation, update the existing scholarship architecture and mechanism, and follow the established change-control and test-governance procedures.

Do not replace the current scholarship subsystem with a parallel solution.

2. Problem statement

The Platform Admin has identified incomplete scholarship coverage.

Example:

University of New South Wales (UNSW)

Official HDR catalogue:

https://www.unsw.edu.au/research/hdr/scholarships#search=&filters=residency%3AInternational+funding_type%3ALiving%2520Allowance&sort=relevance&startRank=1&numRanks=10

Official general scholarships catalogue:

https://www.scholarships.unsw.edu.au/scholarships/search

The Admin reports approximately five scholarships currently visible in Supabase, including research scholarships, despite substantially more opportunities appearing across the university's official scholarship catalogues.

Treat UNSW as the first diagnostic and regression case, not as the boundary of this mandate.

Determine whether missing scholarships are:

- Not discovered.
- Discovered but not crawled.
- Crawled but not converted into candidates.
- Candidates refused incorrectly.
- Awaiting AI interpretation.
- Missing verified international eligibility or value.
- Held in Layer 4.
- Stored but unpublished.
- Published but not returned by the Admin or consumer APIs.
- Incorrectly associated with a provider.
- Deduplicated into unrelated records.
- Excluded by search filters.
- Stalled because of scheduler, adapter, budget or queue failures.

Do not assume that the five reported records represent the entire stored scholarship population.

3. Provider catalogue reconciliation

Use the canonical provider catalogue as the authoritative denominator.

Identify every active, scholarship-eligible provider in each enabled country.

Reconcile these providers against:

1. Scholarship discovery coverage.
2. Official source URL coverage.
3. Sitemap and directory coverage.
4. Candidate discovery.
5. Extracted scholarship records.
6. AI interpretation.
7. Layer 4 pending and held items.
8. Publication eligibility.
9. Published records.
10. Course relationships.
11. Scheduled jobs and failed jobs.

Include all active universities and eligible non-university providers.

Do not restrict coverage to the top 50 universities, providers with many courses or previously onboarded providers.

Prioritisation may control processing order but must not permanently exclude low-volume providers.

For each provider calculate:

- Source catalogues identified.
- Listing pages verified.
- Pagination completeness.
- Estimated or observed distinct opportunities.
- Candidates discovered.
- Candidates screened.
- Valid scholarship records.
- Published records.
- Domestic-only records.
- International-eligible records.
- Expired and closed records.
- Layer 4 holds.
- Discovery or extraction failures.
- Last completed full coverage scan.
- Next scheduled scan.
- Unresolved coverage gaps.

Do not interpret zero scholarships as a valid completed result unless the provider has been successfully checked and evidence supports the result.

4. UNSW full catalogue recovery — first execution

Use UNSW to establish the complete end-to-end approach.

Discover and inspect all official scholarship directories, including:

- Undergraduate scholarships.
- Postgraduate coursework scholarships.
- Higher Degree Research scholarships.
- Faculty and school-specific scholarships.
- International student scholarships.
- Country-specific and regional scholarships.
- Research project-linked scholarships.
- Industry-funded scholarships listed by UNSW.
- University-administered external scholarships.
- Tuition waivers, stipends and living allowance scholarships.

Distinguish a scholarship award from a funded research project, funding component, award round and application window. Do not manufacture duplicate scholarship records.

For the provided HDR URL, inspect the underlying catalogue rather than treating the current URL fragment as the complete dataset.

The "startRank" and "numRanks" parameters indicate a paginated catalogue interface. Determine the actual result total and enumerate all pages.

Investigate the underlying rendered JavaScript application, request behaviour and available listing metadata.

Use the approved Firecrawl integration for acquisition. Do not bypass website restrictions, authentication or rate limits.

Verify:

- All results are enumerated.
- Pagination terminates correctly.
- Filters do not hide other opportunities.
- Scholarship details are opened and captured.
- No awards are omitted because they share one listing page.
- Different award types retain their separate eligibility and value structures.
- Existing stored scholarships are reconciled rather than duplicated.

Compare the acquired corpus with the live Supabase records and produce a scholarship-by-scholarship reconciliation.

Report exact counts, including source totals, distinct opportunities, stored records, legitimately excluded records, pending admissions and confirmed gaps.

Do not invent expected scholarship totals when the source does not publish one.

5. Accelerated Firecrawl discovery

Extend the current discovery process to support full catalogue enumeration.

A provider may have multiple scholarship catalogues distributed across domains, subdomains, faculties and research offices.

Use a hierarchical discovery strategy:

Stage A — Provider sources

Identify and persist the provider's primary scholarship URLs, research scholarship URLs, faculty directories and other official scholarship catalogue entry points.

Stage B — Directory mapping

Use Firecrawl mapping and rendered-page crawling to discover all candidate listing and detail pages.

Support JavaScript-rendered catalogues, pagination, load-more behaviour, filtering and nested directories.

Stage C — Candidate inventory

Extract a stable identity for each distinct scholarship and retain its source page, listing membership, evidence reference and discovery timestamp.

Stage D — Detail acquisition

Read the scholarship detail pages through the existing scraper and save the approved evidence snapshot.

Stage E — Completeness reconciliation

Verify that every eligible listing item has a corresponding classified candidate and an appropriate downstream outcome.

Stage F — Incremental monitoring

Revisit listing sources and compare their fingerprints against prior successful scans.

Re-read changed or newly discovered scholarships and avoid re-crawling unchanged pages unnecessarily.

Reuse the existing Firecrawl allocation, settings, task manager, retry mechanism and credit accounting.

Where full catalogue acquisition is incomplete, record a partial result and queue continuation. Never mark it complete.

6. AI extraction and admission

Use the existing qualified, pinned AI model hierarchy.

Do not silently change active models, qualification rules or AI-admission switches.

AI extraction must support:

Category| Required facts
Identity| Official name, provider, award identity, source URL
Classification| Undergraduate, postgraduate coursework, HDR, research, other
Audience| International, domestic, mixed, restricted or unstated
Nationality| Eligible countries, nationality restrictions and exclusions
Eligibility| Academic, merit, need, programme, faculty, residency and other criteria
Financial benefit| Fixed amount, percentage, tuition coverage, stipend, allowances and funding basis
Timing| Opening date, closing date, award year, recurring round, duration
Application| Official application URL and application instructions
Relationships| Provider, eligible programmes, courses, research projects and faculties
Governance| Evidence references, extraction model, confidence and admission outcome

Every material extracted fact must have supporting evidence from the saved official source.

AI may interpret and classify. It must not invent missing values or broader eligibility than the provider states.

Preserve the existing quote-validation requirement and use a second qualified model wherever the active admission rules require it.

Distinguish a scholarship's availability to domestic students from its suitability for international student publication.

Retain out-of-scope classifications in the coverage census without automatically publishing them.

7. Scholarship admission and Layer 4 reconciliation

Identify the complete lifecycle of each discovered opportunity:

"Discovered → Read → Classified → Validated → Admitted or Held → Published or Excluded"

Use the platform's actual statuses and tables rather than creating competing state machines unnecessarily.

Automatically admit verified scholarships where existing policy permits.

For unresolved cases:

- Reuse saved evidence first.
- Reacquire pages when the evidence is stale or insufficient.
- Apply approved AI re-checks.
- Route genuine ambiguity to the existing Layer 4 process.
- Preserve previous human decisions and manual field locks.

Investigate stalled Layer 4 scholarships and group them by root cause.

Resolve systematic technical problems once, rather than requesting repeated individual reviews.

A correctly identified domestic-only scholarship must not remain indefinitely pending as an international scholarship candidate.

An expired scholarship must be distinguished from a temporarily closed application round.

A scholarship with no course link may still qualify for publication under existing policy.

Do not automatically approve human-held or manually refused records.

8. Continuous scholarship coverage validation

Create an automated feedback loop comparable to the AER continuous-assurance system.

Continuously compare:

Provider catalogue → Scholarship source coverage → Discovered opportunities → Stored scholarships → Validated records → Published opportunities

Detect and queue remediation for:

- Active providers without scholarship sources.
- Providers never successfully crawled.
- Missing secondary scholarship catalogues.
- Unread pagination results.
- Listing/detail count mismatches.
- Newly discovered scholarships.
- Missing or broken scholarship source URLs.
- Incorrectly refused candidates.
- AI extraction failures.
- Missing award values.
- Missing nationality classification.
- Incorrect provider relationships.
- Incorrect course relationships.
- Duplicate scholarships.
- Stale evidence.
- Stuck Layer 4 holds.
- Publication failures.
- Published records absent from consumer results.
- Failed or idle scheduled jobs.
- Providers incorrectly treated as fully covered.

The coverage checker must be independent enough to identify failures in the ingestion mechanism itself.

Do not use the same incomplete discovery list as both the input population and the proof of coverage.

Use provider catalogue identity and official source listings as independent reconciliation anchors.

9. Recovery and feedback queue

Integrate scholarship coverage failures into the existing platform feedback and integration queue.

Each actionable gap must retain:

- Country and provider identity.
- Scholarship or source identity, where known.
- Failure category.
- Evidence.
- Root cause.
- Responsible pipeline stage.
- First detected and last observed timestamps.
- Retry count.
- Priority.
- Assigned workstream.
- Current recovery state.
- Resolution and regression-test reference.

Systemic problems should create one consolidated engineering issue with affected-provider counts, rather than hundreds of duplicates.

Continue reacquisition, recalculation and verification until the gap is resolved or reaches a genuine approval, policy or external-source blocker.

Do not allow failed jobs to silently disappear from the queue.

10. Throughput and parallel-agent execution

Use maximum safe parallel agent development with independent file ownership and a single integration controller.

Recommended workstreams:

Agent A — UNSW source analysis and recovery

Prove complete catalogue enumeration and identify the five-record discrepancy.

Agent B — Provider-wide source coverage

Reconcile all eligible providers and their scholarship source URLs.

Agent C — Firecrawl discovery

Repair pagination, nested catalogue discovery, candidate enumeration and throughput.

Agent D — AI admission

Improve classification, evidence-backed extraction, legitimate refusals and eligible admission.

Agent E — Layer 4 and publication

Resolve technical queue blockers, publication failures and incorrect provider/course relationships.

Agent F — Continuous assurance and reporting

Implement the coverage ledger, gap detection, automated recovery feedback and progress dashboard.

Agent G — Independent validation

Build centrally governed tests for all affected transitions, including the UNSW regression case.

Agents may implement independent, non-conflicting changes concurrently.

Integrate through the existing GitHub workflow with a single release sequence and shared regression gate.

Avoid parallel mutations of the same database functions, migration files or scheduling configuration.

Increase acquisition throughput using measured worker capacity, fair provider scheduling, bounded concurrency and the existing credit budgets.

A P0 priority is not permission to bypass financial limits, data admission rules or destructive-change approvals.

11. Housekeeping and lifecycle integrity

Use existing Replaces/Retires rules.

When a provider is confirmed inactive or retired:

- Preserve and archive its scholarship records and evidence as policy requires.
- Retire associated discovery and re-read jobs.
- Prevent newly retired scholarships from remaining published.
- Reconcile related course mappings and search projections.
- Preserve history and auditability.

Country retirement must cascade through the governed lifecycle of all directly related providers, courses, scholarship records, AER records, discovery jobs, rules and queues.

Do not perform destructive deletion without the required Platform Admin approval.

Maintain independent lifecycle classifications for:

- Provider retirement.
- Scholarship retirement.
- Temporarily closed award rounds.
- Source URL relocation.
- Superseded annual editions.

12. Reporting and operational dashboard

Extend the existing Admin scholarship Coverage and Progress screens rather than creating a redundant dashboard.

Provide country-level and provider-level summaries.

Country coverage

Show:

- Eligible providers.
- Providers fully scanned.
- Providers partially scanned.
- Providers missing official sources.
- Providers with verified zero scholarships.
- Providers with unresolved gaps.
- Total discovered opportunities.
- Total validated scholarships.
- International-eligible scholarships.
- Published scholarships.
- Layer 4 pending scholarships.

Provider drill-down

Show:

- All official scholarship catalogue URLs.
- Each catalogue's last successful scan.
- Source listing counts.
- Candidate and admission counts.
- Outstanding pages.
- Extraction and validation failures.
- Published totals.
- Specific missing scholarships.
- Latest task and next action.

Recovery monitoring

Report daily progress and hourly operational deltas using existing notification channels.

Include:

- Gaps detected.
- Gaps recovered.
- New scholarships admitted.
- Newly published scholarships.
- Providers completed.
- Providers regressed.
- Active and blocked tasks.
- Firecrawl and AI consumption.
- Failed jobs.
- Layer 4 queue movement.

Distinguish verified completeness from partial coverage and unknown coverage.

Avoid using a misleading overall coverage percentage when the source denominator remains unknown.

13. Validation and regression gates

Implement continuous automated tests for:

1. Provider-to-scholarship source reconciliation.
2. Complete paginated catalogue traversal.
3. Discovery of multiple scholarship catalogues at one provider.
4. Idempotent repeated crawling.
5. Scholarship identity and deduplication.
6. Evidence-backed AI admission.
7. International/domestic audience separation.
8. Award-value and stipend extraction.
9. Layer 4 hold preservation.
10. Automatic publication rules.
11. Course relationship scope.
12. Consumer API consistency.
13. Source disappearance and retirement.
14. Scheduler starvation and failed recovery.
15. End-to-end UNSW catalogue reconciliation.

Use the central test governance and register. Do not proliferate overlapping per-provider tests when one parameterised central guard will suffice.

No failing or skipped tests may be carried into an approved release.

Before deployment, run the full required suite and applicable live dry runs.

After deployment, independently verify current database state, deployed Worker version, admission outcomes, job execution and consumer visibility.

Do not mark a workstream complete because code has merged. Mark it complete when the required live results are verified.

14. Delivery order

P0 — UNSW recovery

Identify every official catalogue, count the distinct opportunities, reconcile live records, fix systematic omissions and verify admissions and publication.

P1 — Australian provider-wide reconciliation

Audit all active Australian scholarship-eligible providers and recover missing discovery sources, candidates and admissions.

P2 — Continuous assurance

Activate automated gap detection, recovery queue management, progress reporting and regression tests.

P3 — New Zealand and Canada

Apply the same approach to all eligible providers in currently enabled countries.

P4 — Ongoing optimisation

Improve crawl efficiency, AI costs, freshness, source-change handling and low-yield provider diagnosis.

These phases may overlap through independent agents where safe.

15. Definition of done

This mandate is not complete until:

- The UNSW discrepancy is reconciled with actual verified counts.
- Its official scholarship catalogues are fully enumerated or any residual limitation is explicitly documented.
- Every active provider in the required scope has a coverage state.
- Each known scholarship candidate has a traceable outcome.
- Eligible scholarships are admitted and published according to the active governance rules.
- Domestic-only and other excluded scholarships are accounted for without polluting the international catalogue.
- Layer 4 technical blockers have been remediated or classified with evidence.
- Continuous gap detection and recovery operate without manual provider-by-provider prompting.
- Progress and recovery are visible through existing Admin operations.
- All required automated and deployed validation gates pass.
- Canonical design documents, mechanisms, change-control records and the execution register are current.

16. Required response and execution authority

Start with repository and live-state reconciliation, then proceed immediately with independently executable, non-conflicting tasks.

Do not return only a design or implementation proposal.

Provide an initial baseline and execute the approved engineering work under the existing operating model.

Do not ask the Platform Admin to approve routine non-destructive fixes already authorised by standing governance.

Escalate only genuine approval gates, destructive actions, consumer contract changes, unapproved AI-admission activation or material policy conflicts.

Record before-and-after counts, PRs, releases, migration status, remaining blockers and test outcomes.

Maintain the feedback loop until each gap is resolved or has an explicitly recorded disposition.

Success means sustained, independently verified scholarship coverage across the provider catalogue — not merely additional scholarship records for UNSW.