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


## A15 acceptance-suite inclusion

Permanent A15 UAT is now included in all relevant deployed validation tiers:
- targeted A15 change validation;
- bounded integration desktop/mobile;
- final acceptance desktop/mobile.

Pilot workflow contract commit: `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`.

This closes the prior governance gap where A15 was present in targeted/integration but omitted from the acceptance suite list.


## A15 integration nomination

A15 integration candidate `8a49a2652758784926d42bc6114ceb4270d2cdaa` is nominated against:
- functional freeze `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- acceptance-suite workflow fix `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`.

Pilot must remain frozen until the integration desktop/mobile matrix is terminal.


## A15 bounded integration correction — 29 August 2026

Frozen first-party rollout remains:
- 52/52 AU profiles successful;
- 8/8 NZ profiles successful;
- 60/60 total successful;
- 0 current profile errors;
- 31 current first-party contacts across 11 Providers;
- 17 current territory/market-assigned contacts;
- 45 rejected/noisy historical observations retained.

First bounded integration:
- candidate `8a49a2652758784926d42bc6114ceb4270d2cdaa`;
- run `33230112004`;
- desktop PASS;
- mobile FAIL;
- sole failure: inherited A13 `evidence_detail` HTTP 500 remained unrecovered on both test attempts.

Diagnosis:
- direct role-checked `security.admin_evidence_detail` remained logically correct;
- 25-call proof before hardening: 25/25 success, avg ~375 ms, max ~7.2 s;
- `security.admin_evidence_related_visual` searched `pipeline.layer2_provider_attempts` by raw/html/screenshot Evidence IDs without indexes.

Corrective performance hardening:
- added partial indexes for `raw_evidence_id`, `html_evidence_id`, and `screenshot_evidence_id`;
- no read semantics, authority or UAT assertion changed;
- existing bounded 5xx-only browser retry remains unchanged;
- 25-call proof after hardening: 25/25 success, avg ~164 ms, p95 ~134 ms, max ~2.04 s;
- Performance Advisor improved to 170 INFO / 0 WARN / 0 ERROR;
- Security Advisor remains 135 INFO / 0 WARN / 0 ERROR.

Post-freeze Wellington transport proof was reconciled back to the accepted first-party team record:
- International Student Experience;
- `international-support@vuw.ac.nz`;
- `+64 4 463 5350`;
- source `https://www.wgtn.ac.nz/students/support/international/contact-us`.

Corrected targeted UAT on `f3cf5001e5ac506d5edbac324bfbf25d706d4858`: PASS, run `33240216793`.

Corrective bounded integration candidate:
- `1197099ccedacd5d7946e45400c7bb36fe1dad26`;
- desktop/mobile result pending at this checkpoint.

Do not nominate final acceptance until this exact corrective integration candidate is terminal PASS on both desktop and mobile.
