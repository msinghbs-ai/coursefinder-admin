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

Accepted Pilot implementation:

`msinghbs-ai/Coursefinder-Pilot@69ac752193b9a79cc2ba3809ebd68aabbbb97582`

## M1-SEARCH-ENRICHMENT — accepted

The AU+NZ Search projection remains **33,105 Course documents** and advances to `course-v3`.

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

CRICOS registered tuition and Provider-current tuition are separate Search concepts.

`has_fee` is retained only as a legacy compatibility flag for **Search-admitted Provider-current tuition presence**. CRICOS registered tuition uses dedicated regulatory fields and is never presented as Provider-current/annual tuition.

`total_indicative` Provider tuition is retained in structured options but is not converted into an annual comparison scalar.

## Determinism

Accepted stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Replay result:

- changed 0;
- unchanged 33,105.

Controlled invalidation detected exactly 1 changed row and repaired it on APPLY.

Semantic-content invalidation is scoped correctly:

- 10 genuine semantic-content changes;
- 10 semantic hashes changed;
- 33,095 hashes retained exactly.

## Search mode position

FTS remains the accepted production Search path.

Representative full-projection execution:

- `nursing` ~11 ms;
- `IELTS` ~3.6 ms.

M1-SEARCH-VECTOR remains rejected/not admitted. Current vector state remains 0 embeddings / 0 active jobs / 0 query-cache rows. Hybrid without a corpus uses FTS fallback; vector-only has no accepted candidates.

## Consumer contracts

Website receives versioned `api.website_course_search_v2`; Website v1 remains intact. The v2 DTO keeps regulatory and Provider-current tuition separate and adds governed filters/sorts for admitted enrichment.

All 33,105 Search documents remain unpublished, so the change does not broaden Website visibility.

Zoho Consumer Contract remains v1.3 with no DTO expansion.

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

`CF-CHG-20260823-023` — **CLOSED / PASS**.

Technical acceptance:

`docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`

Known Supabase leaked-password protection remains separately governed under `CF-CHG-20260823-022` and is not altered by this release.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**M1-SEARCH-ENRICHMENT: CLOSED / PASS.**  
**M1-SEARCH-VECTOR: REJECTED / NOT ADMITTED.**
