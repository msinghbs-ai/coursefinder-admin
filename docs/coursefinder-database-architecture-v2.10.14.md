# CourseFinder Database Architecture v2.10.14

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.13.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

## Canada Layer 1 position

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles remain mutable and non-identifying. Provincial APS/MTCU/CIP and non-universal institutional codes remain validation/secondary metadata unless uniqueness and source authority are proven.

## Ontario Course authority

Ontario Provider mapping remains PASS at 24/24 verified IRCC-DLI Providers.

Institutional Course identity sub-gates now PASS: **11**.

Canonical CA Courses: **1,606**.

Coverage accounting:
- full/current accepted source Courses: **1,334**;
- partial-source Courses: **80**;
- identity-full / lifecycle-currentness pending: **192**.

Accepted institutional sources: Algonquin, Conestoga, Fanshawe (partial), Mohawk, Durham, Niagara, Sheridan, Seneca, Cambrian, Fleming and Georgian.

## Fleming identity and transport decision

Official Fleming A–Z programme cards expose a universal first-party `data-guid` programme path, title, programme-code metadata, CIP and start terms.

Observed source:
- programme cards: 77;
- distinct first-party GUID/path values: 77;
- secondary programme-code tokens: 88 / 88 distinct;
- one joint programme has no displayed code;
- lifecycle from current/future start terms: 76 active / 1 unknown.

Accepted base identity is `fleming_program_guid` under verified DLI `O19303189722`. Programme codes are secondary registrations/validation metadata and are not required for identity.

Fleming's response headers exceed Deno's direct HTTP client limit. The accepted runtime therefore uses a service-role-only `pg_net` acquisition bridge implemented with SECURITY INVOKER RPCs. Browser roles cannot execute the bridge. Edge worker `layer1-ca-fleming-programs-v0.1.2` parses/reconciles the returned first-party HTML normally.

Runtime replay:
- 77 parsed;
- 0 created / 77 existing;
- 0 conflicts;
- lifecycle 76 active / 1 unknown;
- private evidence captured;
- transport `pg_net`.

## Georgian identity decision

Official Georgian 2026–27 Academic Catalogue exposes 209 programme entries with 209 unique institutional programme codes and zero duplicate codes. Eight titles are reused across distinct programme codes, independently proving title cannot be identity.

Accepted base identity is `georgian_program_code` under verified DLI `O19395677361`.

Georgian UAT:
- bounded APPLY: 50 created / 0 conflicts;
- full APPLY: 159 created / 50 existing / 0 conflicts;
- UUID mismatch: 0;
- wrong Provider links: 0;
- lifecycle mismatch: 0;
- autonomous Edge replay: 0 created / 209 existing / 0 conflicts;
- lifecycle: 209 active;
- private evidence SHA-256: `fe221ddaa4138990e4e84eed4bc21bb1ef9e02f3248305a080c7959584d4d591`.

## Pilot execution boundary

Pilot-only institutional workers continue to use one-time nonce custom authentication with `verify_jwt=false`. Production hardening must remove this temporary execution pattern and restore the production authentication boundary.

## Gate state

- CA Gate A Federal Provider Authority — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional Course identity sub-gates — **11 PASS**.
- Canonical CA Courses — **1,606**.
- `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

Continue remaining Ontario coverage and then broaden authoritative Course-source coverage outside Ontario before Canada Search/security/performance production gates.