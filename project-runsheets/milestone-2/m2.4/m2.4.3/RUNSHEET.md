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
