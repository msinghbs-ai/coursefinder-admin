# M2.4.4 Follow-ups

| ID | Origin | Item | Status |
|---|---|---|---|
| M244-FU-001 | M2.4 carry-forward | Reconcile Layer 1/2/3 housekeeping and retention boundaries. | COMPLETE |
| M244-FU-002 | M2.4 carry-forward | Reconcile cross-layer scheduling/recheck orchestration and duplicate-work prevention. | COMPLETE |
| M244-FU-003 | M2.4 carry-forward | Verify stuck/stale/provider/model/storage/budget alert coverage. | COMPLETE — no invented storage threshold |
| M244-FU-004 | A14 | Reconcile provider/model telemetry continuity across operational paths. | COMPLETE |
| M244-FU-005 | Documentation | Reconcile Guides, Runbooks, release state and troubleshooting. | COMPLETE |
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


## Implementation reconciliation — 30 August 2026

- **M244-FU-001 COMPLETE:** L1 45m/live-heartbeat exclusion; L2 provider/orphan/batch policy windows; L3 20m stale interpretation recovery. No duplicate recovery path and no governed Evidence/history deletion.
- **M244-FU-002 COMPLETE:** general/L1/L2 schedulers dedupe active targets; no queued/running L1–L3 refresh work at checkpoint. Historical blocked L3 and queued L4 human-resolution rows retained.
- **M244-FU-003 COMPLETE:** L1 and L2 alert coverage retained; L3 operator alert surface added through `layer3_ops_alerts`. Current L3 alert count is zero. Evidence storage observed at 6,248 objects / 3,781,700,044 bytes; no authoritative threshold exists, so none was invented.
- **M244-FU-004 COMPLETE:** active L2/L3 code paths retain A14 telemetry where vendor/runtime data exists; missing historical/vendor usage remains unavailable.
- **M244-FU-005 COMPLETE:** Runbook v1.8, Data Operations Guide v1.6 and PIM Admin Guide v1.22 created; migration-history alias and troubleshooting boundaries documented.
- **M244-FU-006 OPEN / NON-BLOCKING:** retain M2.4.3 Important Links/Important Dates timing-sensitive desktop flake/retry as hygiene evidence unless reproduced as a product defect.

Next gate is bounded integration desktop/mobile.

## A16 follow-ups — 30 August 2026

| ID | Origin | Item | Status |
|---|---|---|---|
| M244-FU-011 | A16 / A15 coverage | Produce explicit 60/60 AU/NZ international-student/admissions contact-channel dispositions from governed first-party Evidence; extraction/classification occurs in Layer 3. | ACTIVE |
| M244-FU-012 | A16 / Layer 4 | Implement governed field-level Layer 4 override ledger/effective-value resolution across editable platform fields. | ACTIVE |
| M244-FU-013 | A16 / Audit | Retain actor, time, before/after, reason, optional comment/Evidence, supersede/revert history for every L4 decision. | ACTIVE |
| M244-FU-014 | A16 / Publication | Implement publication as a separately role-gated, auditable Layer 4 decision rather than a normal editable boolean. | ACTIVE |
| M244-FU-015 | A16 / Security | Define editable/elevated/immutable field classes and prove server-side RBAC plus anonymous/insufficient-rank negative paths. | ACTIVE |

The pre-A16 final acceptance run remains evidence only and cannot close these follow-ups.
