# CourseFinder Master Project Plan v1.33

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.32.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.33.md`  
**Running build:** `docs/coursefinder-running-build-v2.35.md`  
**Completeness design:** `docs/coursefinder-au-layer1-regulatory-completeness-design-v1.0.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 Course substrate |
| AU CRICOS regulatory Course facts | PASS / ACCEPTED | 24-field audit and fact/fee model accepted |
| AU Layer 1 primary adapter consolidation | PASS / ACCEPTED | Primary adapter now owns complete CRICOS refresh path |
| **AU Layer 1 residual completeness remediation** | **IMMEDIATE PRIMARY** | Resolve/classify 2,281 study-level gaps and 34 campus gaps before L2 |
| Regulatory attribute coverage | 99.22% / DIAGNOSTIC | Do not conflate with publication readiness |
| AU first-party Course facts | QUEUED AFTER L1 COMPLETENESS | Provider-owned facts not supplied by CRICOS at required grain/freshness |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Publication/Search completeness | NOT YET FORMALISED FOR AU | Do not manufacture score from regulatory coverage |
| Search enrichment readiness | BLOCKED | Fee/link/intake/English require separate admission UAT |
| Admin/PIM | IN PROGRESS / HARDENING REQUIRED | Expose provenance and distinguish gap reasons/readiness concepts |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents; fee gate still blocked |
| Vector/semantic Search | PENDING / PARALLEL GATE | Independent relevance/latency UAT |

## Completed correction — AU Layer 1 adapter

`layer1-au-depth-v1.5.1` is the accepted primary AU CRICOS operational entrypoint.

It uses bounded streamed processing and internally invokes the CRICOS regulatory-facts phase. Future CRICOS refreshes therefore update core identity/depth/facts under one Layer 1 operational path and source/evidence/hash contract.

Adapter beginning/end replay UAT passes without identity, geography, fact or fee duplication.

## Completeness governance

The programme now formally distinguishes:

1. **Source representation completeness** — whether populated accepted source facts are represented or explicitly classified.
2. **Regulatory attribute coverage** — whether desired regulatory dimensions have usable values. Current AU diagnostic average: **99.22%**.
3. **Publication/Search completeness** — consumer readiness/freshness under separately approved publication and Search semantics.

A source-null value must not be recorded as an adapter defect merely to force a 100% score.

A populated source value that remains unmapped is a Layer 1 mapping/review issue until explicitly resolved.

## Immediate primary — M1-L1-AU-CRICOS-COMPLETENESS

Purpose: close residual canonical/relational Layer 1 mapping gaps before Provider-owned enrichment begins.

### Study-level remediation

Current gap: **2,281 Courses** without mapped `study_level_id`.

Required work:
- inventory every distinct current CRICOS `Course Level` value and count;
- map deterministic regulatory meanings to `ref.study_levels`;
- extend the reference taxonomy only when semantics are stable and documented;
- retain exact raw CRICOS vocabulary/evidence;
- never use Course title fallback where CRICOS supplies a populated Course Level;
- ambiguity goes to review rather than forced mapping.

### Campus remediation

Current gap: **34 Courses** without canonical campus relationship.

Required work:
- reconcile against CRICOS Course Locations;
- classify each gap as source absence, identity-resolution issue or adapter defect;
- repair deterministic mappings where possible;
- do not create synthetic campuses solely for completeness.

### Fee source gaps

Current source-populated counts remain:
- Tuition Fee: 26,457 / 26,648;
- Non Tuition Fee: 26,457 / 26,648;
- Estimated Total Course Cost: 26,648 / 26,648.

The 191 missing Tuition and 191 missing Non Tuition observations are source coverage gaps unless a fresh source audit proves parsing/mapping failure.

No annualisation, interpolation or cross-fee inference is permitted.

## M1-L1-AU-CRICOS-COMPLETENESS acceptance gate

Required PASS conditions:
- every populated CRICOS Course Level value mapped or explicitly review-classified;
- every one of the 34 current campus gaps classified and deterministic defects repaired;
- full dry-run/APPLY/replay/idempotency UAT;
- AU identity remains exactly 1,546 Providers / 26,648 active Courses;
- regulatory facts and fee semantics remain intact;
- no duplicate identities/facts/fees;
- Search remains unchanged;
- regulatory completeness recalculated with source-gap versus adapter-defect attribution.

The target is zero unexplained Layer 1 mapping defects, not fabricated 100% coverage.

## Next serial gate — M1-L2-AU-COURSE-FACTS

Begins only after the residual Layer 1 completeness gate passes.

Scope remains limited to Provider-owned facts CRICOS does not supply at the required grain/freshness:
- official Course URL;
- current/year-specific international fee schedules with exact source dimensions;
- authoritative intakes/application timing;
- English entry requirements;
- source/evidence/versioning;
- stable CRICOS Course identity resolution;
- dry-run/APPLY/replay/idempotency UAT.

Layer 2 must not duplicate or redefine accepted CRICOS facts.

## Search enrichment readiness

After first-party Course Facts, separately decide which fee/link/intake/English facts may enter Search/API/Website contracts.

Current state:
- Search Documents: 33,105;
- `has_fee=true`: 0;
- `courses/course_fee`: BLOCKED.

## Parallel lanes

`M1-PIM-HARDENING`:
- expose regulatory observations and evidence;
- show `source_absent`, `review_required`, `adapter_defect`, `explicitly_excluded`, `not_yet_enriched` gap reasons;
- distinguish regulatory completeness from publication readiness;
- harden browser RPCs/grants/roles/storage.

`M1-SEARCH-VECTOR`:
- embedding profile/model;
- bounded generation;
- relevance and latency UAT;
- cache/replay/invalidation.

## Programme sequence

Primary serial lane:

`M1-L1-AU-CRICOS-COMPLETENESS -> M1-L2-AU-COURSE-FACTS -> SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT`

Parallel:

`M1-PIM-HARDENING`

`M1-SEARCH-VECTOR`

Close-out:

`M1-PRODUCTION-HARDENING -> M1-ACCEPTANCE`

## Programme next

**Immediate primary:** `M1-L1-AU-CRICOS-COMPLETENESS`.

Do not advance the serial data lane to Layer 2 until the residual Layer 1 mapping gate is accepted.
