# M2.4.5 SYSTEM METRICS

**Status:** ACTIVE METRICS LEDGER  
**Established:** 2026-09-12 AEST  
**Milestone:** M2.4.5 / CF-CHG-20260910-093  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Recording rule

For consequential ingestion, discovery, enrichment, scheduler, UAT and recovery runs, retain measurable system/tooling evidence here or in a linked milestone metrics record. Record observed values only; do not manufacture unavailable cost, latency or token data. Each snapshot should preserve the applicable repository head, runtime/worker versions, scope, job/batch/request identifiers, elapsed time where derivable, disposition counts, provider/tool routing, CI/UAT result and any cost/usage telemetry exposed by the governed runtime.

Metrics are evidence, not acceptance criteria unless a Change Control explicitly promotes a threshold to a gate.

## Standard capture fields

| Area | Capture |
|---|---|
| Repository | Pilot/Admin commit or PR head; release where applicable |
| Runtime | Supabase project, Edge Function version, worker/runtime version |
| Scope | country/state/provider/university, Layer, record count |
| Scheduler | Preview token, binding, pg_net/request IDs, continuation count |
| Discovery | attempted, selected, terminal-negative, transient/unattempted, disposition split |
| Deterministic L2 | batch ID, target count, terminal status split, elapsed time, observed throughput |
| Layer 3 | eligible count, provider/model/profile version, calls/tokens/cost/latency when exposed |
| Acquisition tooling | provider keys/routes, vendor units, request cost estimate, response latency when exposed |
| Evidence | evidence counts/types and visual/screenshot coverage where relevant |
| CI/UAT | workflow/run ID, exact tested head, result, duration where available |
| Platform | Edge deployment version/hash, Cloudflare preview/deploy state, relevant database migration IDs |
| Safety | canonical mutation, Search/Publication and generic Layer3 effects explicitly checked |

## CF-093 — UQ 382-course acceptance snapshot — 12 Sep 2026

### Repository / tooling

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Active PR #72 branch: `m245/cf093-async-discovery-20260912`.
- Exact PR head after v1.3.8 regression coverage: `9d70be7ba377b078d78644a69b13f3451bb2d7b2`.
- Exact-head Pilot Frontend Build: GitHub Actions run `34666904950` — PASS.
- Visible accepted release remains v2.15.78; PR unmerged.
- `layer2-scope-discover-scheduled`: Supabase Edge Function v26, worker `layer2-scope-discover-scheduled-v1.3.8`, deployment SHA `fad7e2e1cf7935f49cf55365aa8a3d6b3d9906b4bd78d9ae1e0ae2dca2e51204`.
- `layer2-batch-runner`: deployed Edge Function v8 during this acceptance.
- UQ qualified source-profile version: `3d70516d-95d5-49e6-b33e-e61bacfec275`.
- Security boundary retained: scheduled discovery Edge Function remains `verify_jwt=false` only under the existing one-time nonce/service-RPC contract; no browser/public privilege broadening was introduced.

### Preview / binding

- Preview token: `6fe9b130-c821-4da2-916f-ffea8126cc93`.
- Actor: `63ba56cb-48d4-4169-98c2-7c4d1f72925b`.
- Scope fingerprint: `a6a9fb25457d93de4146ebd808ac0695`.
- Catalogue scope: 382 Courses.
- Initial current-profile queueable: 6.
- Initial current-profile discovery-required: 376.
- Binding activated: `2026-09-12 01:13:22.564082Z`.
- Binding moved to `handoff_started`: `2026-09-12 02:20:20.718361Z`.
- Execution expiry: `2026-09-12 07:13:22.564082Z`.

### Discovery outcomes

First-pass v1.3.7 terminal request `5838` failed closed with 42 courses still transient/unattempted. A governed targeted retry under the same active binding used requests `5839`–`5846`; all completed under v1.3.7 and reproduced the zero-result classification defect without mutating authority.

After worker v1.3.8 deployment, exactly the remaining 42 IDs were redispatched under request `5847`, followed by continuations `5848`–`5854`.

- v1.3.8 retry set: 42 Courses.
- v1.3.8 worker invocations: 8.
- First corrected request: `5847` at `2026-09-12 02:11:57.665321Z`.
- Terminal corrected request: `5854` at `2026-09-12 02:19:42.452916Z`.
- Approximate elapsed corrected retry window: 7m 45s.
- Observed corrected retry throughput: approximately 5.4 Courses/minute. This includes ordered fallback exhaustion for zero-result records and is not a performance SLA.
- Corrected retry failures: 0.
- Remaining transient/unattempted after corrected chain: 0.

Final 376-course discovery result under the bound Preview:

| Outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 245 |
| Terminal negative | 131 |
| **Total** | **376** |

Terminal negatives are governed Evidence outcomes (`current_page_not_found`, `ambiguous`, or `identity_mismatch`) and do not manufacture a canonical URL.

### Deterministic Layer 2 handoff

- Batch: `eee74644-9b2e-45b8-b0f7-20c4e5c587d4`.
- Batch profile version: `3d70516d-95d-49e6-b33e-e61bacfec275`.
- Requested UQ scope: 382.
- Deterministic L2 target count: 251 = 6 previously queueable + 245 newly CRICOS-verified selections.
- Terminal-negative courses excluded from deterministic L2 target: 131.
- Handoff dispatch pg_net request: `5855`.
- Batch created: `2026-09-12 02:20:20.718361Z`.
- Batch last updated/terminalised: `2026-09-12 02:33:58.420717Z`.
- Approximate elapsed batch window: 13m 38s.
- Observed processing throughput: approximately 18.4 target items/minute. This is an observed acceptance-run figure, not a contractual capacity threshold.

Terminal batch disposition:

| L2 item status | Count |
|---|---:|
| `resolved_l2` | 248 |
| `layer3_required` | 3 |
| **Total** | **251** |

Batch status is `partial` because 3 items require the separately governed Layer 3 path. No generic scheduler Layer 3 invocation is authorised by this status.

### Tooling / telemetry observations

- Ordered provider-route execution remained in force.
- Direct HTTP was observed as the successful acquisition provider for sampled deterministic L2 items.
- Runtime result payloads expose per-item response/extraction timing and provider-attempt metrics; future comparative snapshots should aggregate these rather than rely only on batch wall-clock duration.
- Provider runtime supports `vendor_units`, `vendor_units_basis` and `estimated_request_cost_usd`; record these when populated. Do not infer cost where provider configuration reports no value.
- Layer 3 model/token/cost statistics are not recorded for this scheduler run because generic Layer 3 was not invoked.
- Search/Publication effects remain outside this acceptance path and must be checked separately before acceptance closure.

## Comparative baseline use

Use the UQ snapshot as the first large-university baseline for the forthcoming RMIT 500-course run and subsequent qualification wave. Compare at minimum:

- discovery-required percentage;
- selected vs terminal-negative percentage;
- discovery invocations and elapsed time;
- deterministic L2 target and terminal split;
- L2 elapsed time and items/minute;
- provider-route mix and fallback frequency;
- response/extraction latency distribution when queryable;
- vendor units / estimated acquisition cost when populated;
- Layer3-required percentage;
- Evidence volume/screenshot coverage;
- CI/UAT/tool versions tied to the run.

Do not compare runs as equivalent unless source profile, provider route, worker version and scope characteristics are recorded.