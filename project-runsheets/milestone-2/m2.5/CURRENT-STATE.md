# M2.5 CURRENT STATE

**Status:** ACTIVE / READINESS — PLATFORM FOUNDATION IMPLEMENTED; PRODUCTION PROVISIONING BLOCKED  
**Updated:** 1 September 2026  
**Production Change Control:** `CF-CHG-20260901-049`  
**Platform foundation Change Control:** `CF-CHG-20260901-051`  
**Layer 2 corrective Change Controls:** `CF-CHG-20260901-052`, `CF-CHG-20260901-053`  
**Layer 3 source-pattern corrective Change Control:** `CF-CHG-20260901-054`

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
`1605d15bca7ccb46620ce5bd12ca01805a3f30f4`.

CF-054 post-HTTP-reconcile trigger `dbd7bdde61e28fa49170875786066d7015ccd77d` produced run `33492617096` / job `99807392499` FAIL due only to a malformed Playwright assertion string. The corrected clean-rerun trigger is `1605d15bca7ccb46620ce5bd12ca01805a3f30f4`; no workflow status/run ID had been attached at handback.

Admin source UI version: **v2.15.17**.

Important deployment distinction: the external Cloudflare Worker is not currently publishing this source head; deployed browser acceptance for CF-053/CF-054 is blocked by Pilot Cloudflare Git deployment drift.

Deployed M2.5 migrations:
- `20260901060826 m2_5_platform_operations_maturity_foundation`;
- `20260901061041 m2_5_capacity_integrity_alert_classification`;
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`;
- `20260901062200 m2_5_layer2_run_observability_correction`.
- `20260901083800 m2_5_layer2_finalizer_fairness`;
- `20260901085000 m2_5_layer2_stale_pattern_control_handoff`;
- `20260901091500 m2_5_layer3_source_pattern_operator_handback`;
- `20260901091800 m2_5_layer3_source_pattern_legacy_completion_guard`;
- `20260901092500 m2_5_layer3_source_pattern_legacy_http_host_reconcile`.

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

### CF-054 legacy HTTP host reconciliation

The manual-governed source-pattern hand-back now supports retained historical `http://` Provider Evidence/source URLs while keeping the Layer 3 candidate itself HTTPS-only.

Rollback-only Sydney proof:
- `http://sydney.edu.au` retained Evidence → `https://sydney.edu.au/study/study-areas/law.html` candidate;
- hand-back → Layer 2 three-Course identity control;
- Provider not qualified;
- no canonical/Search/Publication mutation;
- rollback restored the original queued request and 10 `layer3_required` sample rows.

Current checkpoint: **227 pending dispatch / 66 pending control / 422 source-pattern queued / 0 completed / 0 interpretations**. No real model call or bulk drain has been performed.

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
