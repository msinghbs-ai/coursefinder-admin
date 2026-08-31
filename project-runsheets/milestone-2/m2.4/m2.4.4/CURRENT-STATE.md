# M2.4.4 Current State

**Status:** ACTIVE — IMPLEMENTATION COMPLETE / BOUNDED INTEGRATION NEXT  
**Updated:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Accepted starting point

- M2.4.3 CLOSED/PASS.
- Pilot `96de9add3762a0594ebc371fba49d4d990ff4b45`.
- Final M2.4.3 acceptance `33286437795` PASS.
- Security 135 INFO / 0 WARN / 0 ERROR.
- Performance 169 INFO / 0 WARN / 0 ERROR.
- Layer 3 interpret v5, provider-control v2, source-pattern-benchmark v9.
- Layer 3 housekeeping cron active every 15 minutes.
- A15 CLOSED/PASS and frozen.

## Entry focus

Inventory cross-layer housekeeping, schedulers, replay/recovery, alerts, telemetry and documentation before making feature changes.

## Boundaries

No Production, broad Publication, Website/Zoho cutover, RMIT 212 promotion or NZ L2 first-party expansion is authorised by M2.4.4.


## Entry reconciliation finding — legacy Layer 1 stale job recovery

Runtime inventory found one genuine stale legacy `pipeline.jobs` row:
- job `da22a5cf-9bff-4597-9193-9503aaad075c`;
- domain `regulatory`;
- job type `regulatory_sync`;
- state had remained `running` since 17 August 2026;
- all active cron schedulers were otherwise reporting successful latest executions.

Root cause:
- accepted Layer 1 housekeeping cleaned expired terminal `layer1_run_queue` rows only;
- Layer 2 already recovered stale `pipeline.jobs` rows for `layer2%`;
- Layer 3 already recovered stale reserved/calling interpretations;
- no equivalent bounded recovery existed for legacy Layer 1 `regulatory_sync` jobs.

Corrective Pilot source:
`29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.

Migration reconciliation:
- deployed Supabase history: `20260830021159_m2_4_4_layer1_legacy_stale_job_recovery`;
- repository mirror: `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery.sql`;
- function body reconciled; do not redeploy only to force timestamp equality.

Deployed validation:
- candidate query matched exactly 1 stale legacy regulatory job;
- housekeeping execution recovered exactly 1;
- remaining stale legacy regulatory running jobs: 0;
- governed Evidence deleted: 0;
- source versions deleted: 0;
- canonical history deleted: 0;
- Security Advisor remains 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor remains 169 INFO / 0 WARN / 0 ERROR.

The recovery excludes any job still owned by a live `layer1_run_queue` heartbeat.


## Cross-layer reconciliation result

M244-FU-001 through M244-FU-005 material work is complete.

- L1/L2/L3 stale recovery ownership/windows are non-overlapping and preserve governed history.
- general/L1/L2 scheduling is idempotent/target-bounded; no active L1–L3 duplicate refresh work exists.
- L3 alert gap corrected by deployed migrations `20260830071523` and `20260830072215`.
- `layer3_ops_alerts` is available through the governed `admin_read` boundary and retains the rank-4+ internal guard.
- current L3 alert conditions: 0.
- A14 active paths remain telemetry-bearing; unavailable historical/vendor usage is not inferred.
- private Evidence footprint observed at 6,248 objects / 3,781,700,044 bytes; no authorised storage threshold is configured.
- all seven operational cron jobs latest-success.
- Security Advisor 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor 169 INFO / 0 WARN / 0 ERROR.
- Guides reconciled: Operations Runbook v1.8, Data Operations Admin Guide v1.6, PIM Admin Guide v1.22.
- permanent M2.4.4 UAT source contract added to targeted/integration/acceptance tiers.

M244-FU-006 remains visible non-blocking timing-sensitive UAT hygiene evidence. A15/Apollo/RMIT/NZ boundaries remain unchanged.

## Next decision

Nominate one bounded integration desktop/mobile candidate from the latest Pilot head. Do not create another candidate while that run is active. Final acceptance may be nominated only after both integration platforms PASS.


## Bounded integration candidate nominated — 30 August 2026

- candidate SHA: `55f867bc371fb961f38631129e746fad9d9ec00b`;
- implementation source before marker: `7ef74a0b787e50e46d4cf11300a0e27391f13e54`;
- stage: bounded integration desktop/mobile;
- decision rule: both commit-status contexts must be success before one final acceptance marker is created;
- duplicate candidate rule: do not create another integration marker while this candidate is active;
- workflow run ID: pending GitHub Actions publication at this checkpoint.


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


## Replacement bounded integration candidate — 30 August 2026

- corrective source: `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- targeted deployed UAT: `33300234103` PASS;
- replacement integration candidate: `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- decision rule: desktop and mobile must both PASS under unchanged budgets;
- first candidate/run `55f867bc... / 33299250997` remains immutable FAIL evidence;
- do not create another integration candidate while `a256283b...` is active.


## Active long-running gate handoff

Replacement bounded integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf` is the **only active candidate**.

At handoff:
- GitHub has not yet published terminal integration desktop/mobile commit-status contexts;
- workflow run ID is therefore not yet trustworthy/available through the connected status surface;
- do not create another integration candidate;
- first inspect this exact SHA;
- if desktop+mobile both PASS, record its run ID/results then nominate one final acceptance candidate;
- if either fails, retain the run as immutable evidence and correct only the exact defect/contract.


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


## Final acceptance candidate — nominated

- marker: `6c480ed3b248f3b118f21dea80bb4d742ab8c282`;
- source lineage: replacement integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- integration run `33300281890`: desktop PASS / mobile PASS;
- decision rule: final acceptance requires desktop PASS + mobile PASS plus clean closing reconciliation;
- do not create another acceptance candidate while this marker is active.


## Final acceptance active run

- candidate `6c480ed3b248f3b118f21dea80bb4d742ab8c282`;
- GitHub Actions run `33303037986`;
- current stage at checkpoint: desktop acceptance in progress, mobile pending;
- no second acceptance candidate is permitted while this run is active.

## A16 scope change — 30 August 2026

User-authorised M2.4.4 scope now includes Addendum A16:
- close the A15 coverage distinction by retaining an explicit international-student/admissions contact-channel disposition for every governed AU/NZ Provider;
- perform contact-channel classification/extraction in Layer 3 from governed Layer 2 first-party Evidence;
- define Layer 4 as a cross-platform governed human intervention layer using append-only field overrides and effective-value resolution.

Layer 4 must not destructively rewrite source/Evidence/history. Each overridden field is visibly L4-edited and retains authenticated actor, timestamp, before/after, reason, optional comment/Evidence and supersede/revert history. Publication is a separate role-gated consequential decision.

Working design:
`docs/coursefinder-layer4-governed-intervention-design-v0.1.md`.

Gate impact:
the already-nominated final acceptance marker `6c480ed3b248f3b118f21dea80bb4d742ab8c282` / run `33303037986` predates A16. It remains immutable evidence but is no longer sufficient by itself to close the expanded M2.4.4 scope.

Next implementation sequence is M244-FU-011 through M244-FU-015, followed by targeted validation, bounded integration and one later final acceptance candidate.


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


### A21 validation correction — 31 August 2026

- Frontend build on `0daa88bdc71afdc27256288e7bbf42b5f50efa55`: run `33335240424` PASS.
- Targeted UAT run `33335240463` FAIL is immutable test-contract evidence: inherited `tests/uat/support/navigation.mjs` still expected Layer 1 as a dialog and old primary label `Layer 1 — Regulatory`; product intentionally changed to embedded canonical route under A21.
- Shared navigation helper corrected at Pilot commit `0a35e722ceb04f5515110a71a6cb50e11044ec36` to use canonical embedded Layer 1/2 and separate Layer 3/4 routes without weakening functional assertions.
- Replacement frontend build run `33335368000` and deployed targeted UAT run `33335367950` active at checkpoint. Do not duplicate while active.


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

### A21 v2.15.13 targeted UAT selector correction — 31 August 2026

- Frontend build `33343098440` on `afc0a58ee7646eb21a6484aeee560386a4889ad2`: PASS.
- Targeted deployed UAT `33343098402`: FAIL retained as immutable test-contract evidence.
- Product filter-restoration test itself PASSed; failure was limited to:
  1. negative `.m-alert` assertion waiting for a non-existent element instead of asserting zero matching error alerts;
  2. Layer 2 heading selector matching both canonical page heading and embedded workspace heading.
- No product threshold, filter behaviour or navigation contract was weakened.
- UAT selectors corrected at Pilot commit `74a2c67d613d64f9ab3f83bc613b6109fc947ffe`.
- Replacement build `33344238253` and targeted deployed UAT `33344238236` queued at checkpoint. Do not duplicate while active.


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

### A23 navigation/UAT correction and live background proof — 31 August 2026

- Immutable A23 deployed UAT failure `33346924249` was reviewed in full.
- Failure 1 was selector-only: the test expected a standalone exact text node `Firecrawl direct`; the canonical route renders it inside the numbered effective acquisition-policy chain.
- Failure 2 was role-boundary mismatch: the test assumed the browser UAT account could see the rank-5 Layer 2 policy editor. The product correctly hides that editor below rank 5.
- No server-side role threshold or Firecrawl quota/production limit was weakened.
- Canonical Administration product gap was also corrected: mature Layer 2 source-profile and acquisition-provider consoles are now embedded under the central Administration workspace rather than being unreachable legacy modules:
  - source console embed `bcb8a5140703e89b24cb65a662cba1b754c7870b`;
  - provider console embed `61b5242d31dfe945847a5c9ddb432cf3d4e94461`;
  - embedded layout CSS `48e55fe546e72d9656eb6c040711215d4dddc192` / `20b38e916d4f0b0b1906eb6c04fbc1b4298e574a`;
  - central Administration placement `23cf4d63437a900a43f407984d88b77f13f76dc1`;
  - shared UAT navigation corrected to Administration `29ae2b9a95f043863a1f5448129e50deac00bead`;
  - A23 UAT made route-aware and rank-aware `b86c88a0d1ce6819fd6741cd37dadd7cb7bacea0`.
- Replacement A23 build/UAT pair: build `33362104409`, targeted deployed UAT `33362104361`; active at this checkpoint and must not be duplicated/cancelled.
- Runtime proof remains live: qualification run `94557562-e292-4ed9-bdf3-8b2dcc370c6b` is processing a governed 50-Provider / 500 identity-sample background wave with `route_mode=scraper_first`, `background_scheduler_authorized=true`, and no canonical/Search/Publication mutation authority.
- Security Advisor: 0 WARN / 0 ERROR (146 INFO).
- Performance Advisor: 0 WARN / 0 ERROR (178 INFO).

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

## A17–A25 bounded integration active gate — 1 September 2026

- FU-016 is CLOSED / RECONCILED.
- Final pre-candidate Pilot implementation source: `adf5ac1d85bff0291355ac44650dc149deedcb09`.
- Exactly one new bounded integration marker was nominated:
  - candidate commit `aa824aa6abe943e6beebf4aaab361f29d54678ef`;
  - marker `.github/m2-4-integration-candidate` updated once.
- Active CI on that exact candidate:
  - deployed UAT run `33416346862` — **ACTIVE / integration desktop running; mobile pending**;
  - frontend build run `33416346835` — **PASS**.
- Do not create another integration candidate while `33416346862` is active.
- Integration decision rule remains unchanged:
  - desktop PASS;
  - mobile PASS;
  - unchanged 3,000 ms Course performance budget;
  - no threshold weakening.
- If `33416346862` fails: retain immutable evidence, inspect exact failure, correct only demonstrated defect/contract, rerun targeted if needed, and nominate a replacement candidate only after this run is terminal.
- If `33416346862` passes desktop + mobile: record the result, run one closing runtime/Advisor reconciliation, then nominate exactly one new A17–A25-aware final acceptance candidate.
- Production, broad Publication, Website and Zoho cutover remain unauthorised.

## A26 captured — Layer 2 production run/progress lineage — 1 September 2026

Addendum `EXECUTION-ADDENDUM-A26-L2-PRODUCTION-RUN-PROGRESS-LINEAGE.md` is ACTIVE.

Required correction:
- one production-oriented Layer 2 background action;
- stable parent-run identity across qualification/production/scheduler continuations;
- Jobs & Runs and Evidence aligned to that run;
- Dashboard uses the same reconciled run for measurable runtime progress and scheduled remainder;
- cross-surface status/count lineage must agree.

Implementation is intentionally not pushed yet because A17–A25 bounded integration run `33416346862` on Pilot `aa824aa6abe943e6beebf4aaab361f29d54678ef` is still active. Next technical action is to check that run first; after terminal result, implement A26 from the settled head without weakening A14/A23/A25.

## A17–A25 integration failure after A26 capture — 1 September 2026

Deployed bounded integration run `33416346862` for Pilot candidate `aa824aa6abe943e6beebf4aaab361f29d54678ef` is terminal FAIL.

- desktop: FAIL;
- mobile: skipped because desktop failed;
- immutable evidence retained;
- no threshold was weakened.

Observed failure classes include:
- stale UI/UAT assertions after accepted navigation/Layer 2 wording/release-note changes;
- duplicate-heading/strict-locator assumptions;
- inherited Course/Layer 2 management-view latency breaches against the unchanged 3,000 ms budget.

A26 remains ACTIVE. Implementation may now proceed from the settled head, but the next integration nomination must reconcile both the demonstrated inherited failures and A26 targeted acceptance.

## A27 captured — Administration workspace blank/sub-navigation defect — 1 September 2026

User-observed defect recorded under `EXECUTION-ADDENDUM-A27-ADMINISTRATION-WORKSPACE-NAVIGATION-RELIABILITY.md`.

Current required correction:
- Administration parent click must render real content;
- visible sub-context items must respond and switch active content;
- empty/loading/error/insufficient-rank states must be explicit;
- canonical route/deep-link/back-forward behaviour must remain functional;
- no legacy launcher/post-render menu mutation may be used as the fix.

This defect is now a closure blocker for M2.4.4 and must be included in the next corrective Pilot head alongside A26.

## A28 captured — Layer 2/3 summary and experimental UI hardening — 1 September 2026

User direction recorded under `EXECUTION-ADDENDUM-A28-L2-L3-OPERATOR-SUMMARY-EXPERIMENTAL-UI-HARDENING.md`.

Required correction:
- reassess Layer 2 end-page blocker/info messages and retain only actionable exceptions as blockers;
- make Layer 2/3 Jobs/Runs and Evidence summaries concise, current and useful;
- reconcile those summaries with A26 parent-run/job/Evidence lineage;
- remove or relocate experimental/debug/demo-only information from normal Layer 2/3 operator routes;
- include demonstrated Layer 2/3 UI bugs in the same corrective sweep.

A28 is now part of the M2.4.4 closure gate.

## Handover checkpoint — A26/A27/A28 corrective cycle — 1 September 2026

Authoritative Pilot head at handover: `aa824aa6abe943e6beebf4aaab361f29d54678ef`.

Latest bounded integration evidence:
- deployed UAT `33416346862`: terminal FAIL;
- desktop: FAIL;
- mobile: skipped because desktop failed;
- do not rerun unchanged;
- preserve immutable failure evidence and unchanged performance budgets.

New active closure blockers/addenda:
- A26 — Layer 2 production run/job/Evidence/Dashboard lineage;
- A27 — Administration blank workspace/sub-context click reliability;
- A28 — Layer 2/3 blocker/info rationalisation, Jobs/Runs + Evidence summaries, experimental UI cleanup and bounded UI bug sweep.

No corrective Pilot implementation commit has been made after `aa824aa6...` at this handover checkpoint.

Next chat must:
1. read PROJECT_INSTRUCTIONS, Standing Instructions and A26–A28;
2. inspect current Pilot/runtime truth before editing;
3. correct demonstrated stale acceptance selectors/contracts without weakening thresholds;
4. implement A26/A27/A28 in one coherent corrective cycle;
5. run targeted validation first;
6. if targeted passes, nominate exactly one bounded integration candidate;
7. when CI/UAT runs longer than about five minutes, record exact run IDs/status in CURRENT-STATE/NEXT-CHAT and hand over rather than waiting;
8. the subsequent chat must check those exact run IDs before creating any rerun/candidate.

Production, broad Publication and Website/Zoho cutover remain unauthorised.

## A26-A28 corrective implementation active — 1 September 2026

Corrective Pilot implementation has now advanced beyond the prior failed integration head.

Current Pilot head:
- `f32eb94063f0ff6190a63db8905b3a6e73805bee`

Implemented corrections:
- `62572ea2270f104cd1ee28bbb8d092f2251f103e` — Layer 2 production wording, canonical Jobs/Evidence links, healthy qualification removed from blockers, post-action run/scheduler message improved, demo proof moved under progressive disclosure.
- `54194db239af0051f8facc85e30e2e338497a41b` — Administration now has a meaningful default overview and explicit rank-aware sub-context navigation instead of a card-only/blank shell.
- `1e6e1a39d47180d4cf0fff2c8331c9eb2fb006dc` — responsive Administration sub-navigation styling.
- `6863904e97aff8c196311b1f913ba7e706e3882c` — Layer 3 current operations/Evidence summary and removal of normal-route profile mutation control.
- `38a62c1835305ed68f293ece796cbeccf13217bb` — UAT navigation helper aligned to Administration sub-context tabs.
- `668a5c05a2c01db2ee913a5eecab6d6f4a3922af` — dedicated A26-A28 deployed operator UX suite.
- `956c829320f1372d25a800314ad888ef29cf7b74` — A26-A28 suite wired into targeted/integration/acceptance selection.
- `246e0e914dbe1615e9eafd47ee6544ec73b07f2c` — canonical Administration navigation UAT aligned to new structure.
- `f32eb94063f0ff6190a63db8905b3a6e73805bee` — A23 UAT aligned to production-action wording.

Known exact UI defects corrected:
- Layer 2 dead links referencing removed labels `Jobs & Runs` / `Evidence & Provenance` now use canonical `Jobs` / `Evidence`.
- routine background qualification no longer appears as an operator blocker.
- `Meeting-ready` demo wording no longer dominates the normal Layer 2 route.
- Administration has an explicit non-empty default landing state and sub-context tabs.
- Layer 3 profile mutation button has been removed from the routine operational route; profile state is described as centrally managed.

Active automation on exact head `f32eb940...`:
- frontend build `33419567099` — IN PROGRESS at handover; current step: Install dependencies.
- targeted deployed UAT `33419567115` — IN PROGRESS at handover; current step: Restore npm and Playwright cache.
- do not push another Pilot commit or create an integration candidate while these are active.

Decision rule:
1. next chat checks `33419567099` and `33419567115` first;
2. if build or targeted UAT FAIL, preserve evidence and correct only demonstrated defect/contract;
3. if both PASS, reconcile current deployed UI/runtime once;
4. only then nominate exactly one replacement bounded integration candidate;
5. unchanged 3,000 ms performance budget and security/role boundaries remain mandatory.

## A26-A28 corrective retry active — 6390374 — 1 September 2026

Prior head `f32eb94063f0ff6190a63db8905b3a6e73805bee` produced immutable FAIL evidence:
- frontend workflow `33419567099`: production bundle build job PASS, browser-smoke FAIL during UAT suite discovery because two test files had syntax defects;
- targeted deployed UAT `33419567115`: FAIL because A23 still expected the obsolete Administration cards.

Exact demonstrated defects corrected:
- `f2c2b4b5ed20e43853c7125abac15f434f5ed224` — repaired malformed Administration UAT source and canonical assertions;
- `ffd3cd20731e6cc41865a3cc62c534bd7623421d` — repaired missing parenthesis in A26-A28 deployed operator UX spec;
- `6390374049cbd8a82a9084c418641d7599b8290f` — aligned A23 Administration acceptance to the new sub-context tab contract.

Current authoritative Pilot head:
- `6390374049cbd8a82a9084c418641d7599b8290f`

Active latest-head automation:
- frontend build `33419997121` — QUEUED at handover;
- targeted deployed UAT `33419997114` — PENDING at handover.

Intermediate earlier-head runs may still be cancelling/finishing due push concurrency and are not candidate evidence for the settled head.

Decision rule:
1. next chat checks `33419997121` and `33419997114` first;
2. if either FAILS, inspect exact latest-head evidence and correct only demonstrated defects;
3. if both PASS, reconcile deployed runtime/UI once and nominate exactly one replacement bounded integration candidate;
4. do not rerun older superseded heads;
5. preserve unchanged performance/security thresholds.

## A17-A28 reconciliation checkpoint — 8309d600 — 1 September 2026

Latest Pilot head:
- `8309d6003c51767785f7c84ced0f6dfba61812cb`

Latest-head automation:
- frontend build `33420469497` — IN PROGRESS at checkpoint;
- targeted deployed UAT `33420469521` — PENDING at checkpoint.

A17-A25 have been explicitly reconciled against failed integration `33416346862`; they are not being treated as implicitly fixed.

### Earlier-addenda acceptance reconciliation
- A17/A18/A19/A20 navigation/governance surfaces: canonical sidebar/Administration tests remain in integration; Administration blank-shell and routing issues additionally covered by A27.
- A21 permanent Layer navigation: stale Layer 2 action wording corrected to `Start production enrichment`; canonical four-Layer route assertions remain.
- A22 responsive Provider/Course blades: Course drawer acceptance updated to the already-implemented wider `min(1100px,66vw)` desktop contract; tablet/mobile scroll/containment remains a hard gate.
- A23 quota/background execution: production-action wording, Administration configuration tabs, worker v1.0.3 continuation contract and background policy assertions reconciled; no manual Wave-1 controls restored.
- A24 unified Layer headers: existing integration suite remains unchanged and must pass.
- A25 Evidence type-aware integrity: **not relaxed**. JSON must not inherit screenshots; HTML may use only exact same-attempt screenshot; screenshot Evidence must preview its own image.
- A13 accepted acquisition Evidence demonstration was updated from experimental/meeting wording to the production Firecrawl/scheduler/budget/Evidence route and progressive-disclosure acquisition example.
- Layer 3 operations acceptance now matches the canonical `Qualified model routes` heading while preserving benchmark, Evidence, credentials and human-review provenance checks.
- release-note acceptance now targets v2.15.14 and retains prior release history checks.

### Hard gates deliberately not weakened
The following failures from `33416346862` must prove PASS in the replacement integration rather than being edited away:
- Data Quality → private Regulatory Snapshot Evidence opening;
- A25 JSON/screenshot Evidence lineage;
- bounded direct Course acquisition creating governed versioned Evidence;
- Layer 2 management-view and Course interaction latency <= 3,000 ms;
- security/role/Evidence boundaries.

### Replacement integration rule
Do not nominate integration until latest-head build `33420469497` and targeted UAT `33420469521` are both PASS.
After PASS/PASS, nominate exactly one bounded integration candidate that includes the permanent A17-A28-relevant suites plus hard Evidence/performance gates.

## Replacement A17-A28 integration candidate active — 4c47ea72 — 1 September 2026

Pre-candidate proof on implementation head `8309d6003c51767785f7c84ced0f6dfba61812cb`:
- frontend build `33420469497`: PASS;
- targeted deployed UAT `33420469521`: PASS.

Exactly one replacement bounded integration candidate has now been nominated:
- candidate commit `4c47ea72a8c5acce70cd3402c0dd512c5ed94537`;
- frontend build `33421322395` — QUEUED at handover;
- deployed integration UAT `33421322389` — QUEUED at handover.

Candidate scope explicitly revalidates A17-A28 and retains unchanged hard gates:
- A25 Evidence type/screenshot lineage;
- private Regulatory Snapshot Evidence opening;
- direct acquisition creating governed versioned Evidence;
- Layer 2/Course <= 3,000 ms performance budgets;
- role/security boundaries.

Do not nominate another integration candidate while `33421322389` is active.
Next chat must check `33421322395` and `33421322389` first. If integration FAILS, preserve exact evidence and correct only demonstrated defects. If desktop+mobile integration PASS, reconcile runtime once and nominate exactly one final acceptance candidate.

## Post-integration corrective cycle — cfad41b4 — 1 September 2026

Replacement bounded integration candidate `4c47ea72a8c5acce70cd3402c0dd512c5ed94537` is immutable FAIL evidence:
- build `33421322395`: PASS;
- deployed integration UAT `33421322389`: FAIL on desktop; mobile not accepted.

Failure reconciliation:
- A13 expected a screenshot on JSON Evidence; corrected to enforce A25 semantics instead (JSON preview + no inherited visual).
- Data Quality Regulatory Snapshot assertion hit duplicate visible headings; scoped to the first heading without weakening private Evidence checks.
- Onboarding create controls are rank-gated; test now proves the create surface only when available and otherwise proves no Create Draft action is exposed.
- Layer 3 Evidence guidance and A28 Jobs/Evidence links had duplicate valid renderings; assertions scoped without changing content requirements.
- A21 Firecrawl route assertion now validates the complete governed route chain rather than exact duplicate leaf text.
- A25 Evidence integrity semantics remain unchanged; only detail-settle timeout was raised from the 6-second deterministic UI helper to 20 seconds.
- bounded direct Course acquisition creating versioned Evidence remains a genuine unresolved integration gate.
- Layer 2 performance remained a genuine defect: `layer2_ops_overview` measured 4,929 ms and 743,462 bytes against unchanged <=3,000 ms / <=250,000-byte budgets.

Performance correction:
- live Supabase `security.admin_layer2_ops_read('layer2_ops_overview')` no longer returns the unused 939-profile source registry;
- source registry remains available through dedicated Administration projections;
- committed migration: `20260901064000_m2_4_4_a26_layer2_ops_overview_compact.sql`;
- Pilot corrective head: `cfad41b46d2300519c49b094e9f1bd00fe6840f8`;
- live function definition verified with `'sources','[]'::jsonb`.

Advisor truth after the DDL:
- Security Advisor: 146 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 175 INFO / 0 WARN / 0 ERROR.

Security follow-up:
- Supabase table introspection separately reported 15 RLS-disabled tables (including operational `pipeline.*` tables) while the Security Advisor still reports 0 WARN / 0 ERROR.
- do not blanket-enable RLS without policy reconciliation; record as a security architecture investigation before Production cutover.

Active latest-head validation:
- build `33437964516` — IN PROGRESS at handover;
- deployed targeted UAT `33437964520` — IN PROGRESS at handover.

Decision:
1. next chat checks these two exact runs first;
2. if PASS/PASS, run focused hard-gate validation for A25 Evidence, direct acquisition Evidence creation and performance;
3. only after those pass may another bounded integration candidate be nominated;
4. do not rerun `33421322389` unchanged.

## Focused hard-gate validation active — cdc4fbf4 — 1 September 2026

Latest corrective proof:
- `cfad41b46d2300519c49b094e9f1bd00fe6840f8`
- frontend build `33437964516`: PASS
- targeted deployed UAT `33437964520`: PASS

A dedicated focused hard-gate selector has been added so the remaining genuine gates can be tested without prematurely nominating integration:
- selector commit `ebe90bb1792359ea07f602d41144d584bfc475d0`;
- marker commit `cdc4fbf4345ee1794557150148fcd5f769bf424a`.

Focused suite scope:
1. `m2-4-4-a25-evidence-type-aware-preview-deployed.spec.mjs`
2. `layer2-provider-deployed.spec.mjs`
3. `performance-deployed.spec.mjs`

Active exact-head runs:
- frontend build `33438250059` — QUEUED at handover;
- focused deployed UAT `33438250056` — QUEUED at handover.

These gates remain unchanged:
- JSON Evidence cannot inherit screenshots;
- HTML may use only exact same-attempt screenshots;
- screenshot Evidence must display its own image;
- bounded direct Course acquisition must create governed versioned Evidence;
- Layer 2 operations <= 3,000 ms and <=250,000 bytes;
- all existing role/security/private Evidence boundaries.

Do not nominate a new integration candidate until `33438250059` and `33438250056` are terminal and the focused UAT is PASS.

## Focused hard-gate corrective retry — bf412b7d — 1 September 2026

Focused hard-gate run `33438250056` is immutable FAIL evidence. Its build `33438250059` passed.

Failure breakdown from the focused suite:
- bounded acquisition itself PASSed twice and created governed Evidence; the stale assertion incorrectly required `direct_http` while the accepted A23 production route is Firecrawl-first.
- A25 JSON integrity semantics PASSed up to the final label check; the failure was a strict-mode duplicate `Layer2 Raw Json` text locator.
- A25 HTML exact-attempt screenshot PASS.
- A25 screenshot-own-image PASS.
- core workspace performance PASS.
- remaining real performance defect: Administration `layer2_profiles` payload 1,226,444 bytes against unchanged <=250,000-byte budget.

Corrections:
- `3bc19b4577b5a34e5656ae0754bc7e5aaea91c62` — added rank-gated bounded `security.admin_layer2_profiles_page(jsonb)` and conditional `admin_read('layer2_profiles', args)` dispatch while preserving the legacy unpaged contract for other consumers.
- `32bfda07a3760e19e109385889c0fcf2a4cc7691` — Administration source registry now requests 50-row server pages with server-side query/country/method/health filters and true total/summary metadata.
- `0ac72fd55539a3c5d6556e5029f3d65164b9a358` — acquisition Evidence gate aligned to accepted Firecrawl-first route; Evidence ID and HTTP 200 requirements remain.
- `bf412b7dc5f6156b28b646857a9c6a50e13690a1` — A25 duplicate JSON label assertion scoped; no Evidence semantic requirement changed.

Live Supabase truth:
- `security.admin_layer2_profiles_page(jsonb)` exists;
- `public.admin_read(text,jsonb)` dispatches to it when paging/filter args are supplied;
- legacy unpaged `layer2_profiles` path remains for existing trial/provider consumers.

Current Pilot head:
- `bf412b7dc5f6156b28b646857a9c6a50e13690a1`

Active latest-head validation:
- frontend build `33439561990` — IN PROGRESS at handover;
- deployed targeted UAT `33439561973` — IN PROGRESS at handover.

Do not act on cancelled intermediate runs.
Next chat must check `33439561990` and `33439561973` first. If PASS/PASS, rerun the focused hard-gate marker/suite only; do not nominate integration until the focused suite passes.

