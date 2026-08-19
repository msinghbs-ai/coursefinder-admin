# CourseFinder Database Architecture v2.10.32

**Status:** AUTHORITATIVE  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.31.md`

## 1. Version scope

v2.10.32 preserves all accepted identity, evidence, regulatory observations, QILT, PRISMS, Scholarship and Search contracts from v2.10.31.

This version closes the operational adapter gap identified after `M1-L1-AU-CRICOS-FACTS`: accepted CRICOS Course facts are now refreshed through the primary AU Layer 1 ingestion path.

Accepted AU identity remains exactly:
- Providers: 1,546;
- active Courses: 26,648.

## 2. Primary AU Layer 1 ingestion contract

The operational entrypoint remains `layer1-au-depth` and now represents the complete accepted AU CRICOS Layer 1 refresh path.

Accepted runtime version: `layer1-au-depth-v1.5.1`.

The adapter owns:
- CRICOS Provider/Course identity;
- title, level, duration and primary field;
- Locations/Campuses and Course-location relationships;
- accepted CRICOS regulatory Course observations;
- CRICOS registered total-course fee observations;
- evidence, source hash and source snapshot reconciliation.

The bounded regulatory-facts worker is invoked as an internal service-role child phase of the parent Layer 1 run. It is not an independent layer and is not Layer 2.

## 3. Runtime design

The previous full-object ZIP parser exceeded Edge worker resource limits when core, geography and regulatory facts were combined.

The accepted design uses bounded streaming scanners so only the selected Course page, relevant Providers, Locations and Course Locations are materialised.

Maximum accepted parent batch: 500 active Courses.

Search finalisation is not executed per Layer 1 batch. Search remains a separately governed derived projection with its own admission gates.

## 4. Idempotency

Same-snapshot parent APPLY proves:
- canonical Course/Provider IDs remain stable;
- existing Campuses and Course-location relationships are reused;
- regulatory facts are unchanged;
- registered-total-course fee observations are unchanged;
- no duplicate identity, fact or fee rows are created.

Beginning and final partial-batch UAT both pass.

Detailed evidence: `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.0.md`.

## 5. Completeness semantics

Two completeness concepts are explicitly separated.

### Regulatory/source completeness

Measures how completely the accepted regulatory source has been represented in canonical/relational Layer 1 data.

An analysis-only 13-dimension AU CRICOS profile currently measures **99.22% average** after the facts implementation, versus an estimated **45.49%** when only the previously persisted dimensions are counted against the same profile.

This diagnostic may be formalised into an Admin/PIM regulatory completeness projection later.

### Publication/Search completeness

Represents consumer/publication readiness and must not automatically increase because a regulatory observation exists.

AU currently has no Course `publishing.entity_states` completeness rows supplying the existing Search/PIM score. Regulatory total-course fees also remain blocked from Search fee admission.

Therefore v2.10.32 does not manufacture or backfill the publication completeness score.

## 6. Search boundary

Current Search remains:
- 33,105 Course Documents;
- `has_fee=true`: 0.

`courses/course_fee` remains `blocked`.

A CRICOS registered total-course amount is not a current annual/provider fee.

## 7. Layer boundary

Layer 1 now fully owns the accepted structured CRICOS Course facts.

Layer 2 is limited to Provider-owned facts not authoritatively available from CRICOS at the required grain/freshness, including official Course URL, current/year-specific fee schedules, intakes and English requirements.

## 8. Gate decision

**v2.10.32 accepted.**

The AU CRICOS Layer 1 adapter is operationally consolidated and future CRICOS refreshes must use the corrected primary path.
