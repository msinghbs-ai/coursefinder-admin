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

## CF-051 / CF-052 / CF-053 / CF-054 / CF-055 / CF-056 / CF-057 / CF-058 / CF-059 / CF-060 implementation state

Pilot M2.5 source head at handover:
`97c3679d8304c36e10ae6e5b74d6cc99a2834152`.

The prior CF-054 post-reconcile trigger `dbd7bdde...` ran as `33492617096` / job `99807392499` and failed before executing tests because of an unterminated assertion string. The test syntax correction `1605d15b...` passed targeted Chromium desktop in workflow `33492875364`. Next check the dedicated deployed browser acceptance for the v2.15.17 Provider source-pattern queue.

Admin source UI version: **v2.15.20**.

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
- `20260901220500 m2_5_platform_maturity_admin_read_surface`
- `20260901224000 m2_5_evidence_lineage_reconciliation_contact_claim`

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
- repository source version: **v2.15.20**;
- CF-053 Layer 2 classification element is absent;
- test stopped before reaching the CF-054 queue;
- no AI action was executed.

FU-015 is no longer a persistent v2.15.14 blocker: user UAT proves the Worker reached v2.15.19. Recheck currentness after v2.15.20 publishes; do not weaken any browser contract.

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

## CF-058 Platform maturity Administration

CF-058 is **IMPLEMENTED / SOURCE+BUILD TARGETED PASS — DEPLOYED UI BLOCKED BY FU-015**.

Pilot migration:
\`20260901220500_m2_5_platform_maturity_admin_read_surface\`.

Source:
- \`src/platform-maturity-entry.jsx\`;
- \`src/platform-maturity.css\`;
- canonical Administration mounts \`PlatformMaturity\`;
- source/release version **v2.15.20**.

Runtime proof:
- anonymous \`admin_read\` denied;
- authenticated read route preserved;
- private Platform dispatcher rank >=4;
- no secrets/raw approval evidence exposed;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 171 INFO / 0 WARN / 0 ERROR.

Current Pilot capacity snapshot shown by the workspace:
- DB 632,933,523 bytes;
- Evidence 10,546 objects / 5,224,808,213 bytes;
- 8.11% governed planning envelope;
- CF-059 supersedes that historical integrity snapshot: raw 205 unlinked = 200 duplicates + 5 reconciled historical orphans + 0 unresolved; raw 2 missing bucket refs = 2 reconciled legacy refs + 0 unresolved; integrity OK.

Permanent source/build contract:
\`tests/uat/m2-5-platform-maturity-admin-contract.spec.mjs\`.
Workflow routing commit:
\`45dcf406090be5bedc8838b965495b71aee7cee0\`.

Initial CF-058 trigger `bd267ab46216529e21f94a4448394365b12a2cae` failed because the full Vite build exposed older Layer 2 source corruption. Repair commit: `a4cde432dcf8798ad1e61b986db3052ddeb64b74`. Trigger `97dc4085e4c00208864529bca21eb743ac46c05d` also failed because the managed-run JSX line itself was still malformed after duplicate-tail removal. Final syntax-safe restoration: `27abb0f3c64a508227e2a442fdf5d4c78ca0f051`. Final CF-058 trigger `7f7f6a920fd303578cad7430401f4dce522c6e0c` passed workflow `33507629698` / job `99855436515`; no further source/build rerun is needed unless CF-058 materially changes. Do not run deployed-browser acceptance until FU-015 Cloudflare drift is repaired.

## CF-059 Evidence-lineage reconciliation & contact claim hardening

CF-059 is **IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING**.

Live proof:
- private reconciliation ledger 7 rows = 5 Storage objects + 2 legacy Evidence refs;
- raw unlinked objects 205 remain visible;
- proven duplicates 200;
- reconciled historical orphans 5;
- unresolved orphans 0;
- raw missing bucket refs 2;
- reconciled legacy refs 2;
- unresolved missing bucket refs 0;
- integrity severity OK / severity input 0;
- active Provider-contact claims 0.

Provider-contact worker:
- source v1.3.4;
- Edge v19;
- atomic \`FOR UPDATE SKIP LOCKED\` profile claim;
- 1,800-second bounded lease;
- wrong finish token rejection;
- claim expiry/reclaim;
- failed Evidence-registration cleanup of only the just-uploaded object.

Rollback-only UAT passed those claim semantics and left no active claim state.

Advisors:
- Security 147 INFO / 0 WARN / 0 ERROR;
- Performance 175 INFO / 0 WARN / 0 ERROR.

Permanent contract:
\`tests/uat/m2-5-evidence-lineage-reconciliation-contract.spec.mjs\`.

Workflow routing commit:
\`7f10e29bac5351b173b5de2df4b61d28d51eed07\`.

The final targeted trigger is recorded below after it is created. Check that exact commit first on the next Proceed. Do not run stale-Worker browser acceptance while FU-015 remains open.

## CF-060 Jobs workspace read-path restoration

User UAT trigger: Jobs showed **0 records** on deployed v2.15.19 while Layer 2 showed background activity.

Live runtime at investigation:
- total Jobs 3,964;
- recent 24h 1,082;
- running 2;
- failed 237;
- completed/succeeded 3,720;
- Layer 2 Jobs 2,643.

Root cause: obsolete `adminRead` route suppression returned `[]` for Jobs/Sources after the old Pipeline Ops overlay had been removed from `index.html`.

Implemented v2.15.20:
- canonical Jobs mounts governed server-paged `JobsWorkspace`;
- canonical Sources mounts `SourcesWorkspace`;
- stale suppression removed;
- current/history filters, timestamps, Evidence counts, duration/cursor and expandable detail use existing governed `pipeline_*` RPCs;
- no generic mutation actions.

Permanent tests:
- `tests/uat/m2-5-jobs-workspace-read-path-contract.spec.mjs`;
- `tests/uat/m2-5-jobs-workspace-deployed.spec.mjs`.

Workflow wiring: `35a2e02d457e5faccffe78979ff3756757571e3d`.

Source validation trigger: `97c3679d8304c36e10ae6e5b74d6cc99a2834152`.
At handover:
- CourseFinder Deployed UAT run `33511601936` = **pending**;
- Pilot Frontend Build run `33511602057` = **queued**.

**Next action:** inspect those exact two runs first. If source/build PASS, create/update `.github/m2-5-jobs-workspace-deployed-candidate` to run only the deployed Jobs test after Cloudflare serves v2.15.20. If deployed test passes, mark CF-060/FU-017 targeted PASS and FU-015 currentness recovered.

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
1. CF-059 has reconciled the known Evidence lineage mismatch without deletion; close its targeted CI before marking FU-009 complete;
2. CF-056 backup/PITR metadata is reconciled as far as current tools allow; final Production restore/DR remains a clean-environment gate;
3. define notification destination/escalation for capacity/integrity;
4. mature canonical Administration surfaces for environment gates/capacity/UAT/blocking;
5. CF-058 source/build is targeted PASS; deployed Platform UI remains blocked only by FU-015;
6. analyse 219 current Layer 2 failures and missing-URL population as Pilot operations, not M2.4 reopening;
7. continue serving-vs-ingestion performance profile design/benchmarks.

With explicit Production org/region/cost approval:
proceed through CF-049 P0→P8; Production canary/UAT remains mandatory.

## Standing boundaries

No broad Publication, Website Production cutover, Zoho Production cutover, RMIT frozen canonical promotion, deferred NZ first-party Layer 2 expansion or autonomous Layer 3 canonical mutation is authorised.

16–30 September 2026 remains the no-planned-delivery blackout unless separately authorised.


## A17 continuation requirement

Read before implementing Course skills/jobs/career intelligence:
- `CF-CHG-20260901-062`;
- A17 execution addendum;
- `docs/coursefinder-course-skills-career-labour-market-design-v0.1.md`;
- `docs/coursefinder-career-skills-demo-operator-guide-v0.1.md`;
- `docs/coursefinder-career-skills-implementation-guide-v0.1.md`;
- M25-FU-017 through M25-FU-026.

Start from repository/runtime truth. Do not jump directly to AI mapping or UI. First establish the versioned occupation/code/concordance and skills relationship schema, then qualify AU/NZ authoritative source adapters. Preserve the explicit distinction between Course-acquired skills, occupation skills, labour demand, registration and migration policy.


## CF-061 continuation checkpoint

QILT/PRISMS comparison work is implemented in Pilot runtime/source under **v2.15.21**.

Read before changing it:
- `change-control/30-admin-pim-ux/CF-CHG-20260901-061-qilt-prisms-provider-course-comparison-experience.md`;
- A12.7 comparison rules;
- Pilot migrations `20260901133212`, `20260901134059`, `20260901134137`;
- `src/ComparisonWorkspace.jsx`, `src/ContextualInsights.jsx`, `src/mature-main.jsx`;
- `tests/uat/cf-061-qilt-prisms-comparison-contract.spec.mjs`.

Runtime is PASS after two additive schema-name corrections:
- Provider comparison returns requested Providers;
- Course comparison returns Course context with QILT grain `provider_context`;
- seven selections are rejected;
- no-JWT request is rejected;
- post-DDL Security 147 INFO / 0 WARN / 0 ERROR;
- Performance 175 INFO / 0 WARN / 0 ERROR.

Source trigger `b423af67af6917ae3407e3f5137dcd403d0da225` had no attached commit status at the last check. Check that exact source/build state before retriggering. Then confirm external Cloudflare serves v2.15.21 and run bounded responsive deployed comparison UAT. Do not call CF-061 deployed PASS from source/runtime proof alone.
