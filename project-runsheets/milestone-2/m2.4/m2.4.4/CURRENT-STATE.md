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
- Admin/PIM Design Decisions baseline advanced to `docs/coursefinder-admin-pim-design-decisions-v1.23.md`, Decision 33.
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
- Admin/PIM Design Decisions advanced to `docs/coursefinder-admin-pim-design-decisions-v1.23.md`, Decision 34.
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
- Admin/PIM design baseline advanced to `docs/coursefinder-admin-pim-design-decisions-v1.23.md`, Decision 35.

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
