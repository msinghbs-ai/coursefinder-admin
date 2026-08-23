# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — LIVE PROVIDER / COURSE-DISCOVERY / DEPLOYED BROWSER EVIDENCE OUTSTANDING  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Product and authority boundary

CourseFinder is an **international-student Course and related-data aggregation, discovery and comparison platform**. It is not an application/admissions/offer-letter/visa workflow.

The final enrichment authority model is:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 is terminal. There is **no Layer 5**. Completeness/readiness, Search Projection/Visibility and Publication are downstream product states, not authority layers.

Avoid **Search Admission** in new work because it is ambiguous with university admissions. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility and Publication.

## Required operating sequence

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Native Evidence → Normalised Extraction Evidence → Deterministic Candidate → Layer 3 if required → Layer 4 if still unresolved → governed canonical/readiness result → Search Projection/Visibility → Publication`

No acquisition or extraction worker directly authorises canonical mutation, Search visibility or Publication.

## Implemented Layer 2 platform

### Source Profiles

- `pipeline.layer2_source_profiles`;
- immutable `pipeline.layer2_source_profile_versions` with validation/hash/Change Control/UAT references;
- exact profile-version references on Jobs and Evidence;
- enabled/paused/validity execution gate;
- source-bound URL allowlist;
- source authority remains independent from acquisition vendor.

### Acquisition Providers

Provider credentials are write-only from Admin and stored in Supabase Vault. Browser reads expose `credential_configured`, never the secret/Vault identifier.

| Priority | Provider | Mechanism | Auth | Response adapter |
|---:|---|---|---|---|
| 10 | Direct HTTP | governed source GET | none | passthrough |
| 20 | Scrape.do | scraper/render API | query `token` | passthrough / `scrape_do_json` |
| 30 | ScraperAPI | scraper/render API | query `api_key` | passthrough |
| 40 | Firecrawl | browser/API scrape | bearer | `firecrawl_v2` |
| 50 | ZenRows | JS render/premium proxy API | query `apikey` | passthrough |
| 90 | Custom gateway | configurable API gateway | configurable | `generic` |

RMIT, UQ and Study Australia web profiles currently route:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

QILT and PRISMS structured-file profiles remain Direct HTTP by default.

### Runtime / Evidence

- `layer2-config-control` — JWT protected;
- `layer2-provider-control` — JWT protected;
- `layer2-acquire` — JWT protected, source-bound provider acquisition/fallback/private Evidence;
- `layer2-extract` — JWT protected, provider-native → common `layer2_extraction_input` Evidence;
- `layer2-trial-control` — JWT protected, rank >=4 country/provider completeness trial control;
- `layer2-course-fact-extract` — JWT protected deterministic Course candidate extraction from normalised Evidence;
- `layer2-scholarship-extract` — JWT protected deterministic Scholarship candidate extraction from normalised Evidence.

Native provider Evidence is retained. Normalised Evidence is derived and linked to the Provider Attempt/source-profile version. Provider screenshot policy does not fabricate screenshots; the provider must actually return/materialise visual Evidence.

## Country-based Course completeness trial foundation

M2.1 now proves the platform through real country/provider Course cohorts rather than configuration CRUD alone.

Live model:

- `pipeline.layer2_country_completeness_profiles`;
- `pipeline.layer2_completeness_trials`;
- `pipeline.layer2_completeness_trial_courses`;
- `pipeline.layer2_provider_trial_results`;
- `pipeline.layer2_course_factual_snapshot(uuid)`;
- `pipeline.layer2_course_decision_context_snapshot(uuid)`;
- service-only trial create/result/finalise RPCs;
- provider comparison summary based on outcome/cost/escalation.

### Country profiles

AU and NZ international-student Course profiles are seeded independently. NZ explicitly must not inherit CRICOS semantics.

AU factual domains currently measured include identity/regulatory status, official Course URL, Provider-current international tuition, intakes, English requirements, Campus/delivery, description and verification/freshness.

Decision context includes Scholarships, QILT Provider/study-area context and PRISMS Provider/state context where the actual source grain supports it.

### Sampling

Ten Courses is a learning-batch default, not a production limit.

For a 10-Course cohort the sampler now selects:

- 2 known-coverage controls; and
- 8 gap-learning Courses.

An initial gap-only sampler was superseded; its two trial rows are retained as cancelled/auditable rather than deleted.

### Active AU cohorts

**RMIT University**  
Trial `26086e95-a387-44a7-9a50-d566e29076bb` — 10 Courses = 2 controls + 8 gap-learning.

**The University of Queensland**  
Trial `3148ca84-f4f9-440f-9bb3-af2e54d383fa` — 10 Courses = 2 controls + 8 gap-learning.

The control Courses have current Provider tuition, official Course link, intake and English evidence already present. The gap cohorts are largely missing those domains plus description while retaining stable identity, Campus/delivery and regulatory verification.

This is intentionally useful for measuring the completion delta of Layer 2 rather than merely re-scraping already-complete Courses.

## Provider evaluation contract

`pipeline.layer2_provider_trial_results` records:

- acquisition success;
- gatekeeping bypass;
- JavaScript rendering;
- Evidence quality;
- deterministic extraction success;
- verified correctness/ambiguity;
- latency;
- request count;
- vendor cost;
- targeted/resolved fields;
- Layer 3 escalation;
- Layer 4 escalation;
- blocker/extra metrics.

The aggregate provider summary calculates acquisition/deterministic success rates, correctness rate, resolution rate, vendor cost, cost per resolved field, average latency/Evidence quality and Layer 3/4 escalation rates.

Provider selection must be based on evidence-backed completion/correctness/reliability/cost. HTTP 200 or cheapest per-request price is not sufficient.

## Course-fact extraction guard

`layer2-course-fact-extract` consumes only `layer2_extraction_input` Evidence plus a selected canonical Course identity.

It deterministically attempts:

- official Course URL;
- Provider-current international tuition candidate;
- intake month candidates;
- IELTS/PTE/TOEFL candidates;
- description candidate;
- page-title/regulatory-code identity validation.

It writes a `pipeline.course_fact_source_records` candidate only. It never writes canonical Course/fee/intake/English rows.

A critical rule is now explicit: **missing enrichment does not mean a similar current Provider page is the same Course.** If the source page title/regulatory code does not sufficiently match the selected Course, the record is marked `identity_mismatch` / Layer 3 required rather than silently attaching the new page.

This protects historical/retired/superseded regulatory identities during current first-party enrichment.

## Scholarship extraction

`layer2-scholarship-extract` consumes only normalised Layer 2 Evidence and deterministically attempts Scholarship title, award amount/percentage, closing-date text, study-level text and eligibility narrative.

It writes `pipeline.scholarship_source_records` candidates through the existing governed service contract and never applies canonical Scholarship mutation.

Sparse Evidence is marked `layer3_required=true`; it does not jump directly to Layer 4. `Not found by scraper` must not become `no scholarship`.

The previously existing `scholarships-au-etl` remains a historical/specialised worker and does not replace the new provider-neutral Evidence contract.

## QILT / PRISMS decision context

`public.course_decision_context(course_id)` now exposes contextual rows alongside a Course while preserving their real grain.

For representative active AU trial Courses:

- current QILT Provider/provider-study-area observations are available;
- exact Provider-linked PRISMS observations may be absent for the current mapping;
- state/subdivision PRISMS context is available where the Course Campus state matches the observation grain.

Each contextual row explicitly carries `grain` and `course_grain=false`. Provider-level QILT must never be relabelled as a Course outcome, and PRISMS state/provider/cohort observations must never be represented as the Course's own enrolments.

This supports counsellor/student comparison of **Course + Provider/university + Campus/state** while preserving evidence semantics.

## Layer 3 / Layer 4 hand-off

Layer 3 consumes Layer 2 Evidence and candidates. It does not independently scrape and receives no scraper/Vault credentials.

If Layer 3 needs better Evidence it requests another governed Layer 2 capability/provider attempt.

Only genuinely unresolved/conflicting/consequential records reach Layer 4 with the full Evidence/attempt/candidate package. Layer 4 is terminal.

## Admin information architecture

Related `CF-CHG-20260823-030` makes Data Acquisition a coherent main-navigation group:

- Pipeline Control;
- Source Registry;
- Layer 2 Source Config;
- Acquisition Providers;
- Jobs;
- Evidence.

QILT/PRISMS remain Enrichment & Insights. Completeness and terminal Review Queue remain Quality & Review.

## Security / ACL UAT

PASS:

- trial tables are RLS enabled;
- `anon` and `authenticated` have no direct SELECT on trial tables;
- service-only trial mutation/metric functions are not executable by browser roles;
- `service_role` has explicit trusted CRUD access required by the orchestration Edge function;
- all newly added M2.1 control/extraction Edge Functions are JWT protected;
- acquisition targets remain source-bound;
- provider credentials remain Vault-only/write-only;
- domain extractors create candidates/Evidence only and do not authorise canonical/Search writes.

## M1 regression

Current post-change live state remains:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

Two current AU completeness trials contain 20 active trial Courses. Trial/candidate data is outside canonical/Search state.

## Current blockers / next execution

M2.1 remains **BLOCKED**, not PASS.

Outstanding evidence:

1. Real Scrape.do/ScraperAPI/Firecrawl/ZenRows credentials are still unconfigured. No vendor success/cost claim may be made until entered through Vault-backed Admin and bounded UAT runs.
2. Live database currently has no `layer2_extraction_input` Evidence. A bounded Provider Attempt must be acquired then run through `layer2-extract` before Course/Scholarship domain extractor runtime UAT.
3. The eight gap Courses per RMIT/UQ cohort lack official Course URLs. The next execution step is governed first-party Course discovery; it must distinguish current match vs retired/superseded/no-current-match rather than forcing a similar page.
4. Scholarship provider-neutral extraction must be exercised against real normalised Evidence.
5. Provider result/cost rows must be populated and compared before a preferred provider strategy is accepted.
6. SHA-bound deployed desktop/mobile browser acceptance evidence remains outstanding.

Technical baseline evidence: `docs/uat/coursefinder-m2-1-country-completeness-provider-trial-2026-08-23.md` and `docs/uat/coursefinder-m2-1-layer2-platform-technical-acceptance-2026-08-23.md`.

## Implementation references added in this increment

Live migrations:

- `m2_1_country_completeness_provider_trial_foundation`;
- `m2_1_completeness_trial_control_sampling`;
- `m2_1_course_decision_context_projection`;
- `m2_1_course_decision_context_current_status_fix`;
- `m2_1_course_decision_context_state_limit`;
- `m2_1_completeness_trial_service_acl`;
- `m2_1_provider_trial_metrics_contract`.

Pilot mirrors include:

- `supabase/migrations/20260823123300_m2_1_country_completeness_provider_trial_foundation.sql`;
- `supabase/migrations/20260823123600_m2_1_completeness_trial_control_sampling.sql`;
- `supabase/migrations/20260823124400_m2_1_course_decision_context_projection.sql`;
- `supabase/migrations/20260823124600_m2_1_completeness_trial_service_acl.sql`;
- `supabase/migrations/20260823124800_m2_1_provider_trial_metrics_contract.sql`;
- `supabase/functions/layer2-trial-control/index.ts`;
- `supabase/functions/layer2-course-fact-extract/index.ts`;
- `supabase/functions/layer2-scholarship-extract/index.ts`.

## Maintained documents

- `docs/coursefinder-m2-1-layer1-4-architecture-contract-v1.0.md`;
- `docs/coursefinder-database-architecture-v2.10.42.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.14.md`;
- `docs/coursefinder-admin-navigation-information-architecture-v1.1.md`;
- `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- `docs/coursefinder-user-guide-v2.2.md`;
- `docs/coursefinder-pim-admin-guide-v1.17.md`;
- `docs/coursefinder-operations-runbook-v1.2.md`;
- `docs/coursefinder-layer2-provider-adapter-contract-v1.0.md`;
- `docs/coursefinder-m2-1-layer2-platform-replanned-prompt-v2.0.md`.

Running Build/Master Plan remain intentionally unchanged until the M2.1 acceptance gate genuinely advances.

## Decision history

| Time | State | Decision |
|---|---|---|
| 20:21 | PROPOSED | M2.1 initiated against frozen M1 baseline. |
| ~21:00 | SCOPE CORRECTION | Multi-provider acquisition/Vault/routing/Evidence made core. |
| ~21:10 | IMPLEMENTED | Source/provider foundation and security UAT PASS. |
| ~21:20 | BLOCKED | Deployed browser evidence unavailable. |
| ~21:37 | IMPLEMENTED/BLOCKED | Provider catalogue + normalisation worker deployed. |
| 22:15 | SCOPE REBASELINE | Country completeness, Scholarships, contextual QILT/PRISMS and terminal Layer 4 added to acceptance. |
| 22:35–22:55 | IMPLEMENTED/PARTIAL PASS | AU RMIT/UQ 10-Course cohorts, provider benchmark contract, Course context projection, trial control and Course/Scholarship Evidence-driven extractors deployed; M1 regression remains PASS. |

## Closure

**Final status:** **BLOCKED — live provider/completeness/Scholarship/browser evidence outstanding**  
**Closed at:** N/A
