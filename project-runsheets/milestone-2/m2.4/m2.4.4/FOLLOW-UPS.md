# M2.4.4 Follow-ups

| ID | Origin | Item | Status |
|---|---|---|---|
| M244-FU-001 | M2.4 carry-forward | Reconcile Layer 1/2/3 housekeeping and retention boundaries. | ACTIVE |
| M244-FU-002 | M2.4 carry-forward | Reconcile cross-layer scheduling/recheck orchestration and duplicate-work prevention. | ACTIVE |
| M244-FU-003 | M2.4 carry-forward | Verify stuck/stale/provider/model/storage/budget alert coverage. | ACTIVE |
| M244-FU-004 | A14 | Reconcile provider/model telemetry continuity across operational paths. | ACTIVE |
| M244-FU-005 | Documentation | Reconcile Guides, Runbooks, release state and troubleshooting. | ACTIVE |
| M244-FU-006 | M2.4.3 acceptance | Track recovered timing-sensitive M2.3 Important Links/Important Dates desktop flake as non-blocking UAT hygiene evidence. | OPEN / NON-BLOCKING |
| M244-FU-007 | A15 | Apollo credential remains absent. | BLOCKED / CONFIGURATION / NON-BLOCKING |
| M244-FU-008 | Layer 1 governance | Canonical Provider website source corrections discovered by A15. | OPEN / NON-BLOCKING |
| M244-FU-009 | RMIT | Frozen 212-record canonical promotion. | BLOCKED / SEPARATE AUTHORITY |
| M244-FU-010 | NZ L2 | First-party Course enrichment. | DEFERRED / SOURCE QUALIFICATION |


## Entry reconciliation checkpoint — 30 August 2026

- M244-FU-001 — Layer 1/2/3 housekeeping reconciliation: **IN PROGRESS**.
  - first material gap found and corrected: stale legacy Layer 1 `regulatory_sync` `pipeline.jobs` recovery;
  - Pilot commit `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`;
  - migration `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery`;
  - exactly one stale job recovered; zero governed Evidence/history deletion;
  - post-change advisors unchanged at 135 Security INFO / 169 Performance INFO, 0 WARN/ERROR.
- Continue M244-FU-001 by reconciling Layer 2 batch/provider-attempt recovery and Layer 3 stale-execution recovery as one cross-layer policy map before adding any further mechanism.
