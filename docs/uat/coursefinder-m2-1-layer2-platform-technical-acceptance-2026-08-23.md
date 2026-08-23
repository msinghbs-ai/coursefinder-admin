# CourseFinder M2.1 Layer 2 Platform — Technical Acceptance

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-029`  
**Gate:** M2.1 — Layer 2 Acquisition, Deterministic Extraction, Completeness Trial & Evidence Foundation  
**Status:** **BLOCKED — browser + live provider/completeness/Scholarship/context evidence outstanding**

## 1. Acceptance statement

The M2.1 core source/provider acquisition platform is implemented at database/API/Edge-control-plane level and mirrored in `msinghbs-ai/Coursefinder-Pilot`. Database/API/security and M1 baseline-regression checks are PASS.

The acceptance scope is now intentionally broader than configuration foundation alone. M2.1 must prove the operating model through representative country-based Course completeness trials, live provider comparison where credentials are available, bounded Scholarship acquisition/extraction and Course-facing QILT/PRISMS contextual semantics, in addition to deployed desktop/mobile browser acceptance.

No external provider success is claimed until its actual API credential is configured through the Vault-backed Admin control and bounded live UAT succeeds.

## 2. Final product / layer boundary

CourseFinder is an international-student Course and related-data aggregation, discovery and comparison platform. It does not perform university application processing, university admissions decisions, offer-letter processing or visa processing.

There are exactly four enrichment authority layers:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 is terminal. There is no Layer 5. Completeness/readiness, Search Projection/Visibility and Publication are downstream product states.

Avoid **Search Admission** in new work; use Search Eligibility/Projection/Visibility or Publication Eligibility as appropriate.

## 3. Implemented Layer 2 model — PASS at foundation level

1. **Source Profile** — authority, discovery/URL scope, parser/mapping semantics, freshness/Evidence policy and immutable version.
2. **Acquisition Provider** — reusable transport/API provider, endpoint, auth mechanism, Vault credential reference, capability and limits.
3. **Source → Provider Route** — provider order, required capabilities, request overrides, Evidence policy and fallback reasons.
4. **Provider Attempt / Native Evidence** — every acquisition attempt is linked to exact Job/profile version/provider and its native Evidence.
5. **Provider-compatible Extraction Input** — `layer2-extract` normalises provider-native responses to one private extraction Evidence contract while preserving native Evidence.

Authority sequence:

`Source Profile → Provider Route → Job → Provider Attempt → Native Evidence → Normalised Extraction Evidence → Deterministic Observation/Candidate → Layer 3 if required → Layer 4 if unresolved → governed canonical/readiness result → Search Projection/Visibility → Publication`.

## 4. Current provider catalogue

| Priority | Provider | API mechanism | Authentication | Response adapter | Credential state |
|---:|---|---|---|---|---|
| 10 | Direct HTTP | direct governed source GET | none | `passthrough` | N/A |
| 20 | Scrape.do | rendered scraper API | query `token` | `passthrough` / `scrape_do_json` | not configured |
| 30 | ScraperAPI | rendered scraper API | query `api_key` | `passthrough` | not configured |
| 40 | Firecrawl | browser/API scrape POST | bearer | `firecrawl_v2` | not configured |
| 50 | ZenRows | JS render + premium proxy API | query `apikey` | `passthrough` | not configured |
| 90 | Custom gateway | configurable API gateway | configurable | `generic` | disabled / not configured |

Provider registry count: **6**. Current route count: **17**.

RMIT, UQ and Study Australia web/search route order is:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

QILT and PRISMS remain Direct HTTP by default for their accepted structured downloadable sources.

## 5. Provider-compatible extraction worker — PASS at contract level

`layer2-extract` is JWT protected and:

- resolves the exact Provider Attempt/provider response adapter/native Evidence;
- downloads private Evidence with trusted runtime credentials;
- normalises text/HTML/structured JSON/visual references;
- creates a private hashed/versioned extraction-input Evidence artifact;
- retains `canonical_mutation_authorised=false`;
- marks usable attempts `normalised`;
- marks no-content cases `extraction_failed/blocked` and requests fallback when policy permits.

This worker is not an LLM. Provider-specific response handling terminates at this Layer 2 boundary.

## 6. Credentials/security — PASS

Verified foundation boundary:

- provider credentials are write-only in Admin and stored in Supabase Vault;
- browser projection exposes credential status only;
- provider mutation/runtime-credential functions remain service-role only;
- provider tables are RLS-enabled with no direct browser table grants;
- secret-like provider JSON keys are rejected/sanitised;
- M2.1 Edge controls/runtimes are JWT protected;
- source-host allowlist prevents arbitrary proxy use;
- provider API keys were not fabricated or embedded in source/profile configuration.

## 7. Evidence / fallback — PASS at contract level

- native provider response is retained as private Evidence;
- Provider Attempt records source-profile version/provider/HTTP/MIME/blocker/metrics/Evidence links;
- derived normalised Evidence retains lineage to native Evidence;
- extraction failure preserves original Evidence and can invoke the next configured provider route;
- screenshot policy does not manufacture screenshots; screenshot/image Evidence requires actual provider output/materialisation.

## 8. Country Course completeness acceptance — OUTSTANDING

M2.1 must execute representative country-based Course completeness trials.

For each selected trial country/university/Provider:

- define/confirm the Country Course Completeness Profile;
- select an initial approximately 10-Course representative learning cohort unless another bounded cohort is justified;
- measure pre-run Course factual completeness and decision-context completeness;
- enrich only missing/stale domains;
- retain native and normalised Evidence;
- measure post-run evidence-backed completion and source correctness;
- record provider attempt count, latency, retries and cost where available;
- expand/re-test/change provider according to measured consistency rather than a fixed 10-Course limit.

Provider evaluation must include **cost per evidence-backed completed Course/domain**, not raw API request cost or HTTP success alone.

## 9. Scholarship acquisition/extraction acceptance — OUTSTANDING

A bounded Scholarship discovery/acquisition/extraction path must be proven through the shared Layer 2 provider/evidence contract.

UAT should verify evidence-backed extraction of appropriate fields such as Scholarship name/URL, Provider, value/basis/currency, eligibility scope, Course/study-level/nationality applicability, international-student eligibility, application/automatic-consideration semantics, dates/intakes and terms.

`not found by scraper` must remain `not_discovered/not_yet_enriched`, not `no scholarship`.

## 10. QILT / PRISMS Course-context acceptance — OUTSTANDING

M2.1 must prove that decision-relevant QILT/PRISMS context can be presented/projected with Courses without changing source grain.

UAT must confirm examples such as:

- QILT Provider context remains labelled Provider-level;
- QILT study-area context remains labelled field/study-area;
- PRISMS Provider/state/sector/cohort context retains its reporting scope and period;
- no Provider/state/cohort metric is persisted or displayed as a false Course-grain fact;
- Course factual completeness and decision-context completeness remain separate concepts.

## 11. Layer 3 / Layer 4 contract acceptance — DEFINED, runtime proof later where applicable

Layer 3 consumes governed Layer 2 Evidence and may request additional Layer 2 Evidence capabilities when existing Evidence is inadequate. It does not independently scrape or receive Vault credentials.

Only unresolved/conflicting/consequential cases reach Layer 4 with the complete Evidence/Provider Attempt/candidate package. Layer 4 is terminal for enrichment authority. There is no Layer 5.

M2.1 must leave these contracts explicit and testable for subsequent Layer 3/4 implementation; it does not need to implement the full future Layer 3 inference engine to prove the Layer 2 foundation.

## 12. Admin navigation acceptance — OUTSTANDING browser evidence

Related `CF-CHG-20260823-030` requires desktop/mobile proof that the main navigation coherently exposes:

- Data Acquisition → Pipeline Control;
- Source Registry;
- Layer 2 Source Config;
- Acquisition Providers;
- Jobs;
- Evidence;
- Enrichment & Insights → QILT/PRISMS;
- Quality & Review → Completeness / Layer 4 Review Queue.

Old floating Pipeline/Layer 2 launchers should not remain the primary navigation path.

## 13. M1 regression — PASS

Latest live post-foundation state remains:

- acquisition providers: **6**;
- provider routes: **17**;
- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

No M2.1 provider/extraction object authorises canonical or Search writes.

## 14. Current documentation baseline

- `docs/coursefinder-m2-1-layer1-4-architecture-contract-v1.0.md`;
- `docs/coursefinder-database-architecture-v2.10.42.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.14.md`;
- `docs/coursefinder-admin-navigation-information-architecture-v1.1.md`;
- `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- `docs/coursefinder-user-guide-v2.2.md`;
- `docs/coursefinder-pim-admin-guide-v1.17.md`;
- `docs/coursefinder-operations-runbook-v1.2.md`;
- `docs/coursefinder-m2-1-layer2-platform-replanned-prompt-v2.0.md`.

## 15. Current blocker evidence

The last observed connected GitHub status surface did not expose the required current SHA-bound deployed desktop/mobile statuses/artifacts. That remains a browser-evidence blocker.

In addition, external-provider live comparisons cannot be claimed until actual provider credentials are configured through the governed Vault-backed Admin control.

Therefore M2.1 remains **BLOCKED**, not PASS.

## 16. Closure requirement

M2.1 may change to `CLOSED / PASS` only after all applicable requirements are evidenced:

- current deployed desktop UAT PASS;
- current deployed mobile UAT PASS;
- SHA/run/artifact evidence retained;
- bounded native/normalised Evidence lineage confirmed;
- real country Course completeness cohort measured;
- provider comparison metrics retained for configured providers;
- bounded Scholarship acquisition/extraction proven;
- QILT/PRISMS Course-context scope/grain UAT proven;
- exact M1 regression re-confirmed;
- Change Control/Register/architecture/design/database/menu/guides/runbook/atlas reconciled;
- Running Build/Master Plan updated only when the gate genuinely advances.
