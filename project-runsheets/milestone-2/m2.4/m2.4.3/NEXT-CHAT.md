# Next Chat — M2.4.4 Cross-layer Checkpoint Readiness

## Authoritative handoff

M2.4.3 is **CLOSED / PASS** under `CF-CHG-20260829-047`.

Accepted Pilot marker/head:
`96de9add3762a0594ebc371fba49d4d990ff4b45`.

Final acceptance:
- run `33286437795`;
- desktop governed PASS: 49 passed + 1 timing-sensitive M2.3 Important Links/Important Dates flake recovered on retry;
- mobile 50/50 PASS;
- both acceptance commit-status contexts success.

Corrective integration:
- marker `d1d5f78ab3673696845fedc96c1f467bd27b3e71`;
- run `33285703513`;
- desktop/mobile PASS.

Historical failed acceptance `33284867253` remains immutable evidence.

Final runtime/advisors:
- migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` present;
- Layer 3 Edges v5/v2/v9;
- source-pattern profile enabled/unpaused on exact accepted Nemotron model;
- housekeeping cron active;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

Current programme baselines:
- Master Project Plan `docs/coursefinder-master-project-plan-v1.77.md`;
- Running Build `docs/coursefinder-running-build-v2.77.md`;
- Database Architecture `docs/coursefinder-database-architecture-v2.10.44.md`;
- Admin/PIM Design Decisions `docs/coursefinder-admin-pim-design-decisions-v1.20.md`.

## Next gate

M2.4.4 Cross-layer Checkpoint is **NEXT / READY, NOT STARTED**.

Before material M2.4.4 execution:
1. reconcile current Admin/Pilot heads and runtime truth;
2. read PROJECT_INSTRUCTIONS, M2 Standing Instructions, A1–A15, REGISTER and latest baselines;
3. create/activate a dedicated M2.4.4 Change Control and runsheet if repository governance permits;
4. preserve the accepted Layer 1→2→3→4 authority chain, Evidence and A14 telemetry;
5. preserve A8/A10/A12/A13/A15 standing behaviour;
6. do not reopen M2.4.2 or M2.4.3 because carried non-blocking follow-ups remain;
7. keep RMIT 212 promotion BLOCKED and NZ L2 first-party enrichment DEFERRED unless separately authorised;
8. Production, broad Publication and Zoho cutover remain outside M2.4.4.

M2.4.4 focus from the current Master Plan:
- cross-layer housekeeping/scheduling;
- recheck/replay orchestration;
- recovery and alerts;
- documentation/operations reconciliation;
- pre-blackout acceptance.

Do not start Production cutover as part of M2.4.4.
