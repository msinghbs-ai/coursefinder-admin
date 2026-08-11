# Coursefinder Layer 1 AU CRICOS Apply / Idempotency UAT v1.0

## Scope
Controlled Australia CRICOS Layer 1 validation using the deterministic first 100 course records.

## Verified results
- Dry-run parsed 26,738 CRICOS course records and selected 100.
- First controlled APPLY completed successfully.
- First APPLY reconciliation: 2 providers created, 0 providers linked, 95 courses created, 5 courses linked, 0 conflicts, 100 selected records.
- Current catalogue state after the later idempotency rerun remains 100 CRICOS course registrations, 95 regulator-created CRICOS courses and 2 regulator-created CRICOS providers.
- No duplicate regulator-created courses were introduced by the rerun.
- One later rerun Worker request terminated with HTTP 503 after the database reconciliation stage and left the Pipeline Job row in Running. The row was operationally closed as failed after verifying stable catalogue counts. This is a control-plane/runtime issue, not a catalogue idempotency failure.

## Decision
AU 100-record catalogue reconciliation is considered functionally idempotent for the tested deterministic batch. The synchronous browser-to-Worker request pattern is not considered production-safe and is being replaced with asynchronous job execution and UI polling before wider ingestion.

## Follow-up
1. Deploy async Layer 1 job execution and polling.
2. Validate UI persistence across navigation/refresh.
3. Add CRICOS Locations and Course Locations.
4. Repeat controlled AU ingestion using the async execution path.
5. Only then unlock full AU Layer 1 ingestion.
