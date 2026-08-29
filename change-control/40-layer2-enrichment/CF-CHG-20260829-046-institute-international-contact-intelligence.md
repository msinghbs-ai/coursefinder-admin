# CF-CHG-20260829-046 — Institute International Contact Intelligence

**Status:** CLOSED / PASS — FINAL ACCEPTANCE DESKTOP+MOBILE PASS
**Category:** 40-layer2-enrichment
**Initiated:** 29 August 2026
**Origin chat/workstream:** M2.4.3 addendum — institute manager / international contact details
**Owner:** M2.4.3 workstream
**Change class:** schema/enrichment/privacy/UI/UAT/operations

## Trigger

User requested Provider/Institute detail to include institute manager / international-course contact details, deterministic scraping of university International/Regional Manager contact pages across AU/NZ, and optional licensed professional enrichment/job-title change monitoring.

## Governing design

A15 introduces **international contact intelligence** without creating a new identity authority.

1. First-party university pages are preferred and stored as governed Layer 2 Evidence-backed observations.
2. Licensed professional enrichment (for example Apollo/ZoomInfo-equivalent APIs) is secondary context and must never overwrite first-party university-published contact facts.
3. LinkedIn HTML scraping is not authorised. Any LinkedIn-derived field must arrive through a licensed/authorised enrichment provider or a first-party university page that links to the profile.
4. Personal-email/mobile reveal is disabled by default. The initial provider adapter searches title/domain and stores professional profile/title context only.
5. Provider/Course identity, Search and Publication authority are unchanged.
6. Every contact retains source class, source URL/provider, observed/verified timestamps, territory text/codes, and Evidence where available.
7. Job-title/contact changes create explicit watch events rather than silently replacing history.
8. A14 telemetry extends to contact discovery/enrichment attempts: provider, calls, units/credits where available, latency, cost where available, outcome and timestamps.

## Initial target cohort

Derived from governed catalogue rather than a hard-coded list:
- AU: 52 providers with governed website and University naming;
- NZ: 8 providers with governed website and University/Te Pūkenga naming;
- total initial profiles: 60.

## UI

Provider detail receives a dedicated **International contacts** section above generic object dumps:
- name / team;
- job title;
- territory/market assignment;
- work email / work phone when first-party or licensed business-contact data permits;
- source class badge;
- source/provider link;
- observed/verified freshness;
- Evidence link for first-party scrape;
- recent title/contact-change signals.

Course detail may later consume Provider contact context read-only, but A15 first acceptance is Provider-detail only.

## Acceptance

Targeted automated UAT must prove:
- profile seed count by AU/NZ;
- anonymous/direct-table negatives;
- Provider detail read projection;
- first-party precedence over licensed enrichment;
- no personal-email/phone reveal in the Apollo search adapter;
- change-watch event creation;
- browser Provider blade rendering;
- Security/Performance Advisors no new WARN/ERROR;
- no canonical/Search/Publication mutation.


## Implementation checkpoint — 29 August 2026

Pilot implementation refs:
- `190a1e9d6c8ec7f8eea6c6c5692e778233e030cd` — private contact schema + Provider-detail projection;
- `5bc47a2291add9cc1c14e168d108d49de2fa9814` — nonce allowlist;
- `88be2c7c1c6a16d9006e357db7a319e7f6b443cd` — service-role bridge;
- `938a5440f2000593bafc5c9d267a19369731198e` — Apollo adapter through service bridge;
- `4f2b36ba2b3c26549f519322513ca7d37348723b` — structured table precedence;
- `0269c59443f46abd07cc88dda4bde94106dbe959` — governed Provider origins/subdomains;
- `bc87d580f6924b53f47028b199122b64d393ee44` — meaningful contact-change semantics;
- `305fcb1fe6246aa418ae1877a1b79748f2199307` — transport URL normalization + provider lookup;
- `5b8ad0717076a55348f8054a43d943bfa8ddcf45` — governed Firecrawl fallback + A14-style acquisition telemetry;
- `24d5ddc68c3f7bef0cf86debca83bd291a1400ea` — Provider blade International contacts;
- `e0c32e0b8a21847be1ba1756d2ff3eea4c41091e` — PIM Admin v2.15.10 release notes;
- `80ee906c91c09026586bd717e7c41235b679dbfa` — permanent A15 deployed UAT;
- `1c6fa1992a8068b408df1ef9bcb7cb59a535bf2c` — A15 UAT tier wiring.

Live evidence:
- initial target cohort: 52 AU + 8 NZ = 60 governed contact profiles;
- UQ final structured proof: 8 current first-party regional-manager territory rows with institutional emails and Evidence;
- targeted deployed browser UAT: PASS, run `33221965310`;
- initial noisy UQ probes retained as rejected/non-current historical Evidence rather than deleted;
- ACU direct HTTP 403 and three malformed NZ canonical website values discovered during rollout and handled without Layer 1 overwrite.

Open before closure:
- complete and reconcile the 60-profile first-party rollout;
- verify Firecrawl fallback proof on blocked sites;
- verify Apollo credential/configuration and bounded no-reveal search if configured;
- run Security/Performance Advisors;
- integration + final acceptance per M2 execution discipline;
- close/update documentation and exact runtime refs.

## Runtime/security checkpoint — 29 August 2026

- Current A15 security advisor: 135 INFO / 0 WARN / 0 ERROR.
- Current A15 performance advisor: 171 INFO / 0 WARN / 0 ERROR.
- Apollo Pilot probe: configuration BLOCKED because `APOLLO_API_KEY` is not configured; probe confirmed `personal_email_requested=false` and `phone_requested=false`. This is non-blocking for first-party rollout.
- Current first-party worker after rollout efficiency hardening: `provider-contact-discover-scheduled-v1.2.3` / Edge v9.


## Full AU/NZ cohort rollout checkpoint — 29 August 2026

A15 first-party AU/NZ contact rollout is now terminal across the governed cohort.

Coverage:
- AU: 52/52 profiles attempted; 52 successful; 0 current errors.
- NZ: 8/8 profiles attempted; 8 successful; 0 current errors.
- total: 60/60 profiles attempted/successful.

Current accepted observations:
- AU: 27 current contacts across 8 Providers;
- NZ: 4 current contacts across 3 Providers;
- total: 31 current contacts across 11 Providers;
- 17 current contacts carry explicit territory/market assignments;
- 30 current contacts carry institutional email;
- 18 current contacts carry public work phone;
- 45 historical/noisy observations are retained as rejected rather than deleted.

Acquisition telemetry for A15 contact pages:
- Direct HTTP: 319 attempts; 154 succeeded; 165 failed/fell through; 0 vendor units; average 599.41 ms; p95 1,944.5 ms.
- Firecrawl: 107 attempts; 107 succeeded; 107 page units; average 3,996.84 ms; p95 7,132.2 ms.
- retained estimated per-request cash cost remains USD 0 because Firecrawl is subscription-backed with subscription price not recorded; vendor units remain the authoritative consumption metric.

Recovery evidence:
- Wellington: stale canonical domain/root produced HTTP 410. A15 transport-only entry point moved to the live `wgtn.ac.nz` International Office page; Direct HTTP 410 now qualifies for governed Firecrawl fallback. Recovery PASS.
- CQU: historical direct HTTP 403 recovered through governed Firecrawl fallback. Recovery PASS with 0 accepted contacts.
- Bond: prior Evidence uniqueness error did not recur under serialized recovery; recovery PASS with 0 accepted contacts.
- Layer 1 canonical Provider website values were not silently rewritten; stale/malformed canonical website corrections remain separate Layer 1/source-governance follow-ups.

Current first-party worker:
- `provider-contact-discover-scheduled-v1.3.2`;
- deployed Edge version 15;
- Direct HTTP preferred;
- governed fallback conditions include 403, 410, 429, 5xx and bounded network/timeout classes.

Post-rollout advisors:
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 171 INFO / 0 WARN / 0 ERROR.

Apollo:
- adapter implemented;
- `APOLLO_API_KEY` remains absent in Pilot;
- personal email reveal disabled;
- phone reveal disabled;
- licensed enrichment remains configuration-blocked/non-blocking.

A15 remains ACTIVE until the post-freeze targeted/integration/final browser acceptance chain is complete.


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


## Final acceptance gate nomination — 29 August 2026

Post-freeze validation is now reconciled through bounded integration:
- frozen functional A15: `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- permanent final-suite inclusion: `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`;
- final corrected integration candidate: `70bd290154b7d5f16d8f04569b90b6074a239611`;
- bounded integration run `33240736705`: desktop PASS / mobile PASS.

Final acceptance has been nominated with Pilot marker:
- `f6741a0cc29c5fea236e85b9042f8079762c6993`.

CF-CHG-20260829-046 remains ACTIVE until final acceptance desktop/mobile is terminal PASS and runtime/docs/advisors reconcile. No broad cohort rerun, Search mutation, Publication mutation, LinkedIn HTML scraping or Layer 1 identity change is authorised by this nomination.


## Closure — 29 August 2026

CF-CHG-20260829-046 is CLOSED / PASS.

Accepted functional/data baseline:
- functional contact freeze: `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- 52/52 AU + 8/8 NZ = 60/60 profiles successful;
- 0 current profile errors;
- 31 current first-party contacts across 11 Providers;
- 17 current territory/market-assigned contacts;
- 30 contacts with institutional email;
- 18 contacts with public work phone;
- 45 rejected/noisy historical observations retained.

Accepted runtime/UAT:
- permanent A15 final-suite inclusion: `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`;
- bounded integration: `33240736705` desktop/mobile PASS;
- final accepted Pilot: `f6741a0cc29c5fea236e85b9042f8079762c6993`;
- final acceptance: `33251745111`;
- workflow resolved `acceptance` tier with 17 permanent suites;
- 48/48 chromium-desktop PASS;
- 48/48 chromium-mobile PASS;
- A15 Provider blade/Evidence test PASS on both;
- A15 private-table/non-revealing licensed-search boundary PASS on both.

Accepted presentation/consumption boundary:
- contact intelligence is a Layer 2 Evidence-backed Provider enrichment capability;
- primary showcase is Provider detail → International contacts;
- Evidence/source/freshness remains directly traceable from the Provider contact presentation;
- Course detail may consume Provider contact context read-only when explicitly designed, but contact data must not be represented as Course truth;
- Layer 3 may interpret governed Layer 2 contact Evidence for bounded operational intelligence/change analysis, but cannot become source authority;
- Layer 4 may surface human review/resolution where a contact change or ambiguity needs an operator decision;
- Search/Public website and Zoho publication/consumption remain separate governed admission/API decisions and are not authorised by this closure.

Non-blocking carry-forward:
- Apollo credential/configuration and licensed enrichment;
- durable VU/Otago/Wellington reconciliation rules across parser refresh;
- Firecrawl subscription cash-cost mapping;
- Layer 1 correction of stale/malformed Provider website values;
- contact-quality regression metrics.

No broad cohort rerun is required for closure.
