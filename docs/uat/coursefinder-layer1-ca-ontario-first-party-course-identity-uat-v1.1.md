# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.1

**Date:** 13 August 2026  
**Supersedes:** `docs/uat/coursefinder-layer1-ca-ontario-first-party-course-identity-uat-v1.0.md`  
**Scope:** CA Gate B — Ontario Provider mapping and first-party institutional Course identity

## Result

**ONTARIO PROVIDER MAPPING: PASS 24/24**  
**ALGONQUIN FULL-SOURCE SUB-GATE: PASS**  
**CONESTOGA FULL-SOURCE SUB-GATE: PASS**  
**FANSHAWE PARTIAL-SOURCE SUB-GATE: PASS**  
**MOHAWK CURRENT-OPEN CATALOGUE SUB-GATE: PASS**  
**DURHAM FIRST-PARTY API SUB-GATE: PASS**  
**OVERALL CA GATE B: ACTIVE/BLOCKED — COURSE COVERAGE INCOMPLETE**

## Identity contract

Provider: `CA + ircc_dli + DLI_number`.

Course: `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles, APS, MTCU, CIP and non-unique admissions codes are never base identity.

## Accepted institutional sources

| Provider | DLI | Identity scheme | Coverage | Courses | Idempotency |
|---|---|---|---|---:|---|
| Algonquin College | O19358971022 | algonquin_program_code | full accepted source | 88 | 0 created / 88 existing |
| Conestoga College | O19376158572 | conestoga_program_code | full accepted source | 315 | 0 / 315 |
| Fanshawe College | O19361039982 | fanshawe_program_code | partial PGWP-aligned only | 80 | 0 / 80 |
| Mohawk College | O19376045902 | mohawk_program_code | current open programmes | 108 | 0 / 108 |
| Durham College | O19361081012 | durham_program_id | full current first-party API | 150 | 0 / 150 |

Current canonical CA Courses: **741**.

## Mohawk UAT

Official current programme search server-renders 154 unique programme-code rows.

Runtime classification:
- current open programmes: 108;
- closed rows excluded: 46;
- accepted canonical Courses: 108;
- first APPLY: 108 created;
- repeat: 0 created / 108 existing;
- conflicts: 0;
- UUID mismatches: 0;
- duplicate codes: 0;
- wrong Provider links: 0;
- title-derived stable keys: 0;
- Edge runtime `layer1-ca-mohawk-catalogue-v0.1.0`: HTTP 200, 108/108 existing, fresh evidence.

Legacy numbers embedded in some displayed titles are retained as mutable title text. The final published programme code remains identity.

## Durham UAT

Official Durham programme search JavaScript exposes first-party JSON API:
`https://durhamcollege.ca/wp-json/dc/v2/programs`.

API result:
- rows: 150;
- unique first-party programme record IDs: 150/150;
- missing IDs: 0;
- duplicate record IDs: 0.

OCAS was explicitly rejected as base Course identity because four OCAS codes are reused across distinct programme/pathway records.

Accepted identity scheme: `durham_program_id` using the first-party programme record `id`.

Results:
- bounded APPLY: 50 created;
- bounded repeat: 0 created / 50 existing;
- full APPLY: 100 created / 50 existing;
- full repeat: 0 created / 150 existing;
- conflicts: 0;
- UUID mismatches: 0;
- duplicate identities: 0;
- wrong Provider links: 0;
- title-derived stable keys: 0;
- Edge runtime `layer1-ca-durham-programs-v0.1.0`: HTTP 200, 150/150 existing, fresh JSON evidence;
- duplicate OCAS diagnostics retained: 4; OCAS identity use disabled.

## Current coverage

- full/current accepted source Courses: 661 across Algonquin, Conestoga, Mohawk and Durham;
- partial-source Courses: 80 Fanshawe PGWP-aligned;
- total canonical CA Courses: **741**;
- Ontario mapped Providers: 24;
- institutional Course sub-gates passed: 5.

## Gate state

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. The identity architecture is proven across published programme codes and institutional internal catalogue IDs; the remaining work is source coverage, deterministic Ontario validation joins, broader Canadian coverage, Search Projection and final hardening UAT.
