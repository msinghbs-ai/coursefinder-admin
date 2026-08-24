# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — DEPLOYED AUTHENTICATED DESKTOP/MOBILE ADMIN UAT OUTSTANDING  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Updated:** 24 August 2026 12:42 AEST (+10:00)  
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

Every successful v2 acquisition records:

- Supabase Edge runtime platform;
- region;
- execution ID;
- deployment ID;
- dynamic/non-static Supabase egress classification;
- Provider Attempt;
- Source Profile Version;
- SHA-256;
- versioned Evidence lineage.

Cloudflare serves the Admin application but does not perform Direct HTTP acquisition. Direct acquisition egress originates from Supabase Edge and is not guaranteed static.

Evidence remains in the private Supabase Storage bucket `evidence`, using the v2 hierarchy:

`layer2/v2/{country}/{domain}/{profile}/{YYYY}/{MM}/{DD}/{job}/{attempt}/{kind}.{ext}`.

Minimum normal retention horizon is 365 days. It is not an automatic destructive-delete deadline for referenced/held Evidence.

## Federation University validation

Federation University Australia (`CRICOS 00103D`) is now a governed Course enrichment source: `au-federation-course-detail`.

Two consecutive five-Course cohorts were completed through the real retained-Evidence/canonical apply path.

**Result: average canonical factual completeness increased from 37.5% to 92.5% (+55 percentage points).**

Five of ten Courses reached 100%. Four reached 87.5%. Science Honours reached 75% because Provider-current international tuition and English remain unresolved.

Exact UAT/cross-check record:

`docs/uat/coursefinder-m2-1-federation-completeness-uat-2026-08-24.md`.

### Fee safety

Federation pages include domestic CSP/student-contribution/Band values alongside international material. `layer2-course-fact-extract-v2.3+` rejects CSP/Commonwealth/domestic/Band and low-confidence fee candidates.

Accepted Provider-current tuition examples include:

- Community & Human Services — AUD 37,800;
- Physiotherapy — AUD 40,500;
- Business (Accounting) — AUD 39,600;
- IT (Cybersecurity) — AUD 41,400;
- Environmental Science — AUD 38,900.

Arts, Science Honours, Biomedical Science, Criminology and Education Primary remain deliberately incomplete for Provider-current tuition. Firecrawl escalation did not make those fee candidates sufficiently trustworthy.

### Description provenance

Extractor v2.4 now uses only the identity-matched first-party HTML meta-description for the Course description candidate.

The first provenance attempt incorrectly targeted `catalogue.course_field_observations`; UAT proved that table is field-of-study taxonomy specific. Failed transactions rolled back with no partial writes.

Corrected apply contract uses:

- empty-only `catalogue.courses.description` update;
- PIM attribute `course_description`;
- `pim.attribute_values` with source/evidence lineage;
- no overwrite of an existing description;
- Search/publication mutation false.

Final UAT: **10/10 descriptions present and 10/10 PIM provenance rows present.**

## Candidate apply contract

`public.layer2_apply_course_candidate(candidate_id, apply)` provides the deterministic service-only apply stage for validated Layer 2 Course candidates.

It preserves exact Provider/Course CRICOS identity and Evidence, applies only supported safe Course-Facts domains, excludes unsafe tuition and does not mutate Search or Publication.

## Scholarship UAT

Study Australia Scholarship flow is now proven beyond listing acquisition:

`listing Evidence → deterministic detail URL discovery → retained detail Evidence → normalisation → deterministic Scholarship detail candidate`.

RGIT Scholarship for Continuing Students was correctly treated as a detail entity rather than collapsing the listing/search page into a fake Scholarship record. Canonical Scholarship mutation remains separately governed.

## Layer 3 fall-out

Federation trial current domain fall-out:

- 5/10 Courses have at least one unresolved domain;
- unresolved cases are predominantly Provider-current international tuition;
- Science Honours also lacks a deterministic English requirement;
- Layer 4 current fall-out: 0/10.

Completed facts remain canonical and evidence-backed while unresolved domains remain `not_yet_enriched`.

## Admin UX

Visible Layer 2 Platform version remains **v1.4**.

Primary operational navigation is intentionally simplified to:

`Data Enrichment → Layer 2 Operations / Evidence`.

Source configuration, Acquisition Providers, Trials and Jobs are drill-down controls rather than separate routine management destinations. QILT/PRISMS remain under Insights; Completeness and terminal Review Queue remain under Quality & Review.

## Security / ACL

PASS for current backend foundation:

- private Layer 2 schemas are not opened to browser PostgREST;
- Edge orchestration uses narrow service-only RPC boundaries;
- browser direct table access remains revoked;
- provider credentials remain Vault-only;
- source-bound acquisition and governed provider-route enforcement remain active;
- identity mismatch contributes zero completeness uplift;
- Search/publication are not implicitly authorised by Layer 2 apply.

## M1 regression

Post-Federation UAT PASS:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical unpublished Courses: **43,461**.

Frozen M1 publication/Search baseline is unchanged.

## Current acceptance state

The following M2.1 evidence is now PASS:

- secure/versioned Source Profiles and provider routes;
- Vault-backed configured Scrape.do, Firecrawl and ZenRows;
- retained Native/Normalised Evidence lineage;
- provider benchmarking and throttle learning;
- Direct HTTP + paid-provider retained-Evidence execution;
- deterministic Course extraction and safe candidate apply;
- real Course completeness uplift across RMIT/UQ/Federation learning cases;
- fee/identity safety guards;
- Scholarship listing→detail extraction proof;
- measured Layer 2→Layer 3 fall-out;
- M1 regression.

## Remaining blocker

**M2.1 remains BLOCKED only for the final deployed authenticated browser acceptance:**

1. desktop Layer 2 Operations v1.4 UAT;
2. mobile Layer 2 Operations v1.4 UAT;
3. SHA/run/artifact evidence showing the deployed menu/workspace exposes the simplified management model, Federation enrichment source and safe drill-down behaviour.

Automatic catalogue-wide scheduling remains disabled until that browser gate is accepted; stored execution policies and bounded manual/service trials remain authorised.

## Rollback

- disable/pause affected Layer 2 Source Profile/Execution Policy;
- keep v1 workers as rollback where retained;
- reverse only candidate-applied Layer 2 facts by source/evidence lineage if a source qualification is withdrawn;
- do not alter frozen M1 Search/publication state.

## Closure

**Final status:** BLOCKED — final deployed authenticated desktop/mobile Admin v1.4 browser UAT outstanding.  
**Closed at:** N/A
