# CourseFinder Master Project Plan v1.31

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.30.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.31.md`  
**Running build:** `docs/coursefinder-running-build-v2.33.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve accepted substrate |
| **AU CRICOS regulatory Course facts** | **PASS / ACCEPTED** | 24-field audit complete; regulatory facts/fees retained with source snapshot/evidence; Search admission remains separate |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| CA Layer 1 | PAUSED / SKIPPED FOR CURRENT M1 EXECUTION | Preserve history; no further fragmented ETL work |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| **AU first-party Course facts** | **NEXT SERIAL DATA GATE** | Provider-owned Course URL, current/year-specific fee schedules, intakes and English requirements |
| Admin/PIM | IN PROGRESS / HARDENING REQUIRED | Finish role-aware UX plus SECURITY DEFINER/RPC/grant hardening |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 AU+NZ projection |
| Website/Zoho API contracts | PASS / CONTRACT ACCEPTED | Curated DTOs only |
| Vector/semantic Search | PENDING / PARALLEL GATE | May proceed independently with bounded relevance/latency UAT |
| Search enrichment readiness | BLOCKED | Fee/link/intake/English domains require separate admission UAT |
| Publication/release readiness | PENDING | No artificial publication solely for UAT |

## Completed gate — M1-L1-AU-CRICOS-FACTS

The current CRICOS Courses export was audited across all 24 columns and every field now has an explicit handling decision.

Accepted AU identity remains:
- 1,546 Providers;
- 26,648 Courses.

Accepted regulatory facts now include:
- one current CRICOS regulatory observation for every active AU Course;
- VET National Code as a relational observation, not Course identity;
- Dual Qualification;
- Foundation Studies;
- Work Component and valid typed quantities;
- Course Language using exact source vocabulary;
- secondary narrow Field of Education relationships;
- Tuition Fee;
- Non Tuition Fee;
- Estimated Total Course Cost.

Accepted CRICOS fee rows: 79,562.

CRICOS fee semantics remain total-course regulatory observations with `fee_year=NULL`; no annual fees were inferred.

Full dry-run, APPLY, same-snapshot replay, idempotency, completeness and bounded Edge runtime UAT passed.

Detailed gate record: `docs/coursefinder-au-cricos-course-facts-uat-v1.0.md`.

## Programme sequence

Primary serial data lane is now:

`M1-L2-AU-COURSE-FACTS -> SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT`

Parallel lane 1:

`M1-PIM-HARDENING`

Parallel lane 2:

`M1-SEARCH-VECTOR`

Close-out lane:

`M1-PRODUCTION-HARDENING -> M1-ACCEPTANCE`

## A. M1-L2-AU-COURSE-FACTS — immediate primary

Purpose: add current Provider-owned Course facts that CRICOS does not authoritatively supply at the required consumer grain.

Required scope:
- qualify bounded first-party Provider sources;
- resolve by accepted CRICOS Course code or another separately accepted stable source identity;
- official Course URL;
- current/year-specific international fee schedules;
- preserve fee year, basis, campus, intake and other source-supplied dimensions;
- intakes/application timing where authoritative;
- English entry requirements;
- source/evidence/versioning;
- dry-run/APPLY/replay/idempotency UAT;
- ambiguity to review, never title fallback.

Required semantic boundary:
- do not overwrite CRICOS registered total-course fees;
- do not derive annual/current fees from CRICOS amounts;
- Provider fees supplement regulatory observations with separate provenance and validity.

## B. Search enrichment readiness — after first-party Course Facts

Current `courses/course_fee` gate remains blocked with approval reference `Await M1-L2-AU-COURSE-FACTS UAT`.

Fee, Link, Intake and English Search admission requires a separate consumer-semantics UAT decision.

The gate must explicitly decide:
- which fact is consumer-displayable;
- regulatory fee versus current Provider fee semantics;
- filtering basis and missing-data behaviour;
- freshness expectations;
- API/Website DTO fields;
- rollback/rebuild behaviour.

Current Search remains 33,105 AU+NZ documents with `has_fee=true` for zero documents.

## C. M1-PIM-HARDENING — required parallel lane

Finish Admin/PIM operational readiness:
- Provider/Course/Campus detail and provenance visibility;
- distinguish CRICOS registered fee from current Provider fee;
- display regulatory Course facts and source snapshot/evidence;
- Evidence Viewer and source history;
- role-aware write controls;
- review browser-executable `SECURITY DEFINER` RPCs;
- explicit grants and server-side rank checks;
- remove/deprecate obsolete compatibility/browser surfaces;
- storage/RLS/security advisor UAT;
- resolve Supabase leaked-password-protection warning if available within project settings.

## D. M1-SEARCH-VECTOR — parallel independent lane

- approve embedding model/profile/dimensions;
- generate bounded AU+NZ embeddings using semantic-content hash;
- vector-only and filtered latency benchmarks;
- curated relevance set comparing FTS/vector/hybrid;
- cache/replay/invalidation UAT;
- approve or reject semantic publication independently.

## E. Publication and consumer positive-path UAT — required before M1 close

Current Search Documents remain unpublished by design.

After canonical/enrichment/hardening gates are accepted:
- define bounded publication policy;
- publish an accepted test/production slice through governed workflow;
- Website/Zoho positive-path API UAT;
- prove no internal/evidence/review fields leak;
- rollback/replay publication UAT.

## F. Final M1 production hardening — required

- security advisors / exposed RPC review;
- RLS/storage/auth checks;
- job/evidence retention and reset/rollback policy;
- search/performance regression;
- source refresh/replay runbook;
- monitoring/operational handover;
- final User/Admin Guide refresh;
- Milestone 1 acceptance record.

## Explicitly not required for current M1

- further Canada ETL generation;
- GB/US/IE/DE country implementation unless a future source-qualification gate separately approves them;
- Layer 3 AI as a prerequisite for accepted structured AU data;
- publication of vectors before semantic UAT;
- re-scraping CRICOS registered fee as though it were a current Provider fee;
- annualising CRICOS registered total-course amounts.

## Programme next

**Immediate primary:** `M1-L2-AU-COURSE-FACTS`.

**Then:** `SEARCH-ENRICHMENT-READINESS` followed by bounded `PUBLICATION-UAT`.

**Parallel:** `M1-PIM-HARDENING` and `M1-SEARCH-VECTOR`.
