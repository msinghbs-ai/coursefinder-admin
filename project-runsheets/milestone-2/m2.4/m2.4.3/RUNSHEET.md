# M2.4.3 Runsheet — Layer 3 AI Operations Maturity + A15 Contact Intelligence

**Status:** ACTIVE
**Updated:** 29 August 2026
**Standing governance:** PROJECT_INSTRUCTIONS / M2 STANDING / A1–A15
**Active Change Control:** CF-CHG-20260829-046

## Accepted input baseline
- M2.4.2 CLOSED/PASS.
- Accepted Pilot baseline before A15: `093010fada8391c93626b59e59c678064f4961c3`.
- A14 telemetry standing.
- RMIT canonical promotion remains independently blocked.
- Layer 3 source-pattern benchmark remains independently blocked.
- Search/Publication authority unchanged.

## A15 objective
Add governed Provider international recruitment contact intelligence:
- first-party public professional contacts;
- territory assignments;
- Evidence/freshness;
- optional licensed professional enrichment;
- job-title/contact-change monitoring;
- Provider blade presentation;
- no Layer 1/Search/Publication authority expansion.

## Current implementation
- 60 AU/NZ Provider contact profiles seeded from governed catalogue.
- private contact schema + service-role RPC bridges deployed.
- first-party discovery worker deployed and iteratively hardened.
- Direct HTTP → Firecrawl fallback with provider telemetry.
- Apollo adapter deployed but credential not configured.
- Provider blade International contacts implemented.
- PIM Admin v2.15.10.
- targeted deployed A15 UAT corrected and PASS: `33227565016`.
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 171 INFO / 0 WARN / 0 ERROR.

## Current rollout procedure
1. execute one nonce-backed batch at a time;
2. max normal batch: 3 Provider profiles;
3. do not overlap Firecrawl-backed batches;
4. inspect any non-zero contacts for deterministic quality;
5. reject noisy observations without deleting history;
6. retain zero-contact success as a valid outcome;
7. update coverage metrics at stable checkpoints.

## Remaining gate
- complete all governed profiles;
- reconcile contacts / zero-contact / source-limited/error outcomes;
- verify current worker and provider-unit telemetry;
- bounded integration desktop/mobile;
- final acceptance at the M2.4.3 checkpoint when broader Layer 3 scope is ready.


## A15 frozen rollout baseline

Cohort: 52 AU + 8 NZ = 60 profiles.
Terminal coverage: 60/60 successful, 0 current profile errors.
Current contact inventory: 31 contacts / 11 Providers.
Territory contacts: 17.
Rejected provenance history: 45 observations.

Runtime:
- `provider-contact-discover-scheduled-v1.3.2` / Edge v15;
- Direct HTTP first;
- Firecrawl fallback for governed 403/410/429/5xx/network/timeout classes;
- no overlapping cohort batches;
- one-time nonce execution retained.

Provider telemetry:
- Direct HTTP 319 attempts; 154 succeeded; 165 failed/fell through; avg 599.41 ms; p95 1,944.5 ms.
- Firecrawl 107 attempts; 107 succeeded; 107 page units; avg 3,996.84 ms; p95 7,132.2 ms.

Post-freeze acceptance sequence:
1. targeted deployed A15 gate on frozen Pilot source;
2. bounded integration desktop/mobile;
3. final checkpoint acceptance only when current M2.4.3 governance permits;
4. close CF-CHG-046 only after docs/runtime/UAT/advisors reconcile.


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


## A15 final acceptance nomination — 29 August 2026

Third bounded integration candidate:
- Pilot marker `70bd290154b7d5f16d8f04569b90b6074a239611`;
- deployed run `33240736705`;
- chromium-desktop PASS;
- chromium-mobile PASS.

This clears the inherited A13 Evidence-detail mobile blocker without weakening Evidence, retry, authority, UAT or access-control semantics.

Final acceptance candidate:
- Pilot marker `f6741a0cc29c5fea236e85b9042f8079762c6993`;
- marker path `.github/m2-4-acceptance-candidate`;
- permanent A15 final-suite inclusion remains `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`.

Gate state:
- A15 first-party rollout: GO / FROZEN;
- A15 bounded integration: PASS;
- A15 final acceptance: NOMINATED / RUN PENDING;
- CF-CHG-20260829-046 remains ACTIVE until final desktop/mobile PASS and closure reconciliation.

Do not broad-rerun the 60-profile cohort and do not mutate Search/Publication while this final gate is outstanding.
