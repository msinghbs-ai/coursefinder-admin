# CourseFinder Master Project Plan v1.78

**Issued:** 30 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.77  
**Programme position:** M1 FROZEN; M2.1–M2.3 CLOSED/PASS; M2.4 ACTIVE; M2.4.0–M2.4.3 CLOSED/PASS; M2.4.4 ACTIVE

## 1. Programme position

M2.4.3 is CLOSED/PASS under `CF-CHG-20260829-047`.

M2.4.4 Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance is now ACTIVE under `CF-CHG-20260830-048`.

Accepted starting Pilot runtime:
`msinghbs-ai/Coursefinder-Pilot@96de9add3762a0594ebc371fba49d4d990ff4b45`.

M2.4.3 final acceptance `33286437795` remains the entry baseline: desktop governed PASS with one recovered timing-sensitive inherited M2.3 UI flake, mobile 50/50 PASS.

## 2. M2.4.4 objective

Reconcile and mature cross-layer operations after accepted per-layer maturity:
- housekeeping/retention;
- scheduling/recheck orchestration;
- replay/recovery/idempotency;
- alerts and operational thresholds;
- A14 telemetry continuity;
- operator troubleshooting visibility;
- Guides/Runbooks/release-state reconciliation;
- bounded integration and final pre-blackout acceptance.

## 3. Authority model

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 governed AI Evidence interpretation → Layer 4 human resolution`.

M2.4.4 must not blur these boundaries. Search, Publication, Website and Zoho remain downstream governed consumers.

## 4. Entry constraints

- A1–A15 remain standing where applicable.
- A15 contact intelligence remains frozen CLOSED/PASS.
- RMIT frozen 212-record promotion remains BLOCKED.
- NZ first-party Layer 2 Course enrichment remains DEFERRED.
- Apollo credential remains configuration-blocked/non-blocking.
- Production cutover, broad Publication, Website release and Zoho cutover remain out of scope.
- 16–30 September 2026 remains the planned delivery blackout unless separately authorised.

## 5. M2.4.4 closure condition

Close only after:
1. cross-layer runtime inventory/reconciliation;
2. genuine gaps corrected without authority/security/Evidence regression;
3. alerts/telemetry/documentation reconciled;
4. bounded integration PASS desktop/mobile;
5. one final desktop/mobile acceptance PASS;
6. final advisor/runtime/head/documentation reconciliation.

## 6. Current architecture/design baselines

- DB Architecture: `docs/coursefinder-database-architecture-v2.10.44.md`;
- Admin/PIM Decisions: `docs/coursefinder-admin-pim-design-decisions-v1.20.md`.

These remain current until M2.4.4 accepts a structural/design change.
