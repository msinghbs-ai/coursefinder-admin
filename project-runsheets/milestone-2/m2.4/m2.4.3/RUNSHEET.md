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
