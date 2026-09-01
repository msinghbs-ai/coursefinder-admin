# M2.5 CURRENT STATE

**Status:** ACTIVE / READINESS — PLATFORM FOUNDATION IMPLEMENTED; PRODUCTION PROVISIONING BLOCKED  
**Updated:** 1 September 2026  
**Production Change Control:** `CF-CHG-20260901-049`  
**Platform foundation Change Control:** `CF-CHG-20260901-051`  
**Layer 2 corrective Change Control:** `CF-CHG-20260901-052`

## Accepted entry baseline

M2.4 is CLOSED/PASS and must not be reopened.

Accepted Pilot:
`95f2991e97e76e644bd74f73512b8bf2725fd4b7`

Final M2.4.4 acceptance:
- build `33468512538` PASS;
- UAT `33468512515` PASS;
- desktop 75 passed;
- mobile 76 passed;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR.

## Live repository/runtime reconciliation

Pilot repository progressed after the frozen M2.4 acceptance only for M2.5 work.

Current M2.5 Pilot source head at this checkpoint:
`9fa8f590c8370bf600f1495794f9205fabbdf8a7`.

Admin UI version: **v2.15.15**.

Deployed M2.5 migrations:
- `20260901060826 m2_5_platform_operations_maturity_foundation`;
- `20260901061041 m2_5_capacity_integrity_alert_classification`;
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`;
- `20260901062200 m2_5_layer2_run_observability_correction`.

Post-change advisors:
- Security: 146 INFO / 0 WARN / 0 ERROR;
- Performance: 174 INFO / 0 WARN / 0 ERROR.

## Supabase inventory

Visible organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

Visible CourseFinder projects:
- `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / Mumbai `ap-south-1` / ACTIVE_HEALTHY;
- `coursefinder-demo` / `gfryvshbeptxwbzjomhe` / `ap-southeast-2` / ACTIVE_HEALTHY;
- no CourseFinder Production Supabase project.

No billable Production resource was created or renamed.

## Platform maturity foundation now deployed

Under CF-051:
- environment-specific source/capability lifecycle gate;
- scraper acquisition-provider Pilot/Production gate;
- AI model/task-profile Pilot/Production gate;
- daily capacity policy/observation and secured reporting;
- class-based retention policy with dry-run only;
- permanent platform UAT catalogue;
- serving/ingestion/concurrency workload profiles;
- reversible Layer 4 operational/publication/Search/quarantine blocking ledger.

Current reconciled Pilot state:
- AU CRICOS + NZ NZQA Provider/Course capabilities = Pilot UAT PASS;
- Direct HTTP + Firecrawl = Pilot-qualified in the new environment gate;
- three benchmark-PASS AI profiles = Pilot-qualified;
- Production source/scraper/AI gate rows = 0.

## Capacity / storage snapshot

Current Pilot:
- logical DB ~611 MB;
- cumulative PostgreSQL temp activity ~216.6 GB / ~51.1k temp files;
- Evidence Storage 8,623 objects / ~4.62 GB;
- Evidence planning utilisation ~7.18% of the existing 60 GiB planning envelope;
- largest relation remains `search.course_documents` at ~155 MB.

Current HIGH platform state is Evidence-lineage integrity, not storage exhaustion:
- 205 Storage objects lack a current `pipeline.evidence_artifacts.storage_path` match;
- 18 regulatory Evidence artifact rows lack a current Storage-object match.

No cleanup is authorised until this lineage is classified.

Backup/PITR status remains `platform_api_required` in DB telemetry and must be reconciled through Supabase platform metadata.

## Layer 2 scheduled-work reconciliation

Historical M2.4.4 closure recorded 42 Courses as scheduled remainder.

Live request `1bb1504d-7bad-42d9-b059-4adeaf9118c7` is now terminal `completed`:
- total queueable: 261;
- completed: 42;
- failed: 219;
- scope rows marked missing URL: 6,562;
- schedule_remaining remains recorded in historical request metadata.

Therefore M25-FU-006 is no longer “42 still waiting”; failure/root-cause review is a separate Pilot operations follow-up and does not reopen M2.4.

### CF-052 observability correction

The operator-visible lineage defect is corrected without reopening M2.4:
- terminal parent projection retains completed/failed child Jobs and Evidence;
- current VIC terminal lineage proves **261 child Jobs** and **783 Evidence artifacts**;
- Recent acquisition attempts and Recent managed runs now display timestamps;
- active parent work is separated from the latest terminal production run;
- retry-window no-op qualification checks return `qualification_waiting` instead of implying new production work;
- bounded live VIC check `c876a8fb-5f03-4433-85ab-5af7e96cee63` created **0 production wave requests** and **0 Course Jobs**;
- post-action read failures are no longer silently swallowed.

## CI/UAT state

Permanent source-contract suites:
- `tests/uat/m2-5-platform-readiness-deployed.spec.mjs`;
- `tests/uat/m2-5-layer2-run-observability-deployed.spec.mjs`.

`.github/workflows/deployed-uat.yml` includes both in integration/acceptance and provides targeted routing.

Platform-readiness targeted deployed UAT `33476711758` / job `99757413769` PASS on `dac23d68e6df230bc30c306fa7b61e720ecb431c`.

CF-052 targeted deployed UAT `33477539721` / job `99760830965` PASS: **2 passed / 0 failed** on Chromium desktop. Targeted tier is desktop-only. Wider Production integration/acceptance is not implied.

## Production decision remains blocked

Production project creation still requires explicit:
1. organisation approval;
2. Production region;
3. quoted Supabase project cost approval.

Do not promote or rename Pilot.

## Current programme/design baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.81.md`
- Running Build: `docs/coursefinder-running-build-v2.81.md`
- Platform maturity design: `docs/coursefinder-platform-maturity-design-v1.0.md`
- DB Architecture: `docs/coursefinder-database-architecture-v2.10.45.md`
- Admin/PIM decisions: `docs/coursefinder-admin-pim-design-decisions-v1.25.md`
- UAT/performance: `docs/coursefinder-uat-performance-baseline-v1.1.md`
- M2.5 operations: `docs/coursefinder-m2-5-platform-operations-readiness-v1.0.md`
