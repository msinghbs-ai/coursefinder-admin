# Coursefinder Pilot to Production Project Plan v1.8

## Current Position
- Phase 0 Runtime: Complete.
- Phase 0A Security hardening: Complete.
- Phase 1 PIM/Admin UI: In progress.
- Phase 1A Regulatory Settings: Complete.
- Phase 3 Layer 1 Worker: In progress — AU CRICOS 100-record reconciliation and idempotency passed; async runtime hardening is now the active gate.

## Phase 3 Gate Status
Passed:
- official source resolution from Settings;
- CRICOS CSV acquisition;
- private evidence + SHA-256 hashing;
- 26,738 course parsing;
- 100-record dry-run;
- 100-record controlled APPLY;
- deterministic idempotency test with no duplicate regulator-created courses.

Active remediation:
- replace long synchronous Worker request with queued/background execution and UI polling;
- persist latest Layer 1 result across navigation/refresh;
- guard course-detail RPC against missing IDs.

## Next Steps
1. Deploy async Layer 1 execution and polling.
2. Re-run 100-record AU control through async path.
3. Add CRICOS Locations and Course Locations and reconcile Campuses/course-campus relationships.
4. Run full AU Layer 1 ingestion with evidence/change telemetry.
5. Rebuild Search Projection.
6. Add remaining country adapters using the same Layer 1 framework.
7. Resume canonical catalogue expansion and Layer 2 acquisition.

Full AU ingestion remains gated until async control-flow UAT and campus/location reconciliation are complete.
