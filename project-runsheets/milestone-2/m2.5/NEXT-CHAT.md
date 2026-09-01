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

## CF-051 / CF-052 / CF-053 / CF-054 / CF-055 / CF-056 / CF-057 implementation state

Pilot M2.5 source head at handover:
`ca1e54f95f9a52b39c3c1b3bf9357d332d6f2389`.

The prior CF-054 post-reconcile trigger `dbd7bdde...` ran as `33492617096` / job `99807392499` and failed before executing tests because of an unterminated assertion string. The test syntax correction `1605d15b...` passed targeted Chromium desktop in workflow `33492875364`. Next check the dedicated deployed browser acceptance for the v2.15.17 Provider source-pattern queue.

Admin source UI version: **v2.15.17**.

Do not assume the external Cloudflare Pilot Worker has this source. CF-053 browser acceptance proves the Worker is stale.

Migrations deployed:
- `20260901060826 m2_5_platform_operations_maturity_foundation`
- `20260901061041 m2_5_capacity_integrity_alert_classification`
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`
- `20260901062200 m2_5_layer2_run_observability_correction`
- `20260901083800 m2_5_layer2_finalizer_fairness`
- `20260901085000 m2_5_layer2_stale_pattern_control_handoff`
- `20260901091500 m2_5_layer3_source_pattern_operator_handback`
- `20260901091800 m2_5_layer3_source_pattern_legacy_completion_guard`
- `20260901092500 m2_5_layer3_source_pattern_legacy_http_host_reconcile`
- `20260901195000 m2_5_evidence_lineage_classification`
- `20260901211500 m2_5_universal_layer4_block_enforcement`

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

Post-CF-054 Advisors:
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 173 INFO / 0 WARN / 0 ERROR.

`layer3-interpret` Pilot Edge Function is version 9, JWT enforced.

## Capacity / integrity finding

CF-055 corrected Pilot integrity snapshot:
- DB **617,819,283 bytes**;
- Evidence Storage **9,484 objects / 4,902,002,299 bytes** at observation;
- Evidence planning utilisation **7.61%**;
- raw unlinked Storage objects **205** = **200 proven duplicates + 5 unresolved**;
- raw Evidence missing-path rows **18** = **16 virtual/external URI references + 2 real legacy missing bucket paths**;
- severity **WARNING** with integrity input **5**.

Do not delete historical objects/rows. Forward duplicate prevention is deployed; 5 unresolved objects + 2 Canadian legacy paths remain remediation work.

CF-056 reconciles the recovery boundary: Pilot identity/health is management-plane proven; paid-plan backup capability is product-level; actual backup inventory/PITR configuration remains Dashboard/control-plane unverified; no restore has executed. Database backups do not recover deleted Storage object bodies. Production P6 remains OPEN.

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

### CF-053

Finalizer fairness/stale-control correction is implemented and runtime-proven:
- 293 pending deterministic Provider dispatches at discovery → 233 at latest checkpoint under normal bounded cron;
- historical VIC 219 = acceptance-isolation/rescheduled markers, operational acquisition failures = 0;
- 6,562 missing URLs = Course-page discovery backlog across 337 Providers with Provider websites already present.

CF-053 deployed browser acceptance is **BLOCKED**, not PASS:
- run `33488961340`;
- jobs `99795659209` and `99796810066` failed because the external Cloudflare Worker did not contain current main's UI classification element.

### CF-054

Manual-governed Layer 3 Provider source-pattern path is implemented:
- secure Curator+ queue;
- Edge `layer3-interpret` v9;
- exact same-host/Evidence-link URL validation;
- valid candidate returns to Layer 2 3-Course identity control;
- no candidate/low confidence returns to Layer 4 Provider source resolution;
- no direct Provider qualification/canonical/Search/Publication mutation;
- A23 no-autonomous-L2→L3 boundary retained.

Rollback-only valid/no-candidate/idempotency paths PASS with no retained synthetic state.

Permanent source-contract CI:
- run `33491843514`;
- job `99804902558`;
- PASS.

Live source-pattern queue at handover: **422 queued / 0 completed / 0 failed**; deterministic finalizer state **227 pending dispatch / 66 pending controls**. Do not bulk drain it. No real CF-054 model execution has been performed.

Legacy HTTP-origin Evidence/source URLs are reconciled by hostname only: candidates remain HTTPS-only and exact Evidence-link bound. Sydney rollback-only proof returned to Layer 2 three-Course control and left no retained test state.

CF-054 deployed UI acceptance remains blocked until the external Cloudflare Pilot deployment is reconciled.

## Cloudflare/currentness browser result

Combined non-mutating test:
`tests/uat/m2-5-pilot-deployment-currentness-deployed.spec.mjs`.

Run `33493637581` / job `99810738327` = **FAIL**.

UAT evidence proves:
- deployed Worker Admin version: **v2.15.14**;
- repository source version: **v2.15.17**;
- CF-053 Layer 2 classification element is absent;
- test stopped before reaching the CF-054 queue;
- no AI action was executed.

Treat FU-015 as an external Cloudflare Git deployment blocker. Do not rerun until the Worker is actually publishing current `main`; do not weaken the browser contract.

## CF-055 targeted source/runtime UAT

`ca1e54f95f9a52b39c3c1b3bf9357d332d6f2389` is **PASS**:
- workflow `33495782424`;
- job `99817573838`;
- targeted Chromium desktop 1/1 passed.

CF-055 is IMPLEMENTED / TARGETED PASS. Remaining 5 unresolved objects + 2 legacy Canadian paths are historical provenance remediation only; no cleanup is authorised by this pass.

## CF-057 universal Layer 4 block enforcement

CF-057 is **IMPLEMENTED / TARGETED PASS**.

Runtime proof:
- direct Course Search block hides Zoho + Website exact/search reads;
- Search unblock restores visibility;
- Provider Search block hides Provider and child Course;
- publication readiness shows `layer4_publication_block`;
- publishable Layer 4 decision rejected; not-publishable remains allowed;
- Layer 2 apply rejected by operational block;
- Layer 3 source-pattern context non-executable and reservation `call_required=false`;
- no model call/new interpretation;
- Provider quarantine is direct and child Course quarantine inherited;
- quarantine alone does not hide Search;
- rollback leaves **0 CF057_UAT / 0 total block decisions**.

Coverage: 20/20 inventoried API functions include Search-block enforcement.
Advisors: Security 146 INFO / 0 WARN / 0 ERROR; Performance 171 INFO / 0 WARN / 0 ERROR.

Permanent contract:
`tests/uat/m2-5-layer4-block-enforcement-contract.spec.mjs`.
Workflow routing commit:
`1df7c2d0ce995895468b727cc6e8003dd95a47c7`.

Targeted Chromium proof: trigger `2073621cf2c2df085d1add918d84b72fd49c207c`, workflow `33503165142`, job `99840959713`, 1/1 PASS.

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

Before relying on Pilot browser UI:
0. **Reconcile Cloudflare external Git deployment** for Worker `coursefinder-pilot`: confirm repository `msinghbs-ai/Coursefinder-Pilot`, branch `main`, build/output/deploy settings and latest deployment. Then rerun CF-053 + CF-054 deployed browser UAT unchanged.

Without Production provisioning:
1. reconcile Evidence lineage mismatch without deleting data;
2. CF-056 backup/PITR metadata is reconciled as far as current tools allow; final Production restore/DR remains a clean-environment gate;
3. define notification destination/escalation for capacity/integrity;
4. mature canonical Administration surfaces for environment gates/capacity/UAT/blocking;
5. CF-057 block enforcement is runtime-proven; retain canonical block-management UI under FU-011 and close targeted CI before treating it as release-gated;
6. analyse 219 current Layer 2 failures and missing-URL population as Pilot operations, not M2.4 reopening;
7. continue serving-vs-ingestion performance profile design/benchmarks.

With explicit Production org/region/cost approval:
proceed through CF-049 P0→P8; Production canary/UAT remains mandatory.

## Standing boundaries

No broad Publication, Website Production cutover, Zoho Production cutover, RMIT frozen canonical promotion, deferred NZ first-party Layer 2 expansion or autonomous Layer 3 canonical mutation is authorised.

16–30 September 2026 remains the no-planned-delivery blackout unless separately authorised.
