# CourseFinder Running Build v2.64

**Status:** **M1-SEARCH-ENRICHMENT CLOSED / PASS**  
**Date:** 23 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.63.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`

## Accepted release position

Current accepted Admin runtime remains:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0`

No visible PIM/Admin release is claimed by this Search-only change.

Accepted Pilot source authority:

`msinghbs-ai/Coursefinder-Pilot@23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`

PR #27 closes the final automated native `course-v3` full-refresh UAT and mirrors the final live migration ledger. It changes no publication or vector-admission decision.

## M1-SEARCH-ENRICHMENT — accepted

The AU+NZ Search projection remains **33,105 Course documents** under `course-v3`.

Accepted Course-Fact Search coverage:

- CRICOS regulatory tuition: 26,326 present / 131 zero / 191 source-null / 6,457 not-applicable;
- Provider-current tuition: 10 Courses;
- comparable annual/indicative-annual Provider tuition: 9 Courses;
- official Course URL: 10 Courses;
- Intake: 10 Courses / 18 observations;
- English requirements: 10 Courses / 32 observations;
- admitted Scholarships: 0 because current canonical Scholarships remain unpublished;
- QILT/PRISMS Course Search signals: excluded/not admitted.

Only qualified/UAT-passed RMIT and UQ first-party sources are admitted. Deferred QUT remains outside Search.

## Fee semantics

CRICOS registered tuition and Provider-current tuition are separate Search concepts. `has_fee` is retained only as a legacy compatibility flag for Search-admitted Provider-current tuition presence. `total_indicative` Provider tuition remains structured/display data and is not converted into an annual comparison scalar.

## Determinism

Enrichment stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Final automated native full-refresh APPLY/replay:

- generation **13**;
- base hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- combined projection hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- immediate replay base: **0 changed / 33,105 unchanged / 0 new / 0 removed**;
- immediate replay enrichment: **0 changed / 33,105 unchanged**;
- `search.projection_state` records `course-v3` with explicit domain/source enrichment admission metadata.

Controlled invalidation earlier detected exactly 1 changed row and repaired it. Exactly 10 semantic hashes changed for 10 genuine searchable-enrichment changes; 33,095 hashes remained exact.

## Search mode position

FTS remains the accepted production Search path. Representative full-projection execution: `nursing` ~11 ms; `IELTS` ~3.6 ms.

M1-SEARCH-VECTOR remains rejected/not admitted. Vector state remains 0 embeddings / 0 active jobs / 0 query-cache rows. Hybrid without a corpus uses FTS fallback; vector-only has no accepted candidates.

## Consumer contracts

Website receives versioned `api.website_course_search_v2`; Website v1 remains intact. The v2 DTO keeps regulatory and Provider-current tuition separate and adds governed filters/sorts for admitted enrichment.

All 33,105 Search documents remain unpublished, so the change does not broaden Website visibility. Zoho Consumer Contract remains v1.3 with no DTO expansion.

## Preserved programme baselines

- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ: 1,955 Providers / 33,105 Courses;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4 canonical;
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- Search admission remains independent from publication;
- canonical identity is unchanged.

## Governance

`CF-CHG-20260823-023` — **CLOSED / PASS**. Technical acceptance: `docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`.

Known Supabase leaked-password protection remains separately governed under `CF-CHG-20260823-022`.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**M1-SEARCH-ENRICHMENT: CLOSED / PASS.**  
**M1-SEARCH-VECTOR: REJECTED / NOT ADMITTED.**
