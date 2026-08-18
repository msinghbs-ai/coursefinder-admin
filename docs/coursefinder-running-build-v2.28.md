# CourseFinder Running Build v2.28

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.26.md`  
**QILT UAT:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`  
**PRISMS UAT:** `docs/uat/coursefinder-layer2a-au-prisms-production-gate-uat-v1.0.md`  
**Scholarship UAT:** `docs/uat/coursefinder-layer2-scholarships-au-first-source-gate-uat-v1.0.md`

## Current build position

**M1-L2-SCHOLARSHIPS — Australia first-authoritative-source gate: PASS / ACCEPTED.**

The live Pilot now proves the accepted relational Scholarship model against authoritative Australian sources without weakening Provider/Course identity or publishing Scholarship data into student-facing Search.

Accepted source position:
- Study Australia — QUALIFIED and implemented for bounded live Scholarship ingestion;
- DFAT Australia Awards — QUALIFIED and implemented;
- Australian Government Research Training Program — BOUNDED/QUALIFIED for central program identity and benefits, with Provider application windows withheld until first-party Provider evidence is available.

Pilot source-control baseline: `2f159d5d5f1715e771e0564cd13b8fc9e1d95ad5`.

## Live Scholarship population

The first-source gate population is deliberately small and evidence-driven. It is not a claim of complete national Scholarship catalogue coverage.

| Relation | Accepted state |
|---|---:|
| Scholarships | **4** |
| Source Identifiers | **4** |
| Offering Cycles | **4** |
| Application Windows | **5** |
| Criterion Groups | **5** |
| Eligibility Criteria | **12** |
| Scopes | **3** |
| Award Tiers | **3** |
| Coverage | **10** |
| Published Scholarships | **0** |

Accepted identities include:
- Australia Awards Scholarships — source identifier `AAS`, Offering Cycle `2027`;
- RMIT Irana Turynska Scholarship — Study Australia source ID `3d26fbb4f240456a8ffc71f9bd51ecf4`, exact CRICOS `00122A`;
- RMIT David Phillips Memorial Scholarship — source ID `d2ec6bbb95a42533d1bc38a55330b012`, exact CRICOS `00122A`;
- RMIT English Language Bursary for Latin American Students — source ID `475b48e53aeac5761f333d81f6e302ae`, exact CRICOS `00122A`.

## Source/identity contract

### Study Australia

Scholarship identity uses the source-native 32-hex identifier embedded in the Scholarship detail URL.

Provider mapping is strictly:

`Study Australia Provider source key -> official Provider page -> published CRICOS -> exact accepted canonical Provider registration`

No Provider-name fallback is permitted.

### Australia Awards

The enduring Scholarship identity is `AAS`.

The 2027 intake is stored as Offering Cycle `2027` with two separate Application Windows:
- main 2027 application round;
- Palau 2027 application round.

Compound eligibility is retained as linked `all` / `any` criterion groups rather than flattened into a single eligibility field.

### Research Training Program

The central program is source-qualified using the persistent government program identifier/DOI. Provider-specific application dates remain deliberately unpopulated until first-party Provider evidence is acquired.

## Award/Coverage proof

The gate exercises both fixed-dollar and percentage awards:
- AUD 10,000 annually Award Tier;
- AUD 5,000 annually Award Tier;
- 35% program-fee Award Tier plus tuition Coverage.

Australia Awards retains 9 separate Coverage facts, including full tuition fees, return air travel, establishment allowance, living expenses, Introductory Academic Program, OSHC and conditional support benefits.

## Autonomous parser correction

The first worker revision retained the source text for the 35% RMIT bursary but did not derive its percentage Award Tier/Coverage because `%` was incorrectly followed by a word-boundary assumption.

The gate was held. Worker `scholarships-au-etl-v0.1.1` corrected the parser, then dry-run/APPLY/replay was repeated. The final accepted population includes the 35% Award Tier and tuition Coverage.

## Replay/idempotency

Corrected APPLY was replayed for both implemented source paths.

All canonical counts remained unchanged. Deterministic-ID fingerprints remained identical:
- Scholarships: `96203df1062d17a0f1e5c8d44a151715`;
- Offering Cycles: `3c14cc1d151fa9743c1b742a19fd6be1`;
- Application Windows: `7680638e21c4a957b3457c4d052c9657`;
- Criterion Groups: `08f0a78efba95347807d5ec23a9330e2`;
- Eligibility Criteria: `7622006a9000613cde68c148dcc1d352`;
- Scopes: `ebc4950c24dea0750a16a8fdd9c28112`;
- Award Tiers: `2a5463b3d914499f282d36704ab249a2`;
- Coverage: `db52862b231baea866419365c5cb2f0f`.

Canonical replay/idempotency is **PASS**.

Evidence/source-record history remains independently versioned by content hash, so changed upstream bytes can create a new evidence version without creating duplicate canonical Scholarship identities.

## Runtime/security/evidence

Edge Function: `scholarships-au-etl` v0.1.1.

Applied migrations:
- `20260818070135_scholarship_au_authoritative_source_contract_v1`;
- `20260818070544_scholarship_au_pilot_nonce_runner`;
- `20260818071312_scholarship_source_qualification_country_index`.

Controls proven:
- service-role-only Scholarship apply/evidence/source RPCs;
- private evidence Storage under `layer2a/AU/scholarships/...`;
- SHA-256 component and manifest evidence lineage;
- source-record version history independent from canonical identity;
- single-use Pilot nonce for Edge execution;
- direct Edge request without nonce returned **401** with `valid one-time Pilot nonce required`;
- all four Scholarship rows remain `unpublished`.

The new source-qualification country foreign key has a covering index. Post-fix Performance Advisor no longer reports that new missing-index condition. Existing inherited/project-wide advisor notices remain outside this gate.

## Accepted AU enrichment retained

The Scholarship gate does not replace or reinterpret previously accepted Layer 2A data:
- QILT — **2,033** accepted Provider outcome observations;
- PRISMS — **2,270** accepted student-flow observations.

It also does not modify AU/NZ Layer 1 identity or accepted Search publication.

Accepted Search remains the separately governed AU+NZ projection of **33,105** documents until M1-SEARCH explicitly approves enrichment projection semantics.

## Current Milestone 1 position

- AU CRICOS Layer 1 — PASS / ACCEPTED;
- NZ NZQA Layer 1 — PASS / ACCEPTED;
- CA Layer 1 — PAUSED / UNPUBLISHED;
- AU QILT Layer 2A — PASS / ACCEPTED;
- AU PRISMS Layer 2A — PASS / ACCEPTED;
- AU Scholarship first-authoritative-source gate — **PASS / ACCEPTED**;
- NZ Education Counts — QUEUED;
- NZ Scholarships — QUEUED;
- Admin/PIM Scholarship/evidence/review workspace — IN PROGRESS;
- Search/API enrichment projection — separate gate required.

## Next build

The Scholarship relational model no longer needs another proof-of-concept gate. Valid next actions are controlled expansion and consumer governance:
- ingest additional qualified Study Australia records in bounded evidence-backed batches;
- qualify first-party Provider evidence for RTP application windows where useful;
- qualify/implement New Zealand Scholarship sources;
- implement the Admin/PIM relational Scholarship workspace and evidence/review views;
- define M1-SEARCH Scholarship publication, filter and ranking semantics before student-facing projection.

Do not reintroduce Provider-name identity matching and do not publish Scholarship rows merely because canonical ingestion has passed.
