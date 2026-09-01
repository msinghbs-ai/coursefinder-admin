# CF-CHG-20260901-053 — M2.5 Layer 2 Qualification Finalizer Fairness & Historical Wave Classification

**Status:** IMPLEMENTED / RUNTIME PASS — DEPLOYED BROWSER ACCEPTANCE BLOCKED BY PILOT CLOUDFLARE GIT DEPLOYMENT DRIFT  
**Category:** 40-layer2-enrichment  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Prior corrective gate:** `CF-CHG-20260901-052` IMPLEMENTED / TARGETED PASS  
**Closed baseline preserved:** `CF-CHG-20260830-048` remains CLOSED/PASS

## Origin

After CF-052 restored Layer 2 run observability, live VIC reconciliation exposed two operational defects which were previously obscured:

1. the historical VIC parent reports 219 failed wave items even though all 261 underlying Firecrawl acquisitions and Jobs succeeded; those 219 terminal wave states were created by final-acceptance isolation/reschedule handling;
2. the deterministic qualification finalizer is starved by two oldest runs waiting on already-dispatched pattern controls, preventing later runs containing 293 undispatched Provider-pattern candidates from progressing.

This change is an M2.5 operational correction. It does not reopen M2.4 and does not weaken Layer 1 identity, Layer 2 Evidence/identity controls, Layer 3 role/profile gates, Layer 4 authority, Search or Publication boundaries.

## Live evidence

Pilot project: `fxcwkweaxjtknorudmwp`.

### VIC production lineage

Parent request:
`1bb1504d-7bad-42d9-b059-4adeaf9118c7`

Stored historical counters:
- total: 261;
- completed: 42;
- failed: 219;
- missing URL: 6,562.

Underlying execution truth:
- 261/261 `pipeline.jobs` = `succeeded`;
- 261/261 Firecrawl attempts = `succeeded`;
- 261/261 acquisition responses = HTTP 200;
- 261/261 extraction states = `normalised`;
- 261 run-item outcomes = `layer3_required` after deterministic Layer 2 extraction;
- 199 generic Layer 3 handoffs;
- 45 multiple-equal-rank fee candidates;
- 17 low-confidence international-fee candidates.

The 219 historical wave `failed` rows are therefore not acquisition failures:
- 65 belonged to acceptance-isolated cancelled batch `accd42a2-f096-452b-a084-dc609bd45030`;
- 154 belonged to replacement acceptance-isolated batch `bc25dfed-495b-49dc-a896-03f08fd33745`;
- the final 42 were completed in batch `39ecbae1-013b-4c95-8d26-dd04b3db5ecc`.

The stored audit history must be preserved. Operator projections should distinguish recorded terminal failure markers from genuine operational acquisition failures/rescheduled work.

### Missing Course URL population

All 6,562 missing-URL rows carry:
`course_url_requires_discovery`.

They span 337 Providers. All 337 already have a Layer 1 Provider website.

Therefore this is a Course-page discovery backlog, not missing Provider-homepage data.

Examples:
- Monash: 581 missing Course URLs, only three sampled discovery controls;
- University of Melbourne: 435 missing, zero Course discovery candidates;
- Swinburne: 410 missing, only three sampled controls;
- RMIT: 499 discovery candidate Courses and 261 selected/verified first-party Course URLs, proving the discovery path can work at Provider scale;
- Federation University: 190 candidate Courses / 10 selected.

### Qualification finalizer starvation

Current backlog:
- 46 qualification runs total;
- 37 completed/partial runs not finalised;
- 293 Providers awaiting deterministic pattern dispatch;
- 2 Providers waiting on already-dispatched pattern controls.

The finalizer cron is healthy and runs every five minutes, but `security.layer2_qualification_finalizer_tick_impl()` selects only the two oldest unfinished runs.

Those two oldest runs are:
- `94557562-e292-4ed9-bdf3-8b2dcc370c6b`;
- `c65e67a6-3b2e-47e3-832a-57118fe5cf5f`.

A bounded manual finalizer proof produced:
- processed runs: 2;
- pattern dispatches: 0;
- reconciliations: 0;
- new cross-layer handoffs: 0;
- finalization complete: false for both;
- global backlog before/after remained exactly 293 pending dispatch / 2 pending control / 37 unfinalized runs.

Thus the current ordering repeatedly touches two non-progressing control waits and starves later dispatchable work.

## Corrective outcome

Implement bounded finalizer fairness:
- prioritise runs containing undispatched `source_pattern_candidate` Providers;
- do not allow already-dispatched control waits to monopolise the run limit;
- preserve policy-bounded Provider dispatch limits and Firecrawl budget controls;
- retain non-progressing controls for later reconciliation rather than deleting or auto-approving them;
- add scheduler/projection observability sufficient to distinguish pending dispatch, pending control and cross-layer queue state.

Correct historical operator semantics:
- preserve the request's recorded `failed_items=219` audit value;
- expose acceptance-isolation/rescheduled terminal rows separately from genuine operational failure;
- never rewrite retained Jobs, Evidence, wave history or canonical facts solely to improve presentation.

## Explicit non-goals

- no autonomous Layer 3 AI execution is introduced by this change;
- no bypass of the benchmark-passed Layer 3 profile gate;
- no Layer 4 automatic resolution;
- no bulk unbounded Firecrawl launch;
- no direct write of discovered URLs to canonical Course URL without existing governed identity/evidence admission;
- no M2.4 acceptance reopening.

## UAT required

1. source contract proves dispatchable qualification runs are prioritised ahead of pending-control-only runs;
2. one bounded live finalizer tick after deployment decreases pending-dispatch backlog or produces explicit bounded dispatch requests;
3. two stuck control Providers remain retained and unresolved unless their normal control path completes;
4. operator projection distinguishes historical acceptance-isolation/reschedule markers from operational acquisition failure;
5. existing CF-052 terminal Job/Evidence visibility remains intact;
6. Security Advisor and Performance Advisor remain 0 WARN / 0 ERROR.

## Rollback

Restore the prior finalizer/projection function definitions. No data deletion or canonical rollback is expected because the correction changes scheduling fairness/read semantics, not retained Evidence or canonical Course facts.


## Implementation & validation update — 1 September 2026

Implementation repository: `msinghbs-ai/Coursefinder-Pilot`.

Applied corrections:
- `supabase/migrations/20260901083800_m2_5_layer2_finalizer_fairness.sql` — finalizer prioritises `pending_dispatch` work and records progress/selection class;
- `supabase/migrations/20260901085000_m2_5_layer2_stale_pattern_control_handoff.sql` — incomplete pattern controls older than 30 minutes route to governed Layer 3 source-pattern review instead of remaining permanent scheduler blockers;
- Layer 2 parent projection preserves the stored 219 terminal audit markers while exposing acceptance-isolation/rescheduled rows separately from operational failures;
- source Admin release advanced through v2.15.16 and later v2.15.17 under the adjacent CF-054 operator-path correction.

Runtime proof:
- pending deterministic pattern dispatch decreased from **293** at discovery to **233** by the later CF-054 checkpoint under the unchanged five-minute bounded finalizer cron;
- the normal cron independently selected `pending_dispatch` runs and recorded `progressed=true`;
- UTas stale control (2/3 terminal) and ETEA stale control (0/3 terminal) were retained but routed to `layer3_required`, one governed Layer 3 source-pattern request each;
- no Provider was auto-qualified and no canonical Course URL/Search/Publication authority was granted;
- VIC request `1bb1504d-7bad-42d9-b059-4adeaf9118c7` reconciles to 42 completed + 219 acceptance-isolation/rescheduled + **0 operational acquisition failures**, while retaining the original 219 audit markers;
- 6,562 missing URL rows remain a Course-page discovery backlog across 337 Providers, all of which already have Provider websites.

Advisor state after the subsequent CF-054 hardening remains:
- Security: 146 INFO / **0 WARN / 0 ERROR**;
- Performance: 173 INFO / **0 WARN / 0 ERROR**.

### Deployed browser blocker

CF-053 deployed browser gate:
- workflow run `33488961340`;
- original job `99795659209` — FAIL;
- rerun job `99796810066` — FAIL.

The source-contract test passed, but the deployed Worker did not contain the new `data-l2-wave-classification` element. Current `main` does contain it.

Repository reconciliation proves:
- `Coursefinder-Pilot/wrangler.jsonc` still targets Worker `coursefinder-pilot`;
- static assets remain `./dist` with SPA fallback;
- the deployed UAT workflow does **not** deploy Cloudflare; it only waits for the external Worker deployment;
- historical project records identify Cloudflare external Git deployment as the Pilot deployment owner.

Therefore CF-053 is not marked deployed-browser PASS. Application/runtime correction is implemented and proven; browser acceptance is blocked by external Cloudflare Git deployment drift, tracked in M2.5 follow-ups.

## Current status decision

**IMPLEMENTED / RUNTIME PASS — DEPLOYED BROWSER ACCEPTANCE BLOCKED.**

M2.4 remains CLOSED/PASS. CF-053 remains an M2.5 Pilot operations correction and does not alter the frozen M2.4 acceptance baseline.
