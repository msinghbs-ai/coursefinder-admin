# CF-247 AER design gap assessment — 2 November 2026

**Status:** Design revision lodged; implementation and production corrections **not** performed. **Authority:** Platform Admin's 2 November mandate to assess and version the existing AER design. **Canonical design:** `docs/platform/ENTRY-REQUIREMENTS.md` Draft 1.2. **Related:** `ENTRY-REQUIREMENTS-IMPLEMENTATION.md`, `ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`, `nz-enrichment-brief/2026-10-30-aer-production-closure-mandate.md`, `STUDYSEARCH-EXECUTION-REGISTER.md`.

## Assessment and gap register

| ID | Gap | Evidence/baseline | Design disposition | Validation |
|---|---|---|---|---|
| AER-GAP-01 | Global qualifications rejected as non-country | RMIT IB and GAC source read runs held: `not a country table: no country named in page heading` (26 Oct). | Canonical global qualification identity, provider-recognition policy, no fabricated country. | Nepal and Switzerland students with IB resolve the same applicable RMIT global rule when active. |
| AER-GAP-02 | UK country incomplete | RMIT UK read held: 2 of 31 published minima not read (26 Oct); no active GB rows in previous live snapshot. | Row/column/section reconciliation and held recovery. | All 31 minima reconciled or explicitly source-evidenced non-applicable; no partial silent admission. |
| AER-GAP-03 | Other country source holds | Nigeria 6/17 missing; Vietnam table-context hold; Norway scale hold; other sources may exist. | Source-to-row completeness register and bounded remediation. | Every held source has reason, owner, recovery path and admission status. |
| AER-GAP-04 | Global curriculum vs country conflation | Nepal has national HSC active rows, but no global IB/A Level/US diploma records tied to Nepal; Switzerland absent from RMIT matrix. | Separate student education-country context from qualification recognition and provider constraints. | Nepal+IB, Swiss+IB, Nepal+A Levels and Nepal+US diploma behave without invented equivalencies. |
| AER-GAP-05 | Postgraduate pathways inadequately represented in consumer availability | Course entries include proposed `prior_qualification`, `minimum_grade`, `work_experience` etc.; many not admitted. | Distinct postgraduate coursework and research pathways, GPA/degree/discipline/experience; existing course admission route. | Course-specific master's test cases with approved data; no Year 12 band fallback. |
| AER-GAP-06 | Narrow provider scope | 28 Oct programme decision has approved ~40-provider scope and explicitly excludes RMIT from matrix expansion. | Target all eligible AU/NZ providers, phased through explicit scope and cost approvals; do not silently override old mandate. | Eligible denominator, source-discovery outcome and accepted coverage per provider. |
| AER-GAP-07 | Provider AER URLs not surfaced as first-class entity information | Existing `pipeline.entry_matrix_sources` associates URLs with providers, but Provider entity design lacks a canonical primary entry URL and grouped linked sources. | Reuse current registry; expose canonical primary URL and additional URLs under Provider Admin, with source type, scope, status, evidence, date. | Provider source URLs visible, identity-checked and not duplicated as independent truth. |
| AER-GAP-08 | Country-only UI misrepresents qualification coverage | Existing resolver and proposed filters are keyed largely by `edu_country`; global rules lack independent qualifier. | Qualification-first resolution with conditional country filtering; role-appropriate Admin versus consumer completeness. | Only active verified provider-supported pathways advertised; Admin also shows held/missing. |
| AER-GAP-09 | Ambiguous completeness metric | Source `read` can coexist with run `failed/held`. | Separate discovery, extraction, admission and consumer coverage metrics. | Read status never implies complete admission. |
| AER-GAP-10 | Consumer compatibility | Existing website v2 contract frozen; course and provider entry payloads already additive. | Any additional filters/keys require explicit consumer API approval, baseline and developer guide; do not deploy from design revision. | Existing calls unchanged, contract tests green and handover documented. |

## Evidence baseline and caution

Read-only live checks performed in the preceding discussion found **RMIT 567 matrix rows (380 active, 167 superseded, 20 unverified), 36 recorded sources, 36 runs; no GB or CH matrix rows**. These are *time-specific observations*, not targets or proof of current production completeness. RMIT Nepal has 11 active national-equivalency rows; they do **not** establish IB, A Levels or American diploma coverage. Course entry counts likewise reflect the snapshot, not guaranteed current values. Re-query before acceptance.

## Revised model and resolution requirements

- Applicant context: education country (optional for globally applicable qualifications), qualification, awarding body/curriculum where material, destination provider, course, study level and intake.
- A **qualification identity** can be global/transnational, country-specific or restricted by jurisdiction/issuer. Recognition is an evidenced **provider rule**, not a claim that every award of the same name qualifies.
- Preserve existing five-step precedence: course override, per-course, course benchmark band, provider minimum, case-by-case/contact. Add qualification matching *within* the applicable steps, and never choose an easier minimum by heuristic.
- Separate postgraduate coursework/research requirements from Year 12 equivalencies. Use existing `catalogue.course_entry_requirements` kinds; extend only where existing metadata cannot safely represent required semantics.
- Do not infer ATAR-to-percent mappings, automatic eligibility, country recognition, school accreditation or SAT/ACT equivalency.
- Global-qualification source pages must be processed even where no country heading exists; maintain quote-on-page, scale, source hash, edition and Layer 4 admission.
- A provider's official landing URL and additional course, national, global and postgraduate source pages are displayed via a provider-linked canonical registry. No wholesale URL duplication in `catalogue.providers`.
- Consumer country dropdown contains only **verified provider-supported country-specific routes**; a separate global qualification group is selectable regardless of country, subject to source restrictions. Unsupported/held countries remain visible as gaps to Admin.
- Reconcile official source navigation/sections → discovered → extracted → admitted → consumer-visible, by country, qualification, study level and course. Distinguish unobserved from explicitly not-published.

## Change-control, scope and acceptance

This is a **design gap record**, not authorisation to bypass the 28 Oct RMIT exclusion, 30 Oct ingestion hold, Layer 4 approvals, paid-read controls, or frozen API approval. Claude/integrator must reconcile precedence and write a specific superseding decision before executing any conflicting work. Current priority: (1) source inventory/impact model and acceptance fixtures; (2) read-only RMIT held-source reconciliation; (3) additive identity and resolver design; (4) Admin source display; (5) governed provider-wave expansion; (6) separately approved consumer contract/handoff.

Representative acceptance fixtures: Nepal/IB/Bachelor/RMIT; Switzerland/IB/Bachelor/RMIT; Nepal/A Levels/Bachelor; Nepal/US-curriculum diploma with issuer/SAT/ACT caveats; Nepal HSC/Bachelor; UK A Levels/Bachelor; GAC/Bachelor; master's course degree/GPA/discipline/experience; evidence-absent fallback; no fabricated score or admission.

**Done in this record:** requirements and gap rationale are documented. **Not done:** schema, source re-reads, active admission, consumer UI, provider source view, all-provider rollout, production verification.
