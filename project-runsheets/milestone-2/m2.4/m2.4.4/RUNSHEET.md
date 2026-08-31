# M2.4.4 RUNSHEET — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance

**Status:** ACTIVE  
**Change Control:** `CF-CHG-20260830-048`  
**Started:** 30 August 2026

## Objective

Complete the cross-layer operational checkpoint after accepted Layer 1, Layer 2 and Layer 3 maturity without changing authority boundaries or silently entering Production scope.

## Starting accepted baseline

- Pilot `96de9add3762a0594ebc371fba49d4d990ff4b45`;
- M2.4.3 final acceptance `33286437795` PASS;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR;
- Layer 3 Edges v5/v2/v9;
- Layer 3 housekeeping cron active;
- A15 frozen CLOSED/PASS.

## Workstreams

### W1 — Cross-layer housekeeping
Inventory transient jobs/nonces/reservations/temp state, retention and stale recovery. Governed Evidence, audit, source versions, contact history and canonical history must not be deleted.

### W2 — Scheduling/recheck orchestration
Reconcile Layer 1 regulatory scheduler, Layer 2 refresh scheduler and Layer 3 housekeeping/revalidation boundaries. Prevent duplicate/conflicting scheduled work.

### W3 — Replay/recovery/idempotency
Verify safe replay, stale-work recovery, duplicate-run protection and state reconciliation across layers.

### W4 — Alerts and operational thresholds
Verify/implement operator-visible alerts for stuck jobs, stale sources, provider/model failures, storage/usage growth and budget/quota conditions where evidence exists.

### W5 — Telemetry and operator visibility
Preserve A14 provider/model calls, latency, units/tokens/cost and outcomes. Do not invent unavailable usage.

### W6 — Documentation/handover
Reconcile Admin/PIM Guide, Operations Runbook, Data Operations guide, release notes and current-state docs.

### W7 — Acceptance
Targeted validation → bounded integration desktop/mobile → one final pre-blackout acceptance matrix.

## Explicit exclusions

Production cutover, broad Publication, Website/Zoho cutover, RMIT 212 promotion and deferred NZ L2 enrichment are not authorised here.

## Closure condition

M2.4.4 closes only after:
- cross-layer runtime reconciliation complete;
- material gaps corrected without authority regression;
- guides/runbooks/current-state synchronized;
- Security/Performance advisor changes explained;
- bounded integration PASS;
- final acceptance desktop/mobile PASS;
- change-control and programme baselines reconciled.


## Entry reconciliation — first corrective housekeeping fix

Cross-layer cron inventory:
- general refresh scheduler: active / latest success;
- Data Quality snapshot refresh: active / latest success;
- Layer 1 regulatory scheduler: active / latest success;
- Layer 1 housekeeping: active / latest success;
- Layer 2 refresh scheduler: active / latest success;
- Layer 2 housekeeping: active / latest success;
- Layer 3 housekeeping: active / latest success.

A stale legacy Layer 1 `regulatory_sync` job from 17 August 2026 remained `running` because Layer 1 housekeeping did not cover legacy `pipeline.jobs`.

Implemented/deployed:
- Pilot `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`;
- repository mirror `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery.sql`; deployed Supabase migration-history version `20260830021159`;
- `svc_layer1_housekeeping()` now recovers only abandoned `regulatory_sync` jobs older than 45 minutes and excludes any live Layer 1 run-queue heartbeat;
- no Evidence, source-version or canonical-history deletion.

Validation:
- pre-fix stale candidates: 1;
- recovered: 1;
- post-fix stale candidates: 0;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

No browser-facing behaviour changed; no release-note version change required for this database-only housekeeping correction.


## Cross-layer implementation checkpoint — 30 August 2026

### W1 / W3 — recovery, retention and replay

Reconciled and accepted policy map:
- L1 legacy regulatory Job: >45 minutes, but never while owned by a live L1 queue heartbeat within 30 minutes;
- L2 provider attempt: greater of 2× provider timeout or 300 seconds; orphan L2 Job >45 minutes; managed batch uses policy stale window (default 30 minutes);
- L3 reserved/calling interpretation: >20 minutes → provider_error with recovery provenance;
- no recovery path deletes governed Evidence/canonical history; L2 profile/provider/run history and L3 interpretation/benchmark history remain retained.

No second conflicting recovery mechanism was found or added.

### W2 — scheduling/recheck

General refresh scheduler, L1 scheduler and L2 scheduler are target-bounded and deduplicate active work. At reconciliation there were no queued/running L1–L3 refresh requests. Eight historical blocked L3 A11 source-pattern requests and seven L4 human-resolution requests remain intentionally preserved and are not scheduler duplication.

### W4 — alerts

Existing:
- L1 source/stale/variance/stuck/schedule health;
- L2 stuck run, paused profile, blocked items, provider failure streak and provider quota reserve.

Added genuine L3 gap:
- runtime migration `20260830071523_m2_4_4_layer3_operational_alerts`;
- runtime migration `20260830072215_m2_4_4_layer3_alert_admin_read_bridge`;
- rank-4+ `layer3_ops_alerts` through the existing governed `admin_read` boundary;
- stale execution, profile state/qualification, latest failed benchmark, provider-error streak and recorded cost-ceiling breach alerts;
- current alert-condition count: 0.

Observed private Evidence footprint: 6,248 objects / 3,781,700,044 bytes. No governed storage capacity threshold exists, therefore no artificial storage warning threshold was created.

### W5 — A14 telemetry

Active L2/L3 Edge execution paths retain provider/model identity, outcome and available latency/usage/cost telemetry. Latest L3 source-pattern benchmark retains exact model, 8 calls, 4,454 input / 832 output tokens, 3,096 ms max latency and recorded USD 0 provider cost. Unavailable vendor usage remains unavailable.

### W6 — documentation

Created:
- Operations Runbook v1.8;
- Data Operations Admin Guide v1.6;
- PIM Admin Guide v1.22.

### Validation

- all seven operational cron jobs latest-success after correction;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR;
- permanent `m2-4-4-cross-layer-operations-deployed.spec.mjs` added to targeted/integration/acceptance tiers;
- Pilot implementation source currently includes migrations through `20260830072215` and permanent UAT coverage.

Next gate: nominate exactly one bounded integration desktop/mobile candidate.


## Bounded integration failure evidence — run 33299250997

Candidate `55f867bc371fb961f38631129e746fad9d9ec00b` is terminal FAIL and remains immutable evidence.

Desktop:
- 44 passed;
- 2 failed after retry;
- M2.4.4 source-contract test failed because its checked-in assertion searched for unescaped `p_operation='layer3_ops_alerts'` while the migration correctly stores the PL/pgSQL replacement string using doubled SQL quotes;
- inherited performance test also exceeded the unchanged 3,000 ms Course-page interaction budget: 3,313 ms, then 3,962 ms on retry.

Mobile:
- skipped because desktop failed;
- published integration mobile context is failure/skipped, not an independently executed product failure.

Corrective source:
- `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- correction changes only the M2.4.4 checked-in test assertion to verify the stable `layer3_ops_alerts` contract token;
- no runtime, authority, Security, Evidence, Course-path or 3,000 ms performance budget was weakened.

The inherited Course performance failure is preserved and must be re-tested under the unchanged budget before promotion.


## Replacement bounded integration — PASS

Candidate `a256283bb5751dda727d8a6e4ae057abbffdcbbf` completed as PASS in deployed UAT run `33300281890`.

- desktop: PASS;
- mobile: PASS;
- corrective targeted run `33300234103`: PASS;
- first candidate `55f867bc371fb961f38631129e746fad9d9ec00b` / run `33299250997` remains immutable FAIL evidence;
- unchanged 3,000 ms Course interaction budget was retained.

Post-integration runtime reconciliation:
- all seven active operational cron jobs latest-success;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR;
- no active Layer 1–3 refresh requests; seven retained Layer 4 human-resolution requests remain queued;
- Layer 3 stale reserved/calling executions: 0.

Decision: bounded integration gate PASS. Exactly one final M2.4.4 acceptance candidate is authorised next under CF-CHG-20260830-048.

## A16 scope expansion — contact coverage and Layer 4 intervention

M2.4.4 now additionally owns active Addendum A16.

### W8 — Layer 3 international-contact coverage

Build on the frozen A15 cohort without redefining A15 history:
- Layer 2 retains first-party contact-page acquisition, URL and Evidence;
- Layer 3 classifies/extracts international-student/admissions URLs, contact/team URLs, institutional email, named/territory contacts and explicit unavailable/not-published dispositions;
- target is an explicit disposition for all 60 governed AU/NZ Provider profiles;
- no contact value is manufactured merely to achieve coverage.

### W9 — Layer 4 governed intervention

Implement the A16 Layer 4 override-ledger model:
- editable fields can receive an audited human override at any stage;
- original Layer 1/2/3 truth and Evidence remain immutable;
- effective values show an L4 marker;
- every decision records authenticated actor, timestamp, before/after, reason and optional comment/Evidence;
- revert/supersede is append-only;
- upstream refresh does not silently erase an active L4 override;
- publication is a separate consequential override/decision, not an ordinary field edit;
- editability and required role are server-governed.

### Gate consequence

Final acceptance candidate `6c480ed3b248f3b118f21dea80bb4d742ab8c282` / run `33303037986` predates A16. Preserve it as immutable acceptance evidence, but do not use it alone to close M2.4.4. A16 requires its own implementation, targeted validation and a later bounded/final acceptance sequence.


## A16 implementation + targeted validation PASS — 30 August 2026

A16 implementation is complete at Pilot source `44960cc8a61c4ee743840bd5aca3cf25f7c10094`.

Runtime/state proof:
- explicit AU/NZ contact disposition: 60/60 Providers = 11 `published_contact_found` + 49 `not_found_in_qualified_evidence`; no synthetic contact values;
- dedicated Layer 3 international-contact profile enabled/unpaused after benchmark run `b16d1801-977e-4aaf-84da-e3b2726ac7ba` PASS (3/3 retained first-party Evidence cases + 3/3 controls; exact model; 8 calls; 16,702 input / 3,761 output tokens; recorded USD 0);
- Layer 4 append-only effective-value override ledger covers Provider, Course, Campus, Scholarship and Provider-contact fields;
- field registry: 50 governed fields / 21 immutable;
- publication override remains a separate rank-5+ audited decision;
- browser-facing A16 RPCs are SECURITY INVOKER through non-exposed `l4_api`; anon execute denied;
- Security Advisor: 139 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 175 INFO / 0 WARN / 0 ERROR;
- all seven active operational cron jobs latest-success;
- no active L1-L3 refresh work; seven intentional queued L4 human-resolution requests retained.

Validation evidence:
- contact benchmark failed runs remain immutable evidence before corrective qualification;
- frontend import failure run `33308697271` retained; corrected frontend build `33308932790` PASS;
- targeted selector-only failure run `33308781849` retained; corrected targeted A16 deployed UAT run `33308932765` PASS.

Decision: M244-FU-011 through M244-FU-015 are complete. Exactly one new A16-aware bounded integration candidate is authorised next. The pre-A16 final acceptance candidate/run remains evidence only and cannot close M2.4.4.


## A16 bounded integration candidate active — 30 August 2026

- implementation source before marker: `44960cc8a61c4ee743840bd5aca3cf25f7c10094`;
- integration candidate marker: `0855720f9c102cfd8e26949f340d22c418b77560`;
- deployed UAT run: `33309171128` — active at checkpoint;
- paired frontend build: `33309171258` — active at checkpoint;
- required outcome: integration chromium-desktop PASS + chromium-mobile PASS under unchanged budgets;
- duplicate-candidate rule: do not nominate another integration candidate while this run is active;
- on PASS: record both results, reconcile runtime once, then nominate exactly one A16-aware final acceptance candidate;
- on failure: preserve immutable run evidence and correct only the exact defect/contract.


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


## Canonical navigation standard promoted — 31 August 2026

- Canonical UI navigation authority is the implemented Pilot repository registry in `src/mature-main.jsx`: `NAV`, `HIDDEN_ROUTES`, `PAGE_META`, and `routeFromHash()`.
- Standing Instructions now require all future UI work to follow/extend that registry and prohibit parallel top-level menu models or launcher-only permanent journeys.
- Administration remains the single normal configuration/settings entrypoint under A20.
- Hidden routes are backwards compatibility only, not primary navigation authority.
- Admin/PIM Design Decisions baseline advanced to `docs/coursefinder-admin-pim-design-decisions-v1.24.md`, Decision 33.
- Repo/runtime navigation truth overrides stale chat assumptions, screenshots and older menu documentation.


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


## A21 Layer 2 floating-shell regression correction — 31 August 2026

User-visible Layer 2 still appeared as a floater with the canonical navigation hidden.

Root cause:
- Layer 2 was correctly routed from `src/mature-main.jsx::NAV`, but the embedded workspace reused `.l2o-shell` from its old standalone implementation.
- `src/layer2-operations.css` still declared `.l2o-shell { position: fixed; inset: 0; z-index: 2200; ... }`, covering the canonical sidebar and making the embedded route look like a separate application.
- `src/layer2-enrichment-scope-entry.js` was also still loaded globally as a post-render Layer 2 label mutator.

Correction:
- `923b290a906b30b50769f696581d246f5e4c1826`: Layer 2 workspace now explicitly marks embedded mode and uses `role="region"` instead of dialog semantics.
- `33f03b7fb8628c3e77030802a43524a57526960b`: full-screen fixed positioning is now scoped to non-embedded Layer 2 only; `.l2o-embedded` is normal in-page content.
- `6095b05c0c0d8a64bcf6913a1a46fc4a9135db4c`: removed global Layer 2 post-render label mutator from `index.html`.
- `46fa6f64212b87deb89cdd641c01961e89ecc67a`: permanent A21 UAT now asserts Layer 2 is `l2o-embedded`, `role="region"`, and the canonical sidebar remains visible.
- Final validation head: `46fa6f64212b87deb89cdd641c01961e89ecc67a`.
- Build run `33345415420` and deployed targeted UAT `33345415500` active at checkpoint. Do not duplicate.


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


## A24 unified Layer header scheme — 31 August 2026

User accepted the Layer 2 header colour treatment as the visual baseline for all four Layer workspaces.

Implementation:
- Layer 1 header changed from white to the Layer 2 navy/violet/white treatment: Pilot `14ab365ca436d882ea467debab35ecc54761eb10`.
- Layer 2 marked as the shared baseline with `data-layer-header="2"`: `0e5bae21c04190b9379d41ffd527e82e682a5486`.
- Layer 3 and Layer 4 receive permanent embedded workspace headers with semantic eyebrows and refresh utility actions: `7d0619d4913f8d1b49f91a2792842cff8a1f52d2`.
- shared responsive header system added in `mature.css`: `9f078cef62ff2f0a9bb85f8fa5f1f67f92b7ba39`.
- permanent A24 deployed UAT added: `841354024728b6785420f386d58e72f412b5409e`.
- targeted/integration/acceptance suite inclusion: `261b7ac50dc4e9f36bbcbf2182f5574324a9b5d9`.

A24 acceptance remains open until the settled-head frontend build and targeted deployed UAT complete. This addendum does not alter Layer authority, routing, publication or cutover governance.


### A24 targeted acceptance evidence
- Pilot settled head: `261b7ac50dc4e9f36bbcbf2182f5574324a9b5d9`.
- Deployed UAT run `33347595340`: PASS.
- Frontend build run `33347595455`: PASS.
- A24 implementation is accepted at targeted scope; integration/acceptance remain governed by the wider M2.4.4 gate.


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


### A25 targeted acceptance evidence
- Pilot settled head: `ee49740da33f09f5378395d04b9f2d807b06a9d7`.
- Deployed UAT run `33359217661`: PASS.
- Frontend build run `33359217695`: PASS.
- Direct runtime relation proof: JSON Evidence returns no related visual; exact RMIT HTML returns only screenshot `e465eb03-e983-4007-b3f5-d63d00c925fe`; selected screenshot Evidence returns no secondary related visual because it previews itself.
- A25 is accepted at targeted scope; wider M2.4.4 integration/acceptance remains separately governed.

### A23 targeted replacement PASS — 31 August 2026

- Final selector/navigation correction head: `33ff74a9ab4a465aa35edb835a6a5218b42dbdb6`.
- Deployed targeted UAT run `33362379727`: PASS.
- This replacement closes the immutable failure lineage from `33346924249`, `33362104361`, and `33362227645` without weakening product role boundaries, Firecrawl quota policy, or performance thresholds.
- A23 operator contract now proves: background-enrichment action, no manual Wave-1/route knobs, Firecrawl-first effective policy, qualification/production distinction.
- Administration contract now proves Layer 2 source/provider configuration is reached centrally under Administration with role-appropriate controls.
- Paired frontend build `33362379732` remained active at this checkpoint; do not push a new Pilot commit until terminal.

## A22 closure + A23 background continuation corrective checkpoint — 31 August 2026

### A22 responsive Provider/Course detail blades — TARGETED PASS
- Final settled A22 source: `4b48fb27332847ce9bca8843c621b27b08c99de0`.
- Deployed targeted UAT `33384244501`: PASS.
- Paired frontend build `33384244532`: PASS.
- Provider blade proved responsive width, single content scroll-owner, no contextual-card clipping and no page-level horizontal overflow.
- Course blade proved explicit scroll-capable content ownership and tablet/mobile usability; sparse records are not required to manufacture overflow.
- Immutable failed/corrective runs remain retained: `33362703943`, `33363086937`, `33363219113`, `33384098203`. These were selector/navigation/test-assumption corrections, not threshold weakening.

### A23 background qualification continuation defect and correction
- Runtime reconciliation found background qualification run `94557562-e292-4ed9-bdf3-8b2dcc370c6b` stalled after its first two Provider slices: 20 samples `layer3_required`, 480 still `qualifying`.
- Edge evidence retained: worker v3 request at 04:40 UTC returned HTTP 500 after two Providers and did not create a continuation nonce.
- First correction `389c52ccfea8f39a62d1b162fd6b8261cc2acdf2` moved continuation off the deliberately non-exposed `pipeline` PostgREST schema, deployed worker `layer2-scale-qualify-scheduled` runtime v4 / source v1.0.3, and added permanent A23 regression coverage.
- Immutable v4 failure retained: request `2387` returned HTTP 500 / PostgREST 403 because the SECURITY INVOKER bridge could execute but did not have direct SELECT privilege on protected `pipeline.layer2_scale_qualification_runs`.
- Exact error retained from `net._http_response`: `layer2_qualification_continue_service: permission denied for table layer2_scale_qualification_runs`.
- Final privilege-boundary correction is Pilot commit `c473a785fce3a31c90349044e05926f77a2fa2f7`:
  - public `layer2_qualification_continue_service(uuid)` remains SECURITY INVOKER and service-role-only;
  - protected-table access moved to non-exposed `security.layer2_qualification_continue_impl(uuid)` SECURITY DEFINER;
  - both functions revoke public/anon/authenticated execution; only service_role is granted;
  - continuation is allowed only for an already-authorised `running` wave with `background_scheduler_authorized=true` and remaining `qualifying` items;
  - no canonical, Search or Publication mutation authority is introduced.
- Corrective targeted UAT `33385645813`: PASS.
- Corrective frontend build `33385645810`: PASS.
- Security Advisor after correction: 146 INFO / 0 WARN / 0 ERROR.
- Performance Advisor after correction: 178 INFO / 0 WARN / 0 ERROR.
- Relevant Edge runtime: `layer2-scale-qualify-scheduled` v4 verify_jwt=false with one-time nonce auth; `layer3-interpret` v8 JWT=true; `layer3-contact-benchmark` v3 verify_jwt=false governed nonce.

### Live recovery proof / gate
- Governed resume request `2388` returned HTTP 200 and created successor `2389`; autonomous chain then proved `2389 → 2390 → 2391 → 2392` with HTTP 200 and further one-time nonces.
- No repeated manual continuation is being used after request `2388`.
- Latest sampled wave state at this checkpoint: 60 samples `layer3_required`, 150 `source_pattern_candidate`, 290 `qualifying` (29 Provider slices remain at 10 samples each).
- The chain is actively consuming new continuation nonces autonomously; run remains `running`.
- Current contact-disposition contract remains exactly 60 current Providers: 11 `published_contact_found`, 49 `not_found_in_qualified_evidence`, 0 current pending and no duplicate current Providers. Historical superseded pending rows remain append-only history.
- Only seven Layer 4 human-resolution refresh requests remain active/queued; no active Layer 1–3 refresh queue work was introduced by this correction.
- **Integration MUST NOT be nominated while this recovery wave is still active/unreconciled.** Do not update `.github/m2-4-integration-candidate` yet.
- Exact next action: allow the autonomous chain to continue; when run `94557562-e292-4ed9-bdf3-8b2dcc370c6b` is terminal, reconcile item outcomes, scheduler auto-progress behaviour, Firecrawl budget/telemetry, Advisors, cron latest status and repository heads. Only then consider one A17–A25-aware bounded integration candidate.

## A23 qualification recovery/finalizer closure — 1 September 2026

- `M244-FU-016` is now **COMPLETE / RECONCILED**.
- Original stalled recovery run `94557562-e292-4ed9-bdf3-8b2dcc370c6b` completed with 50/50 Firecrawl attempts succeeded, 50 vendor units, 50 distinct Evidence objects and 500 Evidence-backed identity samples.
- Final provider outcomes for that repaired wave: 36 `source_pattern_candidate`, 14 `layer3_required`, 0 source-limited/blocked.
- Autonomous continuation repair remains Pilot `c473a785fce3a31c90349044e05926f77a2fa2f7`; corrective UAT/build `33385645813` / `33385645810` PASS.
- Downstream finalization/orchestration is now implemented at Pilot `adf5ac1d85bff0291355ac44650dc149deedcb09` via `20260831115800_m2_4_4_a23_qualification_finalizer_handoff.sql`.
- The finalizer:
  - runs policy-bounded deterministic `source_pattern_candidate` dispatch/reconcile;
  - uses the benchmark-PASS `openrouter-source-pattern-v1` profile for Layer 3 queue eligibility;
  - creates governed Layer 3/Layer 4 refresh requests but does **not** autonomously invoke Layer 3 AI;
  - preserves canonical/Search/Publication mutation boundaries.
- Finalizer targeted deployed UAT `33390795147`: PASS.
- Finalizer frontend build `33390795285`: PASS.
- Cron `coursefinder-layer2-qualification-finalizer` is active at `2-59/5 * * * *` and latest-success.
- At final pre-integration reconciliation there are **no active/planned qualification runs** and no Provider overlap.
- Expected governed queues are now explicit rather than orphaned: 90 A23 Layer 3 source-pattern queued requests and 24 new A23 Layer 4 source-resolution queued requests (31 total Layer 4 queued including pre-existing human-resolution items).
- Firecrawl period budget: 1,820 used / 5,000 limit / 3,180 remaining / 250 reserve; no silent paid fallback.
- Current contact disposition contract remains 11 found + 49 not-found = 60 Providers.
- Security Advisor: 146 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 177 INFO / 0 WARN / 0 ERROR.
- Integration nomination is now permitted from Pilot source `adf5ac1d85bff0291355ac44650dc149deedcb09`.
