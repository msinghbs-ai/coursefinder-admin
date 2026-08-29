# M2.4.3 Current State

**Status:** ACTIVE — A15 TARGETED PASS / COHORT ROLLOUT IN PROGRESS
**Updated:** 29 August 2026

## A15
- Change: CF-CHG-20260829-046.
- Target cohort: 52 AU + 8 NZ Provider profiles.
- UQ accepted proof: 8 first-party International Regional Manager territory assignments.
- Provider detail UI: implemented.
- PIM release: v2.15.10.
- Apollo adapter: implemented, Pilot credential absent; non-blocking.
- Current advisors: Security 135 INFO/0 WARN/0 ERROR; Performance 171 INFO/0 WARN/0 ERROR.
- Corrected targeted UAT: PASS `33227565016`.

## Quality rules
- first-party > governed manual > licensed enrichment;
- actionable row requires institutional email/phone or named person + territory;
- generic/noisy rows are rejected, retained historically;
- no personal-email/phone reveal from licensed enrichment;
- contact data cannot mutate Layer 1 identity/Search/Publication.

## Active rollout
Continue sequential nonce-backed batches until no Provider contact profile remains with `last_run_at is null`.


## A15 full-cohort freeze checkpoint

- 60/60 governed AU/NZ contact profiles attempted and successful.
- 0 current contact-profile errors.
- 31 current accepted contacts across 11 Providers.
- 17 territory-assigned current contacts.
- 30 contacts with institutional email; 18 with public work phone.
- 45 rejected historical/noisy observations retained for provenance.
- Direct HTTP: 319 attempts, 154 success, 165 failure/fallback, avg 599.41 ms, p95 1,944.5 ms, 0 vendor units.
- Firecrawl: 107/107 success, 107 page units, avg 3,996.84 ms, p95 7,132.2 ms.
- worker: `provider-contact-discover-scheduled-v1.3.2` / Edge v15.
- Wellington 410, CQU 403 and Bond Evidence-collision recovery cases are all terminal PASS.
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 171 INFO / 0 WARN / 0 ERROR.
- Apollo remains configuration-blocked because `APOLLO_API_KEY` is absent; no personal email/phone reveal is requested.
- remaining A15 gate: post-freeze deployed UAT chain and closure documentation.
