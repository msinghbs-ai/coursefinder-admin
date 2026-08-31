# Next Chat — M2.4.4 Cross-layer Checkpoint

## Status

M2.4.4 is ACTIVE under `CF-CHG-20260830-048`.

Material implementation and targeted runtime reconciliation are complete. Bounded integration is the next gate.

## Accepted/reconciled state

- M2.4.3 accepted source: `96de9add3762a0594ebc371fba49d4d990ff4b45`.
- M2.4.4 initial corrective source: `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.
- L1 recovery deployed ledger version: `20260830021159`; repository mirror filename: `20260830021400...`; same accepted function body.
- L3 alert migration: `20260830071523_m2_4_4_layer3_operational_alerts`.
- L3 Admin-read bridge: `20260830072215_m2_4_4_layer3_alert_admin_read_bridge`.
- all seven active operational cron jobs latest-success.
- Security 135 INFO / 0 WARN / 0 ERROR.
- Performance 169 INFO / 0 WARN / 0 ERROR.
- current L3 alert-condition count: 0.
- no queued/running L1–L3 refresh duplication.
- A14 telemetry continuity reconciled; unavailable usage not invented.
- Guides: Operations Runbook v1.8; Data Operations Admin Guide v1.6; PIM Admin Guide v1.22.
- permanent M2.4.4 UAT added to targeted/integration/acceptance tiers.

## Follow-up disposition

M244-FU-001–005 COMPLETE.
M244-FU-006 remains OPEN / NON-BLOCKING UAT hygiene.
Apollo credential, A15 frozen baseline, RMIT 212 promotion block and NZ L2 defer remain unchanged.

## Exact next action

1. Reconcile latest Admin/Pilot heads.
2. If no parallel work superseded the lineage, nominate exactly one M2.4.4 bounded integration candidate using the latest Pilot head.
3. Record candidate SHA/run ID and both desktop/mobile outcomes here and in CURRENT-STATE.
4. If both PASS, nominate exactly one final M2.4.4 pre-blackout acceptance candidate.
5. If either fails, retain immutable evidence and correct only the exact defect/contract.
6. On final desktop+mobile PASS, close CF-CHG-20260830-048 and M2.4.4, reconcile REGISTER/Master Plan/Running Build and assess the next authorised milestone without starting it automatically.

## Boundaries

Production, broad Publication, Website/Zoho cutover, RMIT 212 promotion and deferred NZ L2 first-party enrichment remain outside this gate.


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

## A16 continuation requirement

Before attempting M2.4.4 closure, read:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A16-L3-CONTACT-COVERAGE-L4-GOVERNED-INTERVENTION.md`;
- `docs/coursefinder-layer4-governed-intervention-design-v0.1.md`.

Then continue:
1. inspect current A15/L2 Evidence and define the 60-Provider Layer 3 contact-disposition/extraction implementation;
2. inspect existing Layer 4 scalar-resolution structures before introducing any new persistence;
3. implement the smallest compatible override-ledger/effective-value architecture, preserving existing accepted Layer 4 behaviour;
4. classify fields as editable / elevated approval / immutable;
5. implement field-level L4 marker, audit drawer, reason/comment and revert/supersede behaviour;
6. keep publication decision separate and role-gated;
7. add targeted security/RBAC/audit/replay UAT;
8. run bounded integration then one final desktop/mobile acceptance.

The earlier final candidate `6c480ed3b248f3b118f21dea80bb4d742ab8c282` / run `33303037986` predates A16 and must not be treated as the M2.4.4 closing gate.


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
