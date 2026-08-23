# CourseFinder Database Architecture v2.10.42

**Status:** CURRENT M2.1 ADDITIVE ARCHITECTURE  
**Date:** 23 August 2026  
**Supersedes:** v2.10.41 for M2.1 interpretation; all unspecified M1 structures and semantics remain inherited unchanged.  
**Change Control:** `CF-CHG-20260823-029`

## 1. Architecture correction

M2.1 establishes a four-layer enrichment authority model only:

`L1 authoritative/regulatory → L2 deterministic acquisition/extraction → L3 AI-assisted Evidence interpretation → L4 human resolution`

Completeness/readiness, Search projection/visibility and Publication are downstream states, not additional authority layers. CourseFinder is an international-student Course and related-data aggregation/discovery platform; university admissions/application/offer-letter/visa processing are outside this architecture.

## 2. Layer 2 relational model

Existing M2.1 tables remain the reusable acquisition substrate:

- `pipeline.layer2_source_profiles`
- `pipeline.layer2_source_profile_versions`
- `pipeline.layer2_acquisition_providers`
- `pipeline.layer2_profile_provider_routes`
- `pipeline.layer2_provider_attempts`
- `pipeline.jobs`
- `pipeline.evidence_artifacts`

### Stable relationships

`Source → Layer2 Source Profile → immutable Profile Version → Job → Provider Attempt → Evidence Artifact`

Provider routing remains many-to-many through `layer2_profile_provider_routes`; acquisition-vendor logic must not create provider-specific canonical schemas.

## 3. Evidence representation

Two Evidence representations are recognised:

1. **Native Provider Evidence** — exact bytes/representation returned by the acquisition provider, e.g. HTML, JSON, Markdown, PDF/XLSX/ZIP, PNG/JPEG screenshot or other approved MIME.
2. **Normalised Extraction Evidence** — a derived common extraction input retaining lineage to the native Evidence and exact source-profile/provider attempt.

Normalisation must never overwrite or discard native Evidence.

Every derived observation/candidate should be traceable to Evidence, Job, Source Profile version and acquisition provider attempt where applicable.

## 4. Extraction worker contract

`layer2-extract` is the provider-response normalisation boundary. Provider-specific transport/response shape terminates before downstream domain extractors.

Domain extraction workers consume a stable normalised input and produce observations/candidate facts for domains such as:

- Course facts;
- current tuition/fees;
- intakes;
- English requirements;
- academic entry requirements;
- Scholarships;
- descriptions/taxonomy/delivery where approved.

Domain workers must not independently retrieve arbitrary URLs or hold scraper credentials.

## 5. Country completeness model

Course completeness is country-scoped. A Country Course Completeness Profile defines the expected international-student domains and their semantic states for a jurisdiction.

Do not flatten country-specific regulatory concepts into a single CRICOS-shaped schema. CRICOS semantics apply to Australia only; NZ and future countries use their own accepted authority identifiers and vocabularies.

Completeness state must preserve `present`, `source_null`, `not_applicable`, `zero`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected`.

The architecture distinguishes:

- **Course factual completeness** — direct Course-grain facts;
- **decision-context completeness** — relevant contextual signals at Provider/study-area/geography/cohort grain.

## 6. QILT / PRISMS contextual projection

QILT and PRISMS remain stored at their actual source grain. They must not be duplicated into canonical Course columns solely for display convenience.

A Course-facing derived/read/Search projection may assemble contextual objects such as:

- `qilt_provider_context`
- `qilt_study_area_context`
- `prisms_provider_context`
- `prisms_state_context`
- `scholarship_context`

Each contextual object must carry enough metadata to preserve source, grain/scope, reporting period and freshness. The projection is a decision aid for comparing Course + Provider + Campus/State combinations; it is not evidence that the contextual metric was measured for that exact Course.

## 7. Scholarship architecture

Scholarships are first-class related entities and should continue to use relational Scholarship records rather than flattening arbitrary scholarship details into Course rows.

Layer 2 may discover and extract Scholarship candidates through the shared acquisition/evidence platform. Course/Provider/study-level/nationality applicability should be represented relationally or as governed eligibility structures, with source Evidence and verification timestamps preserved.

Failure to discover a Scholarship is `not_yet_enriched`/`not_discovered` unless an authoritative source establishes a different state; it is not automatically `none`.

## 8. Layer 3 and Layer 4 data contracts

Layer 3 reads governed Layer 2 Evidence/observations and produces evidence-backed suggestions/candidates with confidence and ambiguity state. It does not become a second independent acquisition plane.

Layer 4 consumes unresolved/conflicting Layer 2/3 candidates and Evidence. Human decisions are terminal enrichment-authority decisions and must remain auditable.

There is no Layer 5 schema or authority concept.

## 9. Search/publication terminology

Avoid the phrase `Search Admission` in new architecture/UI/docs because it may be misread as university admissions. Existing historical function/table names may remain until a controlled rename is justified.

Preferred product-state terminology:

- Search Eligibility;
- Search Projection;
- Search Visibility;
- Publication Eligibility;
- Publication.

These are downstream projections/states and do not alter Layer 1–4 authority.

## 10. Benchmarking data requirement

M2.1 provider trials should retain enough attempt metrics to calculate per-provider and per-source outcomes including acquisition success, extraction success, latency, retries, Evidence MIME/size, cost units where supplied, completion delta and eventual human-review requirement.

The primary economic comparison is not raw request price; it is **cost per evidence-backed completed Course/domain**.

No cost or provider-performance metric grants permission to overwrite authoritative source semantics.
