# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.0

**Date:** 13 August 2026  
**Scope:** CA Gate B — Ontario Provider mapping and first-party institutional Course identity  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.8.md`

## Result

**ONTARIO PROVIDER MAPPING: PASS**  
**ALGONQUIN FULL-SOURCE COURSE SUB-GATE: PASS**  
**CONESTOGA FULL-SOURCE COURSE SUB-GATE: PASS**  
**FANSHAWE PGWP PARTIAL-SOURCE COURSE SUB-GATE: PASS**  
**ONTARIO / CANADA COURSE COVERAGE: INCOMPLETE — OVERALL GATE B REMAINS BLOCKED**

## Identity contract

Provider identity:
`CA + ircc_dli + DLI_number`.

Course identity:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Course titles are mutable metadata and never identity. Ontario APS, MTCU and CIP remain validation/classification metadata only.

## Ontario ministry Provider mapping — PASS

The Ontario ministry workbook exposes 24 public-college source codes but no DLI numbers and no stable institutional programme code.

All 24 source codes are now mapped in `pipeline.source_provider_mappings` to 24 existing canonical IRCC-DLI Providers:
`ALGO, BORE, CAMB, CANA, CENT, CONF, CONS, DURH, FANS, GEOR, GRBR, HUMB, LACI, LAMB, LOYT, MOHA, NIAG, NORT, SAUL, SENE, SHER, SLAW, SSFL, STCL`.

Validation:
- mappings: 24;
- verified: 24;
- distinct canonical Providers: 24;
- missing Providers: 0;
- missing DLI metadata: 0;
- mapping confidence: 1.0000;
- Provider identity writes from the ministry source: prohibited.

## Algonquin College — full-source PASS

Verified Provider DLI: `O19358971022`.

First-party source:
`https://www.algonquincollege.com/online/programs/list/all/`

Identity scheme: `algonquin_program_code`.

The source publishes structured programme codes in its first-party programme payload.

Accepted full-source results:
- parsed programmes: 88;
- canonical Courses: 88;
- full-source idempotency: 0 created / 88 existing;
- conflicts: 0;
- UUIDv5 mismatches: 0;
- duplicate programme codes: 0;
- wrong Provider links: 0;
- titles embedded in stable keys: 0;
- residual HTML entities in canonical titles: 0.

Accepted Edge runtime:
`layer1-ca-algonquin-catalogue-v0.2.0`.

Autonomous Pilot Edge APPLY returned HTTP 200 with 0 created / 88 existing and fresh private evidence.

## Conestoga College — full-source PASS

Verified Provider DLI: `O19376158572`.

First-party source:
`https://www.conestogac.on.ca/program-technology-requirements/program-device-requirements`

Identity scheme: `conestoga_program_code`.

Source observations:
- raw programme rows: 317;
- unique programme codes: 315;
- duplicate source appearances: 2;
- conflicting duplicate titles: 0.

Accepted full-source results:
- canonical Courses: 315;
- full-source idempotency: 0 created / 315 existing;
- reconciliation conflicts: 0;
- UUIDv5 mismatches: 0;
- duplicate canonical programme codes: 0;
- wrong Provider links: 0;
- titles embedded in stable keys: 0;
- residual HTML entities in canonical titles: 0.

Accepted Edge runtime:
`layer1-ca-conestoga-catalogue-v0.1.0`.

Autonomous Pilot Edge APPLY returned HTTP 200 with 0 created / 315 existing, parser conflicts 0 and fresh private evidence.

## Fanshawe College — partial-source PASS

Verified Provider DLI: `O19361039982`.

First-party source:
`https://www.fanshawec.ca/international/applicants/international-programs/pgwp-programs`

Identity scheme: `fanshawe_program_code`.

The source is intentionally classified as `partial_pgwp_aligned_only`; it must not be represented as the complete Fanshawe catalogue.

Accepted results:
- programme rows: 80;
- unique programme codes: 80;
- canonical Courses: 80;
- first APPLY: 80 created / 0 existing;
- idempotency rerun: 0 created / 80 existing;
- conflicts: 0;
- UUIDv5 mismatches: 0;
- duplicate programme codes: 0;
- wrong Provider links: 0;
- titles embedded in stable keys: 0;
- residual HTML entities in canonical titles: 0.

Accepted Edge runtime:
`layer1-ca-fanshawe-pgwp-v0.1.0`.

Autonomous Pilot Edge APPLY returned HTTP 200 with 0 created / 80 existing, parser conflicts 0 and fresh private evidence.

## Current canonical CA Course state

- Algonquin full-source Courses: 88;
- Conestoga full-source Courses: 315;
- Fanshawe partial-source Courses: 80;
- **total canonical CA Courses: 483**.

Full-source institutional Course coverage represented here: 403 Courses across 2 Providers.
Partial-source institutional Course coverage represented here: 80 Courses across 1 Provider.

## Pilot automation/runtime boundary

Pilot UAT uses a temporary Vault-backed execution key and a service-only `pipeline.pilot_edge_execution_queue` so nominated Edge workers can be exercised without browser JWT handoffs.

The secret is not stored in GitHub. Browser roles cannot operate the execution queue. Selected workers run with `verify_jwt=false` only because each worker enforces in-handler Platform Admin or Pilot-secret authentication.

This Pilot mechanism must be removed/disabled during production hardening.

A redundant request-JWT claim check inside `svc_layer1_apply_scoped_course_records` was removed after proving the RPC ACL itself is service-role-only. `anon` and `authenticated` EXECUTE remain revoked.

## Security/performance review

Post-change Supabase advisors show no new CA identity-write exposure or missing-index defect attributable to these sub-gates.

Existing project-level items remain open:
- deny-by-default RLS/no-policy INFO notices;
- authenticated UI SECURITY DEFINER warnings;
- leaked-password protection disabled;
- unused-index INFO in the Pilot environment.

These remain Phase 7 hardening items.

## Next gate

1. Continue first-party institutional Course identity coverage across the remaining mapped Ontario public colleges.
2. Keep full-source and partial-source coverage explicitly distinguished.
3. Join institutional Course identities to APS/MTCU/CIP validation metadata where deterministic joins can be proven.
4. Close Ontario public-college coverage sufficiently before broadening remaining Canadian provincial/institutional sources.
5. Only after country-wide Course coverage is sufficient, run final Search Projection, security and performance UAT.

## Gate state

- CA Gate A Federal Provider Authority: PASS.
- Ontario ministry parser: PASS as validation/classification authority.
- Ontario Provider mapping: PASS 24/24.
- Algonquin Course sub-gate: PASS full source.
- Conestoga Course sub-gate: PASS full source.
- Fanshawe Course sub-gate: PASS partial source only.
- CA canonical Courses: 483.
- **CA Gate B: ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**
