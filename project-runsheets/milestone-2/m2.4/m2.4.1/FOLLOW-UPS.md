# M2.4.1 — Follow-ups

## P0 — active gate

1. Confirm Pilot `b58d49294f6b9ad1921443d52c8641bbc2df35e6` frontend build and minimal deployed Stage A result.
2. If Layer 1 Stage A fails, fix only the deterministic Layer 1 failure and rerun targeted; do not expand waits or launch unrelated suites.
3. Prove both AU CRICOS and NZ NZQA source validation/count discovery, including unapproved-domain and malformed/unavailable-source negatives.
4. Prove warn/block variance decisions before APPLY and no unattended execution when verification/variance state is blocked.
5. Complete the existing scheduler → Layer 1 governed recheck bridge using the accepted M2.3 refresh policy/request substrate; do not create a second scheduler model.
6. Prove queue lifecycle, duplicate/concurrent protection, heartbeat/stuck detection, retry/resume and cumulative reconciliation with isolated/rollback-safe operational runs.
7. Prove hash/no-change replay produces no duplicate canonical rows, no unnecessary duplicate Evidence and no unnecessary downstream work.
8. Prove transient housekeeping removes only expired execution state and cannot remove governed Evidence, source versions or canonical/audit lineage.

## P1 — before Stage B

- Synchronise all live M2.4.1 Supabase migrations and Edge function source into `Coursefinder-Pilot` repository truth.
- Re-run Security Advisor and Performance Advisor after final database/API shape.
- Reconcile browser RPCs, SECURITY DEFINER/private helpers, grants/RLS, rank negatives, anonymous paths, Edge auth, Storage/Evidence and error leakage.
- Update PIM Admin Guide, Operations Runbook and troubleshooting/bug-reporting guidance to actual deployed behaviour.
- Update release notes for any further browser-facing change.
- Record operational timings, payload sizes and AU/NZ throughput.

## Inherited observations from invalid broad targeted run

The failed `32962485153` run also surfaced Layer 2 platform/provider/trial navigation/data failures. These are not Stage A blockers for M2.4.1 because they were unrelated suites incorrectly included in targeted validation. Preserve their evidence for Stage B/acceptance reconciliation; do not mask them with longer waits.

## Stage progression

- Stage A: minimal Layer 1 affected tests, desktop during active development; responsive/mobile checks only when the Layer 1 slice directly changes responsive behaviour.
- Stage B: one bounded affected regression on a green candidate, desktop + mobile, covering Layer 1, Evidence, Jobs/Runs, Data Quality, security/authority/replay/recovery/scheduling and relevant performance.
- Stage C: exactly one nominated frozen SHA complete deployed permanent desktop/mobile matrix. Any code/runtime change after nomination invalidates the candidate.
