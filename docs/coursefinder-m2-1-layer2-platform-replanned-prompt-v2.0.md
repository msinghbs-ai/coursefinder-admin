# M2.1 — L2-PLATFORM Replanned Prompt v2.0

Use this as the opening prompt for the active M2.1 workstream or any replacement chat continuing the same gate.

---

**M2.1 — L2-PLATFORM — Layer 2 Acquisition, Deterministic Extraction, Completeness Trial & Evidence Foundation**

Before doing any work, read `PROJECT_INSTRUCTIONS.md` in `msinghbs-ai/coursefinder-admin`, then follow the referenced current governance documents and maintain the applicable Change Control records for this workstream. Reconcile the latest Admin docs, current architecture/design decisions, Pilot code, deployed Supabase state, Production-transition state and overlapping open Change Controls before changing anything. Do not overwrite newer parallel work. Perform technical UAT autonomously and only hand over when the stated gate is PASS, BLOCKED with evidence, or explicitly DEFERRED.

Documentation is part of Definition of Done. Keep current architecture, database model, Admin information architecture/menu, User Guide, PIM Admin Guide, Data Flow & Feature Atlas and Operations Runbook aligned with the deployed behaviour.

## Product boundary

CourseFinder is an **international-student Course and related-data aggregation, discovery and comparison platform**. It aggregates Providers, Courses, Campuses, regulatory facts, tuition, intakes, English and academic entry requirements, Scholarships, descriptions/taxonomy/delivery, outcome/student-flow context, Evidence, completeness and freshness so counsellors and international students can compare Course + university/Provider + Campus/state combinations.

University application processing, university admissions decisions, offer-letter processing and visa processing are out of scope. Avoid the ambiguous term **Search Admission** in new work. Use **Search Eligibility**, **Search Projection**, **Search Visibility**, **Publication Eligibility** or **Publication** as appropriate.

## Final layer model

There are exactly four data-enrichment authority layers:

**Layer 1 — Authoritative / Regulatory → Layer 2 — Deterministic Acquisition & Extraction → Layer 3 — AI-assisted Evidence Interpretation → Layer 4 — Human Resolution**

Layer 4 is terminal for enrichment authority. There is **no Layer 5**. Completeness/readiness, Search projection/visibility and Publication are downstream product states, not additional layers.

Preserve this sequence:

`Source/Authority → Acquisition → Native Evidence → Normalised Extraction Evidence → Deterministic Observation/Candidate → Layer 3 only if needed → Layer 4 only if still unresolved → governed canonical result/readiness → Search Projection/Visibility → Publication`

No acquisition/extraction/AI success may directly bypass canonical governance.

## Layer 2 reusable platform

Maintain a reusable, provider-agnostic Layer 2 platform with separate concepts for:

- Source Profile;
- immutable Source Profile Version;
- Acquisition Provider;
- Source → Provider Route;
- Acquisition Job;
- Provider Attempt;
- Native Provider Evidence;
- Normalised Extraction Evidence;
- deterministic domain extraction workers.

Source Profiles define authority, country/domain, acquisition/discovery scope, URL allowlist/patterns, parser/mapping semantics, stable identifiers, regulatory identifiers, MIME/payload rules, freshness, schedule, Evidence policy and Change Control/UAT references.

Acquisition Providers define reusable fetch mechanisms such as Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future API/browser/structured providers. Keep vendor credentials server-side in Supabase Vault. API keys/tokens/passwords/cookies/Authorization/service-role credentials must never be browser-readable configuration.

Every acquisition target must remain source-bound. Do not create an arbitrary URL proxy.

## Provider-compatible extraction

Provider-specific transport and response-format logic must terminate at the shared `layer2-extract`/normalisation boundary. Downstream Course/fee/intake/English/Scholarship workers consume a stable extraction-input contract rather than implementing Scrape.do/ScraperAPI/Firecrawl/ZenRows logic independently.

Preserve the provider-native Evidence exactly where supported: HTML, JSON, Markdown, PDF/XLSX/ZIP or other approved documents, screenshot/image, plus provider metadata. Normalised extraction Evidence is derived and must retain lineage to native Evidence, Job, Provider Attempt and Source Profile version.

Screenshot policy must never manufacture screenshots. Only record screenshot/image Evidence when the acquisition provider actually returned/materialised it.

## Country-based Course completeness trial

M2.1 must prove the platform through **country-based Course completeness trials**, not merely configuration CRUD.

For each trial country, define a Country Course Completeness Profile using that country's actual regulatory/authority semantics. Do not impose CRICOS semantics outside Australia.

For each selected university/Provider, begin with an approximately **10-Course representative batch** unless the source requires a different bounded cohort. Ten is an initial learning batch, not a permanent limit.

Include a useful mix of static, dynamic/JavaScript-heavy, simple and structurally difficult Course pages where available. Measure pre-run completeness, identify only missing/stale domains, acquire/extract those domains, then measure post-run evidence-backed completeness.

Use adaptive expansion:

- consistently strong extraction (around ≥90% evidence-backed success) → expand cautiously;
- mixed results (around 70–89%) → run another validation batch;
- poor results (<70%) → diagnose acquisition/extraction and test an alternate provider before scaling.

These are trial defaults and may be refined from actual evidence rather than treated as hard canonical thresholds.

## Provider benchmarking / selection

The purpose is to decide which provider is **most reliable, least expensive for the outcome, and right on target** for each source/site class.

Do not optimise on API request price or HTTP 200 alone. Measure:

- acquisition success;
- anti-bot/gatekeeping success;
- JavaScript/render success;
- Evidence completeness/quality;
- deterministic extraction success;
- correctness against source;
- latency;
- retries;
- requests per Course;
- vendor cost per Course;
- vendor cost per evidence-backed completed Course/domain;
- completion delta from the pre-run baseline;
- screenshot usefulness where applicable;
- projected Layer 3 recovery/human-review rate.

Retain metrics per Provider Attempt/source/Course cohort so route recommendations can later be evidence-based. Do not silently self-modify provider order without accepted governance/UAT.

## Course completeness domains

For Australia, evaluate applicable international-student Course domains such as:

- Provider/Course/CRICOS identity;
- regulatory duration and CRICOS registered fees;
- current Provider tuition, currency, year and fee basis;
- official Course URL;
- intake availability;
- Campus/delivery/geography;
- English requirements and test detail;
- academic entry requirements;
- Course description/taxonomy;
- relevant Scholarships;
- Evidence/verification/freshness;
- decision-context availability.

Preserve semantic states including `present`, `source_null`, `not_applicable`, `zero`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected`.

## Scholarship acquisition/extraction

Implement/prove a reusable Scholarship discovery/acquisition/extraction worker using the same Layer 2 Source Profile → Provider Route → Provider Attempt → Evidence → normalised extraction contract.

Support evidence-backed candidate fields such as Scholarship name, official URL, Provider, value/type/currency/percentage, eligible Courses/study levels/nationalities, international-student eligibility, academic/English requirements, application requirement, automatic consideration, opening/closing dates, intake applicability, duration/renewability and terms URL.

`not found by scraper` must never become `no scholarship`. Preserve `not_discovered/not_yet_enriched` separately from authoritative none/not-applicable.

## QILT / PRISMS decision context

QILT and PRISMS must be available with Courses where relevant to help counsellors/students compare Course + university/Provider + Campus/state combinations, even when their source grain is Provider, study area/field, state, sector or reporting cohort.

Preserve their actual grain and reporting period. A Provider-level QILT metric must remain explicitly Provider-level; a PRISMS Provider/state/cohort trend must not be relabelled as a Course-level enrolment fact.

Support contextual Course-facing projections such as:

- `qilt_provider_context`;
- `qilt_study_area_context`;
- `prisms_provider_context`;
- `prisms_state_context`;
- `scholarship_context`.

Do not duplicate these into Course-grain canonical columns solely for display convenience.

Completeness must therefore distinguish **Course factual completeness** from **decision-context completeness**.

## Layer 3 contract

Layer 3 is not an independent scraper. It consumes governed Layer 2 Evidence, Course/entity identity, missing domains, source authority, Provider Attempt metadata and prior observations.

Layer 3 may interpret difficult HTML/JSON/Markdown/documents/images/screenshots, reconcile Evidence and produce candidate facts with Evidence references, confidence and ambiguity.

If Layer 3 determines the Evidence is insufficient, it requests additional Evidence capability from Layer 2, for example JavaScript-rendered content, screenshot/image or alternate-provider acquisition. Layer 2 performs that acquisition.

## Layer 4 contract

Only genuinely unresolved, conflicting or consequential cases reach Layer 4. The reviewer must receive the complete decision package: entity/Course, missing/conflicting domain, all relevant Provider Attempts, native/normalised Evidence, deterministic candidates, Layer 3 suggestion/confidence if applicable, source/freshness and explicit reason automation stopped.

Layer 4 is the final resolution authority. Nothing beyond Layer 4 enriches or resolves data.

## Admin information architecture

Primary navigation should remain lifecycle-based:

**Overview**
- Dashboard

**Catalogue**
- Providers
- Courses
- Campuses
- Scholarships

**Data Acquisition**
- Pipeline Control
- Source Registry
- Layer 2 Source Config
- Acquisition Providers
- Jobs
- Evidence

**Enrichment & Insights**
- Outcomes (QILT)
- Student Flow (PRISMS)

**Quality & Review**
- Completeness
- Review Queue

**Governance & Platform**
- Attributes
- Settings

Do not hide Pipeline/Layer 2/Evidence behind floating launchers once the main navigation integration is accepted.

## M2.1 acceptance gate

M2.1 is PASS only when all applicable requirements are evidenced:

- reusable/versioned Source Profile contract;
- reusable acquisition-provider registry, Vault credentials and routing/fallback;
- Provider Attempt and native/normalised Evidence lineage;
- source-bound acquisition/SSRF protection;
- provider-compatible normalisation/extraction worker;
- multiple provider types represented and securely operable;
- country completeness trial executed against representative real Courses;
- evidence-backed provider comparison metrics retained;
- Scholarship acquisition/extraction path proven on a bounded cohort;
- QILT/PRISMS Course-context projection semantics defined/proven without false Course grain;
- Layer 3 additional-Evidence request contract defined;
- Layer 4 terminal routing contract defined;
- canonical/Search/Publication baseline not broadened accidentally;
- main Data Acquisition navigation coherent;
- desktop/mobile browser/security UAT PASS;
- Change Controls and current architecture/design/database/menu/guides/runbook/atlas updated.

Do not close the gate merely because configuration tables or APIs exist. If external provider credentials are unavailable, document that bounded provider-specific live test as BLOCKED/DEFERRED with evidence rather than weakening the acceptance criteria or fabricating a provider success.

---
