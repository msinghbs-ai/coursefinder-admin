# M2.5 NEXT CHAT — Production Readiness + Platform Maturity

Continue CourseFinder autonomously from repository/runtime truth. Do not rely on stale chat assumptions and do not reopen M2.4.

## Mandatory start

Read:
1. `PROJECT_INSTRUCTIONS.md`
2. `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`
3. `docs/coursefinder-master-project-plan-v1.81.md`
4. `docs/coursefinder-running-build-v2.81.md`
5. `change-control/70-security-platform/CF-CHG-20260901-049-m2-5-clean-production-stack-establishment.md`
6. `change-control/70-security-platform/CF-CHG-20260901-051-m2-5-platform-operations-maturity-foundation.md`
7. M2.5 RUNSHEET / CURRENT-STATE / FOLLOW-UPS / PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG
8. `docs/coursefinder-platform-maturity-design-v1.0.md`
9. `docs/coursefinder-database-architecture-v2.10.45.md`
10. `docs/coursefinder-admin-pim-design-decisions-v1.25.md`
11. `docs/coursefinder-uat-performance-baseline-v1.1.md`
12. `docs/coursefinder-m2-5-platform-operations-readiness-v1.0.md`
13. closed M2.4.4 `CF-CHG-20260830-048`
14. `change-control/README.md` and `REGISTER.md`

Reconcile live Admin/Pilot heads, Supabase Pilot, workflows and Production inventory before further changes.

## Frozen M2.4 authority

M2.4 is CLOSED/PASS:
- accepted Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`;
- build `33468512538` PASS;
- final deployed acceptance `33468512515` PASS;
- desktop 75 / mobile 76;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR.

Do not reopen M2.4.2/.3/.4.

## M2.5 Production boundary

CF-049 remains ACTIVE/READINESS.

Supabase at last reconciliation:
- organisation `techM` / `rszbvkqopqfvjldvfnbh`;
- Pilot `fxcwkweaxjtknorudmwp` / Mumbai `ap-south-1`;
- demo `gfryvshbeptxwbzjomhe` / `ap-southeast-2`;
- no CourseFinder Production project.

Do not create a billable Production project until organisation, Production region and quoted cost are explicitly approved. Do not rename/promote Pilot.

## CF-051 / CF-052 implementation state

Pilot M2.5 source head at handover:
`9fa8f590c8370bf600f1495794f9205fabbdf8a7`.

Admin UI version: **v2.15.15**.

Migrations deployed:
- `20260901060826 m2_5_platform_operations_maturity_foundation`
- `20260901061041 m2_5_capacity_integrity_alert_classification`
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`
- `20260901062200 m2_5_layer2_run_observability_correction`

Implemented:
- source/capability lifecycle and Pilot/Production separation;
- scraper environment gate;
- AI profile environment gate;
- capacity policy + daily observation;
- retention classes + dry-run only;
- UAT catalogue;
- workload profiles;
- append-only Layer 4 operational/publication/Search/quarantine block ledger.

Pilot reconciliation:
- AU CRICOS + NZ NZQA Provider/Course = Pilot UAT PASS in new gate;
- Direct HTTP + Firecrawl = Pilot-qualified;
- three benchmark-PASS Layer 3 profiles = Pilot-qualified;
- Production source/scraper/AI rows = zero.

Post-change Advisors:
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 174 INFO / 0 WARN / 0 ERROR.

## Capacity / integrity finding

Current Pilot snapshot:
- DB ~611 MB;
- Evidence Storage 8,623 objects / ~4.62 GB;
- ~7.18% of 60 GiB Evidence planning envelope;
- cumulative temp activity ~216.6 GB / ~51.1k files;
- largest relation `search.course_documents` ~155 MB.

HIGH state is Evidence lineage integrity:
- 205 Storage objects have no current Evidence artifact-path match;
- 18 regulatory Evidence artifact rows have no current Storage object.

Do not delete either side. Classify the lineage first.

Backup/PITR is intentionally `platform_api_required` in the SQL snapshot until platform metadata is reconciled.

## Layer 2 closure-snapshot reconciliation

M2.4.4 recorded 42 scheduled remainder at closure.

Live request `1bb1504d-7bad-42d9-b059-4adeaf9118c7` later became terminal:
- 42 completed;
- 219 failed;
- 6,562 scope candidates marked missing URL.

Do not describe “42 scheduled remainder” as current pending work. Failure review is a separate Pilot operations item and does not reopen M2.4.

CF-052 additionally corrected the operator observability defect:
- terminal parent lineage now retains **261 Jobs / 783 Evidence artifacts**;
- Recent acquisition attempts and Recent managed runs show timestamps;
- active progress is separated from latest terminal production history;
- bounded VIC retry-window check `c876a8fb-5f03-4433-85ab-5af7e96cee63` returned `qualification_waiting` and created zero production wave requests / zero Course Jobs;
- dedicated deployed UAT `33477539721` / job `99760830965` PASS — 2/2 desktop.

CF-052 is **IMPLEMENTED / TARGETED PASS**.

## CI gate

Permanent tests:
- `tests/uat/m2-5-platform-readiness-deployed.spec.mjs`;
- `tests/uat/m2-5-layer2-run-observability-deployed.spec.mjs`.

`.github/workflows/deployed-uat.yml` includes both in integration/acceptance with targeted routing.

Targeted deployed UAT is terminal PASS:
- run `33476711758`;
- job `99757413769`;
- desktop M2.5 source-contract PASS;
- mobile skipped by targeted-tier design.

CF-051 is IMPLEMENTED / TARGETED PASS. Production integration/acceptance remains future work under CF-049.

## Next authorised priorities

Without Production provisioning:
1. reconcile Evidence lineage mismatch without deleting data;
2. reconcile Supabase backup/PITR/platform capacity metadata;
3. define notification destination/escalation for capacity/integrity;
4. mature canonical Administration surfaces for environment gates/capacity/UAT/blocking;
5. add explicit block enforcement + UAT to each owning path before treating block state as universal;
6. analyse 219 current Layer 2 failures and missing-URL population as Pilot operations, not M2.4 reopening;
7. continue serving-vs-ingestion performance profile design/benchmarks.

With explicit Production org/region/cost approval:
proceed through CF-049 P0→P8; Production canary/UAT remains mandatory.

## Standing boundaries

No broad Publication, Website Production cutover, Zoho Production cutover, RMIT frozen canonical promotion, deferred NZ first-party Layer 2 expansion or autonomous Layer 3 canonical mutation is authorised.

16–30 September 2026 remains the no-planned-delivery blackout unless separately authorised.
