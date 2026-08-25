# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** CLOSED / PASS  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Updated:** 25 August 2026 11:24 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream

## Authority boundary

CourseFinder remains an international-student Course and related-data aggregation, discovery and comparison platform.

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Layer 4 is terminal. There is no Layer 5.

Layer 2 acquisition is limited to **Course enrichment** and **Scholarship enrichment**. QILT and PRISMS remain Layer 1 contextual datasets and are not routed through paid Layer 2 providers.

## Operational model

`Execution Policy → Run Batch → Run Item → Job → Provider Attempt → Native Evidence → Normalised Evidence → deterministic extraction → governed candidate apply → factual completeness → L3 required only for unresolved domains`.

Layer 2 never sends directly to Layer 4.

## Acquisition providers

Current configured/tested methods:

| Provider | Credential | Current role |
|---|---|---|
| Direct HTTP | none | first route where sufficient |
| Scrape.do | configured / free tier | rendered fallback / benchmark |
| Firecrawl | configured / free tier | rich HTML/Markdown/visual Evidence escalation |
| ZenRows | configured / free tier | rendered/proxy fallback / benchmark |
| ScraperAPI | not configured | catalogue option only |
| Custom gateway | disabled | future governed adapter |

Credentials remain Vault-only/write-only. Free-tier cash cost is recorded separately from finite vendor credits/units.

## Provider benchmark

Initial 5 RMIT + 5 UQ × 4-method benchmark proved:

- Direct HTTP and Firecrawl 10/10 acquisition success;
- Scrape.do/ZenRows initial parallel failures were predominantly 429 throttles and representative sequential retries passed;
- all successful provider responses contained target Course identity plus fee/English/intake markers;
- Firecrawl can materially improve deterministic resolution on some UQ cases because its richer Evidence resolved an ambiguous fee that Direct/Scrape.do/ZenRows did not;
- provider choice therefore remains outcome-based, not HTTP-status based.

## Runtime v2 / Evidence

Live v2 chain is proven:

`layer2-acquire-v2 → private Native Evidence → layer2-extract-v2 → Normalised Evidence → layer2-course-fact-extract-v2.4`.

Every successful v2 acquisition records Supabase Edge runtime platform/region/execution/deployment, egress classification, Provider Attempt, Source Profile Version, SHA-256 and versioned Evidence lineage.

Cloudflare serves the Admin application but does not perform Direct HTTP acquisition. Direct acquisition egress originates from Supabase Edge and is not guaranteed static.

Evidence remains in the private Supabase Storage bucket `evidence`, using:

`layer2/v2/{country}/{domain}/{profile}/{YYYY}/{MM}/{DD}/{job}/{attempt}/{kind}.{ext}`.

Minimum normal retention horizon is 365 days. It is not an automatic destructive-delete deadline for referenced/held Evidence.

## Federation University validation

Federation University Australia (`CRICOS 00103D`) is a governed Course enrichment source: `au-federation-course-detail`.

Two consecutive five-Course cohorts were completed through the real retained-Evidence/canonical apply path.

**Result: average canonical factual completeness increased from 37.5% to 92.5% (+55 percentage points).**

Five of ten Courses reached 100%. Four reached 87.5%. Science Honours reached 75% because Provider-current international tuition and English remain unresolved.

Exact UAT/cross-check record: `docs/uat/coursefinder-m2-1-federation-completeness-uat-2026-08-24.md`.

### Fee safety

Federation pages include domestic CSP/student-contribution/Band values alongside international material. `layer2-course-fact-extract-v2.3+` rejects CSP/Commonwealth/domestic/Band and low-confidence fee candidates.

Accepted Provider-current tuition examples include Community & Human Services AUD 37,800; Physiotherapy AUD 40,500; Business (Accounting) AUD 39,600; IT (Cybersecurity) AUD 41,400; Environmental Science AUD 38,900.

Arts, Science Honours, Biomedical Science, Criminology and Education Primary remain deliberately incomplete for Provider-current tuition where Evidence was not sufficiently trustworthy.

### Description provenance

Extractor v2.4 uses only the identity-matched first-party HTML meta-description for the Course description candidate. The first provenance attempt incorrectly targeted taxonomy-specific `catalogue.course_field_observations`; failed transactions rolled back with no partial writes.

Corrected apply contract uses empty-only `catalogue.courses.description`, PIM attribute `course_description`, `pim.attribute_values` with source/evidence lineage, no overwrite of an existing description and no Search/publication mutation.

Final UAT: **10/10 descriptions present and 10/10 PIM provenance rows present.**

## Candidate apply contract

`public.layer2_apply_course_candidate(candidate_id, apply)` provides the deterministic service-only apply stage for validated Layer 2 Course candidates. It preserves exact Provider/Course CRICOS identity and Evidence, applies only supported safe Course-Facts domains, excludes unsafe tuition and does not mutate Search or Publication.

## Scholarship UAT

Study Australia Scholarship flow is proven beyond listing acquisition:

`listing Evidence → deterministic detail URL discovery → retained detail Evidence → normalisation → deterministic Scholarship detail candidate`.

RGIT Scholarship for Continuing Students was correctly treated as a detail entity rather than collapsing a listing/search page into a fake Scholarship record. Canonical Scholarship mutation remains separately governed.

## Layer 3 fall-out

Federation trial current domain fall-out:

- 5/10 Courses have at least one unresolved domain;
- unresolved cases are predominantly Provider-current international tuition;
- Science Honours also lacks a deterministic English requirement;
- Layer 4 current fall-out: 0/10.

Completed facts remain canonical and evidence-backed while unresolved domains remain `not_yet_enriched`.

## Admin UX

Visible Layer 2 Platform version is **v1.4**. The accepted M2.1 primary management navigation is `Data Enrichment → Layer 2 Operations / Evidence`, with Source configuration, Acquisition Providers, Trials and Jobs available through progressive drill-down. QILT/PRISMS remain under Insights; Completeness/Layer 4 Review remain under Quality & Review.

The broader M2 consolidated target now matures Layer 1, Layer 2 and Layer 3 as first-class operational workspaces under `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`; that later target does not invalidate the M2.1 browser acceptance.

## Security / ACL

PASS for the M2.1 backend/browser foundation:

- private Layer 2 schemas are not opened to browser PostgREST;
- Edge orchestration uses governed RPC/service boundaries;
- browser direct table access remains revoked;
- provider credentials remain Vault-only;
- source-bound acquisition and governed provider-route enforcement remain active;
- identity mismatch contributes zero completeness uplift;
- Search/publication are not implicitly authorised by Layer 2 apply.

A 25 August Security Advisor review separately flags `public.layer2_ops_policy_update(...)` because it is `SECURITY DEFINER` and executable by `authenticated`. The function verifies `p_actor = auth.uid()` and requires server-side role rank >= 5 before mutation, so no privilege bypass was demonstrated during this closure review. It is explicitly carried into M2.2 Production hardening for independent threat-model/grant/RPC review rather than ignored.

## M1 regression

Post-Federation UAT PASS:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical unpublished Courses: **43,461**.

Frozen M1 publication/Search baseline is unchanged.

## Final deployed browser acceptance

The only remaining blocker from 24 August is now cleared.

Accepted deployed evidence:

- Pilot SHA: `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`;
- GitHub Actions run: `32795496640` — SUCCESS;
- desktop job `97645884152` — PASS;
- mobile job `97645884483` — PASS;
- desktop evidence artifact `9544813710`, digest `sha256:663e5f6c9a2c8f43f8ac5196399104e0c0bc9a2e08560738d657489f60bfba34`;
- mobile evidence artifact `9544904988`, digest `sha256:5a4ff270f8abfd233b7fec67d9a516eefd5111b636899b30bbfe95376d85a433`.

The run passed the governed deployed desktop/mobile acceptance after the Direct HTTP provider-key assertion was corrected to accept the stable deployed provider key. Evidence artifacts are retained by GitHub Actions according to repository retention.

## Acceptance decision

M2.1 is now accepted for:

- secure/versioned Source Profiles and provider routes;
- Vault-backed configured Scrape.do, Firecrawl and ZenRows;
- retained Native/Normalised Evidence lineage;
- provider benchmarking and throttle learning;
- Direct HTTP + paid-provider retained-Evidence execution;
- deterministic Course extraction and safe candidate apply;
- real Course completeness uplift;
- fee/identity safety guards;
- Scholarship listing→detail extraction proof;
- measured Layer 2→Layer 3 fall-out;
- management-oriented Layer 2 Operations UI;
- deployed authenticated desktop/mobile UAT;
- M1 regression protection.

Layer 2 is therefore an accepted deterministic platform capability, not an experimental feature. Provider trials remain bounded qualification/benchmark tools.

## Rollback

- disable/pause affected Layer 2 Source Profile/Execution Policy;
- retain rollback worker versions where available;
- reverse only candidate-applied Layer 2 facts by source/evidence lineage if a source qualification is withdrawn;
- do not alter frozen M1 Search/publication state.

## Closure

**Final status:** CLOSED / PASS.  
**Closed at:** 25 August 2026 11:24 AEST (+10:00).  
**Next gate:** M2.2 — SECURITY-PROD-FOUNDATION under `CF-CHG-20260825-031` / subsequent implementation Change Control.
