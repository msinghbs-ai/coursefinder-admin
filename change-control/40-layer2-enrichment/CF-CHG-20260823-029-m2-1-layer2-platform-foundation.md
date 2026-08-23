# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — DEPLOYED BROWSER UAT / LIVE PROVIDER TRIAL EVIDENCE OUTSTANDING  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Trigger

Milestone 2.1 authorised a reusable Layer 2 foundation after the frozen M1 Pilot baseline. The workstream was subsequently clarified in three material ways:

1. source-profile configuration alone is insufficient; Layer 2 requires reusable multi-provider acquisition, Vault-backed credentials, provider routing/fallback, per-attempt Evidence and provider-compatible extraction;
2. the platform must prove this model through country-based Course completeness/provider trials and Scholarship acquisition rather than configuration CRUD alone; and
3. CourseFinder has exactly four enrichment authority layers. Layer 4 is terminal; Search/Publication are downstream product states and CourseFinder is not a university-admissions workflow.

## Product / authority boundary

CourseFinder is an **international-student Course and related-data aggregation, discovery and comparison platform**. University application processing, admissions decisions, offer-letter processing and visa processing are outside this platform scope.

The final enrichment authority model is:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

There is **no Layer 5**. Completeness/readiness, Search Projection/Visibility and Publication are downstream states.

Avoid **Search Admission** in new work because it is ambiguous with university admissions. Preferred terms are Search Eligibility, Search Projection, Search Visibility, Publication Eligibility and Publication.

## Required operating sequence

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Native Evidence → Normalised Extraction Evidence → Deterministic Observation/Candidate → Layer 3 if required → Layer 4 if still unresolved → governed canonical/readiness result → Search Projection/Visibility → Publication`

Acquisition/extraction success never directly authorises canonical mutation, Search visibility or Publication.

## Affected surfaces

- `pipeline.sources`, `pipeline.jobs`, `pipeline.evidence_artifacts`;
- `pipeline.layer2_source_profiles`, `pipeline.layer2_source_profile_versions`;
- `pipeline.layer2_acquisition_providers`, `pipeline.layer2_profile_provider_routes`, `pipeline.layer2_provider_attempts`;
- Supabase Vault provider credentials;
- private Storage bucket `evidence`;
- `public.admin_read(text,jsonb)`;
- Edge Functions `layer2-config-control`, `layer2-provider-control`, `layer2-acquire`, `layer2-extract`;
- Pilot Data Acquisition navigation and Layer 2 provider/source Admin surfaces;
- country completeness/provider benchmark UAT;
- Scholarship discovery/acquisition/extraction;
- QILT/PRISMS Course decision-context projections;
- Layer 3 additional-Evidence request contract;
- Layer 4 terminal human-resolution contract;
- automated database/security/API/deployed-browser UAT;
- architecture/database/design/menu/guides/runbook/atlas documentation.

## Implemented Source Profile foundation

- reusable `pipeline.layer2_source_profiles`;
- immutable `pipeline.layer2_source_profile_versions` with validation/hash/CC/UAT references;
- exact profile-version reference on Jobs and Evidence;
- pre-execution validity/enabled/paused gate;
- Evidence version guard;
- authenticated governed Admin read surface;
- rank-5 immutable version creation and rank-6 state controls;
- malformed initial `base_domain` seeds corrected through governed v2 profile versions rather than direct overwrite.

## Implemented acquisition-provider foundation

Provider credentials are write-only through authorised Admin controls and stored in Supabase Vault. Browser reads expose only `credential_configured`. Provider capability/request JSON rejects secret-like fields.

| Priority | Provider | Mechanism | Authentication | Extraction response adapter | Default state |
|---:|---|---|---|---|---|
| 10 | Direct HTTP | direct source GET | none | passthrough | enabled |
| 20 | Scrape.do | scraper API / rendered fetch | query `token` | passthrough / `scrape_do_json` | enabled, credential required |
| 30 | ScraperAPI | scraper API / rendered fetch | query `api_key` | passthrough | enabled, credential required |
| 40 | Firecrawl | browser/API scrape POST | bearer | `firecrawl_v2` | enabled, credential required |
| 50 | ZenRows | scraper API / JS render / premium proxy | query `apikey` | passthrough | enabled, credential required |
| 90 | Custom gateway | configurable API gateway | configurable header seed | `generic` | disabled until configured |

Current web/search routing for RMIT, UQ and Study Australia is:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

QILT structured document and PRISMS XLSX remain Direct HTTP by default because they are deterministic downloadable sources.

Current provider count: **6**. Current route count: **17**.

## Provider-compatible extraction worker

JWT-protected `layer2-extract` normalises provider-native Evidence into a common private extraction-input Evidence artifact while preserving the original Evidence.

Supported adapter patterns include passthrough HTML/JSON, Firecrawl v2 Markdown/HTML/structured JSON/screenshot references, Scrape.do JSON/screenshot mode and generic configurable extraction paths.

`layer2-extract` does not call an LLM. It is the Layer 2 provider-normalisation boundary. Domain extractors and future Layer 3 AI consume the common Evidence contract without embedding scraper-vendor transport logic.

Screenshot policy does not manufacture screenshots; a provider must actually return/materialise screenshot/image Evidence.

## Country-based Course completeness trial — now part of M2.1

M2.1 must prove the platform through bounded real-Course completeness trials.

For each selected country:

1. define a Country Course Completeness Profile using that country's accepted authority semantics;
2. select universities/Providers and begin with an approximately 10-Course representative learning batch per Provider unless another bounded cohort is justified;
3. include static, dynamic/JavaScript-heavy and structurally difficult examples where available;
4. measure pre-run Course factual completeness and decision-context completeness;
5. acquire/extract only missing/stale domains;
6. retain provider-native Evidence and normalised Evidence;
7. measure post-run evidence-backed completion and correctness;
8. compare provider latency/retries/cost/outcome;
9. expand, re-test or change provider based on measured consistency.

Approximate operating defaults are ≥90% consistent evidence-backed extraction to expand cautiously, 70–89% for another validation batch, and <70% to diagnose/test alternate provider before scale-out. These thresholds are trial guidance, not canonical rules.

Provider selection is based on **cost per evidence-backed completed Course/domain**, accuracy, Evidence quality and reliability—not raw API request price or HTTP 200 alone.

## Course completeness semantics

Country completeness must preserve direct Course facts such as applicable regulatory identity, current tuition, official Course URL, intake, Campus/delivery, English/academic entry requirements, description/taxonomy, Scholarships, Evidence/freshness and relevant context.

Preserve `present`, `source_null`, `not_applicable`, `zero`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected`.

Distinguish:

- **Course factual completeness** — direct facts about the Course; and
- **decision-context completeness** — relevant Provider/study-area/state/international-student context useful for selection.

## Scholarship acquisition / extraction

M2.1 now requires a reusable Scholarship discovery/acquisition/extraction path using the same Source Profile → Provider Route → Provider Attempt → Evidence → normalised extraction contract.

Target candidate semantics include Scholarship name/URL, Provider, award value/type/currency/percentage, eligible Courses/study levels/nationalities, international-student eligibility, academic/English requirements, application/automatic-consideration semantics, dates/intakes, duration/renewability and terms URL.

`not found by scraper` must never be translated to `no scholarship`.

## QILT / PRISMS decision context

QILT and PRISMS must be available alongside Courses where relevant to help counsellors/international students compare Course + university/Provider + Campus/state combinations, while preserving actual source grain and reporting period.

Permitted contextual projections include:

- `qilt_provider_context`;
- `qilt_study_area_context`;
- `prisms_provider_context`;
- `prisms_state_context`;
- `scholarship_context`.

A Provider-level QILT metric must remain explicitly Provider-level. A PRISMS Provider/state/cohort trend must not be represented as the Course's own enrolment count. Do not duplicate contextual metrics into Course-grain canonical columns solely for UI convenience.

## Layer 3 / Layer 4 hand-off

Layer 3 consumes governed Layer 2 Evidence and may request additional Layer 2 Evidence capabilities when evidence is insufficient. It does not independently scrape or receive Vault credentials.

Only genuinely unresolved/conflicting/consequential cases reach Layer 4. Reviewers receive the complete Evidence/Provider Attempt/candidate package and the explicit reason automation stopped.

Layer 4 is terminal for enrichment authority. There is no Layer 5.

## Admin information architecture

Related `CF-CHG-20260823-030` groups operational acquisition coherently:

- Data Acquisition → Pipeline Control;
- Source Registry;
- Layer 2 Source Config;
- Acquisition Providers;
- Jobs;
- Evidence.

QILT/PRISMS remain under Enrichment & Insights; Course factual/context completeness and Layer 4 Review remain under Quality & Review.

## Supabase implementation references

Source/configuration migrations:

- `20260823102443_m2_1_layer2_platform_foundation`
- `20260823102619_m2_1_layer2_execution_traceability_hardening`
- `20260823103650_m2_1_layer2_config_version_governance_hardening`
- `20260823104038_m2_1_layer2_profile_fk_index_hardening`
- `20260823104311_m2_1_layer2_config_read_scale_hardening`

Provider/runtime migrations:

- `20260823105722_m2_1_layer2_acquisition_provider_registry`
- `20260823105735_m2_1_layer2_provider_admin_read_dispatch`
- `20260823105757_m2_1_layer2_provider_runtime_contract`
- `20260823110522_m2_1_layer2_provider_default_routing`
- `20260823111021_m2_1_layer2_provider_secret_config_hardening`
- provider catalogue expansion for ScraperAPI / Firecrawl / ZenRows / Custom gateway.

Edge Functions:

- `layer2-config-control` — JWT protected;
- `layer2-provider-control` — JWT protected;
- `layer2-acquire` — JWT protected, source-bound acquisition/fallback/private Evidence;
- `layer2-extract` — JWT protected, provider-compatible extraction-input normalisation.

## Security / UAT state

### PASS — current database/API/security foundation

- provider tables are RLS-enabled and not directly granted to `anon`/`authenticated`;
- privileged provider mutation/runtime functions are service-role only;
- provider secrets are absent from browser projection and kept in Vault;
- secret-like provider configuration keys are rejected/sanitised;
- source-bound URL validation prevents arbitrary acquisition proxy use;
- provider-attempt/profile-version provenance is retained;
- extraction-blocked fallback semantics are implemented;
- provider-normalisation worker writes only governed private Evidence/attempt state;
- M1 canonical/Search baseline remains unchanged.

### BLOCKED / outstanding acceptance

- SHA-bound deployed desktop/mobile browser evidence remains outstanding;
- live third-party provider trials require real credentials entered through the Vault-backed Admin control;
- country completeness benchmark cohort must be executed and measured;
- Scholarship acquisition/extraction bounded UAT must be completed;
- QILT/PRISMS Course-context projection UAT must confirm scope labels/grain preservation;
- final M2.1 acceptance must re-confirm M1 regression and documentation pointers.

No vendor success may be claimed without its real configured credential and bounded UAT.

## Current documentation

- `docs/coursefinder-m2-1-layer1-4-architecture-contract-v1.0.md`;
- `docs/coursefinder-database-architecture-v2.10.42.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.14.md`;
- `docs/coursefinder-admin-navigation-information-architecture-v1.1.md`;
- `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- `docs/coursefinder-user-guide-v2.2.md`;
- `docs/coursefinder-pim-admin-guide-v1.17.md`;
- `docs/coursefinder-operations-runbook-v1.2.md`;
- `docs/coursefinder-layer2-provider-adapter-contract-v1.0.md`;
- `docs/coursefinder-m2-1-layer2-platform-replanned-prompt-v2.0.md`;
- `docs/uat/coursefinder-m2-1-layer2-platform-technical-acceptance-2026-08-23.md`.

Running Build and Master Project Plan remain unchanged until the M2.1 gate genuinely advances; do not mark acceptance from documentation alone.

## Rollback

1. Disable provider routes before provider removal.
2. Disable/remove provider credentials from Vault through the authorised control path.
3. Revert provider/runtime/UI changes only after dependency review.
4. Remove provider attempts/Evidence only when explicitly identified and not referenced downstream.
5. Never rewrite the frozen M1 canonical/Search baseline during rollback.

## Decision / status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 23 Aug 2026 20:21 AEST | PROPOSED | M2.1 Layer 2 platform initiated against frozen M1 baseline. |
| 23 Aug 2026 ~21:00 AEST | SCOPE CORRECTION | Multi-provider acquisition, Vault credentials, routing/fallback and Provider Attempt Evidence confirmed as core M2.1. |
| 23 Aug 2026 ~21:10 AEST | IMPLEMENTED | Source/provider registry/runtime/Admin deployed; database/API/security UAT PASS. |
| 23 Aug 2026 ~21:20 AEST | BLOCKED | Deployed desktop/mobile SHA-bound browser evidence unavailable. |
| 23 Aug 2026 ~21:37 AEST | IMPLEMENTED / BLOCKED | Provider catalogue expanded and provider-normalisation worker deployed; live vendor credentials/browser evidence outstanding. |
| 23 Aug 2026 22:15 AEST | SCOPE REBASELINE | M2.1 acceptance expanded to country Course completeness/provider benchmarking, Scholarship extraction, QILT/PRISMS Course decision context, Layer 3 Evidence-only hand-off and terminal Layer 4 model. |

## Closure

**Final status:** **BLOCKED — deployed browser + live provider/completeness trial evidence outstanding**  
**Closed at:** N/A  
**Outcome:** Core M2.1 source-profile, multi-provider acquisition and provider-compatible extraction platform is implemented and database/API/security-tested. M2.1 now remains open until the clarified country-completeness/provider-trial/Scholarship/context/browser acceptance evidence is completed.