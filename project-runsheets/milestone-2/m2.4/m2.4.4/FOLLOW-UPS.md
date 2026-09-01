# M2.4.4 Follow-ups

| ID | Origin | Item | Status |
|---|---|---|---|
| M244-FU-001 | M2.4 carry-forward | Reconcile Layer 1/2/3 housekeeping and retention boundaries. | COMPLETE |
| M244-FU-002 | M2.4 carry-forward | Reconcile cross-layer scheduling/recheck orchestration and duplicate-work prevention. | COMPLETE |
| M244-FU-003 | M2.4 carry-forward | Verify stuck/stale/provider/model/storage/budget alert coverage. | COMPLETE — no invented storage threshold |
| M244-FU-004 | A14 | Reconcile provider/model telemetry continuity across operational paths. | COMPLETE |
| M244-FU-005 | Documentation | Reconcile Guides, Runbooks, release state and troubleshooting. | COMPLETE |
| M244-FU-006 | M2.4.3 acceptance | Track recovered timing-sensitive M2.3 Important Links/Important Dates desktop flake as non-blocking UAT hygiene evidence. | OPEN / NON-BLOCKING |
| M244-FU-007 | A15 | Apollo credential remains absent. | BLOCKED / CONFIGURATION / NON-BLOCKING |
| M244-FU-008 | Layer 1 governance | Canonical Provider website source corrections discovered by A15. | OPEN / NON-BLOCKING |
| M244-FU-009 | RMIT | Frozen 212-record canonical promotion. | BLOCKED / SEPARATE AUTHORITY |
| M244-FU-010 | NZ L2 | First-party Course enrichment. | DEFERRED / SOURCE QUALIFICATION |


## Entry reconciliation checkpoint — 30 August 2026

- M244-FU-001 — Layer 1/2/3 housekeeping reconciliation: **IN PROGRESS**.
  - first material gap found and corrected: stale legacy Layer 1 `regulatory_sync` `pipeline.jobs` recovery;
  - Pilot commit `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`;
  - migration `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery`;
  - exactly one stale job recovered; zero governed Evidence/history deletion;
  - post-change advisors unchanged at 135 Security INFO / 169 Performance INFO, 0 WARN/ERROR.
- Continue M244-FU-001 by reconciling Layer 2 batch/provider-attempt recovery and Layer 3 stale-execution recovery as one cross-layer policy map before adding any further mechanism.


## Implementation reconciliation — 30 August 2026

- **M244-FU-001 COMPLETE:** L1 45m/live-heartbeat exclusion; L2 provider/orphan/batch policy windows; L3 20m stale interpretation recovery. No duplicate recovery path and no governed Evidence/history deletion.
- **M244-FU-002 COMPLETE:** general/L1/L2 schedulers dedupe active targets; no queued/running L1–L3 refresh work at checkpoint. Historical blocked L3 and queued L4 human-resolution rows retained.
- **M244-FU-003 COMPLETE:** L1 and L2 alert coverage retained; L3 operator alert surface added through `layer3_ops_alerts`. Current L3 alert count is zero. Evidence storage observed at 6,248 objects / 3,781,700,044 bytes; no authoritative threshold exists, so none was invented.
- **M244-FU-004 COMPLETE:** active L2/L3 code paths retain A14 telemetry where vendor/runtime data exists; missing historical/vendor usage remains unavailable.
- **M244-FU-005 COMPLETE:** Runbook v1.8, Data Operations Guide v1.6 and PIM Admin Guide v1.22 created; migration-history alias and troubleshooting boundaries documented.
- **M244-FU-006 OPEN / NON-BLOCKING:** retain M2.4.3 Important Links/Important Dates timing-sensitive desktop flake/retry as hygiene evidence unless reproduced as a product defect.

Next gate is bounded integration desktop/mobile.

## A16 follow-ups — 30 August 2026

| ID | Origin | Item | Status |
|---|---|---|---|
| M244-FU-011 | A16 / A15 coverage | Produce explicit 60/60 AU/NZ international-student/admissions contact-channel dispositions from governed first-party Evidence; extraction/classification occurs in Layer 3. | COMPLETE |
| M244-FU-012 | A16 / Layer 4 | Implement governed field-level Layer 4 override ledger/effective-value resolution across editable platform fields. | COMPLETE |
| M244-FU-013 | A16 / Audit | Retain actor, time, before/after, reason, optional comment/Evidence, supersede/revert history for every L4 decision. | COMPLETE |
| M244-FU-014 | A16 / Publication | Implement publication as a separately role-gated, auditable Layer 4 decision rather than a normal editable boolean. | COMPLETE |
| M244-FU-015 | A16 / Security | Define editable/elevated/immutable field classes and prove server-side RBAC plus anonymous/insufficient-rank negative paths. | COMPLETE |

The pre-A16 final acceptance run remains evidence only and cannot close these follow-ups.


## A16 implementation checkpoint — 30 August 2026

- M244-FU-011 COMPLETE: explicit 60/60 Provider dispositions retained (11 published contact found; 49 not found in qualified Evidence). Dedicated Layer 3 contact benchmark run `b16d1801-977e-4aaf-84da-e3b2726ac7ba` PASS: 3/3 retained first-party Evidence cases + 3/3 controls, exact pinned model, 8 calls, 16,702 input / 3,761 output tokens, recorded cost USD 0.
- M244-FU-012 COMPLETE: append-only Layer 4 effective-value override ledger implemented across Provider, Course, Campus, Scholarship and Provider-contact fields; source/canonical/Evidence/history remain preserved.
- M244-FU-013 COMPLETE: actor/time/before-after/reason/comment/Evidence/supersede/revert audit contract implemented and Admin-visible.
- M244-FU-014 COMPLETE: publication override is a separate rank-5+ auditable decision and does not itself authorise Production, Website or Zoho cutover.
- M244-FU-015 COMPLETE: editable/immutable registry expanded to 50 governed fields (21 immutable); anonymous A16 RPC execution denied; browser-facing RPCs refactored to SECURITY INVOKER via non-exposed `l4_api`; Security Advisor returned to 0 WARN / 0 ERROR.
- Targeted A16 deployed UAT run `33308932765`: PASS. Frontend build run `33308932790`: PASS.

Next gate: exactly one A16-aware bounded integration desktop/mobile candidate.


## A19 Scholarship scheduled ETL / maintenance — 31 August 2026

- Existing runtime ETL found and reconciled: `scholarships-au-etl` v2 (`scholarships-au-etl-v0.1.1`), plus active `layer2-scholarship-extract-v2`.
- ETL supports qualified AU Study Australia and DFAT Australia Awards feeds with private Evidence/content-hash/source-record lineage and governed apply semantics.
- Deployed ETL source reconciled into Pilot repo at `a3935c795c32624a5bf6f91449801f502b7259f4`.
- A19 migration `20260830195236_m2_4_4_a19_scholarship_scheduled_etl_maintenance` mirrored at Pilot commit `b59d5c5f7870987edda3d0e7aebce97d7592314a`.
- Active schedules: Study Australia every 24h (bounded max 50, pages 1–5); DFAT Australia Awards every 168h. Scheduler cron evaluates hourly at minute 43.
- Daily Scholarship maintenance cron runs 05:20 UTC and idempotently reconciles only explicit Course/Provider include scopes; Evidence/source history are not deleted.
- First maintenance run `8daf3923-d450-448c-b625-ba599c34e416` PASS: 1,500 deterministic mappings; 13 source records; 3 unapplied; 42 discovery candidates; 0 stale; 0 Evidence deleted; 0 source records deleted.
- First DFAT scheduled ETL request `2383` returned HTTP 200 and applied 1 Scholarship / 1 cycle / 2 windows / 9 criteria / 9 coverage rows with Evidence.
- Study Australia request `2384` remains in-flight at this checkpoint; do not duplicate-dispatch it. Next scheduler due state has already advanced by 24h.
- Security Advisor: 0 WARN / 0 ERROR. Performance Advisor: 0 WARN / 0 ERROR.


## A20 UniPIM-style UI/IA — 31 August 2026

- Addendum: `EXECUTION-ADDENDUM-A20-UNOPIM-STYLE-UI-IA-CENTRAL-ADMIN.md`.
- Reference approach: task-first PIM catalogue navigation; configuration grouped centrally; record attributes grouped into meaningful cards; filters/listings optimised for routine data work; advanced/raw settings progressively disclosed.
- Pilot source `957f967a3bfd32e6d2a0bb2e5f392b07ba62f383`: primary navigation now exposes one `Administration` entry rather than separate Sources / Attributes / Settings / Refresh policy / Onboarding config peers.
- Important Links and Important Dates remain Operations reference registries, consistent with the prior parent-menu requirement.
- Hidden/deep routes remain recognised for backwards compatibility while the normal operator journey starts at Administration.
- Next A20 work: validate frontend build/tablet navigation; refine Administration sub-sections for Sources & Onboarding, PIM Configuration, Scheduling, Acquisition, AI and Platform; remove duplicated advanced settings from Layer 1–4 operational views while preserving effective-status readouts.


## A21 permanent Layer navigation / final Pilot placement — 31 August 2026

- Addendum: `EXECUTION-ADDENDUM-A21-PERMANENT-LAYER-NAV-NON-FLOATING-FINAL-PILOT-UI.md`.
- Pilot commits:
  - `38e969122a4acf16b1057b09f6bac0601d59d16b` — exported Layer 3/4 and registry workspaces for canonical embedding;
  - `ed087ee6ce5dd72c544a4fa0300ee499e076999d` — Layer 2 embedded workspace mode;
  - `2f9d28caa0a5daa6953f7203d5007424bd05b564` — Layer 1 embedded workspace mode;
  - `3f08d9817c89cb2853990c3bd046b2da0b3ecfb0` — canonical Operations routes for Layer 1/2/3/4;
  - `37e5a3d4e0ea2e2576723f5e5da3c1891ae4a043` — removed global floating Layer/config feature mounts from `index.html`;
  - `59c06a316f9df84b23498cb92a5aae301553db4a` — legacy Layer route aliases retained;
  - `c075f408ae2c0d490f142e08e1e0a58df0645314` — permanent A21 navigation UAT;
  - `0daa88bdc71afdc27256288e7bbf42b5f50efa55` — A21 UAT wired into targeted/integration/acceptance suite resolution.
- Canonical Operations placement: Layer 1 — Authority; Layer 2 — Enrichment; Layer 3 — AI Interpretation; Layer 4 — Human Resolution; Important Links; Important Dates; Jobs.
- Layer 3 and Layer 4 are now separate canonical routes.
- Old visible global mounts for Layer 1, Layer 2 ops/platform/provider/trial, combined M2.3 Layer 3/4, Layer 3 credential, pipeline ops and Scholarship selection are disabled in `index.html`; source modules remain for controlled embedding/Administration migration.
- Admin/PIM Design Decisions advanced to `docs/coursefinder-admin-pim-design-decisions-v1.24.md`, Decision 34.
- Pilot rule: no trial/floating navigation experiments in normal user-facing shell; UI must demonstrate intended final placement with concise useful information and actionable buttons.
- Validation head: `0daa88bdc71afdc27256288e7bbf42b5f50efa55`; frontend build run `33335240424` and targeted deployed UAT run `33335240463` active at checkpoint. Do not duplicate while active.


## A21 corrective regression — legacy navigation mutator / shared layer-status RPC — 31 August 2026

User-visible evidence showed two genuine regressions:
1. `src/data-acquisition-nav-entry.js` was still globally loaded and rewrote the canonical React navigation after render. It renamed groups, injected the obsolete Data Operations menu and routed Layer 1 to the legacy `#settings` surface.
2. `security.admin_layer_status_summary()` contained stale schema/helper assumptions, producing the cross-screen `column "layer" does not exist` banner.

Corrective actions:
- removed `data-acquisition-nav-entry.js` from `index.html` at Pilot commit `798e4ad846075696b7a38e00c8f8a37fbba5ea2c`;
- stopped Users & Roles from injecting itself into Operations at `c8fe02cee96460b068ad561f6a086f132ef3b76d`;
- moved Users & Roles entry to the central Administration workspace and aligned visible shell version to v2.15.12 at `1959be0d7a78d9490925efc4d808b6bc7f622d2b`;
- release note v2.15.12 recorded at `268d26d10b9ea6229ef776c59b0a9db8bc01b46a`;
- runtime layer-status corrections deployed as migrations:
  - `20260830234349_m2_4_4_a21_layer_status_source_metadata_fix`;
  - `20260830234440_m2_4_4_a21_layer_status_evidence_metadata_fix`;
  - `20260830234526_m2_4_4_a21_layer_status_candidate_helper_fix`;
- current runtime `security.admin_layer_status_summary()` executes successfully and returns L1/L2/L3/L4/Scholarship summary data;
- permanent A21 UAT now rejects `.go7-nav-item`, `html[data-go7-navigation]`, obsolete `Data Operations` / `Governance & Platform` groups, and the `column "layer" does not exist` banner at Pilot commit `b3e1a3596371c479f8e715fc83c96d7b7466043f`;
- Admin/PIM design baseline advanced to `docs/coursefinder-admin-pim-design-decisions-v1.24.md`, Decision 35.

Validation head `b3e1a3596371c479f8e715fc83c96d7b7466043f`: frontend build run `33342743511` and deployed targeted UAT run `33342743510` active at checkpoint; do not duplicate while active.


## A21 filter flashing regression correction — 31 August 2026

User-visible Course filter flashing was traced to the legacy `src/screen-state-entry.js`, which restored saved state by programmatically opening each filter and clicking options sequentially. This made visible popovers jump across Country / State / Provider / Study level while async options loaded.

Correction:
- removed `screen-state-entry.js` from the global Pilot shell at `0d79d37a357e739721f9ce847721eec7b9bf0acc`;
- retained the canonical React-native Catalogue restoration already implemented in `src/mature-main.jsx`, which restores `query`, `filters`, `filterLabels`, advanced state, sort and direction directly from localStorage;
- added permanent deployed UAT asserting reload/restoration leaves `.m-filter-popover` count at zero until the operator explicitly opens a filter at `5f5b94c6271e9403ce3c69f6d69fd2efb008f681`;
- release version advanced to v2.15.13; canonical shell/document title aligned by `6cb5b4de5171e045d4523b5f2878923f72098a31` / `afc0a58ee7646eb21a6484aeee560386a4889ad2`;
- replacement build run `33343098440` and targeted deployed UAT run `33343098402` queued/pending at checkpoint; do not duplicate while active.


## A22/A23 implementation checkpoint — 31 August 2026

### A22 responsive Provider/Course detail blades
- `9776ae86c3fb602ce6aed165458195b10a20542d`: detail drawer now has a single `.m-drawer-content` scroll owner under the header.
- `e7f5a332384b5269a6b096fd795aafe3dd693cf2`: responsive widths introduced: Provider up to 1040px / 62vw; Course up to 1100px / 66vw; tablet 96vw; mobile 100vw.
- `45f79da4abf2ef172a9228293c4fe7f003fbe6c7`: desktop/tablet vertical scrollbar made explicit/visible; mobile remains auto-scroll.
- permanent A22 viewport UAT: `446226df3569bfb3111abb9cd177caac2016c9de`; initial run was cancelled by subsequent pushes and requires one settled-head targeted proof.

### A23 background/quota-aware Layer 2
- Firecrawl runtime authority at implementation checkpoint: enabled/Vault credential configured; 5,000 monthly page units; 250-unit reserve; 30/min; concurrency 2; no silent paid fallback. At read-only validation: 742 used / 4,258 remaining / 4,008 usable before reserve.
- AU scope preview: 1,546 Providers / 26,648 Courses; only 2 Providers currently fully qualified; 1,544 still require qualification. This proves the previous manual 5-Provider UI was not a production operating model.
- qualification policy now defaults to 50 Providers/batch and 10 Course identity samples/Provider; samples are checked against one acquired Provider seed page and are not separate production Course scrapes.
- production policy defaults to 500 Courses/wave, max 1,000, schedule remaining=true, route=`scraper_first`.
- qualification scheduler `coursefinder-layer2-qualification-scheduler` active every 5 minutes; worker retains safe two-Provider invocation slices and governed continuation nonces.
- Firecrawl-first qualification candidate routes: Firecrawl priority 5, Direct HTTP priority 20; paid alternatives remain disabled in this workflow.
- five inert legacy manual `planned` qualification runs were retained as history but marked cancelled/superseded by A23 so they do not block background scheduling.
- `dfb761eb6a015bbab759c903e9377d92e8211eea`: Layer 2 authenticated Edge control exposes background preview/start and central policy read/update; deployed `layer2-sync-control` v7 JWT=true.
- `4361cdaf624e862fab33fcaf4b5d7ca4ad2d6ad7`: operator Layer 2 UI now exposes effective policy/quota and one `Start background enrichment` action; manual 5×10 / Wave 1 / route controls removed.
- `0bd209dfe157d3492f0f1fb68cb3029b46e04787`: Layer 2 execution policy editing centralised under Administration.
- runtime migration `20260831011253_m2_4_4_a23_quota_background_firecrawl_execution`, mirrored at Pilot commit `e76852f75cf6c6034dd08f225078c793d5923bd3`.
- permanent UAT: A21 updated at `bb68153835457e06f0fa92958417af98518c07fe`; A23 suite `79a49c96785e0963136575df2b85868aed3d40f9`; workflow inclusion `31fae4cd1db7c6267473199937e0b82597591383`.
- Security Advisor: 0 WARN / 0 ERROR (146 INFO).
- Performance Advisor: 0 WARN / 0 ERROR (179 INFO).
- Final A23 build/UAT on `e76852f75cf6c6034dd08f225078c793d5923bd3` active at checkpoint; do not duplicate/cancel it.


## A25 Evidence type-aware preview / screenshot lineage integrity — 31 August 2026

User-visible evidence regression confirmed: one UQ screenshot was being associated with hundreds of unrelated Evidence artifacts because A13 used empty-string COALESCE matching across nullable Evidence IDs.

Runtime truth before correction:
- only 2 actual `layer2_screenshot` artifacts existed;
- JSON remained present at scale, including 2,041 `layer2_extraction_input` JSON artifacts, 1,047 regulatory JSON snapshots, 61 source JSON snapshots and 11 raw Layer 2 JSON artifacts;
- the erroneous UQ screenshot `48733f50-959b-43fb-b495-71aa518a10e8` resolved as a related visual for hundreds of unrelated HTML/JSON artifacts across multiple sources/Providers.

Correction:
- runtime migration `20260831050125_m2_4_4_a25_evidence_visual_lineage_integrity`;
- Pilot migration mirror `8032cb41647eff1f8e0118ce0da9bde1e385b8b6`;
- related screenshot requires an exact HTML artifact ID match to the same Layer 2 provider attempt; null/empty/provider-wide inheritance removed;
- post-fix 1,500-artifact sample resolves only one valid related visual: the exact RMIT HTML artifact `55026c98-20f6-4500-9173-071070b85761` → screenshot `e465eb03-e983-4007-b3f5-d63d00c925fe`.

UI:
- `525de38762030db42ef061dd61bb37207dd516c9`: Evidence list/detail now displays explicit format labels and type-aware previews;
- JSON/text preview comes from the selected artifact's own signed private object and is bounded to 20,000 characters;
- screenshot/image Evidence previews its own image;
- HTML may show only an exact same-attempt related screenshot;
- PDF remains signed-preview; workbook/archive/non-browser-safe formats remain explicit format/download artifacts rather than receiving a screenshot;
- `35b22854fcc18989322ef2b9f22c0410a95509e9`: type-aware preview styling.

Permanent UAT:
- `e9289a2afeb5d6e43a8169786c1ad6b89b777db5`: JSON=no screenshot, HTML=exact related screenshot, screenshot=own image.
- `ee49740da33f09f5378395d04b9f2d807b06a9d7`: A25 suite wired into targeted/integration/acceptance resolution.
- targeted deployed UAT run `33359217661`: PASS.
- paired frontend build `33359217695` was still running at this checkpoint.

Architecture baseline:
- Admin/PIM Design Decisions advanced to `docs/coursefinder-admin-pim-design-decisions-v1.24.md`, Decisions 36–37.

## M244-FU-016 — A23 background qualification continuation recovery

- Status: **COMPLETE / RECONCILED — 1 September 2026**.
- Original run `94557562-e292-4ed9-bdf3-8b2dcc370c6b` completed after autonomous continuation repair.
- Continuation repair: `c473a785fce3a31c90349044e05926f77a2fa2f7`; targeted UAT/build PASS.
- Finalizer/handoff completion: `adf5ac1d85bff0291355ac44650dc149deedcb09`; targeted UAT `33390795147` PASS; build `33390795285` PASS.
- Final runtime reconciliation: no active/planned qualification waves; qualification/finalizer crons latest-success; Firecrawl 1,820/5,000 used with reserve intact; Advisors 0 WARN/0 ERROR.
- Governed downstream queues are now explicit and expected: Layer 3 source-pattern requests + Layer 4 source-resolution requests.
- Closed; bounded integration nomination is permitted.

## M244-FU-017 — Finalise Layer 2 production run / job / Evidence / Dashboard lineage
- **Source:** M2.4.4 A26, 1 September 2026
- **Status:** COMPLETE / FINAL ACCEPTANCE ACTIVE
- **Proof:** stable parent `c65e67a6...` → wave `1bb1504d...` → Firecrawl batch `accd42a2...` → Firecrawl Jobs/Evidence with identical parent/wave lineage.
- **Runtime hardening:** terminal partial non-blocking; selected-provider Firecrawl handoff; timeout-safe chunks; stale acquisition recovery; resume without duplicate scrape; child heartbeat; exact parent aggregation.
- **Final focused proof:** build `33459679420` PASS; UAT `33459679417` PASS.
- **Final acceptance:** candidate `41428941...`; UAT `33460038608` active.
- **Owner:** M2.4.4
- **Target:** close with final acceptance

## M244-FU-018 — Administration parent route renders empty / sub-context clicks ineffective
- **Source:** M2.4.4 A27, 1 September 2026
- **Status:** COMPLETE / FINAL ACCEPTANCE ACTIVE
- **Implementation:** canonical `#administration?section=<key>` route state.
- **Proof:** direct link, refresh, back and forward restoration; focused UAT `33456205806` PASS and final closure UAT `33459679417` PASS.
- **Final acceptance:** `33460038608` active.
- **Owner:** M2.4.4
- **Target:** close with final acceptance

## M244-FU-019 — Rationalise Layer 2/3 blocker, run and Evidence summaries; remove experimental UI
- **Source:** M2.4.4 A28, 1 September 2026
- **Status:** COMPLETE / FINAL ACCEPTANCE ACTIVE
- **Implementation:** parent-linked Layer 2 progress, scheduled-vs-idle correction, Jobs/Evidence actions, concise blocker semantics, exact parent counts, cancelled corrective history and heartbeat visibility.
- **Proof:** focused UAT `33456205806` PASS and final closure UAT `33459679417` PASS.
- **Final acceptance:** `33460038608` active.
- **Owner:** M2.4.4
- **Target:** close with final acceptance

## M244-FU-020 — Reconcile RLS-disabled table introspection versus Security Advisor
- **Source:** M2.4.4 corrective runtime review, 1 September 2026
- **Status:** RESOLVED / RECONCILED — 1 September 2026
- **Finding:** all 15 observed RLS-disabled tables have no `anon` or `authenticated` table grants. `anon` and `authenticated` have no `pipeline` schema USAGE. The public UAT control table also has no anon/authenticated table grants.
- **Operational access:** a small subset of staging/qualification tables is service-role-only where required; most inspected pipeline tables are postgres-only.
- **Conclusion:** the tables are isolated by schema/grants and are not directly browser/Data-API reachable by anon/authenticated roles. The Security Advisor discrepancy is therefore explained; blanket RLS enablement is not required and could break governed service/RPC paths.
- **Security rule:** re-open only if exposed schemas, direct grants or browser access boundaries change. Never blanket-enable RLS without tested policies.
- **Advisor reconciliation:** fresh Security/Performance Advisor snapshots after the review are INFO-only; no WARN/ERROR security condition was introduced.
- **Owner:** M2.4.4
- **Target:** RESOLVED


