# CourseFinder Running Build v2.78

**Status:** M1 FROZEN / M2.1–M2.3 CLOSED-PASS / M2.4.0–M2.4.3 CLOSED-PASS / M2.4.4 ACTIVE  
**Date:** 30 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.77.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.78.md`  
**Active Change Control:** `CF-CHG-20260830-048`

## Accepted runtime entering M2.4.4

Pilot:
`msinghbs-ai/Coursefinder-Pilot@96de9add3762a0594ebc371fba49d4d990ff4b45`.

M2.4.3 final acceptance:
- run `33286437795`;
- desktop governed PASS, 49 passed + one recovered timing-sensitive inherited M2.3 UI flake;
- mobile 50/50 PASS;
- both status contexts success.

Runtime baseline:
- Layer 3 interpret v5 / JWT enforced;
- Layer 3 provider-control v2 / JWT enforced;
- source-pattern benchmark v9 / governed nonce;
- source-pattern profile enabled/unpaused on exact accepted Nemotron model;
- Layer 3 housekeeping cron every 15 minutes;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

## Active M2.4.4 work

CF-CHG-20260830-048 governs:
- cross-layer housekeeping and retention;
- scheduling/rechecks;
- replay/recovery/idempotency;
- alerts/thresholds;
- A14 telemetry continuity;
- operator troubleshooting visibility;
- documentation/handover;
- staged UAT through final pre-blackout acceptance.

## Boundaries

No Production cutover, broad Publication, Website/Zoho cutover, RMIT 212 promotion or deferred NZ L2 first-party enrichment is authorised.

Current DB Architecture remains v2.10.44.  
Current Admin/PIM Design Decisions remain v1.20.
