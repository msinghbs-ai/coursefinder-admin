# Coursefinder Admin Guide v1.4

## Layer 1 operational control
Layer 1 regulatory runs are executed as tracked Pipeline Jobs. Platform Admin starts a run from Settings > Regulatory Sources. The UI should treat the Worker request as job submission, not as a long synchronous transaction.

Operational sequence:
1. Platform Admin starts a dry-run/apply.
2. Worker creates a regulatory_sync Pipeline Job and returns the Job ID immediately.
3. Worker continues source fetch, evidence capture, parsing and reconciliation in the background.
4. Settings polls the authorised job-status contract until Completed or Failed.
5. Result metrics are rendered from the persisted Pipeline Job result and remain recoverable after navigation or refresh.

This prevents browser/network timeouts from being interpreted as catalogue failures. Pipeline Jobs remain the authoritative runtime record.

## AU CRICOS controlled UAT
The deterministic 100-record control has passed reconciliation and idempotency at the catalogue level. The first successful apply created 2 CRICOS providers and 95 CRICOS courses, linked 5 existing courses and produced 0 conflicts. The repeated deterministic batch did not create duplicate regulator-derived courses.

Full AU ingestion remains disabled until asynchronous control-flow UAT and CRICOS Locations/Course Locations reconciliation are complete.
