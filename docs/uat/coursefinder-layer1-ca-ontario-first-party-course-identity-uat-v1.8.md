# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.8

**Date:** 16 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.18.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **18 PASS**, producing **2,273 canonical CA Courses**.

Coverage:
- full/current: 2,001;
- partial source: 80;
- identity-full / lifecycle-currentness pending: 192.

## Collège Boréal PASS

- DLI `O19395678039`.
- 63 unique first-party programme slugs.
- Identity `boreal_program_slug`.
- Lifecycle 58 active / 5 unknown.
- Autonomous replay: 0 created / 63 existing / 0 conflicts.

## Sault College PASS

- DLI `O19395677683`.
- 76 A-Z candidates; 76/76 detail-page acquisitions HTTP 200.
- 76 unique institutional programme codes.
- Identity `sault_program_code`.
- Lifecycle 53 active / 23 unknown.
- Autonomous first APPLY: 76 created / 0 conflicts.
- Autonomous replay: 0 created / 76 existing / 0 conflicts.

## Confederation College PASS

- DLI `O19376986752`.
- First-party `/api/program-search.json` source.
- 59 Full-Time degree/diploma/certificate programmes accepted.
- Identity `confederation_program_id` using the first-party programme UUID.
- First APPLY: 59 created / 0 conflicts.
- Replay: 0 created / 59 existing / 0 conflicts.
- Stable evidence SHA-256 `fcabe6bac6953649a9dde59dd4e12b86312698c739c75e83909032583fb84dd3`.

## Centennial College PASS

- DLI `O19394700003`.
- First-party programme API enumerated A-Z.
- Source rows 195; unique programme codes 195; missing codes/titles 0.
- 192 current credential programmes accepted; 3 preparation/recognition rows excluded.
- Identity `centennial_program_code`.
- Dry-run: 192 parsed / 0 writes.
- First APPLY: 192 created / 0 conflicts / 0 Provider writes.
- Replay: 0 created / 192 existing / 0 conflicts.
- Integrity: 192 identifiers / 192 distinct; wrong Provider 0; stable-key namespace mismatch 0; lifecycle mismatch 0.
- Evidence SHA-256 `d5ad23dd63426d8e1bd69b17b4e6f9fcd627e279a93c69a620e458f4d54c3c84`.

## Northern College — NOT PASS

The dedicated Post-Secondary Programs feed resolves to 53 programme pages. Strict dry-run found 35 valid programme-code records and 36 pages requiring alternate explicit-code parsing. No APPLY occurred. Northern remains a parser-normalisation blocker; rejected loose parsing must not be used for identity.

## Gate state

Overall Canada Gate B remains **ACTIVE/BLOCKED** because national Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.