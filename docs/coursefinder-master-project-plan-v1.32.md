# CourseFinder Master Project Plan v1.32

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.31.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.32.md`  
**Running build:** `docs/coursefinder-running-build-v2.34.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 Course substrate |
| AU CRICOS regulatory Course facts | PASS / ACCEPTED | 24-field audit and fact/fee model accepted |
| **AU Layer 1 primary adapter consolidation** | **PASS / ACCEPTED** | Primary adapter now refreshes accepted CRICOS facts; no permanent operational sidecar ownership |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| AU first-party Course facts | NEXT SERIAL DATA GATE | Provider-owned facts not supplied by CRICOS at required grain/freshness |
| Regulatory completeness | PASS / DIAGNOSTIC | Current AU Layer 1 analysis average 99.22%; do not equate to publication readiness |
| Publication/Search completeness | NOT YET FORMALISED FOR AU | Do not manufacture score from regulatory facts |
| Search enrichment readiness | BLOCKED | Fee/link/intake/English require separate admission UAT |
| Admin/PIM | IN PROGRESS / HARDENING REQUIRED | Show provenance and separate regulatory vs consumer readiness |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents; fee gate still blocked |
| Vector/semantic Search | PENDING / PARALLEL GATE | Independent relevance/latency UAT |

## Completed correction — primary Layer 1 adapter

`layer1-au-depth-v1.5.1` is now the accepted AU CRICOS operational entrypoint.

It uses bounded streamed processing and internally invokes the regulatory-facts phase so future CRICOS refreshes update identity/depth/facts under the same Layer 1 run and source/evidence/hash contract.

The implementation avoids two forms of ingestion debt:
- a separately operated facts refresh that could drift from the core CRICOS refresh;
- an automatic Search rebuild on every bounded Layer 1 batch.

Detailed UAT: `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.0.md`.

## Completeness decision

The regulatory-source model is now highly complete, but the programme recognises two different scores.

### Layer 1 regulatory completeness

Analysis-only 13-dimension AU CRICOS profile:
- estimated previous average: 45.49%;
- current average: 99.22%;
- 24,239 Courses at 100%;
- 26,448 Courses >=90%;
- 200 Courses <90%.

Remaining source/canonical gaps include study-level mapping, a small number of campus relationships, and blank Tuition/Non Tuition values supplied by CRICOS.

### Publication/Search completeness

Must measure consumer readiness and freshness rather than regulatory extraction alone.

It remains separate and is not automatically increased by CRICOS regulatory facts. AU currently has no Course `publishing.entity_states` completeness population supplying this score.

A later PIM/publication hardening gate should formalise the consumer completeness profile and may expose both regulatory completeness and publication readiness separately.

## Immediate primary — M1-L2-AU-COURSE-FACTS

Layer 2 scope begins only where CRICOS stops:
- official Provider-owned Course URL;
- current/year-specific international fee schedules with exact source-supplied dimensions;
- authoritative intakes/application timing;
- English entry requirements;
- source/evidence/versioning;
- stable CRICOS Course identity resolution;
- dry-run/APPLY/replay/idempotency UAT.

Layer 2 must not re-ingest CRICOS facts merely because they are useful to consumers.

## Search enrichment readiness

After accepted first-party Course Facts, separately decide which fee/link/intake/English facts may enter Search/API/Website contracts.

Current `courses/course_fee` remains blocked and Search `has_fee=true` remains 0.

## Parallel lanes

`M1-PIM-HARDENING`:
- expose source/evidence and regulatory facts;
- distinguish regulatory/source completeness from publication readiness;
- harden browser RPCs/grants/roles/storage.

`M1-SEARCH-VECTOR`:
- embedding profile/model;
- bounded generation;
- relevance and latency UAT;
- cache/replay/invalidation.

## Programme next

**Immediate primary:** `M1-L2-AU-COURSE-FACTS`, limited to facts not already supplied by CRICOS.

**Parallel:** `M1-PIM-HARDENING` and `M1-SEARCH-VECTOR`.

**Later:** `SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT -> M1-PRODUCTION-HARDENING -> M1-ACCEPTANCE`.
