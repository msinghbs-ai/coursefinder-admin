# CourseFinder Database Architecture v2.10.13

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.12.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

## Canada Layer 1 position

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable and must never form identity. Provincial APS/MTCU/CIP values and non-universal institutional programme codes remain validation or secondary registration metadata.

## Ontario Provider mapping

24/24 ministry college codes remain mapped to verified IRCC-DLI Providers.

## Institutional Course authority

Nine institutional identity sub-gates now pass, producing **1,320 canonical CA Courses**.

Coverage accounting:
- full/current accepted source Courses: **1,048**;
- partial-source Courses: **80**;
- identity-full / lifecycle-currentness pending: **192**.

Accepted sources now include Algonquin, Conestoga, Fanshawe (partial), Mohawk, Durham, Niagara, Sheridan, Seneca and Cambrian.

## Cambrian identity decision

Cambrian's live first-party programme page serializes structured CMS programme objects in the Next.js/RSC response.

Observed source set:
- programme objects: 85;
- unique CMS post IDs: 85/85;
- unique slugs: 85/85;
- populated programme codes: 82;
- distinct populated programme codes: 82;
- missing programme codes: 3.

Because three legitimate programmes have no programme code, the published programme code is not universal enough for base identity.

Accepted base identity is `cambrian_program_id`, using the first-party numeric CMS post ID. Where present, `acf.program_code` is retained as secondary institutional registration metadata.

Provider DLI: `O19394699409`.

## Cambrian lifecycle

Lifecycle is derived conservatively from current first-party start-date metadata:
- at least one current/future programme start month -> `active`;
- no current/future start -> `unknown`;
- no inactive/suspended state is inferred without explicit source evidence.

Accepted runtime distribution on 14 August 2026:
- active: **80**;
- unknown: **5**;
- inactive: 0;
- suspended: 0.

The two August 2026 programmes are active because the runtime lifecycle rule includes the current month.

## Cambrian UAT

Bounded APPLY:
- 50 records;
- 50 created;
- 0 conflicts.

Full APPLY:
- 85 records;
- 35 created / 50 existing;
- 0 conflicts.

Identity integrity:
- UUIDv5 mismatch: 0;
- duplicate CMS IDs: 0;
- wrong Provider links: 0;
- lifecycle mismatch after runtime reconciliation: 0;
- title-derived stable keys: 0.

Autonomous runtime worker `layer1-ca-cambrian-programs-v0.1.0` replayed the full source with HTTP 200, **0 created / 85 existing**, zero conflicts, zero duplicate secondary codes and fresh private evidence.

## Pilot execution and source-control note

The worker uses the temporary Pilot one-time nonce execution boundary and custom in-handler authentication with `verify_jwt=false`. This remains Pilot-only and must be removed during production hardening.

The deployed Cambrian worker is runtime-verified, but the GitHub connector blocked writing the exact worker source back to Pilot during this session. This is tracked as source-control drift and must be reconciled before migration consolidation/production release.

## Gate state

- CA Gate A Federal Provider Authority — PASS.
- Ontario validation parser — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional Course identity sub-gates — **9 PASS**.
- Canonical CA Courses — **1,320**.
- `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

Continue remaining Ontario institutional coverage, resolve lifecycle-currentness where pending, then broaden outside Ontario before final Search/security/performance production gates.