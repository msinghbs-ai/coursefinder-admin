# CourseFinder Operations Runbook v1.9

**Status:** CURRENT M2.5 PILOT OPERATIONS RUNBOOK  
**Date:** 30 August 2026  
**Supersedes:** `docs/coursefinder-operations-runbook-v1.8.md`  
**Change Controls:** existing M2 controls plus `CF-CHG-20260829-046`, `CF-CHG-20260829-047` and active `CF-CHG-20260830-048`

## 1. Operating boundary

CourseFinder operates four enrichment authority layers only:

`L1 authority → L2 acquisition/extraction → L3 Evidence-aware AI → L4 human resolution`.

Search/Publication are downstream product states. No operational convenience path may bypass Layer 1 identity or Evidence governance.

## 2. Layer 1 AU/NZ regulatory operating procedure

### Routine source check

1. Open **Data Operations → Layer 1 — Regulatory**.
2. Confirm Source Health, authority name, source URL, approved domains and expected format.
3. Confirm latest expected count versus previous accepted count and the variance decision.
4. Inspect Schedule / Recheck for last result/error and next verification.
5. Run **Validate source** when manual validation is required.
6. Do not queue execution while verification is failed, blocked, stale or the source is paused.

### AU CRICOS validation

Confirm the CKAN package resolves on the approved `data.gov.au` authority, the four required CRICOS resources exist, the consolidated archive is valid, the Courses CSV exposes CRICOS Course Code, and active/expired row semantics are derived from `Expired`. Do not reintroduce a hard-coded 26,648 assertion; it is only the accepted baseline used for variance comparison.

### NZ NZQA validation

Confirm all five governed NZQA organisation-listing classes are reachable on the approved NZQA authority and stable `providerId` values are deduplicated. During M2.4.1 the live count was 411 versus accepted 409; this was within the configured PASS guardrail.

## 3. Variance handling

- `pass`: source is eligible subject to other controls.
- `warn`: investigate the observed delta. APPLY requires an explicit Platform Admin confirmation in addition to the server-side acknowledgement flag.
- `block`: do not ingest. Resolve the authority/count/format issue and revalidate.

A simulated AU fall from 26,648 to 1,000 rows produces a blocking variance and is expected to reject APPLY.

## 4. Queue, retry and resume

Only one queued/running operation per source is permitted.

For a failed or blocked run:

1. inspect Job/Evidence/reconciliation and the recorded error;
2. confirm the prior worker is terminal;
3. use **Retry / resume**;
4. verify the retry links to the previous run;
5. verify the resume cursor advances from the last completed boundary;
6. verify reconciliation counters accumulate rather than reset;
7. never bypass idempotency-key protection.

## 5. Stuck run recovery

A regular Layer 1 run is stuck only when it remains `running` and its heartbeat is older than 30 minutes.

Before recovery:

1. inspect Jobs & Runs and worker logs/Evidence;
2. establish that the prior worker is no longer executing;
3. use **Recover stuck run** as Platform Admin.

The server refuses recovery for a non-running or fresh-heartbeat run. Recovery marks the stale run failed with `stuck_recovered`; it does not erase Evidence, configuration versions or canonical history. Retry/resume may then be used as a separate governed action.

## 6. Scheduled authoritative-source verification

The Layer 1 scheduler runs at minutes 5, 20, 35 and 50 of each hour.

Scheduled verification uses a two-minute, single-use nonce and is non-destructive by default. It validates the source and records changed/unchanged/failure state. It does not silently APPLY canonical data.

If a source is paused, no scheduled verification should be dispatched. A dispatched request older than 30 minutes is automatically failed with an operator-visible schedule error.

## 7. Housekeeping

Daily at 03:17 UTC, Layer 1 housekeeping deletes only terminal queue records whose 30-day retention has expired.

Operational verification after housekeeping must confirm:

- expired transient queue entry removed as expected;
- Evidence artifact count unchanged;
- source-operation version count unchanged;
- no canonical/source-history deletion.

## 8. Evidence handling

Preserve authoritative Evidence and its lineage. Failed-attempt Evidence remains valuable operational evidence and must not be deleted merely because a later retry succeeds.

Every consequential Layer 1 investigation should be able to identify:

- governed source/profile version;
- source URL and authority domains;
- current/accepted source hash;
- Layer 1 queue run;
- downstream worker Job where applicable;
- Evidence captured by the worker;
- reconciliation result.

## 9. Layer 2 provider comparison procedure

Compare Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future governed providers using successful bounded acquisition, access success, Evidence quality, deterministic extraction, correctness, duration/retries, cost/quota and downstream unresolved rate.

Do not silently reorder production routes from trial data. Record the accepted change under Change Control.

## 10. Extraction failure procedure

If acquisition succeeds but deterministic extraction cannot establish the required fact, retain Evidence, record the failure class, use permitted provider fallback, then route unresolved Evidence through L3 and finally L4 when required. Never manufacture a value to improve completeness.

## 11. Scholarship, QILT and PRISMS operations

Scholarships use the governed Layer 2 provider/Evidence substrate. `Not discovered` is not equivalent to `none`.

QILT/PRISMS remain contextual observations at their native grain and must not be projected as false Course-level regulatory truth.

A12 operating rule:
- Provider detail may show Provider outcomes plus safely related regional/direct student-flow observations.
- Course detail may show Provider outcomes only as Provider context.
- PRISMS/student flow may be shown as direct Course/Provider data only when the governed observation is actually linked at that grain; otherwise use regional/field context or explicit `not mapped`.
- Scholarships resolve through governed scope; exclusion overrides broad inclusion.
- Every contextual item retains source family, observation period/granularity and Evidence where available.
- Context display is read-only and does not authorise canonical, Search or Publication mutation.

## 12. Layer 4 terminal handling

Layer 4 receives unresolved/conflicting/consequential cases with the complete Evidence package. Human resolution is terminal for enrichment authority. There is no Layer 5 queue.

## 13. Incident classification

Treat separately:

- authoritative source unavailable;
- source authority/domain mismatch;
- source shape/format changed;
- abnormal count variance;
- scheduled verification failure;
- stuck Layer 1 run;
- idempotency/duplicate-active-run block;
- provider credential/access/rate-limit failure;
- malformed/low-value Evidence;
- deterministic extraction defect;
- L3 ambiguity;
- canonical mapping conflict;
- stale data;
- browser/UAT harness failure.

Do not collapse these into a generic `pipeline failed` condition.

## 14. Layer 2 full-run operating procedure — M2.4.2

### Scope launch

1. Open **Data Operations → Layer 2 — Enrichment**.
2. Select Country and Country/State/University scope.
3. Review Catalogue Courses, Ready to sync, Needs discovery and active-run counts.
4. Do not resume a paused profile merely to remove a blocker. Resolve the source/identity reason first.
5. Start **Discover & sync** only when the profile is executable and quota/cost guardrails are acceptable.

### RMIT identity-verification procedure

For every selected RMIT Course URL, verify that `match_basis.detail_cricos_verified=true`.

A selected URL without detail-page CRICOS verification is a release blocker.

If multiple canonical Courses share the same title:
- retain legacy/current records independently;
- verify the current detail page against each expected CRICOS;
- accept only the CRICOS actually present;
- leave ambiguous/mismatch records unresolved;
- never reuse a current page for a legacy CRICOS only because the title matches.

Before broad apply, run a duplicate-selected-URL audit. A duplicate URL across distinct RMIT Course identities requires investigation unless each identity is independently evidenced as valid.

### Bounded continuation

Discovery workers have per-Course and per-invocation budgets and must return before the outer pg_net timeout. A successful wave records a continuation request for the remaining scoped Course IDs.

If a worker exceeds the outer request ceiling:
1. stop broad expansion;
2. inspect running provider attempts and Job state;
3. recover only genuinely stale transient work;
4. correct the continuation/runtime budget;
5. restart from terminal-outcome idempotency rather than deleting prior Evidence.

### Provider quota and economics

Before a broad vendor-backed run:
1. read current provider monthly-unit limit;
2. subtract recorded current-period usage;
3. preserve the configured stop reserve;
4. confirm remaining workload fits inside the reserve-aware entitlement;
5. distinguish vendor-unit consumption from cash cost.

A subscription provider with unrecorded subscription price is **not** a measured zero-cost provider. Record quota consumption even when per-request cash cost is configured as zero.

### Layer 2 refresh dispatcher

The Layer 2 refresh dispatcher runs four times per hour at minutes 03/18/33/48.

It reconciles running refresh requests bound to managed Layer 2 batches, dispatches queued profile-scoped Course refreshes through the managed-batch service, and fails stale orphaned refresh requests visibly.

Course-profile refresh policies follow measured profile acceptance rather than a blanket state.

Current M2.4.2 disposition:
- UQ weekly Course refresh is enabled after accepted deterministic full-run/canonical evidence;
- RMIT weekly Course refresh remains disabled until the frozen 212-record canonical-promotion gate is accepted;
- Federation weekly Course refresh remains disabled and its profile remains paused/source-limited.

Do not enable a profile simply to remove an operational warning.

### Layer 2 housekeeping

Daily 03:27 UTC housekeeping is recovery-only:
- stale provider attempts → terminal failed/recovered;
- abandoned Layer 2 Jobs → terminal failed/recovered;
- stale managed batches → existing stuck-run recovery path.

Verification must confirm zero deletion of governed Evidence, profile versions, provider-attempt history, run history and canonical history.

### Layer 2 alerts

Investigate separately:
- stale run;
- paused profile;
- blocked items;
- provider failure streak;
- provider quota reserve.

Do not treat a deliberate source-limited pause as an execution defect.

## 15. Layer 2 security checks before acceptance

Verify:
- `anon` cannot execute Layer 2 alert, housekeeping or refresh-dispatch functions;
- ordinary authenticated users cannot execute housekeeping/refresh service functions;
- alert read requires authenticated rank >=4;
- provider credentials are never returned to the browser;
- private pipeline/catalogue tables remain inaccessible except through accepted governed bridges;
- Search and Publication mutation remain false during Layer 2 discovery/extraction.


## 16. A12 contextual-insight verification

When validating Provider/Course detail:
1. confirm the source label and actual granularity;
2. confirm unavailable/not-mapped/suppressed states are not converted to zero;
3. verify Evidence/provenance where present;
4. confirm Provider/regional data is not relabelled as a Course fact;
5. confirm Scholarship scope is governed and exclusions win;
6. confirm no Search/Publication signal is created merely by reading contextual data.

## Revision history

### v1.4 — 28 August 2026
- Added A12 contextual outcomes/student-flow/Scholarship operating procedure.
- Reconciled UQ/RMIT/Federation Layer 2 refresh-policy disposition.
- Preserved service-only canonical apply and existing Layer 2 security boundaries.


## 17. A13 Firecrawl Evidence verification

For a website capture used in Layer 2 operational proof:
1. enter Layer 2 through normal primary navigation;
2. confirm the visible route `Direct HTTP → Firecrawl → governed fallback → Evidence`;
3. open the linked source/raw Evidence and confirm the expected source URL/provider attempt;
4. if screenshot Evidence exists, confirm it is linked as secondary visual Evidence;
5. verify the thumbnail renders through private access;
6. verify **View full screenshot** uses short-lived signed access and does not expose a service secret;
7. retain source/raw Evidence as authoritative and do not infer Course facts from the image.

Accepted UQ reference: source Evidence `eb305cd4-577e-4ced-988b-243fc3318f6e`; provider attempt `bbead59b-9e17-492a-95c3-021c049c95cf`; screenshot Evidence `48733f50-959b-43fb-b495-71aa518a10e8`, PNG 281,129 bytes.

## 18. RMIT canonical-promotion blocked procedure

The current exact frozen cohort is 212 records, all identity matched, zero unsafe and zero applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`.

Do not create a privileged browser/Edge/RPC bypass merely because the ChatGPT connector cannot invoke the apply-capable RPC. Until an already-authorised service/CI executor exists:
- record the gate BLOCKED with evidence;
- keep RMIT weekly refresh disabled;
- continue independent M2.4.2 UAT/security/documentation gates.

When an authorised executor becomes available, the only accepted sequence is exact frozen-set dry-run → 212/212 clean → apply identical frozen set → prove Search/Publication mutation false → then separately decide refresh enablement.


## 19. A14 telemetry verification

At every relevant release/operations review:
1. compare Layer 2 attempts by provider, success/failure, average/p95 latency, retries, request units/quota and cost;
2. compare managed-run throughput, Evidence footprint, fields resolved and Layer 3 fall-out;
3. compare Layer 3 model calls, input/output tokens, latency, validation result and cost;
4. distinguish unavailable usage from measured zero;
5. do not infer historical scraper units or AI tokens that were not returned/retained;
6. reject new scraper/model paths that silently bypass their applicable telemetry fields.

Current provider-attempt telemetry was extended prospectively in `layer2-acquire-v2.9`.


## 17. A15 international contact discovery operating procedure

### Routine first-party discovery

A15 seeds Provider contact profiles from governed AU/NZ Provider records and discovers first-party international recruitment/contact pages.

The worker:
1. starts from the governed Provider website and already-governed first-party origins/subdomains;
2. discovers operational international URLs through navigation/sitemaps;
3. prefers structured regional-manager/contact tables;
4. accepts only actionable institutional contact rows;
5. captures private HTML Evidence;
6. records contact observations and later change signals.

### Provider route

Normal contact-page acquisition uses:
`Direct HTTP → Firecrawl on governed fallback conditions`.

Direct HTTP failures such as 403/429/5xx/network limitations are retained as zero-vendor-unit attempts. Firecrawl fallback uses the existing secret/budget provider configuration and records page units and latency.

Do not bypass the provider reserve or insert scraper credentials into browser code.

### Transport URL correction

If a canonical Provider website string is syntactically malformed, A15 may normalise the transport URL in its private contact-discovery profile so acquisition can proceed.

This is not authority to correct `catalogue.providers.website`. Record the Layer 1/source correction separately.

### Quality handling

A row is actionable when it has:
- institutional work email; or
- public work phone; or
- a named person plus a territory/market assignment.

Generic “international team” fragments with no usable contact method/territory are rejected.

Initial discovery is not an alert storm. Operator-facing watch alerts are for subsequent meaningful title, territory, contact, removal or restoration changes.

### Zero-contact result

`succeeded + 0 contacts` means acquisition completed but deterministic contact extraction found no row safe to expose. Preserve the result; do not manufacture a contact or automatically invoke AI to invent one.

### Licensed enrichment

The Apollo adapter is optional and server-side only.

If `APOLLO_API_KEY` is absent, record the configuration blocker and continue first-party rollout. Never enable personal email/phone reveal merely to clear the blocker.

### Acceptance checks

Before A15 acceptance:
- full governed cohort attempted/reconciled;
- source-limited and zero-contact outcomes distinguishable;
- private table access remains blocked;
- Provider blade shows first-party precedence, source, Evidence and freshness;
- no personal-email/phone reveal in licensed adapter;
- Security/Performance Advisors have no new unexplained WARN/ERROR;
- targeted/integration/final browser UAT complete.


## 18. A15 post-rollout operations

Frozen baseline:
- 60/60 profiles successful;
- 0 current errors;
- 31 current contacts;
- worker v1.3.2 / Edge v15.

Do not broad-rerun the cohort simply to increase contact count.

For future refresh:
1. run only governed scheduled/profile-scoped discovery;
2. retain Direct HTTP failure and Firecrawl fallback separately;
3. review newly created change events rather than treating unchanged contacts as incidents;
4. preserve rejected history;
5. if a canonical Provider website is stale, use a transport-only correction for contact discovery and raise a separate Layer 1 source correction.

Provider consumption baseline:
- Direct HTTP: 319 attempts;
- Firecrawl: 107 page units.

Apollo remains disabled until a server-side credential is supplied through normal secret governance.


## 20. M2.4.4 cross-layer recovery and scheduling checkpoint

### Recovery ownership

Recovery is deliberately layer-specific and must not be collapsed into a generic cleanup job:

- **Layer 1 legacy regulatory jobs:** a `regulatory_sync` job is recoverable only after 45 minutes and only when no live Layer 1 run-queue heartbeat exists within 30 minutes. Expired terminal Layer 1 queue rows may be deleted; governed Evidence, source-operation versions and canonical history are retained.
- **Layer 2 provider attempts:** the stale window is the greater of twice the configured provider timeout or 300 seconds. Orphan Layer 2 Jobs use a 45-minute window. Managed batches use their execution-policy `stale_after_minutes` value, default 30 minutes, and are requeued through the existing managed-batch recovery service.
- **Layer 3 interpretation execution:** `reserved`/`calling` rows older than 20 minutes are recovered to `provider_error` with recovery provenance. Interpretation and benchmark history are retained.

Do not add a second recovery mechanism unless a reproducible uncovered state proves the need.

### Scheduler ownership and replay boundaries

- the general refresh-intelligence scheduler creates bounded L1/L2/L3 refresh requests from governed policies/Important Dates/Layer 3 expiry and deduplicates queued/running work by governed target;
- the Layer 1 scheduler owns authoritative-source verification dispatch and its 30-minute dispatched-request recovery;
- the Layer 2 scheduler owns Course-profile managed-batch dispatch/reconciliation and its 45-minute orphan-request recovery;
- Layer 3 housekeeping recovers stale executions but does not create duplicate refresh requests.

An `already_running` Layer 2 batch is bound to the existing managed batch rather than creating duplicate work.

Historical `blocked` Layer 3 requests and Layer 4 human-resolution queue items are evidence/state, not housekeeping debris.

### Layer 3 operational alerts

`security.layer3_operational_alerts_read()` is the rank-4+ governed alert surface for:
- stale interpretation execution beyond 20 minutes;
- enabled-but-paused profiles;
- enabled/unpaused profiles whose current benchmark is not PASS;
- a latest failed benchmark;
- repeated provider-error outcomes;
- a recorded execution cost above the configured profile cost ceiling.

The alert function is read-only. It does not mutate Evidence, interpretation history, canonical state, Search or Publication.

### Storage and quota handling

At the M2.4.4 checkpoint the private Evidence bucket contained 6,248 objects / 3,781,700,044 bytes. This is an observation, not a capacity threshold. No authoritative storage quota/budget threshold is configured in the governed database; do not invent one. Add a threshold only when an authorised plan/budget value is available.

### Migration-history reconciliation

The Layer 1 stale-job correction is deployed in Supabase migration history as `20260830021159_m2_4_4_layer1_legacy_stale_job_recovery`. The repository mirror created during the prior handoff is named `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery.sql` and contains the same accepted function body. Treat this as a recorded history/filename alias; do not redeploy the correction merely to force timestamp equality.

Layer 3 alert runtime migration:
`20260830071523_m2_4_4_layer3_operational_alerts`.

### M2.4.4 operational validation

Before bounded integration/final acceptance:
1. confirm all active cron jobs have latest-success status;
2. confirm no queued/running duplicate L1–L3 refresh work;
3. confirm stale recovery candidate counts are zero after housekeeping;
4. confirm Layer 3 alert conditions are understood rather than suppressed;
5. re-run Security and Performance Advisors;
6. preserve A14 provider/model telemetry and all historical failed/flaky evidence.


## M2.5 incident procedure — Layer 2 finalizer / Layer 3 source-pattern queue

### Symptom A — Layer 2 qualification backlog does not move

Check:
- `coursefinder-layer2-qualification-finalizer` cron is running;
- pending dispatch vs pending control counts;
- recent run `qualification_finalizer_selection_class`;
- `qualification_finalizer_progressed`.

CF-053 rule:
- dispatchable work must be selected ahead of pending-control-only work;
- stale/incomplete controls older than 30 minutes route to governed Layer 3 review;
- never delete controls or auto-qualify a Provider to clear a queue.

### Symptom B — historical Layer 2 parent shows failures

For VIC request `1bb1504d-7bad-42d9-b059-4adeaf9118c7`:
- 42 completed;
- 219 retained acceptance-isolation/rescheduled markers;
- 0 operational acquisition failures;
- 261/261 underlying Jobs and Firecrawl attempts succeeded.

Do not rewrite the 219 audit markers. Use the corrected operator projection.

### Symptom C — source-pattern queue grows

This can be healthy if Layer 2 is progressing faster than human Layer 3 review.

At CF-054 checkpoint:
- L2 pending deterministic dispatch: 233;
- L2 pending controls: 60;
- L3 source-pattern queue: 390 queued;
- real CF-054 source-pattern executions: 0.

Do not enable autonomous draining merely to reduce the count. The accepted contract remains one authenticated Curator+ operator-triggered request at a time and preserves the model's 10/minute / 30/day profile limits.

### Symptom D — source-pattern browser surface missing

Repository truth:
- Pilot source v2.15.17 contains the queue;
- `wrangler.jsonc` targets `coursefinder-pilot` with `./dist`;
- GitHub deployed-UAT does not deploy Cloudflare;
- Pilot historically uses Cloudflare external Git integration.

If the Worker still shows the old bundle:
1. treat deployment as stale;
2. do not modify Supabase ACLs or weaken UAT;
3. reconcile Cloudflare Worker `coursefinder-pilot` Git integration to `msinghbs-ai/Coursefinder-Pilot` / `main`;
4. confirm build output is the Vite `dist` expected by `wrangler.jsonc`;
5. confirm a deployment was produced from the current commit;
6. rerun CF-053 and CF-054 deployed browser tests unchanged.

Current environment cannot perform step 3 because no Cloudflare control-plane connector is available.

### CF-054 safe execution path

Operator
→ governed source-pattern request
→ JWT-authenticated `layer3-interpret` v9
→ same-host/exact-Evidence-link validation
→ valid candidate: Layer 2 three-Course identity control
→ unresolved candidate: Layer 4 Provider source resolution.

Never:
- call Layer 3 automatically from the Layer 2 finalizer;
- set `authority_class='first_party_qualified'` from Layer 3;
- write a canonical Course URL from the AI result;
- bulk drain the source-pattern queue;
- delete Evidence/refresh history to clear operations dashboards.
