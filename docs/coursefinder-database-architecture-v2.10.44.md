# CourseFinder Database Architecture v2.10.44

**Status:** CURRENT — M2.4.3 ACTIVE ADDITIVE ARCHITECTURE  
**Date:** 29 August 2026  
**Supersedes:** v2.10.43; all unspecified prior structures and semantics remain inherited unchanged.  
**Change Controls:** prior accepted controls plus `CF-CHG-20260829-046`

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


## 11. M2.4.2 operational telemetry extensions

M2.4.2 makes provider/model usage telemetry a standing relational contract under Execution Addendum A14.

### Layer 2

`pipeline.layer2_provider_attempts.metrics` remains the attempt-level extensible metrics object and now carries, where available:
- provider key;
- latency;
- request-unit/vendor-unit usage;
- vendor-unit basis;
- estimated request cost;
- Evidence and provider telemetry already retained by the acquisition path.

Managed execution remains represented through `pipeline.layer2_run_batches` and `pipeline.layer2_run_items` for batch/item timing, retry, provider, outcome, fields-targeted/resolved, Evidence footprint and Layer 3 fall-out.

The active attempt-producing runtime surface at M2.4.2 closure is:
- `layer2-acquire-v2` v9;
- `layer2-scope-discover-scheduled` v19;
- `layer2-scale-qualify-scheduled` v3.

Each path must populate or explicitly leave unavailable the telemetry fields it can govern. Historical values are not inferred.

### Layer 3

`pipeline.layer3_interpretations` includes:
- `input_tokens`;
- `output_tokens`;
- `estimated_cost_usd`;
- `external_call_count`;
- `call_latency_ms`;
- persisted call start/completion timestamps and returned model.

`pipeline.layer3_provider_credential_audit` includes:
- provider model;
- external-call count;
- input/output tokens;
- estimated cost;
- measured latency.

`pipeline.layer3_quality_benchmark_runs` remains the benchmark-level store for configured/returned model, external-call count, input/output tokens, cost and latency evidence.

The active chat-completion runtime surface at M2.4.2 closure is:
- `layer3-interpret` v3;
- `layer3-provider-control` v2;
- `layer3-source-pattern-benchmark` v7.

No model/token/cost telemetry grants canonical write authority.

## 12. Screenshot Evidence extension

Rendered acquisition screenshots are retained as separate private `layer2_screenshot` Evidence objects linked to the relevant provider attempt/source Evidence.

Screenshot Evidence:
- is secondary visual Evidence;
- does not replace source/raw Evidence;
- does not become extraction authority by itself;
- uses existing authenticated private signed-access controls for thumbnail/full view.

## 13. Advanced paused-profile visibility

Advanced Layer 2 configuration may read governed paused/disabled Course and Scholarship profiles for operational visibility.

This does not change execution eligibility. Runtime/scope execution contracts continue to exclude paused profiles from executable work.

## 14. M2.4.2 closure state

Accepted Pilot source: `093010fada8391c93626b59e59c678064f4961c3`.

Corrective Stage C: `33219089690` — desktop/mobile PASS.

Carried-forward governed blockers:
- RMIT frozen 212-record canonical promotion remains un-applied and blocked pending an already-authorised exact-set executor;
- Layer 3 source-pattern benchmark remains blocked under its unchanged quality threshold.

These blockers do not alter the accepted database architecture and do not authorise bypass.


## 15. A15 institute international contact intelligence

M2.4.3 adds a private Layer 2 contact-intelligence domain for Provider international recruitment context.

Private relational objects:
- `pipeline.provider_contact_profiles` — governed Provider/domain discovery configuration;
- `pipeline.provider_contact_observations` — versionable first-party/licensed/manual professional contact observations;
- `pipeline.provider_contact_watch_events` — explicit title/territory/contact change events;
- `pipeline.provider_contact_enrichment_attempts` — contact-discovery/enrichment calls, latency, units and cost telemetry.

Authority:
- first-party university-published professional contacts are preferred;
- licensed professional enrichment is secondary context;
- manual governed resolution is permitted with provenance;
- none of these objects redefine Layer 1 Provider/Course identity or directly alter Search/Publication.

Privacy/security:
- contact tables remain in private `pipeline`;
- no direct anon/authenticated table grant is introduced;
- server-side workers use service-role-only RPC bridges;
- Provider Admin reads contacts through the existing authenticated `security.admin_provider_detail(uuid)` boundary;
- LinkedIn HTML scraping is not part of the architecture;
- licensed enrichment defaults to professional title/profile metadata and does not request personal email/phone reveal.

Evidence:
- first-party observations retain source URL and private Evidence;
- transport may use governed Direct HTTP → Firecrawl fallback;
- already-governed Provider subdomains may participate in discovery;
- transport URL normalization may repair malformed acquisition strings but must not mutate Layer 1 Provider website authority.

Source precedence in the Provider read model is:
`first_party → governed_manual → licensed_enrichment`.

Change semantics:
- initial discovery is inventory creation, not an operator alert;
- later title, territory, professional contact or removal/restoration differences create auditable watch events;
- rejected/noisy extraction remains retained historically but is excluded from current Provider contact presentation.

At adoption, the initial governed cohort is 52 AU + 8 NZ Provider profiles. The UQ proof retains eight structured International Regional Manager territory assignments from first-party Evidence.


## 16. A15 accepted rollout characteristics

The first AU/NZ contact-intelligence rollout establishes the following measured baseline:
- 60 contact profiles;
- 31 current accepted professional/institutional contact observations;
- 17 current territory-assigned observations;
- 45 rejected historical/noisy observations retained for provenance;
- 0 current profile errors after recovery.

Acquisition is explicitly multi-provider:
- Direct HTTP is preferred and may fail transparently;
- Firecrawl is a governed fallback for 403, 410, 429, 5xx and bounded network/timeout classes;
- attempt telemetry retains provider, calls, vendor units, latency, cost field and outcome.

Transport corrections (for example stale/malformed Provider website strings or a contact-specific live entry point) are private Layer 2 operational configuration. They do not mutate canonical Layer 1 Provider website authority.

Licensed enrichment remains optional and secondary. Absence of a credential is a configuration state, not a reason to weaken first-party precedence.
