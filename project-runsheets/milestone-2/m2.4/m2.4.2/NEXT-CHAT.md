# M2.4.2 — Next Chat / Continuation Contract

**Status:** ACTIVE — continue current repository/runtime truth; do not restart from chat assumptions.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read M2 Standing Instructions and execution addenda A1–A7.
3. Read `change-control/README.md`, `change-control/REGISTER.md` and CF-CHG-20260827-044.
4. Read current Running Build, Master Project Plan, accepted database architecture and Admin/PIM decisions.
5. Read:
   - `project-runsheets/milestone-2/m2.4/CURRENT-STATE.md`
   - `project-runsheets/milestone-2/m2.4/FOLLOW-UPS.md`
   - this M2.4.2 `RUNSHEET.md`, `CURRENT-STATE.md` and `FOLLOW-UPS.md`.
6. Reconcile current Pilot main, deployed Edge versions, Supabase migrations/functions/jobs and Actions before changing anything.

## Accepted M2.4.2 evidence already established

### UQ

- Current-profile discovery: 382/382 evaluated.
- Governed selected URLs: 156.
- Managed post-fix batch `eb52b6e2-c33b-4dfc-9e87-c107834218e0`: 156 processed / 153 resolved_l2 / 3 Layer 3 required / 0 blocked / USD 0 vendor request cost.
- Deterministic Course extractor: `layer2-course-fact-extract-v2.5`.
- Canonical dry-run and apply: 153/153 exact provider/Course CRICOS resolution.
- Applied: 153 official links, 153 guarded fees, 488 intakes, 453 English upserts, 153 descriptions.
- TOEFL apply mapping corrected to accepted `TOEFL_IBT`.
- Search/Publication mutation remain false.
- Explicit UQ Layer 3 exceptions: CRICOS `027288A`, `082599G`, `094716G`.

### Federation

- 10 identity-verified governed first-party URLs are current-version selected.
- Managed batch `fef3ab42-de28-469d-84a2-22c908f0fad1` processed the 10 governed URLs.
- Canonical dry-run and apply passed 10/10 exact identity.
- Applied: 10 links, 5 safe fees, 17 intakes, 9 English rows.
- Five fee-only Layer 3 cases remain guarded as `domestic_csp_fee_candidate`.
- Remaining 180 Courses are source-limited unless a separately qualified current first-party mapping source is accepted.

### RMIT identity safety

Broad RMIT search-result discovery exposed legacy/current CRICOS collisions where the same title resolved to the same current Course page. Title-only selection is therefore superseded and cannot be used as acceptance evidence.

Current discovery worker: `layer2-scope-discover-scheduled-v1.3.0`.

Selection contract:
- candidate must satisfy accepted RMIT detail-path/title guards;
- current first-party Course detail page must contain the expected CRICOS before `selected=true`;
- detail verification retains separate native Evidence and provider-attempt telemetry;
- no canonical mutation is authorised during discovery.

Control request `2164` PASS:
- current CRICOS `110997A` → BH079 selected with `detail_cricos_verified=true`;
- legacy CRICOS `079626B` → same BH079 URL rejected as identity mismatch;
- 2 processed / 1 selected / 0 failed.

High-risk duplicate-title cohort PASS:
- 20 Courses from duplicate-title/multi-CRICOS groups;
- 20/20 terminal;
- 6 selected;
- 6/6 selected are detail-CRICOS verified;
- 0 unverified selections;
- 0 duplicate selected URL groups;
- 4 ambiguous;
- 10 identity mismatch;
- 0 runtime failures;
- bounded continuation requests `2165` → `2166` → `2167` → `2168` completed without outer timeout.

Full RMIT university rerun then started through the normal operator scope service:
- request `2169`;
- 500 total Courses;
- 493 required discovery at launch;
- 7 already governed/selected were preserved;
- reconcile current runtime before assuming request `2169` remains active.

## Current runtime hardening

- terminal discovery outcomes are idempotent for an immutable profile version;
- provider/acquisition failures remain retryable;
- continuation uses set subtraction rather than ordering assumptions;
- per-Course and per-invocation budgets keep workers inside pg_net outer timeout;
- paused profiles are enforced through `layer2_runtime_context`, without exposing private `security.*` helpers;
- RMIT pre-v1.3.0 terminal decisions were retained historically but invalidated to non-selected `candidate` state with prior status preserved in `match_basis`.

## Operations maturity deployed

### Refresh / recheck

- `coursefinder-layer2-refresh-dispatcher`: cron at minutes 03/18/33/48 hourly.
- Profile-scoped weekly UQ/RMIT/Federation Course refresh policies exist but remain deliberately disabled pending full-run acceptance.
- Dispatcher reuses governed managed-batch services and reconciles `refresh_requests` to terminal batch state.

### Housekeeping

- `coursefinder-layer2-housekeeping`: daily 03:27.
- Recovery only: stale provider attempts/jobs/batches.
- Verification run deleted zero governed Evidence, profile versions, provider-attempt history, run history or canonical history.

### Alerts

`admin_read('layer2_ops_alerts')` now surfaces:
- stale managed run;
- paused Course profile;
- blocked items;
- provider failure streak;
- quota reserve.

Rank-4 authenticated access is explicitly granted to the private alert read helper, which still enforces authentication + role rank internally. Primary sync controls load independently of the alert feed so an alert read failure cannot blank Country/Scope.

Targeted UI/runtime gate after this correction:
- Pilot `a6e09ccd84a1d39e1911f37fbd793d48cf52cdb8`;
- deployed targeted UAT `33027788662` — PASS;
- frontend build `33027788651` — PASS.

## Remaining M2.4.2 gates

1. Complete the full RMIT v1.3.0 rerun and audit:
   - all selected URLs detail-CRICOS verified;
   - no duplicate selected URL groups;
   - provider latency/fallback/quota/economics;
   - Evidence growth and failure classes.
2. Managed enrich only governed RMIT selections; dry-run and canonical apply through `layer2_apply_course_candidate`.
3. Reconcile final Federation source-limited disposition without weakening identity rules.
4. Decide refresh-policy enablement from measured full-run behaviour.
5. Complete permanent cancellation/recovery/replay/idempotency UAT.
6. Run anon/lower-rank/private-table/secret security negatives.
7. Run Layer 1 identity regression plus Jobs/Evidence/Data Quality navigation regression.
8. Update guides, runbook and release notes.
9. Final Security Advisor and Performance Advisor.
10. Stage B desktop/mobile only after the runtime slice is stable.
11. Exactly one final Stage C candidate only after freeze.
12. Advance Running Build/Master Project Plan only at final acceptance.

## Hard rules

- M2.4.2 is ACTIVE, not closed.
- Do not weaken Layer 1 authority, Course identity, Evidence, cost guard, Search or Publication boundaries.
- Do not restore routine browser trial controls.
- Do not create Stage B/Stage C markers prematurely.
- Do not delete governed Evidence/history during recovery or housekeeping.
- NZ first-party Layer 2 Course enrichment remains DEFERRED.


## A8 release-surface rule

Read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md`.

Do not restore `#governed-runtime-marker` or any equivalent footer/floating feature-version chip. The top-right PIM Admin version + Release Notes overlay is the only normal operator-facing release surface. UAT must use deterministic shell/version controls rather than a debug/footer marker.


## Latest live RMIT continuation checkpoint

Full RMIT v1.3.0 discovery remains ACTIVE through the governed continuation chain.

Latest checkpoint recorded in this continuation:
- 192 terminal Courses;
- 80 selected;
- 80/80 selected URLs detail-CRICOS verified;
- 0 unverified selected URLs;
- 0 duplicate selected URL groups at the last duplicate audit;
- latest active worker/job at snapshot: `f9dbaa88-2f56-4604-8f53-ad4cb630cf13`;
- latest completed continuation before that worker: request `2189`, which spawned `2190`.

Retryable non-terminal discovery failures observed so far in the broad run:
- `0efc74b6-839b-4a04-826b-ff0675ead3ce` — signal aborted;
- `58c4440c-0b59-45de-9962-714c068bd419` — signal aborted;
- `5a5da2ce-380b-4913-bfa1-ac9688994324` — signal aborted;
- `7216063f-4843-4a92-8921-b2588ca1269a` — providers exhausted after Direct HTTP extraction failure, Firecrawl 502, Scrape.do timeout, ScraperAPI credential missing and ZenRows extraction failure;
- `7323c63e-5f12-4813-b72a-01b56aacad3c` — signal aborted;
- `658f183e-667d-4504-8900-89dd8cf53de4` — signal aborted.

These failures must remain retryable/non-terminal and must not be converted into fabricated discovery outcomes. After the main continuation chain reaches the end of scope, restart only unresolved/retryable Courses through terminal-outcome idempotency, then audit final selected/verified/duplicate counts before managed enrichment.


## A10 filter/selector rule

Read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md`.

Do not reintroduce eager full option-list loading for Course/University/Provider filters. Dynamic option pages are capped at 10. Layer 2 State scope must visibly list all included universities, paged 10 at a time. On touch/tablet/coarse-pointer devices opening a filter must not auto-focus the search input.


## Continuation checkpoint — 28 August 2026

Latest accepted/non-mutating Pilot source before Stage B marker: `c58cff1790e8be59b7256ce30e68aa8a1d7a1be0`.
Stage B marker Pilot: `75e77c0599a32c77e8e890de9fc2ce2ba8c10a3c`.

A12 targeted PASS:
- Provider/Course detail now surfaces governed Student outcomes / International student flow / Scholarships context;
- RMIT Provider live proof: 36 QILT, 452 VIC PRISMS regional-context rows, 3 Scholarships;
- representative RMIT Course: Provider-context outcome rows + 3 Provider-scope Scholarships; PRISMS explicit not-mapped when no safe Course relationship exists;
- UQ Provider: 36 QILT rows + regional PRISMS context;
- targeted deployed UAT `33080519873` PASS;
- Security and Performance Advisors both 0 WARN / 0 ERROR after A12.

Refresh policy truth:
- UQ weekly Course refresh ENABLED;
- RMIT weekly Course refresh DISABLED pending canonical promotion;
- Federation weekly Course refresh DISABLED and profile paused/source-limited.

Documentation advanced:
- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.2.md` extended with A12 and current refresh disposition;
- `docs/coursefinder-operations-runbook-v1.4.md` published.

Stage B integration workflow run: `33115387818` — reconcile current conclusion before further release progression. Do not create/update the final acceptance marker until Stage B is PASS and the RMIT canonical-promotion blocker is resolved or formally accepted/deferred under governance.

RMIT canonical promotion remains the main technical blocker:
- frozen set: 212 distinct latest source records;
- 212/212 identity matched;
- 0 unsafe;
- 0 already applied at reconciliation;
- ChatGPT Supabase connector blocks invoking the apply-capable RPC even with dry-run flag;
- do not bypass this by synthesising a new privileged path solely to evade connector safety.

Source-pattern Layer 3 benchmark remains separately BLOCKED; this does not block independent M2.4.2 closure work.


## Post-demo authoritative continuation — 28 August 2026

This section supersedes stale statements earlier in this file where they conflict with newer accepted state.

Stakeholder meeting outcome: **very positive reception** of the Layer 2 transparency/Evidence journey and the wider QILT/PRISMS/Scholarships Course-detail decision workspace. Preserve that direction, but do not treat reception as technical PASS.

Latest Pilot head: `24998336d54b92b6ec3c5f341e217779bd6d0134`.
Frontend build `33157407841`: PASS.

Latest targeted deployed UAT:
- A12 `33157407844`: FAIL — stale test wording/layout contract after redesign. Do not revert UI; reconcile the test to the accepted semantic contract.
- A13 `33156550691`: FAIL 1/2 — hidden `.l2o-launcher` test assumption. Use normal primary Layer 2 navigation; do not restore hidden launcher.

Current refresh truth:
- UQ weekly Course refresh ENABLED;
- RMIT DISABLED pending 212-record canonical promotion;
- Federation DISABLED / paused / source-limited.

A13 live screenshot proof remains:
- source Evidence `eb305cd4-577e-4ced-988b-243fc3318f6e`;
- screenshot Evidence `48733f50-959b-43fb-b495-71aa518a10e8`;
- PNG 281,129 bytes;
- private signed thumbnail/full-view path;
- canonical/Search/Publication mutation false.

Use the ready-to-copy continuation prompt:
`project-runsheets/milestone-2/m2.4/m2.4.2/prompts/02-M2.4.2-DEMO-FOLLOW-UP-AND-CLOSURE.md`.

Do not create Stage C until targeted A12/A13 and broader Stage B are clean and the RMIT canonical-promotion blocker is resolved or formally dispositioned.


## Authoritative pre-Stage C continuation — 29 August 2026

This section supersedes stale runtime/version statements above where they conflict.

Current Pilot Stage B accepted state:
- source before marker: `69cb9b465de0a00247db381bcbffcc98a6b1f30a`;
- Stage B marker: `e2eec9b8de0187a5373b506342316ea457b79a0b`;
- integration run `33214733610`: desktop PASS, mobile PASS;
- PIM Admin release surface: v2.15.9.

Current deployed discovery/telemetry truth:
- `layer2-acquire-v2` Edge v9;
- `layer2-scope-discover-scheduled` Edge v19 / worker v1.3.2;
- `layer2-scale-qualify-scheduled` Edge v3;
- active Layer 3 callers: `layer3-interpret` v3, `layer3-provider-control` v2, `layer3-source-pattern-benchmark` v7;
- A14 telemetry is mandatory for new execution paths.

Current refresh/promotion truth:
- UQ weekly Course refresh ENABLED;
- RMIT weekly Course refresh DISABLED;
- Federation weekly Course refresh DISABLED and profile PAUSED/source-limited;
- RMIT frozen promotion cohort: 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`;
- RMIT promotion remains formally BLOCKED because no already-authorised exact frozen-set executor exists. Do not create a privileged bypass.

Current docs:
- Data Operations Admin Guide v1.3;
- Operations Runbook v1.5;
- Admin/PIM Design Decisions v1.19.

Next gate:
1. re-run live Security/Performance Advisor and runtime freeze checks;
2. create exactly one M2.4.2 Stage C acceptance marker;
3. require desktop/mobile acceptance PASS;
4. only then close CF-CHG-044/M2.4.2 and advance Running Build/Master Project Plan.


## Authoritative post-Stage C continuation — 29 August 2026

This section supersedes any earlier instruction to create or run Stage C.

The single final Stage C has already been consumed:
- candidate `91b115ddf64b020563c7ae6bbd1ea395db866d3f`;
- run `33215640328`;
- desktop 45 PASS / 1 FAIL;
- mobile skipped because desktop failed.

The sole failing test was a stale Course-card reorder assertion that predated the accepted A12 insight card. Runtime one-step reorder semantics are correct. The permanent test contract was corrected at Pilot `60e9e25a86a48522dbae7a29d6c2955c9d295761`.

Do **not** create a replacement Stage C marker and do **not** silently rerun final acceptance. M2.4.2 is BLOCKED until an explicit governance/change-control decision authorises a new final-acceptance attempt.

Until then:
- retain Stage B run `33214733610` as desktop/mobile PASS evidence;
- retain Stage C run `33215640328` as the immutable final-gate failure;
- do not close CF-CHG-044;
- do not advance Running Build/Master Project Plan;
- preserve RMIT canonical-promotion and Layer 3 source-pattern blockers;
- preserve A14 telemetry.
