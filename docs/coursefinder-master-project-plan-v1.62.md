# CourseFinder Master Project Plan v1.62

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — SEARCH ENRICHMENT `course-v3` ACCEPTED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.61.md`  
**Last consolidated:** 23 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Running build:** `docs/coursefinder-running-build-v2.64.md`  
**Pilot-to-Production Plan:** `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`

## Current programme position

- M1-PIM-FINALISATION — **CLOSED / PASS**.
- M1-PIPELINE-OPS (`CF-CHG-20260821-016`) — **CLOSED / PASS**.
- M1-EVIDENCE-UX (`CF-CHG-20260821-017`) — **CLOSED / PASS**.
- M1-DATA-QUALITY-READINESS (`CF-CHG-20260821-018`) — **CLOSED / PASS**.
- M1-UAT-HARNESS (`CF-CHG-20260822-019`) — **CLOSED / PASS**.
- Access Admin v1.0 (`CF-CHG-20260822-020`) — **CLOSED / PASS**.
- Data Quality concurrent/snapshot hardening (`CF-CHG-20260823-021`) — **CLOSED / PASS**.
- Supabase leaked-password protection (`CF-CHG-20260823-022`) — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.
- M1-SEARCH-ENRICHMENT (`CF-CHG-20260823-023`) — **CLOSED / PASS**.
- M1-SEARCH-VECTOR — **REJECTED / NOT ADMITTED**.

Accepted operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

## Current accepted implementation authority

Pilot:

`msinghbs-ai/Coursefinder-Pilot@23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`

PR #27 is the final closure authority for the native deterministic `course-v3` full refresh and its automated APPLY/replay evidence. The Admin visible runtime remains PIM Admin v2.12; this Search-only gate does not claim a new UI release.

## Search projection position

The accepted AU+NZ Search projection is `course-v3` with **33,105 Course documents**. Search admission is both domain-gated and source-gated; canonical relational presence alone does not imply Search readiness.

Accepted first-party Course Facts admission covers qualified RMIT and UQ sources only:

- Provider-current tuition: 10 Courses;
- comparable annual/indicative-annual Provider tuition: 9 Courses;
- official Course URL: 10 Courses;
- Intake: 10 Courses / 18 observations;
- English requirements: 10 Courses / 32 observations.

Deferred QUT remains outside Search admission.

## Fee semantics

CRICOS registered tuition remains a Layer 1 registered-total-course fact and is projected separately from Provider-current tuition. Regulatory fee states remain exactly 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero.

Provider-current tuition retains year/basis/scope. Only annual-compatible basis values enter the comparable annual scalar. `total_indicative` remains structured display data and is not silently annualised.

## Scholarships / QILT / PRISMS

Canonical Scholarships remain 4; none are currently Search-admitted because their publication status remains unpublished. QILT and PRISMS remain excluded from Course-grain Search; no provider/study-area/flow/cohort signal is fabricated at Course grain.

## Search-mode decision

FTS remains the accepted Search mode. Representative post-enrichment execution: `nursing` ~11 ms; `IELTS` ~3.6 ms.

The semantic/vector candidate remains rejected. Current state remains 0 embeddings / 0 active embedding jobs / 0 query embedding cache. Hybrid without an admitted corpus uses FTS fallback; vector-only has no accepted corpus.

## Consumer contracts

Website Search v2 is versioned and keeps CRICOS regulatory tuition separate from Provider-current tuition. Website Search v1 remains intact. All 33,105 Search documents remain unpublished in Pilot, so Search admission has not broadened Website visibility.

Zoho Consumer Contract remains v1.3 with no new DTO fields; Search state remains non-authoritative for canonical presence/publication.

## Determinism / invalidation acceptance

Enrichment stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Final native full-refresh automated acceptance:

- generation **13**;
- base content hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- combined projection hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- immediate base replay **0 changed / 33,105 unchanged / 0 new / 0 removed**;
- immediate enrichment replay **0 changed / 33,105 unchanged**;
- `search.projection_state` records `course-v3` and explicit domain/source enrichment admission.

Earlier semantic invalidation UAT remains accepted: exactly 10 Courses gained searchable enrichment text, exactly 10 semantic hashes changed, and 33,095 prior hashes remained exact.

## Accepted technical baselines

- AU Providers / Courses: 1,546 / 26,648;
- NZ Providers / Courses: 409 / 6,457;
- AU+NZ Providers / Courses: 1,955 / 33,105;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4 canonical / 0 currently Search-admitted;
- Search Course Documents: 33,105 (`course-v3`);
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`.

## Production security exception retained

`CF-CHG-20260823-022` remains unchanged: leaked-password protection is a bounded Pilot exception and mandatory Production go-live security gate.

## Governing references

- `CF-CHG-20260823-023` — CLOSED / PASS;
- `docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`;
- Database Architecture v2.10.40;
- Running Build v2.64;
- Zoho Consumer Contract v1.3;
- M1-SEARCH-VECTOR UAT v1.0 rejection;
- Pilot-to-Production Project Plan v1.10.

## Baseline for subsequent work

Use Master Project Plan v1.62, Pilot-to-Production Plan v1.10, Running Build v2.64, Database Architecture v2.10.40, Admin/PIM Design Decisions v1.13, PIM Admin Guide v1.14, and Pilot `23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`.

Search enrichment is accepted for the governed deterministic FTS projection. Publication remains separate, and vector/hybrid remains not admitted.
