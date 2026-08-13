# CourseFinder Running Build v2.11

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.8.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.10.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario ministry validation parser: PASS.
- Ontario Provider mapping: PASS 24/24 to verified IRCC-DLI Providers.
- CA first-party Course identity: 483 canonical Courses across three Ontario institutions.
- CA Layer 2A StatsCan authenticated runtime parser dry-run: PASS.

## Accepted Ontario institutional Course sub-gates

### Algonquin College — full source PASS
- DLI `O19358971022`;
- identity scheme `algonquin_program_code`;
- 88 Courses;
- Edge runtime PASS;
- full-source idempotency 0 created / 88 existing;
- UUID/Provider/title integrity PASS.

### Conestoga College — full source PASS
- DLI `O19376158572`;
- identity scheme `conestoga_program_code`;
- 317 raw rows / 315 unique programme codes;
- 315 Courses;
- Edge runtime PASS;
- full-source idempotency 0 created / 315 existing;
- UUID/Provider/title integrity PASS.

### Fanshawe College — partial source PASS
- DLI `O19361039982`;
- identity scheme `fanshawe_program_code`;
- source classified `partial_pgwp_aligned_only`;
- 80 Courses;
- Edge runtime PASS;
- idempotency 0 created / 80 existing;
- UUID/Provider/title integrity PASS.

Current CA canonical Course count: **483**.

## Runtime/security corrections completed

- Provider-scoped institutional sources use `svc_layer1_resolve_provider_sources(...)` rather than the country regulatory-source resolver.
- `svc_layer1_resolve_provider_by_identifier(...)` resolves an existing canonical Provider from a verified identifier without creating identity.
- The redundant request-JWT claim guard was removed from `svc_layer1_apply_scoped_course_records(...)`; its database ACL remains service-role-only.
- Temporary Pilot automation uses a Vault-backed allowlisted execution queue with a bounded 30-second internal HTTP timeout.
- Browser roles cannot operate the Pilot queue or execute the Course reconciliation RPC.

## Current blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

The proven identity pattern is now repeatable, but Ontario and Canada-wide first-party Course coverage is incomplete. Full-source and partial-source coverage must remain explicitly distinguished.

## Immediate execution

1. Continue machine-readable first-party Course adapters across the remaining 21 mapped Ontario public colleges.
2. Prioritise official programme listings that publish stable institutional programme codes.
3. For sources blocked by CDN/browser protections, queue a browser/API-specific adapter instead of introducing brittle scraping.
4. Preserve deterministic UUIDv5 identity and run APPLY/idempotency/integrity UAT for every accepted source.
5. Join Course identities to Ontario APS/MTCU/CIP validation metadata only where deterministic joins are proven.
6. Broaden Canadian provincial/institutional coverage after Ontario reaches an accepted coverage threshold.

## Gate state

**CA Gate B remains ACTIVE/BLOCKED. The identity architecture and first three institutional source patterns are production-proven; coverage is the remaining blocker.**
