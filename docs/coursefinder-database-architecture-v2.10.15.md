# CourseFinder Database Architecture v2.10.15

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.14.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

## Canada Layer 1 position

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable and non-identifying. Non-universal regulatory/admissions codes remain validation or secondary metadata.

## Institutional Course authority

Twelve Ontario institutional identity sub-gates now PASS, producing **1,680 canonical CA Courses**.

Coverage accounting:
- full/current: **1,408**;
- partial-source: **80**;
- identity-full / lifecycle-currentness pending: **192**.

## Loyalist identity decision

Official first-party source: Loyalist programme-list WordPress AJAX flow exposed by the college page JavaScript.

The supported flow uses the page's fresh WordPress nonce and `admin-ajax.php?action=filter_programs` pagination. Four pages return exactly:
- 74 programme records;
- 74 distinct numeric programme record IDs;
- 74 distinct programme permalinks;
- 0 missing titles/permalinks.

Accepted identity scheme: `loyalist_program_id` using the first-party numeric programme record ID under verified DLI `O19359011572`.

Permalink and title remain mutable metadata.

## Loyalist lifecycle

Lifecycle is conservative:
- explicit January/May/September/Ongoing intake -> `active`;
- `No Upcoming Intakes` or generic `Other` without an explicit intake -> `unknown`;
- no inactive/suspended state is inferred without explicit source evidence.

Accepted runtime distribution: **65 active / 9 unknown**.

## UAT

Bounded APPLY: 50 created / 0 conflicts.  
Full APPLY: 24 created / 50 existing / 0 conflicts.  
Identity integrity: 74/74 IDs, UUID mismatch 0, wrong Provider 0.  
Autonomous Edge replay: HTTP 200, 0 created / 74 existing, 0 conflicts, fresh private evidence.

Worker: `layer1-ca-loyalist-programs-v0.1.0`.

## Gate state

- CA Gate A — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional identity sub-gates — **12 PASS**.
- Canonical CA Courses — **1,680**.
- `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.