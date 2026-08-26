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