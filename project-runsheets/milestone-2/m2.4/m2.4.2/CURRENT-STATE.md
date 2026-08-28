# M2.4.2 — Current State

**Status:** ACTIVE — A9 TARGETED PASS / FULL-RUN GATES OPEN; NOT YET ACCEPTED  
**Started:** 27 August 2026 04:28 AEST (+10:00)  
**Change Control:** `CF-CHG-20260827-044` — ACTIVE  
**Accepted starting Pilot:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`  
**Current A9 targeted Pilot head:** `638970c0b6fe323ba93260289301218a7f218aff`  
**Visible browser baseline at M2.4.2 start:** PIM Admin `v2.15.7`

## Accepted inherited baseline

- M2.4.1 CLOSED/PASS.
- AU/NZ Layer 1 authority, source validation, Evidence, queue, retry/resume, variance, scheduling, security and housekeeping contracts are frozen dependencies.
- Layer 2 remains deterministic acquisition/extraction.
- Layer 3 receives governed unresolved fall-out only.
- Layer 4/Search/Publication authority remains unchanged.
- NZ first-party Layer 2 Course enrichment remains DEFERRED unless separately qualified/authorised.

## Start reconciliation

Pilot `main` was verified at the accepted M2.4.1 SHA when M2.4.2 began.

Deployed Pilot Supabase initial counts:

- Layer 2 source profiles: 6;
- profile versions: 13;
- acquisition providers: 6;
- profile-provider routes: 26;
- provider attempts: 103;
- execution policies: 4;
- run batches: 1;
- run items: 3;
- Evidence artifacts: 1,699.

The existing architecture already includes `layer2_execution_policies`, `layer2_run_batches`, `layer2_run_items`, provider attempts, Evidence lifecycle, governed read/control functions and acquisition/extraction Edge runtimes. M2.4.2 extends/reconciles these contracts rather than creating duplicate concepts.

## Implemented first operational-maturity slice

- production-shaped Layer 2 operator workspace added;
- one-active-batch protection, heartbeat/stale recovery substrate and governed profile concurrency added;
- provider/source attempt telemetry, Evidence summary, scope/queueability and explicit Layer 3 fall-out visibility added;
- trial controls removed from the routine Layer 2 path;
- NZ Layer 2 Course deferral remains explicit;
- targeted deployed Stage A desktop run `33001852982` PASS;
- first-party deterministic scope-discovery worker/substrate deployed and mirrored, but broad discovery/full enrichment is not yet accepted.

## Addendum A8 — operator-first Sync

A8 is now implemented for the targeted operator/UI/security slice.

Routine journey:

`Country → University / catalogue provider → Scope preview → Discover & sync / Sync now → Progress → Results`

Implemented behaviour:
- routine Layer 2 starts with Country and University/catalogue-provider selectors;
- only authorised Layer 2 Course profiles are selectable/launchable;
- current AU selector exposes the accepted Federation, RMIT and UQ Course scopes;
- NZ Course enrichment remains explicitly deferred/non-launchable;
- scope preview distinguishes Catalogue, Ready to sync, Needs discovery and Run concurrency before execution;
- if no governed Course URL is queueable, the primary action is `Discover & sync` and invokes the accepted deterministic discovery substrate;
- if selected current-profile discovery candidates are queueable, the action becomes `Sync now` and creates a managed run from those governed URLs;
- acquisition-vendor routing remains automatic under accepted profile-provider route policy for routine operations;
- Firecrawl/Scrape.do/etc. credentials, route tuning, vendor concurrency/rate/timeout and qualification controls remain Advanced;
- active/concurrent-run protection remains database-authoritative.

### Acquisition-provider persistence correction

The reported Firecrawl editing problem has been corrected in the Advanced provider editor:
- provider save re-reads the server record after update;
- concurrency/rate/timeout must exactly match the persisted record or the UI reports failure rather than claiming success;
- local drawer state is resynchronised from the persisted provider record;
- successful privileged saves display an explicit `Saved and verified` state;
- acquisition-provider concurrency is labelled separately from source-profile/run concurrency;
- client and database guards enforce vendor concurrency 1–20, timeout 1–120 seconds and rate null/default or 1–10000 requests/minute.

Current deployed Firecrawl configuration after validation/restoration remains:
- vendor concurrency `2`;
- rate limit `30/min`;
- timeout `90s`.

A direct persistence probe temporarily changed Firecrawl concurrency from 2 to 3, confirmed the persisted value, then an explicit restore returned it to 2/30/90. No canonical/Evidence state was affected by that configuration probe.

### Security correction

An initial direct authenticated SECURITY DEFINER operator-sync RPC was rejected during implementation after Security Advisor raised `authenticated_security_definer_function_executable`.

The final A8 architecture for this slice is:
- browser → `layer2-sync-control` Edge Function with `verify_jwt=true`;
- Edge rechecks authenticated Admin context and Pipeline Operator rank server-side;
- Edge calls service-only `public.layer2_operator_sync_service(...)`;
- the service helper independently rechecks the supplied actor rank;
- `anon` and `authenticated` have no EXECUTE privilege on the service helper; `service_role` only;
- the superseded browser-callable privileged RPC was removed.

Security Advisor was rerun after correction. The new SECURITY DEFINER warning is gone; remaining findings are INFO-level existing private-table/RLS patterns.

## A8 targeted validation

### Candidate
- Pilot: `db8ff542d275962c4f97ff1c8d37cffe736039cf`.
- Frontend Build + browser smoke: `33004496198` — PASS.
- Corrected targeted deployed desktop UAT: `33004496331` — PASS.

The targeted suite proves:
- AU Country → University selector journey;
- RMIT/UQ/Federation scope exposure;
- Catalogue / Ready to sync / Needs discovery / Run concurrency preview;
- routine acquisition internals and bounded-trial controls remain quarantined;
- run concurrency and acquisition-vendor concurrency are clearly distinct;
- Firecrawl vendor limits are visible to the standard UAT operator while edit controls remain correctly Platform Admin privileged;
- no browser/server runtime errors in the targeted slice.

An earlier targeted run `33004179270` failed only because the test attempted to use the lower-rank permanent UAT identity to access Platform Admin provider-edit controls. The implementation did not lower that boundary. The test was corrected to assert the privileged boundary, and the current candidate passed.


## Addendum A9 — scope-first sync + ordered routing — TARGETED PASS

A9 is implemented for the targeted routing/scope/UI slice.

Routine workflow:

`Country → Fetch scope (Country / State / University) → Scope value → Preview → Sync/Recheck → Progress → Results`

Implemented scope semantics:
- AU Country preview resolves exactly 1,072 Courses across Federation, RMIT and UQ;
- VIC State preview resolves 690 Courses across Federation and RMIT using Course→Campus→Subdivision membership;
- QLD State preview resolves 404 Courses across Federation and UQ;
- RMIT University preview resolves all 500 RMIT Courses;
- Country/State starts fan out by authorised source profile/university; large managed batches execute in profile-governed bounded waves rather than one long Edge request;
- scoped discovery carries exact Course IDs through 50-record continuation waves and queues only governed URLs when discovery completes.

Implemented routing:
- current AU Course route order is Direct HTTP → Firecrawl → Scrape.do → ScraperAPI where configured → ZenRows;
- both scheduled discovery and managed batch acquisition now consume the profile's existing ordered `runtime.routes`; managed batches no longer preselect/force one acquisition provider;
- provider budget/availability/cost/fallback conditions are checked before/after attempts;
- automatic routing skips providers with unknown acquisition cost rather than silently spending;
- provider-attempt status vocabulary is reconciled to accepted values; discovery no longer submits invalid `completed`.

Runtime evidence:
- prior Federation failure: `c7dd414e-487a-4861-a9f3-defbfd9458f2` — 5/5 failed at invalid attempt status;
- corrected Federation run: `e5055e66-8711-4a24-a2c3-d926d681cc15` — 5 processed, 0 runtime failures; four current-page-not-found, one ambiguous, zero unsafe selections; Direct HTTP success correctly stopped fallback;
- governed Firecrawl provider trial `dd48db0c-db0d-4403-ba7f-de2a5482004c` — succeeded through `layer2-acquire-v2.7`, Evidence `ea932ca9-5fa2-4889-a0fb-9103ac4ed374`, canonical mutation false;
- true controlled Direct-failure → Firecrawl fallback remains an explicit pre-broad-run UAT gate; route order and each hop are proven, but a synthetic failure-triggered transition is not yet claimed.

Routine UI cleanup:
- normal Layer 2 now exposes Country, Fetch scope, conditional State/University selector, exact scope metrics, one sync action, progress, simple results, Evidence, recent runs and blockers;
- source-profile launchers, provider table, route/concurrency controls and low-level diagnostics are removed from the routine screen;
- one Advanced configuration entry retains privileged engineering configuration;
- Firecrawl/vendor edits remain Platform Admin privileged.

A9 targeted validation:
- Pilot `638970c0b6fe323ba93260289301218a7f218aff`;
- deployed targeted desktop UAT `33016596722` — PASS;
- frontend build + local browser smoke `33016596701` — PASS;
- preceding A9 UAT `33016397183` failed only because the navigation helper still searched for the deliberately removed Advanced-provider button; helper was corrected without reintroducing the button;
- Security Advisor: 129 INFO, no WARN/ERROR;
- Performance Advisor: 167 INFO, no WARN/ERROR;
- new A9 privileged scope helpers are executable only by service_role/postgres.


## Performance/advisor state

Performance Advisor after the A8 database changes remains INFO-only. Existing Layer 2 foreign-key indexing and unused-index observations remain inputs to the full-run performance tuning gate; thresholds have not been widened and indexes will not be added solely to silence INFO findings without workload evidence.

## Immediate work

1. Continue deterministic first-party Course-page discovery across the authorised AU Federation/RMIT/UQ profiles using bounded, measurable execution.
2. Convert governed selected discovery candidates into managed queueable runs through the simplified operator contract.
3. Execute representative/full authorised AU enrichment and capture throughput, failure/retry overhead, Evidence growth, provider economics/quota and Layer 3 fall-out.
4. Mature schedule/recheck, stuck recovery, alerts and safe transient housekeeping using measured behaviour.
5. Complete documentation/release notes once deployed behaviour is stable.
6. Nominate Stage B desktop/mobile only after the broader execution slice is stable; nominate exactly one Stage C candidate only after every M2.4.2 acceptance requirement is satisfied.

## Acceptance state

M2.4.2 remains ACTIVE and is not CLOSED/PASS. A8 targeted operator simplification is PASS, but full authorised-run evidence, scheduling/housekeeping/alerts, broader recovery/performance gates, Stage B and final Stage C remain open.

## Full-run evidence — UQ canonical enrichment and RMIT expansion (27 August 2026)

### UQ discovery and managed enrichment

- UQ current-profile discovery completed across the full 382-Course catalogue scope.
- Discovery result:
  - evaluated: 382/382;
  - governed selected URLs: 156;
  - ambiguous: 31;
  - identity mismatch: 79;
  - current page not found: 116;
  - duplicate selected URL groups across different Courses: 0.
- Final discovery continuation auto-created managed batch `7fe8446f-f480-4e2e-a901-2b73952ad323` for exactly the 156 governed selected URLs.
- The first representative run proved acquisition/Evidence but exposed systematic fee-confidence fall-out. The run was deliberately cancelled rather than consuming the remaining queue with a known parser weakness.
- Cancellation maturity corrections:
  - `layer2_run_batch_reconcile` now preserves terminal `cancelled` state even when a late in-flight runner reconciles;
  - `layer2-batch-runner` now rechecks live batch/item status before every item and stops at the cancellation boundary rather than consuming a stale queue snapshot.
- Deterministic Course extractor advanced to `layer2-course-fact-extract-v2.5`:
  - explicit AUD/A$ fee context and international/CRICOS proximity improve deterministic fee confidence;
  - domestic/CSP/HECS context remains a strong negative;
  - no provider-specific price values or Course IDs are hard-coded.
- Regression batch `7fb8c4a9-b6d0-499e-9503-8eb13c424c80` passed 3/3 previously problematic UQ Courses at 5/5 resolved fields, Direct HTTP only, zero vendor cost.
- Fresh post-fix UQ full managed batch `eb52b6e2-c33b-4dfc-9e87-c107834218e0` completed:
  - target: 156;
  - resolved_l2: 153;
  - Layer 3 required: 3;
  - blocked: 0;
  - vendor units: 156;
  - vendor cost: USD 0;
  - runtime: ~9m16s from started_at to completed_at.
- The three controlled Layer 3 exceptions are:
  - CRICOS `027288A` Study Abroad — no fee candidate;
  - CRICOS `082599G` Master of Economics and Public Policy — no fee candidate;
  - CRICOS `094716G` Doctor of Veterinary Clinical Science — low-confidence international fee candidate.
- Bulk dry-run of the 153 resolved candidates proved 153/153 exact UQ provider/Course CRICOS resolution through the accepted apply contract before mutation.
- The canonical apply contract was corrected to map extracted TOEFL to the existing `ref.english_tests.code='TOEFL_IBT'`; the preceding bulk statement failed transactionally and was verified not to partially mutate canonical state.
- Canonical promotion then passed 153/153:
  - official Course links applied: 153;
  - guarded international fees applied: 153;
  - intake rows applied/upserted: 488;
  - English requirements applied/upserted: 453;
  - Course descriptions applied: 153;
  - Search mutation authorised: false;
  - Publication mutation authorised: false.
- Post-apply UQ source totals now include 161 active first-party links, 1,307 active fee rows, 503 active intakes, 471 active English requirement rows, 153 populated descriptions and 161 applied source records. Existing rows were preserved/upserted rather than blanket replaced.
- Off-domain validation for UQ Layer 2 links: 0 bad links.

### Federation

- Full Federation discovery evaluation completed for all 190 Courses under the original accepted catalogue strategy with zero selected URLs.
- 10 previously applied, identity-verified first-party Course URLs were safely seeded into the current immutable profile version with existing Evidence/provenance.
- Current governed queueability: 10/190.
- The remaining 180 are source-limited under deterministic first-party discovery; no threshold weakening or external-search shortcut has been accepted.

### RMIT

- RMIT immutable profile version now requires real `/study-with-us/levels-of-study/` Course-detail URLs.
- Direct HTTP 202/no-detail-link responses correctly fall through to Firecrawl under route policy.
- Candidate filtering now enforces the required detail-path prefix before ranking.
- Discovery scoring v1.2.4 distinguishes provider-suffixed exact titles from nearby Honours variants:
  - control CRICOS `110982H` Bachelor of Science now selects `.../bachelor-of-science-bp350`;
  - `Bachelor of Science (Honours)` remains unselected.
- Full bounded RMIT discovery started as request `2138` for the remaining 499/500 Courses. Unknown-cost vendor fallback remains blocked.

### Source/runtime reconciliation commits

Pilot runtime/source reconciliation includes:
- discovery worker unknown-cost guard and detail-path candidate filter;
- discovery worker provider-suffix/Honours disambiguation;
- deterministic Course extractor v2.5 mirror;
- batch-runner cancellation-boundary mirror;
- cancelled-batch reconciliation migration;
- TOEFL → TOEFL_IBT apply-contract migration.

### Acceptance impact

- UQ now satisfies the broad deterministic discovery → managed acquisition/extraction → governed canonical-apply evidence path for 153 Courses, with 3 explicit Layer 3 exceptions.
- This is substantial full-run evidence, but M2.4.2 remains ACTIVE because RMIT/Federation accepted-scope disposition, scheduling/rechecks/alerts/housekeeping, final performance/security regression, Stage B and exactly one final Stage C are still open.


## RMIT detail-page CRICOS gate + Layer 2 operational maturity (27 August 2026)

### RMIT identity correction

Broad RMIT search-result discovery exposed two duplicate URL groups where legacy and current CRICOS records shared the same Course title:
- BH079 Chemical Engineering (Honours): legacy `079626B` and current `110997A`;
- BH077 Civil and Infrastructure (Honours): legacy `079625C` and current `110995C`.

The current first-party RMIT detail pages identify the current CRICOS values, so title-only search-result selection was rejected as unsafe.

Corrective action:
- RMIT discovery was paused;
- all pre-v1.3.0 current-version terminal RMIT discovery decisions were invalidated to non-selected `candidate` rows while preserving Evidence, provider attempts, timestamps and the prior status in `match_basis.pre_detail_verification_status`;
- discovery worker advanced to `layer2-scope-discover-scheduled-v1.3.0`;
- a top search candidate is now queueable only after its current first-party Course detail page contains the expected CRICOS;
- verification HTML is retained as Layer 2 Evidence with `operation=course_url_identity_verification`;
- verification provider attempt telemetry records `detail_cricos_verified` / `detail_cricos_missing`;
- no canonical mutation occurs during discovery/verification.

Two-Course control request `2164` PASS:
- current CRICOS `110997A` → BH079: selected, `detail_cricos_verified=true`, verification Evidence retained, Direct HTTP detail verification succeeded;
- legacy CRICOS `079626B` → same BH079 URL: not selected, `identity_mismatch`, `detail_cricos_verified=false`, explicit blocker that current first-party page does not contain the legacy CRICOS;
- processed 2 / selected 1 / failed 0 / no continuation.

RMIT was re-paused after the control while the v1.3.0 contract is frozen into source/UAT before any broad restart.

### Discovery runtime / restart hardening

- terminal discovery outcomes are idempotent for an immutable profile version; restarts no longer re-acquire already terminal exact/likely/ambiguous/mismatch/not-found Courses;
- provider/acquisition failures remain retryable;
- continuation uses set subtraction rather than assuming context/input ordering;
- per-Course and per-invocation budgets prevent routine continuations exceeding pg_net's outer request ceiling;
- paused profiles are enforced through the existing `layer2_runtime_context` executable-state contract, without exposing private `security.*` helpers.

### Refresh / housekeeping

A Layer 2 Course refresh dispatcher and non-destructive housekeeping substrate are deployed:
- cron `coursefinder-layer2-refresh-dispatcher`: 03/18/33/48 minutes each hour;
- cron `coursefinder-layer2-housekeeping`: daily 03:27;
- profile-scoped weekly UQ/RMIT/Federation refresh policies exist but remain deliberately disabled until full-run acceptance;
- due Layer 2 profile refreshes will reuse the existing managed-batch service and reconcile `refresh_requests` from the resulting batch;
- housekeeping only recovers stale provider attempts/jobs/batches;
- verification run: 0 Evidence deleted, 0 profile versions deleted, 0 provider-attempt history deleted, 0 run history deleted, 0 canonical history deleted.

### Operational alerts

The existing Layer 2 operator workspace now receives governed computed alerts through `admin_read('layer2_ops_alerts')`:
- stale managed run;
- paused Course profile;
- blocked run items;
- repeated acquisition-provider failures;
- provider quota near configured reserve.

The alert helper requires authenticated rank >=4, exposes no credentials/private table access, and follows the accepted authenticated EXECUTE/private-schema read-helper pattern.

Current alert evidence includes Federation's intentional pause/source limitation; RMIT pause is also expected while the CRICOS verification gate is frozen.

### Current acceptance impact

- UQ broad end-to-end enrichment remains PASS.
- Federation safe subset remains PASS / remainder source-limited.
- RMIT title-only broad discovery evidence before v1.3.0 is explicitly superseded and cannot be used as acceptance evidence.
- RMIT broad discovery/enrichment must be rerun under the v1.3.0 detail-page CRICOS gate before M2.4.2 can close.
- Stage B and Stage C remain NOT nominated.


## Targeted UAT recovery + RMIT v1.3.0 high-risk cohort

The post-v1.3.0 targeted browser failure was diagnosed and corrected without weakening runtime controls:
- alert-read ACL was missing for the rank-4 authenticated helper path because an earlier validation GRANT had been rolled back with its test transaction;
- runtime ACL was applied in a committed call and mirrored by `20260827225500_m2_4_2_layer2_alert_acl_reconcile.sql`;
- Layer 2 UI now loads primary sync scope independently of the optional alert feed;
- deployed UAT no longer assumes paused profiles are executable scope options;
- the legacy hidden provider-launcher force-click was removed from routine rank-4 UAT;
- the source assertion now matches the hardened 80-second invocation budget.

Corrected targeted evidence:
- Pilot `a6e09ccd84a1d39e1911f37fbd793d48cf52cdb8`;
- deployed targeted UAT `33027788662` — PASS;
- frontend build/browser smoke `33027788651` — PASS.

Rank/ACL evidence:
- anon alert helper EXECUTE: false;
- authenticated alert helper EXECUTE: true, with internal rank >=4 enforcement;
- anon/authenticated housekeeping EXECUTE: false;
- anon/authenticated Layer 2 refresh dispatcher EXECUTE: false;
- rank-3 authenticated alert read rejected with `pipeline_operator role required`;
- rank-4 authenticated alert read PASS.

RMIT high-risk duplicate-title/multi-CRICOS cohort:
- request chain `2165 → 2166 → 2167 → 2168`;
- 20/20 Courses terminal;
- 6 selected;
- 6/6 selected with `detail_cricos_verified=true`;
- 0 unverified selections;
- 0 duplicate selected URL groups;
- 4 ambiguous;
- 10 identity mismatch;
- 0 current-page-not-found in this cohort;
- 0 runtime failures.

Provider telemetry for the cohort:
- Firecrawl: 20 rendered-search attempts, 20 succeeded, average ~11.5s;
- Direct HTTP: 34 attempts including search fall-through/detail verification, 6 succeeded verification, average ~0.6s, zero vendor fee;
- subscription cash cost for Firecrawl remains not recorded; vendor quota is measured separately.

Full RMIT university rerun started under the normal operator service as request `2169`:
- 500 total Courses;
- 493 needed discovery at launch;
- 7 already governed/selected preserved;
- early full-scope waves remain bounded and failure-free;
- all selected URLs observed so far are detail-CRICOS verified;
- duplicate selected URL audit remains zero.


## A8 release-surface cleanup

A8 is now standing M2 governance for M2.4.2 onward.

Pilot implementation:
- removed the persistent `#governed-runtime-marker` footer/chip and its styling;
- simplified the browser document title to the PIM Admin product/version rather than component feature-version inventory;
- retained the top-right `.m-release-pill` as the sole operator-facing release/version control;
- release overlay remains the governed version/date/change-history surface;
- UAT shell readiness now checks the actual version control rather than the removed footer;
- release, Layer 3 and Course Detail deployed suites now explicitly require the obsolete runtime marker to be absent.

The PIM Admin release version is intentionally not bumped yet because M2.4.2 full RMIT acceptance is still in progress.


### A8 deployed acceptance

Footer/runtime feature-marker cleanup is now targeted PASS:
- Pilot `27f56ddb944569e3ca1061ce6d27f760642e58e0`;
- deployed UAT `33029342740` — PASS;
- frontend build `33029342761` — PASS.

The normal Admin no longer renders `#governed-runtime-marker`; shell readiness and release UAT use the real `.m-release-pill` control and the Release Notes overlay.


## A10 paged-filter / tablet-focus implementation

A10 is now standing M2 governance.

Implemented in the current Pilot slice:
- deployed `security.admin_catalogue_filter_page(jsonb)` through `admin_read('catalogue_filter_page')`;
- server hard cap: maximum 10 filter options per request;
- response includes items, total, limit, offset and has_more;
- Course Country, State/Region, Provider, Study level, Field and Delivery filters use lazy server-side paging/search rather than the previous full `course_filters` bundle;
- shared local `FilterSelect` renders at most 10 options per page;
- shared filter search input no longer uses unconditional `autoFocus`; only fine-pointer desktop contexts receive programmatic focus;
- Layer 2 State preview visibly lists all resolved governed universities/profiles and pages the display 10 at a time;
- State scope remains a single scope action: operators do not individually select each university.

A10 targeted build/deployed UAT is in progress and must PASS before this slice is accepted.


### A10 targeted deployed acceptance

A10 is targeted PASS on Pilot `f8e743c417df26ead234523718a2b8024e415646`:
- deployed UAT `33030713534` — PASS;
- frontend build `33030713535` — PASS;
- server filter API hard-cap independently verified by requesting `limit=50` and receiving `limit=10`, 10 items, `total=84`, `has_more=true` for a Provider search;
- coarse-pointer browser UAT proved opening the Course Provider filter does not focus the search input;
- Course Provider search remains server-side and page-bounded to 10;
- Layer 2 Queensland State preview visibly shows The University of Queensland as an included governed university/profile;
- shared filter rendering is capped to 10 items per page.

Admin/PIM Design Decisions v1.17 now carries the platform-wide paged-filter, dependent-scope and tablet-focus contract.


### A10 platform-wide paged-filter PASS

A10 is now PASS for the current large dynamic Admin filter surfaces on Pilot `656999ef5f92f74b850482e559f418beb93ac9bc`:
- cross-screen deployed UAT `33031938406` — PASS;
- frontend build `33031938398` — PASS;
- Layer 2 State/University options are server-paged at 10; State preview no longer returns the full profile list;
- Course Country/State/Provider/Study level/Field/Delivery use server-paged options;
- Evidence Source uses country-aware server paging; the legacy Evidence bundle now returns `sources: []`;
- QILT Provider and Metric use server paging; the legacy QILT bundle now returns empty `providers`/`metrics` arrays;
- PRISMS Study Area uses server paging; the legacy PRISMS bundle now returns `study_areas: []`;
- shared/local filter renderers are capped to 10 rows and no longer use unconditional `autoFocus`;
- coarse-pointer deployed UAT proves filter opening does not focus the search field;
- CI automatically selects `tests/uat/a10-paged-filters-deployed.spec.mjs` for A10 filter changes and includes it in integration/acceptance.

Current runtime option cardinalities at acceptance: Evidence Source 44; QILT Provider 105; QILT Metric 19; PRISMS Study Area 13. Oversized requests remain server-capped to 10.


### A10 advisor verification

Post-A10 Supabase Advisor review is clean for the new paged-filter functions:
- Security Advisor: 129 total notices, **0 material WARN/ERROR or new function-executable findings** related to `admin_filter_option_page`, `layer2_scope_options_page_service` or `layer2_scope_countries_service`;
- Performance Advisor: 166 total notices, **0 material WARN/ERROR findings** related to the A10 functions;
- remaining notices are existing INFO-class RLS/no-policy, unused-index and project configuration findings and were not changed without workload/security evidence.


### RMIT full discovery + bounded retry gate

RMIT discovery/retry is complete for the accepted current profile version `409b0f7c-4e04-4a33-8f4d-e173fc3f9c40`:
- canonical RMIT catalogue: 500 Courses;
- terminal deterministic discovery outcomes: 498/500;
- selected current first-party Course URLs: 261;
- detail-CRICOS verified selected URLs: 261/261;
- selected URLs outside RMIT-owned hosts: 0;
- duplicate selected URLs across Courses: 0 at the verified-set audit;
- canonical `catalogue.courses.course_url` mutations during discovery: 0;
- bounded retry request `2257` recovered 21 additional verified selected Courses beyond the original 240 auto-sync set;
- two residual Courses remain source-limited: CRICOS `091377B` and `091378A`, both `RMIT Inbound Internship`. The accepted profile requires `/study-with-us/levels-of-study/`; all configured providers exhausted for these records. Current RMIT first-party material for the inbound internship sits on the separate `inbound.rmit.edu.au` estate and does not provide an accepted CRICOS-bearing Course page under the current profile contract. No prefix/identity rule was weakened and no third-party page was accepted.

The primary discovery chain auto-created managed batch `6abe8558-e1b9-4a6f-ba97-47481ba488bb` for the 240 verified selections available at its completion boundary. The 21 retry selections are intentionally outside that active batch and will be processed in a second bounded batch only after the first batch reaches terminal state.


### Managed-run observability correction

During the representative RMIT managed batch, deployed truth showed that `layer2_run_items.retry_count` incremented on the first normal `acquiring` transition and the existing runner left `response_ms`, `extraction_ms` and `outcome_code` empty. This was corrected without changing acquisition, routing or extraction semantics:
- migration `20260827234000_m2_4_2_run_item_observability_fix.sql` corrects retry semantics so only a subsequent acquisition attempt increments `retry_count`;
- active RMIT batch first-attempt rows were corrected from retry_count 1 to 0 because no item-level requeue/resume had occurred;
- service-only `layer2_run_item_metrics_mark` records response/extraction timing and terminal outcome/failure class;
- `layer2-batch-runner` v6 is deployed with the existing custom-auth boundary and records acquisition `latency_ms` plus normalise+deterministic-extraction elapsed time;
- deployed verification after v6 showed retry_count=0, populated response/extraction timing and outcome codes on new items.

Representative post-fix sample at the 160-item checkpoint: acquisition ~1.4–1.5s average, deterministic normalise+extract ~1.5s average, zero item-level retries and zero blocked items. Evidence Storage growth since the primary batch began was ~342.5 MB at that checkpoint.


### RMIT full managed-run gate — PASS for representative profile

Final deployed RMIT representative/full-profile results:
- canonical catalogue: 500 Courses;
- deterministic discovery terminal outcomes: 498/500;
- selected first-party current Course URLs: 261;
- detail-CRICOS verified selected URLs: 261/261;
- selected URLs outside RMIT-owned hosts: 0;
- duplicate selected URLs: 0;
- canonical Course URL mutations during discovery: 0;
- residual source-limited Courses: CRICOS 091377B / 091378A only.

Managed enrichment ran in two non-overlapping batches after bounded retry recovery:
- `6abe8558-e1b9-4a6f-ba97-47481ba488bb`: 240 processed, 193 resolved L2, 47 Layer 3 required, 0 blocked;
- `aaf5809a-0dbd-47e2-9461-9fe58a3bba11`: 21 processed, 19 resolved L2, 2 Layer 3 required, 0 blocked;
- combined: 261/261 processed, 212 resolved L2, 49 governed Layer 3 fall-outs, 0 blocked, 261 vendor units, USD 0 recorded vendor cost, 0 item-level retries;
- combined wall-clock from first batch start to second batch completion: 1,353.18 seconds;
- post-observability-fix timing sample: 111 items, acquisition average ~1.45s / p95 ~1.81s; deterministic normalise+extract average ~1.52s / p95 ~1.89s;
- governed RMIT Evidence since full discovery began: 1,355 Storage-backed Evidence objects, ~823,176,192 bytes.

Terminal PARTIAL state handling was corrected so a completed partial batch is historical/terminal, not an active-run blocker. Preview now reports no active RMIT batch after completion. Post-DDL Security Advisor and Performance Advisor show 0 material findings for the new run-item metrics/state functions.

## Continuation reconciliation — 27 August 2026 18:13 AEST

Repository and deployed Pilot truth were re-reconciled after the final RMIT full managed-run evidence.

- Current Pilot main has advanced beyond the M2.4.2 run candidate because the parallel Zoho workstream added isolated Course API commits; those commits do not supersede the M2.4.2 Layer 2 runtime evidence.
- RMIT full managed enrichment is confirmed terminal: 261/261 processed, 212 resolved L2, 49 governed Layer 3 fall-outs, 0 blocked.
- The exact RMIT canonical-promotion set was independently reconciled from the two terminal managed batches by source URL: 212 resolved items, 212 distinct URLs, 212/212 latest RMIT provider `00122A` source records identity-matched, 0 already applied, 0 unsafe.
- Final Security Advisor recheck remains INFO-only for the current project; no new material M2.4.2 WARN/ERROR was identified.
- Final Performance Advisor recheck remains INFO-only; existing unindexed-FK/unused-index findings are retained for workload-based disposition rather than being changed merely to silence INFO notices.
- Canonical dry-run/apply through `public.layer2_apply_course_candidate(...)` remains the next consequential RMIT gate. The current ChatGPT Supabase connector blocked invocation of the apply-named function even with `p_apply=false`; no bypass was attempted and no canonical mutation occurred.
- Independent closure work may continue: refresh-policy decision, permanent cancellation/recovery/replay/idempotency regression, security negatives, Layer 1 + Jobs/Evidence/Data Quality regression, documentation/release-note freeze, Stage B, then exactly one Stage C.

M2.4.2 therefore remains ACTIVE / NOT YET ACCEPTED.


## Scale-out strategy decision — 27 August 2026

The programme will no longer treat each remaining AU/NZ university as a separate engineering exercise.

UQ, RMIT and Federation are accepted as the initial Layer 2 qualification/evidence cohort. Their combined evidence demonstrates:
- broad deterministic first-party discovery and governed canonical promotion (UQ);
- high-volume identity-safe discovery, provider routing, Evidence growth, managed-run performance and explicit L3 fall-out (RMIT);
- safe source-limited handling without weakening identity controls (Federation).

The next operating model is wave-based onboarding:

`sample → source/profile qualification → automated full discovery → managed enrichment → safe L2 promotion → L3/L4 exception handoff`

Australia will progress in multi-university waves, with representative bounded qualification before automatic full scope. Identity safety remains absolute for anything automatically selected/promoted, while incomplete coverage is accepted as governed source-limited/ambiguous/L3/L4 fall-out.

NZ will not clone the AU implementation university-by-university. NZQA remains Layer 1 authority and a small 2–3-provider source-pattern qualification cohort will be used to establish reusable NZ first-party profile families before broad rollout.

M2.4.2 acceptance therefore requires a proven scalable onboarding/operations contract and representative national-scale evidence, not individual completion of every AU/NZ university. Remaining catalogue rollout becomes follow-on operations that can run while Layer 3 and Layer 4 consume the accumulated governed exception/Evidence stream.


## A11 implementation — full Layer 1 catalogue scope + qualification-wave POC

A11 has moved from strategy to deployed proof-of-concept.

The Layer 2 Country/State/University selectors are no longer sourced only from executable Layer 2 profiles. They now resolve from the full current Layer 1 catalogue and expose qualification state separately.

Live Layer 1 scope at implementation:
- AU: 1,546 institutions / 26,648 Courses;
- CA: 82 institutions / 10,356 Courses;
- NZ: 286 institutions / 6,457 Courses.

Subdivision/state scope now resolves from Layer 1 where subdivision data exists:
- AU: all 8 states/territories represented;
- CA: 10 provinces/territories represented in the current Layer 1 catalogue;
- NZ: no subdivision options are currently returned because the ingested NZ Layer 1 provider/course catalogue does not presently carry usable subdivision linkage. This is a Layer 1 data-coverage fact, not a Layer 2 hard-coded restriction.

New scope semantics:
- every Layer 1 institution with Courses is selectable;
- qualified/executable Layer 2 institutions are labelled separately;
- unqualified institutions remain visible as “Needs Layer 2 qualification” rather than being hidden;
- country/state/university previews report Layer 1 institution/Course counts, L2-qualified institutions, qualification-required institutions, executable Courses and governed-URL readiness.

Initial live qualification-wave POC:
- AU qualification run `a8363428-f6b9-4201-8ddb-c2dda0d79396`: 5 institutions / 50 Course samples;
- CA qualification run `5aa15976-585c-4d85-9c92-b31f72b7251a`: 5 / 50;
- NZ qualification run `dd0da717-e903-4d28-9c6d-d95ad0e46241`: 5 / 50.
- follow-on AU dedupe proof `f0eac45d-e72e-4179-b39a-5dd545ded1c0`: second 5 / 50 wave with **0 provider overlap** against the first AU wave.

The qualification-wave POC is intentionally non-mutating. It selects deterministic bounded samples and records the next step as deterministic source qualification. Canonical/Search/Publication mutation flags are all false.

Wave orchestration has also been hardened so providers already present in active planned/running qualification waves are skipped by subsequent waves.

Deployed implementation:
- migration `m2_4_2_a11_layer1_catalogue_scale_scope`;
- migration `m2_4_2_a11_qualification_wave_dedupe`;
- `layer2-sync-control` Edge v5 with `verify_jwt=true`;
- Pilot source commits through `e646e3537975d0b6e4b6897ffe32409b848a96eb`.

Post-DDL Security and Performance Advisors remain INFO-only for this slice; no new material WARN/ERROR was observed.

A11 is therefore **POC PASS for full Layer 1 visibility + bounded cross-country wave selection/orchestration**. It is not yet evidence that unqualified providers have completed deterministic acquisition/source qualification. The next consequential gate is to execute the selected qualification samples through governed acquisition/Evidence and promote reusable source-pattern/profile families only when identity-safe evidence passes.


## A11 qualification execution and cross-layer handoff — POC gate

A11 has progressed beyond catalogue visibility into live governed source qualification.

### Source-seed qualification

The first AU/CA/NZ 5-provider × 10-Course waves were executed through the existing Layer 2 acquisition-provider routing and Evidence lifecycle. Qualification-only profiles use authority class `qualification_candidate`; they are service/runtime-internal and are explicitly excluded from routine Layer 2 qualified/executable scope until a later strict promotion gate succeeds.

Provider-level source-seed outcomes:

**Australia**
- Adelaide University — source-limited because the current Layer 1 provider website seed is missing/invalid;
- Monash University — Evidence-backed first-party source-pattern candidate;
- The University of Sydney — Evidence-backed source-pattern candidate;
- University of Technology Sydney — Evidence-backed source-pattern candidate;
- UNSW Sydney — Evidence-backed source-pattern candidate.

**Canada**
- British Columbia Institute of Technology;
- Simon Fraser University;
- University of Alberta;
- University of British Columbia;
- University of Victoria.

All five selected CA providers are source-limited because the current Layer 1 records have no provider website seed. No website was guessed or manufactured.

**New Zealand**
- Massey University — Evidence-backed source-pattern candidate;
- University of Auckland — source-limited because the Layer 1 website value is malformed;
- University of Canterbury — Evidence-backed source-pattern candidate;
- University of Waikato — Evidence-backed source-pattern candidate;
- Victoria University of Wellington — Evidence-backed but no deterministic Course-navigation signal, therefore Layer 3 required.

Source-seed sample totals:
- AU: 40/50 Evidence-backed pattern candidates; 10/50 source-limited;
- CA: 0/50 Evidence-backed; 50/50 source-limited;
- NZ: 30/50 pattern candidates; 10/50 Evidence-backed Layer 3 required; 10/50 source-limited.

### Strict deterministic pattern-control gate

Homepage/study navigation signals were not accepted as sufficient qualification evidence. Candidate catalogue/study URLs were passed back through the mature `layer2-scope-discover-scheduled-v1.3.0` identity-verification worker with three Layer 1 control Courses per provider.

The promotion rule is strict: **3/3 control Courses must resolve to identity-verified current first-party detail pages before a qualification candidate may become `first_party_qualified`.**

Results:
- Monash — 0/3 verified → Layer 3 required;
- Sydney — Layer 1 source exposed a legacy HTTP candidate; the mature verifier correctly requires HTTPS. No automatic protocol rewrite was accepted → Layer 3 required;
- UTS — initial direct route returned HTTP 401; the qualification-only route was safely extended to permit 401 fallback, but bounded revalidation still produced 0/3 verified → Layer 3 required;
- UNSW — 0/3 verified → Layer 3 required;
- Massey — 0/3 verified → Layer 3 required;
- Canterbury — 0/3 verified → Layer 3 required;
- Waikato — 0/3 verified → Layer 3 required;
- Victoria University of Wellington was already Layer 3 required from the source-seed gate.

**No new provider profile was automatically promoted.** This is a safety PASS: generic deterministic source-pattern guesses were rejected rather than weakening Layer 1 identity controls.

### Cross-layer handoff

A governed cross-layer handoff now writes bounded provider-level refresh requests:

- **8 Evidence-backed providers → Layer 3 source-pattern interpretation queue**;
- **7 source-seed gaps → Layer 4/provider-source-resolution queue**.

Layer 3 requests are intentionally recorded as `blocked` with `blocked_pending_dedicated_source_pattern_layer3_profile_benchmark`. The existing production Layer 3 profile is benchmarked only for Course fact tasks; A11 does not silently add a new task class to that accepted profile.

Required Layer 3 contract:
1. dedicated source-pattern interpretation task/profile;
2. same first-party host constraint from retained Layer 2 Evidence;
3. no regulatory identity inference;
4. candidate discovery pattern only;
5. candidate must return to Layer 2 strict 3/3 control validation before profile promotion;
6. no canonical/Search/Publication mutation from interpretation.

Layer 4 source-resolution requests are provider-level and identify missing/malformed first-party seed data. They must resolve/verify the source rather than manufacture it.

### Runtime/security evidence

- scheduled qualification worker: `layer2-scale-qualify-scheduled-v1.0.1`;
- custom one-time nonce authentication; worker is not a browser path;
- `layer2-sync-control` remains JWT-authenticated for browser operations;
- qualification preparation, pattern dispatch/reconcile and cross-layer handoff helpers are service-only;
- anon/authenticated EXECUTE checks are false; service_role checks are true;
- post-DDL Security Advisor: INFO-only, no material new WARN/ERROR;
- post-DDL Performance Advisor: INFO-only, no material new WARN/ERROR;
- canonical mutation false;
- Search mutation false;
- Publication mutation false.

Pilot source reconciliation:
- qualification worker: `27ed598f382b49dcd4cfac9d7ec36ddfcd8a9665`;
- live qualification execution/current helper mirror: `aff905d058271d26bb47ebea6f9c1470fd5259f2`;
- permanent safety/UAT contract update: `ceaee1ca3b3f94f7c90e94d10974c90fc39c98c2`.

### Gate interpretation

A11 is **POC PASS** for:
- full Layer 1 scope visibility;
- multi-provider wave selection and deduplication;
- governed source-seed acquisition;
- Evidence retention;
- strict no-false-promotion pattern validation;
- explicit Layer 3/Layer 4 handoff.

The POC demonstrates why remaining national rollout should not become bespoke Layer 2 engineering. The next layer-specific work is a separately benchmarked Layer 3 source-pattern interpretation capability and provider-source resolution for Layer 4/L1 gaps. M2.4.2 remains ACTIVE pending its remaining acceptance/regression/documentation gates.


## A11 Layer 3 source-pattern benchmark disposition — 27 August 2026

A dedicated Layer 3 source-pattern profile was created rather than extending the already accepted Course-fact model profile. The profile remains isolated to task class `source_pattern`, is paused unless its own benchmark passes, and may only select a same-host HTTPS catalogue/discovery URL that appears exactly in retained Layer 2 Evidence links. It cannot infer Layer 1 identity or mutate canonical/Search/Publication state.

Benchmark progression:
- initial benchmark `552fc743-3aa3-45cd-859f-5c8203b93739` — FAIL; exposed output-shape mismatch plus intermittent empty completions;
- refined benchmark `fad59a7a-b03f-4946-8ac9-7e91e3ac3261` — FAIL at 3/4 live providers + 2/3 controls;
- supported-request Nemotron benchmark `579a52d5-f4c2-4995-ab42-0adc4754cef2` — FAIL at **3/4 live providers + 3/3 controls**, exact configured model, USD 0; Massey retained an intermittent empty completion;
- alternate specific free structured-output model benchmark `ba0ca2de-1034-4bdf-a9ea-82e7a6a7918d` — FAIL before inference because OpenRouter returned immediate 404 for the model endpoint in this runtime.

The acceptance threshold was **not lowered**. The dedicated source-pattern profile is now `paused=true` / `source_pattern_benchmark_blocked`. All eight A11 Layer 3 source-pattern requests remain blocked and no Layer 3 candidate has been fed back into Layer 2 qualification.

Post-change ACL/advisor regression:
- benchmark profile/evidence/record helpers: anon=false, authenticated=false, service_role=true;
- Security Advisor: INFO-only, no material new WARN/ERROR;
- Performance Advisor: INFO-only, no material new WARN/ERROR;
- canonical/Search/Publication mutation remains false.

Pilot source reconciliation for this gate includes:
- dedicated profile/benchmark migration and worker;
- blocked-state migration `20260827235900_m2_4_2_a11_source_pattern_benchmark_blocked.sql`;
- latest source-pattern benchmark worker `layer3-source-pattern-benchmark-v1.0.6`;
- permanent source-pattern safety assertions in the Layer 2 operations maturity UAT suite.

This blocker is downstream and does not prevent independent M2.4.2 closure work.

## M2.4.2 permanent recovery/reference regression — 27 August 2026

Rollback-only deployed recovery contract PASS:
- cancel-during-wave → late `layer2_run_batch_reconcile` preserves batch/item `cancelled`;
- stale in-flight batch/item → `layer2_run_batch_recover_stuck` returns both to `queued` and stamps `stale_recovery`;
- transaction rollback leaves no retained test batch/history.

TOEFL reference regression PASS:
- `ref.english_tests.code='TOEFL_IBT'` exists;
- legacy `TOEFL` reference code does not exist;
- `layer2_apply_course_candidate` maps extracted TOEFL to `TOEFL_IBT`;
- apply helper remains service-role only.

Discovery restart/idempotency PASS:
- an existing terminal UQ `current_page_not_found` Course was submitted to `layer2_discovery_context_scope`;
- returned `courses=[]`, proving terminal outcomes are excluded from immutable-profile restart acquisition.

M2.4.2 remains ACTIVE. RMIT canonical promotion, refresh-policy decision, broader UI/navigation regression, documentation/Stage B and exactly one final Stage C remain open.


## A12 contextual insight integration — targeted PASS

A12 is now implemented as a bounded, read-only contextual projection behind the existing authenticated `public.admin_read(text,jsonb)` boundary.

Provider/Course detail now exposes three generic semantic groups:
- Student outcomes / benchmarks;
- International student flow;
- Scholarships / funding.

Country-specific labels such as QILT and PRISMS are source labels rather than hard-coded blade architecture.

Live authenticated validation:
- RMIT Provider: 36 QILT outcome rows, 452 VIC PRISMS regional-context rows, 3 Provider Scholarships;
- representative RMIT Course: 36 Provider-context outcome rows, 3 governed Provider-scope Scholarships, PRISMS correctly reported as `not_mapped` rather than invented as Course-level truth;
- UQ Provider: 36 QILT rows plus regional PRISMS context.

Authority/security:
- contextual projection is stable/read-only;
- rank-0 negative PASS;
- anon execute false;
- authenticated read is rank checked;
- canonical/Search/Publication mutation is not authorised;
- post-DDL Security Advisor: 0 WARN / 0 ERROR;
- post-DDL Performance Advisor: 0 WARN / 0 ERROR.

Permanent deployed A12 UAT:
- initial two failures were test-contract corrections only: wrong same-title Course selection, then brittle copy assertion;
- final targeted desktop UAT run `33080519873` PASS at Pilot `c58cff1790e8be59b7256ce30e68aa8a1d7a1be0`.

A12 is therefore **TARGETED PASS / ACCEPTANCE INPUT**. Stage B integration is nominated separately and does not close M2.4.2.

## Refresh-policy disposition reconciliation

Current accepted Course-profile policies are intentionally split by measured evidence:
- UQ weekly Course refresh: **enabled**, next due 3 September 2026 UTC/AEST-adjusted runtime schedule;
- RMIT weekly Course refresh: **disabled** pending the frozen 212-record canonical-promotion gate;
- Federation weekly Course refresh: **disabled**, source profile remains paused/source-limited.

Do not normalise these into one blanket enable/disable decision. UQ has accepted canonical full-run evidence; RMIT does not yet have its final canonical promotion consequence; Federation remains source-limited by design.


## Stage B integration nomination — 28 August 2026

Pilot `75e77c0599a32c77e8e890de9fc2ce2ba8c10a3c` updates the M2.4 integration marker after A12 targeted PASS.

Workflow evidence:
- frontend build run `33115387890` — PASS;
- deployed Stage B workflow run `33115387818` — currently executing the broader desktop/mobile integration matrix at this checkpoint;
- do not record Stage B PASS until both desktop and mobile conclude successfully.

Independent closure work completed while Stage B runs:
- final live Security Advisor regression: 0 WARN / 0 ERROR;
- final live Performance Advisor regression for current slice: 0 WARN / 0 ERROR;
- service-only canonical apply/reconcile ACL reconfirmed;
- A12 rank/anon negative retained;
- Data Operations Admin Guide v1.2 updated with A12 + refresh-policy truth;
- Operations Runbook v1.4 published;
- Admin/PIM Design Decisions v1.18 published with A12 contextual-detail decision.

No Stage C marker has been created. RMIT 212-record canonical promotion remains open and no connector-safety bypass has been attempted.


## A13 urgent demo-readiness slice — 28 August 2026

A reported Course-filter/tablet defect was reproduced from source: the <=980px CSS explicitly forced `.m-filter-popover` to fixed viewport centre using `left:50%; top:50%; transform:translate(-50%,-50%)`. This is superseded by A13. Course filters now remain absolutely anchored below their trigger at tablet/mobile widths, retain bounded height/width and preserve coarse-pointer no-autofocus behaviour.

Layer 2 routine transparency is also improved without adding a second execution control. The normal screen now explains:
`Direct HTTP → Firecrawl → other governed fallback → Evidence + deterministic extraction`.

The Layer 2 overview read projection now returns a bounded recent provider-attempt list and one accepted meeting-ready Firecrawl proof when available. Live accepted UQ example:
- profile: `au-uq-course-catalogue`;
- URL: `https://study.uq.edu.au/study-options/programs/bachelor-arts-2000?year=2027`;
- provider: Firecrawl;
- HTTP 200;
- attempt 1;
- Evidence: `eb305cd4-577e-4ced-988b-243fc3318f6e`;
- job: `18ccf630-1f32-4055-8f86-4bed27b2b062`.

The UI links directly to the private governed Evidence drawer/Preview. A screenshot image is not implied: Firecrawl/provider output may be retained as HTML/JSON/document Evidence and screenshot Evidence remains null unless actually returned.

Pilot implementation through:
- DB/source migration `20260828081000_m2_4_2_a13_demo_visible_provider_attempts.sql`;
- routing/evidence UI `100060800eed63800abaf2b9f434c08acc300544`;
- route styling `5f3ce40c89885e8cc9d4901d057d10ca647cf0bc`;
- tablet anchoring fix `9b1e23360333ea1241af0e0f471b8e4e4fd15c61`;
- permanent A13 browser UAT added and routed subsequently.

Initial post-fix build `33153586864` PASS and deployed targeted UAT `33153586948` PASS; the dedicated A13 semantic/tablet test is the current consequential validation.


## A13 screenshot Evidence extension — 28 August 2026

Firecrawl provider configuration already requested `markdown`, `html` and `screenshot`. The prior gap was persistence: the acquisition workers retained raw/HTML Evidence but did not copy the Firecrawl-hosted screenshot into governed private Storage.

Implemented:
- `layer2-acquire-v2.8` now reads Firecrawl screenshot output, downloads PNG/JPEG/WebP immediately, creates `layer2_screenshot` Evidence and links `screenshot_evidence_id` to the provider attempt;
- `layer2-scope-discover-scheduled-v1.3.1` applies the same screenshot capture to discovery and identity-verification acquisitions;
- screenshot failure is secondary and does not fail an otherwise valid HTML acquisition;
- Evidence detail now returns a related visual artifact where the attempt contains screenshot Evidence;
- Evidence workspace renders that image through the existing private 60-second signed-access boundary as a thumbnail, with full screenshot and screenshot-Evidence drill-through;
- WebP preview support is included in the signed-access service;
- HTML/raw Evidence remains authoritative; screenshot is explicitly secondary visual Evidence.

Immediate accepted UQ proof was backfilled through a one-time nonce worker without canonical re-extraction:
- source Evidence: `eb305cd4-577e-4ced-988b-243fc3318f6e`;
- source page: `https://study.uq.edu.au/study-options/programs/bachelor-arts-2000?year=2027`;
- original attempt: `bbead59b-9e17-492a-95c3-021c049c95cf`;
- screenshot Evidence: `48733f50-959b-43fb-b495-71aa518a10e8`;
- MIME: `image/png`;
- size: 281,129 bytes;
- screenshot captured 28 August 2026;
- canonical/Search/Publication mutation false.

Post-change Security Advisor: 0 WARN / 0 ERROR.
Post-change Performance Advisor: 0 WARN / 0 ERROR.

Permanent A13 deployed UAT has been extended to require the UQ screenshot thumbnail and signed full-image action before this screenshot extension is accepted.
