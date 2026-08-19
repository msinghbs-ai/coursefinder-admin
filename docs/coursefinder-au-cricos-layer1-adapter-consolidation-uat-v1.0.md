# CourseFinder AU CRICOS Layer 1 Adapter Consolidation UAT v1.0

**Status:** PASS / ACCEPTED  
**Date:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.32.md`

## Purpose

Close the operational gap left after `M1-L1-AU-CRICOS-FACTS`: the proven CRICOS regulatory facts must refresh through the primary AU Layer 1 ingestion path, not depend on a separately operated facts job.

## Accepted source

- Active AU Providers: 1,546
- Active AU Courses: 26,648
- CRICOS Courses snapshot: `2026-08-04T08:04:20.717556Z`
- SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`

## Adapter change

Primary operational entrypoint remains `layer1-au-depth`.

Accepted deployed version: `layer1-au-depth-v1.5.1`.

Changes:
- maximum bounded batch: 500 active Courses;
- streaming/bounded CSV scanner replaces full materialisation of all ZIP CSV rows;
- core Course/Provider and geography reconciliation remains in the parent Layer 1 worker;
- CRICOS regulatory Course facts run as an internal child phase using `layer1-au-cricos-facts-v1.1.0`;
- the child phase accepts the parent service-role invocation and preserves the same source/evidence/hash contract;
- Search rebuild/finalisation is removed from each Layer 1 batch so Search remains an independent governed projection/admission gate.

The child worker is an implementation phase of the primary Layer 1 job, not a separate data layer and not Layer 2.

## Dry-run UAT

Parent job: `72c3d242-b68b-44b7-b0ac-453883710ab2`.

Offset 0 / batch 500:
- completed;
- 500 selected Courses;
- exact source hash matched;
- facts matched: 500;
- facts unchanged: 500;
- fee observations: 1,488;
- fees unchanged: 1,488;
- missing Courses: 0;
- invalid fee values: 0;
- conflicts: 0.

## APPLY/replay UAT

Parent job: `f9618d43-f5f3-4a7f-8739-663276f0bc7e`.

Offset 0 / batch 500:
- 500 existing Courses;
- 500 existing Providers;
- 0 Courses created;
- 0 Providers created;
- 11 existing Campuses;
- 515 existing Course-location links;
- 0 geography conflicts;
- 500 regulatory facts unchanged;
- 1,488 fee observations unchanged;
- 0 fact/fee creates or updates;
- 0 missing identities.

This proves same-snapshot replay does not create duplicate facts or identities through the corrected primary adapter.

## End-of-source boundary UAT

Parent job: `c6b40f4d-47d8-4ca0-a010-9d778675dbc8`.

Offset 26,500 / requested batch 500:
- selected records: 148;
- `hasMore=false`;
- 148 existing Courses and Providers;
- 54 existing Campuses;
- 184 existing Course-location links;
- 148 regulatory facts unchanged;
- 444 fee observations unchanged;
- 0 creates, updates, misses or conflicts.

This proves final partial-batch handling at the 26,648-Course boundary.

## Full catalogue state

The complete accepted CRICOS snapshot had already passed full dry-run/APPLY/replay before adapter consolidation. The corrected parent path now owns future refreshes and has proven beginning/end pagination and idempotent APPLY against that same fully applied snapshot.

Current live state:
- AU Providers: 1,546;
- AU active Courses: 26,648;
- current CRICOS regulatory Course observations: 26,648;
- active CRICOS registered-total-course fee rows: 79,562;
- current Provider/year-specific fee rows: 0.

## Completeness impact

The current publication/Search completeness score is not recalculated by this gate. AU has no Course `publishing.entity_states` completeness rows/profile supplying that score, and all AU Search document completeness values remain null.

A separate analysis-only AU Layer 1 regulatory completeness measure was calculated over 13 equally weighted authoritative dimensions:
1. CRICOS registration;
2. Course title;
3. study level;
4. duration;
5. primary field;
6. campus relationship;
7. Dual Qualification;
8. Foundation Studies;
9. Work Component;
10. Course Language;
11. registered Tuition Fee;
12. registered Non Tuition Fee;
13. Estimated Total Course Cost.

Estimated score using only the previously persisted dimensions: **45.49% average**.

Score after accepted CRICOS facts: **99.22% average**.

Post-implementation distribution:
- 24,239 Courses = 100%;
- 26,448 Courses >= 90%;
- 200 Courses < 90%;
- minimum = 76.92%;
- maximum = 100%.

This is a regulatory/source-completeness diagnostic, not publication readiness and not a Search admission score.

Remaining structural gaps visible in the regulatory profile include:
- study level mapped for 24,367 / 26,648 Courses;
- campus relationship for 26,614 / 26,648 Courses;
- Tuition Fee present for 26,457 / 26,648;
- Non Tuition Fee present for 26,457 / 26,648.

## Search boundary

Search Documents remain 33,105 and `has_fee=true` remains 0.

`search.enrichment_gates` for `courses/course_fee` remains `blocked`.

No regulatory total-course fee is treated as a current annual/provider fee.

## Security/operational checks

- stats compatibility RPC is executable only by `postgres` and `service_role`;
- stale failed UAT jobs were explicitly closed;
- running AU depth jobs after UAT: 0.

## Decision

**PASS / ACCEPTED.**

The missing CRICOS Course facts are now part of the primary AU Layer 1 operational refresh path. Layer 2 is only for Provider-owned facts CRICOS does not supply at the required grain/freshness.
