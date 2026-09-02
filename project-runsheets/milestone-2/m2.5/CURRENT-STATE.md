# M2.5 CURRENT STATE

**Status:** ACTIVE / READINESS — PLATFORM FOUNDATION IMPLEMENTED; PRODUCTION PROVISIONING BLOCKED  
**Updated:** 1 September 2026  
**Production Change Control:** `CF-CHG-20260901-049`  
**Platform foundation Change Control:** `CF-CHG-20260901-051`  
**Layer 2 corrective Change Controls:** `CF-CHG-20260901-052`, `CF-CHG-20260901-053`  
**Layer 3 source-pattern corrective Change Control:** `CF-CHG-20260901-054`
**Evidence-lineage corrective Change Control:** `CF-CHG-20260901-055`
**Backup/PITR reconciliation Change Control:** `CF-CHG-20260901-056`
**Universal block-enforcement Change Control:** `CF-CHG-20260901-057`
**Platform Administration Change Control:** `CF-CHG-20260901-058`
**Career Skills / Labour-Market Change Control:** `CF-CHG-20260901-062`

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
`97c3679d8304c36e10ae6e5b74d6cc99a2834152`.

CF-054 post-HTTP-reconcile trigger `dbd7bdde61e28fa49170875786066d7015ccd77d` produced run `33492617096` / job `99807392499` FAIL due only to a malformed Playwright assertion string. The corrected clean-rerun trigger `1605d15bca7ccb46620ce5bd12ca01805a3f30f4` passed targeted Chromium desktop in workflow `33492875364`.

Admin source UI version: **v2.15.20**.

Important deployment distinction: earlier run `33493637581` / job `99810738327` captured stale Worker v2.15.14, but user UAT now visibly proves the external Cloudflare Worker reached **PIM Admin v2.15.19**. CF-060 advances source to v2.15.20; currentness recheck is pending rather than treating Cloudflare Git integration as persistently broken.

Deployed M2.5 migrations:
- `20260901060826 m2_5_platform_operations_maturity_foundation`;
- `20260901061041 m2_5_capacity_integrity_alert_classification`;
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`;
- `20260901062200 m2_5_layer2_run_observability_correction`.
- `20260901083800 m2_5_layer2_finalizer_fairness`;
- `20260901085000 m2_5_layer2_stale_pattern_control_handoff`;
- `20260901091500 m2_5_layer3_source_pattern_operator_handback`;
- `20260901091800 m2_5_layer3_source_pattern_legacy_completion_guard`;
- `20260901092500 m2_5_layer3_source_pattern_legacy_http_host_reconcile`;
- `20260901195000 m2_5_evidence_lineage_classification`;
- `20260901211500 m2_5_universal_layer4_block_enforcement`;
- `20260901220500 m2_5_platform_maturity_admin_read_surface`;
- `20260901224000 m2_5_evidence_lineage_reconciliation_contact_claim`.

Post-CF-054 advisors:
- Security: 146 INFO / 0 WARN / 0 ERROR;
- Performance: 172 INFO / 0 WARN / 0 ERROR.

Pilot Edge:
- `layer3-interpret` version 9;
- `verify_jwt=true`;
- deployed SHA-256 `5d47c64f49275a513bebd6edd76562239a9970004cd14081e3ff2d30efb3fd92`.

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

Current corrected CF-055 snapshot:
- logical DB **617,819,283 bytes**;
- Evidence Storage **9,484 objects / 4,902,002,299 bytes** at the observation instant;
- Evidence planning utilisation **7.61%** of the 60 GiB planning envelope;
- largest relation remains `search.course_documents` at ~155 MB;
- integrity severity: **WARNING**, not HIGH.

Evidence classification:
- raw unlinked Storage objects: **205**;
- ETag+size-proven duplicates: **200**;
- unresolved orphan objects: **5**;
- virtual/external Evidence URI references: **16**;
- real missing bucket-object paths: **2**;
- integrity count used for severity: **5**.

No historical Storage object or Evidence row was deleted or rewritten. The five unresolved objects and two legacy Canadian missing paths remain retained for later provenance remediation.

CF-056 reconciles the non-billable recovery boundary: Pilot project identity/health is management-plane proven, paid-plan daily-backup capability is product-level only, actual backup inventory/PITR state remains control-plane unverified, and no restore has executed. Database backups do not restore deleted Storage object bodies, so Evidence Storage requires separate DR treatment. Production P6 remains OPEN.

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

### CF-054 legacy HTTP host reconciliation

The manual-governed source-pattern hand-back now supports retained historical `http://` Provider Evidence/source URLs while keeping the Layer 3 candidate itself HTTPS-only.

Rollback-only Sydney proof:
- `http://sydney.edu.au` retained Evidence → `https://sydney.edu.au/study/study-areas/law.html` candidate;
- hand-back → Layer 2 three-Course identity control;
- Provider not qualified;
- no canonical/Search/Publication mutation;
- rollback restored the original queued request and 10 `layer3_required` sample rows.

Current checkpoint: **227 pending dispatch / 66 pending control / 422 source-pattern queued / 0 completed / 0 interpretations**. No real model call or bulk drain has been performed.

## Combined deployed browser currentness gate

A non-mutating combined CF-053/CF-054 deployed browser gate is now permanent:

`tests/uat/m2-5-pilot-deployment-currentness-deployed.spec.mjs`

Trigger commit:
`msinghbs-ai/Coursefinder-Pilot@e15aee26cc910dcc6ee09658f65ef57aeb0f1bae`.

The gate:
- logs in using governed UAT credentials;
- proves the deployed Layer 2 terminal card contains the CF-053 acceptance-isolation/rescheduled classification;
- proves the deployed Layer 3 page contains the CF-054 governed Provider source-pattern queue;
- proves a per-request **Run source-pattern interpretation** control is present;
- proves there is no **Run all source-pattern** control;
- does **not** click the AI execution action and therefore consumes no model call.

At handback GitHub had not yet attached a workflow run/status to `e15aee26...`. Per operating instruction, check this commit first on the next Proceed and do not trigger another run unless needed.

## CF-055 Evidence-lineage correction

Implemented:
- telemetry migration `20260901195000_m2_5_evidence_lineage_classification`;
- Layer 2 discovery Edge v20 / source v1.3.3;
- screenshot backfill Edge v2 / source v1.0.1;
- Provider-contact discovery Edge v18 / source v1.3.3;
- Scholarships ETL Edge v3 / source v0.1.2.

Forward rule: if Evidence registration proves the just-uploaded object is redundant, remove only that new duplicate via the Storage API. Cleanup failure is non-fatal; retained Evidence paths are never removed.

Post-change advisors:
- Security 146 INFO / **0 WARN / 0 ERROR**;
- Performance 172 INFO / **0 WARN / 0 ERROR**.

Permanent contract trigger `ca1e54f95f9a52b39c3c1b3bf9357d332d6f2389` passed targeted Chromium desktop:
- workflow `33495782424`;
- job `99817573838`;
- 1/1 test passed;
- commit status `coursefinder/deployed-uat/targeted/chromium-desktop = success`.

CF-055 is **IMPLEMENTED / TARGETED PASS**.

## CF-057 universal block enforcement

Migration `20260901211500_m2_5_universal_layer4_block_enforcement` is deployed.

Server-side enforcement now covers:
- operational: Layer 2 Course Fact apply + Layer 3 reservation/source-pattern execution;
- publication: readiness + publishable decision gate;
- Search: all 20 inventoried Website/Zoho/legacy consumer API search/lookup/reference-manifest functions;
- Data Quality: secured quarantine read with direct/Provider-inherited state.

Provider Search blocks inherit to child Courses/Campuses and Provider-owned Scholarships. Quarantine remains independent from Search/publication. Layer 1 regulatory ingestion is not rewritten by CF-057.

Rollback-only Pilot UAT proved Course block/unblock, Provider inheritance, publication rejection/nonpublishable allowance, Layer 2 apply rejection, Layer 3 zero-call behavior and quarantine. Post-rollback live block decisions remain **0**.

Post-CF-057 advisors:
- Security 146 INFO / **0 WARN / 0 ERROR**;
- Performance 171 INFO / **0 WARN / 0 ERROR**.

Permanent contract `tests/uat/m2-5-layer4-block-enforcement-contract.spec.mjs` passed targeted Chromium desktop: workflow `33503165142`, job `99840959713`, 1/1 PASS. CF-057 is **IMPLEMENTED / TARGETED PASS**.

## CF-058 Platform maturity Administration surface

Server migration \`20260901220500_m2_5_platform_maturity_admin_read_surface\` is deployed.

Canonical Administration source is now **v2.15.20** and its Platform tab uses \`PlatformMaturity\` instead of the legacy Regulatory Settings component. The workspace consolidates:
- M2.5 readiness and Production-boundary state;
- capacity/Evidence integrity telemetry;
- source/scraper/AI environment gates;
- UAT catalogue;
- workload profiles;
- retention dry-run/classes;
- CF-057 Layer 4 block state and rank-5 block/unblock controls.

CF-059 subsequently reconciled the known historical lineage exceptions. Latest snapshot: DB 627,092,627 bytes; Evidence 10,868 objects / 5,326,216,492 bytes; 8.27% of the governed planning envelope; raw unlinked objects 205 = 200 proven duplicates + 5 reconciled historical orphans + 0 unresolved; raw missing bucket refs 2 = 2 reconciled legacy references + 0 unresolved; 16 direct virtual refs; integrity severity **OK**.

No Production enable, PITR purchase/enable, destructive purge or broad Publication action is introduced by CF-058.

Post-migration:
- Security 146 INFO / **0 WARN / 0 ERROR**;
- Performance 171 INFO / **0 WARN / 0 ERROR**.

Permanent CF-058 source/build contract `tests/uat/m2-5-platform-maturity-admin-contract.spec.mjs` passed workflow `33507629698` / job `99855436515`. Deployed browser acceptance remains BLOCKED by FU-015 because Cloudflare still serves v2.15.14.

## CF-059 Evidence-lineage reconciliation & contact claims

Migration \`20260901224000_m2_5_evidence_lineage_reconciliation_contact_claim\` is deployed.

Known historical lineage is now explicitly reconciled without deleting or rewriting Evidence:
- 5 Storage-object reconciliations;
- 2 legacy Evidence-reference reconciliations;
- raw unlinked count 205 retained;
- 200 fingerprint duplicates retained/classified;
- unresolved orphan count **0**;
- raw missing bucket refs 2 retained;
- unresolved missing bucket count **0**;
- integrity severity **OK**.

Provider-contact discovery now uses atomic leased profile claims and a claim-aware finish service. The scheduled worker is source v1.3.4 / Edge version 19. Rollback-only UAT proved overlapping claims cannot take the same Provider, wrong tokens are rejected, expired claims are reclaimable and correct finish clears all claim state. Live active claims are 0.

The worker also removes only a just-uploaded object if Evidence registration itself fails, preserving retained Evidence objects.

Post-CF-059:
- Security **147 INFO / 0 WARN / 0 ERROR**;
- Performance **175 INFO / 0 WARN / 0 ERROR**.

Permanent contract \`tests/uat/m2-5-evidence-lineage-reconciliation-contract.spec.mjs\` is wired; targeted CI is pending.

## CF-060 Jobs workspace read-path restoration

User UAT showed `#jobs` at 0 records while Layer 2 was active. Live Pilot database simultaneously contained **3,964 Jobs**, including 2 running and 2,643 Layer 2 Jobs.

Root cause: `src/lib/supabase.js` still returned `[]` for `adminRead('jobs')` / `adminRead('sources')` when the browser hash matched those routes. That guard belonged to a removed Pipeline Ops overlay; `index.html` no longer mounts that overlay, so the guard suppressed the canonical Jobs page itself.

Correction:
- canonical Jobs → exported governed `JobsWorkspace`;
- canonical Sources → exported governed `SourcesWorkspace`;
- Jobs uses `pipeline_jobs_page`, `pipeline_filters`, `pipeline_job_detail`;
- stale route suppression removed;
- version **v2.15.20**;
- source/build contract and deployed Jobs contract added.

Validation trigger `97c3679d8304c36e10ae6e5b74d6cc99a2834152`:
- workflow `33511601936` pending at handover;
- frontend build `33511602057` queued at handover.

No database migration, replay/reset authority, Firecrawl quota change, Search or Publication authority is introduced.


## CF-065 Layer 1 operations v2

Layer 1 Pilot/Admin source has advanced to **v2.15.24** under `CF-CHG-20260902-065`.

Implemented without changing Layer 1 authority or canonical semantics:
- compact country-first Authority & Statistical Ingestion operations dashboard;
- Country / Dataset / Status filters with Healthy / Running / Attention / Due summary signals;
- registry-driven responsive dataset cards and running progress;
- routine actions reduced to Run now / View run / Details with diagnostics progressively disclosed;
- Layer 1 source URL, authority metadata, guardrails and cadence moved to **Administration → Layer 1 sources** for Platform Admin;
- no destructive canonical/Evidence purge control added.

Final targeted candidate: `msinghbs-ai/Coursefinder-Pilot@2ed222925a02abeaa1d9bca7474d5e0eb4dcf4ed`.

Validation:
- frontend build `33573906087` PASS;
- deployed targeted UAT `33573906103` PASS;
- Layer 1 deployed suite 4/4 PASS on Chromium desktop;
- real NZQA and CRICOS source validation paths passed;
- anonymous browser boundary passed.

Two earlier targeted failures are retained as diagnostic history: the first exposed stale pre-v2 shared navigation/test selectors; the second exposed a test selector resolving the hidden Status dropdown option instead of the visible Healthy summary. Both were corrected at test/integration level without weakening Layer 1 authority, source validation or security boundaries.


## CF-066 Layer 1 statistical ingestion

Layer 1 Pilot/Admin source is now **v2.15.25** under `CF-CHG-20260902-066`.

The CF-065 UI could display Statistics, but live `pipeline.layer1_source_operations` originally contained only CRICOS and NZQA. CF-066 closes that operational gap by registering the existing Evidence-backed AU statistical sources rather than creating duplicate data:
- QILT ESS 2025 — 228 observations;
- QILT GOS 2025 — 593 observations;
- QILT GOS-L 2025 — 235 observations;
- QILT SES 2024 — 977 observations;
- Department of Education PRISMS SA4 December 2025 — 2,270 observations.

All retain `identity_authority=false`; no Provider/Course identity, Search or Publication authority changed. QILT/PRISMS preserve their existing statistical observation grain and historical Layer 2A lineage while Layer 1 becomes their operational ingestion/control surface.

Runtime routing:
- `qilt-au-etl` Edge v8 / source v0.2.5;
- `prisms-au-etl` Edge v2 / source v0.1.1;
- `layer1-operations-control` Edge v3 / source v1.1.0;
- `layer1-operations-scheduled` Edge v2 / source v1.1.0.

Live proof refreshed QILT GOS to 593 candidate observations / 100 mapped institutions and PRISMS to 2,270 candidate observations / period 2025-12 through the Layer 1 control plane.

Final targeted candidate: `msinghbs-ai/Coursefinder-Pilot@fea444a9343839c55a4b4848fb96c6dfd2dcc241`.
- frontend build `33575858611`: PASS;
- deployed targeted UAT `33575858607`: PASS;
- permanent Layer 1 suite: 5/5 Chromium desktop PASS, including the new AU Statistics QILT/PRISMS live-validation test, CRICOS, NZQA and anonymous boundary.

QS/THE are intentionally not represented as automated **Run now** sources until automated ranking ingestion adapters are accepted; their governed publisher-import/onboarding path remains separate.

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


## CF-053 / CF-054 Pilot operations reconciliation

### CF-053 finalizer fairness

The 219 VIC terminal `failed` markers are retained audit history, not operational acquisition failures:
- total historical production items: 261;
- completed: 42;
- acceptance-isolation/rescheduled markers: 219;
- operational acquisition failures: **0**;
- all 261 Jobs succeeded;
- all 261 Firecrawl acquisition attempts succeeded / HTTP 200 / normalised.

The 6,562 missing URLs are all Course-page discovery work across 337 Providers; all 337 already have Provider websites.

The finalizer fairness correction is active under the existing five-minute bounded cron:
- pending dispatch at defect discovery: 293;
- latest checkpoint: **233**;
- pending controls: **60**;
- no quota/concurrency expansion.

Stale incomplete controls no longer starve the scheduler; they route to governed Layer 3 source-pattern review.

### CF-054 manual-governed source-pattern path

The source-pattern queue remains intentionally operator-triggered.

Implemented:
- Curator+ secured Provider source-pattern queue;
- Layer 3 Edge v9 exact Evidence-bound HTTPS/same-host validator;
- valid candidate → normal Layer 2 3-Course deterministic identity control;
- no candidate / low confidence → Layer 4 Provider source resolution;
- no generic Layer 4 AI field-review for source-pattern;
- no direct Provider qualification;
- no canonical Course URL/Search/Publication mutation;
- no automatic L2→L3 call and no run-all queue drain.

Rollback-only UAT:
- valid candidate path PASS;
- no-candidate path PASS;
- idempotency PASS;
- synthetic interpretation/profile/dispatch state fully rolled back;
- negative Curator-role enforcement PASS.

Permanent source contract:
- test `tests/uat/m2-5-layer3-source-pattern-operator-contract.spec.mjs`;
- final targeted run `33491843514`;
- job `99804902558`;
- PASS.

Live queue checkpoint:
- source-pattern requests: **390 queued / 0 completed / 0 failed**;
- live source-pattern interpretations: **0**.
No real model call or bulk queue drain was performed in CF-054.

## Pilot Cloudflare deployment blocker

Current repository deployment configuration:
- `Coursefinder-Pilot/wrangler.jsonc`;
- Worker name `coursefinder-pilot`;
- static assets `./dist`;
- SPA fallback enabled.

Historical project records identify Cloudflare **external Git integration** as the Pilot deployment mechanism. The GitHub deployed-UAT workflow does not deploy Cloudflare; it only waits for the Worker to update.

CF-053 deployed browser run `33488961340`:
- job `99795659209` FAIL;
- rerun job `99796810066` FAIL;
- both observed the old Worker bundle while current `main` contained the required new element.

No Cloudflare control-plane connector is available in the current execution environment. Do not weaken browser UAT or treat source CI as deployed proof. Reconcile the external Cloudflare Git integration first, then rerun CF-053 and CF-054 deployed browser gates.


## A17 Course Skills / Career / Labour-Market Intelligence

Status: **DESIGN ACCEPTED / IMPLEMENTATION PENDING**.

The M2.5 design now defines Course → evidence-backed skills → governed occupation mappings → official labour-market observations, with registration and migration maintained as separate signals.

Key source decisions:
- AU canonical occupation reference: ABS OSCA;
- current JSA market series may remain native ANZSCO until source transition, resolved through explicit versioned concordance;
- NZ canonical occupation reference: Stats NZ NOL;
- NZ career/occupation context: TEC Tahatū subject to adapter/source qualification;
- Immigration NZ policy data is a time-scoped policy overlay, not student eligibility.

No A17 schema migration, adapter, model call, UI publication or Production enablement has been performed yet.


## CF-061 QILT / PRISMS comparison experience

CF-061 is **IMPLEMENTED / TARGETED PASS**.

Pilot source is now **v2.15.21** and adds:
- a dedicated Compare workspace for up to six Providers or Courses;
- Catalogue and Provider/Course detail entry actions;
- QILT aligned comparison rows keyed by survey + metric + study level + study area + collection period;
- QILT confidence interval, response-count and national-benchmark rendering where stored;
- PRISMS comparison context that retains actual Provider/geography/study-area/cohort grain;
- responsive navy/indigo, teal and magenta comparison styling without copying third-party brand assets.

Pilot migrations:
- `20260901133212 cf_061_contextual_compare_qilt_prisms`;
- `20260901134059 cf_061_contextual_compare_provider_city_fix`;
- `20260901134137 cf_061_contextual_insights_study_area_code_fix`.

Runtime proof:
- 3-Provider comparison PASS;
- 2-Course comparison PASS;
- Course QILT grain remains `provider_context`;
- maximum-six guard PASS (7 rejected);
- no-JWT rejection PASS;
- Security **147 INFO / 0 WARN / 0 ERROR**;
- Performance **175 INFO / 0 WARN / 0 ERROR**.

Initial APPLY exposed two schema-name defects (`providers.city`, `external_study_areas.code`); both were corrected through additive migrations and the live read was re-proven.

Permanent source/build contract:
`tests/uat/cf-061-qilt-prisms-comparison-contract.spec.mjs`.

Targeted source/build proof:
- trigger `msinghbs-ai/Coursefinder-Pilot@b423af67af6917ae3407e3f5137dcd403d0da225`;
- workflow `33515174810`;
- job `99880438005`;
- targeted Chromium desktop PASS.

Dedicated deployed comparison gate:
`tests/uat/cf-061-qilt-prisms-comparison-deployed.spec.mjs`.

Candidate trigger `35fef88e07cff9e7d6e568d740c31722c3c3720e` had no attached status at the last bounded check. Do not claim deployed browser acceptance until that gate proves Cloudflare is serving v2.15.21 and the comparison UI passes.


### CF-061 deployed browser checkpoint

Deployed targeted run `33515683960` / job `99882055173` is **PASS** on trigger `35fef88e07cff9e7d6e568d740c31722c3c3720e`.

The test explicitly observed Worker release pill **v2.15.21**, so the older FU-015 v2.15.14/v2.15.19 currentness evidence is superseded: the external Git deployment is current at this checkpoint.

Deployed proof includes:
- two-Provider comparison and bounded `contextual_compare` response;
- correct Provider QILT grain;
- Course detail QILT `provider_context` grain;
- Course comparison opening from the detail blade;
- no unexpected HTTP 5xx.

Responsive follow-up trigger `90123d162103e707473ac8eb7a7a226cade51280` passed workflow `33515936377` / job `99882833322`. The test explicitly exercises 900px tablet and 390px mobile viewport layouts and proves document-level horizontal overflow remains bounded while the comparison matrix scrolls inside its own container. CF-061 is targeted PASS.


## CF-063 QS / THE World University Rankings — design checkpoint

Status: **DESIGN ACCEPTED / IMPLEMENTATION PENDING**.

A29 now defines QS World University Rankings 2026/2027 and Times Higher Education World University Rankings 2026 as Layer 1 publisher-authoritative institutional context, with 5–10 year historical backfill where official publisher access/reuse permits.

Current design authority:
- `docs/coursefinder-university-ranking-data-design-v1.0.md`;
- DB Architecture `v2.10.46`;
- Admin/PIM decisions `v1.27`;
- execution addendum A29;
- `CF-CHG-20260902-063`.

No ranking schema migration, live source ingestion, Provider mapping, browser UI or consumer publication has been claimed yet. Implementation remains tracked under M25-FU-029 through M25-FU-035.


## CF-064 Statistics / Rankings / Compare IA

Status: **DESIGN ACCEPTED / UI IMPLEMENTATION ACTIVE**.

The accepted M2.5 information architecture now introduces:
- a primary Statistics & Rankings workspace for QILT, PRISMS, QS, THE and future accepted statistical datasets;
- primary Compare navigation with entity → dataset → period/edition selection;
- Administration → Sources & Imports for governed manual publisher artifacts;
- private Evidence reuse for authorised historical ranking files when automated publisher retrieval is restricted;
- concise Provider/Course contextual summaries with deep-links rather than oversized detail blades.

Design authority:
- `docs/coursefinder-statistics-rankings-comparison-ux-v1.0.md`;
- Admin Navigation IA v1.5;
- CF-064.

The existing Evidence bucket already supports CSV/XLSX/PDF/JSON/ZIP and remains private. Backend registration/parse/apply for manual ranking files is not yet claimed complete.


### CF-064 Pilot UI checkpoint

Pilot source **v2.15.22** now implements the first Statistics/Compare IA increment:
- sidebar group **Statistics & Insights**;
- primary **Statistics & Rankings** route;
- primary **Compare** route;
- QILT/PRISMS moved to Statistics drill-down routes rather than separate sidebar concepts;
- Data Operations groups Layers 1–4, Evidence and Jobs;
- Quality & Review groups Completeness / Review;
- Administration adds **Sources & Imports**;
- Statistics page uses current QILT/PRISMS counts/periods and explicit not-yet-ingested QS/THE states;
- Compare adds dataset toggles and explicit QILT year selection; QS/THE remain disabled until CF-063 ingestion exists.

Pilot head: `msinghbs-ai/Coursefinder-Pilot@4d5276c97792e370a8dca253183dea6a359a2c19`.

Frontend build job in workflow `33551442693` completed the production build step PASS; browser smoke was still running at this bounded checkpoint. Deployed UAT `33551441967` was also still running. Do not claim deployed browser PASS yet.


### CF-063 / CF-064 ranking backend checkpoint

Pilot backend now includes:
- private `ranking` schema and seven ranking tables;
- RLS enabled on every ranking table;
- direct browser grants revoked;
- secured `ranking_summary`, `ranking_filters`, `ranking_observations`, `ranking_imports` reads through `public.admin_read`;
- Provider/Course/Compare ranking context helpers;
- private Evidence-backed manual publisher upload registration;
- Edge Function `ranking-publisher-import` v1 with JWT + role-rank checks, MIME/size validation, SHA-256 duplicate handling and cleanup on registration failure;
- FK index hardening.

Pilot UI is now **v2.15.23** and supports Statistics & Rankings, Sources & Imports, dataset/year selection in Compare and dynamic QS/THE rendering when accepted observations become available.

No QS/THE observation rows have been accepted yet. The next functional gate is parser/source qualification + Provider mapping, not more UI scaffolding.


## CF-067 QS / THE Layer 1 ranking ingestion

Status: **IMPLEMENTED / TARGETED UAT ACTIVE**.

Pilot Layer 1 now registers three Global ranking sources:
- QS World University Rankings 2026;
- QS World University Rankings 2027;
- Times Higher Education World University Rankings 2026.

Operational path:
- Layer 1 source card → Validate / Run;
- ranking dispatch through `layer1-operations-control` v4;
- `ranking-layer1-etl` v1 parses the latest governed authorised CSV/XLSX publisher Evidence artifact;
- exact/tied/banded/reporter/unranked semantics are preserved;
- exact Provider name + country can auto-map;
- unresolved publisher institutions remain unmapped and are retained for review;
- no Provider is manufactured;
- Layer 1 ranking card links directly to pre-filled Administration → Sources & Imports when a publisher file is needed.

The Layer 1 read projection now supports **GLOBAL** scope and returns ranking system, edition, acquisition mode and source scope.

Admin UI release: **v2.15.26**.

No real QS/THE observations are claimed accepted yet. First authorised publisher-artifact dry-run/apply is the remaining data acceptance gate.


### CF-067 targeted proof

Implementation head `Coursefinder-Pilot@e431c4e18a0da65a770f98a426b5e8dcebf3c603`:
- Frontend Build `33576970066` PASS;
- Deployed UAT `33576969873` PASS;
- Supabase Security 156 INFO / 0 WARN / 0 ERROR;
- ranking Global source read PASS.

Permanent source contract added at `tests/uat/cf-067-ranking-layer1-contract.spec.mjs`. Admin release notes advanced to v2.15.26.


## CF-069 Course detail contextual helper ACL restoration

User UAT on 2 September 2026 exposed a Course detail failure: `permission denied for function admin_contextual_insights_v2`.

Root cause was CF-061 ACL drift: `public.admin_read` remained the intended SECURITY INVOKER browser boundary, while the newly introduced `security.admin_contextual_insights_v2` and `security.admin_contextual_compare` helpers had authenticated EXECUTE revoked. Course/Provider detail and Compare therefore could not complete under a signed-in browser role.

Pilot migration `20260902011913` restores authenticated EXECUTE only for those two read-only, internally role-checked helpers while retaining public/anon denial. Authenticated rollback-only runtime proof returned the Course detail and `contextual_insights` payload successfully. Post-change advisors: Security 156 INFO / 0 WARN / 0 ERROR; Performance 185 INFO / 0 WARN / 0 ERROR.

Repository migration: `Coursefinder-Pilot/supabase/migrations/20260902011913_cf_069_contextual_detail_invoker_acl_fix.sql` at `7e9fa8fa76d3b333c38f7ed934678eb2fb90793e`. No frontend asset was changed; parallel v2.15.27 work is preserved.


## CF-068 QS direct XHR acquisition

Status: **IMPLEMENTED / DEPLOYED UAT ACTIVE**.

QS 2026 NID `4061771` direct static publisher XHR returned HTTP 200 with **1,501 rows** and is now the primary Layer 1 acquisition route for that edition. Raw JSON is retained as private Evidence and direct JSON APPLY remains disabled pending dry-run/access acceptance.

QS 2027 NID `4153156`: equivalent static asset returns 404 and the current REST endpoint returns a Cloudflare managed challenge from Pilot Supabase egress. No bypass is attempted; manual authorised-file fallback remains available.

Admin release: **v2.15.27**.


### CF-068 targeted proof

Deployed targeted workflow `33579305870` / job `100090017855` PASS. QS 2026 validates 1,501 rows with retained JSON Evidence and SHA-256; QS 2027 access challenge is represented as governed 409. Direct ranking APPLY remains disabled and `ranking.observations` remains 0.


## CF-070 Provider Compare Interaction & Theme Correction

User UAT reported Provider Compare as non-working and the Compare header as visually inconsistent with the rest of the Admin.

Implemented in Pilot source **v2.15.28**:
- `ComparisonWorkspace` now updates selected Provider/Course IDs immediately through one `commitSelection` path before persisting the hash route;
- Add / Remove / Clear / type-switch share the same bounded, de-duplicated state transition;
- stale comparison payload is cleared while the next governed comparison read loads;
- Provider search is explicitly labelled for accessibility;
- Compare header now uses the established CourseFinder layer-header palette (`#172033` background / `#25324a` border / indigo active control) instead of the earlier bespoke gradient/magenta theme.

Live Pilot server read remains healthy and CF-069 authenticated helper ACL is deployed. No QILT/PRISMS/ranking/Search/Publication/Zoho authority changed.

Regression test `tests/uat/cf-061-qilt-prisms-comparison-deployed.spec.mjs` was strengthened to require:
- immediate **2 / 6 selected** after Add;
- selected IDs persisted in the route;
- governed two-Provider response;
- computed header colour/border matching the canonical theme;
- existing tablet/mobile overflow checks.

Corrective candidate:
`msinghbs-ai/Coursefinder-Pilot@9e30626e24bd1eb20a3b8fb5879ba3354a7a138d`.

At the last bounded status check no commit status had attached yet; CF-070 remains **IMPLEMENTED / TARGETED UAT PENDING**.


## CF-071 Layer 1 Operations naming alignment

The primary Admin Data Operations label is now standardised to **Layer 1 — Operations**. The top-level page title and embedded Layer 1 workspace now use Operations terminology rather than presenting the operational control plane as “Authority”. Historical `#layer-1-regulatory` and `#layer-1-authority` routes remain compatible and resolve to the canonical `#layer-1-operations` surface.

Pilot UI is **v2.15.29**. Source, parser, authority, Evidence, execution-role, Search and Publication semantics are unchanged. Layer 1 source/settings configuration remains under Administration → Layer 1 sources.

Implementation refs: `f22415d229838411067678352030dbf20e89d1fd`, `46fbde662340a39ac609c224ead81fd4d31c4517`, `cc3aba52cc3c693e45716c9798c844864a701afc`, `c6e11bfb8b39f97cd4ba96a599482a830387e036`, with Layer 1 acceptance adapters aligned at `fa766d68afbf9d4ee17b73364d2e9a9b0c8b5012`, `4ec367a889da3faccfc479fd36993f78fedc1254` and `f71b37f317d784273278617bc951042994fb9cc0`. Targeted deployed UAT is active; an earlier intermediate run was cancelled by workflow concurrency and is not a functional failure.


### CF-071 QS Provider reconciliation

QS 2026 retained publisher JSON was reconciled without APPLY. AU result: **36 QS institutions / 35 deterministic Provider mappings (97.22%) / 0 unmatched / 1 governed ambiguity**. Fourteen publisher-name variants are retained in `catalogue.provider_aliases` with QS source provenance; 21 institutions match canonical/display name directly. Victoria University remains unresolved between active CRICOS Providers `00124K` and `02475D`; no arbitrary Provider selection is authorised. Deployed targeted UAT `33586539099` PASS; frontend build `33586539127` PASS; `ranking.observations` remains 0.


## CF-072 Layer 1 source configuration card UI restoration

User UAT confirmed that Administration → Layer 1 sources in v2.15.29 still rendered browser-default fields even though Layer 1 Operations itself was correctly themed. Root cause: the configuration component reused Layer 1 CSS classes but did not mount the shared `STYLES` block.

Pilot v2.15.30 now mounts the shared Layer 1 styles and presents source configuration as responsive CourseFinder cards with the same navy/indigo visual language, regulatory/statistics status badges, grouped Source & authority / Cadence & guardrails sections, source metadata, safe-maintenance guidance and consistent Validate / Dry run / Save actions. No source authority, parser, Evidence, Search or Publication semantics changed.

Implementation refs: `8b4fbe1565f889a13a6f0551a311b2041dcc252b`, `58270afb4037fbe5cad53b2c5bdbacc521380183`, `3df210e7be39abd402b6a62aa334d0095fa21af2`, `3dd49fb09b1df602ecdff0fdb28d3083c1bed4d8`, `73ba1836547c913f40a2f5aa19696d8f09e6186f`, `1d802f0310ffb8bbd1f3409925fa442f938deae0`. Targeted deployed UAT is active.


## CF-073 — Administration Acquisition route render-crash correction — 2 September 2026

User-reported Pilot defect on `/#administration?section=layer2-providers` was traced to a browser render exception in v2.15.30: `Layer2ExecutionPolicySettings` referenced `ShieldCheck` without importing it. For privileged roles this could unmount the routed React tree; Back/Forward then changed hashes while the UI remained blank until refresh.

Pilot v2.15.31:
- explicitly imports `ShieldCheck`;
- wraps routed workspaces in a route-keyed error boundary so a future page-local render failure cannot permanently unmount the Admin shell;
- preserves existing role, credential, Layer 2 policy, Evidence, Search and Publication boundaries;
- adds permanent deployed regression `cf-073-administration-acquisition-route-deployed.spec.mjs`.

Accepted Pilot head: `c546c2c3bf87e41154a2c5f5d7b6d554026deba4`.
Frontend build `33590571059` PASS, including build job `100123554410` and browser-smoke job `100123640329`.
Deployed targeted UAT `33590571041` / job `100123554544` PASS: **1 passed (4.6s)**, direct Acquisition route + Administration overview + browser Back recovery on Worker v2.15.31.
