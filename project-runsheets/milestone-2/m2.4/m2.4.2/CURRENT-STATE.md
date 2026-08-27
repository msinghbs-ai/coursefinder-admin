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
